Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3906AC282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 16:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 096A1217D6
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 16:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbfAVQVp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:21:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:15076 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728669AbfAVQVp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 11:21:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 08:21:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,507,1539673200"; 
   d="scan'208";a="293485423"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga005.jf.intel.com with ESMTP; 22 Jan 2019 08:21:43 -0800
Received: from fmsmsx123.amr.corp.intel.com (10.18.125.38) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 22 Jan 2019 08:21:42 -0800
Received: from fmsmsx122.amr.corp.intel.com ([169.254.5.2]) by
 fmsmsx123.amr.corp.intel.com ([169.254.7.98]) with mapi id 14.03.0415.000;
 Tue, 22 Jan 2019 08:21:42 -0800
From:   "Mani, Rajmohan" <rajmohan.mani@intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     Tomasz Figa <tfiga@chromium.org>, Jacopo Mondi <jacopo@jmondi.org>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: RE: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Thread-Topic: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Thread-Index: AQHUb9aJ2xONOQn66UKjxJluMlyZrqVnikaAgABWAwCAADMOAP//erHggAdi27CAAJYyAP//fHuAgAB6QuCAClF3t4AAkIyAgAdn3wCAB0R8AIAATewAgByKWQCAAjYSgP//e7oQABIdloAAD6nxkP//kfAAgACD8BD//WKpMIAGmz8A//sY2VCAEm0bgIAAKNWA//5vI7A=
Date:   Tue, 22 Jan 2019 16:21:42 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A599B323F0D@fmsmsx122.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <20190109182028.l6dopz5k75w3u3t4@uno.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A599B322D80@fmsmsx122.amr.corp.intel.com>
 <2718150.slhGTuRzHq@avalon>
 <6F87890CF0F5204F892DEA1EF0D77A599B323499@fmsmsx122.amr.corp.intel.com>
 <CAAFQd5CRWfBupPKmAUQnQmOqWgi0YZ7=8JOFe4tfpU4hhUxi7Q@mail.gmail.com>
 <20190121080711.GA4420@pendragon.ideasonboard.com>
