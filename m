Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50748 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752751AbdJKCCm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 22:02:42 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: RE: [PATCH v2 09/12] intel-ipu3: css hardware setup
Date: Wed, 11 Oct 2017 02:02:38 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE2869E@ORSMSX106.amr.corp.intel.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
 <1497478767-10270-10-git-send-email-yong.zhi@intel.com>
 <CAHp75VfK7qL5j+hDZj-QKcqf85_JiBDG7N8XET4a59Kfet5z1g@mail.gmail.com>
 <20170617184348.GW12407@valkosipuli.retiisi.org.uk>
 <CAHp75VcOnGuz5s1Y9ZU=Tgrz3wNHfG_APZbd=_HESpRm6BdAGg@mail.gmail.com>
In-Reply-To: <CAHp75VcOnGuz5s1Y9ZU=Tgrz3wNHfG_APZbd=_HESpRm6BdAGg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGksIEFuZHksDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4NCg0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1tZWRpYS1vd25lckB2Z2VyLmtlcm5lbC5vcmcgW21h
aWx0bzpsaW51eC1tZWRpYS0NCj4gb3duZXJAdmdlci5rZXJuZWwub3JnXSBPbiBCZWhhbGYgT2Yg
QW5keSBTaGV2Y2hlbmtvDQo+IFNlbnQ6IFNhdHVyZGF5LCBKdW5lIDE3LCAyMDE3IDEyOjA3IFBN
DQo+IFRvOiBTYWthcmkgQWlsdXMgPHNha2FyaS5haWx1c0Bpa2kuZmk+DQo+IENjOiBaaGksIFlv
bmcgPHlvbmcuemhpQGludGVsLmNvbT47IExpbnV4IE1lZGlhIE1haWxpbmcgTGlzdCA8bGludXgt
DQo+IG1lZGlhQHZnZXIua2VybmVsLm9yZz47IHNha2FyaS5haWx1c0BsaW51eC5pbnRlbC5jb207
IFpoZW5nLCBKaWFuIFh1DQo+IDxqaWFuLnh1LnpoZW5nQGludGVsLmNvbT47IFRvbWFzeiBGaWdh
IDx0ZmlnYUBjaHJvbWl1bS5vcmc+OyBNYW5pLA0KPiBSYWptb2hhbiA8cmFqbW9oYW4ubWFuaUBp
bnRlbC5jb20+OyBUb2l2b25lbiwgVHV1a2thDQo+IDx0dXVra2EudG9pdm9uZW5AaW50ZWwuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDA5LzEyXSBpbnRlbC1pcHUzOiBjc3MgaGFyZHdh
cmUgc2V0dXANCj4gDQo+IE9uIFNhdCwgSnVuIDE3LCAyMDE3IGF0IDk6NDMgUE0sIFNha2FyaSBB
aWx1cyA8c2FrYXJpLmFpbHVzQGlraS5maT4gd3JvdGU6DQo+ID4gT24gU2F0LCBKdW4gMTcsIDIw
MTcgYXQgMDE6NTQ6NTFBTSArMDMwMCwgQW5keSBTaGV2Y2hlbmtvIHdyb3RlOg0KPiA+PiBPbiBU
aHUsIEp1biAxNSwgMjAxNyBhdCAxOjE5IEFNLCBZb25nIFpoaSA8eW9uZy56aGlAaW50ZWwuY29t
PiB3cm90ZToNCj4gDQo+ID4+ID4gK3N0YXRpYyB2b2lkIHdyaXRlcyh2b2lkICptZW0sIHNzaXpl
X3QgbGVuLCB2b2lkIF9faW9tZW0gKnJlZykgew0KPiA+PiA+ICsgICAgICAgd2hpbGUgKGxlbiA+
PSA0KSB7DQo+ID4+ID4gKyAgICAgICAgICAgICAgIHdyaXRlbCgqKHUzMiAqKW1lbSwgcmVnKTsN
Cj4gPj4gPiArICAgICAgICAgICAgICAgbWVtICs9IDQ7DQo+ID4+ID4gKyAgICAgICAgICAgICAg
IHJlZyArPSA0Ow0KPiA+PiA+ICsgICAgICAgICAgICAgICBsZW4gLT0gNDsNCj4gPj4gPiArICAg
ICAgIH0NCj4gPj4gPiArfQ0KPiA+Pg0KPiA+PiBBZ2FpbiwgSSBqdXN0IGxvb2tlZCBpbnRvIHBh
dGNoZXMgYW5kIGZpcnN0IHdoYXQgSSBzZWUgaXMgcmVpbnZlbnRpbmcgdGhlDQo+IHdoZWVsLg0K
PiA+Pg0KPiA+PiBtZW1jcHlfdG9pbygpDQo+IA0KPiA+IFRoYXQgZG9lc24ndCBxdWl0ZSB3b3Jr
OiB0aGUgaGFyZHdhcmUgb25seSBzdXBwb3J0cyAzMi1iaXQgYWNjZXNzLg0KPiA+DQo+ID4gU28g
dGhlIGFuc3dlciBpcyB3cml0ZXNsKCkuDQo+IA0KPiBNYWtlcyBzZW5zZSENCj4gDQoNCldlIGFy
ZSBub3QgYWJsZSB0byB1c2Ugd3JpdGVzbCgpIGluIHRoZSBwYXN0IGJlY2F1c2UgaXQncyBub3Qg
ZGVmaW5lZCBmb3IgeDg2IHBsYXRmb3JtLCBidXQgbm93IHRoZSBoZWxwZXIgZnVuY3Rpb24gaXMg
YXZhaWxhYmxlIGluIDQuMTQsIHdlIHdpbGwgdXNlIGl0IGluIG5leHQgdXBkYXRlLg0KDQo+IC0t
DQo+IFdpdGggQmVzdCBSZWdhcmRzLA0KPiBBbmR5IFNoZXZjaGVua28NCg==
