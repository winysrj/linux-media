Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39630 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbZDUKB6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 06:01:58 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"R, Sivaraj" <sivaraj@ti.com>, "Hadli, Manjunath" <mrh@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"Kumar, Purushotam" <purushotam@ti.com>
Date: Tue, 21 Apr 2009 15:31:40 +0530
Subject: RE: [RFC] Stand-alone Resizer/Previewer Driver support under V4L2
 	framework
Message-ID: <19F8576C6E063C45BE387C64729E739404280C5EAF@dbde02.ent.ti.com>
References: <19F8576C6E063C45BE387C64729E73940427E3F70B@dbde02.ent.ti.com>
	 <200903301902.21783.hverkuil@xs4all.nl>
	 <19F8576C6E063C45BE387C64729E73940427E3F8F1@dbde02.ent.ti.com>
	 <200904181753.47515.hverkuil@xs4all.nl>
	 <793DE56C-45AE-48ED-B26D-A1A4BECC5F87@gmail.com>
	 <19F8576C6E063C45BE387C64729E739404280C5B46@dbde02.ent.ti.com>
 <5e9665e10904200345x7272a24fs6a3e8c72af2e3fe@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhpcmVtYXRoLCBWYWliaGF2
DQo+IFNlbnQ6IFR1ZXNkYXksIEFwcmlsIDIxLCAyMDA5IDM6MTYgUE0NCj4gVG86ICdEb25nc29v
LCBOYXRoYW5pZWwgS2ltJw0KPiBDYzogSGFucyBWZXJrdWlsOyBsaW51eC1tZWRpYUB2Z2VyLmtl
cm5lbC5vcmc7IEFndWlycmUgUm9kcmlndWV6LA0KPiBTZXJnaW8gQWxiZXJ0bzsgVG9pdm9uZW4g
VHV1a2thLk8gKE5va2lhLUQvT3VsdSk7IGxpbnV4LQ0KPiBvbWFwQHZnZXIua2VybmVsLm9yZzsg
TmFnYWxsYSwgSGFyaTsgU2FrYXJpIEFpbHVzOyBKYWRhdiwgQnJpamVzaCBSOw0KPiBSLCBTaXZh
cmFqOyBIYWRsaSwgTWFuanVuYXRoOyBTaGFoLCBIYXJkaWs7IEt1bWFyLCBQdXJ1c2hvdGFtDQo+
IFN1YmplY3Q6IFJFOiBbUkZDXSBTdGFuZC1hbG9uZSBSZXNpemVyL1ByZXZpZXdlciBEcml2ZXIg
c3VwcG9ydA0KPiB1bmRlciBWNEwyIGZyYW1ld29yaw0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiA+IEZyb206IERvbmdzb28sIE5hdGhhbmllbCBLaW0gW21haWx0bzpkb25n
c29vLmtpbUBnbWFpbC5jb21dDQo+ID4gU2VudDogTW9uZGF5LCBBcHJpbCAyMCwgMjAwOSA0OjE1
IFBNDQo+ID4gVG86IEhpcmVtYXRoLCBWYWliaGF2DQo+ID4gQ2M6IEhhbnMgVmVya3VpbDsgbGlu
dXgtbWVkaWFAdmdlci5rZXJuZWwub3JnOyBBZ3VpcnJlIFJvZHJpZ3VleiwNCj4gPiBTZXJnaW8g
QWxiZXJ0bzsgVG9pdm9uZW4gVHV1a2thLk8gKE5va2lhLUQvT3VsdSk7IGxpbnV4LQ0KPiA+IG9t
YXBAdmdlci5rZXJuZWwub3JnOyBOYWdhbGxhLCBIYXJpOyBTYWthcmkgQWlsdXM7IEphZGF2LCBC
cmlqZXNoDQo+IFI7DQo+ID4gUiwgU2l2YXJhajsgSGFkbGksIE1hbmp1bmF0aDsgU2hhaCwgSGFy
ZGlrOyBLdW1hciwgUHVydXNob3RhbQ0KPiA+IFN1YmplY3Q6IFJlOiBbUkZDXSBTdGFuZC1hbG9u
ZSBSZXNpemVyL1ByZXZpZXdlciBEcml2ZXIgc3VwcG9ydA0KPiA+IHVuZGVyIFY0TDIgZnJhbWV3
b3JrDQo+ID4NCj4gPiBIZWxsbyBWYWliaGF2LA0KPiA+DQo+ID4gVGhpcyBpcyB1c2VyIG1hbnVh
bCBvZiBTM0M2NDAwIChub3QgbXVjaCBkaWZmZXJlbnQgZnJvbSBTM0M2NDEwKQ0KPiA+DQo+IGh0
dHA6Ly93d3cuZWJ2LmNvbS9maWxlYWRtaW4vcHJvZHVjdHMvUHJvZHVjdHMvU2Ftc3VuZy9TM0M2
NDAwL1MzQzY0DQo+ID4gMDBYX1VzZXJNYW51YWxfcmV2MS0wXzIwMDgtMDJfNjYxNTU4dW0ucGRm
DQo+ID4NCj4gPiBUaGF0IFNvQyBpcyBmcm9tIG15IGNvbXBhbnkgYnV0IG5vdCBmcm9tIHRoZSBz
YW1lIGRpdmlzaW9uIG9mDQo+IG1pbmUuDQo+ID4gQWN0dWFsbHkgSSdtIGRvaW5nIHRoaXMgZHJp
dmVyIGpvYiB3aXRob3V0IGFueSByZXF1ZXN0IGZyb20gY2hpcA0KPiA+IGRlbGl2ZXJpbmcgZGl2
aXNpb24uIEknbSBkb2luZyB0aGlzIGJlY2F1c2UgdGhpcyBpcyBzbyBjaGFsbGVuZ2luZw0KPiA+
IGFuZA0KPiA+IHdhbnQgYmV0dGVyIGdlbmVyaWMgZHJpdmVyIDotKQ0KPiA+DQo+ID4gVGFrZSBh
IGxvb2sgYXQgdGhlIHVzZXIgbWFudWFsIGFuZCBwbGVhc2UgbGV0IG1lIGtub3cgeW91cg0KPiBv
cGluaW9uLg0KPiA+IEluIG15IHVuZGVyc3RhbmRpbmcgc2NhbGVyIGFuZCBzb21lIGNhbWVyYSBp
bnRlcmZhY2UgZmVhdHVyZSBpbg0KPiA+IFMzQzY0WFggYXJlIHZlcnkgc2ltaWxhciB0byB0aGUg
ZmVhdHVyZXMgaW4gT21hcDMuDQo+ID4NCj4gW0hpcmVtYXRoLCBWYWliaGF2XSBIaSBLaW0sDQo+
IA0KPiBJIHdlbnQgdGhyb3VnaCB0aGUgZG9jdW1lbnQgYW5kIGJlbG93IGFyZSBzb21lIG9ic2Vy
dmF0aW9ucyBhbmQNCj4gcXVlc3Rpb25zIEkgaGF2ZSAtDQo+IA0KPiAJLSBJZiBJIGNvbXBhcmUg
aXQgd2l0aCBPTUFQIHRoZW4gdGhlcmUgaXMgbm90aGluZyBhcHBsaWNhdGlvbg0KPiBuZWVkcyB0
byBjb25maWd1cmUgc3BlY2lmaWMgdG8gaGFyZHdhcmUuIEFsbCB0aGUgcGFyYW1ldGVycw0KPiBz
dXBwb3J0ZWQgdGhyb3VnaCAidjRsMl9mb3JtYXQiIG9uZSB3aXRoIFRZUEVfVklERU9fT1VUUFVU
IGFuZA0KPiBhbm90aGVyIHdpdGggVFlQRV9WSURFT19DQVBUVVJFIGV4Y2VwdCB0aGUgcGFyYW1l
dGVyICJvZmZzZXQiIChJZg0KPiBkcml2ZXIgaXMgc3VwcG9ydGluZyBpdCkNCj4gDQo+IAktIEkg
d2FudGVkIHRvIHVuZGVyc3RhbmQgaG93IGFyZSB5b3UgY29uZmlndXJpbmcgb2Zmc2V0DQo+IHJl
Z2lzdGVyPyBIb3cgYXJlIHlvdSBleHBvcnRpbmcgaXQgdG8gdXNlciBhcHBsaWNhdGlvbj8NCj4g
DQo+IFJlc3QgZXZlcnl0aGluZyB3ZSBjYW4gaGFuZGxlIGluIGRyaXZlciBvbmNlIGlucHV0IHNv
dXJjZSBhbmQgb3V0cHV0DQo+IGRlc3RpbmF0aW9uIGZvcm1hdCByZWNlaXZlcyBmcm9tIGFwcGxp
Y2F0aW9uLg0KPiANCltIaXJlbWF0aCwgVmFpYmhhdl0gTWlzc2VkIG9uZSBwb2ludCBpbiBsYXN0
IGRyYWZ0LCBhYm91dCBidWZmZXIgaGFuZGxpbmcuIEhvdyBhcmUgeW91IGhhbmRsaW5nIGJ1ZmZl
cnM/IEFyZSB5b3Ugc3VwcG9ydGluZyBib3RoIFVTRVJfUE9JTlRFUiBhbmQgTU1BUCBidWZmZXJz
Pw0KV2hhdCBpcyB0aGUgc2l6ZSBvZiBidWZmZXJzLCBpcyB0aGF0IGRpZmZlcmVudCBmb3IgaW5w
dXQgYW5kIG91dHB1dD8NCklmIHllcywgdGhlbiBob3cgYXJlIHlvdSBtYW5hZ2luZyBpdD8NCg0K
SWYgbm8sIGRvbid0IHlvdSBzZWUgcmVxdWlyZW1lbnQgZm9yIGl0Pw0KDQpUaGFua3MsDQpWYWli
aGF2DQoNCj4gRnJvbSBPTUFQIFBvaW50IG9mIHZpZXcgLQ0KPiAtLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPiANCj4gVGhlIGV4dHJhIGNvbmZpZ3VyYXRpb24gaXMgY29lZmZpY2llbnRzLCB3aGlj
aCBpZiB3ZSBkb24ndCBleHBvcnQgdG8NCj4gdXNlciBhcHBsaWNhdGlvbiB0aGVuIEkgdGhpbmsg
d2UgYXJlIHZlcnkgY2xvc2UgdG8geW91ciBJUC4NCj4gDQo+IEV4dHJhIGNvbmZpZ3VyYXRpb24g
cmVxdWlyZWQgb3RoZXIgdGhhbiBjb2VmZi4NCj4gDQo+IFJTWl9ZRU5IIC0gd2hpY2ggdGFrZXMg
NCBwYXJhbXMNCj4gDQo+IAktIEFsZ28NCj4gCS0gR2Fpbg0KPiAJLSBTbG9wZQ0KPiAJLSBDb3Jl
DQo+IA0KPiBBbGwgYXJlIHBhcnQgb2Ygb25lIHJlZ2lzdGVyIHNvIHdlIGNhbiBtYWtlIHVzZSBv
ZiAicHJpdiIgZmllbGQgZm9yDQo+IHRoaXMgY29uZmlndXJhdGlvbi4NCj4gDQo+IA0KPiBUaGFu
a3MsDQo+IFZhaWJoYXYgSGlyZW1hdGgNCj4gDQo+ID4gQ2hlZXJzLA0KPiA+DQo+ID4gTmF0ZQ0K
PiA+DQo+ID4gT24gTW9uLCBBcHIgMjAsIDIwMDkgYXQgNzoxMSBQTSwgSGlyZW1hdGgsIFZhaWJo
YXYNCj4gPGh2YWliaGF2QHRpLmNvbT4NCj4gPiB3cm90ZToNCj4gPiA+DQo+ID4gPg0KPiA+ID4g
VGhhbmtzLA0KPiA+ID4gVmFpYmhhdiBIaXJlbWF0aA0KPiA+ID4NCj4gPiA+PiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4+IEZyb206IGxpbnV4LW1lZGlhLW93bmVyQHZnZXIua2Vy
bmVsLm9yZyBbbWFpbHRvOmxpbnV4LW1lZGlhLQ0KPiA+ID4+IG93bmVyQHZnZXIua2VybmVsLm9y
Z10gT24gQmVoYWxmIE9mIERvbmdzb28gS2ltDQo+ID4gPj4gU2VudDogU3VuZGF5LCBBcHJpbCAx
OSwgMjAwOSAxMjowNiBQTQ0KPiA+ID4+IFRvOiBIYW5zIFZlcmt1aWwNCj4gPiA+PiBDYzogSGly
ZW1hdGgsIFZhaWJoYXY7IGxpbnV4LW1lZGlhQHZnZXIua2VybmVsLm9yZzsgQWd1aXJyZQ0KPiA+
ID4+IFJvZHJpZ3VleiwgU2VyZ2lvIEFsYmVydG87IFRvaXZvbmVuIFR1dWtrYS5PIChOb2tpYS1E
L091bHUpOw0KPiA+IGxpbnV4LQ0KPiA+ID4+IG9tYXBAdmdlci5rZXJuZWwub3JnOyBOYWdhbGxh
LCBIYXJpOyBTYWthcmkgQWlsdXM7IEphZGF2LA0KPiBCcmlqZXNoDQo+ID4gUjsNCj4gPiA+PiBS
LCBTaXZhcmFqOyBIYWRsaSwgTWFuanVuYXRoOyBTaGFoLCBIYXJkaWs7IEt1bWFyLCBQdXJ1c2hv
dGFtDQo+ID4gPj4gU3ViamVjdDogUmU6IFtSRkNdIFN0YW5kLWFsb25lIFJlc2l6ZXIvUHJldmll
d2VyIERyaXZlciBzdXBwb3J0DQo+ID4gPj4gdW5kZXIgVjRMMiBmcmFtZXdvcmsNCj4gPiA+Pg0K
PiA+ID4+IEhlbGxvIEhhbnMgYW5kIEhpcmVtYXRoLA0KPiA+ID4+DQo+ID4gPj4gT25lIG9mIG15
IHJlY2VudCBqb2IgaXMgbWFraW5nIFMzQzY0WFggY2FtZXJhIGludGVyZmFjZSBkcml2ZXINCj4g
PiAoZXZlbg0KPiA+ID4+IHRob3VnaCBvdGhlciBqb2JzIG9mIG1pbmUgYXJlIG5vdCBmaW5pc2hl
ZCB5ZXQuLi47LSgpDQo+ID4gPj4gQW5kLCB3aGF0IGEgaW5jaWRlbnQhIFMzQzY0WFggaGFzIGFs
c28gc2ltaWxhciBIL1cgYmxvY2sgaW4NCj4gPiBjYW1lcmENCj4gPiA+PiBpbnRlcmZhY2UuDQo+
ID4gPj4gUmVzaXplciBpbiBTM0MgY2FtZXJhIGludGVyZmFjZSBjYW4gYmUgdXNlZCBpbiBzeXN0
ZW0gd2lkZSBsaWtlDQo+ID4gdGhlDQo+ID4gPj4gb25lIGluIE9tYXAzLg0KPiA+ID4+DQo+ID4g
PiBbSGlyZW1hdGgsIFZhaWJoYXZdIENhbiB5b3Ugc2hhcmUgdGhlIHNwZWMgZm9yIHRoZSBzYW1l
OyBJDQo+IHdhbnRlZA0KPiA+IHRvIHZlcmlmeSB0aGUgY29uZmlndXJhdGlvbiBwYXJ0IG9mIGl0
PyBXaGF0IGFsbCBjb25maWd1cmF0aW9uIGlzDQo+ID4gZXhwb3J0ZWQgdG8gdGhlIHVzZXI/DQo+
ID4gPg0KPiA+ID4+IEJ1dCBpbiBjYXNlIG9mIG1pbmUsIEkgZGVjaWRlZCB0byBtYWtlIGl0IGFz
IGENCj4gVFlQRV9WSURFT19DQVBUVVJFDQo+ID4gPj4gYW5kDQo+ID4gPj4gVFlQRV9WSURFT19P
VVRQVVQuDQo+ID4gPj4gSSB0aG91Z2h0IHRoYXQgaXMgd2FzIGVub3VnaC4gQWN0dWFsbHkgSSB0
b29rIG9tYXAgdmlkZW8gb3V0DQo+ID4gKHZvdXQ/KQ0KPiA+ID4+IGZvciByZWZlcmVuY2UgOi0p
DQo+ID4gPg0KPiA+ID4gW0hpcmVtYXRoLCBWYWliaGF2XSBJIGhhdmUgYWxzbyBpbXBsZW1lbnRl
ZCB0aGUgZHJpdmVyIGlzIHRoZQ0KPiBzYW1lDQo+ID4gd2F5IGFuZCBhbHNvIHdvcmtpbmcgd2l0
aCBIYW5zIHRvIGdldCBpdCByZXZpZXdlZC4gQnV0IHRoZXJlIGFyZQ0KPiA+IHNvbWUgY29uZmln
dXJhdGlvbiBsaWtlIGNvZWZmLiwgbHVtYSBlbmhhbmNlbWVudCwgZXRjLi4uIG5lZWQgdG8NCj4g
PiBleHBvcnQgdG8gdGhlIHVzZXIsIHdoZXJlIHdlIG5lZWQgdG8gYWRkIG1lY2hhbmlzbSBpbiBW
NEwyDQo+ID4gZnJhbWV3b3JrLg0KPiA+ID4NCj4gPiA+IFNpbmNlIHdlIGhhdmUgb25lIG1vcmUg
ZGV2aWNlIHdoZXJlIHdlIGFyZSBkZW1hbmRpbmcgZm9yIE0tdG8tTQ0KPiA+IG9wZXJhdGlvbiwg
SSB0aGluayBpdCBpcyBpbXBvcnRhbnQgdG8gZ28gdGhyb3VnaCBpdC4gQ2FuIHlvdSBzaGFyZQ0K
PiA+IHNvbWUgZG9jdW1lbnRzIG9mIHlvdXIgSVAgZm9yIGJldHRlciB1bmRlcnN0YW5kaW5nLg0K
PiA+ID4NCj4gPiA+DQo+ID4gPj4gQ2hlZXJzLA0KPiA+ID4+DQo+ID4gPj4gTmF0ZQ0KPiA+ID4+
DQo+ID4gPj4NCj4gPiA+PiAyMDA5LiAwNC4gMTksIOyYpOyghCAxMjo1MywgSGFucyBWZXJrdWls
IOyekeyEsToNCj4gPiA+Pg0KPiA+ID4+ID4gT24gVHVlc2RheSAzMSBNYXJjaCAyMDA5IDEwOjUz
OjAyIEhpcmVtYXRoLCBWYWliaGF2IHdyb3RlOg0KPiA+ID4+ID4+IFRoYW5rcywNCj4gPiA+PiA+
PiBWYWliaGF2IEhpcmVtYXRoDQo+ID4gPj4gPj4NCj4gPiA+PiA+Pj4+IEFQUFJPQUNIIDMgLQ0K
PiA+ID4+ID4+Pj4gLS0tLS0tLS0tLQ0KPiA+ID4+ID4+Pj4NCj4gPiA+PiA+Pj4+IC4uLi4uDQo+
ID4gPj4gPj4+Pg0KPiA+ID4+ID4+Pj4gKEFueSBvdGhlciBhcHByb2FjaCB3aGljaCBJIGNvdWxk
IG5vdCB0aGluayBvZiB3b3VsZCBiZQ0KPiA+ID4+ID4+Pg0KPiA+ID4+ID4+PiBhcHByZWNpYXRl
ZCkNCj4gPiA+PiA+Pj4NCj4gPiA+PiA+Pj4+IEkgd291bGQgcHJlZmVyIHNlY29uZCBhcHByb2Fj
aCwgc2luY2UgdGhpcyB3aWxsIHByb3ZpZGUNCj4gPiA+PiBzdGFuZGFyZA0KPiA+ID4+ID4+Pj4g
aW50ZXJmYWNlIHRvIGFwcGxpY2F0aW9ucyBpbmRlcGVuZGVudCBvbiB1bmRlcm5lYXRoDQo+ID4g
aGFyZHdhcmUuDQo+ID4gPj4gPj4+Pg0KPiA+ID4+ID4+Pj4gVGhlcmUgbWF5IGJlIG1hbnkgbnVt
YmVyIG9mIHN1Y2ggY29uZmlndXJhdGlvbiBwYXJhbWV0ZXJzDQo+ID4gPj4gcmVxdWlyZWQNCj4g
PiA+PiA+Pj4NCj4gPiA+PiA+Pj4gZm9yDQo+ID4gPj4gPj4+DQo+ID4gPj4gPj4+PiBkaWZmZXJl
bnQgc3VjaCBkZXZpY2VzLCB3ZSBuZWVkIHRvIHdvcmsgb24gdGhpcyBhbmQgY29tZQ0KPiB1cA0K
PiA+ID4+IHdpdGgNCj4gPiA+PiA+Pj4NCj4gPiA+PiA+Pj4gc29tZQ0KPiA+ID4+ID4+Pg0KPiA+
ID4+ID4+Pj4gc3RhbmRhcmQgY2FwYWJpbGl0eSBmaWVsZHMgY292ZXJpbmcgbW9zdCBvZiBhdmFp
bGFibGUNCj4gPiBkZXZpY2VzLg0KPiA+ID4+ID4+Pj4NCj4gPiA+PiA+Pj4+IERvZXMgYW55Ym9k
eSBoYXZlIHNvbWUgb3RoZXIgb3BpbmlvbnMgb24gdGhpcz8NCj4gPiA+PiA+Pj4+IEFueSBzdWdn
ZXN0aW9ucyB3aWxsIGJlIGhlbHBmdWwgaGVyZSwNCj4gPiA+PiA+Pj4NCj4gPiA+PiA+Pj4gRllJ
OiBJIGhhdmUgdmVyeSBsaXR0bGUgdGltZSB0byBsb29rIGF0IHRoaXMgZm9yIHRoZSBuZXh0DQo+
IDItMw0KPiA+ID4+IHdlZWtzLg0KPiA+ID4+ID4+PiBBcyB5b3UNCj4gPiA+PiA+Pj4ga25vdyBJ
J20gd29ya2luZyBvbiB0aGUgbGFzdCBwaWVjZXMgb2YgdGhlIHY0bDJfc3ViZGV2DQo+ID4gPj4g
Y29udmVyc2lvbg0KPiA+ID4+ID4+PiBmb3IgMi42LjMwDQo+ID4gPj4gPj4+IHRoYXQgc2hvdWxk
IGJlIGZpbmlzaGVkIHRoaXMgd2Vlay4gQWZ0ZXIgdGhhdCBJJ20gYXR0ZW5kaW5nDQo+ID4gdGhl
DQo+ID4gPj4gPj4+IEVtYmVkZGVkDQo+ID4gPj4gPj4+IExpbnV4IENvbmZlcmVuY2UgaW4gU2Fu
IEZyYW5jaXNjby4NCj4gPiA+PiA+Pj4NCj4gPiA+PiA+Pj4gQnV0IEkgYWx3YXlzIHRob3VnaHQg
dGhhdCBzb21ldGhpbmcgbGlrZSB0aGlzIHdvdWxkIGJlIGp1c3QNCj4gYQ0KPiA+ID4+ID4+PiBy
ZWd1bGFyIHZpZGVvDQo+ID4gPj4gPj4+IGRldmljZSB0aGF0IGNhbiBkbyBib3RoICdvdXRwdXQn
IGFuZCAnY2FwdHVyZScuIEZvciBhDQo+IHJlc2l6ZXINCj4gPiBJDQo+ID4gPj4gPj4+IHdvdWxk
DQo+ID4gPj4gPj4+IGV4cGVjdCB0aGF0IHlvdSBzZXQgdGhlICdvdXRwdXQnIHNpemUgKHRoZSBz
aXplIG9mIHlvdXINCj4gPiBzb3VyY2UNCj4gPiA+PiA+Pj4gaW1hZ2UpIGFuZA0KPiA+ID4+ID4+
PiB0aGUgJ2NhcHR1cmUnIHNpemUgKHRoZSBzaXplIG9mIHRoZSByZXNpemVkIGltYWdlKSwgdGhl
bg0KPiBqdXN0DQo+ID4gPj4gc2VuZA0KPiA+ID4+ID4+PiB0aGUNCj4gPiA+PiA+Pj4gZnJhbWVz
IHRvIHRoZSBkZXZpY2UgKD09IHJlc2l6ZXIpIGFuZCBnZXQgdGhlbSBiYWNrIG9uIHRoZQ0KPiA+
ID4+IGNhcHR1cmUNCj4gPiA+PiA+Pj4gc2lkZS4NCj4gPiA+PiA+Pg0KPiA+ID4+ID4+IFtIaXJl
bWF0aCwgVmFpYmhhdl0gWWVzLCBpdCBpcyBwb3NzaWJsZSB0byBkbyB0aGF0Lg0KPiA+ID4+ID4+
DQo+ID4gPj4gPj4gSGFucywNCj4gPiA+PiA+Pg0KPiA+ID4+ID4+IEkgd2VudCB0aHJvdWdoIHRo
ZSBsaW5rIHJlZmVycmVkIGJ5IFNlcmdpbyBhbmQgSSB0aGluayB3ZQ0KPiA+IHNob3VsZA0KPiA+
ID4+ID4+IGluaGVyaXQNCj4gPiA+PiA+PiBzb21lIGltcGxlbWVudGF0aW9uIGZvciBDT0RFQ3Mg
aGVyZSBmb3Igc3VjaCBkZXZpY2VzLg0KPiA+ID4+ID4+DQo+ID4gPj4gPj4gVjRMMl9CVUZfVFlQ
RV9DT0RFQ0lOIC0gVG8gYWNjZXNzIHRoZSBpbnB1dCBmb3JtYXQuDQo+ID4gPj4gPj4gVjRMMl9C
VUZfVFlQRV9DT0RFQ09VVCAtIFRvIGFjY2VzcyB0aGUgb3V0cHV0IGZvcm1hdC4NCj4gPiA+PiA+
Pg0KPiA+ID4+ID4+IEl0IG1ha2VzIHNlbnNlLCBzaW5jZSBzdWNoIG1lbW9yeS10by1tZW1vcnkg
ZGV2aWNlcyB3aWxsDQo+ID4gbW9zdGx5DQo+ID4gPj4gYmVpbmcNCj4gPiA+PiA+PiB1c2VkIGZy
b20gY29kZWNzIGNvbnRleHQuIEFuZCB0aGlzIHdvdWxkIGJlIG1vcmUgY2xlYXIgZnJvbQ0KPiA+
IHVzZXINCj4gPiA+PiA+PiBhcHBsaWNhdGlvbi4NCj4gPiA+PiA+DQo+ID4gPj4gPiBUbyBiZSBo
b25lc3QsIEkgZG9uJ3Qgc2VlIHRoZSBuZWVkIGZvciB0aGlzLiBJIHRoaW5rDQo+ID4gPj4gPiBU
WVBFX1ZJREVPX0NBUFRVUkUgYW5kDQo+ID4gPj4gPiBUWVBFX1ZJREVPX09VVFBVVCBhcmUgcGVy
ZmVjdGx5IGZpbmUuDQo+ID4gPj4gPg0KPiA+ID4+ID4+IEFuZCBhcyBhY2tub3dsZWRnZWQgYnkg
eW91LCB3ZSBjYW4gdXNlIFZJRElPQ19TX0ZNVCBmb3INCj4gPiBzZXR0aW5nDQo+ID4gPj4gPj4g
cGFyYW1ldGVycy4NCj4gPiA+PiA+Pg0KPiA+ID4+ID4+IE9uZSB0aGluZyBJIGFtIG5vdCBhYmxl
IHRvIGNvbnZpbmNlIG15c2VsZiBpcyB0aGF0LCB1c2luZw0KPiA+ICJwcml2Ig0KPiA+ID4+ID4+
IGZpZWxkDQo+ID4gPj4gPj4gZm9yIGN1c3RvbSBjb25maWd1cmF0aW9uLg0KPiA+ID4+ID4NCj4g
PiA+PiA+IEkgYWdyZWUuIEVzcGVjaWFsbHkgc2luY2UgeW91IGNhbm5vdCB1c2UgaXQgYXMgYSBw
b2ludGVyIHRvDQo+ID4gPj4gYWRkaXRpb24NCj4gPiA+PiA+IGluZm9ybWF0aW9uLg0KPiA+ID4+
ID4NCj4gPiA+PiA+PiBJIHdvdWxkIHByZWZlciBhbmQgcmVjb21tZW5kIGNhcGFiaWxpdHkgYmFz
ZWQNCj4gPiA+PiA+PiBpbnRlcmZhY2UsIHdoZXJlIGFwcGxpY2F0aW9uIHdpbGwgcXVlcnkgdGhl
IGNhcGFiaWxpdHkgb2YNCj4gdGhlDQo+ID4gPj4gPj4gZGV2aWNlIGZvcg0KPiA+ID4+ID4+IGx1
bWEgZW5oYW5jZW1lbnQsIGZpbHRlciBjb2VmZmljaWVudHMgKG51bWJlciBvZiBjb2VmZiBhbmQN
Cj4gPiA+PiBkZXB0aCksDQo+ID4gPj4gPj4gaW50ZXJwb2xhdGlvbiB0eXBlLCBldGMuLi4NCj4g
PiA+PiA+Pg0KPiA+ID4+ID4+IFRoaXMgd2F5IHdlIGNhbiBtYWtlIHN1cmUgdGhhdCwgYW55IHN1
Y2ggZnV0dXJlIGRldmljZXMgY2FuDQo+IGJlDQo+ID4gPj4gPj4gYWRhcHRlZCBieQ0KPiA+ID4+
ID4+IHRoaXMgZnJhbWV3b3JrLg0KPiA+ID4+ID4NCj4gPiA+PiA+IFRoZSBiaWcgcXVlc3Rpb24g
aXMgaG93IG1hbnkgb2YgdGhlc2UgY2FwYWJpbGl0aWVzIGFyZQ0KPiA+ICdnZW5lcmljJw0KPiA+
ID4+IGFuZA0KPiA+ID4+ID4gaG93DQo+ID4gPj4gPiBtYW55IGFyZSB2ZXJ5IG11Y2ggaGFyZHdh
cmUgc3BlY2lmaWMuIEkgYW0gbGVhbmluZyB0b3dhcmRzDQo+ID4gdXNpbmcNCj4gPiA+PiB0aGUN
Cj4gPiA+PiA+IGV4dGVuZGVkIGNvbnRyb2wgQVBJIGZvciB0aGlzLiBJdCdzIGEgYml0IGF3a3dh
cmQgdG8NCj4gaW1wbGVtZW50DQo+ID4gaW4NCj4gPiA+PiA+IGRyaXZlcnMNCj4gPiA+PiA+IGF0
IHRoZSBtb21lbnQsIGJ1dCB0aGF0IHNob3VsZCBpbXByb3ZlIGluIHRoZSBmdXR1cmUgd2hlbiBh
DQo+IGxvdA0KPiA+IG9mDQo+ID4gPj4gdGhlDQo+ID4gPj4gPiBjb250cm9sIGhhbmRsaW5nIGNv
ZGUgd2lsbCBtb3ZlIGludG8gdGhlIG5ldyBjb3JlIGZyYW1ld29yay4NCj4gPiA+PiA+DQo+ID4g
Pj4gPiBJIHJlYWxseSBuZWVkIHRvIGtub3cgbW9yZSBhYm91dCB0aGUgc29ydCBvZiBmZWF0dXJl
cyB0aGF0DQo+ID4gb21hcC8NCj4gPiA+PiA+IGRhdmluY2kNCj4gPiA+PiA+IG9mZmVyIChhbmQg
cHJlZmVyYWJseSBhbHNvIGZvciBzaW1pbGFyIGRldmljZXMgYnkgb3RoZXINCj4gPiA+PiA+IG1h
bnVmYWN0dXJlcnMpLg0KPiA+ID4+ID4NCj4gPiA+PiA+Pg0KPiA+ID4+ID4+DQo+ID4gPj4gPj4g
SGFucywNCj4gPiA+PiA+PiBIYXZlIHlvdSBnZXQgYSBjaGFuY2UgdG8gbG9vayBhdCBWaWRlby1C
dWYgbGF5ZXIgaXNzdWVzIEkNCj4gPiA+PiBtZW50aW9uZWQNCj4gPiA+PiA+PiBpbg0KPiA+ID4+
ID4+IG9yaWdpbmFsIGRyYWZ0Pw0KPiA+ID4+ID4NCj4gPiA+PiA+IEkndmUgYXNrZWQgTWFnbnVz
IERhbW0gdG8gdGFrZSBhIGxvb2sgYXQgdGhpcy4gSSBrbm93IGhlIGRpZA0KPiA+IHNvbWUNCj4g
PiA+PiA+IHdvcmsgaW4NCj4gPiA+PiA+IHRoaXMgYXJlYSBhbmQgaGUgbWF5IGhhdmUgZml4ZWQg
c29tZSBvZiB0aGVzZSBpc3N1ZXMgYWxyZWFkeS4NCj4gPiBWZXJ5DQo+ID4gPj4gPiB1c2VmdWws
DQo+ID4gPj4gPiB0aGF0IEVtYmVkZGVkIExpbnV4IGNvbmZlcmVuY2UuLi4NCj4gPiA+PiA+DQo+
ID4gPj4gPiBSZWdhcmRzLA0KPiA+ID4+ID4NCj4gPiA+PiA+ICAgICBIYW5zDQo+ID4gPj4gPg0K
PiA+ID4+ID4gLS0NCj4gPiA+PiA+IEhhbnMgVmVya3VpbCAtIHZpZGVvNGxpbnV4IGRldmVsb3Bl
ciAtIHNwb25zb3JlZCBieSBUQU5EQkVSRw0KPiA+ID4+DQo+ID4gPj4gPQ0KPiA+ID4+IERvbmdT
b28sIE5hdGhhbmllbCBLaW0NCj4gPiA+PiBFbmdpbmVlcg0KPiA+ID4+IE1vYmlsZSBTL1cgUGxh
dGZvcm0gTGFiLg0KPiA+ID4+IERpZ2l0YWwgTWVkaWEgJiBDb21tdW5pY2F0aW9ucyBSJkQgQ2Vu
dHJlDQo+ID4gPj4gU2Ftc3VuZyBFbGVjdHJvbmljcyBDTy4sIExURC4NCj4gPiA+PiBlLW1haWwg
OiBkb25nc29vLmtpbUBnbWFpbC5jb20NCj4gPiA+PiAgICAgICAgICAgIGRvbmdzb280NS5raW1A
c2Ftc3VuZy5jb20NCj4gPiA+Pg0KPiA+ID4+DQo+ID4gPj4NCj4gPiA+PiAtLQ0KPiA+ID4+IFRv
IHVuc3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBsaW5lICJ1bnN1YnNjcmliZQ0K
PiBsaW51eC0NCj4gPiA+PiBtZWRpYSIgaW4NCj4gPiA+PiB0aGUgYm9keSBvZiBhIG1lc3NhZ2Ug
dG8gbWFqb3Jkb21vQHZnZXIua2VybmVsLm9yZw0KPiA+ID4+IE1vcmUgbWFqb3Jkb21vIGluZm8g
YXQgIGh0dHA6Ly92Z2VyLmtlcm5lbC5vcmcvbWFqb3Jkb21vLQ0KPiA+IGluZm8uaHRtbA0KPiA+
ID4NCj4gPiA+DQo+ID4NCj4gPg0KPiA+DQo+ID4gLS0NCj4gPiA9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA+IERvbmdTb28sIE5hdGhh
bmllbCBLaW0NCj4gPiBFbmdpbmVlcg0KPiA+IE1vYmlsZSBTL1cgUGxhdGZvcm0gTGFiLg0KPiA+
IERpZ2l0YWwgTWVkaWEgJiBDb21tdW5pY2F0aW9ucyBSJkQgQ2VudHJlDQo+ID4gU2Ftc3VuZyBF
bGVjdHJvbmljcyBDTy4sIExURC4NCj4gPiBlLW1haWwgOiBkb25nc29vLmtpbUBnbWFpbC5jb20N
Cj4gPiAgICAgICAgICAgZG9uZ3NvbzQ1LmtpbUBzYW1zdW5nLmNvbQ0KPiA+ID09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQoNCg==
