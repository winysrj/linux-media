Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:7936 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751226AbdKUIX6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 03:23:58 -0500
From: Patrice CHOTARD <patrice.chotard@st.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] c8sectpfe: fix potential NULL pointer dereference in
 c8sectpfe_timer_interrupt
Date: Tue, 21 Nov 2017 08:22:39 +0000
Message-ID: <dbd98a18-6d11-bc4e-de44-a04383bb3ade@st.com>
References: <20171120140055.GA728@embeddedor.com>
In-Reply-To: <20171120140055.GA728@embeddedor.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFC15EDF8038634283FD055B25D5E3C1@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgR3VzdGF2bw0KDQpPbiAxMS8yMC8yMDE3IDAzOjAwIFBNLCBHdXN0YXZvIEEuIFIuIFNpbHZh
IHdyb3RlOg0KPiBfY2hhbm5lbF8gaXMgYmVpbmcgZGVyZWZlcmVuY2VkIGJlZm9yZSBpdCBpcyBu
dWxsIGNoZWNrZWQsIGhlbmNlIHRoZXJlIGlzIGENCj4gcG90ZW50aWFsIG51bGwgcG9pbnRlciBk
ZXJlZmVyZW5jZS4gRml4IHRoaXMgYnkgbW92aW5nIHRoZSBwb2ludGVyIGRlcmVmZXJlbmNlDQo+
IGFmdGVyIF9jaGFubmVsXyBoYXMgYmVlbiBudWxsIGNoZWNrZWQuDQo+IA0KPiBUaGlzIGlzc3Vl
IHdhcyBkZXRlY3RlZCB3aXRoIHRoZSBoZWxwIG9mIENvY2NpbmVsbGUuDQo+IA0KPiBGaXhlczog
YzVmNWQwZjk5Nzk0ICgiW21lZGlhXSBjOHNlY3RwZmU6IFNUaUg0MDcvMTAgTGludXggRFZCIGRl
bXV4IHN1cHBvcnQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBHdXN0YXZvIEEuIFIuIFNpbHZhIDxnYXJz
aWx2YUBlbWJlZGRlZG9yLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9z
dGkvYzhzZWN0cGZlL2M4c2VjdHBmZS1jb3JlLmMgfCA0ICsrKy0NCj4gICAxIGZpbGUgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tZWRpYS9wbGF0Zm9ybS9zdGkvYzhzZWN0cGZlL2M4c2VjdHBmZS1jb3JlLmMgYi9kcml2
ZXJzL21lZGlhL3BsYXRmb3JtL3N0aS9jOHNlY3RwZmUvYzhzZWN0cGZlLWNvcmUuYw0KPiBpbmRl
eCA1OTI4MGFjLi4yM2QwY2VkIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL21lZGlhL3BsYXRmb3Jt
L3N0aS9jOHNlY3RwZmUvYzhzZWN0cGZlLWNvcmUuYw0KPiArKysgYi9kcml2ZXJzL21lZGlhL3Bs
YXRmb3JtL3N0aS9jOHNlY3RwZmUvYzhzZWN0cGZlLWNvcmUuYw0KPiBAQCAtODMsNyArODMsNyBA
QCBzdGF0aWMgdm9pZCBjOHNlY3RwZmVfdGltZXJfaW50ZXJydXB0KHVuc2lnbmVkIGxvbmcgYWM4
c2VjdHBmZWkpDQo+ICAgc3RhdGljIHZvaWQgY2hhbm5lbF9zd2RlbXV4X3Rza2xldCh1bnNpZ25l
ZCBsb25nIGRhdGEpDQo+ICAgew0KPiAgIAlzdHJ1Y3QgY2hhbm5lbF9pbmZvICpjaGFubmVsID0g
KHN0cnVjdCBjaGFubmVsX2luZm8gKilkYXRhOw0KPiAtCXN0cnVjdCBjOHNlY3RwZmVpICpmZWkg
PSBjaGFubmVsLT5mZWk7DQo+ICsJc3RydWN0IGM4c2VjdHBmZWkgKmZlaTsNCj4gICAJdW5zaWdu
ZWQgbG9uZyB3cCwgcnA7DQo+ICAgCWludCBwb3MsIG51bV9wYWNrZXRzLCBuLCBzaXplOw0KPiAg
IAl1OCAqYnVmOw0KPiBAQCAtOTEsNiArOTEsOCBAQCBzdGF0aWMgdm9pZCBjaGFubmVsX3N3ZGVt
dXhfdHNrbGV0KHVuc2lnbmVkIGxvbmcgZGF0YSkNCj4gICAJaWYgKHVubGlrZWx5KCFjaGFubmVs
IHx8ICFjaGFubmVsLT5pcmVjKSkNCj4gICAJCXJldHVybjsNCj4gICANCj4gKwlmZWkgPSBjaGFu
bmVsLT5mZWk7DQo+ICsNCj4gICAJd3AgPSByZWFkbChjaGFubmVsLT5pcmVjICsgRE1BX1BSRFNf
QlVTV1BfVFAoMCkpOw0KPiAgIAlycCA9IHJlYWRsKGNoYW5uZWwtPmlyZWMgKyBETUFfUFJEU19C
VVNSUF9UUCgwKSk7DQo+ICAgDQo+IA0KDQpBY2tlZC1ieTogUGF0cmljZSBDaG90YXJkIDxwYXRy
aWNlLmNob3RhcmRAc3QuY29tPg0KDQpUaGFua3M=
