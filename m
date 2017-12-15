Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:19566 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755322AbdLOOvG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 09:51:06 -0500
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Jia-Ju Bai <baijiaju1990@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Benjamin GAIGNARD" <benjamin.gaignard@st.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/2] bdisp: Fix a possible sleep-in-atomic bug in
 bdisp_hw_reset
Date: Fri, 15 Dec 2017 14:51:00 +0000
Message-ID: <0370257c-ce0c-792f-6c85-50ebc18975f9@st.com>
References: <1513086445-29265-1-git-send-email-baijiaju1990@gmail.com>
In-Reply-To: <1513086445-29265-1-git-send-email-baijiaju1990@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <63D993B0F6DA184F8CC4EA714FEBE9AA@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkNCg0KT24gMTIvMTIvMTcgMTQ6NDcsIEppYS1KdSBCYWkgd3JvdGU6DQo+IFRoZSBkcml2ZXIg
bWF5IHNsZWVwIHVuZGVyIGEgc3BpbmxvY2suDQo+IFRoZSBmdW5jdGlvbiBjYWxsIHBhdGggaXM6
DQo+IGJkaXNwX2RldmljZV9ydW4gKGFjcXVpcmUgdGhlIHNwaW5sb2NrKQ0KPiAgICBiZGlzcF9o
d19yZXNldA0KPiAgICAgIG1zbGVlcCAtLT4gbWF5IHNsZWVwDQo+DQo+IFRvIGZpeCBpdCwgbXNs
ZWVwIGlzIHJlcGxhY2VkIHdpdGggbWRlbGF5Lg0KDQpNYXkgSSBzdWdnZXN0IHlvdSB0byB1c2Ug
cmVhZGxfcG9sbF90aW1lb3V0X2F0b21pYyAoaW5zdGVhZCBvZiB0aGUgd2hvbGUgDQoiZm9yIiBi
bG9jayk6IHRoaXMgZml4ZXMgdGhlIHByb2JsZW0gYW5kIHNpbXBsaWZpZXMgdGhlIGNvZGU/DQoN
Cj4NCj4gVGhpcyBidWcgaXMgZm91bmQgYnkgbXkgc3RhdGljIGFuYWx5c2lzIHRvb2woRFNBQykg
YW5kIGNoZWNrZWQgYnkgbXkgY29kZSByZXZpZXcuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IEppYS1K
dSBCYWkgPGJhaWppYWp1MTk5MEBnbWFpbC5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbWVkaWEv
cGxhdGZvcm0vc3RpL2JkaXNwL2JkaXNwLWh3LmMgfCAgICAyICstDQo+ICAgMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL21lZGlhL3BsYXRmb3JtL3N0aS9iZGlzcC9iZGlzcC1ody5jIGIvZHJpdmVycy9tZWRpYS9w
bGF0Zm9ybS9zdGkvYmRpc3AvYmRpc3AtaHcuYw0KPiBpbmRleCBiNzg5MmYzLi40YjYyY2ViIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL21lZGlhL3BsYXRmb3JtL3N0aS9iZGlzcC9iZGlzcC1ody5j
DQo+ICsrKyBiL2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RpL2JkaXNwL2JkaXNwLWh3LmMNCj4g
QEAgLTM4Miw3ICszODIsNyBAQCBpbnQgYmRpc3BfaHdfcmVzZXQoc3RydWN0IGJkaXNwX2RldiAq
YmRpc3ApDQo+ICAgCWZvciAoaSA9IDA7IGkgPCBQT0xMX1JTVF9NQVg7IGkrKykgew0KPiAgIAkJ
aWYgKHJlYWRsKGJkaXNwLT5yZWdzICsgQkxUX1NUQTEpICYgQkxUX1NUQTFfSURMRSkNCj4gICAJ
CQlicmVhazsNCj4gLQkJbXNsZWVwKFBPTExfUlNUX0RFTEFZX01TKTsNCj4gKwkJbWRlbGF5KFBP
TExfUlNUX0RFTEFZX01TKTsNCj4gICAJfQ0KPiAgIAlpZiAoaSA9PSBQT0xMX1JTVF9NQVgpDQo+
ICAgCQlkZXZfZXJyKGJkaXNwLT5kZXYsICJSZXNldCB0aW1lb3V0XG4iKTsNCg==
