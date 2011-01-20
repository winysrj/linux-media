Return-path: <mchehab@pedra>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:54824 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752946Ab1ATC15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 21:27:57 -0500
From: Qing Xu <qingx@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Wed, 19 Jan 2011 18:26:22 -0800
Subject: RE: How to support MIPI CSI-2 controller in soc-camera framework?
Message-ID: <7BAC95F5A7E67643AAFB2C31BEE662D014040BF80C@SC-VEXCH2.marvell.com>
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
In-Reply-To: <Pine.LNX.4.64.1101191701430.620@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

SGksDQoNCihhIGdlbmVyYWwgcmVxdWVzdDogY291bGQgeW91IHBsZWFzZSBjb25maWd1cmUgeW91
ciBtYWlsZXIgdG8gd3JhcA0KTGluZXMgYXQgc29tZXdoZXJlIGFyb3VuZCA3MCBjaGFyYWN0ZXJz
PykNCnZlcnkgc29ycnkgZm9yIHRoZSB1bi1jb252ZW5pZW5jZSENCg0KVGhhbmtzIGZvciB5b3Vy
IGRlc2NyaXB0aW9uISBJIGNvdWxkIHZlcmlmeSBhbmQgdHJ5IHlvdXIgd2F5IG9uIG91cg0KQ1NJ
LTIgZHJpdmVyLg0KQWxzbywgb3VyIGFub3RoZXIgY2hpcCdzIGNhbWVyYSBjb250cm9sbGVyIHN1
cHBvcnQgYm90aCBNSVBJIGFuZA0KdHJhZGl0aW9uYWwgcGFyYWxsZWwoSF9zeW5jL1Zfc3luYykg
aW50ZXJmYWNlLCB3ZSBob3BlIGhvc3QgY2FuDQpuZWdvdGlhdGUgd2l0aCBzZW5zb3Igb24gTUlQ
SSBjb25maWd1cmUsIGFzIHRoZSBzZW5zb3IgY291bGQgYmUNCnBhcmFsbGVsIGludGVyZmFjZSBv
ciBNSVBJIGludGVyZmFjZSwgc28gSSBoYXZlIGEgcHJvcG9zYWwgYXMNCmZvbGxvdzoNCg0KaW4g
c29jX2NhbWVyYS5oLCBTT0NBTV9YWFggZGVmaW5lcyBhbGwgSFcgY29ubmVjdGlvbiBwcm9wZXJ0
aWVzLA0KSSB0aGluZyBNSVBJKDEvMi8zLzQgbGFuZXMpIGlzIGFsc28gYSBraW5kIG9mIEhXIGNv
bm5lY3Rpb24NCnByb3BlcnR5LCBhbmQgaXQgaXMgbXV0ZXggd2l0aCBwYXJhbGxlbCBwcm9wZXJ0
aWVzKGlmIHNlbnNvcg0Kc3VwcG9ydCBtaXBpIGNvbm5lY3Rpb24sIHRoZSBIVyBzaWduYWwgaGFz
IG5vIHBhcmFsbGVsIHByb3BlcnR5DQphbnkgbW9yZSksIG9uY2UgaG9zdCBjb250cm9sbGVyIGZp
bmQgc3ViZGV2IHN1cHBvcnQgTUlQSSwgaXQgd2lsbA0KZW5hYmxlIE1JUEkgZnVuY3Rpb25hbCBp
dHNlbGYsIGFuZCBpZiBzdWJkZXYgb25seSBzdXBwb3J0IHBhcmFsbGVsLA0KaXQgd2lsbCBlbmFi
bGUgcGFyYWxsZWwgZnVuY3Rpb25hbCBpdHNlbGYuDQooeW91IGNhbiBmaW5kIHRoZSBwcm9wb3Nh
bCBpbiB0aGUgY29kZSB3aGljaCBJIGhhdmUgc2VudCwgcmVmZXIgdG8gcHhhOTU1X2NhbV9zZXRf
YnVzX3BhcmFtKCkgaW4gcHhhOTU1X2NhbS5jLCBvdjU2NDJfcXVlcnlfYnVzX3BhcmFtDQpJbiBv
djU2NDIuYykNCg0KLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9zb2NfY2FtZXJhLmMNCisrKyBi
L2RyaXZlcnMvbWVkaWEvdmlkZW8vc29jX2NhbWVyYS5jDQp1bnNpZ25lZCBsb25nIHNvY19jYW1l
cmFfYXBwbHlfc2Vuc29yX2ZsYWdzKHN0cnVjdCBzb2NfY2FtZXJhX2xpbmsgKmljbCwNCiAgICAg
ICAgICAgICAgICBpZiAoZiA9PSBTT0NBTV9QQ0xLX1NBTVBMRV9SSVNJTkcgfHwgZiA9PSBTT0NB
TV9QQ0xLX1NBTVBMRV9GQUxMSU5HKQ0KICAgICAgICAgICAgICAgICAgICAgICAgZmxhZ3MgXj0g
U09DQU1fUENMS19TQU1QTEVfUklTSU5HIHwgU09DQU1fUENMS19TQU1QTEVfRkFMTElORzsNCiAg
ICAgICAgfQ0KKyAgICAgICBpZiAoaWNsLT5mbGFncyAmIFNPQ0FNX01JUEkpIHsNCisgICAgICAg
ICAgICAgICBmbGFncyAmPSBTT0NBTV9NSVBJIHwgU09DQU1fTUlQSV8xTEFORSB8IFNPQ0FNX01J
UElfMkxBTkUNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IFNPQ0FN
X01JUElfM0xBTkUgfCBTT0NBTV9NSVBJXzRMQU5FOw0KKyAgICAgICB9DQoNCiAgICAgICAgcmV0
dXJuIGZsYWdzOw0KIH0NCg0KLS0tIGEvaW5jbHVkZS9tZWRpYS9zb2NfY2FtZXJhLmgNCisrKyBi
L2luY2x1ZGUvbWVkaWEvc29jX2NhbWVyYS5oDQoNCiAjZGVmaW5lIFNPQ0FNX0RBVEFfQUNUSVZF
X0hJR0ggICAgICAgICAoMSA8PCAxNCkNCiAjZGVmaW5lIFNPQ0FNX0RBVEFfQUNUSVZFX0xPVyAg
ICAgICAgICAoMSA8PCAxNSkNCg0KKyNkZWZpbmUgU09DQU1fTUlQSSAgICAgICAgICAgICAoMSA8
PCAxNikNCisjZGVmaW5lIFNPQ0FNX01JUElfMUxBTkUgICAgICAgICAgICAgICAoMSA8PCAxNykN
CisjZGVmaW5lIFNPQ0FNX01JUElfMkxBTkUgICAgICAgICAgICAgICAoMSA8PCAxOCkNCisjZGVm
aW5lIFNPQ0FNX01JUElfM0xBTkUgICAgICAgICAgICAgICAoMSA8PCAxOSkNCisjZGVmaW5lIFNP
Q0FNX01JUElfNExBTkUgICAgICAgICAgICAgICAoMSA8PCAyMCkNCisNCg0KIHN0YXRpYyBpbmxp
bmUgdW5zaWduZWQgbG9uZyBzb2NfY2FtZXJhX2J1c19wYXJhbV9jb21wYXRpYmxlKA0KICAgICAg
ICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBjYW1lcmFfZmxhZ3MsIHVuc2lnbmVkIGxv
bmcgYnVzX2ZsYWdzKQ0KIHsNCi0gICAgICAgdW5zaWduZWQgbG9uZyBjb21tb25fZmxhZ3MsIGhz
eW5jLCB2c3luYywgcGNsaywgZGF0YSwgYnVzd2lkdGgsIG1vZGU7DQorICAgICAgIHVuc2lnbmVk
IGxvbmcgY29tbW9uX2ZsYWdzLCBoc3luYywgdnN5bmMsIHBjbGssIGRhdGEsIGJ1c3dpZHRoLCBt
b2RlLCBtaXBpOw0KDQogICAgICAgIGNvbW1vbl9mbGFncyA9IGNhbWVyYV9mbGFncyAmIGJ1c19m
bGFnczsNCg0KQEAgLTI2MSw4ICsyNjcsMTAgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25n
IHNvY19jYW1lcmFfYnVzX3BhcmFtX2NvbXBhdGlibGUoDQogICAgICAgIGRhdGEgPSBjb21tb25f
ZmxhZ3MgJiAoU09DQU1fREFUQV9BQ1RJVkVfSElHSCB8IFNPQ0FNX0RBVEFfQUNUSVZFX0xPVyk7
DQogICAgICAgIG1vZGUgPSBjb21tb25fZmxhZ3MgJiAoU09DQU1fTUFTVEVSIHwgU09DQU1fU0xB
VkUpOw0KICAgICAgICBidXN3aWR0aCA9IGNvbW1vbl9mbGFncyAmIFNPQ0FNX0RBVEFXSURUSF9N
QVNLOw0KKyAgICAgICBtaXBpID0gY29tbW9uX2ZsYWdzICYgKFNPQ0FNX01JUEkgfCBTT0NBTV9N
SVBJXzFMQU5FIHwgU09DQU1fTUlQSV8yTEFORQ0KKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCBTT0NBTV9NSVBJXzNMQU5FIHwgU09DQU1fTUlQSV80TEFO
RSk7DQoNCi0gICAgICAgcmV0dXJuICghaHN5bmMgfHwgIXZzeW5jIHx8ICFwY2xrIHx8ICFkYXRh
IHx8ICFtb2RlIHx8ICFidXN3aWR0aCkgPyAwIDoNCisgICAgICAgcmV0dXJuICgoIWhzeW5jIHx8
ICF2c3luYyB8fCAhcGNsayB8fCAhZGF0YSB8fCAhbW9kZSB8fCAhYnVzd2lkdGgpICYmICghbWlw
aSkpID8gMCA6DQogICAgICAgICAgICAgICAgY29tbW9uX2ZsYWdzOw0KIH0NCg0KDQotLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogR3Vlbm5hZGkgTGlha2hvdmV0c2tpIFttYWlsdG86
Zy5saWFraG92ZXRza2lAZ214LmRlXQ0KU2VudDogMjAxMcTqMdTCMjDI1SAwOjIwDQpUbzogUWlu
ZyBYdQ0KQ2M6IExhdXJlbnQgUGluY2hhcnQ7IExpbnV4IE1lZGlhIE1haWxpbmcgTGlzdA0KU3Vi
amVjdDogUmU6IEhvdyB0byBzdXBwb3J0IE1JUEkgQ1NJLTIgY29udHJvbGxlciBpbiBzb2MtY2Ft
ZXJhIGZyYW1ld29yaz8NCg0KKGEgZ2VuZXJhbCByZXF1ZXN0OiBjb3VsZCB5b3UgcGxlYXNlIGNv
bmZpZ3VyZSB5b3VyIG1haWxlciB0byB3cmFwIGxpbmVzDQphdCBzb21ld2hlcmUgYXJvdW5kIDcw
IGNoYXJhY3RlcnM/KQ0KDQpPbiBUdWUsIDE4IEphbiAyMDExLCBRaW5nIFh1IHdyb3RlOg0KDQo+
IEhpLA0KPg0KPiBPdXIgY2hpcCBzdXBwb3J0IGJvdGggTUlQSSBhbmQgcGFyYWxsZWwgaW50ZXJm
YWNlLiBUaGUgSFcgY29ubmVjdGlvbiBsb2dpYyBpcw0KPiBzZW5zb3Ioc3VjaCBhcyBvdjU2NDIp
IC0+IG91ciBNSVBJIGNvbnRyb2xsZXIoaGFuZGxlIERQSFkgdGltaW5nLyBDU0ktMg0KPiB0aGlu
Z3MpIC0+IG91ciBjYW1lcmEgY29udHJvbGxlciAoaGFuZGxlIERNQSB0cmFuc21pdHRpbmcvIGZt
dC8gc2l6ZQ0KPiB0aGluZ3MpLiBOb3csIEkgZmluZCB0aGUgZHJpdmVyIG9mIHNoX21vYmlsZV9j
c2kyLmMsIGl0IHNlZW1zIGxpa2UgYQ0KPiBDU0ktMiBkcml2ZXIsIGJ1dCBJIGRvbid0IHF1aXRl
IHVuZGVyc3RhbmQgaG93IGl0IHdvcmtzOg0KPiAxKSBob3cgdGhlIGhvc3QgY29udHJvbGxlciBj
YWxsIGludG8gdGhpcyBkcml2ZXI/DQoNClRoaXMgaXMgYSBub3JtYWwgdjRsMi1zdWJkZXYgZHJp
dmVyLiBQbGF0Zm9ybSBkYXRhIGZvciB0aGUNCnNoX21vYmlsZV9jZXVfY2FtZXJhIGRyaXZlciBw
cm92aWRlcyBhIGxpbmsgdG8gQ1NJMiBkcml2ZXIgZGF0YSwgdGhlbiB0aGUNCmhvc3QgZHJpdmVy
IGxvYWRzIHRoZSBDU0kyIGRyaXZlciwgd2hpY2ggdGhlbiBsaW5rcyBpdHNlbGYgaW50byB0aGUN
CnN1YmRldmljZSBsaXN0LiBMb29rIGF0IGFyY2gvYXJtL21hY2gtc2htb2JpbGUvYm9hcmQtYXA0
ZXZiLmMgaG93IHRoZSBkYXRhDQppcyBsaW5rZWQ6DQoNCnN0YXRpYyBzdHJ1Y3Qgc2hfbW9iaWxl
X2NldV9pbmZvIHNoX21vYmlsZV9jZXVfaW5mbyA9IHsNCiAgICAgICAgLmZsYWdzID0gU0hfQ0VV
X0ZMQUdfVVNFXzhCSVRfQlVTLA0KICAgICAgICAuY3NpMl9kZXYgPSAmY3NpMl9kZXZpY2UuZGV2
LA0KfTsNCg0KYW5kIGluIHRoZSBob3N6IGRyaXZlciBkcml2ZXJzL21lZGlhL3ZpZGVvL3NoX21v
YmlsZV9jZXVfY2FtZXJhLmMgbG9vayBpbg0KdGhlIHNoX21vYmlsZV9jZXVfcHJvYmUgZnVuY3Rp
b24gYmVsb3cgdGhlIGxpbmVzOg0KDQogICAgICAgIGNzaTIgPSBwY2Rldi0+cGRhdGEtPmNzaTJf
ZGV2Ow0KICAgICAgICBpZiAoY3NpMikgew0KLi4uDQoNCg0KPiAyKSBob3cgdGhlIGhvc3QgY29u
dHJvbGxlci9zZW5zb3IgbmVnb3RpYXRlIE1JUEkgdmFyaWFibGUgd2l0aCB0aGlzDQo+IGRyaXZl
ciwgc3VjaCBhcyBELVBIWSB0aW1pbmcoaHNfc2V0dGxlL2hzX3Rlcm1lbi9jbGtfc2V0dGxlL2Ns
a190ZXJtZW4pLA0KPiBudW1iZXIgb2YgbGFuZXMuLi4/DQoNClNpbmNlIEkgb25seSBoYWQgYSBs
aW1pdGVkIG51bWJlciBvZiBNSVBJIHNldHVwcywgSSBoYXZlbid0IGltcGxlbWVudGVkDQptYXhp
bXVtIGZsZXhpYmlsaXR5LiBBIHBhcnQgb2YgdGhlIHBhcmFtZXRlcnMgaXMgaGFyZC1jb2RlZCwg
YW5vdGhlciBwYXJ0DQppcyBwcm92aWRlZCBpbiB0aGUgcGxhdGZvcm0gZHJpdmVyLCB5ZXQgYW5v
dGhlciBwYXJ0IGlzIGNhbGN1bGF0ZWQNCmR5bmFtaWNhbGx5Lg0KDQpUaGFua3MNCkd1ZW5uYWRp
DQotLS0NCkd1ZW5uYWRpIExpYWtob3ZldHNraSwgUGguRC4NCkZyZWVsYW5jZSBPcGVuLVNvdXJj
ZSBTb2Z0d2FyZSBEZXZlbG9wZXINCmh0dHA6Ly93d3cub3Blbi10ZWNobm9sb2d5LmRlLw0K
