Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3B2C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFA4D21738
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfAISgE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:36:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:15797 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbfAISgE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 13:36:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2019 10:36:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,458,1539673200"; 
   d="scan'208";a="116818716"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2019 10:36:03 -0800
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 9 Jan 2019 10:36:03 -0800
Received: from fmsmsx122.amr.corp.intel.com ([169.254.5.2]) by
 fmsmsx156.amr.corp.intel.com ([169.254.13.179]) with mapi id 14.03.0415.000;
 Wed, 9 Jan 2019 10:36:02 -0800
From:   "Mani, Rajmohan" <rajmohan.mani@intel.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
CC:     Tomasz Figa <tfiga@chromium.org>, "Zhi, Yong" <yong.zhi@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: RE: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Thread-Topic: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Thread-Index: AQHUb9aJ2xONOQn66UKjxJluMlyZrqVnikaAgABWAwCAADMOAP//erHggAdi27CAAJYyAP//fHuAgAB6QuCAClF3t4AAkIyAgAdn3wCAB0R8AIAATewAgByKWQCAAjYSgP//e7oQABIdloAAD6nxkP//kfAAgACD8BA=
Date:   Wed, 9 Jan 2019 18:36:02 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A599B321627@fmsmsx122.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1819843.KIqgResAvh@avalon> <2135468.G1bK1392oW@avalon>
 <3475971.piroVKfGO7@avalon>
 <CAAFQd5CN3dhTviSnFbzSOjkMTQqUyOajYv+CVxSLLAih522CgQ@mail.gmail.com>
 <CAAFQd5AWLi=UD+LtuiQdc5QD8v5B1WX0Jcoe6=QUy+392FSeng@mail.gmail.com>
 <20190109164037.yvtluixvua7cm2tl@uno.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A599B321599@fmsmsx122.amr.corp.intel.com>
 <20190109172553.lrnwxuy3x4drk6af@uno.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A599B3215DA@fmsmsx122.amr.corp.intel.com>
 <20190109182028.l6dopz5k75w3u3t4@uno.localdomain>
