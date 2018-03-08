Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:50621 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935804AbeCHPKD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 10:10:03 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH] media: ov5640: fix frame interval enumeration
Date: Thu, 8 Mar 2018 15:09:48 +0000
Message-ID: <7063d150-3697-5de6-467d-a514bdeb2c9e@st.com>
References: <1520499719-23955-1-git-send-email-hugues.fruchet@st.com>
 <20180308073909.6c1e0ac9@vento.lan> <20180308074601.77c9e7c1@vento.lan>
In-Reply-To: <20180308074601.77c9e7c1@vento.lan>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D5152179AF81D408AA3B3E9E33CBBCB@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgTWF1cm8sDQoNClRoYW5rcyBmb3IgcmV2aWV3LCBJJ3ZlIGp1c3Qgc2VudCBhIHYyIHRvIHJl
YXJyYW5nZSBjb2RlIGFzIHBlciB5b3VyIA0Kc3VnZ2VzdGlvbiBhbmQgYWxzbyBhZGQgYSBOVUxM
IHRlc3QgY2FzZSBmb3IgbW9kZSBldmVuIGlmIHRoaXMgc2hvdWxkIA0Kbm90IGhhcHBlbi4NCg0K
QmVzdCByZWdhcmRzLA0KSHVndWVzLg0KDQpPbiAwMy8wOC8yMDE4IDExOjQ2IEFNLCBNYXVybyBD
YXJ2YWxobyBDaGVoYWIgd3JvdGU6DQo+IEVtIFRodSwgOCBNYXIgMjAxOCAwNzozOTowOSAtMDMw
MA0KPiBNYXVybyBDYXJ2YWxobyBDaGVoYWIgPG1jaGVoYWJAa2VybmVsLm9yZz4gZXNjcmV2ZXU6
DQo+IA0KPj4gQWxzbywgaWYgdGhpcyBmdW5jdGlvbiBzdGFydHMgcmV0dXJuaW5nIE5VTEwsIEkg
c3VzcGVjdCB0aGF0IHlvdSBhbHNvDQo+PiBuZWVkIHRvIGNoYW5nZSBvdjU2NDBfc19mcmFtZV9p
bnRlcnZhbCgpLCBhcyBjdXJyZW50bHkgaXQgaXMgY2FsbGVkDQo+PiBhdCBvdjU2NDBfc19mcmFt
ZV9pbnRlcnZhbCgpIGFzOg0KPj4NCj4+IAlzZW5zb3ItPmN1cnJlbnRfbW9kZSA9IG92NTY0MF9m
aW5kX21vZGUoc2Vuc29yLCBmcmFtZV9yYXRlLCBtb2RlLT53aWR0aCwNCj4+IAkJCQkJCW1vZGUt
PmhlaWdodCwgdHJ1ZSk7DQo+Pg0KPj4gd2l0aG91dCBjaGVja2luZyBpZiB0aGUgcmV0dXJuZWQg
dmFsdWUgaXMgTlVMTC4gU2V0dGluZw0KPj4gY3VycmVudF9tb2RlIHRvIE5VTEwgY2FuIGNhdXNl
IG9vcHNlcyBhdCBvdjU2NDBfc2V0X21vZGUoKS4NCj4gDQo+IEFjdHVhbGx5LCBhcyBvdjU2NDBf
c19mcmFtZV9pbnRlcnZhbCgpIGNhbGxzIG92NTY0MF90cnlfZm10X2ludGVybmFsKCkNCj4gZmly
c3QuIFNvLCB0aGlzIHNob3VsZCBuZXZlciBoYXBwZW4uDQo+IA0KPiANCj4gVGhhbmtzLA0KPiBN
YXVybw0KPiA=
