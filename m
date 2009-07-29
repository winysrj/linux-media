Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38645 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbZG2WGG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 18:06:06 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	v4l2_linux <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?utf-8?B?w6vCsOKAosOqwrLCvcOrwq/CvA==?=
	<kyungmin.park@samsung.com>,
	"jm105.lee@samsung.com" <jm105.lee@samsung.com>,
	=?utf-8?B?w6zvv73CtMOs4oCewrjDq8Kswrg=?= <semun.lee@samsung.com>,
	=?utf-8?B?w6vFkuKCrMOs77+9wrjDqsK4wrA=?= <inki.dae@samsung.com>,
	=?utf-8?B?w6rCueKCrMOty5zigKLDrMKk4oKs?= <riverful.kim@samsung.com>
Date: Wed, 29 Jul 2009 17:05:49 -0500
Subject: RE: How to save number of times using memcpy?
Message-ID: <A69FA2915331DC488A831521EAE36FE401450FAFD0@dlee06.ent.ti.com>
References: <10799.62.70.2.252.1248852719.squirrel@webmail.xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE401450FAE31@dlee06.ent.ti.com>
 <200907292352.00179.hverkuil@xs4all.nl>
In-Reply-To: <200907292352.00179.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGFucywNCg0KSSBhbSBiaXQgY29uZnVzZWQgYWJvdXQgeW91ciB1c2FnZSBvZiAiZGF2aW5jaSIu
IEFyZSB5b3UgcmVmZXJyaW5nIHRvIHZwZmUgY2FwdHVyZSBkcml2ZXIgYW5kIGRtNjQ2NyBkaXNw
bGF5IGRyaXZlciB2cyBPTUFQID8gSSBrbm93IGF0IGxlYXN0IGluIHRoZXNlIGRyaXZlcnMgaXQg
ZG9lc27igJl0IGFsbG9jYXRlIGJ1ZmZlciBhdCBpbml0IHRpbWUsIGJ1dCBvbmx5IG9uIFJFUUJV
Ri4gSSBuZWVkIHRvIGFkZCB0aGlzIHN1cHBvcnQgKGJ1ZmZlciBhbGxvY2F0aW9uIGF0IGluaXQg
dGltZSkgaW4gdGhlIGRyaXZlci4gT25lIHdheSB0byBhbGxvY2F0ZSBidWZmZXIgaW4gZHJpdmVy
IGF0IGluaXQgdGltZSBpcyB0byB1c2UgZG1hX2RlY2xhcmVfY29oZXJlbnRfbWVtb3J5KCkgYW5k
IHBhc3MgcGh5c2ljYWwgbWVtb3J5IGFkZHJlc3MgKG91dHNpZGUgdGhlIGtlcm5lbCBtZW1vcnkg
c3BhY2UpIHRvIHRoaXMgQVBJLiBJIGFtIG5vdCBhd2FyZSBvZiBhbnkgb3RoZXIgd2F5IG9mIGRv
aW5nIHRoaXMuIFBsZWFzZSBsZXQgbWUga25vdyBJZiB0aGVyZSBhcmUgYWx0ZXJuYXRlIHdheXMg
b2YgZG9pbmcgdGhpcy4NCg0KQWxzbyB3aGljaCBPTUFQIGZpbGUgSSBjYW4gcmVmZXIgdG8gdW5k
ZXJzdGFuZCB0aGUgaW1wbGVtZW50YXRpb24geW91IGFyZSByZWZlcnJpbmcgdG8/DQoNCk11cmFs
aSBLYXJpY2hlcmkNClNvZnR3YXJlIERlc2lnbiBFbmdpbmVlcg0KVGV4YXMgSW5zdHJ1bWVudHMg
SW5jLg0KR2VybWFudG93biwgTUQgMjA4NzQNCmVtYWlsOiBtLWthcmljaGVyaTJAdGkuY29tDQoN
Cj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IGxpbnV4LW1lZGlhLW93bmVyQHZn
ZXIua2VybmVsLm9yZyBbbWFpbHRvOmxpbnV4LW1lZGlhLQ0KPm93bmVyQHZnZXIua2VybmVsLm9y
Z10gT24gQmVoYWxmIE9mIEhhbnMgVmVya3VpbA0KPlNlbnQ6IFdlZG5lc2RheSwgSnVseSAyOSwg
MjAwOSA1OjUyIFBNDQo+VG86IEthcmljaGVyaSwgTXVyYWxpZGhhcmFuDQo+Q2M6IExhdXJlbnQg
UGluY2hhcnQ7IE1hdXJvIENhcnZhbGhvIENoZWhhYjsgRG9uZ3NvbywgTmF0aGFuaWVsIEtpbTsN
Cj52NGwyX2xpbnV4OyBEb25nc29vIEtpbTsgw6vCsOKAosOqwrLCvcOrwq/CvDsgam0xMDUubGVl
QHNhbXN1bmcuY29tOyDDrO+/vcK0w6zigJ7CuMOrwqzCuDsNCj7Dq8WS4oKsw6zvv73CuMOqwrjC
sDsgw6rCueKCrMOty5zigKLDrMKk4oKsDQo+U3ViamVjdDogUmU6IEhvdyB0byBzYXZlIG51bWJl
ciBvZiB0aW1lcyB1c2luZyBtZW1jcHk/DQo+DQo+T24gV2VkbmVzZGF5IDI5IEp1bHkgMjAwOSAy
MTowNjoxNyBLYXJpY2hlcmksIE11cmFsaWRoYXJhbiB3cm90ZToNCj4+IEhhbnMsDQo+Pg0KPj4g
PlRydWUuIEhvd2V2ZXIsIG15IGV4cGVyaWVuY2UgaXMgdGhhdCB0aGlzIGFwcHJvYWNoIGlzbid0
IG5lZWRlZCBpbiBtb3N0DQo+PiA+Y2FzZXMgYXMgbG9uZyBhcyB0aGUgdjRsIGRyaXZlciBpcyBj
b21waWxlZCBpbnRvIHRoZSBrZXJuZWwuIEluIHRoYXQNCj4+ID4gY2FzZSBpdCBpcyBjYWxsZWQg
ZWFybHkgZW5vdWdoIGluIHRoZSBib290IHNlcXVlbmNlIHRoYXQgdGhlcmUgaXMgc3RpbGwNCj4+
ID4gZW5vdWdoIHVuZnJhZ21lbnRlZCBtZW1vcnkgYXZhaWxhYmxlLiBUaGlzIHNob3VsZCBkZWZp
bml0ZWx5IGJlIHRoZQ0KPj4gPiBkZWZhdWx0IGNhc2UgZm9yIGRyaXZlcnMgbWVyZ2VkIGludG8g
djRsLWR2Yi4NCj4+DQo+PiBJbiBteSB1bmRlcnN0YW5kaW5nLCB0aGUgYnVmZmVyIGlzIGFsbG9j
YXRlZCBpbiB0aGUgdmlkZW8gYnVmZmVyIGxheWVyDQo+PiB3aGVuIGRyaXZlciBtYWtlcyB0aGUg
dmlkZW9idWZfcmVxYnVmcygpIGNhbGwuDQo+DQo+VGhhdCBkZXBlbmRzIGNvbXBsZXRlbHkgb24g
dGhlIGRyaXZlciBpbXBsZW1lbnRhdGlvbi4gSW4gdGhlIGNhc2Ugb2YgdGhlDQo+ZGF2aW5jaSBk
cml2ZXIgaXQgd2lsbCBhbGxvY2F0ZSBtZW1vcnkgZm9yIFggYnVmZmVycyB3aGVuIHRoZSBkcml2
ZXIgaXMNCj5maXJzdCBpbml0aWFsaXplZCBhbmQgaXQgd2lsbCB1c2UgdGhvc2Ugd2hlbiB0aGUg
YXBwbGljYXRpb24gY2FsbHMgcmVxYnVmcy4NCj5JZiB0aGUgYXBwIHdhbnRzIG1vcmUgdGhhbiBY
IGJ1ZmZlcnMgdGhlIGRyaXZlciB3aWxsIGF0dGVtcHQgdG8gZHluYW1pY2FsbHkNCj5hbGxvY2F0
ZSBhZGRpdGlvbmFsIGJ1ZmZlcnMsIGJ1dCB0aG9zZSBhcmUgdXN1YWxseSBoYXJkIHRvIG9idGFp
bi4NCj4NCj5JbiBteSBleHBlcmllbmNlIHRoZXJlIGlzIG5vIHByb2JsZW0gZm9yIHRoZSBkcml2
ZXIgdG8gYWxsb2NhdGUgdGhlDQo+cmVxdWlyZWQNCj5tZW1vcnkgaWYgaXQgaXMgZG9uZSBkdXJp
bmcgZHJpdmVyIGluaXRpYWxpemF0aW9uIGFuZCBpZiB0aGUgZHJpdmVyIGlzDQo+Y29tcGlsZWQg
aW50byB0aGUga2VybmVsLg0KPg0KPj4gU2luY2UgdGhpcyBoYXBwZW5zIGFmdGVyDQo+PiB0aGUg
a2VybmVsIGlzIHVwLCB0aGlzIGlzIGluZGVlZCBhIHNlcmlvdXMgaXNzdWUgd2hlbiB3ZSByZXF1
aXJlIEhEDQo+PiByZXNvbHV0aW9uIGJ1ZmZlcnMuIFdoZW4gSSBoYXZlIHRlc3RlZCB2cGZlIGNh
cHR1cmUgZnJvbSBNVDlUMDMxIHdpdGgNCj4+IDIwNDh4MTUzNiByZXNvbHV0aW9uIGJ1ZmZlciwg
dGhlIHZpZGVvIGJ1ZmZlciBsYXllciBnaXZlcyBhbiBvb3BzIGR1ZSB0bw0KPj4gZmFpbHVyZSB0
byBhbGxvY2F0ZSBidWZmZXIoIEkgdGhpbmsgdmlkZW8gYnVmZmVyIGxheWVyIGlzIG5vdCBoYW5k
bGluZw0KPj4gZXJyb3IgY2FzZSB3aGVuIHRoZXJlIGFyZSBub3QgZW5vdWdoIGJ1ZmZlcnMgdG8g
YWxsb2NhdGUpLiBTaW5jZSBidWZmZXINCj4+IGFsbG9jYXRpb24gaGFwcGVucyB2ZXJ5IGxhdGUg
KG5vdCBhdCBpbml0aWFsaXphdGlvbiksIGl0IGlzIHVubGlrZWx5IHRvDQo+PiBzdWNjZWVkIGR1
ZSB0byBmcmFnbWVudGF0aW9uIGlzc3VlLg0KPg0KPlRoYXQgaXMgcmVhbGx5IGEgZHJpdmVyIHBy
b2JsZW06IG9tYXAgc2hvdWxkIHVzZSB0aGUgc2FtZSBhbGxvY2F0aW9uIHNjaGVtZQ0KPmFzIGRh
dmluY2kgZG9lcy4gVGhhdCB3b3JrcyBwcmV0dHkgcmVsaWFibHkuIE9mIGNvdXJzZSwgaWYgc29t
ZW9uZSB0cmllcyB0bw0KPnNxdWVlemUgdGhlIGxhc3QgZHJvcCBvdXQgb2YgdGhlaXIgc3lzdGVt
LCB0aGVuIHRoZXkgc3RpbGwgbWF5IGhhdmUgdG8gdXNlDQo+bmFzdHkgdHJpY2tzIHRvIGdldCBp
dCB0byB3b3JrIChsaWtlIHVzaW5nIHRoZSBtZW09IGtlcm5lbCBvcHRpb24pLiBCdXQNCj5zdWNo
IHRyaWNrcyBhcmUgYSBsYXN0IHJlc29ydCBpbiBteSBvcGluaW9uLg0KPg0KPj4gU28gSSBoYXZl
IGFkZGVkIHN1cHBvcnQgZm9yIFVTRVJQVFINCj4+IElPIGluIHZwZmUgY2FwdHVyZSB0byBoYW5k
bGUgaGlnaCByZXNvbHV0aW9uIGNhcHR1cmUuIFRoaXMgcmVxdWlyZXMgYQ0KPj4ga2VybmVsIG1v
ZHVsZSB0byBhbGxvY2F0ZSBjb250aWd1b3VzIGJ1ZmZlciBhbmQgdGhlIHNhbWUgaXMgcmV0dXJu
ZWQgdG8NCj4+IGFwcGxpY2F0aW9uIHVzaW5nIGFuIElPQ1RMLiBUaGUgcGh5c2ljYWwvbG9naWNh
bCBhZGRyZXNzIGNhbiB0aGVuIGJlDQo+PiBnaXZlbiB0byBkcml2ZXIgdGhyb3VnaCBVU0VSUFRS
IElPLg0KPg0KPldoYXQgZXhhY3RseSBpcyB0aGUgcG9pbnQgb2YgZG9pbmcgdGhpcz8gSSBnYXRo
ZXIgaXQgaXMgdXNlZCB0byBwYXNzIHRoZQ0KPnNhbWUgcGh5c2ljYWwgbWVtb3J5IGZyb20gZS5n
LiBhIGNhcHR1cmUgZGV2aWNlIHRvIGUuZy4gYSByZXNpemVyIGRldmljZSwNCj5yaWdodD8gT3Ro
ZXJ3aXNlIEkgc2VlIG5vIGJlbmVmaXQgdG8gZG9pbmcgdGhpcyBhcyBvcHBvc2VkIHRvIHJlZ3Vs
YXIgbW1hcA0KPkkvTy4NCj4NCj5SZWdhcmRzLA0KPg0KPglIYW5zDQo+DQo+PiBBbm90aGVyIHdh
eSB0aGlzIGNhbiBiZSBkb25lLCB3aGVuIHVzaW5nIG1tYXAgSU8sIGlzIHRvIGFsbG9jYXRlIGRl
dmljZQ0KPj4gbWVtb3J5IChJIGhhdmUgbm90IHRyaWVkIGl0IG15c2VsZiwgYnV0IHRoaXMgc2Vl
bXMgdG8gd29yayBpbiBTT0MgQ2FtZXJhDQo+PiBkcml2ZXJzKSB1c2luZyBkbWFfZGVjbGFyZV9j
b2hlcmVudF9tZW1vcnkoKSAoVGhhbmtzIHRvIEd1ZW5uYWRpDQo+PiBMaWFraG92ZXRza2kgZm9y
IHRoZSBzdWdnZXN0aW9uKS4gVGhpcyBmdW5jdGlvbiB0YWtlcyBwaHlzaWNhbCBtZW1vcnkNCj4+
IGFkZHJlc3Mgb3V0c2lkZSB0aGUga2VybmVsIG1lbW9yeSBzcGFjZS4gVGhlbiB3aGVuIGRtYV9h
bGxvY19jb2hlcmVudCgpDQo+PiBpcyBjYWxsZWQgYnkgdmlkZW8gYnVmZmVyIGxheWVyLCB0aGUg
YnVmZmVyIGlzIGFsbG9jYXRlZCBmcm9tIHRoZSBhYm92ZQ0KPj4gcHJlLWFsbG9jYXRlZCBkZXZp
Y2UgbWVtb3J5IGFuZCB3aWxsIHN1Y2NlZWQgYWx3YXlzLiBCdXQgZm9yIHRoaXMsIHRoZQ0KPj4g
dGFyZ2V0IGFyY2hpdGVjdHVyZSByZXF1aXJlIHN1cHBvcnQgZm9yIGNvbnNpc3RlbnQgbWVtb3J5
IGFsbG9jYXRpb24uDQo+Pg0KPj4gTXVyYWxpDQo+Pg0KPj4gPlJlZ2FyZHMsDQo+PiA+DQo+PiA+
ICAgICAgICBIYW5zDQo+PiA+DQo+PiA+LS0NCj4+ID5IYW5zIFZlcmt1aWwgLSB2aWRlbzRsaW51
eCBkZXZlbG9wZXIgLSBzcG9uc29yZWQgYnkgVEFOREJFUkcNCj4+ID4NCj4+ID4tLQ0KPj4gPlRv
IHVuc3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBsaW5lICJ1bnN1YnNjcmliZSBs
aW51eC1tZWRpYSINCj4+ID4gaW4gdGhlIGJvZHkgb2YgYSBtZXNzYWdlIHRvIG1ham9yZG9tb0B2
Z2VyLmtlcm5lbC5vcmcNCj4+ID5Nb3JlIG1ham9yZG9tbyBpbmZvIGF0ICBodHRwOi8vdmdlci5r
ZXJuZWwub3JnL21ham9yZG9tby1pbmZvLmh0bWwNCj4+DQo+PiAtLQ0KPj4gVG8gdW5zdWJzY3Jp
YmUgZnJvbSB0aGlzIGxpc3Q6IHNlbmQgdGhlIGxpbmUgInVuc3Vic2NyaWJlIGxpbnV4LW1lZGlh
IiBpbg0KPj4gdGhlIGJvZHkgb2YgYSBtZXNzYWdlIHRvIG1ham9yZG9tb0B2Z2VyLmtlcm5lbC5v
cmcNCj4+IE1vcmUgbWFqb3Jkb21vIGluZm8gYXQgIGh0dHA6Ly92Z2VyLmtlcm5lbC5vcmcvbWFq
b3Jkb21vLWluZm8uaHRtbA0KPg0KPg0KPg0KPi0tDQo+SGFucyBWZXJrdWlsIC0gdmlkZW80bGlu
dXggZGV2ZWxvcGVyIC0gc3BvbnNvcmVkIGJ5IFRBTkRCRVJHIFRlbGVjb20NCj4tLQ0KPlRvIHVu
c3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBsaW5lICJ1bnN1YnNjcmliZSBsaW51
eC1tZWRpYSIgaW4NCj50aGUgYm9keSBvZiBhIG1lc3NhZ2UgdG8gbWFqb3Jkb21vQHZnZXIua2Vy
bmVsLm9yZw0KPk1vcmUgbWFqb3Jkb21vIGluZm8gYXQgIGh0dHA6Ly92Z2VyLmtlcm5lbC5vcmcv
bWFqb3Jkb21vLWluZm8uaHRtbA0KDQo=
