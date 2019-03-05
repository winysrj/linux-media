Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF1C2C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 10:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A41FC20842
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 10:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfCEKYZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 05:24:25 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:48278 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726190AbfCEKYZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 05:24:25 -0500
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x25AIDcd025706;
        Tue, 5 Mar 2019 11:24:17 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2qyhkn0ty5-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 05 Mar 2019 11:24:17 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id A2E7E31;
        Tue,  5 Mar 2019 10:24:16 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 3DD2C2657;
        Tue,  5 Mar 2019 10:24:16 +0000 (GMT)
Received: from SFHDAG5NODE1.st.com (10.75.127.13) by SFHDAG5NODE3.st.com
 (10.75.127.15) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue, 5 Mar
 2019 11:24:15 +0100
Received: from SFHDAG5NODE1.st.com ([fe80::cc53:528c:36c8:95f6]) by
 SFHDAG5NODE1.st.com ([fe80::cc53:528c:36c8:95f6%20]) with mapi id
 15.00.1347.000; Tue, 5 Mar 2019 11:24:15 +0100
From:   Hugues FRUCHET <hugues.fruchet@st.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: uvcvideo: Read support
Thread-Topic: [PATCH] media: uvcvideo: Read support
Thread-Index: AQHU0obNzNNU77V6FU2VMxLpEw4y5KX7ikQAgAACWwCAATi6gA==
Date:   Tue, 5 Mar 2019 10:24:15 +0000
Message-ID: <eb707933-4309-bb65-ad73-d933278a3c5d@st.com>
References: <1551702925-7739-1-git-send-email-hugues.fruchet@st.com>
 <1551702925-7739-2-git-send-email-hugues.fruchet@st.com>
 <8ec96fe6-96af-c101-ff20-ab59d953ad6a@ideasonboard.com>
 <20190304154458.GO6325@pendragon.ideasonboard.com>
