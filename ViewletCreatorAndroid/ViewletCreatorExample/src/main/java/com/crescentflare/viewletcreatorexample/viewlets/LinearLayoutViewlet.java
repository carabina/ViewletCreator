package com.crescentflare.viewletcreatorexample.viewlets;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.crescentflare.viewletcreator.ViewletCreator;
import com.crescentflare.viewletcreator.binder.ViewletBinder;
import com.crescentflare.viewletcreator.utility.ViewletMapUtil;

import java.util.List;
import java.util.Map;

/**
 * Container viewlet: linear layout
 * Creation of a linear layout through parsed JSON
 */
public class LinearLayoutViewlet implements ViewletCreator.Viewlet
{
    @Override
    public View create(Context context)
    {
        return new LinearLayout(context);
    }

    @Override
    public void update(View view, Map<String, Object> attributes, ViewGroup parent, ViewletBinder binder)
    {
        if (view instanceof LinearLayout)
        {
            // Add or recycle children
            LinearLayout container = (LinearLayout)view;
            int childCount = container.getChildCount();
            int currentViewChild = 0;
            List<Object> children = ViewletMapUtil.optionalObjectList(attributes, "children");
            for (int i = 0; i < children.size(); i++)
            {
                Map<String, Object> child = ViewletMapUtil.asStringObjectMap(children.get(i));
                if (currentViewChild < childCount && ViewletCreator.canRecycle(container.getChildAt(currentViewChild), child))
                {
                    ViewletCreator.inflateOn(container.getChildAt(currentViewChild), child, container, binder);
                    ViewViewlet.applyLayoutAttributes(container.getChildAt(currentViewChild), child);
                    if (binder != null)
                    {
                        String refId = ViewletMapUtil.optionalString(child, "refId", null);
                        if (refId != null)
                        {
                            binder.onBind(refId, container.getChildAt(currentViewChild));
                        }
                    }
                    currentViewChild++;
                }
                else
                {
                    if (currentViewChild < childCount)
                    {
                        container.removeViewAt(currentViewChild);
                        childCount--;
                    }
                    View createdView = ViewletCreator.create(view.getContext(), child, container);
                    if (createdView != null)
                    {
                        container.addView(createdView, currentViewChild);
                        ViewViewlet.applyLayoutAttributes(createdView, child);
                        if (binder != null)
                        {
                            String refId = ViewletMapUtil.optionalString(child, "refId", null);
                            if (refId != null)
                            {
                                binder.onBind(refId, createdView);
                            }
                        }
                        currentViewChild++;
                        childCount++;
                    }
                }
            }
            for (int i = childCount - 1; i >= currentViewChild; i--)
            {
                container.removeViewAt(i);
            }

            // Standard view attributes
            ViewViewlet.applyDefaultAttributes(view, attributes);
        }
    }

    @Override
    public boolean canRecycle(View view, Map<String, Object> attributes)
    {
        return view instanceof LinearLayout;
    }
}
