Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:43412 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731067AbeKVN3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 08:29:49 -0500
From: "Zhang, Ning A" <ning.a.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Zhang, Ning A" <ning.a.zhang@intel.com>
Subject: is it possible to use single IOCTL to setup media pipeline?
Date: Thu, 22 Nov 2018 02:51:48 +0000
Message-ID: <1542855107.1288.32.camel@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <8109FB97C92CEE48A1522AFB4B7F1345@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGVsbG8gZXZlcnlvbmUNCg0Kd2hlbiB3ZSBuZWVkIHRvIHNldHVwIG1lZGlhIHBpcGVsaW5lLCBl
ZywgZm9yIGNhbWVyYSBjYXB0dXJlLCBtZWRpYS1jdGwgDQpuZWVkcyB0byBiZSBjYWxsZWQgbXVs
dGlwbGUgdGltZSB0byBzZXR1cCBtZWRpYSBsaW5rIGFuZCBzdWJkZXYNCmZvcm1hdHMsIG9yIHNp
bWlsYXIgY29kZSBpbiBhIHNpbmdsZSBhcHBsaWNhdGlvbi4gdGhpcyB3aWxsIHVzZQ0KbXVsdGlw
bGUgSU9DVExzIG9uICIvZGV2L21lZGlhWCIgYW5kICIvZGV2L3Y0bDItc3ViZGV2WSIuDQoNCnRv
IHNldHVwIG1lZGlhIHBpcGVsaW5lIGluIHVzZXJzcGFjZSByZXF1aXJlcyB0byBmdWxseSB1bmRl
cnN0YW5kaW5nDQp0aGUgdG9wb2xvZ3kgb2YgdGhlIG1lZGlhIHN0YWNrLiBidXQgdGhlIGZhY3Qg
aXMgb25seSBtZWRpYSBkcml2ZXINCmRldmVsb3BlciBjb3VsZCBrbm93IGhvdyB0byBzZXR1cCBt
ZWRpYSBwaXBlbGluZS4gZWFjaCB0aW1lIGRyaXZlcg0KdXBkYXRlcywgdGhpcyB3b3VsZCBicmVh
ayB1c2Vyc3BhY2UgYXBwbGljYXRpb24gaWYgYXBwbGljYXRpb24NCmVuZ2luZWVycyBkb24ndCBr
bm93IHRoaXMgY2hhbmdlLiBJbiB0aGlzIGNhc2UsIGlmIGEgSU9DVEwgaXMgZGVzaWduZWQNCnRv
IHNldHVwIG1lZGlhIHBpcGVsaW5lLCBubyBuZWVkIHRvIHVwZGF0ZSBhcHBsaWNhdGlvbnMsIGFm
dGVyIGRyaXZlcg0KaXMgdXBkYXRlZC4NCg0KdGhpcyB3aWxsIG5vdCBvbmx5IGJlbmVmaXQgZm9y
IGRlc2lnbiBhIHNpbmdsZSBJT0NUTCwgdGhpcyBhbHNvIGhlbHBzDQp0byBoaWRlIHRoZSBkZXRh
aWwgb2YgbWVkaWEgcGlwZWxpbmUsIGJ5IGxvYWQgYSBiaW5hcnkgYmxvYiB3aGljaCBob2xkcw0K
aW5mb3JtYXRpb24gYWJvdXQgaG93IHRvIHNldHVwIHBpcGVsaW5lLCBvciBoaWRlIGl0IGluIGJv
b3Rsb2FkZXIvQUNQSQ0KdGFibGVzL2RldmljZSB0cmVlLCBldGMuDQoNCmFub3RoZXIgYmVuZWZp
dCBpcyBzYXZlIHRpbWUgZm9yIHNldHVwIG1lZGlhIHBpcGVsaW5lLCBpZiB0aGVyZSBpcyBhDQpQ
S0kgbGlrZSAidGltZSBmb3Igb3BlbiBjYW1lcmEiLiBhcyBteSB0ZXN0LCB0aGlzIHdpbGwgc2F2
ZXMgaHVuZHJlZHMNCm9mIG1pbGxpc2Vjb25kcy4NCg0KaXMgdGhpcyBhY2NlcHRhYmxlPw0KDQpC
Ui4NCk5pbmcu
