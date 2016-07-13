Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:44063 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751543AbcGMOLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 10:11:36 -0400
From: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
To: "nicolas@ndufresne.ca" <nicolas@ndufresne.ca>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: "kernel@stlinux.com" <kernel@stlinux.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick FERTRE <yannick.fertre@st.com>,
	Hugues FRUCHET <hugues.fruchet@st.com>
Date: Wed, 13 Jul 2016 16:11:05 +0200
Subject: Re: [PATCH v2 2/3] [media] hva: multi-format video encoder V4L2
 driver
Message-ID: <57864BF9.80203@st.com>
References: <1468250057-16395-1-git-send-email-jean-christophe.trotin@st.com>
 <1468250057-16395-3-git-send-email-jean-christophe.trotin@st.com>
 <1468260005.14217.14.camel@ndufresne.ca>
In-Reply-To: <1468260005.14217.14.camel@ndufresne.ca>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQoNCk9uIDA3LzExLzIwMTYgMDg6MDAgUE0sIE5pY29sYXMgRHVmcmVzbmUgd3JvdGU6DQo+IExl
IGx1bmRpIDExIGp1aWxsZXQgMjAxNiDDoCAxNzoxNCArMDIwMCwgSmVhbi1DaHJpc3RvcGhlIFRy
b3RpbiBhIMOpY3JpdCA6DQoNCltzbmlwXQ0KDQo+PiArc3RhdGljIGludCBodmFfZ19mbXRfc3Ry
ZWFtKHN0cnVjdCBmaWxlICpmaWxlLCB2b2lkICpmaCwgc3RydWN0IHY0bDJfZm9ybWF0ICpmKQ0K
Pj4gK3sNCj4+ICsJc3RydWN0IGh2YV9jdHggKmN0eCA9IGZoX3RvX2N0eChmaWxlLT5wcml2YXRl
X2RhdGEpOw0KPj4gKwlzdHJ1Y3QgZGV2aWNlICpkZXYgPSBjdHhfdG9fZGV2KGN0eCk7DQo+PiAr
CXN0cnVjdCBodmFfc3RyZWFtaW5mbyAqc3RyZWFtaW5mbyA9ICZjdHgtPnN0cmVhbWluZm87DQo+
PiArDQo+PiArCWYtPmZtdC5waXgud2lkdGggPSBzdHJlYW1pbmZvLT53aWR0aDsNCj4+ICsJZi0+
Zm10LnBpeC5oZWlnaHQgPSBzdHJlYW1pbmZvLT5oZWlnaHQ7DQo+PiArCWYtPmZtdC5waXguZmll
bGQgPSBWNEwyX0ZJRUxEX05PTkU7DQo+PiArCWYtPmZtdC5waXguY29sb3JzcGFjZSA9IFY0TDJf
Q09MT1JTUEFDRV9TTVBURTE3ME07DQo+DQo+IEhhcmQgY29kaW5nIHRoaXMgaXMgbm90IGdyZWF0
LklkZWFsbHkgdGhlIGNvbG9yaW1ldHJ5IChpZiBub3QgbW9kaWZpZWQpIHNob3VsZCBiZSBjb3Bp
ZWQgZnJvbSBPVVRQVVQgdG8gQ0FQVFVSRSwgeW91IG1heSBhbHNvIHNldCB0aGlzIHRvIFY0TDJf
Q09MT1JTUEFDRV9ERUZBVUxULg0KPg0KDQpOaWNvbGFzLA0KDQpUaGFuayB5b3UgZm9yIHRoZSBy
ZW1hcmsuDQpDb2xvcnNwYWNlIHdhcyBoYXJkLWNvZGVkIGJlY2F1c2Ugb25seSBWNEwyX0NPTE9S
U1BBQ0VfU01QVEUxNzBNIGlzIHN1cHBvcnRlZC4gDQpIb3dldmVyLCBJIHVuZGVyc3RhbmQgdGhh
dCBoYXJkLWNvZGluZyBpcyBub3QgZ3JlYXQ6IEkgd2lsbCBhbGlnbiB0aGUgY29kZSBpbiANCnZl
cnNpb24gMyBvbiB0aGUgY29sb3JzcGFjZSBtYW5hZ2VtZW50IG1hZGUgaW4gdGhlIGNvZGEgZHJp
dmVyLg0KDQpCZXN0IHJlZ2FyZHMsDQpKZWFuLUNocmlzdG9waGUuDQoNCj4+ICsJZi0+Zm10LnBp
eC5waXhlbGZvcm1hdCA9IHN0cmVhbWluZm8tPnN0cmVhbWZvcm1hdDsNCj4+ICsJZi0+Zm10LnBp
eC5ieXRlc3BlcmxpbmUgPSAwOw0KPj4gKwlmLT5mbXQucGl4LnNpemVpbWFnZSA9IGN0eC0+bWF4
X3N0cmVhbV9zaXplOw0KPj4gKw0KPj4gKwlkZXZfZGJnKGRldiwgIiVzIFY0TDIgR19GTVQgKENB
UFRVUkUpOiAlZHglZCBmbXQ6JS40cyBzaXplOiVkXG4iLA0KPj4gKwkJY3R4LT5uYW1lLCBmLT5m
bXQucGl4LndpZHRoLCBmLT5mbXQucGl4LmhlaWdodCwNCj4+ICsJCSh1OCAqKSZmLT5mbXQucGl4
LnBpeGVsZm9ybWF0LCBmLT5mbXQucGl4LnNpemVpbWFnZSk7DQo+PiArCXJldHVybiAwOw0KPj4g
K30NCg0KW3NuaXBd
