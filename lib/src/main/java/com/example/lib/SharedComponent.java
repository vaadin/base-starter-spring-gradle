package com.example.lib;

import com.vaadin.flow.component.html.Span;
import com.vaadin.flow.component.dependency.NpmPackage;

@NpmPackage(value = "@vaadin/icon", version = "25.0.7")
public class SharedComponent extends Span {
    public SharedComponent() {
        super("From lib v1");
    }
}
