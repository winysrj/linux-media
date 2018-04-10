Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:18239 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752057AbeDJJze (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 05:55:34 -0400
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: =?utf-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        TOMOHARU FUKAWA <tomoharu.fukawa.eb@renesas.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Simon Horman <horms@verge.net.au>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Fabrizio Castro" <fabrizio.castro@bp.renesas.com>
Subject: RE: [PATCH v13 02/33] dt-bindings: media: rcar_vin: add device tree
 support for r8a774[35]
Date: Tue, 10 Apr 2018 09:55:29 +0000
Message-ID: <TY1PR01MB17703A92A8B0DF3758D00F1BC0BE0@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
 <20180326214456.6655-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180326214456.6655-3-niklas.soderlund+renesas@ragnatech.se>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RGVhciBBbGwsDQoNCnRoaXMgcGF0Y2ggd2FzIG9yaWdpbmFsbHkgc2VudCBvbiB0aGUgMTYvMTEv
MjAxNywgYW5kIHJlcG9zdGVkIGEgZmV3IHRpbWVzLCBkb2VzIGFueWJvZHkga25vdyB3aG8gaXMg
c3VwcG9zZWQgdG8gdGFrZSBpdD8NCg0KVGhhbmtzLA0KRmFiDQoNCj4gLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCj4gRnJvbTogTmlrbGFzIFPDtmRlcmx1bmQgW21haWx0bzpuaWtsYXMuc29k
ZXJsdW5kK3JlbmVzYXNAcmFnbmF0ZWNoLnNlXQ0KPiBTZW50OiAyNiBNYXJjaCAyMDE4IDIyOjQ0
DQo+IFRvOiBMYXVyZW50IFBpbmNoYXJ0IDxsYXVyZW50LnBpbmNoYXJ0QGlkZWFzb25ib2FyZC5j
b20+OyBIYW5zIFZlcmt1aWwgPGh2ZXJrdWlsQHhzNGFsbC5ubD47IGxpbnV4LW1lZGlhQHZnZXIu
a2VybmVsLm9yZw0KPiBDYzogbGludXgtcmVuZXNhcy1zb2NAdmdlci5rZXJuZWwub3JnOyBUT01P
SEFSVSBGVUtBV0EgPHRvbW9oYXJ1LmZ1a2F3YS5lYkByZW5lc2FzLmNvbT47IEtpZXJhbiBCaW5n
aGFtDQo+IDxraWVyYW4uYmluZ2hhbUBpZGVhc29uYm9hcmQuY29tPjsgRmFicml6aW8gQ2FzdHJv
IDxmYWJyaXppby5jYXN0cm9AYnAucmVuZXNhcy5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCB2MTMg
MDIvMzNdIGR0LWJpbmRpbmdzOiBtZWRpYTogcmNhcl92aW46IGFkZCBkZXZpY2UgdHJlZSBzdXBw
b3J0IGZvciByOGE3NzRbMzVdDQo+DQo+IEZyb206IEZhYnJpemlvIENhc3RybyA8ZmFicml6aW8u
Y2FzdHJvQGJwLnJlbmVzYXMuY29tPg0KPg0KPiBBZGQgY29tcGF0aWJsZSBzdHJpbmdzIGZvciBy
OGE3NzQzIGFuZCByOGE3NzQ1LiBObyBkcml2ZXIgY2hhbmdlDQo+IGlzIG5lZWRlZCBhcyAicmVu
ZXNhcyxyY2FyLWdlbjItdmluIiB3aWxsIGFjdGl2YXRlIHRoZSByaWdodCBjb2RlLg0KPiBIb3dl
dmVyLCBpdCBpcyBnb29kIHByYWN0aWNlIHRvIGRvY3VtZW50IGNvbXBhdGlibGUgc3RyaW5ncyBm
b3IgdGhlDQo+IHNwZWNpZmljIFNvQyBhcyB0aGlzIGFsbG93cyBTb0Mgc3BlY2lmaWMgY2hhbmdl
cyB0byB0aGUgZHJpdmVyIGlmDQo+IG5lZWRlZCwgaW4gYWRkaXRpb24gdG8gZG9jdW1lbnQgU29D
IHN1cHBvcnQgYW5kIHRoZXJlZm9yZSBhbGxvdw0KPiBjaGVja3BhdGNoLnBsIHRvIHZhbGlkYXRl
IGNvbXBhdGlibGUgc3RyaW5nIHZhbHVlcy4NCj4NCj4gU2lnbmVkLW9mZi1ieTogRmFicml6aW8g
Q2FzdHJvIDxmYWJyaXppby5jYXN0cm9AYnAucmVuZXNhcy5jb20+DQo+IFJldmlld2VkLWJ5OiBC
aWp1IERhcyA8YmlqdS5kYXNAYnAucmVuZXNhcy5jb20+DQo+IFJldmlld2VkLWJ5OiBTaW1vbiBI
b3JtYW4gPGhvcm1zK3JlbmVzYXNAdmVyZ2UubmV0LmF1Pg0KPiBBY2tlZC1ieTogUm9iIEhlcnJp
bmcgPHJvYmhAa2VybmVsLm9yZz4NCj4gUmV2aWV3ZWQtYnk6IEdlZXJ0IFV5dHRlcmhvZXZlbiA8
Z2VlcnQrcmVuZXNhc0BnbGlkZXIuYmU+DQo+IEFja2VkLWJ5OiBOaWtsYXMgU8O2ZGVybHVuZCA8
bmlrbGFzLnNvZGVybHVuZCtyZW5lc2FzQHJhZ25hdGVjaC5zZT4NCj4gUmV2aWV3ZWQtYnk6IExh
dXJlbnQgUGluY2hhcnQgPGxhdXJlbnQucGluY2hhcnRAaWRlYXNvbmJvYXJkLmNvbT4NCj4gLS0t
DQo+ICBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvcmNhcl92aW4udHh0
IHwgNSArKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L21lZGlhL3JjYXJfdmluLnR4dCBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9t
ZWRpYS9yY2FyX3Zpbi50eHQNCj4gaW5kZXggZDk5YjZmNWRlZTQxODA1Ni4uNGM3NmQ4MjkwNWM5
ZDNiOCAxMDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21l
ZGlhL3JjYXJfdmluLnR4dA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3MvbWVkaWEvcmNhcl92aW4udHh0DQo+IEBAIC02LDYgKzYsOCBAQCBmYW1pbHkgb2YgZGV2aWNl
cy4gVGhlIGN1cnJlbnQgYmxvY2tzIGFyZSBhbHdheXMgc2xhdmVzIGFuZCBzdXBwb3Qgb25lIGlu
cHV0DQo+ICBjaGFubmVsIHdoaWNoIGNhbiBiZSBlaXRoZXIgUkdCLCBZVVlWIG9yIEJUNjU2Lg0K
Pg0KPiAgIC0gY29tcGF0aWJsZTogTXVzdCBiZSBvbmUgb3IgbW9yZSBvZiB0aGUgZm9sbG93aW5n
DQo+ICsgICAtICJyZW5lc2FzLHZpbi1yOGE3NzQzIiBmb3IgdGhlIFI4QTc3NDMgZGV2aWNlDQo+
ICsgICAtICJyZW5lc2FzLHZpbi1yOGE3NzQ1IiBmb3IgdGhlIFI4QTc3NDUgZGV2aWNlDQo+ICAg
ICAtICJyZW5lc2FzLHZpbi1yOGE3Nzc4IiBmb3IgdGhlIFI4QTc3NzggZGV2aWNlDQo+ICAgICAt
ICJyZW5lc2FzLHZpbi1yOGE3Nzc5IiBmb3IgdGhlIFI4QTc3NzkgZGV2aWNlDQo+ICAgICAtICJy
ZW5lc2FzLHZpbi1yOGE3NzkwIiBmb3IgdGhlIFI4QTc3OTAgZGV2aWNlDQo+IEBAIC0xNCw3ICsx
Niw4IEBAIGNoYW5uZWwgd2hpY2ggY2FuIGJlIGVpdGhlciBSR0IsIFlVWVYgb3IgQlQ2NTYuDQo+
ICAgICAtICJyZW5lc2FzLHZpbi1yOGE3NzkzIiBmb3IgdGhlIFI4QTc3OTMgZGV2aWNlDQo+ICAg
ICAtICJyZW5lc2FzLHZpbi1yOGE3Nzk0IiBmb3IgdGhlIFI4QTc3OTQgZGV2aWNlDQo+ICAgICAt
ICJyZW5lc2FzLHZpbi1yOGE3Nzk1IiBmb3IgdGhlIFI4QTc3OTUgZGV2aWNlDQo+IC0gICAtICJy
ZW5lc2FzLHJjYXItZ2VuMi12aW4iIGZvciBhIGdlbmVyaWMgUi1DYXIgR2VuMiBjb21wYXRpYmxl
IGRldmljZS4NCj4gKyAgIC0gInJlbmVzYXMscmNhci1nZW4yLXZpbiIgZm9yIGEgZ2VuZXJpYyBS
LUNhciBHZW4yIG9yIFJaL0cxIGNvbXBhdGlibGUNCj4gKyAgICAgZGV2aWNlLg0KPiAgICAgLSAi
cmVuZXNhcyxyY2FyLWdlbjMtdmluIiBmb3IgYSBnZW5lcmljIFItQ2FyIEdlbjMgY29tcGF0aWJs
ZSBkZXZpY2UuDQo+DQo+ICAgICBXaGVuIGNvbXBhdGlibGUgd2l0aCB0aGUgZ2VuZXJpYyB2ZXJz
aW9uIG5vZGVzIG11c3QgbGlzdCB0aGUNCj4gLS0NCj4gMi4xNi4yDQoNCg0KDQoNClJlbmVzYXMg
RWxlY3Ryb25pY3MgRXVyb3BlIEx0ZCwgRHVrZXMgTWVhZG93LCBNaWxsYm9hcmQgUm9hZCwgQm91
cm5lIEVuZCwgQnVja2luZ2hhbXNoaXJlLCBTTDggNUZILCBVSy4gUmVnaXN0ZXJlZCBpbiBFbmds
YW5kICYgV2FsZXMgdW5kZXIgUmVnaXN0ZXJlZCBOby4gMDQ1ODY3MDkuDQo=
