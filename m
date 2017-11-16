Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:44318 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935076AbdKPNqD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 08:46:03 -0500
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        =?utf-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?=
        <niklas.soderlund@ragnatech.se>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH 1/2] dt-bindings: media: rcar_vin: add device tree support
 for r8a774[35]
Date: Thu, 16 Nov 2017 13:45:59 +0000
Message-ID: <TY1PR06MB089529F042099069AD960093C02E0@TY1PR06MB0895.apcprd06.prod.outlook.com>
References: <1510834290-25434-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1510834290-25434-2-git-send-email-fabrizio.castro@bp.renesas.com>
 <CAMuHMdW+krUp5ELO4NFxGi8NZ5-H4vrtm-=OXyvZKMCk2f-WcQ@mail.gmail.com>
In-Reply-To: <CAMuHMdW+krUp5ELO4NFxGi8NZ5-H4vrtm-=OXyvZKMCk2f-WcQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGVsbG8gR2VlcnQsDQoNCnRoYW5rIHlvdSBmb3IgeW91ciBjb21tZW50IQ0KDQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0ggMS8yXSBkdC1iaW5kaW5nczogbWVkaWE6IHJjYXJfdmluOiBhZGQgZGV2aWNl
IHRyZWUgc3VwcG9ydCBmb3IgcjhhNzc0WzM1XQ0KPg0KPiBPbiBUaHUsIE5vdiAxNiwgMjAxNyBh
dCAxOjExIFBNLCBGYWJyaXppbyBDYXN0cm8NCj4gPGZhYnJpemlvLmNhc3Ryb0BicC5yZW5lc2Fz
LmNvbT4gd3JvdGU6DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L21lZGlhL3JjYXJfdmluLnR4dA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9tZWRpYS9yY2FyX3Zpbi50eHQNCj4gPiBAQCAtMTQsNyArMTQsMTAgQEAgY2hhbm5l
bCB3aGljaCBjYW4gYmUgZWl0aGVyIFJHQiwgWVVZViBvciBCVDY1Ni4NCj4gPiAgICAgLSAicmVu
ZXNhcyx2aW4tcjhhNzc5MCIgZm9yIHRoZSBSOEE3NzkwIGRldmljZQ0KPiA+ICAgICAtICJyZW5l
c2FzLHZpbi1yOGE3Nzc5IiBmb3IgdGhlIFI4QTc3NzkgZGV2aWNlDQo+ID4gICAgIC0gInJlbmVz
YXMsdmluLXI4YTc3NzgiIGZvciB0aGUgUjhBNzc3OCBkZXZpY2UNCj4gPiAtICAgLSAicmVuZXNh
cyxyY2FyLWdlbjItdmluIiBmb3IgYSBnZW5lcmljIFItQ2FyIEdlbjIgY29tcGF0aWJsZSBkZXZp
Y2UuDQo+ID4gKyAgIC0gInJlbmVzYXMsdmluLXI4YTc3NDUiIGZvciB0aGUgUjhBNzc0NSBkZXZp
Y2UNCj4gPiArICAgLSAicmVuZXNhcyx2aW4tcjhhNzc0MyIgZm9yIHRoZSBSOEE3NzQzIGRldmlj
ZQ0KPg0KPiBQbGVhc2Uga2VlcCB0aGUgbGlzdCBzb3J0ZWQgYnkgU29DIHBhcnQgbnVtYmVyLg0K
Pg0KDQpJdCBpcyBzb3J0ZWQsIGp1c3QgaW4gZGVzY2VuZGluZyBvcmRlci4gRG8geW91IHdhbnQg
bWUgdG8gcmUtb3JkZXIgdGhlIGZ1bGwgbGlzdCBpbiBhc2NlbmRpbmcgb3JkZXI/DQoNClRoYW5r
cywNCkZhYg0KDQoNCg0KDQoNClJlbmVzYXMgRWxlY3Ryb25pY3MgRXVyb3BlIEx0ZCwgRHVrZXMg
TWVhZG93LCBNaWxsYm9hcmQgUm9hZCwgQm91cm5lIEVuZCwgQnVja2luZ2hhbXNoaXJlLCBTTDgg
NUZILCBVSy4gUmVnaXN0ZXJlZCBpbiBFbmdsYW5kICYgV2FsZXMgdW5kZXIgUmVnaXN0ZXJlZCBO
by4gMDQ1ODY3MDkuDQo=
