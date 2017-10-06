Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9627 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751980AbdJFTUG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 15:20:06 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Tomasz Figa <tfiga@chromium.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: RE: [PATCH v2 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2
 driver
Date: Fri, 6 Oct 2017 19:19:55 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE25A50@ORSMSX106.amr.corp.intel.com>
References: <1496799279-8774-1-git-send-email-yong.zhi@intel.com>
 <1496799279-8774-4-git-send-email-yong.zhi@intel.com>
 <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
In-Reply-To: <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGksIFRvbWFzeiwNCg0KU29ycnkgZm9yIHRoZSBsYXRlIHJlcGx5LiBJIHdpbGwgb21pdCB0aGUg
cG9pbnRzIHRoYXQgaGF2ZSBiZWVuIGZpeGVkIGluIHY0IG9yIGRpc2N1c3NlZCBlYXJsaWVyIGJ5
IGVpdGhlciBUdXVra2Egb3IgU2FrYXJpIChodHRwczovL3BhdGNod29yay5saW51eHR2Lm9yZy9w
YXRjaC80MTY2NSkNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51
eC1tZWRpYS1vd25lckB2Z2VyLmtlcm5lbC5vcmcgW21haWx0bzpsaW51eC1tZWRpYS0NCj4gb3du
ZXJAdmdlci5rZXJuZWwub3JnXSBPbiBCZWhhbGYgT2YgVG9tYXN6IEZpZ2ENCj4gU2VudDogTW9u
ZGF5LCBKdW5lIDEyLCAyMDE3IDI6NTkgQU0NCj4gVG86IFpoaSwgWW9uZyA8eW9uZy56aGlAaW50
ZWwuY29tPg0KPiBDYzogbGludXgtbWVkaWFAdmdlci5rZXJuZWwub3JnOyBTYWthcmkgQWlsdXMg
PHNha2FyaS5haWx1c0BsaW51eC5pbnRlbC5jb20+Ow0KPiBaaGVuZywgSmlhbiBYdSA8amlhbi54
dS56aGVuZ0BpbnRlbC5jb20+OyBNYW5pLCBSYWptb2hhbg0KPiA8cmFqbW9oYW4ubWFuaUBpbnRl
bC5jb20+OyBUb2l2b25lbiwgVHV1a2thDQo+IDx0dXVra2EudG9pdm9uZW5AaW50ZWwuY29tPjsg
SGFucyBWZXJrdWlsIDxodmVya3VpbEB4czRhbGwubmw+OyBZYW5nLA0KPiBIeXVuZ3dvbyA8aHl1
bmd3b28ueWFuZ0BpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgMy8zXSBbbWVk
aWFdIGludGVsLWlwdTM6IGNpbzI6IEFkZCBuZXcgTUlQSS1DU0kyDQo+IGRyaXZlcg0KPiANCj4g
SGkgWW9uZywNCj4gDQo+IFBsZWFzZSBzZWUgbXkgY29tbWVudHMgaW5saW5lLg0KPiANCj4gT24g
V2VkLCBKdW4gNywgMjAxNyBhdCAxMDozNCBBTSwgWW9uZyBaaGkgPHlvbmcuemhpQGludGVsLmNv
bT4gd3JvdGU6DQo+ID4gVGhpcyBwYXRjaCBhZGRzIENJTzIgQ1NJLTIgZGV2aWNlIGRyaXZlciBm
b3IgSW50ZWwncyBJUFUzIGNhbWVyYQ0KPiA+IHN1Yi1zeXN0ZW0gc3VwcG9ydC4NCj4gPg0KPiA+
IFNpZ25lZC1vZmYtYnk6IFlvbmcgWmhpIDx5b25nLnpoaUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+
ID4gIGRyaXZlcnMvbWVkaWEvcGNpL0tjb25maWcgICAgICAgICAgICAgICAgfCAgICAyICsNCj4g
PiAgZHJpdmVycy9tZWRpYS9wY2kvTWFrZWZpbGUgICAgICAgICAgICAgICB8ICAgIDMgKy0NCj4g
PiAgZHJpdmVycy9tZWRpYS9wY2kvaW50ZWwvTWFrZWZpbGUgICAgICAgICB8ICAgIDUgKw0KPiA+
ICBkcml2ZXJzL21lZGlhL3BjaS9pbnRlbC9pcHUzL0tjb25maWcgICAgIHwgICAxNyArDQo+ID4g
IGRyaXZlcnMvbWVkaWEvcGNpL2ludGVsL2lwdTMvTWFrZWZpbGUgICAgfCAgICAxICsNCj4gPiAg
ZHJpdmVycy9tZWRpYS9wY2kvaW50ZWwvaXB1My9pcHUzLWNpbzIuYyB8IDE3ODgNCj4gPiArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiBkcml2ZXJzL21lZGlhL3BjaS9pbnRlbC9p
cHUzL2lwdTMtY2lvMi5oIHwgIDQyNCArKysrKysrDQo+ID4gIDcgZmlsZXMgY2hhbmdlZCwgMjIz
OSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pICBjcmVhdGUgbW9kZQ0KPiA+IDEwMDY0NCBk
cml2ZXJzL21lZGlhL3BjaS9pbnRlbC9NYWtlZmlsZSAgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+ID4g
ZHJpdmVycy9tZWRpYS9wY2kvaW50ZWwvaXB1My9LY29uZmlnDQo+ID4gIGNyZWF0ZSBtb2RlIDEw
MDY0NCBkcml2ZXJzL21lZGlhL3BjaS9pbnRlbC9pcHUzL01ha2VmaWxlDQo+ID4gIGNyZWF0ZSBt
b2RlIDEwMDY0NCBkcml2ZXJzL21lZGlhL3BjaS9pbnRlbC9pcHUzL2lwdTMtY2lvMi5jDQo+ID4g
IGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21lZGlhL3BjaS9pbnRlbC9pcHUzL2lwdTMtY2lv
Mi5oDQo+IFtzbmlwXQ0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3BjaS9pbnRlbC9p
cHUzL0tjb25maWcNCj4gPiBiL2RyaXZlcnMvbWVkaWEvcGNpL2ludGVsL2lwdTMvS2NvbmZpZw0K
PiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMC4uMmE4OTVkNg0KPiA+
IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9kcml2ZXJzL21lZGlhL3BjaS9pbnRlbC9pcHUzL0tj
b25maWcNCj4gPiBAQCAtMCwwICsxLDE3IEBADQo+ID4gK2NvbmZpZyBWSURFT19JUFUzX0NJTzIN
Cj4gPiArICAgICAgIHRyaXN0YXRlICJJbnRlbCBpcHUzLWNpbzIgZHJpdmVyIg0KPiA+ICsgICAg
ICAgZGVwZW5kcyBvbiBWSURFT19WNEwyICYmIFBDSQ0KPiA+ICsgICAgICAgZGVwZW5kcyBvbiBN
RURJQV9DT05UUk9MTEVSDQo+ID4gKyAgICAgICBkZXBlbmRzIG9uIEhBU19ETUENCj4gPiArICAg
ICAgIGRlcGVuZHMgb24gQUNQSQ0KPiANCj4gSSB3b25kZXIgaWYgaXQgd291bGRuJ3QgbWFrZSBz
ZW5zZSB0byBtYWtlIHRoaXMgZGVwZW5kIG9uIFg4NiAofHwNCj4gQ09NUElMRV9URVNUKSBhcyB3
ZWxsLiBBcmUgd2UgZXhwZWN0aW5nIGEgc3RhbmRhbG9uZSBQQ0koZSkgY2FyZCB3aXRoIHRoaXMN
Cj4gZGV2aWNlIGluIHRoZSBmdXR1cmU/DQoNCldpbGwgYWRkIGRlcGVuZHMgb24gKFg4NiB8fCBD
T01QSUxFX1RFU1QpICYmIDY0QklUDQoNCj4gDQo+ID4gKyAgICAgICBzZWxlY3QgVjRMMl9GV05P
REUNCj4gPiArICAgICAgIHNlbGVjdCBWSURFT0JVRjJfRE1BX1NHDQo+ID4gKw0KPiA+ICsgICAg
ICAgLS0taGVscC0tLQ0KPiA+ICsgICAgICAgVGhpcyBpcyB0aGUgSW50ZWwgSVBVMyBDSU8yIENT
SS0yIHJlY2VpdmVyIHVuaXQsIGZvdW5kIGluIEludGVsDQo+ID4gKyAgICAgICBTa3lsYWtlIGFu
ZCBLYWJ5IExha2UgU29DcyBhbmQgdXNlZCBmb3IgY2FwdHVyaW5nIGltYWdlcyBhbmQNCj4gPiAr
ICAgICAgIHZpZGVvIGZyb20gYSBjYW1lcmEgc2Vuc29yLg0KPiA+ICsNCj4gPiArICAgICAgIFNh
eSBZIG9yIE0gaGVyZSBpZiB5b3UgaGF2ZSBhIFNreWxha2UvS2FieSBMYWtlIFNvQyB3aXRoIE1J
UEkgQ1NJLTINCj4gPiArICAgICAgIGNvbm5lY3RlZCBjYW1lcmEuDQo+ID4gKyAgICAgICBUaGUg
bW9kdWxlIHdpbGwgYmUgY2FsbGVkIGlwdTMtY2lvMi4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tZWRpYS9wY2kvaW50ZWwvaXB1My9NYWtlZmlsZQ0KPiA+IGIvZHJpdmVycy9tZWRpYS9wY2kv
aW50ZWwvaXB1My9NYWtlZmlsZQ0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXgg
MDAwMDAwMC4uMjAxODZlMw0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9kcml2ZXJzL21l
ZGlhL3BjaS9pbnRlbC9pcHUzL01ha2VmaWxlDQo+ID4gQEAgLTAsMCArMSBAQA0KPiA+ICtvYmot
JChDT05GSUdfVklERU9fSVBVM19DSU8yKSArPSBpcHUzLWNpbzIubw0KPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL21lZGlhL3BjaS9pbnRlbC9pcHUzL2lwdTMtY2lvMi5jDQo+ID4gYi9kcml2ZXJz
L21lZGlhL3BjaS9pbnRlbC9pcHUzL2lwdTMtY2lvMi5jDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2
NDQNCj4gPiBpbmRleCAwMDAwMDAwLi42OWM0N2ZjDQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsr
KyBiL2RyaXZlcnMvbWVkaWEvcGNpL2ludGVsL2lwdTMvaXB1My1jaW8yLmMNCj4gW3NuaXBdDQo+
IA0KPiA+ICsgICAgICAgICAgICAgICB1MzIgZmJwdF9ycCA9DQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgKHJlYWRsKGNpbzItPmJhc2UgKyBDSU8yX1JFR19DRE1BUkkoQ0lPMl9ETUFfQ0hB
TikpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgID4+IENJTzJfQ0RNQVJJX0ZCUFRfUlBf
U0hJRlQpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgJiBDSU8yX0NETUFSSV9GQlBUX1JQ
X01BU0s7DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgICAvKg0KPiA+ICsgICAgICAgICAgICAg
ICAgKiBmYnB0X3JwIGlzIHRoZSBmYnB0IGVudHJ5IHRoYXQgdGhlIGRtYSBpcyBjdXJyZW50bHkg
d29ya2luZw0KPiA+ICsgICAgICAgICAgICAgICAgKiBvbiwgYnV0IHNpbmNlIGl0IGNvdWxkIGp1
bXAgdG8gbmV4dCBlbnRyeSBhdCBhbnkgdGltZSwNCj4gPiArICAgICAgICAgICAgICAgICogYXNz
dW1lIHRoYXQgd2UgbWlnaHQgYWxyZWFkeSBiZSB0aGVyZS4NCj4gPiArICAgICAgICAgICAgICAg
ICovDQo+ID4gKyAgICAgICAgICAgICAgIGZicHRfcnAgPSAoZmJwdF9ycCArIDEpICUgQ0lPMl9N
QVhfQlVGRkVSUzsNCj4gDQo+IEhtbSwgdGhpcyBpcyByZWFsbHkgcmFjeS4gVGhpcyBjb2RlIGNh
biBiZSBwcmUtZW1wdGVkIGFuZCBub3QgZXhlY3V0ZSBmb3INCj4gcXVpdGUgbG9uZyB0aW1lLCBk
ZXBlbmRpbmcgb24gc3lzdGVtIGxvYWQsIHJlc3VtaW5nIGFmdGVyIHRoZSBoYXJkd2FyZQ0KPiBn
b2VzIGV2ZW4gZnVydGhlci4gVGVjaG5pY2FsbHkgeW91IGNvdWxkIHByZXZlbnQgdGhpcyB1c2lu
Zw0KPiAqX2lycV9zYXZlKCkvX2lycV9yZXN0b3JlKCksIGJ1dCBJJ2QgdHJ5IHRvIGZpbmQgYSB3
YXkgdGhhdCBkb2Vzbid0IHJlbHkgb24gdGhlDQo+IHRpbWluZywgaWYgcG9zc2libGUuDQoNCkFj
aw0KV2lsbCBkaXNhYmxlIGludGVycnVwdHMgZm9yIHRoZSBkdXJhdGlvbiBvZiB0aGlzIGJ1ZmZl
ciBxdWV1ZWluZy4NCg0KPiBbc25pcF0NCj4gPiArc3RhdGljIGludCBjaW8yX3Y0bDJfcXVlcnlj
YXAoc3RydWN0IGZpbGUgKmZpbGUsIHZvaWQgKmZoLA0KPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHN0cnVjdCB2NGwyX2NhcGFiaWxpdHkgKmNhcCkgew0KPiA+ICsgICAgICAgc3Ry
dWN0IGNpbzJfZGV2aWNlICpjaW8yID0gdmlkZW9fZHJ2ZGF0YShmaWxlKTsNCj4gPiArDQo+ID4g
KyAgICAgICBzdHJsY3B5KGNhcC0+ZHJpdmVyLCBDSU8yX05BTUUsIHNpemVvZihjYXAtPmRyaXZl
cikpOw0KPiA+ICsgICAgICAgc3RybGNweShjYXAtPmNhcmQsIENJTzJfREVWSUNFX05BTUUsIHNp
emVvZihjYXAtPmNhcmQpKTsNCj4gPiArICAgICAgIHNucHJpbnRmKGNhcC0+YnVzX2luZm8sIHNp
emVvZihjYXAtPmJ1c19pbmZvKSwNCj4gPiArICAgICAgICAgICAgICAgICJQQ0k6JXMiLCBwY2lf
bmFtZShjaW8yLT5wY2lfZGV2KSk7DQo+ID4gKyAgICAgICBjYXAtPmRldmljZV9jYXBzID0gVjRM
Ml9DQVBfVklERU9fQ0FQVFVSRSB8DQo+ID4gKyBWNEwyX0NBUF9TVFJFQU1JTkc7DQo+IA0KPiBI
bW0sIEkgdGhvdWdodCBzaW5nbGUgcGxhbmUgcXVldWUgdHlwZSB3YXMgZGVwcmVjYXRlZCB0aGVz
ZSBkYXlzIGFuZA0KPiBfTVBMQU5FIHJlY29tbWVuZGVkIGZvciBhbGwgbmV3IGRyaXZlcnMuIEkn
bGwgZGVmZXIgdGhpcyB0byBvdGhlciByZXZpZXdlcnMsDQo+IHRob3VnaC4NCg0KV2lsbCBzd2l0
Y2ggdG8gTVBMQU5FIHN1cHBvcnQgaW4gdjUuDQoNCj4gDQo+ID4gKyAgICAgICBjYXAtPmNhcGFi
aWxpdGllcyA9IGNhcC0+ZGV2aWNlX2NhcHMgfCBWNEwyX0NBUF9ERVZJQ0VfQ0FQUzsNCj4gPiAr
DQo+ID4gKyAgICAgICByZXR1cm4gMDsNCj4gPiArfQ0KPiBbc25pcF0NCj4gPiArc3RhdGljIGlu
dCBjaW8yX3Y0bDJfdHJ5X2ZtdChzdHJ1Y3QgZmlsZSAqZmlsZSwgdm9pZCAqZmgsIHN0cnVjdA0K
PiA+ICt2NGwyX2Zvcm1hdCAqZikgew0KPiA+ICsgICAgICAgdTMyIHBpeGVsZm9ybWF0ID0gZi0+
Zm10LnBpeC5waXhlbGZvcm1hdDsNCj4gPiArICAgICAgIHVuc2lnbmVkIGludCBpOw0KPiA+ICsN
Cj4gPiArICAgICAgIGNpbzJfdjRsMl9nX2ZtdChmaWxlLCBmaCwgZik7DQo+ID4gKw0KPiA+ICsg
ICAgICAgZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoY2lvMl9jc2kyX2ZtdHMpOyBpKyspIHsN
Cj4gPiArICAgICAgICAgICAgICAgaWYgKHBpeGVsZm9ybWF0ID09IGNpbzJfY3NpMl9mbXRzW2ld
KQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICsgICAgICAgfQ0KPiA+
ICsNCj4gPiArICAgICAgIC8qIFVzZSBTUkdHQjEwIGFzIGRlZmF1bHQgaWYgbm90IGZvdW5kICov
DQo+ID4gKyAgICAgICBpZiAoaSA+PSBBUlJBWV9TSVpFKGNpbzJfY3NpMl9mbXRzKSkNCj4gPiAr
ICAgICAgICAgICAgICAgcGl4ZWxmb3JtYXQgPSBWNEwyX1BJWF9GTVRfSVBVM19TUkdHQjEwOw0K
PiA+ICsNCj4gPiArICAgICAgIGYtPmZtdC5waXgucGl4ZWxmb3JtYXQgPSBwaXhlbGZvcm1hdDsN
Cj4gPiArICAgICAgIGYtPmZtdC5waXguYnl0ZXNwZXJsaW5lID0gY2lvMl9ieXRlc3BlcmxpbmUo
Zi0+Zm10LnBpeC53aWR0aCk7DQo+ID4gKyAgICAgICBmLT5mbXQucGl4LnNpemVpbWFnZSA9IGYt
PmZtdC5waXguYnl0ZXNwZXJsaW5lICoNCj4gPiArIGYtPmZtdC5waXguaGVpZ2h0Ow0KPiANCj4g
U2hvdWxkbid0IHlvdSB1c2UgZi0+Zm10LnBpeF9tcCBpbnN0ZWFkPw0KPiANCg0KQWdyZWVkLCB3
aWxsIHVwZGF0ZSBoZXJlIHRvZ2V0aGVyIHdpdGggTVBMQU5FIHN1cHBvcnQuDQoNCj4gW3NuaXBd
DQo+ID4gKw0KPiA+ICsgICAgICAgLyogSW5pdGlhbGl6ZSB2YnEgKi8NCj4gPiArICAgICAgIHZi
cS0+dHlwZSA9IFY0TDJfQlVGX1RZUEVfVklERU9fQ0FQVFVSRTsNCj4gPiArICAgICAgIHZicS0+
aW9fbW9kZXMgPSBWQjJfVVNFUlBUUiB8IFZCMl9NTUFQOw0KPiANCj4gDQo+IEJlc3QgcmVnYXJk
cywNCj4gVG9tYXN6DQo=
