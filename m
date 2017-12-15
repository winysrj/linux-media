Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51225 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932136AbdLOOxd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 09:53:33 -0500
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Jia-Ju Bai <baijiaju1990@gmail.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Benjamin GAIGNARD" <benjamin.gaignard@st.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 2/2] bdisp: Fix a possible sleep-in-atomic bug in
 bdisp_hw_save_request
Date: Fri, 15 Dec 2017 14:53:27 +0000
Message-ID: <489e7b01-a484-1c13-554f-fc32cdbf9bc7@st.com>
References: <1513086458-29304-1-git-send-email-baijiaju1990@gmail.com>
In-Reply-To: <1513086458-29304-1-git-send-email-baijiaju1990@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <D84E545C6AACCF4DAF9DCE4103EE5652@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkNCg0KDQpUaGFuayB5b3UgZm9yIHRoZSBwYXRjaC4NCg0KDQpPbiAxMi8xMi8xNyAxNDo0Nywg
SmlhLUp1IEJhaSB3cm90ZToNCj4gVGhlIGRyaXZlciBtYXkgc2xlZXAgdW5kZXIgYSBzcGlubG9j
ay4NCj4gVGhlIGZ1bmN0aW9uIGNhbGwgcGF0aCBpczoNCj4gYmRpc3BfZGV2aWNlX3J1biAoYWNx
dWlyZSB0aGUgc3BpbmxvY2spDQo+ICAgIGJkaXNwX2h3X3VwZGF0ZQ0KPiAgICAgIGJkaXNwX2h3
X3NhdmVfcmVxdWVzdA0KPiAgICAgICAgZGV2bV9remFsbG9jKEdGUF9LRVJORUwpIC0tPiBtYXkg
c2xlZXANCj4NCj4gVG8gZml4IGl0LCBHRlBfS0VSTkVMIGlzIHJlcGxhY2VkIHdpdGggR0ZQX0FU
T01JQy4NCj4NCj4gVGhpcyBidWcgaXMgZm91bmQgYnkgbXkgc3RhdGljIGFuYWx5c2lzIHRvb2wo
RFNBQykgYW5kIGNoZWNrZWQgYnkgbXkgY29kZSByZXZpZXcuDQo+DQo+IFNpZ25lZC1vZmYtYnk6
IEppYS1KdSBCYWkgPGJhaWppYWp1MTk5MEBnbWFpbC5jb20+DQpSZXZpZXdlZC1ieTogRmFiaWVu
IERlc3Nlbm5lIDxmYWJpZW4uZGVzc2VubmVAc3QuY29tPg0KPiAtLS0NCj4gICBkcml2ZXJzL21l
ZGlhL3BsYXRmb3JtL3N0aS9iZGlzcC9iZGlzcC1ody5jIHwgICAgMiArLQ0KPiAgIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdGkvYmRpc3AvYmRpc3AtaHcuYyBiL2RyaXZlcnMvbWVk
aWEvcGxhdGZvcm0vc3RpL2JkaXNwL2JkaXNwLWh3LmMNCj4gaW5kZXggNGI2MmNlYi4uN2I0NWI0
MyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdGkvYmRpc3AvYmRpc3At
aHcuYw0KPiArKysgYi9kcml2ZXJzL21lZGlhL3BsYXRmb3JtL3N0aS9iZGlzcC9iZGlzcC1ody5j
DQo+IEBAIC0xMDY0LDcgKzEwNjQsNyBAQCBzdGF0aWMgdm9pZCBiZGlzcF9od19zYXZlX3JlcXVl
c3Qoc3RydWN0IGJkaXNwX2N0eCAqY3R4KQ0KPiAgIAkJaWYgKCFjb3B5X25vZGVbaV0pIHsNCj4g
ICAJCQljb3B5X25vZGVbaV0gPSBkZXZtX2t6YWxsb2MoY3R4LT5iZGlzcF9kZXYtPmRldiwNCj4g
ICAJCQkJCQkgICAgc2l6ZW9mKCpjb3B5X25vZGVbaV0pLA0KPiAtCQkJCQkJICAgIEdGUF9LRVJO
RUwpOw0KPiArCQkJCQkJICAgIEdGUF9BVE9NSUMpOw0KPiAgIAkJCWlmICghY29weV9ub2RlW2ld
KQ0KPiAgIAkJCQlyZXR1cm47DQo+ICAgCQl9DQo=
