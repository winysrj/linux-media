Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40961 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbZG2Sgp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 14:36:45 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	v4l2_linux <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?ks_c_5601-1987?B?udqw5rnO?= <kyungmin.park@samsung.com>,
	"jm105.lee@samsung.com" <jm105.lee@samsung.com>,
	=?ks_c_5601-1987?B?wMy8vLmu?= <semun.lee@samsung.com>,
	=?ks_c_5601-1987?B?tOvAzrHi?= <inki.dae@samsung.com>,
	=?ks_c_5601-1987?B?sejH/MHY?= <riverful.kim@samsung.com>
Date: Wed, 29 Jul 2009 13:36:25 -0500
Subject: RE: How to save number of times using memcpy?
Message-ID: <A69FA2915331DC488A831521EAE36FE401450FADF1@dlee06.ent.ti.com>
References: <5e9665e10907271756l114f6e6ekeefa04d976b95c66@mail.gmail.com>
 <5e9665e10907282030i7d25c6e4se1d52eff321da8e3@mail.gmail.com>
 <20090729005551.79430fe5@pedra.chehab.org>
 <200907290926.41488.laurent.pinchart@skynet.be>
In-Reply-To: <200907290926.41488.laurent.pinchart@skynet.be>
Content-Language: en-US
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQoNCjxTbmlwPg0KPj4gdGhlIGRldGFpbHMsIGJ1dCBJIHRoaW5rIHRoZSBzdHJhdGVneSB3ZXJl
IHRvIHBhc3MgYSBwYXJhbWV0ZXIgZHVyaW5nDQo+PiBrZXJuZWwgYm9vdCwgZm9yIGl0IHRvIHJl
c2VydmUgc29tZSBhbW91bnQgb2YgbWVtb3J5IHRoYXQgd291bGQgbGF0ZXIgYmUNCj4+IGNsYWlt
ZWQgYnkgdGhlIFY0TCBkZXZpY2UuDQo+DQo+SXQncyBhY3R1YWxseSBhIHByZXR0eSBjb21tb24g
c3RyYXRlZ3kgZm9yIGVtYmVkZGVkIGhhcmR3YXJlICh0aGUgImdlbmVyYWwtDQo+cHVycG9zZSBt
YWNoaW5lIiBjYXNlIGRvZXNuJ3QgLSBmb3Igbm93IC0gbWFrZSBtdWNoIHNlbnNlIG9uIGFuIE9N
QVANCj5wcm9jZXNzb3INCj5mb3IgaW5zdGFuY2UpLiBBIG1lbW9yeSBjaHVuayB3b3VsZCBiZSBy
ZXNlcnZlZCBhdCBib290IHRpbWUgYXQgdGhlIGVuZCBvZg0KPnRoZQ0KPnBoeXNpY2FsIG1lbW9y
eSBieSBwYXNzaW5nIHRoZSBtZW09IHBhcmFtZXRlciB0byB0aGUga2VybmVsLiBWaWRlbw0KPmFw
cGxpY2F0aW9ucyB3b3VsZCB0aGVuIG1tYXAoKSAvZGV2L21lbSB0byBhY2Nlc3MgdGhhdCBtZW1v
cnkgKEknZCBoYXZlIHRvDQo+Y2hlY2sgdGhlIGRldGFpbHMgb24gdGhhdCBvbmUsIHRoYXQncyBm
cm9tIG15IG1lbW9yeSksIGFuZCBwYXNzIHRoZSBwb2ludGVyDQo+dGhlIHRoZSB2NGwyIGRyaXZl
ciB1c2luZyB1c2VycHRyIEkvTy4gVGhpcyByZXF1aXJlcyByb290IHByaXZpbGVnZXMsIGFuZA0K
PnBlb3BsZSB1c3VhbGx5IGRvbid0IGNhcmUgYWJvdXQgdGhhdCB3aGVuIHRoZSBmaW5hbCBhcHBs
aWNhdGlvbiBpcyBhIGNhbWVyYQ0KPih1c3VhbGx5IGVtYmVkZGVkIGluIHNvbWUgZGV2aWNlIGxp
a2UgYSBtZWRpYSBwbGF5ZXIsIGFuIElQIGNhbWVyYSwgLi4uKS4NCj4NCj5SZWdhcmRzLA0KWWVz
LiBUaGlzIGlzIGV4YWN0bHkgd2hhdCB3ZSBhcmUgZG9pbmcgaW4gdGhlIGNhc2Ugb2YgZGF2aW5j
aSBwcm9jZXNzb3JzLiBXZSBoYXZlIGEga2VybmVsIG1vZHVsZSB0aGF0IHVzZXMgbWVtb3J5IGZy
b20gdGhlIGVuZCBvZiBTRFJBTSBzcGFjZSBhbmQgbW1hcCBpdCB0byBhcHBsaWNhdGlvbiB0aHJv
dWdoIGEgc2V0IG9mIEFQSXMuIFRoZXkgYWxsb2NhdGUgY29udGlndW91cyBtZW1vcnkgcG9vbHMg
YW5kIHJldHVybiB0aGUgc2FtZSB0byBhcHBsaWNhdGlvbiB0aHJvdWdoIElPQ1RMcy4gSSBoYXZl
IHRlc3RlZCB2cGZlIGNhcHR1cmUgdXNpbmcgdGhpcyBhcHByb2FjaCAoYnV0IHlldCB0byBwdXNo
IHRoZSBzYW1lIHRvIHY0bDIgY29tbXVuaXR5IGZvciByZXZpZXcpLiBUaGUgc2FtZSBhcHByb2Fj
aCBtYXkgYmUgdXNlZCBhY3Jvc3Mgb3RoZXIgcGxhdGZvcm1zIGFzIHdlbGwuIFNvIGRvZXNuJ3Qg
aXQgbWFrZSBzZW5zZSB0byBhZGQgdGhpcyBrZXJuZWwgbW9kdWxlIHRvIHRoZSBrZXJuZWwgdHJl
ZSBzbyB0aGF0IGV2ZXJ5b25lIGNhbiB1c2UgaXQ/DQoNCk11cmFsaQ0KPg0KPkxhdXJlbnQgUGlu
Y2hhcnQNCj4NCj4tLQ0KPlRvIHVuc3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBs
aW5lICJ1bnN1YnNjcmliZSBsaW51eC1tZWRpYSIgaW4NCj50aGUgYm9keSBvZiBhIG1lc3NhZ2Ug
dG8gbWFqb3Jkb21vQHZnZXIua2VybmVsLm9yZw0KPk1vcmUgbWFqb3Jkb21vIGluZm8gYXQgIGh0
dHA6Ly92Z2VyLmtlcm5lbC5vcmcvbWFqb3Jkb21vLWluZm8uaHRtbA0KDQo=
