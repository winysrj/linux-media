Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D4FC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 16:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EA5B20645
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 16:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbfAOQDv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 11:03:51 -0500
Received: from mga12.intel.com ([192.55.52.136]:56602 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729599AbfAOQDv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 11:03:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2019 08:03:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,481,1539673200"; 
   d="scan'208";a="106787393"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga007.jf.intel.com with ESMTP; 15 Jan 2019 08:03:48 -0800
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 15 Jan 2019 08:03:49 -0800
Received: from orsmsx106.amr.corp.intel.com ([169.254.1.179]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.248]) with mapi id 14.03.0415.000;
 Tue, 15 Jan 2019 08:03:49 -0800
From:   "Zhi, Yong" <yong.zhi@intel.com>
To:     Tomasz Figa <tfiga@chromium.org>
CC:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
Subject: RE: [PATCH 2/2] media: ipu3-imgu: Remove dead code for NULL check
Thread-Topic: [PATCH 2/2] media: ipu3-imgu: Remove dead code for NULL check
Thread-Index: AQHUrIO0T71BRY2AwUqKke4xK28ECaWwVgmAgAAoAJA=
Date:   Tue, 15 Jan 2019 16:03:48 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DB53840@ORSMSX106.amr.corp.intel.com>
References: <1547523465-27807-1-git-send-email-yong.zhi@intel.com>
 <1547523465-27807-2-git-send-email-yong.zhi@intel.com>
 <CAAFQd5BZc33TkX_u5-vO_n13+73Ga5Pn+ERcFzTe4=HbPWRKXA@mail.gmail.com>
