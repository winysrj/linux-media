Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D585AC282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 21:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F22320866
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 21:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfAVVqm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 16:46:42 -0500
Received: from mga05.intel.com ([192.55.52.43]:41765 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfAVVqm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 16:46:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 13:46:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,508,1539673200"; 
   d="scan'208";a="127757861"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jan 2019 13:46:42 -0800
Received: from orsmsx112.amr.corp.intel.com (10.22.240.13) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 22 Jan 2019 13:46:41 -0800
Received: from orsmsx106.amr.corp.intel.com ([169.254.1.54]) by
 ORSMSX112.amr.corp.intel.com ([169.254.3.62]) with mapi id 14.03.0415.000;
 Tue, 22 Jan 2019 13:46:41 -0800
From:   "Zhi, Yong" <yong.zhi@intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH v8 15/17] media: v4l: Add Intel IPU3 meta buffer formats
Thread-Topic: [PATCH v8 15/17] media: v4l: Add Intel IPU3 meta buffer formats
Thread-Index: AQHUjcjiu26CCKyCXUOnsfGXsr8nLaV6DRAAgC72FVCAE5iMAP//fZYQ
Date:   Tue, 22 Jan 2019 21:46:40 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DB5489B@ORSMSX106.amr.corp.intel.com>
References: <1544144622-29791-1-git-send-email-yong.zhi@intel.com>
 <1544144622-29791-16-git-send-email-yong.zhi@intel.com>
 <2743727.5LazzqFdDF@avalon>
 <C193D76D23A22742993887E6D207B54D3DB52FDB@ORSMSX106.amr.corp.intel.com>
 <20190122212228.GM3264@pendragon.ideasonboard.com>
