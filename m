Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664F3C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3785C20685
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfAISBl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:01:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:6093 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbfAISBl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 13:01:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2019 10:01:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,458,1539673200"; 
   d="scan'208";a="265808960"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga004.jf.intel.com with ESMTP; 09 Jan 2019 10:01:39 -0800
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 9 Jan 2019 10:01:39 -0800
Received: from fmsmsx122.amr.corp.intel.com ([169.254.5.2]) by
 FMSMSX102.amr.corp.intel.com ([169.254.10.43]) with mapi id 14.03.0415.000;
 Wed, 9 Jan 2019 10:01:39 -0800
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
Thread-Index: AQHUb9aJ2xONOQn66UKjxJluMlyZrqVnikaAgABWAwCAADMOAP//erHggAdi27CAAJYyAP//fHuAgAB6QuCAClF3t4AAkIyAgAdn3wCAB0R8AIAATewAgByKWQCAAjYSgP//e7oQABIdloAAD6nxkA==
Date:   Wed, 9 Jan 2019 18:01:39 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A599B3215DA@fmsmsx122.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1819843.KIqgResAvh@avalon> <2135468.G1bK1392oW@avalon>
 <3475971.piroVKfGO7@avalon>
 <CAAFQd5CN3dhTviSnFbzSOjkMTQqUyOajYv+CVxSLLAih522CgQ@mail.gmail.com>
 <CAAFQd5AWLi=UD+LtuiQdc5QD8v5B1WX0Jcoe6=QUy+392FSeng@mail.gmail.com>
 <20190109164037.yvtluixvua7cm2tl@uno.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A599B321599@fmsmsx122.amr.corp.intel.com>
 <20190109172553.lrnwxuy3x4drk6af@uno.localdomain>
