Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.acens.net ([86.109.99.145]:42034 "EHLO smtp.movistar.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753221AbbA2NDN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 08:03:13 -0500
Message-ID: <54430CAB033428B2@smtp.movistar.es> (added by
	    postmaster@movistar.es)
Date: Thu, 29 Jan 2015 14:03:03 +0100
Subject: RE: [possible BUG, cx23885] Dual tuner TV card, works using one
 tuner only, doesn't work if both tuners are used
From: dCrypt <dcrypt@telefonica.net>
To: James Harper <james@ejbdigital.com.au>
Cc: linux-media@vger.kernel.org,
	" hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VGhhbmsgeW91IGZvciB5b3VyIGNvbW1lbnRzLCBKYW1lcy4gSSdtIHN1cmUgaXQncyBub3QgYSBo
dyBmYXVsdCBiZWNhdXNlIG1pbmUgd29ya3MgaW4gV2luZG93cyBwZXJmZWN0bHksIGFuZCBib3Ro
IHR1bmVycyB1c2VkIGluZGVwZW5kZW50bHkgYWxzbyB3b3JrZWQgaW4gTGludXguIAoKQlJFbCAy
OS8xLzIwMTUgMjozNCwgSmFtZXMgSGFycGVyIDxqYW1lc0BlamJkaWdpdGFsLmNvbS5hdT4gZXNj
cmliacOzOgo+Cj4gPiAKPiA+IEhpLCBKYW1lcy4gCj4gPiAKPiA+IEFmdGVyIHNlYXJjaGluZyBm
b3Igc29tZWJvZHkgcG9zdGluZyBzb21lIGlzc3VlcyBzaW1pbGFyIHRvIG1pbmUsIEkgdGhpbmsg
dGhpcyAKPiA+IG9uZSB5b3UgcG9zdGVkIHRvIHRoZSBtYWlsaW5nIGxpc3QgY2FuIGJlIHJlbGF0
ZWQ6IAo+ID4gCj4gPiBodHRwczovL3d3dy5tYWlsLWFyY2hpdmUuY29tL2xpbnV4LSAKPiA+IG1l
ZGlhJTQwdmdlci5rZXJuZWwub3JnL21zZzgwMDc4Lmh0bWwgCj4gPiAKPiA+IEknbSBoYXZpbmcg
cHJvYmxlbXMgdXNpbmcgYm90aCB0dW5lcnMgaW4gYSBkdWFsIHR1bmVyIGNhcmQgKFRlcnJhdGVj
IENpbmVyZ3kgVCAKPiA+IFBDSWUgRHVhbCksIGFsc28gYmFzZWQgb24gY3gyMzg4NSwgYnV0IGl0
IHVzZXMgZGlmZmVyZW50IGZyb250ZW5kcy90dW5lcnMgCj4gPiB0aGFuIHlvdXJzLiAKPiA+IAo+
Cj4gSSdtIHByZXR0eSBzdXJlIG1pbmUgd2FzIGFuIGFjdHVhbCBoYXJkd2FyZSBmYXVsdC4gQXQg
Zmlyc3QgaXQgd29ya2VkIHBlcmZlY3RseS4gVGhlbiBhZnRlciBhIGJpdCB0aGUgc2VydmVyIHdv
dWxkIG9jY2FzaW9uYWxseSBsb2NrIHVwIGhhcmQgb3IgcmVib290LCB0aGVuIG1vcmUgb2Z0ZW4s
IHRoZW4gZXZlcnkgdGltZS4gSSBzcGVudCBhZ2VzIHRoaW5raW5nIGl0IHdhcyBhIGRyaXZlciBw
cm9ibGVtIGFuZCBkaWQgYWxsIHNvcnRzIG9mIHRyYWNlcyBldGMgYW5kIGZvdW5kIG5vdGhpbmcu
IEluIHRoZSBlbmQgSSBqdXN0IGdvdCBteXRodHYgdG8gbm90IHVzZSB0aGUgc2Vjb25kIHR1bmVy
IChvciB0aGUgZmlyc3QgdHVuZXIgLSBhcyBsb25nIGFzIG9ubHkgb25lIHdhcyB1c2VkIGl0IHdh
cyBmaW5lKS4gCj4KPiBUaGVuIGFib3V0IGEgbW9udGggYWdvIGl0IHN0YXJ0ZWQgbG9ja2luZyB1
cCBhZ2FpbiBvY2Nhc2lvbmFsbHksIHRoZW4gbW9yZSBvZnRlbiwgdGhlbiBldmVyeSB0aW1lLCBv
bmx5IHVzaW5nIHRoZSBvbmUgdHVuZXIuIFN0cmFuZ2UgdGhvdWdoIHRoYXQgaWYgaXQgYm9vdGVk
IHVwIHdpdGhvdXQgbG9ja2luZyB1cCBpdCB3b3VsZCBiZSBva2F5LiAKPgo+IEkgYm91Z2h0IGEg
dXNiIHR1bmVyIGFuZCBoYXZlbid0IHVzZWQgdGhlIGN4MjM4ODUgY2FyZCBzaW5jZS4gCj4KPiBJ
IHdpbGwgYmUgc2Vla2luZyBhIHJlcGxhY2VtZW50IHVuZGVyIHdhcnJhbnR5IHRob3VnaCwgYXMg
dGhlIHNpZ25hbCBxdWFsaXR5IGlzIHF1aXRlIGEgYml0IGJldHRlci4gCj4KPiBHb29kIGx1Y2sg
aW4geW91ciBxdWVzdCB0aG91Z2ghIAo+Cj4gSmFtZXMgCj4K

