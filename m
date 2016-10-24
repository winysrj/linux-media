Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51842 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933177AbcJXHz3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 03:55:29 -0400
From: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
To: Colin King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 24 Oct 2016 09:55:14 +0200
Subject: Re: [PATCH] [media] st-hva: fix a copy-and-paste variable name error
Message-ID: <bb8f2ff1-68af-9a04-6e6d-3a4a585b39c1@st.com>
References: <20160919061928.6575-1-colin.king@canonical.com>
In-Reply-To: <20160919061928.6575-1-colin.king@canonical.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VGhhbmtzIChhbmQgc29ycnkgZm9yIHRoZSBkZWxheSBvZiBteSBhbnN3ZXIpLA0KDQpBY2tlZC1i
eTogSmVhbi1DaHJpc3RvcGhlIFRyb3RpbiA8amVhbi1jaHJpc3RvcGhlLnRyb3RpbkBzdC5jb20+
DQoNCk9uIDA5LzE5LzIwMTYgMDg6MTkgQU0sIENvbGluIEtpbmcgd3JvdGU6DQo+IEZyb206IENv
bGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+DQo+IFRoZSBzZWNvbmQg
Y2hlY2sgZm9yIGFuIGVycm9yIG9uIGh2YS0+bG1pX2Vycl9yZWcgYXBwZWFycw0KPiB0byBiZSBh
IGNvcHktYW5kLXBhc3RlIGVycm9yLCBpdCBzaG91bGQgYmUgaHZhLT5lbWlfZXJyX3JlZw0KPiBp
bnN0ZWFkLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0Bj
YW5vbmljYWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RpL2h2YS9o
dmEtaHcuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdGkvaHZh
L2h2YS1ody5jIGIvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdGkvaHZhL2h2YS1ody5jDQo+IGlu
ZGV4IGQzNDFkNDkuLmRjZjM2MmMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbWVkaWEvcGxhdGZv
cm0vc3RpL2h2YS9odmEtaHcuYw0KPiArKysgYi9kcml2ZXJzL21lZGlhL3BsYXRmb3JtL3N0aS9o
dmEvaHZhLWh3LmMNCj4gQEAgLTI0NSw3ICsyNDUsNyBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgaHZh
X2h3X2Vycl9pcnFfdGhyZWFkKGludCBpcnEsIHZvaWQgKmFyZykNCj4gIAkJY3R4LT5od19lcnIg
PSB0cnVlOw0KPiAgCX0NCj4NCj4gLQlpZiAoaHZhLT5sbWlfZXJyX3JlZykgew0KPiArCWlmICho
dmEtPmVtaV9lcnJfcmVnKSB7DQo+ICAJCWRldl9lcnIoZGV2LCAiJXMgICAgIGV4dGVybmFsIG1l
bW9yeSBpbnRlcmZhY2UgZXJyb3I6IDB4JTA4eFxuIiwNCj4gIAkJCWN0eC0+bmFtZSwgaHZhLT5l
bWlfZXJyX3JlZyk7DQo+ICAJCWN0eC0+aHdfZXJyID0gdHJ1ZTsNCj4=
