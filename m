Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:19775 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753693AbeEJG43 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 02:56:29 -0400
From: "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
To: Tomasz Figa <tfiga@chromium.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>
CC: "Yeh, Andy" <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Chiang, AlanX" <alanx.chiang@intel.com>
Subject: RE: [PATCH v11] media: imx258: Add imx258 camera sensor driver
Date: Thu, 10 May 2018 06:56:25 +0000
Message-ID: <FA6CF6692DF0B343ABE491A46A2CD0E76C65E22D@SHSMSX101.ccr.corp.intel.com>
References: <1525275968-17207-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5BYokHC7J8wEjT4twx7_bU1Yyv1LbN2PAK2tjmCrr2cig@mail.gmail.com>
 <5881B549BE56034BB7E7D11D6EDEA2020678E62E@PGSMSX106.gar.corp.intel.com>
 <CAAFQd5CvPCfFx6Nxb26JdSAfD_YNe=-hvyJ=iKLcTA0LpxC4_g@mail.gmail.com>
In-Reply-To: <CAAFQd5CvPCfFx6Nxb26JdSAfD_YNe=-hvyJ=iKLcTA0LpxC4_g@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgVG9tYXN6LCANCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51
eC1tZWRpYS1vd25lckB2Z2VyLmtlcm5lbC5vcmcgW21haWx0bzpsaW51eC1tZWRpYS0NCj4gb3du
ZXJAdmdlci5rZXJuZWwub3JnXSBPbiBCZWhhbGYgT2YgVG9tYXN6IEZpZ2ENCj4gU2VudDogV2Vk
bmVzZGF5LCBNYXkgOSwgMjAxOCA2OjA1IFBNDQo+IFRvOiBDaGVuLCBKYXNvblggWiA8amFzb254
LnouY2hlbkBpbnRlbC5jb20+DQo+IENjOiBZZWgsIEFuZHkgPGFuZHkueWVoQGludGVsLmNvbT47
IExpbnV4IE1lZGlhIE1haWxpbmcgTGlzdCA8bGludXgtDQo+IG1lZGlhQHZnZXIua2VybmVsLm9y
Zz47IFNha2FyaSBBaWx1cyA8c2FrYXJpLmFpbHVzQGxpbnV4LmludGVsLmNvbT47IENoaWFuZywN
Cj4gQWxhblggPGFsYW54LmNoaWFuZ0BpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djExXSBtZWRpYTogaW14MjU4OiBBZGQgaW14MjU4IGNhbWVyYSBzZW5zb3IgZHJpdmVyDQo+IA0K
PiBIaSBKYXNvbiwNCj4gDQo+ID4gSVBVMyBIQUwgaGFzIGEgaGFuZGxlciB0byBiaW5kIHRlc3Rf
cGF0dGVybiBtb2RlLg0KPiA+IFRoZSBDT0xPUiBCQVIgTU9ERSBpbiBIQUwgaGFzIGJlZW4gY29u
ZmlndXJlZCB0byAxIHdoZW4gQVBQIHJlcXVlc3RzDQo+ID4gdG8NCj4gb3V0cHV0IGNvbG9yIGJh
ciBpbWFnZS4NCj4gPiBIb3dldmVyIFNvbnkgc2Vuc29yJ3MgQ09MT1IgQkFSIE1PREUgaXMgZGVz
aWduZWQgYXMgMiBpbiByZWdpc3RlciB0YWJsZS4NCj4gKGdyZXkgY29sb3IgYmFycyBhcyAxKS4N
Cj4gPiBXaGVuIEhBTCBzZW5kcyBoYW5kbGVyIHRvIGRyaXZlciB0byBzd2l0Y2ggdGVzdCBwYXR0
ZXJuIG1vZGUgKHRvIENPTE9SDQo+IEJBUiAtIHZhbDogMSksIGl0IHdpbGwgYmUgZ3JleSBjb2xv
ciwgc2luY2UgZHJpdmVyIHN0aWxsIHNldCBURVNUX1BBVFRFUk5fTU9ERQ0KPiByZWcgdmFsdWUg
dG8gMSwgdGhvc2UgaXQgaXMgbm90IHdoYXQgd2UgZXhwZWN0ZWQuDQo+IA0KPiA+IFRoYXQgaXMg
d2h5IHdlIGhhdmUgdG8gbWFrZSBhbiBhcnJheSB3aXRoIGluZGV4IHRvIGFycmFuZ2UgdGhlIG9y
ZGVyDQo+ID4gb2YNCj4gdGhlIHRlc3QgcGF0dGVybiBpdGVtcywgc28gZHJpdmVyIHdpbGwgY2hv
b3NlIENPTE9SIEJBUiBjb3JyZWN0bHkgd2hlbiBIQUwNCj4gc2VuZCB0ZXN0X3BhdHRlcm4gbWVz
c2FnZSAod2l0aCAxKS4NCj4gPiBUaGUgY29uY2VwdCBpcyB0aGUgdGVzdF9wYXR0ZXJuX21lbnUg
Y291bGQgYmUgbGlzdGVkIGluIGRyaXZlciBwZXINCj4gPiByZWFsDQo+IHJlcXVpcmVtZW50LCBu
byBtYXR0ZXIgaG93IHRoZSBzZW5zb3IgcmVnaXN0ZXIgaXMgZGVzaWduZWQuDQo+IA0KPiANCj4g
VjRMMiBzcGVjaWZpY2F0aW9uIGRvZXMgbm90IGRlZmluZSBhbnkgcGFydGljdWxhciBvcmRlciBv
ZiBtZW51IGVudHJpZXMgaW4NCj4gVjRMMl9DSURfVEVTVF9QQVRURVJOLiBUaGUgYXBwbGljYXRp
b24gc2hvdWxkIHF1ZXJ5IHRoZSBzdHJpbmdzIGluIHRoZQ0KPiBtZW51IGFuZCBkZXRlcm1pbmUg
dGhlIG9wdGlvbiBpdCBuZWVkcyBiYXNlZCBvbiB0aGF0LiBJZiBpdCBoYXJkY29kZXMNCj4gcGFy
dGljdWxhciBpbmRleCwgaXQncyBhIGJ1Zy4NCg0KSXMgdGhlcmUgYW55IHJlYXNvbiB0aGF0IHRo
ZXJlIGlzIG5vIGNlcnRhaW4gbWFjcm8gZGVmaW5lIGZvciBkaWZmZXJlbnQgdHlwZSBvZiB0ZXN0
IHBhdHRlcm4gaW4gdjRsMj8NClNvIEFwcCB3aWxsIG5vdCBkZXBlbmQgb24gYW55IHN0cmluZ3Mg
d2hlcmUgY291bGQgYmUgZGlmZmVyZW50IG9uIGRpZmZlcmVudCBzZW5zb3IgZHJpdmVycy4NCg0K
PiANCj4gVGhhbmtzLg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBUb21hc3oNCg==
