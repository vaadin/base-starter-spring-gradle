package com.example.demo.translation;

public class TString {
    public String fieldName;
    public String value;

    public TString(String fieldName, String value) {
        this.fieldName = fieldName;
        this.value = value;
    }
    @Override
    public String toString() {
        try{
            return T.t(this);
        } catch (Exception e) {
            return value;
        }
    }
}
