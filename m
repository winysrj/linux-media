Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:57991 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751809AbdGGOeG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 10:34:06 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre TORGUE" <alexandre.torgue@st.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stm32-dcmi: constify vb2_ops structure
Date: Fri, 7 Jul 2017 14:33:22 +0000
Message-ID: <d6b36309-2152-a55e-f160-ed43fdc3791c@st.com>
References: <20170706200517.GA5886@embeddedgus>
In-Reply-To: <20170706200517.GA5886@embeddedgus>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DF6E8F82FC3E84481959768E1F3C035@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

QWNrZWQtYnk6IEh1Z3VlcyBGcnVjaGV0IDxodWd1ZXMuZnJ1Y2hldEBzdC5jb20+DQoNCk9uIDA3
LzA2LzIwMTcgMTA6MDUgUE0sIEd1c3Rhdm8gQS4gUi4gU2lsdmEgd3JvdGU6DQo+IENoZWNrIGZv
ciB2YjJfb3BzIHN0cnVjdHVyZXMgdGhhdCBhcmUgb25seSBzdG9yZWQgaW4gdGhlIG9wcyBmaWVs
ZCBvZiBhDQo+IHZiMl9xdWV1ZSBzdHJ1Y3R1cmUuIFRoYXQgZmllbGQgaXMgZGVjbGFyZWQgY29u
c3QsIHNvIHZiMl9vcHMgc3RydWN0dXJlcw0KPiB0aGF0IGhhdmUgdGhpcyBwcm9wZXJ0eSBjYW4g
YmUgZGVjbGFyZWQgYXMgY29uc3QgYWxzby4NCj4gDQo+IFRoaXMgaXNzdWUgd2FzIGRldGVjdGVk
IHVzaW5nIENvY2NpbmVsbGUgYW5kIHRoZSBmb2xsb3dpbmcgc2VtYW50aWMgcGF0Y2g6DQo+IA0K
PiBAciBkaXNhYmxlIG9wdGlvbmFsX3F1YWxpZmllckANCj4gaWRlbnRpZmllciBpOw0KPiBwb3Np
dGlvbiBwOw0KPiBAQA0KPiBzdGF0aWMgc3RydWN0IHZiMl9vcHMgaUBwID0geyAuLi4gfTsNCj4g
DQo+IEBva0ANCj4gaWRlbnRpZmllciByLmk7DQo+IHN0cnVjdCB2YjJfcXVldWUgZTsNCj4gcG9z
aXRpb24gcDsNCj4gQEANCj4gZS5vcHMgPSAmaUBwOw0KPiANCj4gQGJhZEANCj4gcG9zaXRpb24g
cCAhPSB7ci5wLG9rLnB9Ow0KPiBpZGVudGlmaWVyIHIuaTsNCj4gc3RydWN0IHZiMl9vcHMgZTsN
Cj4gQEANCj4gZUBpQHANCj4gDQo+IEBkZXBlbmRzIG9uICFiYWQgZGlzYWJsZSBvcHRpb25hbF9x
dWFsaWZpZXJADQo+IGlkZW50aWZpZXIgci5pOw0KPiBAQA0KPiBzdGF0aWMNCj4gK2NvbnN0DQo+
IHN0cnVjdCB2YjJfb3BzIGkgPSB7IC4uLiB9Ow0KPiANCj4gU2lnbmVkLW9mZi1ieTogR3VzdGF2
byBBLiBSLiBTaWx2YSA8Z2Fyc2lsdmFAZW1iZWRkZWRvci5jb20+DQo+IC0tLQ0KPiAgIGRyaXZl
cnMvbWVkaWEvcGxhdGZvcm0vc3RtMzIvc3RtMzItZGNtaS5jIHwgMiArLQ0KPiAgIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RtMzIvc3RtMzItZGNtaS5jIGIvZHJpdmVycy9tZWRp
YS9wbGF0Zm9ybS9zdG0zMi9zdG0zMi1kY21pLmMNCj4gaW5kZXggODNkMzJhNS4uMjRlZjg4OCAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdG0zMi9zdG0zMi1kY21pLmMN
Cj4gKysrIGIvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdG0zMi9zdG0zMi1kY21pLmMNCj4gQEAg
LTY2Miw3ICs2NjIsNyBAQCBzdGF0aWMgdm9pZCBkY21pX3N0b3Bfc3RyZWFtaW5nKHN0cnVjdCB2
YjJfcXVldWUgKnZxKQ0KPiAgIAkJZGNtaS0+ZXJyb3JzX2NvdW50LCBkY21pLT5idWZmZXJzX2Nv
dW50KTsNCj4gICB9DQo+ICAgDQo+IC1zdGF0aWMgc3RydWN0IHZiMl9vcHMgZGNtaV92aWRlb19x
b3BzID0gew0KPiArc3RhdGljIGNvbnN0IHN0cnVjdCB2YjJfb3BzIGRjbWlfdmlkZW9fcW9wcyA9
IHsNCj4gICAJLnF1ZXVlX3NldHVwCQk9IGRjbWlfcXVldWVfc2V0dXAsDQo+ICAgCS5idWZfaW5p
dAkJPSBkY21pX2J1Zl9pbml0LA0KPiAgIAkuYnVmX3ByZXBhcmUJCT0gZGNtaV9idWZfcHJlcGFy
ZSwNCj4g
