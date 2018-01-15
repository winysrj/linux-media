Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63218 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935071AbeAORFi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 12:05:38 -0500
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Tomasz Figa <tfiga@chromium.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH 1/2] media: intel-ipu3: cio2: fix a crash with
 out-of-bounds access
Date: Mon, 15 Jan 2018 17:05:36 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AEB6195@FMSMSX151.amr.corp.intel.com>
References: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
 <CAAFQd5AO4n4kge1dijXLK-Ckudd5wJnuRnNMef+H4W00G2mpwQ@mail.gmail.com>
In-Reply-To: <CAAFQd5AO4n4kge1dijXLK-Ckudd5wJnuRnNMef+H4W00G2mpwQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGksIFRvbWFzeiwNCg0KVGhhbmtzIGZvciB0aGUgcGF0Y2ggcmV2aWV3Lg0KDQo+IC0tLS0tT3Jp
Z2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFRvbWFzeiBGaWdhIFttYWlsdG86dGZpZ2FAY2hy
b21pdW0ub3JnXQ0KPiBTZW50OiBGcmlkYXksIEphbnVhcnkgMTIsIDIwMTggMTI6MTcgQU0NCj4g
VG86IFpoaSwgWW9uZyA8eW9uZy56aGlAaW50ZWwuY29tPg0KPiBDYzogTGludXggTWVkaWEgTWFp
bGluZyBMaXN0IDxsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmc+OyBTYWthcmkgQWlsdXMNCj4g
PHNha2FyaS5haWx1c0BsaW51eC5pbnRlbC5jb20+OyBNYW5pLCBSYWptb2hhbg0KPiA8cmFqbW9o
YW4ubWFuaUBpbnRlbC5jb20+OyBDYW8sIEJpbmdidSA8YmluZ2J1LmNhb0BpbnRlbC5jb20+DQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8yXSBtZWRpYTogaW50ZWwtaXB1MzogY2lvMjogZml4IGEg
Y3Jhc2ggd2l0aCBvdXQtb2YtDQo+IGJvdW5kcyBhY2Nlc3MNCj4gDQo+IE9uIFRodSwgSmFuIDQs
IDIwMTggYXQgMTE6NTcgQU0sIFlvbmcgWmhpIDx5b25nLnpoaUBpbnRlbC5jb20+IHdyb3RlOg0K
PiA+IFdoZW4gZG1hYnVmIGlzIHVzZWQgZm9yIEJMT0IgdHlwZSBmcmFtZSwgdGhlIGZyYW1lIGJ1
ZmZlcnMgYWxsb2NhdGVkDQo+ID4gYnkgZ3JhbGxvYyB3aWxsIGhvbGQgbW9yZSBwYWdlcyB0aGFu
IHRoZSB2YWxpZCBmcmFtZSBkYXRhIGR1ZSB0bw0KPiA+IGhlaWdodCBhbGlnbm1lbnQuDQo+ID4N
Cj4gPiBJbiB0aGlzIGNhc2UsIHRoZSBwYWdlIG51bWJlcnMgaW4gc2cgbGlzdCBjb3VsZCBleGNl
ZWQgdGhlIEZCUFQgdXBwZXINCj4gPiBsaW1pdCB2YWx1ZSAtIG1heF9sb3BzKDgpKjEwMjQgdG8g
Y2F1c2UgY3Jhc2guDQo+ID4NCj4gPiBMaW1pdCB0aGUgTE9QIGFjY2VzcyB0byB0aGUgdmFsaWQg
ZGF0YSBsZW5ndGggdG8gYXZvaWQgRkJQVA0KPiA+IHN1Yi1lbnRyaWVzIG92ZXJmbG93Lg0KPiA+
DQo+ID4gU2lnbmVkLW9mZi1ieTogWW9uZyBaaGkgPHlvbmcuemhpQGludGVsLmNvbT4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBDYW8gQmluZyBCdSA8YmluZ2J1LmNhb0BpbnRlbC5jb20+DQo+ID4gLS0t
DQo+ID4gIGRyaXZlcnMvbWVkaWEvcGNpL2ludGVsL2lwdTMvaXB1My1jaW8yLmMgfCA3ICsrKysr
LS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3BjaS9pbnRlbC9pcHUzL2lwdTMt
Y2lvMi5jDQo+ID4gYi9kcml2ZXJzL21lZGlhL3BjaS9pbnRlbC9pcHUzL2lwdTMtY2lvMi5jDQo+
ID4gaW5kZXggOTQxY2FhOTg3ZGFiLi45NDlmNDNkMjA2YWQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy9tZWRpYS9wY2kvaW50ZWwvaXB1My9pcHUzLWNpbzIuYw0KPiA+ICsrKyBiL2RyaXZlcnMv
bWVkaWEvcGNpL2ludGVsL2lwdTMvaXB1My1jaW8yLmMNCj4gPiBAQCAtODM4LDggKzgzOCw5IEBA
IHN0YXRpYyBpbnQgY2lvMl92YjJfYnVmX2luaXQoc3RydWN0IHZiMl9idWZmZXIgKnZiKQ0KPiA+
ICAgICAgICAgICAgICAgICBjb250YWluZXJfb2YodmIsIHN0cnVjdCBjaW8yX2J1ZmZlciwgdmJi
LnZiMl9idWYpOw0KPiA+ICAgICAgICAgc3RhdGljIGNvbnN0IHVuc2lnbmVkIGludCBlbnRyaWVz
X3Blcl9wYWdlID0NCj4gPiAgICAgICAgICAgICAgICAgQ0lPMl9QQUdFX1NJWkUgLyBzaXplb2Yo
dTMyKTsNCj4gPiAtICAgICAgIHVuc2lnbmVkIGludCBwYWdlcyA9IERJVl9ST1VORF9VUCh2Yi0+
cGxhbmVzWzBdLmxlbmd0aCwNCj4gQ0lPMl9QQUdFX1NJWkUpOw0KPiA+IC0gICAgICAgdW5zaWdu
ZWQgaW50IGxvcHMgPSBESVZfUk9VTkRfVVAocGFnZXMgKyAxLCBlbnRyaWVzX3Blcl9wYWdlKTsN
Cj4gPiArICAgICAgIHVuc2lnbmVkIGludCBwYWdlcyA9IERJVl9ST1VORF9VUCh2Yi0+cGxhbmVz
WzBdLmxlbmd0aCwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBDSU8yX1BBR0VfU0laRSkgKyAxOw0KPiANCj4gV2h5ICsgMT8gVGhpcyB3b3VsZCBzdGlsbCBv
dmVyZmxvdyB0aGUgYnVmZmVyLCB3b3VsZG4ndCBpdD8NCg0KVGhlICJwYWdlcyIgdmFyaWFibGUg
aXMgdXNlZCB0byBjYWxjdWxhdGUgbG9wcyB3aGljaCBoYXMgb25lIGV4dHJhIHBhZ2UgYXQgdGhl
IGVuZCB0aGF0IHBvaW50cyB0byBkdW1teSBwYWdlLg0KDQo+IA0KPiA+ICsgICAgICAgdW5zaWdu
ZWQgaW50IGxvcHMgPSBESVZfUk9VTkRfVVAocGFnZXMsIGVudHJpZXNfcGVyX3BhZ2UpOw0KPiA+
ICAgICAgICAgc3RydWN0IHNnX3RhYmxlICpzZzsNCj4gPiAgICAgICAgIHN0cnVjdCBzZ19wYWdl
X2l0ZXIgc2dfaXRlcjsNCj4gPiAgICAgICAgIGludCBpLCBqOw0KPiA+IEBAIC04NjksNiArODcw
LDggQEAgc3RhdGljIGludCBjaW8yX3ZiMl9idWZfaW5pdChzdHJ1Y3QgdmIyX2J1ZmZlcg0KPiA+
ICp2YikNCj4gPg0KPiA+ICAgICAgICAgaSA9IGogPSAwOw0KPiA+ICAgICAgICAgZm9yX2VhY2hf
c2dfcGFnZShzZy0+c2dsLCAmc2dfaXRlciwgc2ctPm5lbnRzLCAwKSB7DQo+ID4gKyAgICAgICAg
ICAgICAgIGlmICghcGFnZXMtLSkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBicmVhazsN
Cj4gDQo+IE9yIHBlcmhhcHMgd2Ugc2hvdWxkIGNoZWNrIGhlcmUgZm9yIChwYWdlcyA+IDEpPw0K
DQpUaGlzIGlzIHNvIHRoYXQgdGhlIGVuZCBvZiBsb3AgaXMgc2V0IHRvIHRoZSBkdW1teV9wYWdl
Lg0KDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IFRvbWFzeg0K
