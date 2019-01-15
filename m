Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D7FC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 05:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B982620859
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 05:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfAOFST (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 00:18:19 -0500
Received: from mga07.intel.com ([134.134.136.100]:27880 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbfAOFST (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 00:18:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2019 21:18:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,480,1539673200"; 
   d="scan'208";a="116813160"
Received: from pgsmsx113.gar.corp.intel.com ([10.108.55.202])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jan 2019 21:18:17 -0800
Received: from pgsmsx111.gar.corp.intel.com ([169.254.2.23]) by
 pgsmsx113.gar.corp.intel.com ([169.254.6.94]) with mapi id 14.03.0415.000;
 Tue, 15 Jan 2019 13:18:16 +0800
From:   "Yeh, Andy" <andy.yeh@intel.com>
To:     "Kao, Ben" <ben.kao@intel.com>, "Tu, ShawnX" <shawnx.tu@intel.com>
CC:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: RE: [PATCH v2] media: ov8856: Add support for OV8856 sensor
Thread-Topic: [PATCH v2] media: ov8856: Add support for OV8856 sensor
Thread-Index: AQHUqVt4PvdFDufmy0OcvM0Aqycv/KWvKl4AgAClVQA=
Date:   Tue, 15 Jan 2019 05:18:15 +0000
Deferred-Delivery: Tue, 15 Jan 2019 05:17:28 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D883FA5@PGSMSX111.gar.corp.intel.com>
References: <1547176516-18074-1-git-send-email-ben.kao@intel.com>
 <CAAFQd5B1nkEDou9Jj78sMnB-pc+qx-76i8hk0mdb-sjj6TkCfw@mail.gmail.com>
In-Reply-To: <CAAFQd5B1nkEDou9Jj78sMnB-pc+qx-76i8hk0mdb-sjj6TkCfw@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzk4OGZkMjktNGIzNy00ZjQ1LThmNzgtMjYwODRjNTI0NjUxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicFV6Rjl4TlZKRmdyQ2hyTGdNdVZQVFwvSFM0VHI3aHYrWHVLWVh6a05lVDdZTWxiVjR6azJmVUk2RTJUOWdSeTUifQ==
x-ctpclassification: CTP_NT
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgQmVuLA0KDQpZb3UgYXJlIHJlZmVycmluZyB0byBvbGRlciB0eXBlIG9mIHNlbnNvciBpMmMg
Y29udHJvbC4gWW91IGNhbiByZWZlciB0byBJTVgyNTggZHJpdmVyLiAgDQpkcml2ZXJzL21lZGlh
L2kyYy9pbXgyNTguYw0KDQovKiBXcml0ZSByZWdpc3RlcnMgdXAgdG8gMiBhdCBhIHRpbWUgKi8N
CnN0YXRpYyBpbnQgaW14MjU4X3dyaXRlX3JlZyhzdHJ1Y3QgaW14MjU4ICppbXgyNTgsIHUxNiBy
ZWcsIHUzMiBsZW4sIHUzMiB2YWwpDQp7DQogICAgICAgIHN0cnVjdCBpMmNfY2xpZW50ICpjbGll
bnQgPSB2NGwyX2dldF9zdWJkZXZkYXRhKCZpbXgyNTgtPnNkKTsNCiAgICAgICAgdTggYnVmWzZd
Ow0KDQogICAgICAgIGlmIChsZW4gPiA0KQ0KICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFM
Ow0KDQogICAgICAgIHB1dF91bmFsaWduZWRfYmUxNihyZWcsIGJ1Zik7DQogICAgICAgIHB1dF91
bmFsaWduZWRfYmUzMih2YWwgPDwgKDggKiAoNCAtIGxlbikpLCBidWYgKyAyKTsNCiAgICAgICAg
aWYgKGkyY19tYXN0ZXJfc2VuZChjbGllbnQsIGJ1ZiwgbGVuICsgMikgIT0gbGVuICsgMikNCiAg
ICAgICAgICAgICAgICByZXR1cm4gLUVJTzsNCg0KICAgICAgICByZXR1cm4gMDsNCn0NCg0KUmVn
YXJkcywgQW5keQ0KDQo+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj5Gcm9tOiBUb21hc3og
RmlnYSBbbWFpbHRvOnRmaWdhQGNocm9taXVtLm9yZ10NCj5TZW50OiBUdWVzZGF5LCBKYW51YXJ5
IDE1LCAyMDE5IDExOjIzIEFNDQo+VG86IEthbywgQmVuIDxiZW4ua2FvQGludGVsLmNvbT4NCj5D
YzogTGludXggTWVkaWEgTWFpbGluZyBMaXN0IDxsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmc+
OyBTYWthcmkgQWlsdXMNCj48c2FrYXJpLmFpbHVzQGxpbnV4LmludGVsLmNvbT47IFllaCwgQW5k
eSA8YW5keS55ZWhAaW50ZWwuY29tPg0KPlN1YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIG1lZGlhOiBv
djg4NTY6IEFkZCBzdXBwb3J0IGZvciBPVjg4NTYgc2Vuc29yDQo+DQo+SGkgQmVuLA0KPg0KPk9u
IEZyaSwgSmFuIDExLCAyMDE5IGF0IDEyOjEyIFBNIEJlbiBLYW8gPGJlbi5rYW9AaW50ZWwuY29t
PiB3cm90ZToNCj4+DQo+PiBUaGlzIHBhdGNoIGFkZHMgZHJpdmVyIGZvciBPbW5pdmlzaW9uJ3Mg
b3Y4ODU2IHNlbnNvciwgdGhlIGRyaXZlcg0KPj4gc3VwcG9ydHMgZm9sbG93aW5nIGZlYXR1cmVz
Og0KPltzbmlwXQ0KPj4gK3N0YXRpYyBpbnQgb3Y4ODU2X3dyaXRlX3JlZyhzdHJ1Y3Qgb3Y4ODU2
ICpvdjg4NTYsIHUxNiByZWcsIHUxNiBsZW4sDQo+PiArdTMyIF9fdmFsKSB7DQo+PiArICAgICAg
IHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQgPSB2NGwyX2dldF9zdWJkZXZkYXRhKCZvdjg4NTYt
PnNkKTsNCj4+ICsgICAgICAgdW5zaWduZWQgaW50IGJ1Zl9pLCB2YWxfaTsNCj4+ICsgICAgICAg
dTggYnVmWzZdOw0KPj4gKyAgICAgICB1OCAqdmFsX3A7DQo+PiArICAgICAgIF9fYmUzMiB2YWw7
DQo+PiArDQo+PiArICAgICAgIGlmIChsZW4gPiA0KQ0KPj4gKyAgICAgICAgICAgICAgIHJldHVy
biAtRUlOVkFMOw0KPj4gKw0KPj4gKyAgICAgICBidWZbMF0gPSByZWcgPj4gODsNCj4+ICsgICAg
ICAgYnVmWzFdID0gcmVnICYgMHhmZjsNCj4NCj5UaGUgdHdvIGxpbmVzIGFib3ZlIGNhbiBiZSBz
aW1wbGlmaWVkIGludG8gb25lIHB1dF91bmFsaWduZWRfYmUxNihyZWcsIGJ1Zik7DQo+DQo+PiAr
DQo+PiArICAgICAgIHZhbCA9IGNwdV90b19iZTMyKF9fdmFsKTsNCj4+ICsgICAgICAgdmFsX3Ag
PSAodTggKikmdmFsOw0KPj4gKyAgICAgICBidWZfaSA9IDI7DQo+PiArICAgICAgIHZhbF9pID0g
NCAtIGxlbjsNCj4+ICsNCj4+ICsgICAgICAgd2hpbGUgKHZhbF9pIDwgNCkNCj4+ICsgICAgICAg
ICAgICAgICBidWZbYnVmX2krK10gPSB2YWxfcFt2YWxfaSsrXTsNCj4NCj5BbGwgdGhlIGNvZGUg
YWJvdmUgY2FuIGJlIHNpbXBsaWZpZWQgaW50bzoNCj4NCj52YWwgPDw9IDggKiAoNCAtIGxlbik7
DQo+cHV0X3VuYWxpZ25lZF9iZTMyKHZhbCwgYnVmICsgMik7DQo+DQo+PiArDQo+PiArICAgICAg
IGlmIChpMmNfbWFzdGVyX3NlbmQoY2xpZW50LCBidWYsIGxlbiArIDIpICE9IGxlbiArIDIpDQo+
PiArICAgICAgICAgICAgICAgcmV0dXJuIC1FSU87DQo+PiArDQo+PiArICAgICAgIHJldHVybiAw
Ow0KPj4gK30NCj4NCj5CZXN0IHJlZ2FyZHMsDQo+VG9tYXN6DQo=
