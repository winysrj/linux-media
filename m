Return-path: <mchehab@pedra>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:54612 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390Ab1DGFZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Apr 2011 01:25:40 -0400
From: Kassey Li <ygli@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Qing Xu <qingx@marvell.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Wed, 6 Apr 2011 22:21:13 -0700
Subject: RE: How to support MIPI CSI-2 controller in soc-camera framework?
Message-ID: <4737A960563B524DA805CA602BE04B30601048A4CD@SC-VEXCH2.marvell.com>
References: <1294368595-2518-1-git-send-email-qingx@marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040171EE@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101100853490.24479@axis700.grange>
 <201101101133.01636.laurent.pinchart@ideasonboard.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF237@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101171826340.16051@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF2EF@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101181811590.19950@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF54D@SC-VEXCH2.marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF5AF@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101191701430.620@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF80C@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1102040838280.14717@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102040838280.14717@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

SGksIEd1ZW5uYWRpOg0KCVNvcnJ5IGZvciB0aGUgbGF0ZSENCgkiSSB3b3VsZCBsZWF2ZSB0aGUg
Y2hvaWNlIG9mIGEgY29ubmVjdGlvbiB0byB0aGUgcGxhdGZvcm0gDQpjb2RlLiIgIEkgYWdyZWUg
d2l0aCB5b3Ugb24gdGhpcywgc2luY2UgSFcgYm9hcmQgd2lsbCBvbmx5IHN1cHBvcnQgTUlQSSBv
ciBwYXJhbGxlbCBldmVuIHRoZSBzZW5zb3INCmNhbiBzdXBwb3J0IGJvdGguDQoNCglQbGVhc2Ug
cmV2aWV3ICEgdGhhbmtzIGZvciB5b3VyIHRpbWUuDQoNClN1YmplY3Q6IFtQQVRDSF0gVjRML0RW
QjogVjRMMjogYWRkIE1JUEkgYnVzIGZsYWdzDQoNClNpZ25lZC1vZmYtYnk6IEthc3NleSBMZWUg
PHlnbGlAbWFydmVsbC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBRaW5nIFh1IDxxaW5neEBtYXJ2ZWxs
LmNvbT4NCi0tLQ0KIGluY2x1ZGUvbWVkaWEvc29jX2NhbWVyYS5oIHwgICAxMyArKysrKysrKyst
LS0tDQogMSBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQoN
CmRpZmYgLS1naXQgYS9pbmNsdWRlL21lZGlhL3NvY19jYW1lcmEuaCBiL2luY2x1ZGUvbWVkaWEv
c29jX2NhbWVyYS5oDQppbmRleCA5Mzg2ZGI4Li40ODBlM2U5IDEwMDY0NA0KLS0tIGEvaW5jbHVk
ZS9tZWRpYS9zb2NfY2FtZXJhLmgNCisrKyBiL2luY2x1ZGUvbWVkaWEvc29jX2NhbWVyYS5oDQpA
QCAtOTUsNyArOTUsMTIgQEAgc3RydWN0IHNvY19jYW1lcmFfaG9zdF9vcHMgew0KICNkZWZpbmUg
U09DQU1fU0VOU09SX0lOVkVSVF9IU1lOQwkoMSA8PCAyKQ0KICNkZWZpbmUgU09DQU1fU0VOU09S
X0lOVkVSVF9WU1lOQwkoMSA8PCAzKQ0KICNkZWZpbmUgU09DQU1fU0VOU09SX0lOVkVSVF9EQVRB
CSgxIDw8IDQpDQotDQorI2RlZmluZSBTT0NBTV9NSVBJXzFMQU5FCSgxIDw8IDE3KQ0KKyNkZWZp
bmUgU09DQU1fTUlQSV8yTEFORQkoMSA8PCAxOCkNCisjZGVmaW5lIFNPQ0FNX01JUElfM0xBTkUJ
KDEgPDwgMTkpDQorI2RlZmluZSBTT0NBTV9NSVBJXzRMQU5FCSgxIDw8IDIwKQ0KKyNkZWZpbmUg
U09DQU1fTUlQSQkoU09DQU1fTUlQSV8xTEFORSB8IFNPQ0FNX01JUElfMkxBTkUgfCBcDQorCQkJ
U09DQU1fTUlQSV8zTEFORSB8IFNPQ0FNX01JUElfNExBTkUpDQogc3RydWN0IGkyY19ib2FyZF9p
bmZvOw0KIHN0cnVjdCByZWd1bGF0b3JfYnVsa19kYXRhOw0KIA0KQEAgLTI1OSw3ICsyNjQsNyBA
QCBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgc29jX2NhbWVyYV9idXNfcGFyYW1fY29tcGF0
aWJsZSgNCiAJCQl1bnNpZ25lZCBsb25nIGNhbWVyYV9mbGFncywgdW5zaWduZWQgbG9uZyBidXNf
ZmxhZ3MpDQogew0KIAl1bnNpZ25lZCBsb25nIGNvbW1vbl9mbGFncywgaHN5bmMsIHZzeW5jLCBw
Y2xrLCBkYXRhLCBidXN3aWR0aCwgbW9kZTsNCi0NCisJdW5zaWduZWQgbG9uZyBtaXBpOw0KIAlj
b21tb25fZmxhZ3MgPSBjYW1lcmFfZmxhZ3MgJiBidXNfZmxhZ3M7DQogDQogCWhzeW5jID0gY29t
bW9uX2ZsYWdzICYgKFNPQ0FNX0hTWU5DX0FDVElWRV9ISUdIIHwgU09DQU1fSFNZTkNfQUNUSVZF
X0xPVyk7DQpAQCAtMjY4LDggKzI3Myw4IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBz
b2NfY2FtZXJhX2J1c19wYXJhbV9jb21wYXRpYmxlKA0KIAlkYXRhID0gY29tbW9uX2ZsYWdzICYg
KFNPQ0FNX0RBVEFfQUNUSVZFX0hJR0ggfCBTT0NBTV9EQVRBX0FDVElWRV9MT1cpOw0KIAltb2Rl
ID0gY29tbW9uX2ZsYWdzICYgKFNPQ0FNX01BU1RFUiB8IFNPQ0FNX1NMQVZFKTsNCiAJYnVzd2lk
dGggPSBjb21tb25fZmxhZ3MgJiBTT0NBTV9EQVRBV0lEVEhfTUFTSzsNCi0NCi0JcmV0dXJuICgh
aHN5bmMgfHwgIXZzeW5jIHx8ICFwY2xrIHx8ICFkYXRhIHx8ICFtb2RlIHx8ICFidXN3aWR0aCkg
PyAwIDoNCisJbWlwaSA9IGNvbW1vbl9mbGFncyAmIFNPQ0FNX01JUEk7DQorCXJldHVybiAoKCFo
c3luYyB8fCAhdnN5bmMgfHwgIXBjbGsgfHwgIWRhdGEgfHwgIW1vZGUgfHwgIWJ1c3dpZHRoKSAm
JiAoIW1pcGkpKSA/IDAgOg0KIAkJY29tbW9uX2ZsYWdzOw0KIH0NCg0KDQpCZXN0IHJlZ2FyZHMN
Ckthc3NleSANCkVtYWlsOiB5Z2xpQG1hcnZlbGwuY29tDQpBcHBsaWNhdGlvbiBQcm9jZXNzb3Ig
U3lzdGVtcyBFbmdpbmVlcmluZywgTWFydmVsbCBUZWNobm9sb2d5IEdyb3VwIEx0ZC4NClNoYW5n
aGFpLCBDaGluYS4NCg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogbGludXgt
bWVkaWEtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtbWVkaWEtb3duZXJAdmdl
ci5rZXJuZWwub3JnXSBPbiBCZWhhbGYgT2YgR3Vlbm5hZGkgTGlha2hvdmV0c2tpDQpTZW50OiAy
MDEx5bm0MuaciDTml6UgMTU6NDUNClRvOiBRaW5nIFh1DQpDYzogTGF1cmVudCBQaW5jaGFydDsg
TGludXggTWVkaWEgTWFpbGluZyBMaXN0DQpTdWJqZWN0OiBSRTogSG93IHRvIHN1cHBvcnQgTUlQ
SSBDU0ktMiBjb250cm9sbGVyIGluIHNvYy1jYW1lcmEgZnJhbWV3b3JrPw0KDQpIaQ0KDQpTb3Jy
eSBmb3IgdGhlIGRlbGF5IGZpcnN0IG9mIGFsbC4NCg0KT24gV2VkLCAxOSBKYW4gMjAxMSwgUWlu
ZyBYdSB3cm90ZToNCg0KPiBIaSwNCj4gDQo+IChhIGdlbmVyYWwgcmVxdWVzdDogY291bGQgeW91
IHBsZWFzZSBjb25maWd1cmUgeW91ciBtYWlsZXIgdG8gd3JhcA0KPiBMaW5lcyBhdCBzb21ld2hl
cmUgYXJvdW5kIDcwIGNoYXJhY3RlcnM/KQ0KPiB2ZXJ5IHNvcnJ5IGZvciB0aGUgdW4tY29udmVu
aWVuY2UhDQo+IA0KPiBUaGFua3MgZm9yIHlvdXIgZGVzY3JpcHRpb24hIEkgY291bGQgdmVyaWZ5
IGFuZCB0cnkgeW91ciB3YXkgb24gb3VyDQo+IENTSS0yIGRyaXZlci4NCj4gQWxzbywgb3VyIGFu
b3RoZXIgY2hpcCdzIGNhbWVyYSBjb250cm9sbGVyIHN1cHBvcnQgYm90aCBNSVBJIGFuZA0KPiB0
cmFkaXRpb25hbCBwYXJhbGxlbChIX3N5bmMvVl9zeW5jKSBpbnRlcmZhY2UsIHdlIGhvcGUgaG9z
dCBjYW4NCj4gbmVnb3RpYXRlIHdpdGggc2Vuc29yIG9uIE1JUEkgY29uZmlndXJlLCBhcyB0aGUg
c2Vuc29yIGNvdWxkIGJlDQo+IHBhcmFsbGVsIGludGVyZmFjZSBvciBNSVBJIGludGVyZmFjZSwg
c28gSSBoYXZlIGEgcHJvcG9zYWwgYXMNCj4gZm9sbG93Og0KPiANCj4gaW4gc29jX2NhbWVyYS5o
LCBTT0NBTV9YWFggZGVmaW5lcyBhbGwgSFcgY29ubmVjdGlvbiBwcm9wZXJ0aWVzLA0KPiBJIHRo
aW5nIE1JUEkoMS8yLzMvNCBsYW5lcykgaXMgYWxzbyBhIGtpbmQgb2YgSFcgY29ubmVjdGlvbg0K
PiBwcm9wZXJ0eSwgYW5kIGl0IGlzIG11dGV4IHdpdGggcGFyYWxsZWwgcHJvcGVydGllcyhpZiBz
ZW5zb3INCj4gc3VwcG9ydCBtaXBpIGNvbm5lY3Rpb24sIHRoZSBIVyBzaWduYWwgaGFzIG5vIHBh
cmFsbGVsIHByb3BlcnR5DQo+IGFueSBtb3JlKSwgb25jZSBob3N0IGNvbnRyb2xsZXIgZmluZCBz
dWJkZXYgc3VwcG9ydCBNSVBJLCBpdCB3aWxsDQo+IGVuYWJsZSBNSVBJIGZ1bmN0aW9uYWwgaXRz
ZWxmLCBhbmQgaWYgc3ViZGV2IG9ubHkgc3VwcG9ydCBwYXJhbGxlbCwNCj4gaXQgd2lsbCBlbmFi
bGUgcGFyYWxsZWwgZnVuY3Rpb25hbCBpdHNlbGYuDQoNCkkgdGhpbmssIHllcywgd2UgY2FuIGFk
ZCBNSVBJIGRlZmluaXRpb25zIHRvIHNvY19jYW1lcmEuaCwgc2ltaWxhciB0byB5b3VyIA0KcHJv
cG9zYWwgYmVsb3csIGJ1dCBJIGRvbid0IHRoaW5rIHdlIG5lZWQgdGhlICJTT0NBTV9NSVBJIiBt
YWNybyBpdHNlbGYsIA0KbWF5YmUgZGVmaW5lIGl0IGFzIGEgbWFzaw0KDQojZGVmaW5lIFNPQ0FN
X01JUEkgKFNPQ0FNX01JUElfMUxBTkUgfCBTT0NBTV9NSVBJXzJMQU5FIHwgU09DQU1fTUlQSV8z
TEFORSB8IFNPQ0FNX01JUElfNExBTkUpDQoNCkFsc28sIHRoZSBkZWNpc2lvbiAiaWYgTUlQSSBz
dXBwb3J0ZWQgYnkgdGhlIGNsaWVudCBhbHdheXMgcHJlZmVyIGl0IG92ZXIgDQp0aGUgcGFyYWxs
ZWwgY29ubmVjdGlvbiIgZG9lc24ndCBzZWVtIHRvIGJlIGEgbWVhbmluZ2Z1bCB0aGluZyB0byBk
byBpbiANCnRoZSBkcml2ZXIgdG8gbWUuIEkgd291bGQgbGVhdmUgdGhlIGNob2ljZSBvZiBhIGNv
bm5lY3Rpb24gdG8gdGhlIHBsYXRmb3JtIA0KY29kZS4gSW4gdGhhdCBjYXNlIHlvdXIgYWRkaXRp
b24gdG8gdGhlIHNvY19jYW1lcmFfYXBwbHlfc2Vuc29yX2ZsYWdzKCkgDQpmdW5jdGlvbiBiZWNv
bWVzIHVubmVlZGVkLg0KDQpNYWtlcyBzZW5zZT8NCg0KVGhhbmtzDQpHdWVubmFkaQ0KDQo+ICh5
b3UgY2FuIGZpbmQgdGhlIHByb3Bvc2FsIGluIHRoZSBjb2RlIHdoaWNoIEkgaGF2ZSBzZW50LCBy
ZWZlciB0byANCj4gcHhhOTU1X2NhbV9zZXRfYnVzX3BhcmFtKCkgaW4gcHhhOTU1X2NhbS5jLCBv
djU2NDJfcXVlcnlfYnVzX3BhcmFtDQo+IEluIG92NTY0Mi5jKQ0KPiANCj4gLS0tIGEvZHJpdmVy
cy9tZWRpYS92aWRlby9zb2NfY2FtZXJhLmMNCj4gKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9z
b2NfY2FtZXJhLmMNCj4gdW5zaWduZWQgbG9uZyBzb2NfY2FtZXJhX2FwcGx5X3NlbnNvcl9mbGFn
cyhzdHJ1Y3Qgc29jX2NhbWVyYV9saW5rICppY2wsDQo+ICAgICAgICAgICAgICAgICBpZiAoZiA9
PSBTT0NBTV9QQ0xLX1NBTVBMRV9SSVNJTkcgfHwgZiA9PSBTT0NBTV9QQ0xLX1NBTVBMRV9GQUxM
SU5HKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICBmbGFncyBePSBTT0NBTV9QQ0xLX1NBTVBM
RV9SSVNJTkcgfCBTT0NBTV9QQ0xLX1NBTVBMRV9GQUxMSU5HOw0KPiAgICAgICAgIH0NCj4gKyAg
ICAgICBpZiAoaWNsLT5mbGFncyAmIFNPQ0FNX01JUEkpIHsNCj4gKyAgICAgICAgICAgICAgIGZs
YWdzICY9IFNPQ0FNX01JUEkgfCBTT0NBTV9NSVBJXzFMQU5FIHwgU09DQU1fTUlQSV8yTEFORQ0K
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBTT0NBTV9NSVBJXzNM
QU5FIHwgU09DQU1fTUlQSV80TEFORTsNCj4gKyAgICAgICB9DQo+IA0KPiAgICAgICAgIHJldHVy
biBmbGFnczsNCj4gIH0NCj4gDQo+IC0tLSBhL2luY2x1ZGUvbWVkaWEvc29jX2NhbWVyYS5oDQo+
ICsrKyBiL2luY2x1ZGUvbWVkaWEvc29jX2NhbWVyYS5oDQo+IA0KPiAgI2RlZmluZSBTT0NBTV9E
QVRBX0FDVElWRV9ISUdIICAgICAgICAgKDEgPDwgMTQpDQo+ICAjZGVmaW5lIFNPQ0FNX0RBVEFf
QUNUSVZFX0xPVyAgICAgICAgICAoMSA8PCAxNSkNCj4gDQo+ICsjZGVmaW5lIFNPQ0FNX01JUEkg
ICAgICAgICAgICAgKDEgPDwgMTYpDQo+ICsjZGVmaW5lIFNPQ0FNX01JUElfMUxBTkUgICAgICAg
ICAgICAgICAoMSA8PCAxNykNCj4gKyNkZWZpbmUgU09DQU1fTUlQSV8yTEFORSAgICAgICAgICAg
ICAgICgxIDw8IDE4KQ0KPiArI2RlZmluZSBTT0NBTV9NSVBJXzNMQU5FICAgICAgICAgICAgICAg
KDEgPDwgMTkpDQo+ICsjZGVmaW5lIFNPQ0FNX01JUElfNExBTkUgICAgICAgICAgICAgICAoMSA8
PCAyMCkNCj4gKw0KPiANCj4gIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBzb2NfY2FtZXJh
X2J1c19wYXJhbV9jb21wYXRpYmxlKA0KPiAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25l
ZCBsb25nIGNhbWVyYV9mbGFncywgdW5zaWduZWQgbG9uZyBidXNfZmxhZ3MpDQo+ICB7DQo+IC0g
ICAgICAgdW5zaWduZWQgbG9uZyBjb21tb25fZmxhZ3MsIGhzeW5jLCB2c3luYywgcGNsaywgZGF0
YSwgYnVzd2lkdGgsIG1vZGU7DQo+ICsgICAgICAgdW5zaWduZWQgbG9uZyBjb21tb25fZmxhZ3Ms
IGhzeW5jLCB2c3luYywgcGNsaywgZGF0YSwgYnVzd2lkdGgsIG1vZGUsIG1pcGk7DQo+IA0KPiAg
ICAgICAgIGNvbW1vbl9mbGFncyA9IGNhbWVyYV9mbGFncyAmIGJ1c19mbGFnczsNCj4gDQo+IEBA
IC0yNjEsOCArMjY3LDEwIEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBzb2NfY2FtZXJh
X2J1c19wYXJhbV9jb21wYXRpYmxlKA0KPiAgICAgICAgIGRhdGEgPSBjb21tb25fZmxhZ3MgJiAo
U09DQU1fREFUQV9BQ1RJVkVfSElHSCB8IFNPQ0FNX0RBVEFfQUNUSVZFX0xPVyk7DQo+ICAgICAg
ICAgbW9kZSA9IGNvbW1vbl9mbGFncyAmIChTT0NBTV9NQVNURVIgfCBTT0NBTV9TTEFWRSk7DQo+
ICAgICAgICAgYnVzd2lkdGggPSBjb21tb25fZmxhZ3MgJiBTT0NBTV9EQVRBV0lEVEhfTUFTSzsN
Cj4gKyAgICAgICBtaXBpID0gY29tbW9uX2ZsYWdzICYgKFNPQ0FNX01JUEkgfCBTT0NBTV9NSVBJ
XzFMQU5FIHwgU09DQU1fTUlQSV8yTEFORQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB8IFNPQ0FNX01JUElfM0xBTkUgfCBTT0NBTV9NSVBJXzRMQU5F
KTsNCj4gDQo+IC0gICAgICAgcmV0dXJuICghaHN5bmMgfHwgIXZzeW5jIHx8ICFwY2xrIHx8ICFk
YXRhIHx8ICFtb2RlIHx8ICFidXN3aWR0aCkgPyAwIDoNCj4gKyAgICAgICByZXR1cm4gKCghaHN5
bmMgfHwgIXZzeW5jIHx8ICFwY2xrIHx8ICFkYXRhIHx8ICFtb2RlIHx8ICFidXN3aWR0aCkgJiYg
KCFtaXBpKSkgPyAwIDoNCj4gICAgICAgICAgICAgICAgIGNvbW1vbl9mbGFnczsNCj4gIH0NCj4g
DQo+IA0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHdWVubmFkaSBMaWFr
aG92ZXRza2kgW21haWx0bzpnLmxpYWtob3ZldHNraUBnbXguZGVdDQo+IFNlbnQ6IDIwMTHDhMOq
McOUw4IyMMOIw5UgMDoyMA0KPiBUbzogUWluZyBYdQ0KPiBDYzogTGF1cmVudCBQaW5jaGFydDsg
TGludXggTWVkaWEgTWFpbGluZyBMaXN0DQo+IFN1YmplY3Q6IFJlOiBIb3cgdG8gc3VwcG9ydCBN
SVBJIENTSS0yIGNvbnRyb2xsZXIgaW4gc29jLWNhbWVyYSBmcmFtZXdvcms/DQo+IA0KPiAoYSBn
ZW5lcmFsIHJlcXVlc3Q6IGNvdWxkIHlvdSBwbGVhc2UgY29uZmlndXJlIHlvdXIgbWFpbGVyIHRv
IHdyYXAgbGluZXMNCj4gYXQgc29tZXdoZXJlIGFyb3VuZCA3MCBjaGFyYWN0ZXJzPykNCj4gDQo+
IE9uIFR1ZSwgMTggSmFuIDIwMTEsIFFpbmcgWHUgd3JvdGU6DQo+IA0KPiA+IEhpLA0KPiA+DQo+
ID4gT3VyIGNoaXAgc3VwcG9ydCBib3RoIE1JUEkgYW5kIHBhcmFsbGVsIGludGVyZmFjZS4gVGhl
IEhXIGNvbm5lY3Rpb24gbG9naWMgaXMNCj4gPiBzZW5zb3Ioc3VjaCBhcyBvdjU2NDIpIC0+IG91
ciBNSVBJIGNvbnRyb2xsZXIoaGFuZGxlIERQSFkgdGltaW5nLyBDU0ktMg0KPiA+IHRoaW5ncykg
LT4gb3VyIGNhbWVyYSBjb250cm9sbGVyIChoYW5kbGUgRE1BIHRyYW5zbWl0dGluZy8gZm10LyBz
aXplDQo+ID4gdGhpbmdzKS4gTm93LCBJIGZpbmQgdGhlIGRyaXZlciBvZiBzaF9tb2JpbGVfY3Np
Mi5jLCBpdCBzZWVtcyBsaWtlIGENCj4gPiBDU0ktMiBkcml2ZXIsIGJ1dCBJIGRvbid0IHF1aXRl
IHVuZGVyc3RhbmQgaG93IGl0IHdvcmtzOg0KPiA+IDEpIGhvdyB0aGUgaG9zdCBjb250cm9sbGVy
IGNhbGwgaW50byB0aGlzIGRyaXZlcj8NCj4gDQo+IFRoaXMgaXMgYSBub3JtYWwgdjRsMi1zdWJk
ZXYgZHJpdmVyLiBQbGF0Zm9ybSBkYXRhIGZvciB0aGUNCj4gc2hfbW9iaWxlX2NldV9jYW1lcmEg
ZHJpdmVyIHByb3ZpZGVzIGEgbGluayB0byBDU0kyIGRyaXZlciBkYXRhLCB0aGVuIHRoZQ0KPiBo
b3N0IGRyaXZlciBsb2FkcyB0aGUgQ1NJMiBkcml2ZXIsIHdoaWNoIHRoZW4gbGlua3MgaXRzZWxm
IGludG8gdGhlDQo+IHN1YmRldmljZSBsaXN0LiBMb29rIGF0IGFyY2gvYXJtL21hY2gtc2htb2Jp
bGUvYm9hcmQtYXA0ZXZiLmMgaG93IHRoZSBkYXRhDQo+IGlzIGxpbmtlZDoNCj4gDQo+IHN0YXRp
YyBzdHJ1Y3Qgc2hfbW9iaWxlX2NldV9pbmZvIHNoX21vYmlsZV9jZXVfaW5mbyA9IHsNCj4gICAg
ICAgICAuZmxhZ3MgPSBTSF9DRVVfRkxBR19VU0VfOEJJVF9CVVMsDQo+ICAgICAgICAgLmNzaTJf
ZGV2ID0gJmNzaTJfZGV2aWNlLmRldiwNCj4gfTsNCj4gDQo+IGFuZCBpbiB0aGUgaG9zeiBkcml2
ZXIgZHJpdmVycy9tZWRpYS92aWRlby9zaF9tb2JpbGVfY2V1X2NhbWVyYS5jIGxvb2sgaW4NCj4g
dGhlIHNoX21vYmlsZV9jZXVfcHJvYmUgZnVuY3Rpb24gYmVsb3cgdGhlIGxpbmVzOg0KPiANCj4g
ICAgICAgICBjc2kyID0gcGNkZXYtPnBkYXRhLT5jc2kyX2RldjsNCj4gICAgICAgICBpZiAoY3Np
Mikgew0KPiAuLi4NCj4gDQo+IA0KPiA+IDIpIGhvdyB0aGUgaG9zdCBjb250cm9sbGVyL3NlbnNv
ciBuZWdvdGlhdGUgTUlQSSB2YXJpYWJsZSB3aXRoIHRoaXMNCj4gPiBkcml2ZXIsIHN1Y2ggYXMg
RC1QSFkgdGltaW5nKGhzX3NldHRsZS9oc190ZXJtZW4vY2xrX3NldHRsZS9jbGtfdGVybWVuKSwN
Cj4gPiBudW1iZXIgb2YgbGFuZXMuLi4/DQo+IA0KPiBTaW5jZSBJIG9ubHkgaGFkIGEgbGltaXRl
ZCBudW1iZXIgb2YgTUlQSSBzZXR1cHMsIEkgaGF2ZW4ndCBpbXBsZW1lbnRlZA0KPiBtYXhpbXVt
IGZsZXhpYmlsaXR5LiBBIHBhcnQgb2YgdGhlIHBhcmFtZXRlcnMgaXMgaGFyZC1jb2RlZCwgYW5v
dGhlciBwYXJ0DQo+IGlzIHByb3ZpZGVkIGluIHRoZSBwbGF0Zm9ybSBkcml2ZXIsIHlldCBhbm90
aGVyIHBhcnQgaXMgY2FsY3VsYXRlZA0KPiBkeW5hbWljYWxseS4NCj4gDQo+IFRoYW5rcw0KPiBH
dWVubmFkaQ0KPiAtLS0NCj4gR3Vlbm5hZGkgTGlha2hvdmV0c2tpLCBQaC5ELg0KPiBGcmVlbGFu
Y2UgT3Blbi1Tb3VyY2UgU29mdHdhcmUgRGV2ZWxvcGVyDQo+IGh0dHA6Ly93d3cub3Blbi10ZWNo
bm9sb2d5LmRlLw0KPiANCg0KLS0tDQpHdWVubmFkaSBMaWFraG92ZXRza2ksIFBoLkQuDQpGcmVl
bGFuY2UgT3Blbi1Tb3VyY2UgU29mdHdhcmUgRGV2ZWxvcGVyDQpodHRwOi8vd3d3Lm9wZW4tdGVj
aG5vbG9neS5kZS8NCi0tDQpUbyB1bnN1YnNjcmliZSBmcm9tIHRoaXMgbGlzdDogc2VuZCB0aGUg
bGluZSAidW5zdWJzY3JpYmUgbGludXgtbWVkaWEiIGluDQp0aGUgYm9keSBvZiBhIG1lc3NhZ2Ug
dG8gbWFqb3Jkb21vQHZnZXIua2VybmVsLm9yZw0KTW9yZSBtYWpvcmRvbW8gaW5mbyBhdCAgaHR0
cDovL3ZnZXIua2VybmVsLm9yZy9tYWpvcmRvbW8taW5mby5odG1sDQo=
