Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:52411 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750737AbdKFIUj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 03:20:39 -0500
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Colin King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][V2] bdisp: remove redundant assignment to pix
Date: Mon, 6 Nov 2017 08:20:32 +0000
Message-ID: <07c2fb76-3a55-77fd-ec21-cc6bb4b3e786@st.com>
References: <20171029134339.7101-1-colin.king@canonical.com>
In-Reply-To: <20171029134339.7101-1-colin.king@canonical.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D0DD301926A4442BD2522AF824A4A33@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgQ29saW4NCg0KVGhhbmsgeW91IGZvciB0aGUgcGF0Y2guDQoNCg0KT24gMjkvMTAvMTcgMTQ6
NDMsIENvbGluIEtpbmcgd3JvdGU6DQo+IEZyb206IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5n
QGNhbm9uaWNhbC5jb20+DQo+DQo+IFBvaW50ZXIgcGl4IGlzIGJlaW5nIGluaXRpYWxpemVkIHRv
IGEgdmFsdWUgYW5kIGEgbGl0dGxlIGxhdGVyDQo+IGJlaW5nIGFzc2lnbmVkIHRoZSBzYW1lIHZh
bHVlIGFnYWluLiBSZW1vdmUgdGhlIGluaXRpYWwgYXNzaWdubWVudCB0bw0KPiBhdm9pZCBhIGR1
cGxpY2F0ZSBhc3NpZ25tZW50LiBDbGVhbnMgdXAgdGhlIGNsYW5nIHdhcm5pbmc6DQo+DQo+IGRy
aXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RpL2JkaXNwL2JkaXNwLXY0bDIuYzo3MjY6MjY6IHdhcm5p
bmc6IFZhbHVlDQo+IHN0b3JlZCB0byAncGl4JyBkdXJpbmcgaXRzIGluaXRpYWxpemF0aW9uIGlz
IG5ldmVyIHJlYWQNCj4NCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtp
bmdAY2Fub25pY2FsLmNvbT4NClJldmlld2VkLWJ5OiBGYWJpZW4gRGVzc2VubmUgPGZhYmllbi5k
ZXNzZW5uZUBzdC5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RpL2Jk
aXNwL2JkaXNwLXY0bDIuYyB8IDIgKy0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvcGxhdGZv
cm0vc3RpL2JkaXNwL2JkaXNwLXY0bDIuYyBiL2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RpL2Jk
aXNwL2JkaXNwLXY0bDIuYw0KPiBpbmRleCA5MzlkYTZkYTc2NDQuLjdlOWVkOWM3YjNlMSAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdGkvYmRpc3AvYmRpc3AtdjRsMi5j
DQo+ICsrKyBiL2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RpL2JkaXNwL2JkaXNwLXY0bDIuYw0K
PiBAQCAtNzIzLDcgKzcyMyw3IEBAIHN0YXRpYyBpbnQgYmRpc3BfZW51bV9mbXQoc3RydWN0IGZp
bGUgKmZpbGUsIHZvaWQgKmZoLCBzdHJ1Y3QgdjRsMl9mbXRkZXNjICpmKQ0KPiAgIHN0YXRpYyBp
bnQgYmRpc3BfZ19mbXQoc3RydWN0IGZpbGUgKmZpbGUsIHZvaWQgKmZoLCBzdHJ1Y3QgdjRsMl9m
b3JtYXQgKmYpDQo+ICAgew0KPiAgIAlzdHJ1Y3QgYmRpc3BfY3R4ICpjdHggPSBmaF90b19jdHgo
ZmgpOw0KPiAtCXN0cnVjdCB2NGwyX3BpeF9mb3JtYXQgKnBpeCA9ICZmLT5mbXQucGl4Ow0KPiAr
CXN0cnVjdCB2NGwyX3BpeF9mb3JtYXQgKnBpeDsNCj4gICAJc3RydWN0IGJkaXNwX2ZyYW1lICpm
cmFtZSAgPSBjdHhfZ2V0X2ZyYW1lKGN0eCwgZi0+dHlwZSk7DQo+ICAgDQo+ICAgCWlmIChJU19F
UlIoZnJhbWUpKSB7DQo=
