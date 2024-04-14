package com.example.demo;

import com.example.demo.translation.T;

public class GreetService {

    public String greet(String name) {
        if (name == null || name.isEmpty()) {
            return T.HELLO_ANON+"";
        } else {
            return T.HELLO + " " + name;
        }
    }
}
