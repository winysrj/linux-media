Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.25]:40971 "EHLO mgw-da03.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab3LFAI2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Dec 2013 19:08:28 -0500
From: <ext-eero.1.nurkkala@here.com>
To: <nils.faerber@kernelconcepts.de>, <pali.rohar@gmail.com>,
	<hverkuil@xs4all.nl>, <m.chehab@samsung.com>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<joni.lapilainen@gmail.com>, <freemangordon@abv.bg>,
	<pavel@ucw.cz>, <aaro.koskinen@iki.fi>
Subject: RE: [PATCH] media: Add BCM2048 radio driver
Date: Thu, 5 Dec 2013 20:03:52 +0000
Message-ID: <FD9B7CFF0C2EA64D911C748F7B8329910B4191D8@008-AM1MPN1-024.mgdnok.nokia.com>
References: <1381847218-8408-1-git-send-email-pali.rohar@gmail.com>
 <201312022151.07599@pali> <52A030BE.7040709@xs4all.nl>
 <201312051420.56852@pali>
 <20131205135705.GA3969@earth.universe>,<52A08795.3010809@kernelconcepts.de>
In-Reply-To: <52A08795.3010809@kernelconcepts.de>
Content-Language: en-US
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cj4gRnJvbTogZXh0IE5pbHMgRmFlcmJlciBbbmlscy5mYWVyYmVyQGtlcm5lbGNvbmNlcHRzLmRl
XQo+IFNlbnQ6IFRodXJzZGF5LCBEZWNlbWJlciAwNSwgMjAxMyA0OjAzIFBNCj4gVG86IFBhbGkg
Um9oqKJyOyBIYW5zIFZlcmt1aWw7IE1hdXJvIENhcnZhbGhvIENoZWhhYjsgbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZzsgbGludXgtbWVkaWFAdmdlci5rZXJuZWwub3JnOyBOdXJra2FsYSBF
ZXJvLjEgKEVYVC1IYWx0aWFuL091bHUpOyBKb25pIExhcGlsYWluZW47IKeqp9On0afbp92n4CCn
pafap96n2qfkp+Kn4KfTOyBQYXZlbCBNYWNoZWs7IGFhcm8ua29za2luZW5AaWtpLmZpCj4gU3Vi
amVjdDogUmU6IFtQQVRDSF0gbWVkaWE6IEFkZCBCQ00yMDQ4IHJhZGlvIGRyaXZlcgo+Cj4gQW0g
MDUuMTIuMjAxMyAxNDo1Nywgc2NocmllYiBTZWJhc3RpYW4gUmVpY2hlbDoKPj4gT24gVGh1LCBE
ZWMgMDUsIDIwMTMgYXQgMDI6MjA6NTZQTSArMDEwMCwgUGFsaSBSb2ioonIgd3JvdGU6Cj4+Pj4g
QW55d2F5LCBJJ3ZlIHBvc3RlZCB0aGUgcHVsbCByZXF1ZXN0LiBQbGVhc2Ugbm90ZSwgaWYgeW91
IHdhbnQKPj4+PiB0byBhdm9pZCBoYXZpbmcgdGhpcyBkcml2ZXIgYmUgcmVtb3ZlZCBhZ2FpbiBp
biB0aGUgZnV0dXJlLAo+Pj4+IHRoZW4geW91IChvciBzb21lb25lIGVsc2UpIHNob3VsZCB3b3Jr
IG9uIGFkZHJlc3NpbmcgdGhlCj4+Pj4gaXNzdWVzIGluIHRoZSBUT0RPIGZpbGUgSSBhZGRlZC4K
Pj4+Cj4+PiBPay4gQ0Npbmcgb3RoZXIgcGVvcGxlIHdobyB3b3JrcyB3aXRoIG45MDAga2VybmVs
Lgo+Pgo+PiBEb2VzIHRoZSBiY20yMDQ4J3MgcmFkaW8gcGFydCB3b3JrIHdpdGhvdXQgdGhlIGJs
dWV0b290aCBkcml2ZXI/Cj4KCkhlbGxvIGFsbCwKSSByZWNhbGwgdGhhdCBpcyBkb2Vzbid0IHdv
cmsgc2VwYXJhdGVseSwgYnV0IGluc3RlYWQsIGl0IGhhZCB0byBiZSBwb3dlcmVkCm9uIHZpYSBh
IHNlcGFyYXRlIGhjaSBjb21tYW5kLiBJIGRvbid0IHJlbWVtYmVyIHdoYXQgaXQgd2FzIHRob3Vn
aC4KQnV0IGFnYWluIGl0IG1heWJlIGhhZCB0byBkbyB3aXRoIHRoZSBjb25maWd1cmF0aW9uIG9m
IHRoZSBCVC4gQW55d2F5LApieSBoYXZpbmcgbm8gQlQgZHJpdmVyIGF0IGFsbCB3b3VsZCBtYWtl
IGl0IGltcG9zc2libGUgdG8gdXNlIHRoZSByYWRpbyBhbG9uZS4KCi0gRWVybwoKPiBBdCBsZWFz
dCBJIGRvIG5vdCBrbm93Lgo+IEkganVzdCBhZGRlZCB0aGUgUkRTIGRhdGEgaW50ZXJmYWNlLCBJ
IGhhdmUgbm8gaWRlYSBvZiBhYm91dCB0aGUKPiBoYXJkd2FyZSBhbmQgdGhlIG90aGVyIHBhcnRz
IG9mIGl0LCBzb3JyeS4KPgo+PiAtLSBTZWJhc3RpYW4KPiBDaGVlcnMKPiAgbmlscwo+Cj4gLS0K
PiBrZXJuZWwgY29uY2VwdHMgR21iSCAgICAgICBUZWw6ICs0OS0yNzEtNzcxMDkxLTEyCj4gU2ll
Z2h1ZXR0ZXIgSGF1cHR3ZWcgNDgKPiBELTU3MDcyIFNpZWdlbiAgICAgICAgICAgICBNb2I6ICs0
OS0xNzYtMjEwMjQ1MzUKPiBodHRwOi8vd3d3Lmtlcm5lbGNvbmNlcHRzLmRlCgo=
