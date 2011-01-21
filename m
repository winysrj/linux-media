Return-path: <mchehab@pedra>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:54008 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754101Ab1AULKt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 06:10:49 -0500
From: Qing Xu <qingx@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Fri, 21 Jan 2011 03:06:09 -0800
Subject: RE: [PATCH] [media] v4l: soc-camera: add enum-frame-size ioctl
Message-ID: <7BAC95F5A7E67643AAFB2C31BEE662D014040BFAF7@SC-VEXCH2.marvell.com>
References: <1295574498-8666-1-git-send-email-qingx@marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BFA37@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101210841190.14675@axis700.grange>
 <201101211106.08670.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1101211138050.14675@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1101211138050.14675@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

DQpUaGFua3MhIEkgYW0gbm93IHByb3RvdHlwaW5nIE1hcnZlbGwgY2FtZXJhIGRyaXZlciB0byBh
bGlnbiB3aXRoIHNvYy1jYW1lcmENCmFyY2hpdGVjdHVyZSwgbWF5IG5lZWQgc29tZSB0aW1lIHRv
IHN0YWJpbGl6ZSBpdC4gT3VyIHN1YmRldiBkcml2ZXIgbm93DQphbHJlYWR5IGZvbGxvd3MgdGhv
c2UgeHh4X21idXNfeHh4IG9wZXJhdGlvbnMuIFdlIGhvcGUgd2UgY291bGQgZmluYWxpemUNCmFu
ZCBzdWJtaXQgb3VyIGNhbWVyYSBkcml2ZXIgcGF0Y2ggdG8gb3BlbiBzb3VyY2UgdGhpcyB5ZWFy
Lg0KDQpUaGFua3MhDQotUWluZw0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTog
R3Vlbm5hZGkgTGlha2hvdmV0c2tpIFttYWlsdG86Zy5saWFraG92ZXRza2lAZ214LmRlXQ0KU2Vu
dDogMjAxMeW5tDHmnIgyMeaXpSAxODo0Mw0KVG86IEhhbnMgVmVya3VpbA0KQ2M6IFFpbmcgWHU7
IGxpbnV4LW1lZGlhQHZnZXIua2VybmVsLm9yZzsgTGF1cmVudCBQaW5jaGFydA0KU3ViamVjdDog
UmU6IFtQQVRDSF0gW21lZGlhXSB2NGw6IHNvYy1jYW1lcmE6IGFkZCBlbnVtLWZyYW1lLXNpemUg
aW9jdGwNCg0KT24gRnJpLCAyMSBKYW4gMjAxMSwgSGFucyBWZXJrdWlsIHdyb3RlOg0KDQo+IE9u
IEZyaWRheSwgSmFudWFyeSAyMSwgMjAxMSAwOTowNTowNyBHdWVubmFkaSBMaWFraG92ZXRza2kg
d3JvdGU6DQo+ID4gT24gVGh1LCAyMCBKYW4gMjAxMSwgUWluZyBYdSB3cm90ZToNCj4gPg0KPiA+
ID4gSGkgR3Vlbm5hZGksIEhhbnMsDQo+ID4gPg0KPiA+ID4gSSB1cGRhdGUgdGhpcyBwYXRjaCwg
SSB1c2UgZW51bV9mcmFtZXNpemVzIGluc3RlYWQgb2YNCj4gPiA+IGVudW1fbWJ1c19mc2l6ZXMs
IHdoaWNoIGlzIGFscmVhZHkgZGVmaW5lZCBpbiB2NGwyLXN1YmRldi5oLA0KPiA+ID4gc28sIGRv
IG5vdCBuZWVkIHRvIG1vZGlmeSB2NGwyLXN1YmRldi5oIG5vdy4NCj4gPiA+DQo+ID4gPiBBcmUg
eW91IG9rIHdpdGggaXQ/DQo+ID4NCj4gPiBIbSwgeW91IHNlZSwgdGhpcyB3b3VsZCBtZWFuLCBo
aWphY2tpbmcgYSAid3JvbmciIG9wZXJhdGlvbi4gVGhpcyBpcyBvbmUNCj4gPiBvZiB0aG9zZSAi
d3JvbmciIHN1YmRldmljZSBvcGVyYXRpb25zLCB1c2luZyBmb3VyY2MgZm9ybWF0cyB0byBzcGVj
aWZ5IGENCj4gPiBkYXRhIGZvcm1hdCBvbiB0aGUgdmlkZW8tYnVzIGJldHdlZW4gYSBzdWJkZXZp
Y2UgKGEgc2Vuc29yKSBhbmQgYSBzaW5rIChhDQo+ID4gaG9zdCkuIFByZXZpb3VzbHkgdGhlcmUg
aGF2ZSBiZWVuIG1vcmUgb2Ygc3VjaCAid3JvbmciIG9wZXJhdGlvbnMsIGxpa2UNCj4gPiAue2cs
cyx0cnksZW51bX1fZm10LCBhbGwgb2YgdGhvc2UgaGF2ZSBiZWVuIF9ncmFkdWFsbHlfIHJlcGxh
Y2VkIGJ5DQo+ID4gcmVzcGVjdGl2ZSBtZWRpYWJ1cyBjb3VudGVycGFydHMuIFdoaWxlIGRvaW5n
IHRoYXQgd2UgZmlyc3QgYWRkZWQgbmV3DQo+ID4gb3BlcmF0aW9ucyB3aXRoIGRpZmZlcmVudCBu
YW1lcyAod2l0aCBhbiBleHRyYSAibWJ1c18iIGluIHRoZW0pLCB0aGVuDQo+ID4gcG9ydGVkIGFs
bCBleGlzdGluZyB1c2VycyBvdmVyIHRvIHRoZW0sIGFuZCBldmVudHVhbGx5IHJlbW92ZWQgdGhl
IG9sZA0KPiA+ICJ3cm9uZyIgb25lcyAoSGFucyBoYXMgZG9uZSB0aGUgZGlydGllc3QgYW5kIG1v
c3QgZGlmZmljdWx0IHBhcnQgb2YgdGhhdCAtDQo+ID4gcG9ydGluZyBhbmQgcmVtb3Zpbmc7KSku
IE5vdywgdGhlIC5lbnVtX2ZyYW1lc2l6ZXMoKSB2aWRlbyBzdWJkZXYNCj4gPiBvcGVyYXRpb24g
aXMgYWxzbyBvbmUgc3VjaCB3cm9uZyBBUEkgZWxlbWVudC4gSXQgaGFzIG11Y2ggZmV3ZXIgY3Vy
cmVudA0KPiA+IHVzZXJzIChvdjc2NzAuYyBhbmQgY2FmZV9jY2ljLmMgLSB0aGUgT0xQQyBwcm9q
ZWN0KS4NCj4NCj4gT29wcywgSSdkIG1pc3NlZCB0aG9zZS4gVGhvc2Ugc2hvdWxkIGJlIHJlcGxh
Y2VkIHdpdGggZW51bV9tYnVzX2ZyYW1lc2l6ZXMuDQo+IERpdHRvIGZvciBlbnVtX2ZyYW1laW50
ZXJ2YWxzLiB2aWFfY2FtZXJhLmMgdXNlcyBpdCBhcyB3ZWxsLg0KPg0KPiA+IElmIHdlIGp1c3Qg
YmxhdGFudGx5DQo+ID4gcmUtdXNlIGl0IHdpdGggYSBtZWRpYS1idXMgY29kZSwgaXQgd2lsbCBi
ZSByZWxhdGl2ZWx5IGhhcm1sZXNzLCBpbWhvLA0KPiA+IHN0aWxsLCBpdCB3aWxsIGludHJvZHVj
ZSBhbiBhbWJpZ3VpdHkuIE9mIHRoZSBhYm92ZSB0d28gZHJpdmVycyB0aGUgc2Vuc29yDQo+ID4g
ZHJpdmVyIHdpbGwgbm90IGhhdmUgdG8gYmUgY2hhbmdlZCBhdCBhbGwsIGJlY2F1c2UgaXQganVz
dCBpZ25vcmVzIHRoZQ0KPiA+IHBpeGVsX2Zvcm1hdCBmaWVsZCBhbHRvZ2V0aGVyLCBjYWZlX2Nj
aWMuYyB3aWxsIGhhdmUgdG8gYmUgdHJpdmlhbGx5DQo+ID4gcG9ydGVkLCB3ZSdkIGp1c3QgaGF2
ZSB0byBhZGQgYSBjb3VwbGUgb2YgbGluZXMsIGUuZy4NCj4gPg0KPiA+ICBzdGF0aWMgaW50IGNh
ZmVfdmlkaW9jX2VudW1fZnJhbWVzaXplcyhzdHJ1Y3QgZmlsZSAqZmlscCwgdm9pZCAqcHJpdiwN
Cj4gPiAgICAgICAgICAgICBzdHJ1Y3QgdjRsMl9mcm1zaXplZW51bSAqc2l6ZXMpDQo+ID4gIHsN
Cj4gPiAgICAgc3RydWN0IGNhZmVfY2FtZXJhICpjYW0gPSBwcml2Ow0KPiA+ICsgICBfX3UzMiBm
b3VyY2MgPSBzaXplcy0+cGl4ZWxfZm9ybWF0Ow0KPiA+ICAgICBpbnQgcmV0Ow0KPiA+DQo+ID4g
ICAgIG11dGV4X2xvY2soJmNhbS0+c19tdXRleCk7DQo+ID4gKyAgIHNpemVzLT5waXhlbF9mb3Jt
YXQgPSBjYW0tPm1idXNfY29kZTsNCj4gPiAgICAgcmV0ID0gc2Vuc29yX2NhbGwoY2FtLCB2aWRl
bywgZW51bV9mcmFtZXNpemVzLCBzaXplcyk7DQo+ID4gICAgIG11dGV4X3VubG9jaygmY2FtLT5z
X211dGV4KTsNCj4gPiArICAgc2l6ZXMtPnBpeGVsX2Zvcm1hdCA9IGZvdXJjYzsNCj4gPiAgICAg
cmV0dXJuIHJldDsNCj4gPiAgfQ0KPiA+DQo+ID4NCj4gPiBvciBzb21ldGhpbmcgc2ltaWxhci4g
U28sIHRoYXQncyBjZXJ0YWlubHkgZG9hYmxlLCBzdGlsbCwgSSB0aGluaywgdGhpcw0KPiA+IHdv
dWxkIGludHJvZHVjZSBhIHByZWNlZGVudCBvZiBpbmNvbnNpc3RlbnQgbmFtaW5nIC0gd2UnbGwg
aGF2ZSBhbg0KPiA+IG9wZXJhdGlvbiwgd2l0aG91dCBhbiAibWJ1cyIgaW4gdGhlIG5hbWUsIG9w
ZXJhdGluZyBhdCB0aGUgbWVkaWEtYnVzDQo+ID4gbGV2ZWwsIHdoaWNoIGlzIG5vdCBhIHZlcnkg
Z29vZCBpZGVhLCBpbWhvLiBIYW5zPw0KPg0KPiBJIGFncmVlLg0KPg0KPiBGaXJzdCBhZGQgbmV3
IGVudW1fbWJ1c19mcmFtZXNpemVzIGFuZCBlbnVtX21idXNfZnJhbWVpbnRlcnZhbHMgZnVuY3Rp
b25zLg0KPiBUaGVuIGNvbnZlcnQgdGhlIHRocmVlIGRyaXZlcnMgdGhhdCB1c2UgdGhpcyAob3Y3
NjcwLmMsIGNhZmVfY2NpYy5jIGFuZA0KPiB2aWFfY2FtZXJhLmMpIHRvIHRoZXNlIG5ldyBvcHMu
IE5leHQgcmVtb3ZlIHRoZSBvbGQgb25lcyBzaW5jZSBub2JvZHkgc2hvdWxkDQo+IHVzZSB0aGVt
IGFueW1vcmUuIEFuZCBmaW5hbGx5IGFkZCBzdXBwb3J0IGZvciB0aGlzIHRvIHNvY19jYW1lcmEu
DQoNClJpZ2h0LCBidXQgbGV0IG1lIHB1dCB0aGlzIGEgYml0IG1vcmUgc29mdGx5OiBJIGRvbid0
IHRoaW5rIFFpbmcgWHUgX211c3RfDQpub3cgZml4IGFsbCB0aG9zZSBkcml2ZXJzLCBldmVuIHRo
b3VnaCB0aG9zZSBjaGFuZ2VzIGFyZSwgcGVyaGFwcywgcmVhbGx5DQp0cml2aWFsLiBBcyBsb25n
IGFzIHRoZSBuZXcgb3BlcmF0aW9ucyBhcmUgYWRkZWQsIGlmIGhlIGNob29zZXMgbm90IHRvDQpw
YXRjaCB0aG9zZSAzIG90aGVyIGRyaXZlcnMsIGl0IHdvdWxkIGJlIGZpbmUgaWYgaGUganVzdCBk
b2VzIHdoYXQNCmNvbmNlcm5zIGhpbSAoaW4gZmFjdCwgaGUgZG9lc24ndCBoYXZlIHRvIGRvIGFu
eXRoaW5nIGVsc2UsIHdlIHN0aWxsIGhhdmUNCmhpcyBwcmV2aW91cyB2ZXJzaW9ucyBvZiB0aGUg
cGF0Y2hlcywgd2UgY2FuIGp1c3QgdXNlIHRoZW0pLiBJZiBuZWVkZWQsDQpldmVuIEkgY291bGQg
Y29vayB1cCBwYXRjaGVzIGZvciB0aG9zZSAzIGRyaXZlcnMsIG5vIGJpZyBkZWFsLg0KDQo+IEkg
Y2FuIHRha2UgeW91ciBvdjc2NzAvY2FmZS92aWEgcGF0Y2hlcyBhbmQgdGVzdCB0aGVtIGFuZCBt
YWtlIGEgcHVsbCByZXF1ZXN0DQo+IGZvciB0aGVtLiBJIGhhdmUgb3RoZXIgb3V0c3RhbmRpbmcg
d29yayBmb3IgdGhvc2UgZHJpdmVycyBzbyBJIGNhbiB0YWtlIHRoaXMNCj4gaW4gYXMgd2VsbC4g
U2luY2UgaXQgaXMgYSBiaWcgcGFpbiB0byB0ZXN0IG9uIHRoZSBPTFBDIGxhcHRvcCBJJ2QgcmF0
aGVyIHRlc3QNCj4gZXZlcnl0aGluZyBpbiBvbmUgZ28gOi0pDQo+DQo+IExhdXJlbnQsIGl0IGlz
IGEgZ29vZCBpZGVhIGlmIHlvdSB0b29rIGEgbG9vayBhdCB0aGlzIGFzIHdlbGwuIEVzcGVjaWFs
bHkgc2luY2UNCj4geW91IGhhdmUgc2ltaWxhciBwYXRjaGVzIGluIHlvdXIgbWVkaWEgY29udHJv
bGxlciBzZXJpZXM6DQo+DQo+IGh0dHA6Ly9wZXJtYWxpbmsuZ21hbmUub3JnL2dtYW5lLmxpbnV4
LmRyaXZlcnMudmlkZW8taW5wdXQtaW5mcmFzdHJ1Y3R1cmUvMjY4MjENCj4NCj4gVGhlIGZyYW1l
c2l6ZSBzdHJ1Y3QgaXMgbXVjaCBzaW1wbGlmaWVkIGhlcmUgYW5kIGFueSBuZXcgY29kZSBzaG91
bGQgcHJvYmFibHkNCj4gYmUgY2xvc2UgdG8gd2hhdCBpcyBwcm9wb3NlZCBoZXJlLg0KPg0KPiBS
ZWdhcmRzLA0KPg0KPiAgICAgICBIYW5zDQo+DQo+ID4NCj4gPiBUaGFua3MNCj4gPiBHdWVubmFk
aQ0KPiA+DQo+ID4gPg0KPiA+ID4gLVFpbmcNCj4gPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogUWluZyBYdSBbbWFpbHRvOnFpbmd4QG1hcnZlbGwuY29t
XQ0KPiA+ID4gU2VudDogMjAxMcOEw6oxw5TDgjIxw4jDlSA5OjQ4DQo+ID4gPiBUbzogZy5saWFr
aG92ZXRza2lAZ214LmRlDQo+ID4gPiBDYzogbGludXgtbWVkaWFAdmdlci5rZXJuZWwub3JnOyBR
aW5nIFh1DQo+ID4gPiBTdWJqZWN0OiBbUEFUQ0hdIFttZWRpYV0gdjRsOiBzb2MtY2FtZXJhOiBh
ZGQgZW51bS1mcmFtZS1zaXplIGlvY3RsDQo+ID4gPg0KPiA+ID4gYWRkIHZpZGlvY19lbnVtX2Zy
YW1lc2l6ZXMgaW1wbGVtZW50YXRpb24sIGZvbGxvdyBkZWZhdWx0X2dfcGFybSgpDQo+ID4gPiBh
bmQgZ19tYnVzX2ZtdCgpIG1ldGhvZA0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFFpbmcg
WHUgPHFpbmd4QG1hcnZlbGwuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9tZWRpYS92
aWRlby9zb2NfY2FtZXJhLmMgfCAgIDM3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCj4gPiA+ICBpbmNsdWRlL21lZGlhL3NvY19jYW1lcmEuaCAgICAgICB8ICAgIDEgKw0K
PiA+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMzggaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkN
Cj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS92aWRlby9zb2NfY2FtZXJh
LmMgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL3NvY19jYW1lcmEuYw0KPiA+ID4gaW5kZXggMDUyYmQ2
ZC4uNzI5MDEwNyAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vc29jX2Nh
bWVyYS5jDQo+ID4gPiArKysgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL3NvY19jYW1lcmEuYw0KPiA+
ID4gQEAgLTE0NSw2ICsxNDUsMTUgQEAgc3RhdGljIGludCBzb2NfY2FtZXJhX3Nfc3RkKHN0cnVj
dCBmaWxlICpmaWxlLCB2b2lkICpwcml2LCB2NGwyX3N0ZF9pZCAqYSkNCj4gPiA+ICAgICAgICAg
cmV0dXJuIHY0bDJfc3ViZGV2X2NhbGwoc2QsIGNvcmUsIHNfc3RkLCAqYSk7DQo+ID4gPiAgfQ0K
PiA+ID4NCj4gPiA+ICtzdGF0aWMgaW50IHNvY19jYW1lcmFfZW51bV9mc2l6ZXMoc3RydWN0IGZp
bGUgKmZpbGUsIHZvaWQgKmZoLA0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBzdHJ1Y3QgdjRsMl9mcm1zaXplZW51bSAqZnNpemUpDQo+ID4gPiArew0KPiA+
ID4gKyAgICAgICBzdHJ1Y3Qgc29jX2NhbWVyYV9kZXZpY2UgKmljZCA9IGZpbGUtPnByaXZhdGVf
ZGF0YTsNCj4gPiA+ICsgICAgICAgc3RydWN0IHNvY19jYW1lcmFfaG9zdCAqaWNpID0gdG9fc29j
X2NhbWVyYV9ob3N0KGljZC0+ZGV2LnBhcmVudCk7DQo+ID4gPiArDQo+ID4gPiArICAgICAgIHJl
dHVybiBpY2ktPm9wcy0+ZW51bV9mc2l6ZXMoaWNkLCBmc2l6ZSk7DQo+ID4gPiArfQ0KPiA+ID4g
Kw0KPiA+ID4gIHN0YXRpYyBpbnQgc29jX2NhbWVyYV9yZXFidWZzKHN0cnVjdCBmaWxlICpmaWxl
LCB2b2lkICpwcml2LA0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0
IHY0bDJfcmVxdWVzdGJ1ZmZlcnMgKnApDQo+ID4gPiAgew0KPiA+ID4gQEAgLTExNjAsNiArMTE2
OSwzMSBAQCBzdGF0aWMgaW50IGRlZmF1bHRfc19wYXJtKHN0cnVjdCBzb2NfY2FtZXJhX2Rldmlj
ZSAqaWNkLA0KPiA+ID4gICAgICAgICByZXR1cm4gdjRsMl9zdWJkZXZfY2FsbChzZCwgdmlkZW8s
IHNfcGFybSwgcGFybSk7DQo+ID4gPiAgfQ0KPiA+ID4NCj4gPiA+ICtzdGF0aWMgaW50IGRlZmF1
bHRfZW51bV9mc2l6ZXMoc3RydWN0IHNvY19jYW1lcmFfZGV2aWNlICppY2QsDQo+ID4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCB2NGwyX2ZybXNpemVlbnVtICpmc2l6ZSkNCj4g
PiA+ICt7DQo+ID4gPiArICAgICAgIGludCByZXQ7DQo+ID4gPiArICAgICAgIHN0cnVjdCB2NGwy
X3N1YmRldiAqc2QgPSBzb2NfY2FtZXJhX3RvX3N1YmRldihpY2QpOw0KPiA+ID4gKyAgICAgICBj
b25zdCBzdHJ1Y3Qgc29jX2NhbWVyYV9mb3JtYXRfeGxhdGUgKnhsYXRlOw0KPiA+ID4gKyAgICAg
ICBfX3UzMiBwaXhmbXQgPSBmc2l6ZS0+cGl4ZWxfZm9ybWF0Ow0KPiA+ID4gKyAgICAgICBzdHJ1
Y3QgdjRsMl9mcm1zaXplZW51bSBmc2l6ZV9tYnVzID0gKmZzaXplOw0KPiA+ID4gKw0KPiA+ID4g
KyAgICAgICB4bGF0ZSA9IHNvY19jYW1lcmFfeGxhdGVfYnlfZm91cmNjKGljZCwgcGl4Zm10KTsN
Cj4gPiA+ICsgICAgICAgaWYgKCF4bGF0ZSkNCj4gPiA+ICsgICAgICAgICAgICAgICByZXR1cm4g
LUVJTlZBTDsNCj4gPiA+ICsgICAgICAgLyogbWFwIHhsYXRlLWNvZGUgdG8gcGl4ZWxfZm9ybWF0
LCBzZW5zb3Igb25seSBoYW5kbGUgeGxhdGUtY29kZSovDQo+ID4gPiArICAgICAgIGZzaXplX21i
dXMucGl4ZWxfZm9ybWF0ID0geGxhdGUtPmNvZGU7DQo+ID4gPiArDQo+ID4gPiArICAgICAgIHJl
dCA9IHY0bDJfc3ViZGV2X2NhbGwoc2QsIHZpZGVvLCBlbnVtX2ZyYW1lc2l6ZXMsICZmc2l6ZV9t
YnVzKTsNCj4gPiA+ICsgICAgICAgaWYgKHJldCA8IDApDQo+ID4gPiArICAgICAgICAgICAgICAg
cmV0dXJuIHJldDsNCj4gPiA+ICsNCj4gPiA+ICsgICAgICAgKmZzaXplID0gZnNpemVfbWJ1czsN
Cj4gPiA+ICsgICAgICAgZnNpemUtPnBpeGVsX2Zvcm1hdCA9IHBpeGZtdDsNCj4gPiA+ICsNCj4g
PiA+ICsgICAgICAgcmV0dXJuIDA7DQo+ID4gPiArfQ0KPiA+ID4gKw0KPiA+ID4gIHN0YXRpYyB2
b2lkIHNvY19jYW1lcmFfZGV2aWNlX2luaXQoc3RydWN0IGRldmljZSAqZGV2LCB2b2lkICpwZGF0
YSkNCj4gPiA+ICB7DQo+ID4gPiAgICAgICAgIGRldi0+cGxhdGZvcm1fZGF0YSAgICAgID0gcGRh
dGE7DQo+ID4gPiBAQCAtMTE5NSw2ICsxMjI5LDggQEAgaW50IHNvY19jYW1lcmFfaG9zdF9yZWdp
c3RlcihzdHJ1Y3Qgc29jX2NhbWVyYV9ob3N0ICppY2kpDQo+ID4gPiAgICAgICAgICAgICAgICAg
aWNpLT5vcHMtPnNldF9wYXJtID0gZGVmYXVsdF9zX3Bhcm07DQo+ID4gPiAgICAgICAgIGlmICgh
aWNpLT5vcHMtPmdldF9wYXJtKQ0KPiA+ID4gICAgICAgICAgICAgICAgIGljaS0+b3BzLT5nZXRf
cGFybSA9IGRlZmF1bHRfZ19wYXJtOw0KPiA+ID4gKyAgICAgICBpZiAoIWljaS0+b3BzLT5lbnVt
X2ZzaXplcykNCj4gPiA+ICsgICAgICAgICAgICAgICBpY2ktPm9wcy0+ZW51bV9mc2l6ZXMgPSBk
ZWZhdWx0X2VudW1fZnNpemVzOw0KPiA+ID4NCj4gPiA+ICAgICAgICAgbXV0ZXhfbG9jaygmbGlz
dF9sb2NrKTsNCj4gPiA+ICAgICAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeShpeCwgJmhvc3RzLCBs
aXN0KSB7DQo+ID4gPiBAQCAtMTMwMiw2ICsxMzM4LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB2
NGwyX2lvY3RsX29wcyBzb2NfY2FtZXJhX2lvY3RsX29wcyA9IHsNCj4gPiA+ICAgICAgICAgLnZp
ZGlvY19nX2lucHV0ICAgICAgICAgID0gc29jX2NhbWVyYV9nX2lucHV0LA0KPiA+ID4gICAgICAg
ICAudmlkaW9jX3NfaW5wdXQgICAgICAgICAgPSBzb2NfY2FtZXJhX3NfaW5wdXQsDQo+ID4gPiAg
ICAgICAgIC52aWRpb2Nfc19zdGQgICAgICAgICAgICA9IHNvY19jYW1lcmFfc19zdGQsDQo+ID4g
PiArICAgICAgIC52aWRpb2NfZW51bV9mcmFtZXNpemVzICA9IHNvY19jYW1lcmFfZW51bV9mc2l6
ZXMsDQo+ID4gPiAgICAgICAgIC52aWRpb2NfcmVxYnVmcyAgICAgICAgICA9IHNvY19jYW1lcmFf
cmVxYnVmcywNCj4gPiA+ICAgICAgICAgLnZpZGlvY190cnlfZm10X3ZpZF9jYXAgID0gc29jX2Nh
bWVyYV90cnlfZm10X3ZpZF9jYXAsDQo+ID4gPiAgICAgICAgIC52aWRpb2NfcXVlcnlidWYgICAg
ICAgICA9IHNvY19jYW1lcmFfcXVlcnlidWYsDQo+ID4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9t
ZWRpYS9zb2NfY2FtZXJhLmggYi9pbmNsdWRlL21lZGlhL3NvY19jYW1lcmEuaA0KPiA+ID4gaW5k
ZXggODZlMzYzMS4uNmU0ODAwYyAxMDA2NDQNCj4gPiA+IC0tLSBhL2luY2x1ZGUvbWVkaWEvc29j
X2NhbWVyYS5oDQo+ID4gPiArKysgYi9pbmNsdWRlL21lZGlhL3NvY19jYW1lcmEuaA0KPiA+ID4g
QEAgLTg1LDYgKzg1LDcgQEAgc3RydWN0IHNvY19jYW1lcmFfaG9zdF9vcHMgew0KPiA+ID4gICAg
ICAgICBpbnQgKCpzZXRfY3RybCkoc3RydWN0IHNvY19jYW1lcmFfZGV2aWNlICosIHN0cnVjdCB2
NGwyX2NvbnRyb2wgKik7DQo+ID4gPiAgICAgICAgIGludCAoKmdldF9wYXJtKShzdHJ1Y3Qgc29j
X2NhbWVyYV9kZXZpY2UgKiwgc3RydWN0IHY0bDJfc3RyZWFtcGFybSAqKTsNCj4gPiA+ICAgICAg
ICAgaW50ICgqc2V0X3Bhcm0pKHN0cnVjdCBzb2NfY2FtZXJhX2RldmljZSAqLCBzdHJ1Y3QgdjRs
Ml9zdHJlYW1wYXJtICopOw0KPiA+ID4gKyAgICAgICBpbnQgKCplbnVtX2ZzaXplcykoc3RydWN0
IHNvY19jYW1lcmFfZGV2aWNlICosIHN0cnVjdCB2NGwyX2ZybXNpemVlbnVtICopOw0KPiA+ID4g
ICAgICAgICB1bnNpZ25lZCBpbnQgKCpwb2xsKShzdHJ1Y3QgZmlsZSAqLCBwb2xsX3RhYmxlICop
Ow0KPiA+ID4gICAgICAgICBjb25zdCBzdHJ1Y3QgdjRsMl9xdWVyeWN0cmwgKmNvbnRyb2xzOw0K
PiA+ID4gICAgICAgICBpbnQgbnVtX2NvbnRyb2xzOw0KPiA+ID4gLS0NCj4gPiA+IDEuNi4zLjMN
Cj4gPiA+DQo+ID4gPg0KPiA+DQo+ID4gLS0tDQo+ID4gR3Vlbm5hZGkgTGlha2hvdmV0c2tpLCBQ
aC5ELg0KPiA+IEZyZWVsYW5jZSBPcGVuLVNvdXJjZSBTb2Z0d2FyZSBEZXZlbG9wZXINCj4gPiBo
dHRwOi8vd3d3Lm9wZW4tdGVjaG5vbG9neS5kZS8NCj4gPg0KPiA+DQo+DQo+IC0tDQo+IEhhbnMg
VmVya3VpbCAtIHZpZGVvNGxpbnV4IGRldmVsb3BlciAtIHNwb25zb3JlZCBieSBDaXNjbw0KPg0K
DQotLS0NCkd1ZW5uYWRpIExpYWtob3ZldHNraSwgUGguRC4NCkZyZWVsYW5jZSBPcGVuLVNvdXJj
ZSBTb2Z0d2FyZSBEZXZlbG9wZXINCmh0dHA6Ly93d3cub3Blbi10ZWNobm9sb2d5LmRlLw0K
