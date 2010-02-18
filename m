Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43892 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab0BRU0U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 15:26:20 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: roel kluin <roel.kluin@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Date: Thu, 18 Feb 2010 14:25:56 -0600
Subject: RE: [PATCH] video_device: don't free_irq() an element past array
 	vpif_obj.dev[] and fix test
Message-ID: <A69FA2915331DC488A831521EAE36FE40169C5CBD8@dlee06.ent.ti.com>
References: <4B714E15.4020909@gmail.com>
 <A69FA2915331DC488A831521EAE36FE40169C5C9B5@dlee06.ent.ti.com>
 <25e057c01002181202v346f488bk571d099f679fea83@mail.gmail.com>
In-Reply-To: <25e057c01002181202v346f488bk571d099f679fea83@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQoNCj4+Pi0gwqAgwqAgwqBpZiAoIXN0ZF9pbmZvKQ0KPj4+KyDCoCDCoCDCoGlmICghc3RkX2lu
Zm8tPnN0ZGlkKQ0KPj4+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldHVybiAtMTsNCj4+Pg0KPj4g
VGhpcyBpcyBhIE5BQ0suIFdlIHNob3VsZG4ndCBjaGVjayBmb3Igc3RkaWQgc2luY2UgdGhlIGZ1
bmN0aW9uIGlzDQo+c3VwcG9zZWQNCj4+IHRvIHVwZGF0ZSBzdGRfaW5mby4gU28ganVzdCByZW1v
dmUNCj4+DQo+PiBpZiAoIXN0ZF9pbmZvKQ0KPj4gwqAgwqAgwqAgwqByZXR1cm4gLTE7DQo+DQo+
SSBkb24ndCBzZWUgaG93IHN0ZF9pbmZvIGNvdWxkIGdldCB1cGRhdGVkLiBjb25zaWRlciB0aGUg
bG9vcCBpbiBjYXNlDQo+c3RkX2luZm8tPnN0ZGlkIGVxdWFscyAwOg0KDQpPay4gWW91IGFyZSBy
aWdodCEgVGhlIGNoX3BhcmFtc1tdIGlzIGEgdGFibGUgZm9yIGtlZXBpbmcgdGhlIGluZm9ybWF0
aW9uDQphYm91dCBkaWZmZXJlbnQgc3RhbmRhcmRzIHN1cHBvcnRlZC4gRm9yIGEgZ2l2ZW4gc3Rk
aWQgaW4gc3RkX2luZm8sIHRoZSBmdW5jdGlvbiBtYXRjaGVzIHRoZSBzdGRpZCB3aXRoIHRoYXQg
aW4gdGhlIHRhYmxlIGFuZCBnZXQgdGhlIGNvcnJlc3BvbmRpbmcgZW50cnkuDQoNCg0KPj4gSSBh
bSBva2F5IHdpdGggdGhlIGJlbG93IGNoYW5nZS4gU28gcGxlYXNlIHJlLXN1Ym1pdCB0aGUgcGF0
Y2ggd2l0aCB0aGUNCj4+IGFib3ZlIGNoYW5nZSBhbmQgbXkgQUNLLg0KPj4NCj4+IFRoYW5rcw0K
Pj4NCj4+IE11cmFsaQ0KPj4NCj4NCj4+PisgwqAgwqAgwqBpZiAoayA9PSBWUElGX0RJU1BMQVlf
TUFYX0RFVklDRVMpDQo+Pj4rIMKgIMKgIMKgIMKgIMKgIMKgIMKgayA9IFZQSUZfRElTUExBWV9N
QVhfREVWSUNFUyAtIDE7DQo+DQo+YWN0dWFsbHkgSSB0aGluayB0aGlzIGlzIHN0aWxsIG5vdCBy
aWdodC4gc2hvdWxkbid0IGl0IGJlIGJlDQo+DQo+ayA9IFZQSUZfRElTUExBWV9NQVhfREVWSUNF
UyAtIDE7DQoNCldoYXQgeW91IG1lYW4gaGVyZT8gV2hhdCB5b3Ugc3VnZ2VzdCBoZXJlIGlzIHNh
bWUgYXMgaW4geW91ciBwYXRjaCwgcmlnaHQ/DQoNCk11cmFsaQ0KPg0KPj4gYXJlIHlvdSB1c2lu
ZyB0aGlzIGRyaXZlciBpbiB5b3VyIHByb2plY3Q/DQo+DQo+Tm8sIEkganVzdCBmb3VuZCB0aGlz
IGluIHRoZSBjb2RlLg0KPg0KPlRoYW5rcywgUm9lbA0K