In-Reply-To: <20190109182028.l6dopz5k75w3u3t4@uno.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjdjNDc2ZTQtMjNhMS00M2YyLTllNGYtMDJiNGEzYmM4ZWZlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiM0xyWGozODh0aXIwSzFiRkZuK1VOUVZFZ0NPQjIwUTlzcFJWRTI5U3A5cTZSczRYWUlibXAzYUpsMHUwemMxNiJ9
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgSmFjb3BvLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjcgMDAvMTZdIEludGVsIElQVTMg
SW1nVSBwYXRjaHNldA0KPiANCj4gSGkgUmFqLA0KPiANCj4gT24gV2VkLCBKYW4gMDksIDIwMTkg
YXQgMDY6MDE6MzlQTSArMDAwMCwgTWFuaSwgUmFqbW9oYW4gd3JvdGU6DQo+ID4gSGkgSmFjb3Bv
LA0KPiA+DQo+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIIHY3IDAwLzE2XSBJbnRlbCBJUFUzIElt
Z1UgcGF0Y2hzZXQNCj4gPiA+DQo+ID4gPiBIZWxsbyBSYWosDQo+ID4gPg0KPiA+ID4gT24gV2Vk
LCBKYW4gMDksIDIwMTkgYXQgMDU6MDA6MjFQTSArMDAwMCwgTWFuaSwgUmFqbW9oYW4gd3JvdGU6
DQo+ID4gPiA+IEhpIExhdXJlbnQsIFRvbWFzeiwgSmFjb3BvLA0KPiA+ID4gPg0KPiA+ID4gPiA+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjcgMDAvMTZdIEludGVsIElQVTMgSW1nVSBwYXRjaHNldA0K
PiA+ID4gPiA+DQo+ID4gPiA+ID4gSGVsbG8sDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBPbiBUdWUs
IEphbiAwOCwgMjAxOSBhdCAwMzo1NDozNFBNICswOTAwLCBUb21hc3ogRmlnYSB3cm90ZToNCj4g
PiA+ID4gPiA+IEhpIFJhaiwgWW9uZywgQmluZ2J1LCBUaWFuc2h1LA0KPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+IE9uIEZyaSwgRGVjIDIxLCAyMDE4IGF0IDEyOjA0IFBNIFRvbWFzeiBGaWdhDQo+
ID4gPiA+ID4gPiA8dGZpZ2FAY2hyb21pdW0ub3JnPg0KPiA+ID4gd3JvdGU6DQo+ID4gPiA+ID4g
PiA+DQo+ID4gPiA+ID4gPiA+IE9uIEZyaSwgRGVjIDIxLCAyMDE4IGF0IDc6MjQgQU0gTGF1cmVu
dCBQaW5jaGFydA0KPiA+ID4gPiA+ID4gPiA8bGF1cmVudC5waW5jaGFydEBpZGVhc29uYm9hcmQu
Y29tPiB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+IEhlbGxvbg0KPiA+
ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+ID4gT24gU3VuZGF5LCAxNiBEZWNlbWJlciAyMDE4
IDA5OjI2OjE4IEVFVCBMYXVyZW50IFBpbmNoYXJ0DQo+IHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+
ID4gSGVsbG8gWW9uZywNCj4gPiA+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+ID4gPiBDb3Vs
ZCB5b3UgcGxlYXNlIGhhdmUgYSBsb29rIGF0IHRoZSBjcmFzaCByZXBvcnRlZCBiZWxvdyA/DQo+
ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiBBIGJpdCBtb3JlIGluZm9ybWF0aW9uIHRv
IGhlbHAgeW91IGRlYnVnZ2luZyB0aGlzLiBJJ3ZlDQo+ID4gPiA+ID4gPiA+ID4gZW5hYmxlZCBL
QVNBTiBpbiB0aGUga2VybmVsIGNvbmZpZ3VyYXRpb24sIGFuZCBnZXQgdGhlDQo+ID4gPiA+ID4g
PiA+ID4gZm9sbG93aW5nIHVzZS1hZnRlci1mcmVlDQo+ID4gPiA+ID4gcmVwb3J0cy4NCj4gPiA+
ID4gPg0KPiA+ID4gPiA+IEkgdGVzdGVkIGFzIHdlbGwgdXNpbmcgdGhlIGlwdS1wcm9jZXNzLnNo
IHNjcmlwdCBzaGFyZWQgYnkNCj4gPiA+ID4gPiBMYXVyZW50LCB3aXRoIHRoZSBmb2xsb3dpbmcg
Y29tbWFuZCBsaW5lOg0KPiA+ID4gPiA+IC4vaXB1My1wcm9jZXNzLnNoIC0tb3V0IDI1NjB4MTky
MCAtLXZmIDE5MjB4MTA4MA0KPiA+ID4gPiA+IGZyYW1lLTI1OTJ4MTk0NC5jaW8yDQo+ID4gPiA+
ID4NCj4gPiA+ID4gPiBhbmQgSSBnb3QgYSB2ZXJ5IHNpbWlsYXIgdHJhY2UgYXZhaWxhYmxlIGF0
Og0KPiA+ID4gPiA+IGh0dHBzOi8vcGFzdGUuZGViaWFuLm5ldC9oaWRkZW4vNTg1NWUxNWEvDQo+
ID4gPiA+ID4NCj4gPiA+ID4gPiBQbGVhc2Ugbm90ZSBJIGhhdmUgYmVlbiBhYmxlIHRvIHByb2Nl
c3MgYSBzZXQgb2YgaW1hZ2VzICh3aXRoDQo+ID4gPiA+ID4gS0FTQU4gZW5hYmxlZCB0aGUgbWFj
aGluZSBkb2VzIG5vdCBmcmVlemUpIGJ1dCB0aGUga2VybmVsIGxvZw0KPiA+ID4gPiA+IGdldHMg
Zmxvb2RlZCBhbmQgaXQgaXMgbm90IHBvc3NpYmxlIHRvIHByb2Nlc3MgYW55IG90aGVyIGZyYW1l
IGFmdGVyIHRoaXMuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGUgaXNzdWUgaXMgY3VycmVudGx5
IHF1aXRlIGFubm95aW5nIGFuZCBpdCdzIGEgYmxvY2tlciBmb3INCj4gPiA+ID4gPiBsaWJjYW1l
cmEgZGV2ZWxvcG1lbnQgb24gSVBVMy4gUGxlYXNlIGxldCBtZSBrbm93IGlmIEkgY2FuDQo+ID4g
PiA+ID4gc3VwcG9ydCB3aXRoDQo+ID4gPiBtb3JlIHRlc3RpbmcuDQo+ID4gPiA+ID4NCj4gPiA+
ID4gPiBUaGFua3MNCj4gPiA+ID4gPiAgICBqDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gPiA+IFsgIDE2Ni4zMzI5MjBdDQo+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4g
Pg0KPiA+ID4NCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQ0KPiA+ID4gPiA+ID09DQo+ID4gPiA+ID4gPiA+ID4gWyAgMTY2
LjMzMjkzN10gQlVHOiBLQVNBTjogdXNlLWFmdGVyLWZyZWUgaW4NCj4gPiA+ID4gPiA+ID4gPiBf
X2NhY2hlZF9yYm5vZGVfZGVsZXRlX3VwZGF0ZSsweDM2LzB4MjAyDQo+ID4gPiA+ID4gPiA+ID4g
WyAgMTY2LjMzMjk0NF0gUmVhZCBvZiBzaXplIDggYXQgYWRkciBmZmZmODg4MTMzODIzNzE4IGJ5
DQo+ID4gPiA+ID4gPiA+ID4gdGFzaw0KPiA+ID4gPiA+ID4gPiA+IHlhdnRhLzEzMDUNCj4gPiA+
ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+IFsgIDE2Ni4zMzI5NTVdIENQVTogMyBQSUQ6IDEz
MDUgQ29tbTogeWF2dGEgVGFpbnRlZDogRyAgICAgICAgIEMNCj4gPiA+IDQuMjAuMC0NCj4gPiA+
ID4gPiByYzYrICMzDQo+ID4gPiA+ID4gPiA+ID4gWyAgMTY2LjMzMjk1OF0gSGFyZHdhcmUgbmFt
ZTogSFAgU29yYWthL1NvcmFrYSwgQklPUw0KPiA+ID4gPiA+ID4gPiA+IDA4LzMwLzIwMTggWyAx
NjYuMzMyOTU5XSBDYWxsIFRyYWNlOg0KPiA+ID4gPiA+ID4gPiA+IFsgIDE2Ni4zMzI5NjddICBk
dW1wX3N0YWNrKzB4NWIvMHg4MSBbICAxNjYuMzMyOTc0XQ0KPiA+ID4gPiA+ID4gPiA+IHByaW50
X2FkZHJlc3NfZGVzY3JpcHRpb24rMHg2NS8weDIyNw0KPiA+ID4gPiA+ID4gPiA+IFsgIDE2Ni4z
MzI5NzldICA/IF9fY2FjaGVkX3Jibm9kZV9kZWxldGVfdXBkYXRlKzB4MzYvMHgyMDINCj4gPiA+
ID4gPiA+ID4gPiBbICAxNjYuMzMyOTgzXSAga2FzYW5fcmVwb3J0KzB4MjQ3LzB4Mjg1IFsgIDE2
Ni4zMzI5ODldDQo+ID4gPiA+ID4gPiA+ID4gX19jYWNoZWRfcmJub2RlX2RlbGV0ZV91cGRhdGUr
MHgzNi8weDIwMg0KPiA+ID4gPiA+ID4gPiA+IFsgIDE2Ni4zMzI5OTVdICBwcml2YXRlX2ZyZWVf
aW92YSsweDU3LzB4NmQgWyAgMTY2LjMzMjk5OV0NCj4gPiA+ID4gPiA+ID4gPiBfX2ZyZWVfaW92
YSsweDIzLzB4MzEgWyAgMTY2LjMzMzAxMV0NCj4gPiA+ID4gPiA+ID4gPiBpcHUzX2RtYW1hcF9m
cmVlKzB4MTE4LzB4MWQ2IFtpcHUzX2ltZ3VdDQo+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+
IFRoYW5rcyBMYXVyZW50LCBJIHRoaW5rIHRoaXMgaXMgYSB2ZXJ5IGdvb2QgaGludC4gSXQgbG9v
a3MNCj4gPiA+ID4gPiA+ID4gbGlrZSB3ZSdyZSBiYXNpY2FsbHkgZnJlZWluZyBhbmQgYWxyZWFk
eSBmcmVlZCBJT1ZBIGFuZA0KPiA+ID4gPiA+ID4gPiBjb3JydXB0aW5nIHNvbWUgYWxsb2NhdG9y
IHN0YXRlPw0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IERpZCB5b3UgaGF2ZSBhbnkgbHVjayBp
biByZXByb2R1Y2luZyBhbmQgZml4aW5nIHRoaXMgZG91YmxlIGZyZWUNCj4gaXNzdWU/DQo+ID4g
PiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiBUaGlzIGlzc3VlIGlzIGVpdGhlciBoYXJkIHRvIHJl
cHJvZHVjZSBvciBjb21lcyB3aXRoIGRpZmZlcmVudA0KPiA+ID4gPiBzaWduYXR1cmVzIHdpdGgg
dGhlIHVwZGF0ZWQgeWF2dGEgKHRoYXQgbm93IHN1cHBvcnRzIG1ldGEgb3V0cHV0KQ0KPiA+ID4g
PiB3aXRoIHRoZSA0LjQga2VybmVsIHRoYXQgSSBoYXZlIGJlZW4gdXNpbmcuDQo+ID4gPiA+IEkg
YW0gc3dpdGNoaW5nIHRvIDQuMjAtcmM2IGZvciBiZXR0ZXIgcmVwcm9kdWNpYmlsaXR5Lg0KPiA+
ID4gPiBFbmFibGluZyBLQVNBTiBhbHNvIHJlc3VsdHMgaW4gc3RvcmFnZSBzcGFjZSBpc3N1ZXMg
b24gbXkgQ2hyb21lDQo+IGRldmljZS4NCj4gPiA+ID4gV2lsbCBlbmFibGUgdGhpcyBqdXN0IGZv
ciBJbWdVIHRvIGdldCBhaGVhZCBhbmQgZ2V0IGJhY2sgd2l0aCBtb3JlDQo+IHVwZGF0ZXMuDQo+
ID4gPiA+DQo+ID4gPg0KPiA+ID4gVGhhbmtzIGZvciB0ZXN0aW5nIHRoaXMuDQo+ID4gPg0KPiA+
ID4gRm9yIHlvdXIgaW5mb3JtYXRpb25zIEknbSB1c2luZyB0aGUgZm9sbG93aW5nIGJyYW5jaCwg
ZnJvbSBTYWthcmkncw0KPiA+ID4gdHJlZTogZ2l0Oi8vbGludXh0di5vcmcvc2FpbHVzL21lZGlh
X3RyZWUuZ2l0IGlwdTMNCj4gPiA+DQo+ID4gPiBBbHRob3VnaCBpdCBhcHBlYXJzIHRoYXQgdGhl
IG1lZGlhIHRyZWUgbWFzdGVyIGJyYW5jaCBoYXMgZXZlcnl0aGluZw0KPiA+ID4gdGhhdCBpcyB0
aGVyZSwgd2l0aCBhIGZldyBhZGRpdGlvbmFsIHBhdGNoZXMgb24gdG9wLiBJIHNob3VsZCBtb3Zl
DQo+ID4gPiB0byB1c2UgbWVkaWEgdHJlZSBtYXN0ZXIgYXMgd2VsbC4uLg0KPiA+ID4NCj4gPiA+
IEkgaGF2ZSBoZXJlIGF0dGFjaGVkIDIgY29uZmlndXJhdGlvbiBmaWxlcyBmb3IgdjQuMjAtcmM1
IEkgYW0gdXNpbmcNCj4gPiA+IG9uIFNvcmFrYSwgaW4gY2FzZSB0aGV5IG1pZ2h0IGhlbHAgeW91
LiBPbmUgaGFzIEtBU0FOIGVuYWJsZWQgd2l0aA0KPiA+ID4gYW4gaW5jcmVhc2VkIGtlcm5lbCBs
b2cgc2l6ZSwgdGhlIG90aGVyIG9uZSBpcyB0aGUgb25lIHdlIHVzZSBmb3IgZGFpbHkNCj4gZGV2
ZWxvcG1lbnQuDQo+ID4NCj4gPiBJIHRoaW5rIEkgYW0gbWlzc2luZyBhIHRyaWNrIGhlcmUgdG8g
b3ZlcnJpZGUgdGhlIGRlZmF1bHQgY2hyb21lIG9zDQo+ID4ga2VybmVsIGNvbmZpZyB3aXRoIHRo
ZSBvbmUgdGhhdCB5b3Ugc3VwcGxpZWQuDQo+ID4NCj4gPiBJbiBwYXJ0aWN1bGFyIEkgYW0gbG9v
a2luZyBmb3Igc3RlcHMgdG8gYnVpbGQgdGhlIHVwc3RyZWFtIGtlcm5lbA0KPiA+IHdpdGhpbiBj
aHJvbWUgb3MgYnVpbGQgZW52aXJvbm1lbnQgdXNpbmcgeW91ciBjb25maWcsIHNvIEkgY2FuIHVw
ZGF0ZSBteQ0KPiBTb3Jha2EgZGV2aWNlLg0KPiANCj4gSSdtIHNvcnJ5IEkgY2FuIG5vdCBoZWxw
IG11Y2ggYnVpbGRpbmcgJ3dpdGhpbmcgY2hyb21lIG9zIGJ1aWxkIGVudmlyb25tZW50Jy4NCj4g
Q2FyZSB0byBleHBsYWluIHdoYXQgeW91IG1lYW4/DQo+IA0KDQpUaGlzIGlzIHBhcnQgb2YgdGhl
IENocm9taXVtIE9TIGJ1aWxkIGVudmlyb25tZW50IGFuZCBkZXZlbG9wbWVudCB3b3JrZmxvdy4N
Cmh0dHBzOi8vY2hyb21pdW0uZ29vZ2xlc291cmNlLmNvbS9jaHJvbWl1bW9zL2RvY3MvKy9tYXN0
ZXIva2VybmVsX2ZhcS5tZA0KDQpObyB3b3JyaWVzLg0KSSB3aWxsIHN5bmMgdXAgd2l0aCBUb21h
c3osIGFzIGhlIG1hbmFnZWQgdG8gZ2V0IHRoaXMgd29ya2luZyB3aXRoIDQuMjAga2VybmVsLg0K
DQo+IFdoYXQgSSB1c3VhbGx5IGRvLCBwcm92aWRlZCB5b3UncmUgcnVubmluZyBhIGRlYmlhbi1i
YXNlZCBMaW51eCBkaXN0cm8gb24NCj4geW91ciBTb3Jha2EgZGV2aWNlLCBpcyBjb21waWxlIHRo
ZSBrZXJuZWwgb24gaG9zdCB3aXRoICdtYWtlIGJpbmRlYi1wa2cnDQo+IGFuZCB0aGVuIHVwbG9h
ZCBhbmQgaW5zdGFsbCB0aGUgcmVzdWx0aW5nIC5kZWIgcGFja2FnZSBvbiB0aGUgU29yYWthDQo+
IGNocm9tZWJvb2suDQo+IA0KPiBJZiB0aGF0IG1pZ2h0IHdvcmsgZm9yIHlvdSwgd2UgY2FuIHNo
YXJlIG1vcmUgZGV0YWlscyBvbiBob3cgdG8gZG8gc28NCj4gKHRvbW9ycm93IG1heWJlIDpwICkN
Cj4gDQoNClRoZSBhYm92ZSBpbmZvIHdvdWxkIGJlIHZlcnkgaGVscGZ1bCBmb3IgdXMgdG8gb3B0
aW1pemUgdXNlIG9mIHVwc3RyZWFtDQprZXJuZWwgaW4gQ2hyb21lIE9TIGRldmljZXMuDQpQbGVh
c2Ugc2hhcmUgd2hlbiB5b3VyIHRpbWUgcGVybWl0cy4NCg0KPiBUaGFua3MNCj4gICAgag0KPiAN
Cj4gPg0KPiA+ID4NCj4gPiA+IEFsc28sIHBsZWFzZSBtYWtlIHN1cmUgdG8gdXNlICh0aGUgbW9z
dCkgcmVjZW50IG1lZGlhLWN0bCBhbmQgeWF2dGENCj4gPiA+IHV0aWxpdGllcywgYXMgdGhlIG9u
ZXMgcHJvdmlkZWQgYnkgbW9zdCBkaXN0cm9zIGFyZSB1c3VhbGx5IG5vdA0KPiA+ID4gcmVjZW50
IGVub3VnaCB0byB3b3JrIHdpdGggSVBVMywgYnV0IEknbSBzdXJlIHlvdSBrbm93IHRoYXQgYWxy
ZWFkeQ0KPiA+ID4gOykNCj4gPg0KPiA+IEFjaw0KPiA+DQo+ID4gPg0KPiA+ID4gVGhhbmtzDQo+
ID4gPiAgIGoNCj4gPiA+DQo+ID4NCj4gPiBbc25pcF0NCg==