In-Reply-To: <20190122212228.GM3264@pendragon.ideasonboard.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjM4ZDI4ZWYtMmI4YS00NmM0LTkzYWMtZmFkOTBmODZlZmEwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicTd4ME42VmpJdXA4dWlMY3VSYWtnQ3ZqUUE1aUlPYWNkdjdmSFlXbDhmd1NKeGI5NU15VVA2bEZQSXlEWk9qMCJ9
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGksIExhdXJlbnQsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGF1
cmVudCBQaW5jaGFydCBbbWFpbHRvOmxhdXJlbnQucGluY2hhcnRAaWRlYXNvbmJvYXJkLmNvbV0N
Cj4gU2VudDogVHVlc2RheSwgSmFudWFyeSAyMiwgMjAxOSAxOjIyIFBNDQo+IFRvOiBaaGksIFlv
bmcgPHlvbmcuemhpQGludGVsLmNvbT4NCj4gQ2M6IGxpbnV4LW1lZGlhQHZnZXIua2VybmVsLm9y
Zzsgc2FrYXJpLmFpbHVzQGxpbnV4LmludGVsLmNvbTsNCj4gdGZpZ2FAY2hyb21pdW0ub3JnOyBN
YW5pLCBSYWptb2hhbiA8cmFqbW9oYW4ubWFuaUBpbnRlbC5jb20+Ow0KPiBUb2l2b25lbiwgVHV1
a2thIDx0dXVra2EudG9pdm9uZW5AaW50ZWwuY29tPjsgSHUsIEplcnJ5IFcNCj4gPGplcnJ5Lncu
aHVAaW50ZWwuY29tPjsgUWl1LCBUaWFuIFNodSA8dGlhbi5zaHUucWl1QGludGVsLmNvbT47DQo+
IGhhbnMudmVya3VpbEBjaXNjby5jb207IG1jaGVoYWJAa2VybmVsLm9yZzsgQ2FvLCBCaW5nYnUN
Cj4gPGJpbmdidS5jYW9AaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY4IDE1LzE3
XSBtZWRpYTogdjRsOiBBZGQgSW50ZWwgSVBVMyBtZXRhIGJ1ZmZlciBmb3JtYXRzDQo+IA0KPiBI
aSBZb25nLA0KPiANCj4gT24gVGh1LCBKYW4gMTAsIDIwMTkgYXQgMDY6MzU6MTFQTSArMDAwMCwg
WmhpLCBZb25nIHdyb3RlOg0KPiA+IE9uIFR1ZXNkYXksIERlY2VtYmVyIDExLCAyMDE4IDY6NTkg
QU0sIExhdXJlbnQgUGluY2hhcnQgd3JvdGU6DQo+ID4gPiBPbiBGcmlkYXksIDcgRGVjZW1iZXIg
MjAxOCAwMzowMzo0MCBFRVQgWW9uZyBaaGkgd3JvdGU6DQo+ID4gPj4gQWRkIElQVTMtc3BlY2lm
aWMgbWV0YSBmb3JtYXRzIGZvciBwcm9jZXNzaW5nIHBhcmFtZXRlcnMgYW5kIDNBDQo+ID4gPj4g
c3RhdGlzdGljcy4NCj4gPiA+Pg0KPiA+ID4+ICAgVjRMMl9NRVRBX0ZNVF9JUFUzX1BBUkFNUw0K
PiA+ID4+ICAgVjRMMl9NRVRBX0ZNVF9JUFUzX1NUQVRfM0ENCj4gPiA+Pg0KPiA+ID4+IFNpZ25l
ZC1vZmYtYnk6IFlvbmcgWmhpIDx5b25nLnpoaUBpbnRlbC5jb20+DQo+ID4gPj4gUmV2aWV3ZWQt
Ynk6IExhdXJlbnQgUGluY2hhcnQgPGxhdXJlbnQucGluY2hhcnRAaWRlYXNvbmJvYXJkLmNvbT4N
Cj4gPiA+DQo+ID4gPiBNeSBSZXZpZXdlZC1ieSB0YWcgd2FzIHJlbGF0ZWQgdG8gdGhlIGZvcm1h
dCBwYXJ0IG9ubHkgKHY0bDItaW9jdGwuYw0KPiA+ID4gYW5kDQo+ID4gPiB2aWRlb2RldjIuaCkg
Oi0pIFBsZWFzZSBzZWUgYmVsb3cgZm9yIG1vcmUgY29tbWVudHMgYWJvdXQgdGhlDQo+ID4gPiBk
b2N1bWVudGF0aW9uLg0KPiA+ID4NCj4gPiA+PiAtLS0NCj4gPiA+PiAgRG9jdW1lbnRhdGlvbi9t
ZWRpYS91YXBpL3Y0bC9tZXRhLWZvcm1hdHMucnN0ICAgICAgfCAgIDEgKw0KPiA+ID4+ICAuLi4v
bWVkaWEvdWFwaS92NGwvcGl4Zm10LW1ldGEtaW50ZWwtaXB1My5yc3QgICAgICB8IDE3OA0KPiAr
KysrKysrKysrKysrKysrKysNCj4gPiA+PiAgZHJpdmVycy9tZWRpYS92NGwyLWNvcmUvdjRsMi1p
b2N0bC5jICAgICAgICAgICAgICAgfCAgIDIgKw0KPiA+ID4+ICBpbmNsdWRlL3VhcGkvbGludXgv
dmlkZW9kZXYyLmggICAgICAgICAgICAgICAgICAgICB8ICAgNCArDQo+ID4gPj4gIDQgZmlsZXMg
Y2hhbmdlZCwgMTg1IGluc2VydGlvbnMoKykgIGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiA+ID4+IERv
Y3VtZW50YXRpb24vbWVkaWEvdWFwaS92NGwvcGl4Zm10LW1ldGEtaW50ZWwtaXB1My5yc3QNCj4g
DQo+IFtzbmlwXQ0KPiANCj4gPiA+PiBkaWZmIC0tZ2l0DQo+ID4gPj4gYS9Eb2N1bWVudGF0aW9u
L21lZGlhL3VhcGkvdjRsL3BpeGZtdC1tZXRhLWludGVsLWlwdTMucnN0DQo+ID4gPj4gYi9Eb2N1
bWVudGF0aW9uL21lZGlhL3VhcGkvdjRsL3BpeGZtdC1tZXRhLWludGVsLWlwdTMucnN0IG5ldyBm
aWxlDQo+ID4gPj4gbW9kZQ0KPiA+ID4+IDEwMDY0NA0KPiA+ID4+IGluZGV4IDAwMDAwMDAwMDAw
MC4uOGNkMzBmZmJmOGI4DQo+ID4gPj4gLS0tIC9kZXYvbnVsbA0KPiA+ID4+ICsrKyBiL0RvY3Vt
ZW50YXRpb24vbWVkaWEvdWFwaS92NGwvcGl4Zm10LW1ldGEtaW50ZWwtaXB1My5yc3QNCj4gDQo+
IFtzbmlwXQ0KPiANCj4gPiA+PiArc3RydWN0IDpjOnR5cGU6YGlwdTNfdWFwaV80YV9jb25maWdg
IHNhdmVzIGNvbmZpZ3VyYWJsZSBwYXJhbWV0ZXJzDQo+ID4gPj4gK2ZvciBhbGwNCj4gPiA+PiBh
Ym92ZS4NCj4gPiA+DQo+ID4gPiBJIHdvdWxkIHdyaXRlIGl0IGFzICJUaGUNCj4gPiA+DQo+ID4g
PiBCeSB0aGUgd2F5IHdoeSAiNGEiIHdoZW4gdGhlIGRvY3VtZW50YXRpb24gdGFsa3MgYWJvdXQg
M0EgPw0KPiA+ID4gU2hvdWxkbid0IHRoZSBzdHJ1Y3R1cmUgYmUgY2FsbGVkIGlwdTNfdWFwaV8z
YV9jb25maWcgPw0KPiA+ID4NCj4gPg0KPiA+IFRoZSA0dGggImEiIHJlZmVycyB0byB0aGUgQVdC
IGZpbHRlciByZXNwb25zZSBjb25maWcuDQo+IA0KPiBCdXQgdGhlIGF1dG9tYXRpYyBhbGdvcml0
aG1zIGFyZSBzdGlsbCBhdXRvbWF0aWMgd2hpdGUgYmFsYW5jZSwgYXV0b21hdGljDQo+IGV4cG9z
dXJlIGFuZCBhdXRvbWF0aWMgZm9jdXMsIHJpZ2h0LCB3aXRoIGlwdTNfdWFwaV9hd2JfZnJfcmF3
X2J1ZmZlcg0KPiBiZWluZyBwYXJ0IG9mIEFXQiwgcmlnaHQgPw0KPiANCg0KVGhhdCdzIHJpZ2h0
LCB3ZSBzdGlsbCBjYWxsIGl0IGlwdTNfdWFwaV9zdGF0c18zYSBpbnN0ZWFkIG9mIGlwdTNfdWFw
aV9zdGF0c180YS4NCkkgaGF2ZSBubyBwcm9ibGVtIHRvIHJlbmFtZSBpcHUzX3VhcGlfNGFfY29u
ZmlnIHRvIGlwdTNfdWFwaV8zYV9jb25maWcuDQoNCkkgY2FuIHJlc2VuZCB0aGUgcGF0Y2ggd2l0
aCB0aGlzIHVwZGF0ZSBpZiBubyBvbmUgb3Bwb3NlcywgdGhhbmtzISENCg0KPiA+ID4+ICsNCj4g
PiA+PiArLi4gY29kZS1ibG9jazo6IGMNCj4gPiA+PiArDQo+ID4gPj4gKwlzdHJ1Y3QgaXB1M191
YXBpX3N0YXRzXzNhIHsNCj4gPiA+PiArCQlzdHJ1Y3QgaXB1M191YXBpX2F3Yl9yYXdfYnVmZmVy
IGF3Yl9yYXdfYnVmZmVyOw0KPiA+ID4+ICsJCXN0cnVjdCBpcHUzX3VhcGlfYWVfcmF3X2J1ZmZl
cl9hbGlnbmVkDQo+ID4gPj4gYWVfcmF3X2J1ZmZlcltJUFUzX1VBUElfTUFYX1NUUklQRVNdOw0K
PiA+ID4+ICsJCXN0cnVjdCBpcHUzX3VhcGlfYWZfcmF3X2J1ZmZlcg0KPiA+ID4+IGFmX3Jhd19i
dWZmZXI7DQo+ID4gPj4gKwkJc3RydWN0IGlwdTNfdWFwaV9hd2JfZnJfcmF3X2J1ZmZlciBhd2Jf
ZnJfcmF3X2J1ZmZlcjsNCj4gPiA+PiArCQlzdHJ1Y3QgaXB1M191YXBpXzRhX2NvbmZpZyBzdGF0
c180YV9jb25maWc7DQo+ID4gPj4gKwkJX191MzIgYWVfam9pbl9idWZmZXJzOw0KPiA+ID4+ICsJ
CV9fdTggcGFkZGluZ1syOF07DQo+ID4gPj4gKwkJc3RydWN0IGlwdTNfdWFwaV9zdGF0c18zYV9i
dWJibGVfaW5mb19wZXJfc3RyaXBlDQo+ID4gPj4gc3RhdHNfM2FfYnViYmxlX3Blcl9zdHJpcGU7
DQo+ID4gPj4gKwkJc3RydWN0IGlwdTNfdWFwaV9mZl9zdGF0dXMgc3RhdHNfM2Ffc3RhdHVzOw0K
PiA+ID4+ICsJfTsNCj4gPiA+Pg0KPiA+ID4+ICsuLiBjOnR5cGU6OiBpcHUzX3VhcGlfcGFyYW1z
DQo+IA0KPiBbc25pcF0NCj4gDQo+IC0tDQo+IFJlZ2FyZHMsDQo+IA0KPiBMYXVyZW50IFBpbmNo
YXJ0DQo=
