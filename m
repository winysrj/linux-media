Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:42201 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbeHKBuG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 21:50:06 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: "Zhi, Yong" <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Li, Chao C" <chao.c.li@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Subject: RE: [PATCH v1 2/2] v4l: Document Intel IPU3 meta data uAPI
Date: Fri, 10 Aug 2018 23:18:06 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A59814FD981@fmsmsx122.amr.corp.intel.com>
References: <1529033373-15724-1-git-send-email-yong.zhi@intel.com>
 <1529033373-15724-3-git-send-email-yong.zhi@intel.com>
 <CAAFQd5AH3voHmJq3h1AqULJTFWH=BTWmB76k7f78q9FHaDMXfg@mail.gmail.com>
In-Reply-To: <CAAFQd5AH3voHmJq3h1AqULJTFWH=BTWmB76k7f78q9FHaDMXfg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgTWF1cm8sIEhhbnMsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTog
VG9tYXN6IEZpZ2EgW21haWx0bzp0ZmlnYUBjaHJvbWl1bS5vcmddDQo+IFNlbnQ6IFdlZG5lc2Rh
eSwgSnVseSAxOCwgMjAxOCA3OjUzIEFNDQo+IFRvOiBIYW5zIFZlcmt1aWwgPGhhbnMudmVya3Vp
bEBjaXNjby5jb20+OyBNYXVybyBDYXJ2YWxobyBDaGVoYWINCj4gPG1jaGVoYWJAa2VybmVsLm9y
Zz4NCj4gQ2M6IFpoaSwgWW9uZyA8eW9uZy56aGlAaW50ZWwuY29tPjsgU2FrYXJpIEFpbHVzDQo+
IDxzYWthcmkuYWlsdXNAbGludXguaW50ZWwuY29tPjsgTGludXggTWVkaWEgTWFpbGluZyBMaXN0
IDxsaW51eC0NCj4gbWVkaWFAdmdlci5rZXJuZWwub3JnPjsgTGF1cmVudCBQaW5jaGFydA0KPiA8
bGF1cmVudC5waW5jaGFydEBpZGVhc29uYm9hcmQuY29tPjsgTWFuaSwgUmFqbW9oYW4NCj4gPHJh
am1vaGFuLm1hbmlAaW50ZWwuY29tPjsgWmhlbmcsIEppYW4gWHUgPGppYW4ueHUuemhlbmdAaW50
ZWwuY29tPjsgSHUsDQo+IEplcnJ5IFcgPGplcnJ5LncuaHVAaW50ZWwuY29tPjsgTGksIENoYW8g
QyA8Y2hhby5jLmxpQGludGVsLmNvbT47IFFpdSwgVGlhbg0KPiBTaHUgPHRpYW4uc2h1LnFpdUBp
bnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEgMi8yXSB2NGw6IERvY3VtZW50IElu
dGVsIElQVTMgbWV0YSBkYXRhIHVBUEkNCj4gDQo+IEhpIE1hdXJvLCBIYW5zLA0KPiANCj4gT24g
RnJpLCBKdW4gMTUsIDIwMTggYXQgMTI6MzAgUE0gWW9uZyBaaGkgPHlvbmcuemhpQGludGVsLmNv
bT4gd3JvdGU6DQo+ID4NCj4gPiBUaGVzZSBtZXRhIGZvcm1hdHMgYXJlIHVzZWQgb24gSW50ZWwg
SVBVMyBJbWdVIHZpZGVvIHF1ZXVlcyB0byBjYXJyeQ0KPiA+IDNBIHN0YXRpc3RpY3MgYW5kIElT
UCBwaXBlbGluZSBwYXJhbWV0ZXJzLg0KPiA+DQo+ID4gVjRMMl9NRVRBX0ZNVF9JUFUzXzNBDQo+
ID4gVjRMMl9NRVRBX0ZNVF9JUFUzX1BBUkFNUw0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogWW9u
ZyBaaGkgPHlvbmcuemhpQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBDaGFvIEMgTGkg
PGNoYW8uYy5saUBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogUmFqbW9oYW4gTWFuaSA8
cmFqbW9oYW4ubWFuaUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIERvY3VtZW50YXRpb24vbWVk
aWEvdWFwaS92NGwvbWV0YS1mb3JtYXRzLnJzdCAgICAgIHwgICAgMSArDQo+ID4gIC4uLi9tZWRp
YS91YXBpL3Y0bC9waXhmbXQtbWV0YS1pbnRlbC1pcHUzLnJzdCAgICAgIHwgIDE3NCArKw0KPiA+
ICBpbmNsdWRlL3VhcGkvbGludXgvaW50ZWwtaXB1My5oICAgICAgICAgICAgICAgICAgICB8IDI4
MTYgKysrKysrKysrKysrKysrKysrKysNCj4gDQo+IFRoZSBkb2N1bWVudGF0aW9uIHNlZW1zIHRv
IGJlIHF1aXRlIGV4dGVuc2l2ZSBpbiBjdXJyZW50IHZlcnNpb24uIERvIHlvdQ0KPiB0aGluayBp
dCdzIG1vcmUgYWNjZXB0YWJsZSBub3c/IFdvdWxkIHlvdSBiZSBhYmxlIHRvIHRha2UgYSBsb29r
Pw0KDQpIb3BlIHlvdSBoYWQgYSBjaGFuY2UgdG8gbG9vayBpbnRvIHRoaXMgY3VycmVudCB2ZXJz
aW9uIG9mIElQVTMgZG9jdW1lbnRhdGlvbi4NClBsZWFzZSBzaGFyZSB5b3VyIHRob3VnaHRzLg0K
DQpUaGFua3MNClJhag0KDQo+IA0KPiBXZSBvYnZpb3VzbHkgbmVlZCB0byBrZWVwIHdvcmtpbmcg
b24gdGhlIHVzZXIgc3BhY2UgZnJhbWV3b3JrIChhbmQgd2UncmUgaW4NCj4gcHJvY2VzcyBvZiBm
aWd1cmluZyBvdXQgaG93IHdlIGNhbiBwcm9jZWVkIGZ1cnRoZXIpLCBidXQgaGF2aW5nIHRoZSBk
cml2ZXIgYml0LQ0KPiByb3R0aW5nIGRvd25zdHJlYW0gbWlnaHQgbm90IGJlIGEgdmVyeSBlbmNv
dXJhZ2luZyBmYWN0b3IuIDspDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IFRvbWFzeg0K
