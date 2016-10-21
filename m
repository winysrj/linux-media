Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:48114 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932967AbcJUNPe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 09:15:34 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Antti Palosaari" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: RE: [RFC 3/5] media: platform: rcar_drif: Add DRIF support
Date: Fri, 21 Oct 2016 13:15:28 +0000
Message-ID: <SG2PR06MB1038D6897CE9CF5DE68ED67AC3D40@SG2PR06MB1038.apcprd06.prod.outlook.com>
References: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1476281429-27603-4-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <CAMuHMdXvGEm3bdNOsa6Q1FLB9yMSTAzO4nHcCb-pnYYwg6f6Cg@mail.gmail.com>
In-Reply-To: <CAMuHMdXvGEm3bdNOsa6Q1FLB9yMSTAzO4nHcCb-pnYYwg6f6Cg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgR2VlcnQsDQoNClRoYW5rIHlvdSBmb3IgdGhlIHJldmlldyBjb21tZW50cy4NCg0KPiBPbiBX
ZWQsIE9jdCAxMiwgMjAxNiBhdCA0OjEwIFBNLCBSYW1lc2ggU2hhbm11Z2FzdW5kYXJhbQ0KPiA8
cmFtZXNoLnNoYW5tdWdhc3VuZGFyYW1AYnAucmVuZXNhcy5jb20+IHdyb3RlOg0KPiA+IFRoaXMg
cGF0Y2ggYWRkcyBEaWdpdGFsIFJhZGlvIEludGVyZmFjZSAoRFJJRikgc3VwcG9ydCB0byBSLUNh
ciBHZW4zDQo+IFNvQ3MuDQo+ID4gVGhlIGRyaXZlciBleHBvc2VzIGVhY2ggaW5zdGFuY2Ugb2Yg
RFJJRiBhcyBhIFY0TDIgU0RSIGRldmljZS4gQSBEUklGDQo+ID4gZGV2aWNlIHJlcHJlc2VudHMg
YSBjaGFubmVsIGFuZCBlYWNoIGNoYW5uZWwgY2FuIGhhdmUgb25lIG9yIHR3bw0KPiA+IHN1Yi1j
aGFubmVscyByZXNwZWN0aXZlbHkgZGVwZW5kaW5nIG9uIHRoZSB0YXJnZXQgYm9hcmQuDQo+ID4N
Cj4gPiBEUklGIHN1cHBvcnRzIG9ubHkgUnggZnVuY3Rpb25hbGl0eS4gSXQgcmVjZWl2ZXMgc2Ft
cGxlcyBmcm9tIGEgUkYNCj4gPiBmcm9udGVuZCB0dW5lciBjaGlwIGl0IGlzIGludGVyZmFjZWQg
d2l0aC4gVGhlIGNvbWJpbmF0aW9uIG9mIERSSUYgYW5kDQo+ID4gdGhlIHR1bmVyIGRldmljZSwg
d2hpY2ggaXMgcmVnaXN0ZXJlZCBhcyBhIHN1Yi1kZXZpY2UsIGRldGVybWluZXMgdGhlDQo+ID4g
cmVjZWl2ZSBzYW1wbGUgcmF0ZSBhbmQgZm9ybWF0Lg0KPiA+DQo+ID4gSW4gb3JkZXIgdG8gYmUg
Y29tcGxpYW50IGFzIGEgVjRMMiBTRFIgZGV2aWNlLCBEUklGIG5lZWRzIHRvIGJpbmQgd2l0aA0K
PiA+IHRoZSB0dW5lciBkZXZpY2UsIHdoaWNoIGNhbiBiZSBwcm92aWRlZCBieSBhIHRoaXJkIHBh
cnR5IHZlbmRvci4gRFJJRg0KPiA+IGFjdHMgYXMgYSBzbGF2ZSBkZXZpY2UgYW5kIHRoZSB0dW5l
ciBkZXZpY2UgYWN0cyBhcyBhIG1hc3Rlcg0KPiA+IHRyYW5zbWl0dGluZyB0aGUgc2FtcGxlcy4g
VGhlIGRyaXZlciBhbGxvd3MgYXN5bmNocm9ub3VzIGJpbmRpbmcgb2YgYQ0KPiA+IHR1bmVyIGRl
dmljZSB0aGF0IGlzIHJlZ2lzdGVyZWQgYXMgYSB2NGwyIHN1Yi1kZXZpY2UuIFRoZSBkcml2ZXIg
Y2FuDQo+ID4gbGVhcm4gYWJvdXQgdGhlIHR1bmVyIGl0IGlzIGludGVyZmFjZWQgd2l0aCBiYXNl
ZCBvbiBwb3J0IGVuZHBvaW50DQo+ID4gcHJvcGVydGllcyBvZiB0aGUgZGV2aWNlIGluIGRldmlj
ZSB0cmVlLiBUaGUgVjRMMiBTRFIgZGV2aWNlIGluaGVyaXRzDQo+ID4gdGhlIGNvbnRyb2xzIGV4
cG9zZWQgYnkgdGhlIHR1bmVyIGRldmljZS4NCj4gPg0KPiA+IFRoZSBkZXZpY2UgY2FuIGFsc28g
YmUgY29uZmlndXJlZCB0byB1c2UgZWl0aGVyIG9uZSBvciBib3RoIG9mIHRoZQ0KPiA+IGRhdGEg
cGlucyBhdCBydW50aW1lIGJhc2VkIG9uIHRoZSBtYXN0ZXIgKHR1bmVyKSBjb25maWd1cmF0aW9u
Lg0KPiANCj4gVGhhbmtzIGZvciB5b3VyIHBhdGNoIQ0KPiANCj4gPiAtLS0gL2Rldi9udWxsDQo+
ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL3JlbmVzYXMs
ZHJpZi50eHQNCj4gPiBAQCAtMCwwICsxLDEwOSBAQA0KPiA+ICtSZW5lc2FzIFItQ2FyIEdlbjMg
RFJJRiBjb250cm9sbGVyIChEUklGKQ0KPiA+ICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KPiA+ICsNCj4gPiArUmVxdWlyZWQgcHJvcGVydGllczoNCj4gPiArLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCj4gPiArLSBjb21wYXRpYmxlOiAicmVuZXNhcyxkcmlmLXI4YTc3
OTUiIGlmIERSSUYgY29udHJvbGxlciBpcyBhIHBhcnQgb2YNCj4gUjhBNzc5NSBTb0MuDQo+IA0K
PiAicmVuZXNhcyxyOGE3Nzk1LWRyaWYiLCBhcyBSb2IgYWxyZWFkeSBwb2ludGVkIG91dC4NCg0K
QWdyZWVkLg0KDQo+IA0KPiA+ICsgICAgICAgICAgICAgInJlbmVzYXMscmNhci1nZW4zLWRyaWYi
IGZvciBhIGdlbmVyaWMgUi1DYXIgR2VuMw0KPiBjb21wYXRpYmxlIGRldmljZS4NCj4gPiArICAg
ICAgICAgICAgIFdoZW4gY29tcGF0aWJsZSB3aXRoIHRoZSBnZW5lcmljIHZlcnNpb24sIG5vZGVz
IG11c3QgbGlzdA0KPiB0aGUNCj4gPiArICAgICAgICAgICAgIFNvQy1zcGVjaWZpYyB2ZXJzaW9u
IGNvcnJlc3BvbmRpbmcgdG8gdGhlIHBsYXRmb3JtIGZpcnN0DQo+ID4gKyAgICAgICAgICAgICBm
b2xsb3dlZCBieSB0aGUgZ2VuZXJpYyB2ZXJzaW9uLg0KPiA+ICsNCj4gPiArLSByZWc6IG9mZnNl
dCBhbmQgbGVuZ3RoIG9mIGVhY2ggc3ViLWNoYW5uZWwuDQo+ID4gKy0gaW50ZXJydXB0czogYXNz
b2NpYXRlZCB3aXRoIGVhY2ggc3ViLWNoYW5uZWwuDQo+ID4gKy0gY2xvY2tzOiBwaGFuZGxlcyBh
bmQgY2xvY2sgc3BlY2lmaWVycyBmb3IgZWFjaCBzdWItY2hhbm5lbC4NCj4gPiArLSBjbG9jay1u
YW1lczogY2xvY2sgaW5wdXQgbmFtZSBzdHJpbmdzOiAiZmNrMCIsICJmY2sxIi4NCj4gPiArLSBw
aW5jdHJsLTA6IHBpbiBjb250cm9sIGdyb3VwIHRvIGJlIHVzZWQgZm9yIHRoaXMgY29udHJvbGxl
ci4NCj4gPiArLSBwaW5jdHJsLW5hbWVzOiBtdXN0IGJlICJkZWZhdWx0Ii4NCj4gPiArLSBkbWFz
OiBwaGFuZGxlcyB0byB0aGUgRE1BIGNoYW5uZWxzIGZvciBlYWNoIHN1Yi1jaGFubmVsLg0KPiA+
ICstIGRtYS1uYW1lczogbmFtZXMgZm9yIHRoZSBETUEgY2hhbm5lbHM6ICJyeDAiLCAicngxIi4N
Cj4gPiArDQo+ID4gK1JlcXVpcmVkIGNoaWxkIG5vZGVzOg0KPiA+ICstLS0tLS0tLS0tLS0tLS0t
LS0tLS0NCj4gPiArLSBFYWNoIERSSUYgY2hhbm5lbCBjYW4gaGF2ZSBvbmUgb3IgYm90aCBvZiB0
aGUgc3ViLWNoYW5uZWxzIGVuYWJsZWQNCj4gPiAraW4gYQ0KPiA+ICsgIHNldHVwLiBUaGUgc3Vi
LWNoYW5uZWxzIGFyZSByZXByZXNlbnRlZCBhcyBhIGNoaWxkIG5vZGUuIFRoZSBuYW1lDQo+ID4g
K29mIHRoZQ0KPiA+ICsgIGNoaWxkIG5vZGVzIGFyZSAic3ViLWNoYW5uZWwwIiBhbmQgInN1Yi1j
aGFubmVsMSIgcmVzcGVjdGl2ZWx5Lg0KPiA+ICtFYWNoIGNoaWxkDQo+ID4gKyAgbm9kZSBzdXBw
b3J0cyB0aGUgInN0YXR1cyIgcHJvcGVydHkgb25seSwgd2hpY2ggaXMgdXNlZCB0bw0KPiA+ICtl
bmFibGUvZGlzYWJsZQ0KPiA+ICsgIHRoZSByZXNwZWN0aXZlIHN1Yi1jaGFubmVsLg0KPiANCj4g
PiArRXhhbXBsZQ0KPiA+ICstLS0tLS0tLQ0KPiA+ICsNCj4gPiArU29DIGNvbW1vbiBkdHNpIGZp
bGUNCj4gPiArDQo+ID4gK2RyaWYwOiByaWZAZTZmNDAwMDAgew0KPiA+ICsgICAgICAgY29tcGF0
aWJsZSA9ICJyZW5lc2FzLGRyaWYtcjhhNzc5NSIsDQo+ID4gKyAgICAgICAgICAgICAgICAgICJy
ZW5lc2FzLHJjYXItZ2VuMy1kcmlmIjsNCj4gPiArICAgICAgIHJlZyA9IDwwIDB4ZTZmNDAwMDAg
MCAweDY0PiwgPDAgMHhlNmY1MDAwMCAwIDB4NjQ+Ow0KPiA+ICsgICAgICAgaW50ZXJydXB0cyA9
IDxHSUNfU1BJIDEyIElSUV9UWVBFX0xFVkVMX0hJR0g+LA0KPiA+ICsgICAgICAgICAgICAgICAg
ICA8R0lDX1NQSSAxMyBJUlFfVFlQRV9MRVZFTF9ISUdIPjsNCj4gPiArICAgICAgIGNsb2NrcyA9
IDwmY3BnIENQR19NT0QgNTE1PiwgPCZjcGcgQ1BHX01PRCA1MTQ+Ow0KPiA+ICsgICAgICAgY2xv
Y2stbmFtZXMgPSAiZmNrMCIsICJmY2sxIjsNCj4gPiArICAgICAgIGRtYXMgPSA8JmRtYWMxIDB4
MjA+LCA8JmRtYWMxIDB4MjI+Ow0KPiA+ICsgICAgICAgZG1hLW5hbWVzID0gInJ4MCIsICJyeDEi
Ow0KPiANCj4gSSBjb3VsZCBub3QgZmluZCB0aGUgRE1BQyBjaGFubmVscyBpbiB0aGUgZGF0YXNo
ZWV0Pw0KDQpJdCBpcyBtZW50aW9uZWQgb25seSBpbiB2MC41IGgvdyBtYW51YWwuIHYwLjUyIG1h
bnVhbCBpbnRyb2R1Y2VkIERSSUYgY2hhcHRlciBidXQgdGhlbiBzb21lIG9mIHRoZSBvbGQgcmVm
ZXJlbmNlcyB3ZXJlIG1pc3NpbmcgOi0oLiBUaGVyZSBhcmUgZmV3IG1vcmUgZG9jIGFub21hbGll
cywgd2hpY2ggSSBzaGFsbCBkb2N1bWVudCBpbiB0aGUgbmV4dCB2ZXJzaW9uIG9mIHRoZSBwYXRj
aC4NCg0KPiBNb3N0IG1vZHVsZXMgYXJlIGVpdGhlciB0aWVkIHRvIGRtYWMwLCBvciB0d28gYm90
aCBkbWFjMSBhbmQgZG1hYzIuDQo+IEluIHRoZSBsYXR0ZXIgY2FzZSwgeW91IHdhbnQgdG8gbGlz
dCB0d28gc2V0cyBvZiBkbWFzLCBvbmUgZm9yIGVhY2ggRE1BQy4NCg0KWW91IGFyZSByaWdodC4g
SSBoYXZlIGFkZGVkIGJvdGggZG1hYzEgJiAyIG5vdy4NCg0KPiANCj4gPiArICAgICAgIHBvd2Vy
LWRvbWFpbnMgPSA8JnN5c2MgUjhBNzc5NV9QRF9BTFdBWVNfT04+Ow0KPiA+ICsgICAgICAgc3Rh
dHVzID0gImRpc2FibGVkIjsNCj4gPiArDQo+ID4gKyAgICAgICBzdWItY2hhbm5lbDAgew0KPiA+
ICsgICAgICAgICAgICAgICBzdGF0dXMgPSAiZGlzYWJsZWQiOw0KPiA+ICsgICAgICAgfTsNCj4g
PiArDQo+ID4gKyAgICAgICBzdWItY2hhbm5lbDEgew0KPiA+ICsgICAgICAgICAgICAgICBzdGF0
dXMgPSAiZGlzYWJsZWQiOw0KPiA+ICsgICAgICAgfTsNCj4gPiArDQo+ID4gK307DQo+IA0KPiBB
cyB5b3UncmUgbW9kZWxsaW5nIHRoaXMgaW4gRFQgdW5kZXIgYSBzaW5nbGUgZGV2aWNlIG5vZGUs
IHRoaXMgbWVhbnMgeW91DQo+IGNhbm5vdCB1c2UgcnVudGltZSBQTSB0byBtYW5hZ2UgdGhlIG1v
ZHVsZSBjbG9ja3Mgb2YgdGhlIGluZGl2aWR1YWwNCj4gY2hhbm5lbHMuDQo+IA0KPiBBbiBhbHRl
cm5hdGl2ZSBjb3VsZCBiZSB0byBoYXZlIHR3byBzZXBhcmF0ZSBub2RlcyBmb3IgZWFjaCBjaGFu
bmVsLCBhbmQNCj4gdGllIHRoZW0gdG9nZXRoZXIgdXNpbmcgYSBwaGFuZGxlLg0KDQpJIGFncmVl
ICYgdGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbi4gSXMgdGhlIGJlbG93IG1vZGVsIGxvb2tzIGFu
eXRoaW5nIGNsb3Nlcj8gQXBwcmVjaWF0ZSB5b3VyIGlucHV0cy4NCg0KZHRzaQ0KLS0tLS0tLQ0K
DQogICAgICAgICAgICAgICAgZHJpZjAwOiByaWZAZTZmNDAwMDAgew0KICAgICAgICAgICAgICAg
ICAgICAgICAgY29tcGF0aWJsZSA9ICJyZW5lc2FzLHI4YTc3OTUtZHJpZiIsDQoJCQkJCQkJCQkg
InJlbmVzYXMscmNhci1nZW4zLWRyaWYiOw0KICAgICAgICAgICAgICAgICAgICAgICAgcmVnID0g
PDAgMHhlNmY0MDAwMCAwIDB4NjQ+Ow0KICAgICAgICAgICAgICAgICAgICAgICAgaW50ZXJydXB0
cyA9IDxHSUNfU1BJIDEyIElSUV9UWVBFX0xFVkVMX0hJR0g+Ow0KICAgICAgICAgICAgICAgICAg
ICAgICAgY2xvY2tzID0gPCZjcGcgQ1BHX01PRCA1MTU+Ow0KICAgICAgICAgICAgICAgICAgICAg
ICAgY2xvY2stbmFtZXMgPSAiZmNrIjsNCiAgICAgICAgICAgICAgICAgICAgICAgIGRtYXMgPSA8
JmRtYWMxIDB4MjA+LCA8JmRtYWMyIDB4MjA+Ow0KICAgICAgICAgICAgICAgICAgICAgICAgZG1h
LW5hbWVzID0gInJ4IjsNCiAgICAgICAgICAgICAgICAgICAgICAgIHBvd2VyLWRvbWFpbnMgPSA8
JnN5c2MgUjhBNzc5NV9QRF9BTFdBWVNfT04+Ow0KICAgICAgICAgICAgICAgICAgICAgICAgc3Rh
dHVzID0gImRpc2FibGVkIjsNCiAgICAgICAgICAgICAgICB9OyAgIA0KDQogICAgICAgICAgICAg
ICAgZHJpZjAxOiByaWZAZTZmNTAwMDAgew0KICAgICAgICAgICAgICAgICAgICAgICAgY29tcGF0
aWJsZSA9ICJyZW5lc2FzLHI4YTc3OTUtZHJpZiIsDQoJCQkJCQkJCQkgInJlbmVzYXMscmNhci1n
ZW4zLWRyaWYiOw0KICAgICAgICAgICAgICAgICAgICAgICAgcmVnID0gPDAgMHhlNmY1MDAwMCAw
IDB4NjQ+Ow0KICAgICAgICAgICAgICAgICAgICAgICAgaW50ZXJydXB0cyA9IDxHSUNfU1BJIDEz
IElSUV9UWVBFX0xFVkVMX0hJR0g+Ow0KICAgICAgICAgICAgICAgICAgICAgICAgY2xvY2tzID0g
PCZjcGcgQ1BHX01PRCA1MTQ+Ow0KICAgICAgICAgICAgICAgICAgICAgICAgY2xvY2stbmFtZXMg
PSAiZmNrIjsNCiAgICAgICAgICAgICAgICAgICAgICAgIGRtYXMgPSA8JmRtYWMxIDB4MjI+LCA8
JmRtYWMyIDB4MjI+Ow0KICAgICAgICAgICAgICAgICAgICAgICAgZG1hLW5hbWVzID0gInJ4IjsN
CiAgICAgICAgICAgICAgICAgICAgICAgIHBvd2VyLWRvbWFpbnMgPSA8JnN5c2MgUjhBNzc5NV9Q
RF9BTFdBWVNfT04+Ow0KICAgICAgICAgICAgICAgICAgICAgICAgc3RhdHVzID0gImRpc2FibGVk
IjsNCiAgICAgICAgICAgICAgICB9Ow0KCQkJCQ0KICAgICAgICAgICAgICAgIGRyaWYwOiByaWZA
MCB7DQogICAgICAgICAgICAgICAgICAgICAgICBjb21wYXRpYmxlID0gInJlbmVzYXMscjhhNzc5
NS1kcmlmIiwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAicmVuZXNhcyxy
Y2FyLWdlbjMtZHJpZiI7DQoJCQkJCQlzdWItY2hhbm5lbHMgPSA8JmRyaWYwMD4sIDwmZHJpZjAx
PjsNCiAgICAgICAgICAgICAgICAgICAgICAgIHN0YXR1cyA9ICJkaXNhYmxlZCI7DQoJCQkJCQkN
CiAgICAgICAgICAgICAgICB9OyAgIA0KDQotLS0tLS0tDQpib2FyZCBkdHMgZmlsZSB3b3VsZCBo
YXZlIHNvbWV0aGluZyBsaWtlIHRoaXMNCg0KJmRyaWYwMCB7DQogICAgICAgIHN0YXR1cyA9ICJv
a2F5IjsNCn07ICAgICAgDQogICAgICAgIA0KJmRyaWYwMSB7DQogICAgICAgIHN0YXR1cyA9ICJv
a2F5IjsNCn07ICAgICAgDQogICAgICAgIA0KJmRyaWYwIHsNCiAgICAgICAgcGluY3RybC0wID0g
PCZkcmlmMF9waW5zPjsNCiAgICAgICAgcGluY3RybC1uYW1lcyA9ICJkZWZhdWx0IjsNCiAgICAg
ICAgc3RhdHVzID0gIm9rYXkiOw0KDQogICAgICAgIHBvcnQgew0KICAgICAgICAgICAgICAgIGRy
aWYwX2VwOiBlbmRwb2ludCB7DQogICAgICAgICAgICAgICAgICAgICByZW1vdGUtZW5kcG9pbnQg
PSA8Jm1heDIxNzVfMF9lcD47DQogICAgICAgICAgICAgICAgfTsNCiAgICAgICAgfTsNCn07DQot
LS0tLS0tDQpUaGUgZHJpZjBYIGRyaXZlciBpbnN0YW5jZSB3aWxsIGhlbHAgb25seSBpbiByZWdp
c3RlcmluZyB3aXRoIGdlbnBkLg0KVGhlIHBhcmVudCBkcmlmMCBpbnN0YW5jZSB3aWxsIHBhcnNl
ICJzdWItY2hhbm5lbHMiIHBoYW5kbGVzIGFuZCB1c2UgdGhlIHJlc291cmNlcyBvZiByZXNwZWN0
aXZlIGVuYWJsZWQgc3ViLWNoYW5uZWxzIHVzaW5nIGl0J3MgcGRldi4gDQoNClRoYW5rcywNClJh
bWVzaA0KDQo=
