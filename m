Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47977 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730164AbeKGIzd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 03:55:33 -0500
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Tomasz Figa <tfiga@chromium.org>,
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
Date: Tue, 6 Nov 2018 23:27:53 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A5981524580@fmsmsx122.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-4-git-send-email-yong.zhi@intel.com>
 <20181102104908.609177e5@coco.lan>
 <CAAFQd5B_OVV-Nh0uOGHdQE4eSKcs5N8Nn1t-Zz-GbvgpB9P38A@mail.gmail.com>
In-Reply-To: <CAAFQd5B_OVV-Nh0uOGHdQE4eSKcs5N8Nn1t-Zz-GbvgpB9P38A@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgTWF1cm8sDQoNClRoYW5rcyBmb3IgdGhlIHJldmlld3MuDQoNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2NyAwMy8xNl0gdjRsOiBBZGQgSW50ZWwgSVBVMyBtZXRhIGRhdGEgdUFQSQ0KPiANCj4g
SGkgTWF1cm8sDQo+IA0KPiBPbiBGcmksIE5vdiAyLCAyMDE4IGF0IDEwOjQ5IFBNIE1hdXJvIENh
cnZhbGhvIENoZWhhYg0KPiA8bWNoZWhhYitzYW1zdW5nQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiA+
DQo+ID4gRW0gTW9uLCAyOSBPY3QgMjAxOCAxNToyMjo1NyAtMDcwMA0KPiA+IFlvbmcgWmhpIDx5
b25nLnpoaUBpbnRlbC5jb20+IGVzY3JldmV1Og0KPiBbc25pcF0NCj4gPiA+ICtzdHJ1Y3QgaXB1
M191YXBpX2F3Yl9jb25maWdfcyB7DQo+ID4gPiArICAgICBfX3UxNiByZ2JzX3Rocl9ncjsNCj4g
PiA+ICsgICAgIF9fdTE2IHJnYnNfdGhyX3I7DQo+ID4gPiArICAgICBfX3UxNiByZ2JzX3Rocl9n
YjsNCj4gPiA+ICsgICAgIF9fdTE2IHJnYnNfdGhyX2I7DQo+ID4gPiArICAgICBzdHJ1Y3QgaXB1
M191YXBpX2dyaWRfY29uZmlnIGdyaWQ7IH0NCj4gPiA+ICtfX2F0dHJpYnV0ZV9fKChhbGlnbmVk
KDMyKSkpIF9fcGFja2VkOw0KPiA+DQo+ID4gSG1tLi4uIEtlcm5lbCBkZWZpbmVzIGEgbWFjcm8g
Zm9yIGFsaWduZWQgYXR0cmlidXRlOg0KPiA+DQo+ID4gICAgICAgICBpbmNsdWRlL2xpbnV4L2Nv
bXBpbGVyX3R5cGVzLmg6I2RlZmluZSBfX2FsaWduZWQoeCkNCj4gX19hdHRyaWJ1dGVfXygoYWxp
Z25lZCh4KSkpDQo+ID4NCj4gDQo+IEZpcnN0LCB0aGFua3MgZm9yIHJldmlldyENCj4gDQo+IE1h
eWJlIEkgbWlzc2VkIHNvbWV0aGluZywgYnV0IGxhc3QgdGltZSBJIGNoZWNrZWQsIGl0IHdhc24n
dCBhY2Nlc3NpYmxlIGZyb20NCj4gVUFQSSBoZWFkZXJzIGluIHVzZXJzcGFjZS4NCg0KQWNrLiBX
ZSBzZWUgdGhhdCdzIHN0aWxsIHRoZSBjYXNlLg0KDQo+IA0KPiA+IEknbSBub3QgYSBnY2MgZXhw
ZXJ0LCBidXQgaXQgc291bmRzIHdlaXJkIHRvIGZpcnN0IGFzayBpdCB0byBhbGlnbg0KPiA+IHdp
dGggMzIgYml0cyBhbmQgdGhlbiBoYXZlIF9fcGFja2VkICh3aXRoIG1lYW5zIHRoYXQgcGFkcyBz
aG91bGQgYmUNCj4gPiByZW1vdmVkKS4NCj4gPg0KPiA+IEluIG90aGVyIHdvcmRzLCBJICpndWVz
cyogaXMgaXQgc2hvdWxkIGVpdGhlciBiZSBfX3BhY2tlZCBvcg0KPiA+IF9fYWxpZ25lZCgzMiku
DQo+ID4NCj4gPiBOb3QgdGhhdCBpdCB3b3VsZCBkbyBhbnkgZGlmZmVyZW5jZSwgaW4gcHJhY3Rp
Y2UsIGFzIHRoaXMgc3BlY2lmaWMNCj4gPiBzdHJ1Y3QgaGFzIGEgc2l6ZSB3aXRoIGlzIG11bHRp
cGxlIG9mIDMyIGJpdHMsIGJ1dCBsZXQncyBkbyB0aGUgcmlnaHQNCj4gPiBhbm5vdGF0aW9uIGhl
cmUsIG5vdCBtaXhpbmcgdHdvIGluY29tcGF0aWJsZSBhbGlnbm1lbnQgcmVxdWlyZW1lbnRzLg0K
PiA+DQo+IA0KPiBNeSB1bmRlcnN0YW5kaW5nIHdhcyB0aGF0IF9fcGFja2VkIG1ha2VzIHRoZSBj
b21waWxlciBub3QgaW5zZXJ0IGFueQ0KPiBhbGlnbm1lbnQgYmV0d2VlbiBwYXJ0aWN1bGFyIGZp
ZWxkcyBvZiB0aGUgc3RydWN0LCB3aGlsZSBfX2FsaWduZWQgbWFrZXMgdGhlDQo+IHdob2xlIHN0
cnVjdCBiZSBhbGlnbmVkIGF0IGdpdmVuIGJvdW5kYXJ5LCBpZiBwbGFjZWQgaW4gYW5vdGhlciBz
dHJ1Y3QuIElmIEkNCj4gZGlkbid0IG1pc3MgYW55dGhpbmcsIGhhdmluZyBib3RoIHNob3VsZCBt
YWtlIHBlcmZlY3Qgc2Vuc2UgaGVyZS4NCg0KQWNrDQoNCkkgYWxzbyByZWNhbGwgdGhhdCBhcyBw
YXJ0IG9mIGFkZHJlc3NpbmcgcmV2aWV3IGNvbW1lbnRzICAoZnJvbSBIYW5zIGFuZCBTYWthcmkp
LA0Kb24gZWFybGllciB2ZXJzaW9ucyBvZiB0aGlzIHBhdGNoIHNlcmllcywgd2UgYWRkZWQgX19w
YWNrZWQgYXR0cmlidXRlIHRvIGFsbCBzdHJ1Y3RzDQp0byBlbnN1cmUgdGhlIHNpemUgb2YgdGhl
IHN0cnVjdHMgcmVtYWlucyB0aGUgc2FtZSBiZXR3ZWVuIDMyIGFuZCA2NCBiaXQgYnVpbGRzLg0K
DQpUaGUgYWRkaXRpb24gb2Ygc3RydWN0dXJlIG1lbWJlcnMgb2YgdGhlIG5hbWUgcGFkZGluZ1t4
XSBpbiBzb21lIG9mIHRoZSBzdHJ1Y3RzDQplbnN1cmVzIHRoYXQgcmVzcGVjdGl2ZSBtZW1iZXJz
IGFyZSBhbGlnbmVkIGF0IDMyIGJ5dGUgYm91bmRhcmllcywgd2hpbGUgdGhlDQpvdmVyYWxsIHNp
emUgb2YgdGhlIHN0cnVjdHMgcmVtYWluIHRoZSBzYW1lIGJldHdlZW4gMzIgYW5kIDY0IGJpdCBi
dWlsZHMuDQoNClRoYW5rcw0KUmFqDQoNCj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gVG9tYXN6DQo=
