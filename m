Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:58570 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750828AbdFNHSR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 03:18:17 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Ian Arkver <ian.arkver.dev@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "mattw@codeaurora.org" <mattw@codeaurora.org>,
        "mitchelh@codeaurora.org" <mitchelh@codeaurora.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>
CC: "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>
Subject: RE: [PATCH v2 0/2] Avoid namespace collision within macros & tidyup
Date: Wed, 14 Jun 2017 07:18:09 +0000
Message-ID: <KL1PR0601MB20388B133E5E841FF5BF2D4BC3C30@KL1PR0601MB2038.apcprd06.prod.outlook.com>
References: <20170613133348.48044-1-ramesh.shanmugasundaram@bp.renesas.com>
 <293256b4-2477-e5f6-eca6-e5eaf9b14876@gmail.com>
In-Reply-To: <293256b4-2477-e5f6-eca6-e5eaf9b14876@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDAvMl0gQXZvaWQgbmFtZXNwYWNlIGNvbGxpc2lvbiB3
aXRoaW4gbWFjcm9zICYNCj4gdGlkeXVwDQo+IA0KPiBPbiAxMy8wNi8xNyAxNDozMywgUmFtZXNo
IFNoYW5tdWdhc3VuZGFyYW0gd3JvdGU6DQo+ID4gSGkgQWxsLA0KPiA+DQo+ID4gVGhlIHJlYWR4
X3BvbGxfdGltZW91dCAmIHNpbWlsYXIgbWFjcm9zIGRlZmluZXMgbG9jYWwgdmFyaWFibGUgdGhh
dA0KPiA+IGNhbiBjYXVzZSBuYW1lIHNwYWNlIGNvbGxpc2lvbiB3aXRoIHRoZSBjYWxsZXIuIEZp
eGVkIHRoaXMgaXNzdWUgYnkNCj4gPiBwcmVmaXhpbmcgdGhlbSB3aXRoIHVuZGVyc2NvcmVzLg0K
PiANCj4gVGhlIGNvbXBvdW5kIHN0YXRlbWVudCBoYXMgYSBsb2NhbCB2YXJpYWJsZSBzY29wZSwg
c28gdGhlc2Ugd29uJ3QgY29sbGlkZQ0KPiB3aXRoIHRoZSBjYWxsZXIgSSBiZWxpZXZlLg0KDQpC
dXQgeHh4X3BvbGxfdGltZW91dCBpcyBhIG1hY3JvPz8NCg0KVXNhZ2UgcmVnbWFwX3JlYWRfcG9s
bF90aW1lb3V0KC4uLiwgdGltZW91dCkgd2l0aCB2YXJpYWJsZSBuYW1lICJ0aW1lb3V0IiBpbiB0
aGUgY2FsbGVyIHJlc3VsdHMgaW4gDQoNCmluY2x1ZGUvbGludXgvcmVnbWFwLmg6MTIzOjIwOiB3
YXJuaW5nOiAndGltZW91dCcgaXMgdXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rpb24g
Wy1XdW5pbml0aWFsaXplZF0NCiAga3RpbWVfdCB0aW1lb3V0ID0ga3RpbWVfYWRkX3VzKGt0aW1l
X2dldCgpLCB0aW1lb3V0X3VzKTsgXA0KDQo+IA0KPiA+IEFsc28gdGlkaWVkIGNvdXBsZSBvZiBp
bnN0YW5jZXMgd2hlcmUgdGhlIG1hY3JvIGFyZ3VtZW50cyBhcmUgdXNlZCBpbg0KPiA+IGV4cHJl
c3Npb25zIHdpdGhvdXQgcGFyYW50aGVzaXMuDQo+ID4NCj4gPiBUaGlzIHBhdGNoc2V0IGlzIGJh
c2VkIG9uIHRvcCBvZiB0b2RheSdzIGxpbnV4LW5leHQgcmVwby4NCj4gPiBjb21taXQgYmM0Yzc1
ZjQxYTFjICgiQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTcwNjEzIikNCj4g
Pg0KPiA+IENoYW5nZSBoaXN0b3J5Og0KPiA+DQo+ID4gdjI6DQo+ID4gICAtIGlvcG9sbC5oOg0K
PiA+IAktIEVuY2xvc2VkIHRpbWVvdXRfdXMgJiBzbGVlcF91cyBhcmd1bWVudHMgd2l0aCBwYXJh
bnRoZXNpcw0KPiA+ICAgLSByZWdtYXAuaDoNCj4gPiAJLSBFbmNsb3NlZCB0aW1lb3V0X3VzICYg
c2xlZXBfdXMgYXJndW1lbnRzIHdpdGggcGFyYW50aGVzaXMNCj4gPiAJLSBSZW5hbWVkIHBvbGxy
ZXQgdG8gX19yZXQNCj4gPg0KPiA+IE5vdGU6IHRpbWVvdXRfdXMgY2F1c2Ugc3BhcmUgY2hlY2sg
d2FybmluZyBhcyBpZGVudGlmaWVkIGhlcmUgWzFdLg0KPiA+DQo+ID4gWzFdDQo+ID4gaHR0cHM6
Ly93d3cubWFpbC1hcmNoaXZlLmNvbS9saW51eC1yZW5lc2FzLXNvY0B2Z2VyLmtlcm5lbC5vcmcv
bXNnMTUxMw0KPiA+IDguaHRtbA0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IFJhbWVzaA0KPiA+DQo+
ID4gUmFtZXNoIFNoYW5tdWdhc3VuZGFyYW0gKDIpOg0KPiA+ICAgIGlvcG9sbDogQXZvaWQgbmFt
ZXNwYWNlIGNvbGxpc2lvbiB3aXRoaW4gbWFjcm9zICYgdGlkeXVwDQo+ID4gICAgcmVnbWFwOiBB
dm9pZCBuYW1lc3BhY2UgY29sbGlzaW9uIHdpdGhpbiBtYWNybyAmIHRpZHl1cA0KPiA+DQo+ID4g
ICBpbmNsdWRlL2xpbnV4L2lvcG9sbC5oIHwgMTIgKysrKysrKy0tLS0tDQo+ID4gICBpbmNsdWRl
L2xpbnV4L3JlZ21hcC5oIHwgMTcgKysrKysrKysrLS0tLS0tLS0NCj4gPiAgIDIgZmlsZXMgY2hh
bmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pDQo+ID4NCg==