In-Reply-To: <20190304154458.GO6325@pendragon.ideasonboard.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.48]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF0FB3CA0238754B82523AD1479C9576@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-05_06:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgS2llcmFuLCBMYXVyZW50LA0KDQpPbiAzLzQvMTkgNDo0NCBQTSwgTGF1cmVudCBQaW5jaGFy
dCB3cm90ZToNCj4gSGVsbG8sDQo+IA0KPiBPbiBNb24sIE1hciAwNCwgMjAxOSBhdCAwMzozNjoz
MlBNICswMDAwLCBLaWVyYW4gQmluZ2hhbSB3cm90ZToNCj4+IE9uIDA0LzAzLzIwMTkgMTI6MzUs
IEh1Z3VlcyBGcnVjaGV0IHdyb3RlOg0KPj4+IEFkZCBzdXBwb3J0IG9mIHJlYWQoKSBjYWxsIGZy
b20gdXNlcnNwYWNlIGJ5IGltcGxlbWVudGluZw0KPj4+IHV2Y192NGwyX3JlYWQoKSB3aXRoIHZi
Ml9yZWFkKCkgaGVscGVyLg0KPj4NCj4+IEp1c3QgdGhpbmtpbmcgb3V0IGxvdWQsDQo+Pg0KPj4g
VGhpcyBvcGVucyB1cCBVVkMgZGV2aWNlcyB0byByZWFkIHJhdyBmdWxsIGZyYW1lIGltYWdlcyB0
aHJvdWdoIHRoaXMNCj4+IGludGVyZmFjZSBhcyB3ZWxsLg0KPj4NCj4+IER1ZSB0byB0aGUgVVZD
IHByb3RvY29sLCB0aGVyZSBpcyAvYWxyZWFkeS8gYSBmdWxsIG1lbWNweSB0byBnZXQgdGhlc2UN
Cj4+IGltYWdlcyBvdXQgb2YgdGhlIFVSQiBwYWNrZXRzLCBzbyB1c2luZyBhIHJlYWQoKSBpbnRl
cmZhY2Ugd291bGQgYmUNCj4+IGFub3RoZXIgZnVsbCBmcmFtZSBjb3B5Lg0KPj4NCj4+IEkgY2Fu
IHBlcmhhcHMgc2VlIHRoZSB1c2VjYXNlIGZvciByZWFkaW5nIGNvbXByZXNzZWQgZGF0YSB0aHJv
dWdoIHRoaXMNCj4+IGludGVyZmFjZSAtIGJ1dCBmdWxsIGZyYW1lcyBkb24ndCBzZWVtIGFwcHJv
cHJpYXRlLiAobm90IGltcG9zc2libGUgb2YNCj4+IGNvdXJzZSwganVzdCBpcyBpdCByZWFzb25h
YmxlPykNCj4+DQo+PiBJZiB0aGlzIGlzIHRvIGJlIGVuYWJsZWQsIHNob3VsZCBpdCBiZSBlbmFi
bGVkIGZvciBjb21wcmVzc2VkIGZvcm1hdHMNCj4+IG9ubHk/IG9yIHdvdWxkIHRoYXQgY29tcGxp
Y2F0ZSBtYXR0ZXJzPw0KPiANCj4gSSd2ZSByZXBlYXRlZGx5IHJlZnVzZWQgcmVhZCgpIHN1cHBv
cnQgaW4gdXZjdmlkZW8gZm9yIHRoaXMgcmVhc29uLCBhbmQNCj4gYWxzbyBiZWNhdXNlIHJlYWQo
KSBkb2Vzbid0IGNhcnJ5IGZyYW1pbmcgaW5mb3JtYXRpb24gdmVyeSB3ZWxsLiBJdCdzDQo+IGp1
c3Qgbm90IGEgZ29vZCBBUEkgZm9yIGNhcHR1cmluZyB2aWRlbyBmcmFtZXMgZnJvbSBhIHdlYmNh
bSwgYW5kIHNvIGZhcg0KPiBJIGhhdmVuJ3QgaGVhcmQgYSBjb21wZWxpbmcgcmVhc29uIHdoeSBp
dCBzaG91bGQgYmUgZW5hYmxlZC4gSSB0aHVzDQo+IGhhdmVuJ3QgY2hhbmdlZCBteSBtaW5kIDot
KQ0KPiANCg0KRm9yIHN1cmUgcmVhZCgpIGlzIG5vdCBvcHRpbWFsLCBidXQgaXMgdmVyeSBjb21t
b24gYW5kIHByZXR0eSBzaW1wbGUgdG8gDQp1c2UgZnJvbSB1c2Vyc3BhY2UgYXMgZXhwbGFpbmVk
IGluIHRoZSBjb3ZlciBsZXR0ZXIgd2l0aCBzb21lIGV4YW1wbGVzLg0KDQpNb3Jlb3ZlciwgcmVh
ZCgpIGlzIGVuYWJsZWQgYnkgbWFueSAoYWxsID8pIGNhbWVyYSBpbnRlcmZhY2VzOg0KDQpkcml2
ZXJzL21lZGlhL3BsYXRmb3JtL3B4YV9jYW1lcmEuYzoJLnJlYWQJCT0gdmIyX2ZvcF9yZWFkLA0K
ZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9hdG1lbC9hdG1lbC1pc2kuYzoJLnJlYWQJPSB2YjJfZm9w
X3JlYWQsDQpkcml2ZXJzL21lZGlhL3BsYXRmb3JtL3JjYXItdmluL3JjYXItdjRsMi5jOgkucmVh
ZAk9IHZiMl9mb3BfcmVhZCwNCmRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RtMzIvc3RtMzItZGNt
aS5jOgkucmVhZAk9IHZiMl9mb3BfcmVhZCwNCmRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vdml2aWQv
dml2aWQtY29yZS5jOgkucmVhZCAgID0gdmIyX2ZvcF9yZWFkLA0KZHJpdmVycy9tZWRpYS9wbGF0
Zm9ybS92aW1jL3ZpbWMtY2FwdHVyZS5jOgkucmVhZCAgID0gdmIyX2ZvcF9yZWFkLA0KZHJpdmVy
cy9tZWRpYS9wbGF0Zm9ybS9tYXJ2ZWxsLWNjaWMvbWNhbS1jb3JlLmM6LnJlYWQgICA9IHZiMl9m
b3BfcmVhZCwNCmRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vcWNvbS9jYW1zcy9jYW1zcy12aWRlby5j
Oi5yZWFkCT0gdmIyX2ZvcF9yZWFkLA0KDQpvbiBteSBzZXR1cCwgdGhpcyBsZWFkcyB0byBoYXZl
IC9kZXYvdmlkZW8wIChtYXBwZWQgb24gRENNSSBjYW1lcmEgDQppbnRlcmZhY2UpIHN1cHBvcnRp
bmcgSlBFRyBzdHJlYW1pbmcgdGhyb3VnaCByZWFkKCkgd2hpbGUgL2Rldi92aWRlbzEgDQoobWFw
cGVkIG9uIEhlcmN1bGUgVVNCIGNhbWVyYSkgZmFpbHMgd2l0aCAiaW52YWxpZCBhcmd1bWVudCIg
ZXJyb3IuLi4NCg0KDQo+Pj4gU2lnbmVkLW9mZi1ieTogSHVndWVzIEZydWNoZXQgPGh1Z3Vlcy5m
cnVjaGV0QHN0LmNvbT4NCj4+PiAtLS0NCj4+PiAgIGRyaXZlcnMvbWVkaWEvdXNiL3V2Yy91dmNf
cXVldWUuYyB8IDE1ICsrKysrKysrKysrKysrLQ0KPj4+ICAgZHJpdmVycy9tZWRpYS91c2IvdXZj
L3V2Y192NGwyLmMgIHwgMTEgKysrKysrKystLS0NCj4+PiAgIGRyaXZlcnMvbWVkaWEvdXNiL3V2
Yy91dmN2aWRlby5oICB8ICAyICsrDQo+Pj4gICAzIGZpbGVzIGNoYW5nZWQsIDI0IGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRp
YS91c2IvdXZjL3V2Y19xdWV1ZS5jIGIvZHJpdmVycy9tZWRpYS91c2IvdXZjL3V2Y19xdWV1ZS5j
DQo+Pj4gaW5kZXggNjgyNjk4ZS4uMGM4YTBhOCAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL21l
ZGlhL3VzYi91dmMvdXZjX3F1ZXVlLmMNCj4+PiArKysgYi9kcml2ZXJzL21lZGlhL3VzYi91dmMv
dXZjX3F1ZXVlLmMNCj4+PiBAQCAtMjI3LDcgKzIyNyw3IEBAIGludCB1dmNfcXVldWVfaW5pdChz
dHJ1Y3QgdXZjX3ZpZGVvX3F1ZXVlICpxdWV1ZSwgZW51bSB2NGwyX2J1Zl90eXBlIHR5cGUsDQo+
Pj4gICAJaW50IHJldDsNCj4+PiAgIA0KPj4+ICAgCXF1ZXVlLT5xdWV1ZS50eXBlID0gdHlwZTsN
Cj4+PiAtCXF1ZXVlLT5xdWV1ZS5pb19tb2RlcyA9IFZCMl9NTUFQIHwgVkIyX1VTRVJQVFI7DQo+
Pj4gKwlxdWV1ZS0+cXVldWUuaW9fbW9kZXMgPSBWQjJfTU1BUCB8IFZCMl9VU0VSUFRSIHwgVkIy
X1JFQUQ7DQo+Pj4gICAJcXVldWUtPnF1ZXVlLmRydl9wcml2ID0gcXVldWU7DQo+Pj4gICAJcXVl
dWUtPnF1ZXVlLmJ1Zl9zdHJ1Y3Rfc2l6ZSA9IHNpemVvZihzdHJ1Y3QgdXZjX2J1ZmZlcik7DQo+
Pj4gICAJcXVldWUtPnF1ZXVlLm1lbV9vcHMgPSAmdmIyX3ZtYWxsb2NfbWVtb3BzOw0KPj4+IEBA
IC0zNjEsNiArMzYxLDE5IEBAIGludCB1dmNfcXVldWVfc3RyZWFtb2ZmKHN0cnVjdCB1dmNfdmlk
ZW9fcXVldWUgKnF1ZXVlLCBlbnVtIHY0bDJfYnVmX3R5cGUgdHlwZSkNCj4+PiAgIAlyZXR1cm4g
cmV0Ow0KPj4+ICAgfQ0KPj4+ICAgDQo+Pj4gK3NzaXplX3QgdXZjX3F1ZXVlX3JlYWQoc3RydWN0
IHV2Y192aWRlb19xdWV1ZSAqcXVldWUsIHN0cnVjdCBmaWxlICpmaWxlLA0KPj4+ICsJCSAgICAg
ICBjaGFyIF9fdXNlciAqYnVmLCBzaXplX3QgY291bnQsIGxvZmZfdCAqcHBvcykNCj4+PiArew0K
Pj4+ICsJc3NpemVfdCByZXQ7DQo+Pj4gKw0KPj4+ICsJbXV0ZXhfbG9jaygmcXVldWUtPm11dGV4
KTsNCj4+PiArCXJldCA9IHZiMl9yZWFkKCZxdWV1ZS0+cXVldWUsIGJ1ZiwgY291bnQsIHBwb3Ms
DQo+Pj4gKwkJICAgICAgIGZpbGUtPmZfZmxhZ3MgJiBPX05PTkJMT0NLKTsNCj4+PiArCW11dGV4
X3VubG9jaygmcXVldWUtPm11dGV4KTsNCj4+PiArDQo+Pj4gKwlyZXR1cm4gcmV0Ow0KPj4+ICt9
DQo+Pj4gKw0KPj4+ICAgaW50IHV2Y19xdWV1ZV9tbWFwKHN0cnVjdCB1dmNfdmlkZW9fcXVldWUg
KnF1ZXVlLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkNCj4+PiAgIHsNCj4+PiAgIAlyZXR1
cm4gdmIyX21tYXAoJnF1ZXVlLT5xdWV1ZSwgdm1hKTsNCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tZWRpYS91c2IvdXZjL3V2Y192NGwyLmMgYi9kcml2ZXJzL21lZGlhL3VzYi91dmMvdXZjX3Y0
bDIuYw0KPj4+IGluZGV4IDg0YmU1OTYuLjM4NjY4MzIgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVy
cy9tZWRpYS91c2IvdXZjL3V2Y192NGwyLmMNCj4+PiArKysgYi9kcml2ZXJzL21lZGlhL3VzYi91
dmMvdXZjX3Y0bDIuYw0KPj4+IEBAIC01OTQsNyArNTk0LDggQEAgc3RhdGljIGludCB1dmNfaW9j
dGxfcXVlcnljYXAoc3RydWN0IGZpbGUgKmZpbGUsIHZvaWQgKmZoLA0KPj4+ICAgCXN0cnNjcHko
Y2FwLT5kcml2ZXIsICJ1dmN2aWRlbyIsIHNpemVvZihjYXAtPmRyaXZlcikpOw0KPj4+ICAgCXN0
cnNjcHkoY2FwLT5jYXJkLCB2ZGV2LT5uYW1lLCBzaXplb2YoY2FwLT5jYXJkKSk7DQo+Pj4gICAJ
dXNiX21ha2VfcGF0aChzdHJlYW0tPmRldi0+dWRldiwgY2FwLT5idXNfaW5mbywgc2l6ZW9mKGNh
cC0+YnVzX2luZm8pKTsNCj4+PiAtCWNhcC0+Y2FwYWJpbGl0aWVzID0gVjRMMl9DQVBfREVWSUNF
X0NBUFMgfCBWNEwyX0NBUF9TVFJFQU1JTkcNCj4+PiArCWNhcC0+Y2FwYWJpbGl0aWVzID0gVjRM
Ml9DQVBfREVWSUNFX0NBUFMgfCBWNEwyX0NBUF9TVFJFQU1JTkcgfA0KPj4+ICsJCQkgICAgVjRM
Ml9DQVBfUkVBRFdSSVRFDQo+Pj4gICAJCQkgIHwgY2hhaW4tPmNhcHM7DQo+Pj4gICANCj4+PiAg
IAlyZXR1cm4gMDsNCj4+PiBAQCAtMTQzNCw4ICsxNDM1LDEyIEBAIHN0YXRpYyBsb25nIHV2Y192
NGwyX2NvbXBhdF9pb2N0bDMyKHN0cnVjdCBmaWxlICpmaWxlLA0KPj4+ICAgc3RhdGljIHNzaXpl
X3QgdXZjX3Y0bDJfcmVhZChzdHJ1Y3QgZmlsZSAqZmlsZSwgY2hhciBfX3VzZXIgKmRhdGEsDQo+
Pj4gICAJCSAgICBzaXplX3QgY291bnQsIGxvZmZfdCAqcHBvcykNCj4+PiAgIHsNCj4+PiAtCXV2
Y190cmFjZShVVkNfVFJBQ0VfQ0FMTFMsICJ1dmNfdjRsMl9yZWFkOiBub3QgaW1wbGVtZW50ZWQu
XG4iKTsNCj4+PiAtCXJldHVybiAtRUlOVkFMOw0KPj4+ICsJc3RydWN0IHV2Y19maCAqaGFuZGxl
ID0gZmlsZS0+cHJpdmF0ZV9kYXRhOw0KPj4+ICsJc3RydWN0IHV2Y19zdHJlYW1pbmcgKnN0cmVh
bSA9IGhhbmRsZS0+c3RyZWFtOw0KPj4+ICsNCj4+PiArCXV2Y190cmFjZShVVkNfVFJBQ0VfQ0FM
TFMsICJ1dmNfdjRsMl9yZWFkXG4iKTsNCj4+PiArDQo+Pj4gKwlyZXR1cm4gdXZjX3F1ZXVlX3Jl
YWQoJnN0cmVhbS0+cXVldWUsIGZpbGUsIGRhdGEsIGNvdW50LCBwcG9zKTsNCj4+PiAgIH0NCj4+
PiAgIA0KPj4+ICAgc3RhdGljIGludCB1dmNfdjRsMl9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCBz
dHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkNCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRp
YS91c2IvdXZjL3V2Y3ZpZGVvLmggYi9kcml2ZXJzL21lZGlhL3VzYi91dmMvdXZjdmlkZW8uaA0K
Pj4+IGluZGV4IGM3YzFiYWEuLjVkMDUxNWMgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVycy9tZWRp
YS91c2IvdXZjL3V2Y3ZpZGVvLmgNCj4+PiArKysgYi9kcml2ZXJzL21lZGlhL3VzYi91dmMvdXZj
dmlkZW8uaA0KPj4+IEBAIC03NjYsNiArNzY2LDggQEAgc3RydWN0IHV2Y19idWZmZXIgKnV2Y19x
dWV1ZV9uZXh0X2J1ZmZlcihzdHJ1Y3QgdXZjX3ZpZGVvX3F1ZXVlICpxdWV1ZSwNCj4+PiAgIAkJ
CQkJIHN0cnVjdCB1dmNfYnVmZmVyICpidWYpOw0KPj4+ICAgc3RydWN0IHV2Y19idWZmZXIgKnV2
Y19xdWV1ZV9nZXRfY3VycmVudF9idWZmZXIoc3RydWN0IHV2Y192aWRlb19xdWV1ZSAqcXVldWUp
Ow0KPj4+ICAgdm9pZCB1dmNfcXVldWVfYnVmZmVyX3JlbGVhc2Uoc3RydWN0IHV2Y19idWZmZXIg
KmJ1Zik7DQo+Pj4gK3NzaXplX3QgdXZjX3F1ZXVlX3JlYWQoc3RydWN0IHV2Y192aWRlb19xdWV1
ZSAqcXVldWUsIHN0cnVjdCBmaWxlICpmaWxlLA0KPj4+ICsJCSAgICAgICBjaGFyIF9fdXNlciAq
YnVmLCBzaXplX3QgY291bnQsIGxvZmZfdCAqcHBvcyk7DQo+Pj4gICBpbnQgdXZjX3F1ZXVlX21t
YXAoc3RydWN0IHV2Y192aWRlb19xdWV1ZSAqcXVldWUsDQo+Pj4gICAJCSAgIHN0cnVjdCB2bV9h
cmVhX3N0cnVjdCAqdm1hKTsNCj4+PiAgIF9fcG9sbF90IHV2Y19xdWV1ZV9wb2xsKHN0cnVjdCB1
dmNfdmlkZW9fcXVldWUgKnF1ZXVlLCBzdHJ1Y3QgZmlsZSAqZmlsZSwNCj4gDQoNCkJlc3QgcmVn
YXJkcywNCkh1Z3Vlcy4=
