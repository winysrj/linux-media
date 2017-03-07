Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:32734 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751258AbdCGH6j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Mar 2017 02:58:39 -0500
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net"
        <linux1394-devel@lists.sourceforge.net>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Subject: RE: [PATCH 11/29] drivers, media: convert cx88_core.refcount from
 atomic_t to refcount_t
Date: Tue, 7 Mar 2017 07:52:09 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C556E2@IRSMSX102.ger.corp.intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-12-git-send-email-elena.reshetova@intel.com>
 <c6987419-f708-9923-0f9f-87b715600045@cogentembedded.com>
In-Reply-To: <c6987419-f708-9923-0f9f-87b715600045@cogentembedded.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PiBIZWxsby4NCj4gDQo+IE9uIDAzLzA2LzIwMTcgMDU6MjAgUE0sIEVsZW5hIFJlc2hldG92YSB3
cm90ZToNCj4gDQo+ID4gcmVmY291bnRfdCB0eXBlIGFuZCBjb3JyZXNwb25kaW5nIEFQSSBzaG91
bGQgYmUNCj4gPiB1c2VkIGluc3RlYWQgb2YgYXRvbWljX3Qgd2hlbiB0aGUgdmFyaWFibGUgaXMg
dXNlZCBhcw0KPiA+IGEgcmVmZXJlbmNlIGNvdW50ZXIuIFRoaXMgYWxsb3dzIHRvIGF2b2lkIGFj
Y2lkZW50YWwNCj4gPiByZWZjb3VudGVyIG92ZXJmbG93cyB0aGF0IG1pZ2h0IGxlYWQgdG8gdXNl
LWFmdGVyLWZyZWUNCj4gPiBzaXR1YXRpb25zLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogRWxl
bmEgUmVzaGV0b3ZhIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEhhbnMgTGlsamVzdHJhbmQgPGlzaGthbWllbEBnbWFpbC5jb20+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogS2VlcyBDb29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+DQo+ID4gU2lnbmVkLW9mZi1i
eTogRGF2aWQgV2luZHNvciA8ZHdpbmRzb3JAZ21haWwuY29tPg0KPiBbLi4uXQ0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL21lZGlhL3BjaS9jeDg4L2N4ODguaCBiL2RyaXZlcnMvbWVkaWEvcGNp
L2N4ODgvY3g4OC5oDQo+ID4gaW5kZXggMTE1NDE0Yy4uMTZjMTMxMyAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL21lZGlhL3BjaS9jeDg4L2N4ODguaA0KPiA+ICsrKyBiL2RyaXZlcnMvbWVkaWEv
cGNpL2N4ODgvY3g4OC5oDQo+ID4gQEAgLTI0LDYgKzI0LDcgQEANCj4gPiAgI2luY2x1ZGUgPGxp
bnV4L2kyYy1hbGdvLWJpdC5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvdmlkZW9kZXYyLmg+DQo+
ID4gICNpbmNsdWRlIDxsaW51eC9rZGV2X3QuaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L3JlZmNv
dW50Lmg+DQo+ID4NCj4gPiAgI2luY2x1ZGUgPG1lZGlhL3Y0bDItZGV2aWNlLmg+DQo+ID4gICNp
bmNsdWRlIDxtZWRpYS92NGwyLWZoLmg+DQo+ID4gQEAgLTMzOSw3ICszNDAsNyBAQCBzdHJ1Y3Qg
Y3g4ODAyX2RldjsNCj4gPg0KPiA+ICBzdHJ1Y3QgY3g4OF9jb3JlIHsNCj4gPiAgCXN0cnVjdCBs
aXN0X2hlYWQgICAgICAgICAgIGRldmxpc3Q7DQo+ID4gLQlhdG9taWNfdCAgICAgICAgICAgICAg
ICAgICByZWZjb3VudDsNCj4gPiArCXJlZmNvdW50X3QgICAgICAgICAgICAgICAgICAgcmVmY291
bnQ7DQo+IA0KPiAgICAgQ291bGQgeW91IHBsZWFzZSBrZWVwIHRoZSBuYW1lIGFsaWduZWQgd2l0
aCBhYm92ZSBhbmQgYmVsb3c/DQoNCllvdSBtZWFuICJub3QgYWxpZ25lZCIgdG8gZGV2bGlzdCwg
YnV0IHdpdGggYSBzaGlmdCBsaWtlIGl0IHdhcyBiZWZvcmU/IA0KU3VyZSwgd2lsbCBmaXguIElz
IHRoZSBwYXRjaCBvayBvdGhlcndpc2U/DQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0KDQo+IA0K
PiA+DQo+ID4gIAkvKiBib2FyZCBuYW1lICovDQo+ID4gIAlpbnQgICAgICAgICAgICAgICAgICAg
ICAgICBucjsNCj4gPg0KPiANCj4gTUJSLCBTZXJnZWkNCg0K