In-Reply-To: <20190109172553.lrnwxuy3x4drk6af@uno.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNGQ1Y2E4NDctNzdlNi00YzU4LTk0OWQtYzEzNWVhN2RiZjVmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTHdkT1wvMWJhSGZCaFQ3aTZ1MVFXaW5DdXJzMEdTWWJOSmIwanpXVnhoWHlPck5TOVI0VlwvSzlrVVBRQUdtenJVIn0=
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgSmFjb3BvLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjcgMDAvMTZdIEludGVsIElQVTMg
SW1nVSBwYXRjaHNldA0KPiANCj4gSGVsbG8gUmFqLA0KPiANCj4gT24gV2VkLCBKYW4gMDksIDIw
MTkgYXQgMDU6MDA6MjFQTSArMDAwMCwgTWFuaSwgUmFqbW9oYW4gd3JvdGU6DQo+ID4gSGkgTGF1
cmVudCwgVG9tYXN6LCBKYWNvcG8sDQo+ID4NCj4gPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjcg
MDAvMTZdIEludGVsIElQVTMgSW1nVSBwYXRjaHNldA0KPiA+ID4NCj4gPiA+IEhlbGxvLA0KPiA+
ID4NCj4gPiA+IE9uIFR1ZSwgSmFuIDA4LCAyMDE5IGF0IDAzOjU0OjM0UE0gKzA5MDAsIFRvbWFz
eiBGaWdhIHdyb3RlOg0KPiA+ID4gPiBIaSBSYWosIFlvbmcsIEJpbmdidSwgVGlhbnNodSwNCj4g
PiA+ID4NCj4gPiA+ID4gT24gRnJpLCBEZWMgMjEsIDIwMTggYXQgMTI6MDQgUE0gVG9tYXN6IEZp
Z2EgPHRmaWdhQGNocm9taXVtLm9yZz4NCj4gd3JvdGU6DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBP
biBGcmksIERlYyAyMSwgMjAxOCBhdCA3OjI0IEFNIExhdXJlbnQgUGluY2hhcnQNCj4gPiA+ID4g
PiA8bGF1cmVudC5waW5jaGFydEBpZGVhc29uYm9hcmQuY29tPiB3cm90ZToNCj4gPiA+ID4gPiA+
DQo+ID4gPiA+ID4gPiBIZWxsb24NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBPbiBTdW5kYXks
IDE2IERlY2VtYmVyIDIwMTggMDk6MjY6MTggRUVUIExhdXJlbnQgUGluY2hhcnQgd3JvdGU6DQo+
ID4gPiA+ID4gPiA+IEhlbGxvIFlvbmcsDQo+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+IENv
dWxkIHlvdSBwbGVhc2UgaGF2ZSBhIGxvb2sgYXQgdGhlIGNyYXNoIHJlcG9ydGVkIGJlbG93ID8N
Cj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBBIGJpdCBtb3JlIGluZm9ybWF0aW9uIHRvIGhlbHAg
eW91IGRlYnVnZ2luZyB0aGlzLiBJJ3ZlDQo+ID4gPiA+ID4gPiBlbmFibGVkIEtBU0FOIGluIHRo
ZSBrZXJuZWwgY29uZmlndXJhdGlvbiwgYW5kIGdldCB0aGUNCj4gPiA+ID4gPiA+IGZvbGxvd2lu
ZyB1c2UtYWZ0ZXItZnJlZQ0KPiA+ID4gcmVwb3J0cy4NCj4gPiA+DQo+ID4gPiBJIHRlc3RlZCBh
cyB3ZWxsIHVzaW5nIHRoZSBpcHUtcHJvY2Vzcy5zaCBzY3JpcHQgc2hhcmVkIGJ5IExhdXJlbnQs
DQo+ID4gPiB3aXRoIHRoZSBmb2xsb3dpbmcgY29tbWFuZCBsaW5lOg0KPiA+ID4gLi9pcHUzLXBy
b2Nlc3Muc2ggLS1vdXQgMjU2MHgxOTIwIC0tdmYgMTkyMHgxMDgwDQo+ID4gPiBmcmFtZS0yNTky
eDE5NDQuY2lvMg0KPiA+ID4NCj4gPiA+IGFuZCBJIGdvdCBhIHZlcnkgc2ltaWxhciB0cmFjZSBh
dmFpbGFibGUgYXQ6DQo+ID4gPiBodHRwczovL3Bhc3RlLmRlYmlhbi5uZXQvaGlkZGVuLzU4NTVl
MTVhLw0KPiA+ID4NCj4gPiA+IFBsZWFzZSBub3RlIEkgaGF2ZSBiZWVuIGFibGUgdG8gcHJvY2Vz
cyBhIHNldCBvZiBpbWFnZXMgKHdpdGggS0FTQU4NCj4gPiA+IGVuYWJsZWQgdGhlIG1hY2hpbmUg
ZG9lcyBub3QgZnJlZXplKSBidXQgdGhlIGtlcm5lbCBsb2cgZ2V0cyBmbG9vZGVkDQo+ID4gPiBh
bmQgaXQgaXMgbm90IHBvc3NpYmxlIHRvIHByb2Nlc3MgYW55IG90aGVyIGZyYW1lIGFmdGVyIHRo
aXMuDQo+ID4gPg0KPiA+ID4gVGhlIGlzc3VlIGlzIGN1cnJlbnRseSBxdWl0ZSBhbm5veWluZyBh
bmQgaXQncyBhIGJsb2NrZXIgZm9yDQo+ID4gPiBsaWJjYW1lcmEgZGV2ZWxvcG1lbnQgb24gSVBV
My4gUGxlYXNlIGxldCBtZSBrbm93IGlmIEkgY2FuIHN1cHBvcnQgd2l0aA0KPiBtb3JlIHRlc3Rp
bmcuDQo+ID4gPg0KPiA+ID4gVGhhbmtzDQo+ID4gPiAgICBqDQo+ID4gPg0KPiA+ID4gPiA+ID4N
Cj4gPiA+ID4gPiA+IFsgIDE2Ni4zMzI5MjBdDQo+ID4gPiA+ID4gPg0KPiA+ID4NCj4gPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQ0KPiA+ID4gPT0NCj4gPiA+ID4gPiA+IFsgIDE2Ni4zMzI5MzddIEJVRzogS0FTQU46IHVzZS1h
ZnRlci1mcmVlIGluDQo+ID4gPiA+ID4gPiBfX2NhY2hlZF9yYm5vZGVfZGVsZXRlX3VwZGF0ZSsw
eDM2LzB4MjAyDQo+ID4gPiA+ID4gPiBbICAxNjYuMzMyOTQ0XSBSZWFkIG9mIHNpemUgOCBhdCBh
ZGRyIGZmZmY4ODgxMzM4MjM3MTggYnkgdGFzaw0KPiA+ID4gPiA+ID4geWF2dGEvMTMwNQ0KPiA+
ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFsgIDE2Ni4zMzI5NTVdIENQVTogMyBQSUQ6IDEzMDUgQ29t
bTogeWF2dGEgVGFpbnRlZDogRyAgICAgICAgIEMNCj4gNC4yMC4wLQ0KPiA+ID4gcmM2KyAjMw0K
PiA+ID4gPiA+ID4gWyAgMTY2LjMzMjk1OF0gSGFyZHdhcmUgbmFtZTogSFAgU29yYWthL1NvcmFr
YSwgQklPUw0KPiA+ID4gPiA+ID4gMDgvMzAvMjAxOCBbIDE2Ni4zMzI5NTldIENhbGwgVHJhY2U6
DQo+ID4gPiA+ID4gPiBbICAxNjYuMzMyOTY3XSAgZHVtcF9zdGFjaysweDViLzB4ODEgWyAgMTY2
LjMzMjk3NF0NCj4gPiA+ID4gPiA+IHByaW50X2FkZHJlc3NfZGVzY3JpcHRpb24rMHg2NS8weDIy
Nw0KPiA+ID4gPiA+ID4gWyAgMTY2LjMzMjk3OV0gID8gX19jYWNoZWRfcmJub2RlX2RlbGV0ZV91
cGRhdGUrMHgzNi8weDIwMg0KPiA+ID4gPiA+ID4gWyAgMTY2LjMzMjk4M10gIGthc2FuX3JlcG9y
dCsweDI0Ny8weDI4NSBbICAxNjYuMzMyOTg5XQ0KPiA+ID4gPiA+ID4gX19jYWNoZWRfcmJub2Rl
X2RlbGV0ZV91cGRhdGUrMHgzNi8weDIwMg0KPiA+ID4gPiA+ID4gWyAgMTY2LjMzMjk5NV0gIHBy
aXZhdGVfZnJlZV9pb3ZhKzB4NTcvMHg2ZCBbICAxNjYuMzMyOTk5XQ0KPiA+ID4gPiA+ID4gX19m
cmVlX2lvdmErMHgyMy8weDMxIFsgIDE2Ni4zMzMwMTFdDQo+ID4gPiA+ID4gPiBpcHUzX2RtYW1h
cF9mcmVlKzB4MTE4LzB4MWQ2IFtpcHUzX2ltZ3VdDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGFu
a3MgTGF1cmVudCwgSSB0aGluayB0aGlzIGlzIGEgdmVyeSBnb29kIGhpbnQuIEl0IGxvb2tzIGxp
a2UNCj4gPiA+ID4gPiB3ZSdyZSBiYXNpY2FsbHkgZnJlZWluZyBhbmQgYWxyZWFkeSBmcmVlZCBJ
T1ZBIGFuZCBjb3JydXB0aW5nDQo+ID4gPiA+ID4gc29tZSBhbGxvY2F0b3Igc3RhdGU/DQo+ID4g
PiA+DQo+ID4gPiA+IERpZCB5b3UgaGF2ZSBhbnkgbHVjayBpbiByZXByb2R1Y2luZyBhbmQgZml4
aW5nIHRoaXMgZG91YmxlIGZyZWUgaXNzdWU/DQo+ID4gPiA+DQo+ID4NCj4gPiBUaGlzIGlzc3Vl
IGlzIGVpdGhlciBoYXJkIHRvIHJlcHJvZHVjZSBvciBjb21lcyB3aXRoIGRpZmZlcmVudA0KPiA+
IHNpZ25hdHVyZXMgd2l0aCB0aGUgdXBkYXRlZCB5YXZ0YSAodGhhdCBub3cgc3VwcG9ydHMgbWV0
YSBvdXRwdXQpIHdpdGgNCj4gPiB0aGUgNC40IGtlcm5lbCB0aGF0IEkgaGF2ZSBiZWVuIHVzaW5n
Lg0KPiA+IEkgYW0gc3dpdGNoaW5nIHRvIDQuMjAtcmM2IGZvciBiZXR0ZXIgcmVwcm9kdWNpYmls
aXR5Lg0KPiA+IEVuYWJsaW5nIEtBU0FOIGFsc28gcmVzdWx0cyBpbiBzdG9yYWdlIHNwYWNlIGlz
c3VlcyBvbiBteSBDaHJvbWUgZGV2aWNlLg0KPiA+IFdpbGwgZW5hYmxlIHRoaXMganVzdCBmb3Ig
SW1nVSB0byBnZXQgYWhlYWQgYW5kIGdldCBiYWNrIHdpdGggbW9yZSB1cGRhdGVzLg0KPiA+DQo+
IA0KPiBUaGFua3MgZm9yIHRlc3RpbmcgdGhpcy4NCj4gDQo+IEZvciB5b3VyIGluZm9ybWF0aW9u
cyBJJ20gdXNpbmcgdGhlIGZvbGxvd2luZyBicmFuY2gsIGZyb20gU2FrYXJpJ3MNCj4gdHJlZTog
Z2l0Oi8vbGludXh0di5vcmcvc2FpbHVzL21lZGlhX3RyZWUuZ2l0IGlwdTMNCj4gDQo+IEFsdGhv
dWdoIGl0IGFwcGVhcnMgdGhhdCB0aGUgbWVkaWEgdHJlZSBtYXN0ZXIgYnJhbmNoIGhhcyBldmVy
eXRoaW5nIHRoYXQgaXMNCj4gdGhlcmUsIHdpdGggYSBmZXcgYWRkaXRpb25hbCBwYXRjaGVzIG9u
IHRvcC4gSSBzaG91bGQgbW92ZSB0byB1c2UgbWVkaWEgdHJlZQ0KPiBtYXN0ZXIgYXMgd2VsbC4u
Lg0KPiANCj4gSSBoYXZlIGhlcmUgYXR0YWNoZWQgMiBjb25maWd1cmF0aW9uIGZpbGVzIGZvciB2
NC4yMC1yYzUgSSBhbSB1c2luZyBvbiBTb3Jha2EsIGluDQo+IGNhc2UgdGhleSBtaWdodCBoZWxw
IHlvdS4gT25lIGhhcyBLQVNBTiBlbmFibGVkIHdpdGggYW4gaW5jcmVhc2VkIGtlcm5lbA0KPiBs
b2cgc2l6ZSwgdGhlIG90aGVyIG9uZSBpcyB0aGUgb25lIHdlIHVzZSBmb3IgZGFpbHkgZGV2ZWxv
cG1lbnQuDQoNCkkgdGhpbmsgSSBhbSBtaXNzaW5nIGEgdHJpY2sgaGVyZSB0byBvdmVycmlkZSB0
aGUgZGVmYXVsdCBjaHJvbWUgb3Mga2VybmVsDQpjb25maWcgd2l0aCB0aGUgb25lIHRoYXQgeW91
IHN1cHBsaWVkLg0KDQpJbiBwYXJ0aWN1bGFyIEkgYW0gbG9va2luZyBmb3Igc3RlcHMgdG8gYnVp
bGQgdGhlIHVwc3RyZWFtIGtlcm5lbCB3aXRoaW4gY2hyb21lIG9zDQpidWlsZCBlbnZpcm9ubWVu
dCB1c2luZyB5b3VyIGNvbmZpZywgc28gSSBjYW4gdXBkYXRlIG15IFNvcmFrYSBkZXZpY2UuDQoN
Cj4gDQo+IEFsc28sIHBsZWFzZSBtYWtlIHN1cmUgdG8gdXNlICh0aGUgbW9zdCkgcmVjZW50IG1l
ZGlhLWN0bCBhbmQgeWF2dGEgdXRpbGl0aWVzLCBhcw0KPiB0aGUgb25lcyBwcm92aWRlZCBieSBt
b3N0IGRpc3Ryb3MgYXJlIHVzdWFsbHkgbm90IHJlY2VudCBlbm91Z2ggdG8gd29yayB3aXRoDQo+
IElQVTMsIGJ1dCBJJ20gc3VyZSB5b3Uga25vdyB0aGF0IGFscmVhZHkgOykNCg0KQWNrDQoNCj4g
DQo+IFRoYW5rcw0KPiAgIGoNCj4gDQoNCltzbmlwXQ0K
