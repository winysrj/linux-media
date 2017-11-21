Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:38317 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751496AbdKUIrv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 03:47:51 -0500
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Vasyl Gomonovych <gomonovych@gmail.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] c8sectpfe: Use resource_size function on memory
 resource
Date: Tue, 21 Nov 2017 08:47:21 +0000
Message-ID: <1d30b010-96b1-cf98-d98f-8c804631fb80@st.com>
References: <1511218007-3577-1-git-send-email-gomonovych@gmail.com>
In-Reply-To: <1511218007-3577-1-git-send-email-gomonovych@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE4F7793A12BC14E919B8E1F21F50383@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgVmFzeWwNCg0KT24gMTEvMjAvMjAxNyAxMTo0NiBQTSwgVmFzeWwgR29tb25vdnljaCB3cm90
ZToNCj4gVG8gYWRhcHQgZmVpLT5zcmFtX3NpemUgY2FsY3VsYXRpb24gdmlhIHJlc291cmNlX3Np
emUgZm9yIG1lbW9yeSBzaXplDQo+IGNhbGN1bGF0aW9uIGJlZm9yZSwgaW4gZmVpLT5zcmFtID0g
ZGV2bV9pb3JlbWFwX3Jlc291cmNlKGRldiwgcmVzKS4NCj4gQW5kIG1ha2UgbWVtb3J5IGluaXRp
YWxpemF0aW9uIHJhbmdlIGluDQo+IG1lbXNldF9pbyBmb3IgZmVpLT5zcmFtIGFwcHJvcHJpYXRl
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBWYXN5bCBHb21vbm92eWNoIDxnb21vbm92eWNoQGdtYWls
LmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdGkvYzhzZWN0cGZlL2M4
c2VjdHBmZS1jb3JlLmMgfCAyICstDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9wbGF0Zm9y
bS9zdGkvYzhzZWN0cGZlL2M4c2VjdHBmZS1jb3JlLmMgYi9kcml2ZXJzL21lZGlhL3BsYXRmb3Jt
L3N0aS9jOHNlY3RwZmUvYzhzZWN0cGZlLWNvcmUuYw0KPiBpbmRleCA1OTI4MGFjMzE5MzcuLjI4
M2Y3Mjg5YWFhMSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdGkvYzhz
ZWN0cGZlL2M4c2VjdHBmZS1jb3JlLmMNCj4gKysrIGIvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9z
dGkvYzhzZWN0cGZlL2M4c2VjdHBmZS1jb3JlLmMNCj4gQEAgLTY5MSw3ICs2OTEsNyBAQCBzdGF0
aWMgaW50IGM4c2VjdHBmZV9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAg
IAlpZiAoSVNfRVJSKGZlaS0+c3JhbSkpDQo+ICAgCQlyZXR1cm4gUFRSX0VSUihmZWktPnNyYW0p
Ow0KPiAgIA0KPiAtCWZlaS0+c3JhbV9zaXplID0gcmVzLT5lbmQgLSByZXMtPnN0YXJ0Ow0KPiAr
CWZlaS0+c3JhbV9zaXplID0gcmVzb3VyY2Vfc2l6ZShyZXMpOw0KPiAgIA0KPiAgIAlmZWktPmlk
bGVfaXJxID0gcGxhdGZvcm1fZ2V0X2lycV9ieW5hbWUocGRldiwgImM4c2VjdHBmZS1pZGxlLWly
cSIpOw0KPiAgIAlpZiAoZmVpLT5pZGxlX2lycSA8IDApIHsNCj4gDQoNCkFja2VkLWJ5OiBQYXRy
aWNlIENob3RhcmQgPHBhdHJpY2UuY2hvdGFyZEBzdC5jb20+DQoNClRoYW5rcw==
