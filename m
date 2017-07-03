Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:43674 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753694AbdGCJ4A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 05:56:00 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Mark Brown <broonie@kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        "mattw@codeaurora.org" <mattw@codeaurora.org>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>
Subject: RE: [PATCH v2 1/2] iopoll: Avoid namespace collision within macros &
 tidyup
Date: Mon, 3 Jul 2017 09:55:55 +0000
Message-ID: <KL1PR0601MB203830EA67621CA20520B03FC3D60@KL1PR0601MB2038.apcprd06.prod.outlook.com>
References: <20170613133348.48044-1-ramesh.shanmugasundaram@bp.renesas.com>
 <20170613133348.48044-2-ramesh.shanmugasundaram@bp.renesas.com>
 <CAMuHMdVSBstPK55-36vJySKc-NAUyWKRMDYGgF4vBce07Pn0Ug@mail.gmail.com>
In-Reply-To: <CAMuHMdVSBstPK55-36vJySKc-NAUyWKRMDYGgF4vBce07Pn0Ug@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4gUmVwbHlpbmcgdG8gdGhlIHRocmVh
ZCB0byB1cGRhdGUgd2hhdCB3ZSBkaXNjdXNzZWQgaW4gSVJDIHNvbWV0aW1lIGJhY2suDQoNCj4g
T24gVHVlLCBKdW4gMTMsIDIwMTcgYXQgMzozMyBQTSwgUmFtZXNoIFNoYW5tdWdhc3VuZGFyYW0N
Cj4gPHJhbWVzaC5zaGFubXVnYXN1bmRhcmFtQGJwLnJlbmVzYXMuY29tPiB3cm90ZToNCj4gPiBS
ZW5hbWVkIHZhcmlhYmxlICJ0aW1lb3V0IiB0byAiX190aW1lb3V0IiB0byBhdm9pZCBuYW1lc3Bh
Y2UgY29sbGlzaW9uLg0KPiA+IFRpZHkgdXAgbWFjcm8gYXJndW1lbnRzIHdpdGggcGFyYW50aGVz
aXMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBSYW1lc2ggU2hhbm11Z2FzdW5kYXJhbQ0KPiA+
IDxyYW1lc2guc2hhbm11Z2FzdW5kYXJhbUBicC5yZW5lc2FzLmNvbT4NCj4gDQo+IFRoYW5rcyBm
b3IgeW91ciBwYXRjaGVzIQ0KPiANCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2lvcG9sbC5oDQo+
ID4gKysrIGIvaW5jbHVkZS9saW51eC9pb3BvbGwuaA0KPiA+IEBAIC00MiwxOCArNDIsMTkgQEAN
Cj4gPiAgICovDQo+ID4gICNkZWZpbmUgcmVhZHhfcG9sbF90aW1lb3V0KG9wLCBhZGRyLCB2YWws
IGNvbmQsIHNsZWVwX3VzLCB0aW1lb3V0X3VzKQ0KPiA+IFwgICh7IFwNCj4gPiAtICAgICAgIGt0
aW1lX3QgdGltZW91dCA9IGt0aW1lX2FkZF91cyhrdGltZV9nZXQoKSwgdGltZW91dF91cyk7IFwN
Cj4gPiArICAgICAgIGt0aW1lX3QgX190aW1lb3V0ID0ga3RpbWVfYWRkX3VzKGt0aW1lX2dldCgp
LCB0aW1lb3V0X3VzKTsgXA0KPiANCj4gSSB0aGluayB0aW1lb3V0X3VzIHNob3VsZCBiZSB3aXRo
aW4gcGFyZW50aGVzZXMsIHRvby4NCg0KSXQgaXMgbm90IHJlcXVpcmVkIGFzIGl0IGlzIHBhc3Nl
ZCBhcyBhbiBmdW5jdGlvbiAoa3RpbWVfYWRkX3VzKSBhcmd1bWVudC4NCg0KPiANCj4gPiAgICAg
ICAgIG1pZ2h0X3NsZWVwX2lmKHNsZWVwX3VzKTsgXA0KPiA+ICAgICAgICAgZm9yICg7OykgeyBc
DQo+ID4gICAgICAgICAgICAgICAgICh2YWwpID0gb3AoYWRkcik7IFwNCj4gPiAgICAgICAgICAg
ICAgICAgaWYgKGNvbmQpIFwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBicmVhazsgXA0K
PiA+IC0gICAgICAgICAgICAgICBpZiAodGltZW91dF91cyAmJiBrdGltZV9jb21wYXJlKGt0aW1l
X2dldCgpLCB0aW1lb3V0KSA+DQo+IDApIHsgXA0KPiA+ICsgICAgICAgICAgICAgICBpZiAoKHRp
bWVvdXRfdXMpICYmIFwNCj4gPiArICAgICAgICAgICAgICAgICAgIGt0aW1lX2NvbXBhcmUoa3Rp
bWVfZ2V0KCksIF9fdGltZW91dCkgPiAwKSB7IFwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICAodmFsKSA9IG9wKGFkZHIpOyBcDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7
IFwNCj4gPiAgICAgICAgICAgICAgICAgfSBcDQo+ID4gICAgICAgICAgICAgICAgIGlmIChzbGVl
cF91cykgXA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIHVzbGVlcF9yYW5nZSgoc2xlZXBf
dXMgPj4gMikgKyAxLCBzbGVlcF91cyk7IFwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICB1
c2xlZXBfcmFuZ2UoKChzbGVlcF91cykgPj4gMikgKyAxLCBzbGVlcF91cyk7DQo+ID4gKyBcDQo+
IA0KPiBTYW1lIGZvciBzbGVlcF91cy4NCj4gDQo+IEFsc28gaW4gcmVhZHhfcG9sbF90aW1lb3V0
X2F0b21pYygpLCBhbmQgaW4geW91ciBzZWNvbmQgcGF0Y2guDQoNClNhbWUgYXMgdGhlIGFib3Zl
IGNvbW1lbnQuDQoNClRoYW5rcywNClJhbWVzaA0K
