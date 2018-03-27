Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0084.outbound.protection.outlook.com ([104.47.33.84]:64512
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751824AbeC0Dc4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 23:32:56 -0400
From: "He, Roger" <Hongbo.He@amd.com>
To: =?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?=
        <ckoenig.leichtzumerken@gmail.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>
Subject: RE: [PATCH 3/5] drm/ttm: remove the backing store if no placement is
 given
Date: Tue, 27 Mar 2018 03:32:54 +0000
Message-ID: <MWHPR1201MB0127FE21A778A3FD2DDD9234FDAC0@MWHPR1201MB0127.namprd12.prod.outlook.com>
References: <20180325105759.2151-1-christian.koenig@amd.com>
 <20180325105759.2151-3-christian.koenig@amd.com>
In-Reply-To: <20180325105759.2151-3-christian.koenig@amd.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQpBY2tlZC1ieTogUm9nZXIgSGUgPEhvbmdiby5IZUBhbWQuY29tPg0KDQotLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KRnJvbTogYW1kLWdmeCBbbWFpbHRvOmFtZC1nZngtYm91bmNlc0BsaXN0
cy5mcmVlZGVza3RvcC5vcmddIE9uIEJlaGFsZiBPZiBDaHJpc3RpYW4gSz9uaWcNClNlbnQ6IFN1
bmRheSwgTWFyY2ggMjUsIDIwMTggNjo1OCBQTQ0KVG86IGxpbmFyby1tbS1zaWdAbGlzdHMubGlu
YXJvLm9yZzsgbGludXgtbWVkaWFAdmdlci5rZXJuZWwub3JnOyBkcmktZGV2ZWxAbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnOyBhbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZzsgc3VtaXQuc2Vtd2Fs
QGxpbmFyby5vcmcNClN1YmplY3Q6IFtQQVRDSCAzLzVdIGRybS90dG06IHJlbW92ZSB0aGUgYmFj
a2luZyBzdG9yZSBpZiBubyBwbGFjZW1lbnQgaXMgZ2l2ZW4NCg0KUGlwZWxpbmUgcmVtb3ZhbCBv
ZiB0aGUgQk9zIGJhY2tpbmcgc3RvcmUgd2hlbiB0aGUgcGxhY2VtZW50IGlzIGdpdmVuIGR1cmlu
ZyB2YWxpZGF0aW9uLg0KDQpTaWduZWQtb2ZmLWJ5OiBDaHJpc3RpYW4gS8O2bmlnIDxjaHJpc3Rp
YW4ua29lbmlnQGFtZC5jb20+DQotLS0NCiBkcml2ZXJzL2dwdS9kcm0vdHRtL3R0bV9iby5jIHwg
MTIgKysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS90dG0vdHRtX2JvLmMgYi9kcml2ZXJzL2dwdS9kcm0v
dHRtL3R0bV9iby5jIGluZGV4IDk4ZTA2ZjhiZjIzYi4uMTdlODIxZjAxZDBhIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9ncHUvZHJtL3R0bS90dG1fYm8uYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3R0
bS90dG1fYm8uYw0KQEAgLTEwNzgsNiArMTA3OCwxOCBAQCBpbnQgdHRtX2JvX3ZhbGlkYXRlKHN0
cnVjdCB0dG1fYnVmZmVyX29iamVjdCAqYm8sDQogCXVpbnQzMl90IG5ld19mbGFnczsNCiANCiAJ
cmVzZXJ2YXRpb25fb2JqZWN0X2Fzc2VydF9oZWxkKGJvLT5yZXN2KTsNCisNCisJLyoNCisJICog
UmVtb3ZlIHRoZSBiYWNraW5nIHN0b3JlIGlmIG5vIHBsYWNlbWVudCBpcyBnaXZlbi4NCisJICov
DQorCWlmICghcGxhY2VtZW50LT5udW1fcGxhY2VtZW50ICYmICFwbGFjZW1lbnQtPm51bV9idXN5
X3BsYWNlbWVudCkgew0KKwkJcmV0ID0gdHRtX2JvX3BpcGVsaW5lX2d1dHRpbmcoYm8pOw0KKwkJ
aWYgKHJldCkNCisJCQlyZXR1cm4gcmV0Ow0KKw0KKwkJcmV0dXJuIHR0bV90dF9jcmVhdGUoYm8s
IGZhbHNlKTsNCisJfQ0KKw0KIAkvKg0KIAkgKiBDaGVjayB3aGV0aGVyIHdlIG5lZWQgdG8gbW92
ZSBidWZmZXIuDQogCSAqLw0KLS0NCjIuMTQuMQ0KDQpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXw0KYW1kLWdmeCBtYWlsaW5nIGxpc3QNCmFtZC1nZnhAbGlz
dHMuZnJlZWRlc2t0b3Aub3JnDQpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL2FtZC1nZngNCg==
