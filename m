Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41754 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab3AGGLH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 01:11:07 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>
CC: Rob Herring <robherring2@gmail.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>,
	Rob Clark <robdclark@gmail.com>,
	Leela Krishna Amudala <leelakrishna.a@gmail.com>
Subject: RE: [PATCHv16 5/7] fbmon: add of_videomode helpers
Date: Mon, 7 Jan 2013 06:10:13 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA7FB02@DBDE01.ent.ti.com>
References: <1355850256-16135-1-git-send-email-s.trumtrar@pengutronix.de>
 <1355850256-16135-6-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1355850256-16135-6-git-send-email-s.trumtrar@pengutronix.de>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgU3RlZmZlbiwNCg0KT24gVHVlLCBEZWMgMTgsIDIwMTIgYXQgMjI6MzQ6MTQsIFN0ZWZmZW4g
VHJ1bXRyYXIgd3JvdGU6DQo+IEFkZCBoZWxwZXIgdG8gZ2V0IGZiX3ZpZGVvbW9kZSBmcm9tIGRl
dmljZXRyZWUuDQoNCj4gIGRyaXZlcnMvdmlkZW8vZmJtb24uYyB8ICAgNDIgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBpbmNsdWRlL2xpbnV4L2ZiLmggICAg
fCAgICA0ICsrKysNCg0KVGhpcyBicmVha3MgRGFWaW5jaSAoZGE4eHhfb21hcGxfZGVmY29uZmln
KSwgZm9sbG93aW5nIGNoYW5nZSB3YXMNCnJlcXVpcmVkIHRvIGdldCBpdCBidWlsZCBpZiBPRl9W
SURFT01PREUgb3IvYW5kIEZCX01PREVfSEVMUEVSUw0KaXMgbm90IGRlZmluZWQuIFRoZXJlIG1h
eSBiZSBiZXR0ZXIgc29sdXRpb25zLCBmb2xsb3dpbmcgd2FzIHRoZQ0Kb25lIHRoYXQgd2FzIHVz
ZWQgYnkgbWUgdG8gdGVzdCB0aGlzIHNlcmllcy4NCg0KLS0tODwtLS0tLS0tLS0tDQoNCmRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L2ZiLmggYi9pbmNsdWRlL2xpbnV4L2ZiLmgNCmluZGV4IDU4
Yjk4NjAuLjBjZTMwZDEgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L2ZiLmgNCisrKyBiL2lu
Y2x1ZGUvbGludXgvZmIuaA0KQEAgLTcxNiw5ICs3MTYsMTkgQEAgZXh0ZXJuIHZvaWQgZmJfZGVz
dHJveV9tb2RlZGIoc3RydWN0IGZiX3ZpZGVvbW9kZSAqbW9kZWRiKTsNCiBleHRlcm4gaW50IGZi
X2ZpbmRfbW9kZV9jdnQoc3RydWN0IGZiX3ZpZGVvbW9kZSAqbW9kZSwgaW50IG1hcmdpbnMsIGlu
dCByYik7DQogZXh0ZXJuIHVuc2lnbmVkIGNoYXIgKmZiX2RkY19yZWFkKHN0cnVjdCBpMmNfYWRh
cHRlciAqYWRhcHRlcik7DQoNCisjaWYgZGVmaW5lZChDT05GSUdfT0ZfVklERU9NT0RFKSAmJiBk
ZWZpbmVkKENPTkZJR19GQl9NT0RFX0hFTFBFUlMpDQogZXh0ZXJuIGludCBvZl9nZXRfZmJfdmlk
ZW9tb2RlKHN0cnVjdCBkZXZpY2Vfbm9kZSAqbnAsDQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgc3RydWN0IGZiX3ZpZGVvbW9kZSAqZmIsDQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgaW50IGluZGV4KTsNCisjZWxzZQ0KK3N0YXRpYyBpbmxpbmUgaW50IG9mX2dldF9mYl92
aWRlb21vZGUoc3RydWN0IGRldmljZV9ub2RlICpucCwNCisgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgc3RydWN0IGZiX3ZpZGVvbW9kZSAqZmIsDQorICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGludCBpbmRleCkNCit7DQorICAgICAgIHJldHVybiAtRUlO
VkFMOw0KK30NCisjZW5kaWYNCisNCiBleHRlcm4gaW50IGZiX3ZpZGVvbW9kZV9mcm9tX3ZpZGVv
bW9kZShjb25zdCBzdHJ1Y3QgdmlkZW9tb2RlICp2bSwNCiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHN0cnVjdCBmYl92aWRlb21vZGUgKmZibW9kZSk7DQoNCi0tLTg8LS0t
LS0tLS0tLQ0KDQoNCj4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19PRl9WSURFT01PREUpDQoNCkFz
IF9PRl9WSURFT01PREUgaXMgYSBib29sIHR5cGUgQ09ORklHLCBpc24ndCwNCg0KI2lmZGVmIENP
TkZJR19PRl9WSURFT01PREUNCg0Kc3VmZmljaWVudCA/DQoNClJlZ2FyZHMNCkFmemFsDQo=
