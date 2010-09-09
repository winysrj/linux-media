Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:42492 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab0IIOmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 10:42:07 -0400
Date: Thu, 09 Sep 2010 10:41:55 -0400
Subject: Re: [PATCH] Illuminators and status LED controls
Message-ID: <e3kwq01m3v9rvkx9fdhst6mo.1284042856851@email.android.com>
From: Andy Walls <awalls@md.metrocast.net>
To: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
	Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

SGFucyBkZSBHb2VkZSwKClRoZSB1dmMgQVBJIHRoYXQgY3JlYXRlcyB2NGwyIGN0cmxzIG9uIGJl
aGFsZiBvZiB1c2Vyc3BhY2UgY291bGQgaW50ZXJjZXB0IHRob3NlIGNhbGxzIGFuZCBjcmVhdGUg
YW4gTEVEIGludGVyZmFjZSBpbnN0ZWFkIG9mLCBvciBpbiBhZGRpdGlvbiB0bywgdGhlIHY0bDIg
Y3RybC4KClVudGlsIHVkZXYsIGhhbCwgcGFtLCBhbmQgcG9sa2l0IHVzZXJzcGFjZSBjb25maWd1
cmF0aW9ucyBjYXRjaCB1cCwgb25lIHN0aWxsIGhhcyB0aGUgcHJvYmxlbSBvZiB0aGUgc3lzZnMg
TEVEIGZpbGVzIG5vdCBiZWluZyB1c2FibGUgYnkgdGhlIHVzZXIgZHVlIHRvIHBlcm1pc3Npb25z
LgoKUmVnYXJkcywKQW5keQoKSGFucyBkZSBHb2VkZSA8aGRlZ29lZGVAcmVkaGF0LmNvbT4gd3Jv
dGU6Cgo+SGksCj4KPk9uIDA5LzA5LzIwMTAgMDM6MjkgUE0sIEhhbnMgVmVya3VpbCB3cm90ZToK
Pj4KPj4+IEhpLAo+Pj4KPj4+IE9uIDA5LzA5LzIwMTAgMDg6NTUgQU0sIFBldGVyIEtvcnNnYWFy
ZCB3cm90ZToKPj4+Pj4+Pj4+ICJIYW5zIiA9PSBIYW5zIFZlcmt1aWw8aHZlcmt1aWxAeHM0YWxs
Lm5sPiAgIHdyaXRlczoKPj4+Pgo+Pj4+IEhpLAo+Pj4+Cj4+Pj4gICAgPj4gICAtIHRoZSBzdGF0
dXMgTEVEIHNob3VsZCBiZSBjb250cm9sbGVkIGJ5IHRoZSBMRUQgaW50ZXJmYWNlLgo+Pj4+Cj4+
Pj4gICAgSGFucz4gICBJIG9yaWdpbmFsbHkgd2FzIGluIGZhdm9yIG9mIGNvbnRyb2xsaW5nIHRo
ZXNlIHRocm91Z2ggdjRsIGFzCj4+Pj4gICAgSGFucz4gICB3ZWxsLCBidXQgcGVvcGxlIG1hZGUg
c29tZSBnb29kIGFyZ3VtZW50cyBhZ2FpbnN0IHRoYXQuIFRoZQo+Pj4+IG1haW4KPj4+PiAgICBI
YW5zPiAgIG9uZSBiZWluZzogd2h5IHdvdWxkIHlvdSB3YW50IHRvIHNob3cgdGhlc2UgYXMgYSBj
b250cm9sPyBXaGF0Cj4+Pj4gaXMKPj4+PiAgICBIYW5zPiAgIHRoZSBlbmQgdXNlciBzdXBwb3Nl
ZCB0byBkbyB3aXRoIHRoZW0/IEl0IG1ha2VzIGxpdHRsZSBzZW5zZS4KPj4+Pgo+Pj4+ICAgIEhh
bnM+ICAgRnJhbmtseSwgd2h5IHdvdWxkIHlvdSB3YW50IHRvIGV4cG9zZSBMRURzIGF0IGFsbD8g
U2hvdWxkbid0Cj4+Pj4gdGhpcwo+Pj4+ICAgIEhhbnM+ICAgYmUgY29tcGxldGVseSBoaWRkZW4g
YnkgdGhlIGRyaXZlcj8gTm8gZ2VuZXJpYyBhcHBsaWNhdGlvbiB3aWxsCj4+Pj4gICAgSGFucz4g
ICBldmVyIGRvIGFueXRoaW5nIHdpdGggc3RhdHVzIExFRHMgYW55d2F5LiBTbyBpdCBzaG91bGQg
YmUgdGhlCj4+Pj4gICAgSGFucz4gICBkcml2ZXIgdGhhdCBvcGVyYXRlcyB0aGVtIGFuZCBpbiB0
aGF0IGNhc2UgdGhlIExFRHMgZG8gbm90IG5lZWQKPj4+PiAgICBIYW5zPiAgIHRvIGJlIGV4cG9z
ZWQgYW55d2hlcmUuCj4+Pj4KPj4+PiBJdCdzIG5vdCB0aGF0IGl0ICpIQVMqIHRvIGJlIGV4cG9z
ZWQgLSBCdXQgaWYgd2UgY2FuLCB0aGVuIGl0J3MgbmljZSB0bwo+Pj4+IGRvCj4+Pj4gc28gYXMg
aXQgZ2l2ZXMgZmxleGliaWxpdHkgdG8gdGhlIHVzZXIgaW5zdGVhZCBvZiBoYXJkY29kaW5nIHBv
bGljeSBpbgo+Pj4+IHRoZSBrZXJuZWwuCj4+Pj4KPj4+Cj4+PiBSZWFkaW5nIHRoaXMgd2hvbGUg
dGhyZWFkIEkgaGF2ZSB0byBhZ3JlZSB0aGF0IGlmIHdlIGFyZSBnb2luZyB0byBleHBvc2UKPj4+
IGNhbWVyYSBzdGF0dXMgTEVEcyBpdCB3b3VsZCBiZSBkb25lIHRocm91Z2ggdGhlIHN5c2ZzIEFQ
SS4gSSB0aGluayB0aGlzCj4+PiBjYW4gYmUgZG9uZSBuaWNlbHkgZm9yIGdzcGNhIGJhc2VkIGRy
aXZlcnMgKGFzIHdlIGNhbiBwdXQgYWxsIHRoZSAiY3J1ZCIKPj4+IGluIHRoZSBnc3BjYSBjb3Jl
IGhhdmluZyB0byBkbyBpdCBvbmx5IG9uY2UpLCBidXQgdGhhdCBpcyBhIGxvdyBwcmlvcml0eQo+
Pj4gbmljZSB0byBoYXZlIHRoaW5neS4KPj4+Cj4+PiBUaGlzIGRvZXMgbGVhdmUgdXMgd2l0aCB0
aGUgcHJvYmxlbSBvZiBsb2dpdGVjaCB1dmMgY2FtcyB3aGVyZSB0aGUgTEVECj4+PiBjdXJyZW50
bHkgaXMgZXhwb3NlZCBhcyBhIHY0bDIgY29udHJvbC4KPj4KPj4gSXMgaXQgcG9zc2libGUgZm9y
IHRoZSB1dmMgZHJpdmVyIHRvIGRldGVjdCBhbmQgdXNlIGEgTEVEIGNvbnRyb2w/IFRoYXQncwo+
PiBob3cgSSB3b3VsZCBleHBlY3QgdGhpcyB0byB3b3JrLCBidXQgSSBrbm93IHRoYXQgdXZjIGlz
IGEgYml0IG9mIGEgc3RyYW5nZQo+PiBiZWFzdC4KPj4KPgo+VW5mb3J0dW5hdGVseSBubywgc29t
ZSB1dmMgY2FtZXJhcyBoYXZlICJwcm9wcmlldGFyeSIgY29udHJvbHMuIFRoZSB1dmMgZHJpdmVy
Cj5rbm93cyBub3RoaW5nIGFib3V0IHRoZXNlIGJ1dCBvZmZlcnMgYW4gQVBJIHRvIG1hcCB0aGVz
ZSB0byB2NGwyIGNvbnRyb2xzCj4od2hlcmUgdXNlcnNwYWNlIHRlbGxzIGl0IHRoZSB2NGwyIGNp
ZCwgdHlwZSwgbWluLCBtYXgsIGV0Yy4pLgo+Cj5DdXJyZW50bHkgb24gbG9naXRlY2ggY2FtZXJh
cyB0aGUgdXNlcnNwYWNlIHRvb2xzIGlmIGluc3RhbGxlZCB3aWxsIG1hcAo+dGhlIGxlZCBjb250
cm9sIHRvIGEgcHJpdmF0ZSB2NGwyIG1lbnUgY29udHJvbCB3aXRoIHRoZSBmb2xsb3dpbmcgb3B0
aW9uczoKPk9uCj5PZmYKPkF1dG8KPkJsaW5rCj4KPlRoZSBjYW1lcmFzIGRlZmF1bHQgdG8gYXV0
bywgd2hlcmUgdGhlIGxlZCBpcyB0dXJuZWQgb24gd2hlbiB2aWRlbwo+aXMgYmVpbmcgc3RyZWFt
ZWQgYW5kIG9mZiB3aGVuIHRoZXJlIGlzIG5vIHN0cmVhbWluZyBnb2luZyBvbi4KPgo+UmVnYXJk
cywKPgo+SGFucwo=