In-Reply-To: <20190121080711.GA4420@pendragon.ideasonboard.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjU2NjhjMzQtMDE4NS00OWU1LTlmZTctNjY3ZjVlNmI5Y2YxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSGdaS3QwQU9rdnR4ZWFVM1hrRklxWDRRQmlqK2NNMHM2ZmhiVytHdmxtTXIrd29ubjhDSnBvMnk1RHRHS2o1QiJ9
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgVG9tYXN6LCBMYXVyZW50LA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjcgMDAvMTZdIElu
dGVsIElQVTMgSW1nVSBwYXRjaHNldA0KPiANCj4gSGVsbG8gUmFqLA0KPiANCj4gT24gTW9uLCBK
YW4gMjEsIDIwMTkgYXQgMDI6NDE6MDNQTSArMDkwMCwgVG9tYXN6IEZpZ2Egd3JvdGU6DQo+ID4g
IE9uIFdlZCwgSmFuIDE2LCAyMDE5IGF0IDExOjE2IEFNIE1hbmksIFJham1vaGFuDQo+IDxyYWpt
b2hhbi5tYW5pQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCB2
NyAwMC8xNl0gSW50ZWwgSVBVMyBJbWdVIHBhdGNoc2V0IE9uIFNhdHVyZGF5LA0KPiA+ID4+IDEy
IEphbnVhcnkgMjAxOSAwNDozMDo0OSBFRVQgTWFuaSwgUmFqbW9oYW4gd3JvdGU6DQo+ID4gPj4N
Cj4gPiA+PiBbc25pcF0NCj4gPiA+Pg0KPiA+ID4+PiBJIGZpbmFsbHkgbWFuYWdlZCB0byByZXBy
b2R1Y2UgdGhlIGlzc3VlIHdpdGggNC4yMC1yYzYsIHdpdGggS0FTQU4NCj4gPiA+Pj4gZW5hYmxl
ZCBhbmQgd2l0aCBDT05GSUdfU0xVQl9ERUJVR19PTiB3aXRoIFNMQUJfU1RPUkVfVVNFUi4NCj4g
PiA+Pg0KPiA+ID4+IE5pY2UgISBUaGFuayB5b3UgZm9yIHlvdXIgd29yay4NCj4gPiA+Pg0KPiA+
ID4+PiBUaGUgZm9sbG93aW5nIGxpbmUgaW5kaWNhdGVzIHRoZSBjcmFzaCBoYXBwZW5zIHdoZW4g
eWF2dGEgUElEDQo+ID4gPj4+IDEwMjg5IHRyaWVzIHRvIGZyZWUgdGhlIG1lbW9yeS4NCj4gPiA+
Pj4NCj4gPiA+Pj4gWyAgNDUyLjQzNzg0NF0gQlVHOiBLQVNBTjogdXNlLWFmdGVyLWZyZWUgaW4N
Cj4gPiA+Pj4gaXB1M19kbWFtYXBfZnJlZSsweDUwLzB4OWMgW2lwdTNfaW1ndV0gWyAgNDUyLjQ0
NjEyM10gUmVhZCBvZiBzaXplDQo+ID4gPj4+IDggYXQgYWRkciBmZmZmODg4MTUwMzQ4MWEwIGJ5
IHRhc2sgeWF2dGEvMTAyODkNCj4gPiA+Pj4NCj4gPiA+Pj4gVGhlIGFib3ZlIGxvb2tzIHRvIGJl
IG5vcm1hbCwgc2luY2UgaXQncyB0aGUgc2FtZSB0YXNrIHRoYXQNCj4gPiA+Pj4gYWxsb2NhdGVk
IHRoaXMgbWVtb3J5Lg0KPiA+ID4+PiBbICA0NTIuNjg1NzMxXSBBbGxvY2F0ZWQgYnkgdGFzayAx
MDI4OToNCj4gPiA+Pj4NCj4gPiA+Pj4gQmVmb3JlIHRoZSBhYm92ZSBoYXBwZW5lZCwgeWF2dGEv
MTAxODcgY2FtZSBpbiBhbmQgZnJlZWQgdGhpcw0KPiA+ID4+PiBtZW1vcnkgcGVyIEtBU0FOLg0K
PiA+ID4+PiBbICA0NTIuNzg3NjU2XSBGcmVlZCBieSB0YXNrIDEwMTg3Og0KPiA+ID4+Pg0KPiA+
ID4+PiBJcyB0aGlzIChvbmUgaW5zdGFuY2Ugb2YgeWF2dGEgZnJlZWluZyB0aGUgbWVtb3J5IGFs
bG9jYXRlZCBieQ0KPiA+ID4+PiBhbm90aGVyIGluc3RhbmNlIG9mIHlhdnRhKSBleHBlY3RlZD8g
T3IgZG9lcyBpdCBpbmRpY2F0ZSB0aGF0IG1tYXANCj4gPiA+Pj4gZ2l2aW5nIHRoZSBzYW1lIGFk
ZHJlc3MgYWNyb3NzIHRoZXNlIDIgaW5zdGFuY2VzIG9mIHlhdnRhPyBJIG5lZWQNCj4gPiA+Pj4g
dG8gZGVidWcgLyBjb25maXJtIHRoZSBsYXR0ZXIgY2FzZS4NCj4gPiA+Pg0KPiA+ID4+IEtBU0FO
IHByaW50cyB0aGUgdGFzayBuYW1lIChhbmQgcHJvY2VzcyBJRCkgdG8gaGVscCB5b3UgZGVidWdn
aW5nDQo+ID4gPj4gdGhlIHByb2JsZW0sIGJ1dCB0aGlzIGRvZXNuJ3QgbWVhbiB0aGF0IHlhdnRh
IGlzIGZyZWVpbmcgdGhlDQo+ID4gPj4gbWVtb3J5LiB5YXZ0YSBleGVyY2lzZXMgdGhlIFY0TDIg
QVBJIGV4cG9zZWQgYnkgdGhlIGRyaXZlciwgYW5kDQo+ID4gPj4gaW50ZXJuYWxseSwgZG93biB0
aGUgY2FsbCBzdGFjaywgaXB1M19kbWFtYXBfZnJlZSgpIGlzIGNhbGxlZCBieQ0KPiA+ID4+IHRo
ZSBkcml2ZXIuIEFjY29yZGluZyB0byB0aGUgYmFja3RyYWNlcyB5b3UgcG9zdGVkLCB0aGlzIGlz
IGluDQo+ID4gPj4gcmVzcG9uc2UgdG8gYSBWSURJT0NfU1RSRUFNT0ZGIGNhbGwgZnJvbSB5YXZ0
YS4gSSB3b3VsZCBleHBlY3QNCj4gPiA+PiBWSURJT0NfU1RSRUFNT0ZGIHRvIGZyZWUgRE1BIG1h
cHBpbmdzIGNyZWF0ZWQgZm9yIHRoZSBidWZmZXJzIG9uDQo+ID4gPj4gdGhlIGNvcnJlc3BvbmRp
bmcgdmlkZW8gbm9kZXMsIGFuZCB0aHVzIGFsbG9jYXRlZCBieSB0aGUgc2FtZSB0YXNrLg0KPiA+
ID4NCj4gPiA+IEFjay4NCj4gPiA+DQo+ID4gPj4gVGhlIGZhY3QNCj4gPiA+PiB0aGF0IG1lbW9y
eSBpcyBhbGxvY2F0ZWQgaW4gb25lIHRhc2sgYW5kIGZyZWVkIGluIGFub3RoZXIgc2VlbXMNCj4g
PiA+PiB3ZWlyZCB0byBtZSBpbiB0aGlzIGNhc2UuDQo+ID4gPj4NCj4gPiA+DQo+ID4gPiBJIGhh
dmUgaW5zdHJ1bWVudGVkIHRoZSBjb2RlIGFyb3VuZCBpcHUzIGRtYSBtYXAgY29kZSwgd2l0aCBh
IGNoYW5nZQ0KPiA+ID4gdG8gc2tpcCBkbWEgZnJlZSBvcGVyYXRpb25zLCBpZiB0aGUgY3VycmVu
dC0+cGlkIGlzIG5vdCB0aGUgc2FtZSBhcw0KPiA+ID4gdGhlIHBpZCB0aGF0IG9yaWdpbmFsbHkg
ZGlkIHRoZSBkbWEgYWxsb2MuDQo+ID4gPg0KPiA+ID4gVGhlcmUgYXJlIG5vIGNyYXNoZXMgaW4g
dGhpcyBjYXNlLCBhcyBleHBlY3RlZC4NCj4gPiA+DQo+ID4gPiBJIGFsc28gY29uZmlybWVkIHRo
YXQgU1RSRUFNX09OL09GRiBpcyB0aGUgb25lIHRoYXQgcmVzdWx0cyBpbiB0aGlzIGNyYXNoLg0K
PiA+ID4gSSBuZWVkIHRvIHNwZW5kIG1vcmUgdGltZSBvbiB0aGUgYWxsb2MgLyBmcmVlIG9wZXJh
dGlvbnMgZG9uZSBieSB0aGUNCj4gPiA+IHlhdnRhIEluc3RhbmNlcyB0byBzZWUgd2hlcmUgdGhl
IHByb2JsZW0gY291bGQgYmUuDQo+ID4gPg0KPiA+ID4gVGhpcyBiZWxvdyBsaW5lIGRvZXNuJ3Qg
bWFrZSBzZW5zZSwgYXMgdGhlIGZyZWUgY2FsbCBmb3IgcGlkIDEyOTg2DQo+ID4gPiBvY2N1cnMg
Zmlyc3QsIGJlZm9yZSB0aGUgYWxsb2MgY2FsbHMuIFlhdnRhIGFwcGxpY2F0aW9uIGxvZ3MNCj4g
PiA+IGluZGljYXRlIHRoZSBkbWEgYWxsb2MgaGFzIGJlZW4gZG9uZSBmb3IgcGlkIDEyOTg2LCBh
bHRob3VnaCBJIGRvbid0IHNlZQ0KPiBjb3JyZXNwb25kaW5nIGRtYSBhbGxvYyBjYWxscyBmcm9t
IHBpZCAxMjk4Ni4NCj4gPg0KPiA+ICBJIHdvbmRlciBpZiB0aGF0IGRvZXNuJ3QgbWVhbiB0aGF0
IGZvciBzb21lIHJlYXNvbiBzb21lIFY0TDIgaW9jdGxzDQo+ID4gZG9uZSBmcm9tIGEgY29udGV4
dCBvdGhlciB0aGFuIHRoZSBvd25lciAodGhlIG9uZSB0aGF0IGZpcnN0IGFsbG9jYXRlZA0KPiA+
ICB2YjIgYnVmZmVycykgZW5kIHVwIHRyaWdnZXJpbmcgc29tZSBidWZmZXIgZnJlZWluZy9yZS1h
bGxvY2F0aW9uLiBGb3INCj4gPiAgVkIyIGJ1ZmZlcnMgdGhhdCdzIG5vcm1hbGx5IHByZXZlbnRl
ZCBieSB0aGUgY29yZSwgYnV0IHBvc3NpYmx5IHdlIGRvDQo+ID4gc29tZSBpbnRlcm5hbCBidWZm
ZXIgbWFuYWdlbWVudCBpbiBub24tYnVmZmVyIHJlbGF0ZWQgVjRMMiBpb2N0bHMgaW4NCj4gPiB0
aGUgZHJpdmVyPw0KPiANCj4gSSBoYWQgYSBxdWljayBsb29rIGF0IHRoZSBkcml2ZXIsIGFuZCBm
b3VuZCB0aGUgZm9sbG93aW5nIGNvZGUgaW4gdGhlDQo+IFZJRElPQ19TVFJFQU1PRkYgaGFuZGxl
ciBpcHUzX3ZiMl9zdG9wX3N0cmVhbWluZygpOg0KPiANCj4gICAgICAgICAvKiBXYXMgdGhpcyB0
aGUgZmlyc3Qgbm9kZSB3aXRoIHN0cmVhbWluZyBkaXNhYmxlZD8gKi8NCj4gICAgICAgICBpZiAo
aW1ndS0+c3RyZWFtaW5nICYmIGlwdTNfYWxsX25vZGVzX3N0cmVhbWluZyhpbWd1LCBub2RlKSkg
ew0KPiAgICAgICAgICAgICAgICAgLyogWWVzLCByZWFsbHkgc3RvcCBzdHJlYW1pbmcgbm93ICov
DQo+ICAgICAgICAgICAgICAgICBkZXZfZGJnKGRldiwgIklNR1Ugc3RyZWFtaW5nIGlzIHJlYWR5
IHRvIHN0b3AiKTsNCj4gICAgICAgICAgICAgICAgIHIgPSBpbWd1X3Nfc3RyZWFtKGltZ3UsIGZh
bHNlKTsNCj4gICAgICAgICAgICAgICAgIGlmICghcikNCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgaW1ndS0+c3RyZWFtaW5nID0gZmFsc2U7DQo+ICAgICAgICAgfQ0KPiANCj4gVGhlIHF1ZXVl
IGlzIGluaXRpYWxpemVkIGluIGlwdTNfdjRsMl9ub2RlX3NldHVwKCkgd2l0aA0KPiANCj4gICAg
ICAgICB2YnEtPmxvY2sgPSAmbm9kZS0+bG9jazsNCj4gDQo+IHdoaWNoIG1lYW5zIHRoYXQgY29u
Y3VycmVudCBWSURJT0NfU1RSRUFNT0ZGIG9wZXJhdGlvbnMgb24gZGlmZmVyZW50DQo+IG5vZGVz
IGNhbiByYWNlIGVhY2ggb3RoZXIuIENvdWxkIHlvdSBlbmFibGUgZHluYW1pYyBkZWJ1Z2dpbmcg
dG8gZ2V0IHRoZQ0KPiAiSU1HVSBzdHJlYW1pbmcgaXMgcmVhZHkgdG8gc3RvcCIgbWVzc2FnZSBw
cmludGVkIHRvIHRoZSBrZXJuZWwgbG9nLCBhbmQgc2VlIGlmDQo+IHRoaXMgY291bGQgZXhwbGFp
biB0aGUgZG91YmxlLWZyZWUgcHJvYmxlbSA/DQo+IA0KPiBJbiBhbnkgY2FzZSB0aGlzIHJhY2Ug
Y29uZGl0aW9uIHNob3VsZCBiZSBoYW5kbGVkIGJ5IHByb3BlciBsb2NraW5nLg0KPiBCb3RoIHRo
ZSBpbWd1LT5zdHJlYW1pbmcgYW5kIHRoZSBpcHUzX2FsbF9ub2Rlc19zdHJlYW1pbmcoKSB0ZXN0
cyBhcmUgdmVyeQ0KPiByYWN5LCBhbmQgY2FuIGxlYWQgdG8gbWFueSBkaWZmZXJlbnQgcHJvYmxl
bXMgKGZhaWx1cmUgYXQgcHJvY2Vzc2luZyBzdGFydCBhbHNvDQo+IGNvbWVzIHRvIG1pbmQpLg0K
PiANCg0KVGhhbmtzIGZvciB5b3VyIGlucHV0cy4NCg0KSSBoYXZlIGNvbmZpcm1lZCBzbyBmYXIg
dGhhdCBpcHUzX3ZiMl9zdG9wX3N0cmVhbWluZygpIGlzIGNhbGxlZCBmb3IgYWxsIDQgaW5zdGFu
Y2VzDQpvZiB5YXZ0YSBleGl0LCB3aGlsZSBpcHUzX3ZiMl9zdGFydF9zdHJlYW1pbmcoKSBpcyBj
YWxsZWQgZm9yIGp1c3Qgb25lIGluc3RhbmNlLiBUaGlzIGNhdXNlcw0KNCBmcmVlIG9wZXJhdGlv
bnMgZm9yIGEgc2luZ2xlIGFsbG9jLCByZXN1bHRpbmcgaW4gdGhpcyBmYWlsdXJlLg0KDQppcHUz
X3ZiMl9zdG9wX3N0cmVhbWluZygpIHNob3VsZCBiZSBkb25lIGp1c3Qgb25jZSwganVzdCBsaWtl
IGlwdTNfdmIyX3N0YXJ0X3N0cmVhbWluZygpLg0KaXB1M192YjJfc3RvcF9zdHJlYW1pbmcoKSBz
aG91bGQgYWxzbyBiZSBpbXByb3ZlZCBhIGJpdCB0byBoYW5kbGUgbXVsdGlwbGUgYXBwbGljYXRp
b25zIGhhbmRsaW5nDQphbGwgdGhlIG5vZGVzLg0KDQpMYXVyZW50J3MgZmluZGluZ3MgcG9pbnQg
dG8gdGhlIHNhbWUuDQoNCkxldCBtZSBnZXQgYmFjayBzb29uIHdpdGggbW9yZSBkZXRhaWxzLg0K
DQpbc25pcF0NCg==
