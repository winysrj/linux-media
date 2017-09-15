Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:5221 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750838AbdIOIUW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 04:20:22 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Hans Verkuil <hansverk@cisco.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>
Subject: RE: [PATCH] [media] rcar_drif: fix potential uninitialized variable
 use
Date: Fri, 15 Sep 2017 08:20:17 +0000
Message-ID: <KL1PR0601MB203870A27AC25380926691C3C36C0@KL1PR0601MB2038.apcprd06.prod.outlook.com>
References: <20170914110733.3592437-1-arnd@arndb.de>
In-Reply-To: <20170914110733.3592437-1-arnd@arndb.de>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgQXJuZCwNCg0KVGhhbmsgeW91IGZvciB0aGUgcGF0Y2guDQoNCj4gU3ViamVjdDogW1BBVENI
XSBbbWVkaWFdIHJjYXJfZHJpZjogZml4IHBvdGVudGlhbCB1bmluaXRpYWxpemVkIHZhcmlhYmxl
DQo+IHVzZQ0KPiANCj4gT2xkZXIgY29tcGlsZXJzIGxpa2UgZ2NjLTQuNiBtYXkgcnVuIGludG8g
YSBjYXNlIHRoYXQgcmV0dXJucyBhbg0KPiB1bmluaXRpYWxpemVkIHZhcmlhYmxlIGZyb20gcmNh
cl9kcmlmX2VuYWJsZV9yeCgpIGlmIHRoYXQgZnVuY3Rpb24gd2FzDQo+IGV2ZXIgY2FsbGVkIHdp
dGggYW4gZW1wdHkgY3VyX2NoX21hc2s6DQo+IA0KPiBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL3Jj
YXJfZHJpZi5jOjY1ODoyOiBlcnJvcjog4oCYcmV04oCZIG1heSBiZSB1c2VkDQo+IHVuaW5pdGlh
bGl6ZWQgaW4gdGhpcyBmdW5jdGlvbiBbLVdlcnJvcj11bmluaXRpYWxpemVkXQ0KPiANCj4gTmV3
ZXIgY29tcGlsZXJzIGRvbid0IGhhdmUgdGhhdCBwcm9ibGVtIGFzIHRoZXkgb3B0aW1pemUgdGhl
ICdyZXQnDQo+IHZhcmlhYmxlIGF3YXkgYW5kIGp1c3QgcmV0dXJuIHplcm8gaW4gdGhhdCBjYXNl
Lg0KPiANCj4gVGhpcyBjaGFuZ2VzIHRoZSBmdW5jdGlvbiB0byByZXR1cm4gLUVJTlZBTCBmb3Ig
dGhpcyBwYXJ0aWN1bGFyIGZhaWx1cmUsDQo+IHRvIG1ha2UgaXQgY29uc2lzdGVudCBhY3Jvc3Mg
YWxsIGNvbXBpbGVyIHZlcnNpb25zLg0KPiBJbiBjYXNlIGdjYyBnZXRzIGNoYW5nZWQgdG8gcmVw
b3J0IGEgd2FybmluZyBmb3IgaXQgaW4gdGhlIGZ1dHVyZSwgaXQncw0KPiBhbHNvIGEgZ29vZCBp
ZGVhIHRvIHNodXQgaXQgdXAgbm93Lg0KPiANCj4gTGluazogaHR0cHM6Ly9nY2MuZ251Lm9yZy9i
dWd6aWxsYS9zaG93X2J1Zy5jZ2k/aWQ9ODIyMDMNCj4gU2lnbmVkLW9mZi1ieTogQXJuZCBCZXJn
bWFubiA8YXJuZEBhcm5kYi5kZT4NCg0KQWNrZWQtYnk6IFJhbWVzaCBTaGFubXVnYXN1bmRhcmFt
IDxyYW1lc2guc2hhbm11Z2FzdW5kYXJhbUBicC5yZW5lc2FzLmNvbT4NCg0KVGhhbmtzLA0KUmFt
ZXNoDQo=