In-Reply-To: <CAAFQd5BZc33TkX_u5-vO_n13+73Ga5Pn+ERcFzTe4=HbPWRKXA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjRjZDdkZjMtNjFjNC00MTU2LWE3YjYtZjQ1YjQyYzBmZjAzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWUUyUEl1b2tqRXF0elN2TEdEbGZSekh6NzcwNHR2VjZMTmRuMDFHRndWVDN0TVVYRDNJSklabm8yQU52ODFMdiJ9
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGksIFRvbWFzeiwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBUb21h
c3ogRmlnYSBbbWFpbHRvOnRmaWdhQGNocm9taXVtLm9yZ10NCj4gU2VudDogTW9uZGF5LCBKYW51
YXJ5IDE0LCAyMDE5IDExOjM4IFBNDQo+IFRvOiBaaGksIFlvbmcgPHlvbmcuemhpQGludGVsLmNv
bT4NCj4gQ2M6IExpbnV4IE1lZGlhIE1haWxpbmcgTGlzdCA8bGludXgtbWVkaWFAdmdlci5rZXJu
ZWwub3JnPjsgU2FrYXJpIEFpbHVzDQo+IDxzYWthcmkuYWlsdXNAbGludXguaW50ZWwuY29tPjsg
TWFuaSwgUmFqbW9oYW4NCj4gPHJham1vaGFuLm1hbmlAaW50ZWwuY29tPjsgUWl1LCBUaWFuIFNo
dSA8dGlhbi5zaHUucWl1QGludGVsLmNvbT47DQo+IExhdXJlbnQgUGluY2hhcnQgPGxhdXJlbnQu
cGluY2hhcnRAaWRlYXNvbmJvYXJkLmNvbT47IEhhbnMgVmVya3VpbA0KPiA8aGFucy52ZXJrdWls
QGNpc2NvLmNvbT47IE1hdXJvIENhcnZhbGhvIENoZWhhYiA8bWNoZWhhYkBrZXJuZWwub3JnPjsN
Cj4gQ2FvLCBCaW5nYnUgPGJpbmdidS5jYW9AaW50ZWwuY29tPjsgZGFuLmNhcnBlbnRlckBvcmFj
bGUuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMi8yXSBtZWRpYTogaXB1My1pbWd1OiBSZW1v
dmUgZGVhZCBjb2RlIGZvciBOVUxMDQo+IGNoZWNrDQo+IA0KPiBIaSBZb25nLA0KPiANCj4gT24g
VHVlLCBKYW4gMTUsIDIwMTkgYXQgMTI6MzggUE0gWW9uZyBaaGkgPHlvbmcuemhpQGludGVsLmNv
bT4gd3JvdGU6DQo+ID4NCj4gPiBTaW5jZSBpcHUzX2Nzc19idWZfZGVxdWV1ZSgpIG5ldmVyIHJl
dHVybnMgTlVMTCwgcmVtb3ZlIHRoZSBkZWFkIGNvZGUNCj4gPiB0byBmaXggc3RhdGljIGNoZWNr
ZXIgd2FybmluZzoNCj4gPg0KPiA+IGRyaXZlcnMvc3RhZ2luZy9tZWRpYS9pcHUzL2lwdTMuYzo0
OTMgaW1ndV9pc3JfdGhyZWFkZWQoKQ0KPiA+IHdhcm46ICdiJyBpcyBhbiBlcnJvciBwb2ludGVy
IG9yIHZhbGlkDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZb25nIFpoaSA8eW9uZy56aGlAaW50
ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IExpbmsgdG8gRGFuJ3MgYnVnIHJlcG9ydDoNCj4gPiBodHRw
czovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51eC1tZWRpYS9tc2cxNDUwNDMuaHRtbA0KPiAN
Cj4gWW91IGNhbiBhZGQgRGFuJ3MgUmVwb3J0ZWQtYnkgYWJvdmUgeW91ciBTaWduZWQtb2ZmLWJ5
IHRvIHByb3Blcmx5IGNyZWRpdA0KPiBoaW0uIEknZCBhbHNvIGFkZCBhIGNvbW1lbnQgYmVsb3cg
dGhhdCBSZXBvcnRlZC1ieSwgZS5nLg0KPiANCj4gW0J1ZyByZXBvcnQ6IGh0dHBzOi8vd3d3LnNw
aW5pY3MubmV0L2xpc3RzL2xpbnV4LW1lZGlhL21zZzE0NTA0My5odG1sXQ0KPiANCj4gc28gdGhh
dCBpdCBkb2Vzbid0IGdldCByZW1vdmVkIHdoZW4gYXBwbHlpbmcgdGhlIHBhdGNoLCBhcyBpdCB3
b3VsZCBnZXQgbm93LA0KPiBiZWNhdXNlIGFueSB0ZXh0IHJpZ2h0IGluIHRoaXMgYXJlYSBpcyBp
Z25vcmVkIGJ5IGdpdC4NCj4gDQo+IFdpdGggdGhhdCBmaXhlcywgZmVlbCBmcmVlIHRvIGFkZCBt
eSBSZXZpZXdlZC1ieS4NCg0KVGhhbmtzIGEgbG90IGZvciB0aGUgZGV0YWlsZWQgaW5zdHJ1Y3Rp
b25zIDopDQoNCj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gVG9tYXN6DQo+IA0KPiA+DQo+ID4gIGRy
aXZlcnMvc3RhZ2luZy9tZWRpYS9pcHUzL2lwdTMuYyB8IDExICsrKysrLS0tLS0tDQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL21lZGlhL2lwdTMvaXB1My5jDQo+ID4gYi9kcml2
ZXJzL3N0YWdpbmcvbWVkaWEvaXB1My9pcHUzLmMNCj4gPiBpbmRleCBkNTIxYjNhZmI4YjEuLjgz
OWQ5Mzk4ZjhlOSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3N0YWdpbmcvbWVkaWEvaXB1My9p
cHUzLmMNCj4gPiArKysgYi9kcml2ZXJzL3N0YWdpbmcvbWVkaWEvaXB1My9pcHUzLmMNCj4gPiBA
QCAtNDg5LDEyICs0ODksMTEgQEAgc3RhdGljIGlycXJldHVybl90IGltZ3VfaXNyX3RocmVhZGVk
KGludCBpcnEsIHZvaWQNCj4gKmltZ3VfcHRyKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAg
IG11dGV4X3VubG9jaygmaW1ndS0+bG9jayk7DQo+ID4gICAgICAgICAgICAgICAgIH0gd2hpbGUg
KFBUUl9FUlIoYikgPT0gLUVBR0FJTik7DQo+ID4NCj4gPiAtICAgICAgICAgICAgICAgaWYgKElT
X0VSUl9PUl9OVUxMKGIpKSB7DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgaWYgKCFiIHx8
IFBUUl9FUlIoYikgPT0gLUVCVVNZKSAvKiBBbGwgZG9uZSAqLw0KPiA+IC0gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgZGV2
X2VycigmaW1ndS0+cGNpX2Rldi0+ZGV2LA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgImZhaWxlZCB0byBkZXF1ZXVlIGJ1ZmZlcnMgKCVsZClcbiIsDQo+ID4gLSAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBQVFJfRVJSKGIpKTsNCj4gPiArICAgICAgICAgICAgICAg
aWYgKElTX0VSUihiKSkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGlmIChQVFJfRVJS
KGIpICE9IC1FQlVTWSkgICAgICAgLyogQWxsIGRvbmUgKi8NCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGRldl9lcnIoJmltZ3UtPnBjaV9kZXYtPmRldiwNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImZhaWxlZCB0byBkZXF1ZXVlIGJ1ZmZl
cnMgKCVsZClcbiIsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IFBUUl9FUlIoYikpOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICAg
ICAgICAgICAgICAgICB9DQo+ID4NCj4gPiAtLQ0KPiA+IDIuNy40DQo+ID4NCg==
