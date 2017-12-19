Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47787 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758943AbdLSKn2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 05:43:28 -0500
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Jia-Ju Bai <baijiaju1990@gmail.com>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] bdisp: Fix a possible sleep-in-atomic bug in
 bdisp_hw_reset
Date: Tue, 19 Dec 2017 10:43:22 +0000
Message-ID: <b526fa1a-e670-4abe-078c-2c7c5af9a42c@st.com>
References: <1513425251-4143-1-git-send-email-baijiaju1990@gmail.com>
In-Reply-To: <1513425251-4143-1-git-send-email-baijiaju1990@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6E35B245E017E4B84C536F2D8B9E4C6@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGksDQoNCg0KT24gMTYvMTIvMTcgMTI6NTQsIEppYS1KdSBCYWkgd3JvdGU6DQo+IFRoZSBkcml2
ZXIgbWF5IHNsZWVwIHVuZGVyIGEgc3BpbmxvY2suDQo+IFRoZSBmdW5jdGlvbiBjYWxsIHBhdGgg
aXM6DQo+IGJkaXNwX2RldmljZV9ydW4gKGFjcXVpcmUgdGhlIHNwaW5sb2NrKQ0KPiAgICBiZGlz
cF9od19yZXNldA0KPiAgICAgIG1zbGVlcCAtLT4gbWF5IHNsZWVwDQo+DQo+IFRvIGZpeCBpdCwg
cmVhZGxfcG9sbF90aW1lb3V0X2F0b21pYyBpcyB1c2VkIHRvIHJlcGxhY2UgbXNsZWVwLg0KPg0K
PiBUaGlzIGJ1ZyBpcyBmb3VuZCBieSBteSBzdGF0aWMgYW5hbHlzaXMgdG9vbChEU0FDKSBhbmQN
Cj4gY2hlY2tlZCBieSBteSBjb2RlIHJldmlldy4NCj4NCj4gU2lnbmVkLW9mZi1ieTogSmlhLUp1
IEJhaSA8YmFpamlhanUxOTkwQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9tZWRpYS9w
bGF0Zm9ybS9zdGkvYmRpc3AvYmRpc3AtaHcuYyB8ICAgMTYgKysrKysrKystLS0tLS0tLQ0KPiAg
IDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQo+DQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3BsYXRmb3JtL3N0aS9iZGlzcC9iZGlzcC1ody5jIGIv
ZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdGkvYmRpc3AvYmRpc3AtaHcuYw0KPiBpbmRleCBiNzg5
MmYzLi5lOTRhMzcxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL21lZGlhL3BsYXRmb3JtL3N0aS9i
ZGlzcC9iZGlzcC1ody5jDQo+ICsrKyBiL2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RpL2JkaXNw
L2JkaXNwLWh3LmMNCj4gQEAgLTUsNiArNSw3IEBADQo+ICAgICovDQo+ICAgDQo+ICAgI2luY2x1
ZGUgPGxpbnV4L2RlbGF5Lmg+DQoNClRoaXMgZGVsYXkuaCBpbmNsdWRlIGlzIG5vIG1vcmUgbmVl
ZGVkLCByZW1vdmUgaXQuDQoNCj4gKyNpbmNsdWRlIDxsaW51eC9pb3BvbGwuaD4NCj4gICANCj4g
ICAjaW5jbHVkZSAiYmRpc3AuaCINCj4gICAjaW5jbHVkZSAiYmRpc3AtZmlsdGVyLmgiDQo+IEBA
IC0zNjYsNyArMzY3LDcgQEAgc3RydWN0IGJkaXNwX2ZpbHRlcl9hZGRyIHsNCj4gICAgKi8NCj4g
ICBpbnQgYmRpc3BfaHdfcmVzZXQoc3RydWN0IGJkaXNwX2RldiAqYmRpc3ApDQo+ICAgew0KPiAt
CXVuc2lnbmVkIGludCBpOw0KPiArCXUzMiB0bXA7DQo+ICAgDQo+ICAgCWRldl9kYmcoYmRpc3At
PmRldiwgIiVzXG4iLCBfX2Z1bmNfXyk7DQo+ICAgDQo+IEBAIC0zNzksMTUgKzM4MCwxNCBAQCBp
bnQgYmRpc3BfaHdfcmVzZXQoc3RydWN0IGJkaXNwX2RldiAqYmRpc3ApDQo+ICAgCXdyaXRlbCgw
LCBiZGlzcC0+cmVncyArIEJMVF9DVEwpOw0KPiAgIA0KPiAgIAkvKiBXYWl0IGZvciByZXNldCBk
b25lICovDQo+IC0JZm9yIChpID0gMDsgaSA8IFBPTExfUlNUX01BWDsgaSsrKSB7DQo+IC0JCWlm
IChyZWFkbChiZGlzcC0+cmVncyArIEJMVF9TVEExKSAmIEJMVF9TVEExX0lETEUpDQo+IC0JCQli
cmVhazsNCj4gLQkJbXNsZWVwKFBPTExfUlNUX0RFTEFZX01TKTsNCj4gLQl9DQo+IC0JaWYgKGkg
PT0gUE9MTF9SU1RfTUFYKQ0KDQpBcyByZWNvbW1lbmRlZCBieSBNYXVybywgcGxlYXNlIGFkZCB0
aGlzIGNvbW1lbnQ6DQpEZXNwaXRlIHRoZSBsYXJnZSB0aW1lb3V0LCBtb3N0IG9mIHRoZSB0aW1l
IHRoZSByZXNldCBoYXBwZW5zIHdpdGhvdXQgDQpuZWVkaW5nIGFueSBkZWxheXMNCg0KPiArCWlm
IChyZWFkbF9wb2xsX3RpbWVvdXRfYXRvbWljKGJkaXNwLT5yZWdzICsgQkxUX1NUQTEsIHRtcCwN
Cj4gKwkJKHRtcCAmIEJMVF9TVEExX0lETEUpLCBQT0xMX1JTVF9ERUxBWV9NUywNCj4gKwkJCVBP
TExfUlNUX0RFTEFZX01TICogUE9MTF9SU1RfTUFYKSkgew0KDQpyZWFkX3BvbGxfdGltZW91dCBl
eHBlY3RzIFVTIHRpbWluZ3MsIG5vdCBNUy4NCg0KPiAgIAkJZGV2X2VycihiZGlzcC0+ZGV2LCAi
UmVzZXQgdGltZW91dFxuIik7DQo+ICsJCXJldHVybiAtRUFHQUlOOw0KPiArCX0NCj4gICANCj4g
LQlyZXR1cm4gKGkgPT0gUE9MTF9SU1RfTUFYKSA/IC1FQUdBSU4gOiAwOw0KPiArCXJldHVybiAw
Ow0KPiAgIH0NCj4gICANCj4gICAvKioNCg==
