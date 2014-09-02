Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:39147 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaIBDQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 23:16:04 -0400
Received: from epcpsbgx4.samsung.com
 (u164.gpu120.samsung.co.kr [203.254.230.164])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NB9003TX7QQ5800@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Sep 2014 12:16:02 +0900 (KST)
Date: Tue, 02 Sep 2014 03:16:01 +0000 (GMT)
From: Changbing Xiong <cb.xiong@samsung.com>
Subject: Re: Re: [PATCH 3/3] media: check status of dmxdev->exit in poll
 functions of demux&dvr
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Reply-to: cb.xiong@samsung.com
MIME-version: 1.0
Content-transfer-encoding: base64
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1309141204.238711409627760764.JavaMail.weblogic@epmlwas04b>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQo+IFdlbGwsIHdlIG1heSBzdGFydCByZXR1cm5pbmcgLUVOT0RFViB3aGVuIHN1Y2ggZXZlbnQg
aGFwcGVucy4gDQoNCj4gQXQgdGhlIGZyb250ZW5kLCB3ZSBjb3VsZCB1c2UgZmUtPmV4aXQgPSBE
VkJfRkVfREVWSUNFX1JFTU9WRUQgdG8NCj4gc2lnbmFsaXplIGl0LiBJIGRvbid0IHRoaW5rIHRo
YXQgdGhlIGRlbW9kIGZyb250ZW5kIGhhcyBzb21ldGhpbmcNCj4gc2ltaWxhci4NCg0KPiBZZXQs
IGl0IHNob3VsZCBiZSB1cCB0byB0aGUgdXNlcnNwYWNlIGFwcGxpY2F0aW9uIHRvIHByb3Blcmx5
IGhhbmRsZSANCj4gdGhlIGVycm9yIGNvZGVzIGFuZCBjbG9zZSB0aGUgZGV2aWNlcyBvbiBmYXRh
bCBub24tcmVjb3ZlcnkgZXJyb3JzIGxpa2UNCj4gRU5PREVWLiANCg0KPiBTbywgd2hhdCB3ZSBj
YW4gZG8sIGF0IEtlcm5lbCBsZXZlbCwgaXMgdG8gYWx3YXlzIHJldHVybiAtRU5PREVWIHdoZW4N
Cj4gdGhlIGRldmljZSBpcyBrbm93biB0byBiZSByZW1vdmVkLCBhbmQgZG91YmxlIGNoZWNrIGxp
YmR2YnY1IGlmIGl0DQo+IGhhbmRsZXMgc3VjaCBlcnJvciBwcm9wZXJseS4NCg0KIHdlbGwsIHdl
IGRvIG5vdCB1c2UgbGliZHZidjUsIGFuZCAgLUVOT0RFViBjYW4gYmUgcmV0dXJuZWQgYnkgcmVh
ZCBzeXNjYWxsLCAgDQpidXQgZm9yIHBvbGwgc3lzY2FsbCwgIC1FTk9ERVYgY2FuIG5ldmVyIGJl
IHJldHVybmVkIHRvIHVzZXIsIGFzIG5lZ2F0aXZlIG51bWJlcg0KIGlzIGludmFsaWQgIHR5cGUg
Zm9yIHBvbGwgcmV0dXJuZWQgdmFsdWUuIHBsZWFzZSByZWZlciB0byBteSBzZWNvbmQgcGF0Y2gu
DQoNCmFuZCBpbiBvdXIgdXNhZ2UsIHdoZXRoZXIgdG8gcmVhZCB0aGUgZGV2aWNlIGlzIHVwIHRv
IHRoZSBwb2xsIHJlc3VsdC4gaWYgdHVuZXIgaXMgcGx1Z2dlZCBvdXQsIA0KYW5kIHRoZXJlIGlz
IG5vIGRhdGEgaW4gZHZyIHJpbmdidWZmZXIuIHRoZW4gdXNlciBjb2RlIHdpbGwgc3RpbGwgZ28g
b24gcG9sbGluZyB0aGUgZHZyIGRldmljZSBhbmQgbmV2ZXIgc3RvcC4NCmlmIFBPTExFUlIgaXMg
cmV0dXJuZWQsIHRoZW4gdXNlciB3aWxsIHBlcmZvcm0gcmVhZCBkdnIsIGFuZCB0aGVuIC1FTk9E
RVYgY2FuIGJlIGdvdCwgYW5kIA0KdXNlciB3aWxsIHN0b3AgcG9sbGluZyBkdnIgZGV2aWNlLg0K
DQp0aGUgZmlyc3QgcGF0Y2ggaXMgZW5vdWdoIHRvIGZpeCB0aGUgZGVhZGxvY2sgaXNzdWUuDQp0
aGUgc2Vjb25kIHBhdGNoIGlzIHVzZWQgdG8gY29ycmVjdCB0aGUgd3JvbmcgdHlwZSBvZiByZXR1
cm5lZCB2YWx1ZS4NCnRoZSB0aGlyZCBwYXRjaCBpcyB1c2VkIHRvIHByb3ZpZGUgdXNlciBhIGJl
dHRlciBjb250cm9sbGluZyBsb2dpYy4NCg0KDQo=


