Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:42688 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbeK2LpJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 06:45:09 -0500
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
CC: "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "Li, Chao C" <chao.c.li@intel.com>
Subject: RE: [PATCH v7 03/16] v4l: Add Intel IPU3 meta data uAPI
Date: Thu, 29 Nov 2018 00:41:38 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A598152864C@fmsmsx122.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-4-git-send-email-yong.zhi@intel.com>
 <20181102104908.609177e5@coco.lan>
 <CAAFQd5B_OVV-Nh0uOGHdQE4eSKcs5N8Nn1t-Zz-GbvgpB9P38A@mail.gmail.com>
 <6F87890CF0F5204F892DEA1EF0D77A5981524580@fmsmsx122.amr.corp.intel.com>
 <653bae0f-899a-5a8b-a1d0-814f6b44f8f8@xs4all.nl>
In-Reply-To: <653bae0f-899a-5a8b-a1d0-814f6b44f8f8@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgSGFucywNCg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY3IDAzLzE2XSB2NGw6IEFkZCBJbnRl
bCBJUFUzIG1ldGEgZGF0YSB1QVBJDQo+IA0KPiBPbiAxMS8wNy8xOCAwMDoyNywgTWFuaSwgUmFq
bW9oYW4gd3JvdGU6DQo+ID4gSGkgTWF1cm8sDQo+ID4NCj4gPiBUaGFua3MgZm9yIHRoZSByZXZp
ZXdzLg0KPiA+DQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjcgMDMvMTZdIHY0bDogQWRkIElu
dGVsIElQVTMgbWV0YSBkYXRhIHVBUEkNCj4gPj4NCj4gPj4gSGkgTWF1cm8sDQo+ID4+DQo+ID4+
IE9uIEZyaSwgTm92IDIsIDIwMTggYXQgMTA6NDkgUE0gTWF1cm8gQ2FydmFsaG8gQ2hlaGFiDQo+
ID4+IDxtY2hlaGFiK3NhbXN1bmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+ID4+Pg0KPiA+Pj4gRW0g
TW9uLCAyOSBPY3QgMjAxOCAxNToyMjo1NyAtMDcwMA0KPiA+Pj4gWW9uZyBaaGkgPHlvbmcuemhp
QGludGVsLmNvbT4gZXNjcmV2ZXU6DQo+ID4+IFtzbmlwXQ0KPiA+Pj4+ICtzdHJ1Y3QgaXB1M191
YXBpX2F3Yl9jb25maWdfcyB7DQo+ID4+Pj4gKyAgICAgX191MTYgcmdic190aHJfZ3I7DQo+ID4+
Pj4gKyAgICAgX191MTYgcmdic190aHJfcjsNCj4gPj4+PiArICAgICBfX3UxNiByZ2JzX3Rocl9n
YjsNCj4gPj4+PiArICAgICBfX3UxNiByZ2JzX3Rocl9iOw0KPiA+Pj4+ICsgICAgIHN0cnVjdCBp
cHUzX3VhcGlfZ3JpZF9jb25maWcgZ3JpZDsgfQ0KPiA+Pj4+ICtfX2F0dHJpYnV0ZV9fKChhbGln
bmVkKDMyKSkpIF9fcGFja2VkOw0KPiA+Pj4NCj4gPj4+IEhtbS4uLiBLZXJuZWwgZGVmaW5lcyBh
IG1hY3JvIGZvciBhbGlnbmVkIGF0dHJpYnV0ZToNCj4gPj4+DQo+ID4+PiAgICAgICAgIGluY2x1
ZGUvbGludXgvY29tcGlsZXJfdHlwZXMuaDojZGVmaW5lIF9fYWxpZ25lZCh4KQ0KPiA+PiBfX2F0
dHJpYnV0ZV9fKChhbGlnbmVkKHgpKSkNCj4gPj4+DQo+ID4+DQo+ID4+IEZpcnN0LCB0aGFua3Mg
Zm9yIHJldmlldyENCj4gPj4NCj4gPj4gTWF5YmUgSSBtaXNzZWQgc29tZXRoaW5nLCBidXQgbGFz
dCB0aW1lIEkgY2hlY2tlZCwgaXQgd2Fzbid0DQo+ID4+IGFjY2Vzc2libGUgZnJvbSBVQVBJIGhl
YWRlcnMgaW4gdXNlcnNwYWNlLg0KPiA+DQo+ID4gQWNrLiBXZSBzZWUgdGhhdCdzIHN0aWxsIHRo
ZSBjYXNlLg0KPiA+DQo+ID4+DQo+ID4+PiBJJ20gbm90IGEgZ2NjIGV4cGVydCwgYnV0IGl0IHNv
dW5kcyB3ZWlyZCB0byBmaXJzdCBhc2sgaXQgdG8gYWxpZ24NCj4gPj4+IHdpdGggMzIgYml0cyBh
bmQgdGhlbiBoYXZlIF9fcGFja2VkICh3aXRoIG1lYW5zIHRoYXQgcGFkcyBzaG91bGQgYmUNCj4g
Pj4+IHJlbW92ZWQpLg0KPiA+Pj4NCj4gPj4+IEluIG90aGVyIHdvcmRzLCBJICpndWVzcyogaXMg
aXQgc2hvdWxkIGVpdGhlciBiZSBfX3BhY2tlZCBvcg0KPiA+Pj4gX19hbGlnbmVkKDMyKS4NCj4g
Pj4+DQo+ID4+PiBOb3QgdGhhdCBpdCB3b3VsZCBkbyBhbnkgZGlmZmVyZW5jZSwgaW4gcHJhY3Rp
Y2UsIGFzIHRoaXMgc3BlY2lmaWMNCj4gPj4+IHN0cnVjdCBoYXMgYSBzaXplIHdpdGggaXMgbXVs
dGlwbGUgb2YgMzIgYml0cywgYnV0IGxldCdzIGRvIHRoZQ0KPiA+Pj4gcmlnaHQgYW5ub3RhdGlv
biBoZXJlLCBub3QgbWl4aW5nIHR3byBpbmNvbXBhdGlibGUgYWxpZ25tZW50DQo+IHJlcXVpcmVt
ZW50cy4NCj4gPj4+DQo+ID4+DQo+ID4+IE15IHVuZGVyc3RhbmRpbmcgd2FzIHRoYXQgX19wYWNr
ZWQgbWFrZXMgdGhlIGNvbXBpbGVyIG5vdCBpbnNlcnQgYW55DQo+ID4+IGFsaWdubWVudCBiZXR3
ZWVuIHBhcnRpY3VsYXIgZmllbGRzIG9mIHRoZSBzdHJ1Y3QsIHdoaWxlIF9fYWxpZ25lZA0KPiA+
PiBtYWtlcyB0aGUgd2hvbGUgc3RydWN0IGJlIGFsaWduZWQgYXQgZ2l2ZW4gYm91bmRhcnksIGlm
IHBsYWNlZCBpbg0KPiA+PiBhbm90aGVyIHN0cnVjdC4gSWYgSSBkaWRuJ3QgbWlzcyBhbnl0aGlu
ZywgaGF2aW5nIGJvdGggc2hvdWxkIG1ha2UgcGVyZmVjdA0KPiBzZW5zZSBoZXJlLg0KPiA+DQo+
ID4gQWNrDQo+ID4NCj4gPiBJIGFsc28gcmVjYWxsIHRoYXQgYXMgcGFydCBvZiBhZGRyZXNzaW5n
IHJldmlldyBjb21tZW50cyAgKGZyb20gSGFucw0KPiA+IGFuZCBTYWthcmkpLCBvbiBlYXJsaWVy
IHZlcnNpb25zIG9mIHRoaXMgcGF0Y2ggc2VyaWVzLCB3ZSBhZGRlZA0KPiA+IF9fcGFja2VkIGF0
dHJpYnV0ZSB0byBhbGwgc3RydWN0cyB0byBlbnN1cmUgdGhlIHNpemUgb2YgdGhlIHN0cnVjdHMg
cmVtYWlucyB0aGUNCj4gc2FtZSBiZXR3ZWVuIDMyIGFuZCA2NCBiaXQgYnVpbGRzLg0KPiA+DQo+
ID4gVGhlIGFkZGl0aW9uIG9mIHN0cnVjdHVyZSBtZW1iZXJzIG9mIHRoZSBuYW1lIHBhZGRpbmdb
eF0gaW4gc29tZSBvZg0KPiA+IHRoZSBzdHJ1Y3RzIGVuc3VyZXMgdGhhdCByZXNwZWN0aXZlIG1l
bWJlcnMgYXJlIGFsaWduZWQgYXQgMzIgYnl0ZQ0KPiA+IGJvdW5kYXJpZXMsIHdoaWxlIHRoZSBv
dmVyYWxsIHNpemUgb2YgdGhlIHN0cnVjdHMgcmVtYWluIHRoZSBzYW1lIGJldHdlZW4gMzINCj4g
YW5kIDY0IGJpdCBidWlsZHMuDQo+IA0KPiBJIHJlY29tbWVuZCB0aGF0IHRoaXMgaXMgZG9jdW1l
bnRlZCBpbiB0aGUgaGVhZGVyLiBJdCdzIG5vdCBhIGNvbW1vbg0KPiBjb25zdHJ1Y3Rpb24gc28g
YW4gZXhwbGFuYXRpb24gd2lsbCBoZWxwLg0KDQpBY2suDQoNCj4gDQo+IFJlZ2FyZHMsDQo+IA0K
PiAJSGFucw0KPiANCj4gPg0KPiA+IFRoYW5rcw0KPiA+IFJhag0KPiA+DQo+ID4+DQo+ID4+IEJl
c3QgcmVnYXJkcywNCj4gPj4gVG9tYXN6DQoNCg==
