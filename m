Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:50799 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935343AbeAORH5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 12:07:57 -0500
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Tomasz Figa <tfiga@chromium.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH 2/2] media: intel-ipu3: cio2: fix for wrong vb2buf state
 warnings
Date: Mon, 15 Jan 2018 17:07:57 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AEB61AE@FMSMSX151.amr.corp.intel.com>
References: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
 <1515034637-3517-2-git-send-email-yong.zhi@intel.com>
 <CAAFQd5AaOSQ_wcA_w5vBufVk5FfLPe6x9BnS=hcShv_asf3Cyw@mail.gmail.com>
In-Reply-To: <CAAFQd5AaOSQ_wcA_w5vBufVk5FfLPe6x9BnS=hcShv_asf3Cyw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGksIFRvbWFzeiwNCg0KVGhhbmtzIGZvciByZXZpZXdpbmcgdGhlIHBhdGNoLg0KDQo+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFRvbWFzeiBGaWdhIFttYWlsdG86dGZpZ2FA
Y2hyb21pdW0ub3JnXQ0KPiBTZW50OiBGcmlkYXksIEphbnVhcnkgMTIsIDIwMTggMTI6MTkgQU0N
Cj4gVG86IFpoaSwgWW9uZyA8eW9uZy56aGlAaW50ZWwuY29tPg0KPiBDYzogTGludXggTWVkaWEg
TWFpbGluZyBMaXN0IDxsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmc+OyBTYWthcmkgQWlsdXMN
Cj4gPHNha2FyaS5haWx1c0BsaW51eC5pbnRlbC5jb20+OyBNYW5pLCBSYWptb2hhbg0KPiA8cmFq
bW9oYW4ubWFuaUBpbnRlbC5jb20+OyBDYW8sIEJpbmdidSA8YmluZ2J1LmNhb0BpbnRlbC5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMi8yXSBtZWRpYTogaW50ZWwtaXB1MzogY2lvMjogZml4
IGZvciB3cm9uZyB2YjJidWYgc3RhdGUNCj4gd2FybmluZ3MNCj4gDQo+IE9uIFRodSwgSmFuIDQs
IDIwMTggYXQgMTE6NTcgQU0sIFlvbmcgWmhpIDx5b25nLnpoaUBpbnRlbC5jb20+IHdyb3RlOg0K
PiA+IGNpbzIgZHJpdmVyIHNob3VsZCByZWxlYXNlIGJ1ZmZlciB3aXRoIFFVRVVFRCBzdGF0ZSB3
aGVuIHN0YXJ0X3N0cmVhbQ0KPiA+IG9wIGZhaWxlZCwgd3JvbmcgYnVmZmVyIHN0YXRlIHdpbGwg
Y2F1c2UgdmIyIGNvcmUgdGhyb3cgYSB3YXJuaW5nLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTog
WW9uZyBaaGkgPHlvbmcuemhpQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBDYW8gQmlu
ZyBCdSA8YmluZ2J1LmNhb0BpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbWVkaWEv
cGNpL2ludGVsL2lwdTMvaXB1My1jaW8yLmMgfCA5ICsrKysrLS0tLQ0KPiA+ICAxIGZpbGUgY2hh
bmdlZCwgNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWVkaWEvcGNpL2ludGVsL2lwdTMvaXB1My1jaW8yLmMNCj4gPiBiL2RyaXZl
cnMvbWVkaWEvcGNpL2ludGVsL2lwdTMvaXB1My1jaW8yLmMNCj4gPiBpbmRleCA5NDlmNDNkMjA2
YWQuLjEwNmQwNDMwNjM3MiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL21lZGlhL3BjaS9pbnRl
bC9pcHUzL2lwdTMtY2lvMi5jDQo+ID4gKysrIGIvZHJpdmVycy9tZWRpYS9wY2kvaW50ZWwvaXB1
My9pcHUzLWNpbzIuYw0KPiA+IEBAIC03ODUsNyArNzg1LDggQEAgc3RhdGljIGlycXJldHVybl90
IGNpbzJfaXJxKGludCBpcnEsIHZvaWQNCj4gPiAqY2lvMl9wdHIpDQo+ID4NCj4gPiAgLyoqKioq
KioqKioqKioqKiogVmlkZW9idWYyIGludGVyZmFjZSAqKioqKioqKioqKioqKioqLw0KPiA+DQo+
ID4gLXN0YXRpYyB2b2lkIGNpbzJfdmIyX3JldHVybl9hbGxfYnVmZmVycyhzdHJ1Y3QgY2lvMl9x
dWV1ZSAqcSkNCj4gPiArc3RhdGljIHZvaWQgY2lvMl92YjJfcmV0dXJuX2FsbF9idWZmZXJzKHN0
cnVjdCBjaW8yX3F1ZXVlICpxLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBlbnVtIHZiMl9idWZmZXJfc3RhdGUgc3RhdGUpDQo+ID4gIHsNCj4gPiAgICAgICAg
IHVuc2lnbmVkIGludCBpOw0KPiA+DQo+ID4gQEAgLTc5Myw3ICs3OTQsNyBAQCBzdGF0aWMgdm9p
ZCBjaW8yX3ZiMl9yZXR1cm5fYWxsX2J1ZmZlcnMoc3RydWN0DQo+IGNpbzJfcXVldWUgKnEpDQo+
ID4gICAgICAgICAgICAgICAgIGlmIChxLT5idWZzW2ldKSB7DQo+ID4gICAgICAgICAgICAgICAg
ICAgICAgICAgYXRvbWljX2RlYygmcS0+YnVmc19xdWV1ZWQpOw0KPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgIHZiMl9idWZmZXJfZG9uZSgmcS0+YnVmc1tpXS0+dmJiLnZiMl9idWYsDQo+ID4g
LSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFZCMl9CVUZfU1RBVEVfRVJS
T1IpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdGF0ZSk7
DQo+IA0KPiBuaXQ6IERvZXMgaXQgcmVhbGx5IGV4Y2VlZCA4MCBjaGFyYWN0ZXJzIGFmdGVyIGZv
bGRpbmcgaW50byBwcmV2aW91cyBsaW5lPw0KPiANCg0KVGhhbmtzIGZvciBjYXRjaGluZyB0aGlz
LCBzZWVtcyB0aGlzIHBhdGNoIHdhcyBtZXJnZWQsIG1heSBJIGZpeCBpdCBpbiBmdXR1cmUgcGF0
Y2g/DQoNCj4gV2l0aCB0aGUgbml0IGZpeGVkOg0KPiBSZXZpZXdlZC1ieTogVG9tYXN6IEZpZ2Eg
PHRmaWdhQGNocm9taXVtLm9yZz4NCj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gVG9tYXN6DQo=
