Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:11375 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbeCIKqP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 05:46:15 -0500
From: "Yeh, Andy" <andy.yeh@intel.com>
To: Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        "Chiang, AlanX" <alanx.chiang@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Subject: RE: [PATCH v8] media: imx258: Add imx258 camera sensor driver
Date: Fri, 9 Mar 2018 10:46:10 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D5252C7@KMSMSX156.gar.corp.intel.com>
References: <1520525754-15726-1-git-send-email-andy.yeh@intel.com>
 <20180309085442.qyo2ufb4abaupzop@paasikivi.fi.intel.com>
 <CAAFQd5BexArX_tzx-HEtAiDMu-v+6i+tDPysnpJLa+hPe1=M=Q@mail.gmail.com>
In-Reply-To: <CAAFQd5BexArX_tzx-HEtAiDMu-v+6i+tDPysnpJLa+hPe1=M=Q@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgVG9tYXN6LA0KDQpNeSBhcG9sb2d5LiBBY3R1YWxseSBJIG9ic29sZXRlZCB0aGlzIFtWOF0g
aHR0cHM6Ly9wYXRjaHdvcmsubGludXh0di5vcmcvcGF0Y2gvNDc3NjgvIGp1c3QgYWZ0ZXIgc3Vi
bWl0dGVkLiAgDQpTaW5jZSBJIGZvdW5kIGZldyBjb21tZW50cyBhcyB3aGF0IHlvdSBwb2ludGVk
IGJlbG93IHdlcmUgbm90IGFkZHJlc3NlZCB5ZXQuDQpEaWRu4oCZdCBleHBlY3QgeW91IHRvIGNo
ZWNrIHRoaXMuIEkgc2hhbGwgc2VuZCBhbiBlbWFpbCB0byBub3RpZnkgeW91IHR3byB0aGUgb2Jz
b2xldGUgc3RhdGUgYXMgd2VsbC4NCg0KV2UgYXJlIHdvcmtpbmcgb24gYWRkcmVzc2luZyBhbGwg
dGhvc2Ugb3V0c3RhbmRpbmcgY29tbWVudHMuIEFsbW9zdCBkb25lLg0KV2lsbCBkbyByZXBseSB2
NiB3aXRoIE9LQVksIGFuZCBzZW5kIHRvIGxpc3QgYSBuZXcgdjcgd2l0aCBhbGwgZml4ZWQuCQ0K
DQoNClJlZ2FyZHMsIEFuZHkNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFRv
bWFzeiBGaWdhIFttYWlsdG86dGZpZ2FAY2hyb21pdW0ub3JnXSANClNlbnQ6IEZyaWRheSwgTWFy
Y2ggOSwgMjAxOCA2OjIwIFBNDQpUbzogU2FrYXJpIEFpbHVzIDxzYWthcmkuYWlsdXNAbGludXgu
aW50ZWwuY29tPg0KQ2M6IFllaCwgQW5keSA8YW5keS55ZWhAaW50ZWwuY29tPjsgTGludXggTWVk
aWEgTWFpbGluZyBMaXN0IDxsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmc+OyBDaGVuLCBKYXNv
blggWiA8amFzb254LnouY2hlbkBpbnRlbC5jb20+OyBDaGlhbmcsIEFsYW5YIDxhbGFueC5jaGlh
bmdAaW50ZWwuY29tPg0KU3ViamVjdDogUmU6IFtQQVRDSCB2OF0gbWVkaWE6IGlteDI1ODogQWRk
IGlteDI1OCBjYW1lcmEgc2Vuc29yIGRyaXZlcg0KDQpIaSBBbmR5LCBTYWthcmksDQoNCk9uIEZy
aSwgTWFyIDksIDIwMTggYXQgNTo1NCBQTSwgU2FrYXJpIEFpbHVzIDxzYWthcmkuYWlsdXNAbGlu
dXguaW50ZWwuY29tPiB3cm90ZToNCj4gSGkgQW5keSwNCj4NCj4gVGhhbmtzIGZvciB0aGUgdXBk
YXRlLiBQbGVhc2Ugc2VlIG15IGNvbW1lbnRzIGJlbG93Lg0KPg0KPiBPbiBGcmksIE1hciAwOSwg
MjAxOCBhdCAxMjoxNTo1NEFNICswODAwLCBBbmR5IFllaCB3cm90ZToNCj4+IEFkZCBhIFY0TDIg
c3ViLWRldmljZSBkcml2ZXIgZm9yIHRoZSBTb255IElNWDI1OCBpbWFnZSBzZW5zb3IuDQo+PiBU
aGlzIGlzIGEgY2FtZXJhIHNlbnNvciB1c2luZyB0aGUgSTJDIGJ1cyBmb3IgY29udHJvbCBhbmQg
dGhlDQo+PiBDU0ktMiBidXMgZm9yIGRhdGEuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogSmFzb24g
Q2hlbiA8amFzb254LnouY2hlbkBpbnRlbC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBBbGFuIENo
aWFuZyA8YWxhbnguY2hpYW5nQGludGVsLmNvbT4NCj4+IC0tLQ0KPj4gc2luY2UgdjI6DQo+PiAt
LSBVcGRhdGUgdGhlIHN0cmVhbWluZyBmdW5jdGlvbiB0byByZW1vdmUgU1dfU1RBTkRCWSBpbiB0
aGUgYmVnaW5uaW5nLg0KPj4gLS0gQWRqdXN0IHRoZSBkZWxheSB0aW1lIGZyb20gMW1zIHRvIDEy
bXMgYmVmb3JlIHNldCBzdHJlYW0tb24gcmVnaXN0ZXIuDQo+PiBzaW5jZSB2MzoNCj4+IC0tIGZp
eCB0aGUgc2QuZW50aXR5IHRvIG1ha2UgY29kZSBiZSBjb21waWxlZCBvbiB0aGUgbWFpbmxpbmUg
a2VybmVsLg0KPj4gc2luY2UgdjQ6DQo+PiAtLSBFbmFibGVkIEFHLCBERywgYW5kIEV4cG9zdXJl
IHRpbWUgY29udHJvbCBjb3JyZWN0bHkuDQo+PiBzaW5jZSB2NToNCj4+IC0tIFNlbnNvciB2ZW5k
b3IgcHJvdmlkZWQgYSBuZXcgc2V0dGluZyB0byBmaXggZGlmZmVyZW50IENMSyBpc3N1ZQ0KPj4g
LS0gQWRkIG9uZSBtb3JlIHJlc29sdXRpb24gZm9yIDEwNDh4NzgwLCB1c2VkIGZvciBWR0Egc3Ry
ZWFtaW5nIHNpbmNlIA0KPj4gdjY6DQo+PiAtLSBpbXByb3ZlIGkyYyB3cml0ZSBmdW5jdGlvbiB0
byBzdXBwb3J0IHdyaXRpbmcgMiByZWdpc3RlcnMNCj4+IC0tIE5vdCBPcnJpbmcgcmV0IGluIHVw
ZGF0ZV9kaWdpdGFsX2dhaW4gd2hpY2ggbGVhZCB0byB1bmludGVuZGVkIA0KPj4gZXJyb3Igc2lu
Y2Ugdjc6DQo+PiAtLSBtb2RpZmllZCBpbXgyNThfcmVnIHJlYWQgLyB3cml0ZSBmdW5jdGlvbiB3
aXRoIGEgbW9yZSBwb3J0YWJsZSB3YXkNCj4+IC0tIGFycmFuZ2VkIHNvbWUgZm9ybWF0IHBlciBz
dWdnZXN0aW9ucw0KPj4NCj4+DQo+PiAgTUFJTlRBSU5FUlMgICAgICAgICAgICAgICAgfCAgICA3
ICsNCj4+ICBkcml2ZXJzL21lZGlhL2kyYy9LY29uZmlnICB8ICAgMTEgKw0KPj4gIGRyaXZlcnMv
bWVkaWEvaTJjL01ha2VmaWxlIHwgICAgMSArDQo+PiAgZHJpdmVycy9tZWRpYS9pMmMvaW14MjU4
LmMgfCAxMzI0IA0KPj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCj4+ICA0IGZpbGVzIGNoYW5nZWQsIDEzNDMgaW5zZXJ0aW9ucygrKQ0KPj4gIGNyZWF0ZSBt
b2RlIDEwMDY0NCBkcml2ZXJzL21lZGlhL2kyYy9pbXgyNTguYw0KPj4NCj4+IGRpZmYgLS1naXQg
YS9NQUlOVEFJTkVSUyBiL01BSU5UQUlORVJTIGluZGV4IGEzMzliYjUuLjlmNzU1MTAgMTAwNjQ0
DQo+PiAtLS0gYS9NQUlOVEFJTkVSUw0KPj4gKysrIGIvTUFJTlRBSU5FUlMNCj4+IEBAIC0xMjY0
Niw2ICsxMjY0NiwxMyBAQCBTOiAgIE1haW50YWluZWQNCj4+ICBGOiAgIGRyaXZlcnMvc3NiLw0K
Pj4gIEY6ICAgaW5jbHVkZS9saW51eC9zc2IvDQo+Pg0KPj4gK1NPTlkgSU1YMjU4IFNFTlNPUiBE
UklWRVINCj4+ICtNOiAgIFNha2FyaSBBaWx1cyA8c2FrYXJpLmFpbHVzQGxpbnV4LmludGVsLmNv
bT4NCj4+ICtMOiAgIGxpbnV4LW1lZGlhQHZnZXIua2VybmVsLm9yZw0KPj4gK1Q6ICAgZ2l0IGdp
dDovL2xpbnV4dHYub3JnL21lZGlhX3RyZWUuZ2l0DQo+PiArUzogICBNYWludGFpbmVkDQo+PiAr
RjogICBkcml2ZXJzL21lZGlhL2kyYy9pbXgyNTguYw0KPj4gKw0KPj4gIFNPTlkgSU1YMjc0IFNF
TlNPUiBEUklWRVINCj4+ICBNOiAgIExlb24gTHVvIDxsZW9ubEBsZW9wYXJkaW1hZ2luZy5jb20+
DQo+PiAgTDogICBsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmcNCj4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL21lZGlhL2kyYy9LY29uZmlnIGIvZHJpdmVycy9tZWRpYS9pMmMvS2NvbmZpZyANCj4+
IGluZGV4IGZkMDE4NDIuLmJjZDRiZjEgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL21lZGlhL2ky
Yy9LY29uZmlnDQo+PiArKysgYi9kcml2ZXJzL21lZGlhL2kyYy9LY29uZmlnDQo+PiBAQCAtNTY1
LDYgKzU2NSwxNyBAQCBjb25maWcgVklERU9fQVBUSU5BX1BMTCAgY29uZmlnIFZJREVPX1NNSUFQ
UF9QTEwNCj4+ICAgICAgIHRyaXN0YXRlDQo+Pg0KPj4gK2NvbmZpZyBWSURFT19JTVgyNTgNCj4+
ICsgICAgIHRyaXN0YXRlICJTb255IElNWDI1OCBzZW5zb3Igc3VwcG9ydCINCj4+ICsgICAgIGRl
cGVuZHMgb24gSTJDICYmIFZJREVPX1Y0TDIgJiYgVklERU9fVjRMMl9TVUJERVZfQVBJDQo+PiAr
ICAgICBkZXBlbmRzIG9uIE1FRElBX0NBTUVSQV9TVVBQT1JUDQo+PiArICAgICAtLS1oZWxwLS0t
DQo+PiArICAgICAgIFRoaXMgaXMgYSBWaWRlbzRMaW51eDIgc2Vuc29yLWxldmVsIGRyaXZlciBm
b3IgdGhlIFNvbnkNCj4+ICsgICAgICAgSU1YMjU4IGNhbWVyYS4NCj4+ICsNCj4+ICsgICAgICAg
VG8gY29tcGlsZSB0aGlzIGRyaXZlciBhcyBhIG1vZHVsZSwgY2hvb3NlIE0gaGVyZTogdGhlDQo+
PiArICAgICAgIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCBpbXgyNTguDQo+PiArDQo+PiAgY29uZmln
IFZJREVPX0lNWDI3NA0KPj4gICAgICAgdHJpc3RhdGUgIlNvbnkgSU1YMjc0IHNlbnNvciBzdXBw
b3J0Ig0KPj4gICAgICAgZGVwZW5kcyBvbiBJMkMgJiYgVklERU9fVjRMMiAmJiBWSURFT19WNEwy
X1NVQkRFVl9BUEkgZGlmZiANCj4+IC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9pMmMvTWFrZWZpbGUg
Yi9kcml2ZXJzL21lZGlhL2kyYy9NYWtlZmlsZSBpbmRleCANCj4+IDFiNjI2MzkuLjRiZjdkMDAg
MTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL21lZGlhL2kyYy9NYWtlZmlsZQ0KPj4gKysrIGIvZHJp
dmVycy9tZWRpYS9pMmMvTWFrZWZpbGUNCj4+IEBAIC05NCw2ICs5NCw3IEBAIG9iai0kKENPTkZJ
R19WSURFT19JUl9JMkMpICArPSBpci1rYmQtaTJjLm8NCj4+ICBvYmotJChDT05GSUdfVklERU9f
TUw4NlY3NjY3KSAgICAgICAgKz0gbWw4NnY3NjY3Lm8NCj4+ICBvYmotJChDT05GSUdfVklERU9f
T1YyNjU5KSAgICs9IG92MjY1OS5vDQo+PiAgb2JqLSQoQ09ORklHX1ZJREVPX1RDMzU4NzQzKSAr
PSB0YzM1ODc0My5vDQo+PiArb2JqLSQoQ09ORklHX1ZJREVPX0lNWDI1OCkgICArPSBpbXgyNTgu
bw0KPj4gIG9iai0kKENPTkZJR19WSURFT19JTVgyNzQpICAgKz0gaW14Mjc0Lm8NCj4+DQo+PiAg
b2JqLSQoQ09ORklHX1NEUl9NQVgyMTc1KSArPSBtYXgyMTc1Lm8gZGlmZiAtLWdpdCANCj4+IGEv
ZHJpdmVycy9tZWRpYS9pMmMvaW14MjU4LmMgYi9kcml2ZXJzL21lZGlhL2kyYy9pbXgyNTguYyBu
ZXcgZmlsZSANCj4+IG1vZGUgMTAwNjQ0IGluZGV4IDAwMDAwMDAuLjgxNDUyMGYNCj4+IC0tLSAv
ZGV2L251bGwNCj4+ICsrKyBiL2RyaXZlcnMvbWVkaWEvaTJjL2lteDI1OC5jDQo+PiBAQCAtMCww
ICsxLDEzMjQgQEANCj4+ICsvLyBDb3B5cmlnaHQgKEMpIDIwMTggSW50ZWwgQ29ycG9yYXRpb24g
Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IA0KPj4gK0dQTC0yLjANCj4+ICsNCj4+ICsjaW5j
bHVkZSA8bGludXgvYWNwaS5oPg0KPj4gKyNpbmNsdWRlIDxsaW51eC9kZWxheS5oPg0KPj4gKyNp
bmNsdWRlIDxsaW51eC9pMmMuaD4NCj4+ICsjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQo+PiAr
I2luY2x1ZGUgPGxpbnV4L3BtX3J1bnRpbWUuaD4NCj4+ICsjaW5jbHVkZSA8bWVkaWEvdjRsMi1j
dHJscy5oPg0KPj4gKyNpbmNsdWRlIDxtZWRpYS92NGwyLWRldmljZS5oPg0KPj4gKyNpbmNsdWRl
IDxhc20vdW5hbGlnbmVkLmg+DQo+PiArDQo+PiArI2RlZmluZSBJTVgyNThfUkVHX1ZBTFVFXzA4
QklUICAgICAgICAgICAgICAgMQ0KPj4gKyNkZWZpbmUgSU1YMjU4X1JFR19WQUxVRV8xNkJJVCAg
ICAgICAgICAgICAgIDINCj4+ICsjZGVmaW5lIElNWDI1OF9SRUdfVkFMVUVfMjRCSVQgICAgICAg
ICAgICAgICAzDQo+DQo+IFRoZSBsYXN0IG9uZSBpcyBub3QgdXNlZC4gUGVyaGFwcyBiZWNhdXNl
IHRoZSBzZW5zb3IgZG9lcyBub3QgaGF2ZSBhbnkgDQo+IDI0LWJpdCByZWdpc3RlcnM/IDotKSBI
b3cgYWJvdXQgcmVtb3ZpbmcgaXQ/DQoNCkkgcG9pbnRlZCBpbiBteSBlYXJsaWVyIHJldmlldyBj
b21tZW50cyB0aGF0IHdlIGRvbid0IGV2ZW4gbmVlZCB0aGVzZSBtYWNyb3MgYW55bW9yZS4gVGhl
eSBhZGQgYXMgbXVjaCB2YWx1ZSBhcyBkZWZpbmluZyBPTkUgPSAxIGFuZCBUV08gPSAyLg0KDQpB
bmR5LCB0aGlzIGlzIGFscmVhZHkgYSBzZWNvbmQgcmUtc3BpbiBvZiB0aGlzIHBhdGNoLCB3aGVy
ZSBteSBwcmV2aW91cyBjb21tZW50cyBhcmUgbGVmdCB1bmFkZHJlc3NlZC4NCg0KPg0KPj4gKw0K
Pj4gKyNkZWZpbmUgSU1YMjU4X1JFR19NT0RFX1NFTEVDVCAgICAgICAgICAgICAgIDB4MDEwMA0K
Pj4gKyNkZWZpbmUgSU1YMjU4X01PREVfU1RBTkRCWSAgICAgICAgICAweDAwDQo+PiArI2RlZmlu
ZSBJTVgyNThfTU9ERV9TVFJFQU1JTkcgICAgICAgICAgICAgICAgMHgwMQ0KPj4gKw0KPj4gKy8q
IENoaXAgSUQgKi8NCj4+ICsjZGVmaW5lIElNWDI1OF9SRUdfQ0hJUF9JRCAgICAgICAgICAgMHgw
MDE2DQo+PiArI2RlZmluZSBJTVgyNThfQ0hJUF9JRCAgICAgICAgICAgICAgICAgICAgICAgMHgw
MjU4DQo+PiArDQo+PiArLyogVl9USU1JTkcgaW50ZXJuYWwgKi8NCj4+ICsjZGVmaW5lIElNWDI1
OF9SRUdfVlRTICAgICAgICAgICAgICAgICAgICAgICAweDAzNDANCj4+ICsjZGVmaW5lIElNWDI1
OF9WVFNfMzBGUFMgICAgICAgICAgICAgMHgwYzk4DQo+PiArI2RlZmluZSBJTVgyNThfVlRTX01B
WCAgICAgICAgICAgICAgICAgICAgICAgMHhmZmZmDQo+PiArDQo+PiArLypGcmFtZSBMZW5ndGgg
TGluZSovDQo+PiArI2RlZmluZSBJTVgyNThfRkxMX01JTiAgICAgICAgICAgICAgICAgICAgICAg
MHgwOGE2DQo+PiArI2RlZmluZSBJTVgyNThfRkxMX01BWCAgICAgICAgICAgICAgICAgICAgICAg
MHhmZmZmDQo+PiArI2RlZmluZSBJTVgyNThfRkxMX1NURVAgICAgICAgICAgICAgICAgICAgICAg
MQ0KPj4gKyNkZWZpbmUgSU1YMjU4X0ZMTF9ERUZBVUxUICAgICAgICAgICAweDBjOTgNCj4+ICsN
Cj4+ICsvKiBIQkxBTksgY29udHJvbCAtIHJlYWQgb25seSAqLw0KPj4gKyNkZWZpbmUgSU1YMjU4
X1BQTF9ERUZBVUxUICAgICAgICAgICA1MzUyDQo+PiArDQo+PiArLyogRXhwb3N1cmUgY29udHJv
bCAqLw0KPj4gKyNkZWZpbmUgSU1YMjU4X1JFR19FWFBPU1VSRSAgICAgICAgICAweDAyMDINCj4+
ICsjZGVmaW5lIElNWDI1OF9FWFBPU1VSRV9NSU4gICAgICAgICAgNA0KPj4gKyNkZWZpbmUgSU1Y
MjU4X0VYUE9TVVJFX1NURVAgICAgICAgICAxDQo+PiArI2RlZmluZSBJTVgyNThfRVhQT1NVUkVf
REVGQVVMVCAgICAgICAgICAgICAgMHg2NDANCj4+ICsjZGVmaW5lIElNWDI1OF9FWFBPU1VSRV9N
QVggICAgICAgICAgNjU1MzUNCj4+ICsNCj4+ICsvKiBBbmFsb2cgZ2FpbiBjb250cm9sICovDQo+
PiArI2RlZmluZSBJTVgyNThfUkVHX0FOQUxPR19HQUlOICAgICAgICAgICAgICAgMHgwMjA0DQo+
PiArI2RlZmluZSBJTVgyNThfQU5BX0dBSU5fTUlOICAgICAgICAgIDANCj4+ICsjZGVmaW5lIElN
WDI1OF9BTkFfR0FJTl9NQVggICAgICAgICAgMHgxZmZmDQo+PiArI2RlZmluZSBJTVgyNThfQU5B
X0dBSU5fU1RFUCAgICAgICAgIDENCj4+ICsjZGVmaW5lIElNWDI1OF9BTkFfR0FJTl9ERUZBVUxU
ICAgICAgICAgICAgICAweDANCj4+ICsNCj4+ICsvKiBEaWdpdGFsIGdhaW4gY29udHJvbCAqLw0K
Pj4gKyNkZWZpbmUgSU1YMjU4X1JFR19HUl9ESUdJVEFMX0dBSU4gICAweDAyMGUNCj4+ICsjZGVm
aW5lIElNWDI1OF9SRUdfUl9ESUdJVEFMX0dBSU4gICAgMHgwMjEwDQo+PiArI2RlZmluZSBJTVgy
NThfUkVHX0JfRElHSVRBTF9HQUlOICAgIDB4MDIxMg0KPj4gKyNkZWZpbmUgSU1YMjU4X1JFR19H
Ql9ESUdJVEFMX0dBSU4gICAweDAyMTQNCj4+ICsjZGVmaW5lIElNWDI1OF9ER1RMX0dBSU5fTUlO
ICAgICAgICAgMA0KPj4gKyNkZWZpbmUgSU1YMjU4X0RHVExfR0FJTl9NQVggICAgICAgICA0MDk2
ICAgLyogTWF4ID0gMHhGRkYgKi8NCj4+ICsjZGVmaW5lIElNWDI1OF9ER1RMX0dBSU5fREVGQVVM
VCAgICAgMTAyNA0KPj4gKyNkZWZpbmUgSU1YMjU4X0RHVExfR0FJTl9TVEVQICAgICAgICAgICAx
DQo+PiArDQo+PiArLyogT3JpZW50YXRpb24gKi8NCj4+ICsjZGVmaW5lIFJFR19NSVJST1JfRkxJ
UF9DT05UUk9MICAgICAgMHgwMTAxDQo+PiArI2RlZmluZSBSRUdfQ09ORklHX01JUlJPUl9GTElQ
ICAgICAgICAgICAgICAgMHgwMw0KPj4gKw0KPj4gK3N0cnVjdCBpbXgyNThfcmVnIHsNCj4+ICsg
ICAgIHUxNiBhZGRyZXNzOw0KPj4gKyAgICAgdTggdmFsOw0KPj4gK307DQo+PiArDQo+PiArc3Ry
dWN0IGlteDI1OF9yZWdfbGlzdCB7DQo+PiArICAgICB1MzIgbnVtX29mX3JlZ3M7DQo+PiArICAg
ICBjb25zdCBzdHJ1Y3QgaW14MjU4X3JlZyAqcmVnczsNCj4+ICt9Ow0KPj4gKw0KPj4gKy8qIExp
bmsgZnJlcXVlbmN5IGNvbmZpZyAqLw0KPj4gK3N0cnVjdCBpbXgyNThfbGlua19mcmVxX2NvbmZp
ZyB7DQo+PiArICAgICB1MzIgcGl4ZWxzX3Blcl9saW5lOw0KPj4gKw0KPj4gKyAgICAgLyogUExM
IHJlZ2lzdGVycyBmb3IgdGhpcyBsaW5rIGZyZXF1ZW5jeSAqLw0KPj4gKyAgICAgc3RydWN0IGlt
eDI1OF9yZWdfbGlzdCByZWdfbGlzdDsgfTsNCj4+ICsNCj4+ICsvKiBNb2RlIDogcmVzb2x1dGlv
biBhbmQgcmVsYXRlZCBjb25maWcmdmFsdWVzICovIHN0cnVjdCBpbXgyNThfbW9kZSANCj4+ICt7
DQo+PiArICAgICAvKiBGcmFtZSB3aWR0aCAqLw0KPj4gKyAgICAgdTMyIHdpZHRoOw0KPj4gKyAg
ICAgLyogRnJhbWUgaGVpZ2h0ICovDQo+PiArICAgICB1MzIgaGVpZ2h0Ow0KPj4gKw0KPj4gKyAg
ICAgLyogVi10aW1pbmcgKi8NCj4+ICsgICAgIHUzMiB2dHNfZGVmOw0KPj4gKyAgICAgdTMyIHZ0
c19taW47DQo+PiArDQo+PiArICAgICAvKiBJbmRleCBvZiBMaW5rIGZyZXF1ZW5jeSBjb25maWcg
dG8gYmUgdXNlZCAqLw0KPj4gKyAgICAgdTMyIGxpbmtfZnJlcV9pbmRleDsNCj4+ICsgICAgIC8q
IERlZmF1bHQgcmVnaXN0ZXIgdmFsdWVzICovDQo+PiArICAgICBzdHJ1Y3QgaW14MjU4X3JlZ19s
aXN0IHJlZ19saXN0OyB9Ow0KPj4gKw0KPj4gKy8qIDQyMDh4MzExOCBuZWVkcyAxMjY3TWJwcy9s
YW5lLCA0IGxhbmVzICovIHN0YXRpYyBjb25zdCBzdHJ1Y3QgDQo+PiAraW14MjU4X3JlZyBtaXBp
X2RhdGFfcmF0ZV8xMjY3bWJwc1tdID0gew0KPj4gKyAgICAgeyAweDAzMDEsIDB4MDV9LA0KPg0K
PiBJZiB5b3UgaGF2ZSBhIHNwYWNlIGFmdGVyIHRoZSBvcGVuaW5nIGJyYWNlICh3aGljaCBJJ2Qg
cmVjb21tZW5kKSwgeW91IA0KPiBzaG91bGQgaGF2ZSBvbmUgYmVmb3JlIHRoZSBjbG9zaW5nIG9u
ZSBhcyB3ZWxsLg0KPg0KPj4gKyAgICAgeyAweDAzMDMsIDB4MDJ9LA0KPj4gKyAgICAgeyAweDAz
MDUsIDB4MDN9LA0KPj4gKyAgICAgeyAweDAzMDYsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAzMDcs
IDB4QzZ9LA0KPj4gKyAgICAgeyAweDAzMDksIDB4MEF9LA0KPj4gKyAgICAgeyAweDAzMEIsIDB4
MDF9LA0KPj4gKyAgICAgeyAweDAzMEQsIDB4MDJ9LA0KPj4gKyAgICAgeyAweDAzMEUsIDB4MDB9
LA0KPj4gKyAgICAgeyAweDAzMEYsIDB4RDh9LA0KPj4gKyAgICAgeyAweDAzMTAsIDB4MDB9LA0K
Pj4gKyAgICAgeyAweDA4MjAsIDB4MTN9LA0KPj4gKyAgICAgeyAweDA4MjEsIDB4NEN9LA0KPj4g
KyAgICAgeyAweDA4MjIsIDB4Q0N9LA0KPj4gKyAgICAgeyAweDA4MjMsIDB4Q0N9LA0KPj4gK307
DQo+PiArDQo+PiArc3RhdGljIGNvbnN0IHN0cnVjdCBpbXgyNThfcmVnIG1pcGlfZGF0YV9yYXRl
XzY0MG1icHNbXSA9IHsNCj4+ICsgICAgIHsgMHgwMzAxLCAweDA1fSwNCj4+ICsgICAgIHsgMHgw
MzAzLCAweDAyfSwNCj4+ICsgICAgIHsgMHgwMzA1LCAweDAzfSwNCj4+ICsgICAgIHsgMHgwMzA2
LCAweDAwfSwNCj4+ICsgICAgIHsgMHgwMzA3LCAweDY0fSwNCj4+ICsgICAgIHsgMHgwMzA5LCAw
eDBBfSwNCj4+ICsgICAgIHsgMHgwMzBCLCAweDAxfSwNCj4+ICsgICAgIHsgMHgwMzBELCAweDAy
fSwNCj4+ICsgICAgIHsgMHgwMzBFLCAweDAwfSwNCj4+ICsgICAgIHsgMHgwMzBGLCAweEQ4fSwN
Cj4+ICsgICAgIHsgMHgwMzEwLCAweDAwfSwNCj4+ICsgICAgIHsgMHgwODIwLCAweDBBfSwNCj4+
ICsgICAgIHsgMHgwODIxLCAweDAwfSwNCj4+ICsgICAgIHsgMHgwODIyLCAweDAwfSwNCj4+ICsg
ICAgIHsgMHgwODIzLCAweDAwfSwNCj4+ICt9Ow0KPj4gKw0KPj4gK3N0YXRpYyBjb25zdCBzdHJ1
Y3QgaW14MjU4X3JlZyBtb2RlXzQyMDh4MzExOF9yZWdzW10gPSB7DQo+PiArICAgICB7IDB4MDEz
NiwgMHgxM30sDQo+PiArICAgICB7IDB4MDEzNywgMHgzM30sDQo+PiArICAgICB7IDB4MzA1MSwg
MHgwMH0sDQo+PiArICAgICB7IDB4MzA1MiwgMHgwMH0sDQo+PiArICAgICB7IDB4NEUyMSwgMHgx
NH0sDQo+PiArICAgICB7IDB4NkIxMSwgMHhDRn0sDQo+PiArICAgICB7IDB4N0ZGMCwgMHgwOH0s
DQo+PiArICAgICB7IDB4N0ZGMSwgMHgwRn0sDQo+PiArICAgICB7IDB4N0ZGMiwgMHgwOH0sDQo+
PiArICAgICB7IDB4N0ZGMywgMHgxQn0sDQo+PiArICAgICB7IDB4N0ZGNCwgMHgyM30sDQo+PiAr
ICAgICB7IDB4N0ZGNSwgMHg2MH0sDQo+PiArICAgICB7IDB4N0ZGNiwgMHgwMH0sDQo+PiArICAg
ICB7IDB4N0ZGNywgMHgwMX0sDQo+PiArICAgICB7IDB4N0ZGOCwgMHgwMH0sDQo+PiArICAgICB7
IDB4N0ZGOSwgMHg3OH0sDQo+PiArICAgICB7IDB4N0ZGQSwgMHgwMH0sDQo+PiArICAgICB7IDB4
N0ZGQiwgMHgwMH0sDQo+PiArICAgICB7IDB4N0ZGQywgMHgwMH0sDQo+PiArICAgICB7IDB4N0ZG
RCwgMHgwMH0sDQo+PiArICAgICB7IDB4N0ZGRSwgMHgwMH0sDQo+PiArICAgICB7IDB4N0ZGRiwg
MHgwM30sDQo+PiArICAgICB7IDB4N0Y3NiwgMHgwM30sDQo+PiArICAgICB7IDB4N0Y3NywgMHhG
RX0sDQo+PiArICAgICB7IDB4N0ZBOCwgMHgwM30sDQo+PiArICAgICB7IDB4N0ZBOSwgMHhGRX0s
DQo+PiArICAgICB7IDB4N0IyNCwgMHg4MX0sDQo+PiArICAgICB7IDB4N0IyNSwgMHgwMH0sDQo+
PiArICAgICB7IDB4NjU2NCwgMHgwN30sDQo+PiArICAgICB7IDB4NkIwRCwgMHg0MX0sDQo+PiAr
ICAgICB7IDB4NjUzRCwgMHgwNH0sDQo+PiArICAgICB7IDB4NkIwNSwgMHg4Q30sDQo+PiArICAg
ICB7IDB4NkIwNiwgMHhGOX0sDQo+PiArICAgICB7IDB4NkIwOCwgMHg2NX0sDQo+PiArICAgICB7
IDB4NkIwOSwgMHhGQ30sDQo+PiArICAgICB7IDB4NkIwQSwgMHhDRn0sDQo+PiArICAgICB7IDB4
NkIwQiwgMHhEMn0sDQo+PiArICAgICB7IDB4NjcwMCwgMHgwRX0sDQo+PiArICAgICB7IDB4Njcw
NywgMHgwRX0sDQo+PiArICAgICB7IDB4OTEwNCwgMHgwMH0sDQo+PiArICAgICB7IDB4NDY0OCwg
MHg3Rn0sDQo+PiArICAgICB7IDB4NzQyMCwgMHgwMH0sDQo+PiArICAgICB7IDB4NzQyMSwgMHgx
Q30sDQo+PiArICAgICB7IDB4NzQyMiwgMHgwMH0sDQo+PiArICAgICB7IDB4NzQyMywgMHhEN30s
DQo+PiArICAgICB7IDB4NUYwNCwgMHgwMH0sDQo+PiArICAgICB7IDB4NUYwNSwgMHhFRH0sDQo+
PiArICAgICB7IDB4MDExMiwgMHgwQX0sDQo+PiArICAgICB7IDB4MDExMywgMHgwQX0sDQo+PiAr
ICAgICB7IDB4MDExNCwgMHgwM30sDQo+PiArICAgICB7IDB4MDM0MiwgMHgxNH0sDQo+PiArICAg
ICB7IDB4MDM0MywgMHhFOH0sDQo+PiArICAgICB7IDB4MDM0MCwgMHgwQ30sDQo+PiArICAgICB7
IDB4MDM0MSwgMHg1MH0sDQo+PiArICAgICB7IDB4MDM0NCwgMHgwMH0sDQo+PiArICAgICB7IDB4
MDM0NSwgMHgwMH0sDQo+PiArICAgICB7IDB4MDM0NiwgMHgwMH0sDQo+PiArICAgICB7IDB4MDM0
NywgMHgwMH0sDQo+PiArICAgICB7IDB4MDM0OCwgMHgxMH0sDQo+PiArICAgICB7IDB4MDM0OSwg
MHg2Rn0sDQo+PiArICAgICB7IDB4MDM0QSwgMHgwQ30sDQo+PiArICAgICB7IDB4MDM0QiwgMHgy
RX0sDQo+PiArICAgICB7IDB4MDM4MSwgMHgwMX0sDQo+PiArICAgICB7IDB4MDM4MywgMHgwMX0s
DQo+PiArICAgICB7IDB4MDM4NSwgMHgwMX0sDQo+PiArICAgICB7IDB4MDM4NywgMHgwMX0sDQo+
PiArICAgICB7IDB4MDkwMCwgMHgwMH0sDQo+PiArICAgICB7IDB4MDkwMSwgMHgxMX0sDQo+PiAr
ICAgICB7IDB4MDQwMSwgMHgwMH0sDQo+PiArICAgICB7IDB4MDQwNCwgMHgwMH0sDQo+PiArICAg
ICB7IDB4MDQwNSwgMHgxMH0sDQo+PiArICAgICB7IDB4MDQwOCwgMHgwMH0sDQo+PiArICAgICB7
IDB4MDQwOSwgMHgwMH0sDQo+PiArICAgICB7IDB4MDQwQSwgMHgwMH0sDQo+PiArICAgICB7IDB4
MDQwQiwgMHgwMH0sDQo+PiArICAgICB7IDB4MDQwQywgMHgxMH0sDQo+PiArICAgICB7IDB4MDQw
RCwgMHg3MH0sDQo+PiArICAgICB7IDB4MDQwRSwgMHgwQ30sDQo+PiArICAgICB7IDB4MDQwRiwg
MHgzMH0sDQo+PiArICAgICB7IDB4MzAzOCwgMHgwMH0sDQo+PiArICAgICB7IDB4MzAzQSwgMHgw
MH0sDQo+PiArICAgICB7IDB4MzAzQiwgMHgxMH0sDQo+PiArICAgICB7IDB4MzAwRCwgMHgwMH0s
DQo+PiArICAgICB7IDB4MDM0QywgMHgxMH0sDQo+PiArICAgICB7IDB4MDM0RCwgMHg3MH0sDQo+
PiArICAgICB7IDB4MDM0RSwgMHgwQ30sDQo+PiArICAgICB7IDB4MDM0RiwgMHgzMH0sDQo+PiAr
ICAgICB7IDB4MDIwMiwgMHgwQ30sDQo+PiArICAgICB7IDB4MDIwMywgMHg0Nn0sDQo+PiArICAg
ICB7IDB4MDIwNCwgMHgwMH0sDQo+PiArICAgICB7IDB4MDIwNSwgMHgwMH0sDQo+PiArICAgICB7
IDB4MDIwRSwgMHgwMX0sDQo+PiArICAgICB7IDB4MDIwRiwgMHgwMH0sDQo+PiArICAgICB7IDB4
MDIxMCwgMHgwMX0sDQo+PiArICAgICB7IDB4MDIxMSwgMHgwMH0sDQo+PiArICAgICB7IDB4MDIx
MiwgMHgwMX0sDQo+PiArICAgICB7IDB4MDIxMywgMHgwMH0sDQo+PiArICAgICB7IDB4MDIxNCwg
MHgwMX0sDQo+PiArICAgICB7IDB4MDIxNSwgMHgwMH0sDQo+PiArICAgICB7IDB4N0JDRCwgMHgw
MH0sDQo+PiArICAgICB7IDB4OTREQywgMHgyMH0sDQo+PiArICAgICB7IDB4OTRERCwgMHgyMH0s
DQo+PiArICAgICB7IDB4OTRERSwgMHgyMH0sDQo+PiArICAgICB7IDB4OTVEQywgMHgyMH0sDQo+
PiArICAgICB7IDB4OTVERCwgMHgyMH0sDQo+PiArICAgICB7IDB4OTVERSwgMHgyMH0sDQo+PiAr
ICAgICB7IDB4N0ZCMCwgMHgwMH0sDQo+PiArICAgICB7IDB4OTAxMCwgMHgzRX0sDQo+PiArICAg
ICB7IDB4OTQxOSwgMHg1MH0sDQo+PiArICAgICB7IDB4OTQxQiwgMHg1MH0sDQo+PiArICAgICB7
IDB4OTUxOSwgMHg1MH0sDQo+PiArICAgICB7IDB4OTUxQiwgMHg1MH0sDQo+PiArICAgICB7IDB4
MzAzMCwgMHgwMH0sDQo+PiArICAgICB7IDB4MzAzMiwgMHgwMH0sDQo+PiArICAgICB7IDB4MDIy
MCwgMHgwMH0sDQo+PiArfTsNCj4+ICsNCj4+ICtzdGF0aWMgY29uc3Qgc3RydWN0IGlteDI1OF9y
ZWcgbW9kZV8yMTA0XzE1NjBfcmVnc1tdID0gew0KPj4gKyAgICAgeyAweDAxMzYsIDB4MTN9LA0K
Pj4gKyAgICAgeyAweDAxMzcsIDB4MzN9LA0KPj4gKyAgICAgeyAweDMwNTEsIDB4MDB9LA0KPj4g
KyAgICAgeyAweDMwNTIsIDB4MDB9LA0KPj4gKyAgICAgeyAweDRFMjEsIDB4MTR9LA0KPj4gKyAg
ICAgeyAweDZCMTEsIDB4Q0Z9LA0KPj4gKyAgICAgeyAweDdGRjAsIDB4MDh9LA0KPj4gKyAgICAg
eyAweDdGRjEsIDB4MEZ9LA0KPj4gKyAgICAgeyAweDdGRjIsIDB4MDh9LA0KPj4gKyAgICAgeyAw
eDdGRjMsIDB4MUJ9LA0KPj4gKyAgICAgeyAweDdGRjQsIDB4MjN9LA0KPj4gKyAgICAgeyAweDdG
RjUsIDB4NjB9LA0KPj4gKyAgICAgeyAweDdGRjYsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdGRjcs
IDB4MDF9LA0KPj4gKyAgICAgeyAweDdGRjgsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdGRjksIDB4
Nzh9LA0KPj4gKyAgICAgeyAweDdGRkEsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdGRkIsIDB4MDB9
LA0KPj4gKyAgICAgeyAweDdGRkMsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdGRkQsIDB4MDB9LA0K
Pj4gKyAgICAgeyAweDdGRkUsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdGRkYsIDB4MDN9LA0KPj4g
KyAgICAgeyAweDdGNzYsIDB4MDN9LA0KPj4gKyAgICAgeyAweDdGNzcsIDB4RkV9LA0KPj4gKyAg
ICAgeyAweDdGQTgsIDB4MDN9LA0KPj4gKyAgICAgeyAweDdGQTksIDB4RkV9LA0KPj4gKyAgICAg
eyAweDdCMjQsIDB4ODF9LA0KPj4gKyAgICAgeyAweDdCMjUsIDB4MDB9LA0KPj4gKyAgICAgeyAw
eDY1NjQsIDB4MDd9LA0KPj4gKyAgICAgeyAweDZCMEQsIDB4NDF9LA0KPj4gKyAgICAgeyAweDY1
M0QsIDB4MDR9LA0KPj4gKyAgICAgeyAweDZCMDUsIDB4OEN9LA0KPj4gKyAgICAgeyAweDZCMDYs
IDB4Rjl9LA0KPj4gKyAgICAgeyAweDZCMDgsIDB4NjV9LA0KPj4gKyAgICAgeyAweDZCMDksIDB4
RkN9LA0KPj4gKyAgICAgeyAweDZCMEEsIDB4Q0Z9LA0KPj4gKyAgICAgeyAweDZCMEIsIDB4RDJ9
LA0KPj4gKyAgICAgeyAweDY3MDAsIDB4MEV9LA0KPj4gKyAgICAgeyAweDY3MDcsIDB4MEV9LA0K
Pj4gKyAgICAgeyAweDkxMDQsIDB4MDB9LA0KPj4gKyAgICAgeyAweDQ2NDgsIDB4N0Z9LA0KPj4g
KyAgICAgeyAweDc0MjAsIDB4MDB9LA0KPj4gKyAgICAgeyAweDc0MjEsIDB4MUN9LA0KPj4gKyAg
ICAgeyAweDc0MjIsIDB4MDB9LA0KPj4gKyAgICAgeyAweDc0MjMsIDB4RDd9LA0KPj4gKyAgICAg
eyAweDVGMDQsIDB4MDB9LA0KPj4gKyAgICAgeyAweDVGMDUsIDB4RUR9LA0KPj4gKyAgICAgeyAw
eDAxMTIsIDB4MEF9LA0KPj4gKyAgICAgeyAweDAxMTMsIDB4MEF9LA0KPj4gKyAgICAgeyAweDAx
MTQsIDB4MDN9LA0KPj4gKyAgICAgeyAweDAzNDIsIDB4MTR9LA0KPj4gKyAgICAgeyAweDAzNDMs
IDB4RTh9LA0KPj4gKyAgICAgeyAweDAzNDAsIDB4MDZ9LA0KPj4gKyAgICAgeyAweDAzNDEsIDB4
Mzh9LA0KPj4gKyAgICAgeyAweDAzNDQsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAzNDUsIDB4MDB9
LA0KPj4gKyAgICAgeyAweDAzNDYsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAzNDcsIDB4MDB9LA0K
Pj4gKyAgICAgeyAweDAzNDgsIDB4MTB9LA0KPj4gKyAgICAgeyAweDAzNDksIDB4NkZ9LA0KPj4g
KyAgICAgeyAweDAzNEEsIDB4MEN9LA0KPj4gKyAgICAgeyAweDAzNEIsIDB4MkV9LA0KPj4gKyAg
ICAgeyAweDAzODEsIDB4MDF9LA0KPj4gKyAgICAgeyAweDAzODMsIDB4MDF9LA0KPj4gKyAgICAg
eyAweDAzODUsIDB4MDF9LA0KPj4gKyAgICAgeyAweDAzODcsIDB4MDF9LA0KPj4gKyAgICAgeyAw
eDA5MDAsIDB4MDF9LA0KPj4gKyAgICAgeyAweDA5MDEsIDB4MTJ9LA0KPj4gKyAgICAgeyAweDA0
MDEsIDB4MDF9LA0KPj4gKyAgICAgeyAweDA0MDQsIDB4MDB9LA0KPj4gKyAgICAgeyAweDA0MDUs
IDB4MjB9LA0KPj4gKyAgICAgeyAweDA0MDgsIDB4MDB9LA0KPj4gKyAgICAgeyAweDA0MDksIDB4
MDJ9LA0KPj4gKyAgICAgeyAweDA0MEEsIDB4MDB9LA0KPj4gKyAgICAgeyAweDA0MEIsIDB4MDB9
LA0KPj4gKyAgICAgeyAweDA0MEMsIDB4MTB9LA0KPj4gKyAgICAgeyAweDA0MEQsIDB4NkF9LA0K
Pj4gKyAgICAgeyAweDA0MEUsIDB4MDZ9LA0KPj4gKyAgICAgeyAweDA0MEYsIDB4MTh9LA0KPj4g
KyAgICAgeyAweDMwMzgsIDB4MDB9LA0KPj4gKyAgICAgeyAweDMwM0EsIDB4MDB9LA0KPj4gKyAg
ICAgeyAweDMwM0IsIDB4MTB9LA0KPj4gKyAgICAgeyAweDMwMEQsIDB4MDB9LA0KPj4gKyAgICAg
eyAweDAzNEMsIDB4MDh9LA0KPj4gKyAgICAgeyAweDAzNEQsIDB4Mzh9LA0KPj4gKyAgICAgeyAw
eDAzNEUsIDB4MDZ9LA0KPj4gKyAgICAgeyAweDAzNEYsIDB4MTh9LA0KPj4gKyAgICAgeyAweDAy
MDIsIDB4MDZ9LA0KPj4gKyAgICAgeyAweDAyMDMsIDB4MkV9LA0KPj4gKyAgICAgeyAweDAyMDQs
IDB4MDB9LA0KPj4gKyAgICAgeyAweDAyMDUsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAyMEUsIDB4
MDF9LA0KPj4gKyAgICAgeyAweDAyMEYsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAyMTAsIDB4MDF9
LA0KPj4gKyAgICAgeyAweDAyMTEsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAyMTIsIDB4MDF9LA0K
Pj4gKyAgICAgeyAweDAyMTMsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAyMTQsIDB4MDF9LA0KPj4g
KyAgICAgeyAweDAyMTUsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdCQ0QsIDB4MDF9LA0KPj4gKyAg
ICAgeyAweDk0REMsIDB4MjB9LA0KPj4gKyAgICAgeyAweDk0REQsIDB4MjB9LA0KPj4gKyAgICAg
eyAweDk0REUsIDB4MjB9LA0KPj4gKyAgICAgeyAweDk1REMsIDB4MjB9LA0KPj4gKyAgICAgeyAw
eDk1REQsIDB4MjB9LA0KPj4gKyAgICAgeyAweDk1REUsIDB4MjB9LA0KPj4gKyAgICAgeyAweDdG
QjAsIDB4MDB9LA0KPj4gKyAgICAgeyAweDkwMTAsIDB4M0V9LA0KPj4gKyAgICAgeyAweDk0MTks
IDB4NTB9LA0KPj4gKyAgICAgeyAweDk0MUIsIDB4NTB9LA0KPj4gKyAgICAgeyAweDk1MTksIDB4
NTB9LA0KPj4gKyAgICAgeyAweDk1MUIsIDB4NTB9LA0KPj4gKyAgICAgeyAweDMwMzAsIDB4MDB9
LA0KPj4gKyAgICAgeyAweDMwMzIsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAyMjAsIDB4MDB9LA0K
Pj4gK307DQo+PiArDQo+PiArc3RhdGljIGNvbnN0IHN0cnVjdCBpbXgyNThfcmVnIG1vZGVfMTA0
OF83ODBfcmVnc1tdID0gew0KPj4gKyAgICAgeyAweDAxMzYsIDB4MTN9LA0KPj4gKyAgICAgeyAw
eDAxMzcsIDB4MzN9LA0KPj4gKyAgICAgeyAweDMwNTEsIDB4MDB9LA0KPj4gKyAgICAgeyAweDMw
NTIsIDB4MDB9LA0KPj4gKyAgICAgeyAweDRFMjEsIDB4MTR9LA0KPj4gKyAgICAgeyAweDZCMTEs
IDB4Q0Z9LA0KPj4gKyAgICAgeyAweDdGRjAsIDB4MDh9LA0KPj4gKyAgICAgeyAweDdGRjEsIDB4
MEZ9LA0KPj4gKyAgICAgeyAweDdGRjIsIDB4MDh9LA0KPj4gKyAgICAgeyAweDdGRjMsIDB4MUJ9
LA0KPj4gKyAgICAgeyAweDdGRjQsIDB4MjN9LA0KPj4gKyAgICAgeyAweDdGRjUsIDB4NjB9LA0K
Pj4gKyAgICAgeyAweDdGRjYsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdGRjcsIDB4MDF9LA0KPj4g
KyAgICAgeyAweDdGRjgsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdGRjksIDB4Nzh9LA0KPj4gKyAg
ICAgeyAweDdGRkEsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdGRkIsIDB4MDB9LA0KPj4gKyAgICAg
eyAweDdGRkMsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdGRkQsIDB4MDB9LA0KPj4gKyAgICAgeyAw
eDdGRkUsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdGRkYsIDB4MDN9LA0KPj4gKyAgICAgeyAweDdG
NzYsIDB4MDN9LA0KPj4gKyAgICAgeyAweDdGNzcsIDB4RkV9LA0KPj4gKyAgICAgeyAweDdGQTgs
IDB4MDN9LA0KPj4gKyAgICAgeyAweDdGQTksIDB4RkV9LA0KPj4gKyAgICAgeyAweDdCMjQsIDB4
ODF9LA0KPj4gKyAgICAgeyAweDdCMjUsIDB4MDB9LA0KPj4gKyAgICAgeyAweDY1NjQsIDB4MDd9
LA0KPj4gKyAgICAgeyAweDZCMEQsIDB4NDF9LA0KPj4gKyAgICAgeyAweDY1M0QsIDB4MDR9LA0K
Pj4gKyAgICAgeyAweDZCMDUsIDB4OEN9LA0KPj4gKyAgICAgeyAweDZCMDYsIDB4Rjl9LA0KPj4g
KyAgICAgeyAweDZCMDgsIDB4NjV9LA0KPj4gKyAgICAgeyAweDZCMDksIDB4RkN9LA0KPj4gKyAg
ICAgeyAweDZCMEEsIDB4Q0Z9LA0KPj4gKyAgICAgeyAweDZCMEIsIDB4RDJ9LA0KPj4gKyAgICAg
eyAweDY3MDAsIDB4MEV9LA0KPj4gKyAgICAgeyAweDY3MDcsIDB4MEV9LA0KPj4gKyAgICAgeyAw
eDkxMDQsIDB4MDB9LA0KPj4gKyAgICAgeyAweDQ2NDgsIDB4N0Z9LA0KPj4gKyAgICAgeyAweDc0
MjAsIDB4MDB9LA0KPj4gKyAgICAgeyAweDc0MjEsIDB4MUN9LA0KPj4gKyAgICAgeyAweDc0MjIs
IDB4MDB9LA0KPj4gKyAgICAgeyAweDc0MjMsIDB4RDd9LA0KPj4gKyAgICAgeyAweDVGMDQsIDB4
MDB9LA0KPj4gKyAgICAgeyAweDVGMDUsIDB4RUR9LA0KPj4gKyAgICAgeyAweDAxMTIsIDB4MEF9
LA0KPj4gKyAgICAgeyAweDAxMTMsIDB4MEF9LA0KPj4gKyAgICAgeyAweDAxMTQsIDB4MDN9LA0K
Pj4gKyAgICAgeyAweDAzNDIsIDB4MTR9LA0KPj4gKyAgICAgeyAweDAzNDMsIDB4RTh9LA0KPj4g
KyAgICAgeyAweDAzNDAsIDB4MDN9LA0KPj4gKyAgICAgeyAweDAzNDEsIDB4NEN9LA0KPj4gKyAg
ICAgeyAweDAzNDQsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAzNDUsIDB4MDB9LA0KPj4gKyAgICAg
eyAweDAzNDYsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAzNDcsIDB4MDB9LA0KPj4gKyAgICAgeyAw
eDAzNDgsIDB4MTB9LA0KPj4gKyAgICAgeyAweDAzNDksIDB4NkZ9LA0KPj4gKyAgICAgeyAweDAz
NEEsIDB4MEN9LA0KPj4gKyAgICAgeyAweDAzNEIsIDB4MkV9LA0KPj4gKyAgICAgeyAweDAzODEs
IDB4MDF9LA0KPj4gKyAgICAgeyAweDAzODMsIDB4MDF9LA0KPj4gKyAgICAgeyAweDAzODUsIDB4
MDF9LA0KPj4gKyAgICAgeyAweDAzODcsIDB4MDF9LA0KPj4gKyAgICAgeyAweDA5MDAsIDB4MDF9
LA0KPj4gKyAgICAgeyAweDA5MDEsIDB4MTR9LA0KPj4gKyAgICAgeyAweDA0MDEsIDB4MDF9LA0K
Pj4gKyAgICAgeyAweDA0MDQsIDB4MDB9LA0KPj4gKyAgICAgeyAweDA0MDUsIDB4NDB9LA0KPj4g
KyAgICAgeyAweDA0MDgsIDB4MDB9LA0KPj4gKyAgICAgeyAweDA0MDksIDB4MDZ9LA0KPj4gKyAg
ICAgeyAweDA0MEEsIDB4MDB9LA0KPj4gKyAgICAgeyAweDA0MEIsIDB4MDB9LA0KPj4gKyAgICAg
eyAweDA0MEMsIDB4MTB9LA0KPj4gKyAgICAgeyAweDA0MEQsIDB4NjR9LA0KPj4gKyAgICAgeyAw
eDA0MEUsIDB4MDN9LA0KPj4gKyAgICAgeyAweDA0MEYsIDB4MEN9LA0KPj4gKyAgICAgeyAweDMw
MzgsIDB4MDB9LA0KPj4gKyAgICAgeyAweDMwM0EsIDB4MDB9LA0KPj4gKyAgICAgeyAweDMwM0Is
IDB4MTB9LA0KPj4gKyAgICAgeyAweDMwMEQsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAzNEMsIDB4
MDR9LA0KPj4gKyAgICAgeyAweDAzNEQsIDB4MTh9LA0KPj4gKyAgICAgeyAweDAzNEUsIDB4MDN9
LA0KPj4gKyAgICAgeyAweDAzNEYsIDB4MEN9LA0KPj4gKyAgICAgeyAweDAyMDIsIDB4MDN9LA0K
Pj4gKyAgICAgeyAweDAyMDMsIDB4NDJ9LA0KPj4gKyAgICAgeyAweDAyMDQsIDB4MDB9LA0KPj4g
KyAgICAgeyAweDAyMDUsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAyMEUsIDB4MDF9LA0KPj4gKyAg
ICAgeyAweDAyMEYsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAyMTAsIDB4MDF9LA0KPj4gKyAgICAg
eyAweDAyMTEsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAyMTIsIDB4MDF9LA0KPj4gKyAgICAgeyAw
eDAyMTMsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAyMTQsIDB4MDF9LA0KPj4gKyAgICAgeyAweDAy
MTUsIDB4MDB9LA0KPj4gKyAgICAgeyAweDdCQ0QsIDB4MDB9LA0KPj4gKyAgICAgeyAweDk0REMs
IDB4MjB9LA0KPj4gKyAgICAgeyAweDk0REQsIDB4MjB9LA0KPj4gKyAgICAgeyAweDk0REUsIDB4
MjB9LA0KPj4gKyAgICAgeyAweDk1REMsIDB4MjB9LA0KPj4gKyAgICAgeyAweDk1REQsIDB4MjB9
LA0KPj4gKyAgICAgeyAweDk1REUsIDB4MjB9LA0KPj4gKyAgICAgeyAweDdGQjAsIDB4MDB9LA0K
Pj4gKyAgICAgeyAweDkwMTAsIDB4M0V9LA0KPj4gKyAgICAgeyAweDk0MTksIDB4NTB9LA0KPj4g
KyAgICAgeyAweDk0MUIsIDB4NTB9LA0KPj4gKyAgICAgeyAweDk1MTksIDB4NTB9LA0KPj4gKyAg
ICAgeyAweDk1MUIsIDB4NTB9LA0KPj4gKyAgICAgeyAweDMwMzAsIDB4MDB9LA0KPj4gKyAgICAg
eyAweDMwMzIsIDB4MDB9LA0KPj4gKyAgICAgeyAweDAyMjAsIDB4MDB9LA0KPj4gK307DQo+PiAr
DQo+PiArc3RhdGljIGNvbnN0IGNoYXIgKiBjb25zdCBpbXgyNThfdGVzdF9wYXR0ZXJuX21lbnVb
XSA9IHsNCj4+ICsgICAgICJEaXNhYmxlZCIsDQo+PiArICAgICAiVmVydGljYWwgQ29sb3IgQmFy
IFR5cGUgMSIsDQo+PiArICAgICAiVmVydGljYWwgQ29sb3IgQmFyIFR5cGUgMiIsDQo+PiArICAg
ICAiVmVydGljYWwgQ29sb3IgQmFyIFR5cGUgMyIsDQo+PiArICAgICAiVmVydGljYWwgQ29sb3Ig
QmFyIFR5cGUgNCINCj4+ICt9Ow0KPj4gKw0KPj4gKy8qIENvbmZpZ3VyYXRpb25zIGZvciBzdXBw
b3J0ZWQgbGluayBmcmVxdWVuY2llcyAqLw0KPj4gKyNkZWZpbmUgSU1YMjU4X0xJTktfRlJFUV82
MzRNSFogICAgICA2MzM2MDAwMDBVTEwNCj4+ICsjZGVmaW5lIElNWDI1OF9MSU5LX0ZSRVFfMzIw
TUhaICAgICAgMzIwMDAwMDAwVUxMDQo+PiArDQo+PiArLyoNCj4+ICsgKiBwaXhlbF9yYXRlID0g
bGlua19mcmVxICogZGF0YS1yYXRlICogbnJfb2ZfbGFuZXMgLyANCj4+ICtiaXRzX3Blcl9zYW1w
bGUNCj4+ICsgKiBkYXRhIHJhdGUgPT4gZG91YmxlIGRhdGEgcmF0ZTsgbnVtYmVyIG9mIGxhbmVz
ID0+IDQ7IGJpdHMgcGVyIA0KPj4gK3BpeGVsID0+IDEwICAqLyBzdGF0aWMgdTY0IGxpbmtfZnJl
cV90b19waXhlbF9yYXRlKHU2NCBmKSB7DQo+PiArICAgICBmICo9IDIgKiA0Ow0KPj4gKyAgICAg
ZG9fZGl2KGYsIDEwKTsNCj4+ICsNCj4+ICsgICAgIHJldHVybiBmOw0KPj4gK30NCj4+ICsNCj4+
ICsvKiBNZW51IGl0ZW1zIGZvciBMSU5LX0ZSRVEgVjRMMiBjb250cm9sICovIHN0YXRpYyBjb25z
dCBzNjQgDQo+PiArbGlua19mcmVxX21lbnVfaXRlbXNbXSA9IHsNCj4+ICsgICAgIElNWDI1OF9M
SU5LX0ZSRVFfNjM0TUhaLA0KPj4gKyAgICAgSU1YMjU4X0xJTktfRlJFUV8zMjBNSFosDQo+PiAr
fTsNCj4+ICsNCj4+ICsvKiBMaW5rIGZyZXF1ZW5jeSBjb25maWdzICovDQo+PiArc3RhdGljIGNv
bnN0IHN0cnVjdCBpbXgyNThfbGlua19mcmVxX2NvbmZpZyBsaW5rX2ZyZXFfY29uZmlnc1tdID0g
ew0KPj4gKyAgICAgew0KPj4gKyAgICAgICAgICAgICAucGl4ZWxzX3Blcl9saW5lID0gSU1YMjU4
X1BQTF9ERUZBVUxULA0KPj4gKyAgICAgICAgICAgICAucmVnX2xpc3QgPSB7DQo+PiArICAgICAg
ICAgICAgICAgICAgICAgLm51bV9vZl9yZWdzID0gQVJSQVlfU0laRShtaXBpX2RhdGFfcmF0ZV8x
MjY3bWJwcyksDQo+PiArICAgICAgICAgICAgICAgICAgICAgLnJlZ3MgPSBtaXBpX2RhdGFfcmF0
ZV8xMjY3bWJwcywNCj4+ICsgICAgICAgICAgICAgfQ0KPj4gKyAgICAgfSwNCj4+ICsgICAgIHsN
Cj4+ICsgICAgICAgICAgICAgLnBpeGVsc19wZXJfbGluZSA9IElNWDI1OF9QUExfREVGQVVMVCwN
Cj4+ICsgICAgICAgICAgICAgLnJlZ19saXN0ID0gew0KPj4gKyAgICAgICAgICAgICAgICAgICAg
IC5udW1fb2ZfcmVncyA9IEFSUkFZX1NJWkUobWlwaV9kYXRhX3JhdGVfNjQwbWJwcyksDQo+PiAr
ICAgICAgICAgICAgICAgICAgICAgLnJlZ3MgPSBtaXBpX2RhdGFfcmF0ZV82NDBtYnBzLA0KPj4g
KyAgICAgICAgICAgICB9DQo+PiArICAgICB9LA0KPj4gK307DQoNCkkgYWxzbyBoYWQgY29tbWVu
dHMgZm9yIHVzaW5nIGV4cGxpY2l0IGluZGljZXMgaW4gdGhpcyBhcnJheSwgdG8gYXZvaWQgbWlz
dGFrZXMgaW4gc3VwcG9ydGVkX21vZGVzW10gYmVsb3cuDQoNCj4+ICsNCj4+ICsvKiBNb2RlIGNv
bmZpZ3MgKi8NCj4+ICtzdGF0aWMgY29uc3Qgc3RydWN0IGlteDI1OF9tb2RlIHN1cHBvcnRlZF9t
b2Rlc1tdID0gew0KPj4gKyAgICAgew0KPj4gKyAgICAgICAgICAgICAud2lkdGggPSA0MjA4LA0K
Pj4gKyAgICAgICAgICAgICAuaGVpZ2h0ID0gMzExOCwNCj4+ICsgICAgICAgICAgICAgLnZ0c19k
ZWYgPSBJTVgyNThfVlRTXzMwRlBTLA0KPj4gKyAgICAgICAgICAgICAudnRzX21pbiA9IElNWDI1
OF9WVFNfMzBGUFMsDQo+PiArICAgICAgICAgICAgIC5yZWdfbGlzdCA9IHsNCj4+ICsgICAgICAg
ICAgICAgICAgICAgICAubnVtX29mX3JlZ3MgPSBBUlJBWV9TSVpFKG1vZGVfNDIwOHgzMTE4X3Jl
Z3MpLA0KPj4gKyAgICAgICAgICAgICAgICAgICAgIC5yZWdzID0gbW9kZV80MjA4eDMxMThfcmVn
cywNCj4+ICsgICAgICAgICAgICAgfSwNCj4+ICsgICAgICAgICAgICAgLmxpbmtfZnJlcV9pbmRl
eCA9IDAsDQo+PiArICAgICB9LA0KPj4gKyAgICAgew0KPj4gKyAgICAgICAgICAgICAud2lkdGgg
PSAyMTA0LA0KPj4gKyAgICAgICAgICAgICAuaGVpZ2h0ID0gMTU2MCwNCj4+ICsgICAgICAgICAg
ICAgLnZ0c19kZWYgPSBJTVgyNThfVlRTXzMwRlBTLA0KPj4gKyAgICAgICAgICAgICAudnRzX21p
biA9IDE2MDgsDQo+PiArICAgICAgICAgICAgIC5yZWdfbGlzdCA9IHsNCj4+ICsgICAgICAgICAg
ICAgICAgICAgICAubnVtX29mX3JlZ3MgPSBBUlJBWV9TSVpFKG1vZGVfMjEwNF8xNTYwX3JlZ3Mp
LA0KPj4gKyAgICAgICAgICAgICAgICAgICAgIC5yZWdzID0gbW9kZV8yMTA0XzE1NjBfcmVncywN
Cj4+ICsgICAgICAgICAgICAgfSwNCj4+ICsgICAgICAgICAgICAgLmxpbmtfZnJlcV9pbmRleCA9
IDEsDQo+PiArICAgICB9LA0KPj4gKyAgICAgew0KPj4gKyAgICAgICAgICAgICAud2lkdGggPSAx
MDQ4LA0KPj4gKyAgICAgICAgICAgICAuaGVpZ2h0ID0gNzgwLA0KPj4gKyAgICAgICAgICAgICAu
dnRzX2RlZiA9IElNWDI1OF9WVFNfMzBGUFMsDQo+PiArICAgICAgICAgICAgIC52dHNfbWluID0g
ODA0LA0KPj4gKyAgICAgICAgICAgICAucmVnX2xpc3QgPSB7DQo+PiArICAgICAgICAgICAgICAg
ICAgICAgLm51bV9vZl9yZWdzID0gQVJSQVlfU0laRShtb2RlXzEwNDhfNzgwX3JlZ3MpLA0KPj4g
KyAgICAgICAgICAgICAgICAgICAgIC5yZWdzID0gbW9kZV8xMDQ4Xzc4MF9yZWdzLA0KPj4gKyAg
ICAgICAgICAgICB9LA0KPj4gKyAgICAgICAgICAgICAubGlua19mcmVxX2luZGV4ID0gMSwNCj4+
ICsgICAgIH0sDQo+PiArfTsNCj4+ICsNCj4+ICtzdHJ1Y3QgaW14MjU4IHsNCj4+ICsgICAgIHN0
cnVjdCB2NGwyX3N1YmRldiBzZDsNCj4+ICsgICAgIHN0cnVjdCBtZWRpYV9wYWQgcGFkOw0KPj4g
Kw0KPj4gKyAgICAgc3RydWN0IHY0bDJfY3RybF9oYW5kbGVyIGN0cmxfaGFuZGxlcjsNCj4+ICsg
ICAgIC8qIFY0TDIgQ29udHJvbHMgKi8NCj4+ICsgICAgIHN0cnVjdCB2NGwyX2N0cmwgKmxpbmtf
ZnJlcTsNCj4+ICsgICAgIHN0cnVjdCB2NGwyX2N0cmwgKnBpeGVsX3JhdGU7DQo+PiArICAgICBz
dHJ1Y3QgdjRsMl9jdHJsICp2Ymxhbms7DQo+PiArICAgICBzdHJ1Y3QgdjRsMl9jdHJsICpoYmxh
bms7DQo+PiArICAgICBzdHJ1Y3QgdjRsMl9jdHJsICpleHBvc3VyZTsNCj4+ICsNCj4+ICsgICAg
IC8qIEN1cnJlbnQgbW9kZSAqLw0KPj4gKyAgICAgY29uc3Qgc3RydWN0IGlteDI1OF9tb2RlICpj
dXJfbW9kZTsNCj4+ICsNCj4+ICsgICAgIC8qIE11dGV4IGZvciBzZXJpYWxpemVkIGFjY2VzcyAq
Lw0KPj4gKyAgICAgc3RydWN0IG11dGV4IG11dGV4Ow0KPj4gKyAgICAgLyoNCj4+ICsgICAgICAq
IFByb3RlY3Qgc2Vuc29yIG1vZHVsZSBzZXQgcGFkIGZvcm1hdCBhbmQgc3RhcnQgc3RyZWFtaW5n
IG5vcm1hbGx5Lg0KPj4gKyAgICAgICovDQo+PiArDQo+PiArICAgICAvKiBTdHJlYW1pbmcgb24v
b2ZmICovDQo+PiArICAgICBib29sIHN0cmVhbWluZzsNCj4+ICt9Ow0KPj4gKw0KPj4gKyNkZWZp
bmUgdG9faW14MjU4KF9zZCkgICAgICAgY29udGFpbmVyX29mKF9zZCwgc3RydWN0IGlteDI1OCwg
c2QpDQo+PiArDQo+PiArLyogUmVhZCByZWdpc3RlcnMgdXAgdG8gMiBhdCBhIHRpbWUgKi8gc3Rh
dGljIGludCANCj4+ICtpbXgyNThfcmVhZF9yZWcoc3RydWN0IGlteDI1OCAqaW14MjU4LCB1MTYg
cmVnLCB1MzIgbGVuLCB1MzIgKnZhbCkgew0KPj4gKyAgICAgc3RydWN0IGkyY19jbGllbnQgKmNs
aWVudCA9IHY0bDJfZ2V0X3N1YmRldmRhdGEoJmlteDI1OC0+c2QpOw0KPj4gKyAgICAgc3RydWN0
IGkyY19tc2cgbXNnc1syXTsNCj4+ICsgICAgIHU4IGFkZHJfYnVmWzJdID0geyByZWcgPj4gOCwg
cmVnICYgMHhmZiB9Ow0KPj4gKyAgICAgdTggZGF0YV9idWZbNF0gPSB7IDAsIH07DQo+PiArICAg
ICBpbnQgcmV0Ow0KPj4gKw0KPj4gKyAgICAgaWYgKGxlbiA+IDQpDQo+PiArICAgICAgICAgICAg
IHJldHVybiAtRUlOVkFMOw0KPj4gKw0KPj4gKyAgICAgLyogV3JpdGUgcmVnaXN0ZXIgYWRkcmVz
cyAqLw0KPj4gKyAgICAgbXNnc1swXS5hZGRyID0gY2xpZW50LT5hZGRyOw0KPj4gKyAgICAgbXNn
c1swXS5mbGFncyA9IDA7DQo+PiArICAgICBtc2dzWzBdLmxlbiA9IEFSUkFZX1NJWkUoYWRkcl9i
dWYpOw0KPj4gKyAgICAgbXNnc1swXS5idWYgPSBhZGRyX2J1ZjsNCj4+ICsNCj4+ICsgICAgIC8q
IFJlYWQgZGF0YSBmcm9tIHJlZ2lzdGVyICovDQo+PiArICAgICBtc2dzWzFdLmFkZHIgPSBjbGll
bnQtPmFkZHI7DQo+PiArICAgICBtc2dzWzFdLmZsYWdzID0gSTJDX01fUkQ7DQo+PiArICAgICBt
c2dzWzFdLmxlbiA9IGxlbjsNCj4+ICsgICAgIG1zZ3NbMV0uYnVmID0gJmRhdGFfYnVmWzQgLSBs
ZW5dOw0KPj4gKw0KPj4gKyAgICAgcmV0ID0gaTJjX3RyYW5zZmVyKGNsaWVudC0+YWRhcHRlciwg
bXNncywgQVJSQVlfU0laRShtc2dzKSk7DQo+PiArICAgICBpZiAocmV0ICE9IEFSUkFZX1NJWkUo
bXNncykpDQo+PiArICAgICAgICAgICAgIHJldHVybiAtRUlPOw0KPj4gKw0KPj4gKyAgICAgKnZh
bCA9IGdldF91bmFsaWduZWRfYmUzMihkYXRhX2J1Zik7DQo+PiArDQo+PiArICAgICByZXR1cm4g
MDsNCj4+ICt9DQo+PiArDQo+PiArLyogV3JpdGUgcmVnaXN0ZXJzIHVwIHRvIDIgYXQgYSB0aW1l
ICovIHN0YXRpYyBpbnQgDQo+PiAraW14MjU4X3dyaXRlX3JlZyhzdHJ1Y3QgaW14MjU4ICppbXgy
NTgsIHUxNiByZWcsIHUzMiBsZW4sIHUzMiB2YWwpIHsNCj4+ICsgICAgIHN0cnVjdCBpMmNfY2xp
ZW50ICpjbGllbnQgPSB2NGwyX2dldF9zdWJkZXZkYXRhKCZpbXgyNTgtPnNkKTsNCj4+ICsgICAg
IHU4IF9fYnVmWzZdLCAqYnVmID0gX19idWY7DQo+PiArDQo+PiArICAgICBpZiAobGVuID4gNCkN
Cj4+ICsgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+PiArDQo+PiArICAgICAqYnVmKysg
PSByZWcgPj4gODsNCj4+ICsgICAgICpidWYrKyA9IHJlZyAmIDB4ZmY7DQo+DQo+IFlvdSBhc3Np
Z24gcmVnIGluIHZhcmlhYmxlIGRlY2xhcmF0aW9uIGluIGlteDI1OF9yZWFkX3JlZygpLiBDb3Vs
ZCB5b3UgDQo+IGRvIHRoZSBzYW1lIGhlcmU/IE9yIGV2ZW4gYmV0dGVyLCB1c2UgcHV0X3VuYWxp
Z25lZF9iZTE2KCkuDQo+DQo+IEkgd2Fzbid0IGF3YXJlIG9mIHRoZXNlIGZ1bmN0aW9ucywgdGhh
bmtzIGZvciBpbnRyb2R1Y2luZyB0aGVtIHRvIG1lLiANCj4gOi0pDQo+DQo+IFlvdSBjYW4gdGhl
biByZW1vdmUgYnVmIGFuZCByZW5hbWUgX19idWYgYXMgYnVmLg0KDQpJIGJlbGlldmUgSSBnYXZl
IGFuIGV4YWN0IGltcGxlbWVudGF0aW9uLCB3aXRob3V0IHRoYXQgcHJvYmxlbSwgaW4gbXkgcHJl
dmlvdXMgY29tbWVudHMgYWN0dWFsbHkuDQoNCkFuZHksIHBsZWFzZSwgcmVhbGx5IHBsZWFzZSwg
Z28gdGhyb3VnaCBhbGwgdGhlIGNvbW1lbnRzIGluIG15IHJlcGx5IHRvIHY2IG9uIHRoZSBsaXN0
IGFuZCBtYWtlIHN1cmUgdGhhdCB0aGV5IGFyZSBhbGwgYWRkcmVzc2VkLiBQZXJoYXBzIHJlcGx5
IHRvIGl0LCB3aXRoICJPa2F5IiBuZXh0IHRvIGVhY2ggY29tbWVudCwgdG8gbWFrZSBzdXJlIHNv
bWUgb2YgdGhlIG1lc3NhZ2Ugd2FzIG5vdCBsb3N0IGR1ZSB0byBzb21lIHdlaXJkIG1haWwgY2xp
ZW50IHNldHRpbmdzLg0KDQpCZXN0IHJlZ2FyZHMsDQpUb21hc3oNCg==
