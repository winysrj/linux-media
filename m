Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:43617 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725935AbeIXOMR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 10:12:17 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        jacopo mondi <jacopo@jmondi.org>
CC: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v3 0/5] Fix OV5640 exposure & gain
Date: Mon, 24 Sep 2018 08:11:12 +0000
Message-ID: <d4003b8a-8438-39cb-6e72-6a16a589cc06@st.com>
References: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
 <20180914160712.GD16851@w540>
 <20180915230229.ivldwawzwignkbxv@kekkonen.localdomain>
 <20180917074505.GE16851@w540>
 <20180917114013.qwl4k644er2tuvad@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180917114013.qwl4k644er2tuvad@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EBDE395E14A19459D8471A9B3565E3E@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TWFueSB0aGFua3MgZm9yIHRoaXMgd29yayBKYWNvcG8gYW5kIFNha2FyaSwNCg0KT24gbXkgc2lk
ZSBJJ3ZlIG1hZGUgc29tZSBvdGhlciBpbXByb3ZlbWVudHMvZml4ZXMgb24gT1Y1NjQwIHRoYXQg
SSB3aWxsIA0KcHVzaCBpbiB0aGUgY29taW5nIGRheXMuDQoNCkJSLA0KSHVndWVzLg0KDQpPbiAw
OS8xNy8yMDE4IDAxOjQwIFBNLCBTYWthcmkgQWlsdXMgd3JvdGU6DQo+IE9uIE1vbiwgU2VwIDE3
LCAyMDE4IGF0IDA5OjQ3OjE5QU0gKzAyMDAsIGphY29wbyBtb25kaSB3cm90ZToNCj4+IEhpIFNh
a2FyaSwNCj4+ICAgICAgICAgIHRoYW5rcyBmb3IgaGFuZGxpbmcgdGhpcw0KPj4NCj4+IE9uIFN1
biwgU2VwIDE2LCAyMDE4IGF0IDAyOjAyOjMwQU0gKzAzMDAsIFNha2FyaSBBaWx1cyB3cm90ZToN
Cj4+PiBIaSBKYWNvcG8sIEh1Z3VlcywNCj4+Pg0KPj4+IE9uIEZyaSwgU2VwIDE0LCAyMDE4IGF0
IDA2OjA3OjEyUE0gKzAyMDAsIGphY29wbyBtb25kaSB3cm90ZToNCj4+Pj4gSGkgU2FrYXJpLA0K
Pj4+Pg0KPj4+PiBPbiBUdWUsIFNlcCAxMSwgMjAxOCBhdCAwMzo0ODoxNlBNICswMjAwLCBIdWd1
ZXMgRnJ1Y2hldCB3cm90ZToNCj4+Pj4+IFRoaXMgcGF0Y2ggc2VyaWUgZml4ZXMgc29tZSBwcm9i
bGVtcyBhcm91bmQgZXhwb3N1cmUgJiBnYWluIGluIE9WNTY0MCBkcml2ZXIuDQo+Pj4+DQo+Pj4+
IEFzIHlvdSBvZmZlcmVkIHRvIGNvbGxlY3QgdGhpcyBzZXJpZXMgYW5kIG15IENTSS0yIGZpeGVz
IEkgaGF2ZSBqdXN0DQo+Pj4+IHJlLXNlbnQsIHlvdSBtaWdodCBiZSBpbnRlcmVzdGVkIGluIHRo
aXMgYnJhbmNoOg0KPj4+Pg0KPj4+PiBnaXQ6Ly9qbW9uZGkub3JnL2xpbnV4DQo+Pj4+IGVuZ2lj
YW0taW14NnEvbWVkaWEtbWFzdGVyL292NTY0MC9jc2kyX2luaXRfdjRfZXhwb3N1cmVfdjMNCj4+
Pj4NCj4+Pj4gSSBoYXZlIHRoZXJlIHJlLWJhc2VkIHRoaXMgc2VyaWVzIG9uIHRvcCBvZiBtaW5l
LCB3aGljaCBpcyBpbiB0dXJuDQo+Pj4+IGJhc2VkIG9uIGxhdGVzdCBtZWRpYSBtYXN0ZXIsIHdo
ZXJlIHRoaXMgc2VyaWVzIGRvIG5vdCBhcHBseSBhcy1pcw0KPj4+PiBhZmFpY3QuDQo+Pj4+DQo+
Pj4+IEkgaGF2ZSBhZGRlZCB0byBIdWd1ZXMnIHBhdGNoZXMgbXkgcmV2aWV3ZWQtYnkgYW5kIHRl
c3RlZC1ieSB0YWdzLg0KPj4+PiBJZiB5b3UgcHJlZmVyIHRvIEkgY2FuIHNlbmQgeW91IGEgcHVs
bCByZXF1ZXN0LCBvciBpZiB5b3Ugd2FudCB0byBoYXZlDQo+Pj4+IGEgY2hhbmNlIHRvIHJldmll
dyB0aGUgd2hvbGUgcGF0Y2ggbGlzdCBwbGVhc2UgcmVmZXIgdG8gdGhlIGFib3ZlDQo+Pj4+IGJy
YW5jaC4NCj4+Pj4NCj4+Pj4gTGV0IG1lIGtub3cgaWYgSSBjYW4gaGVscCBzcGVlZGluZyB1cCB0
aGUgaW5jbHVzaW9uIG9mIHRoZXNlIHR3bw0KPj4+PiBzZXJpZXMgYXMgdGhleSBmaXggdHdvIHJl
YWwgaXNzdWVzIG9mIE1JUEkgQ1NJLTIgY2FwdHVyZSBvcGVyYXRpb25zDQo+Pj4+IGZvciB0aGlz
IHNlbnNvci4NCj4+Pg0KPj4+IEkndmUgcHVzaGVkIHRoZSBwYXRjaGVzIGhlcmU6DQo+Pj4NCj4+
PiA8VVJMOmh0dHBzOi8vZ2l0LmxpbnV4dHYub3JnL3NhaWx1cy9tZWRpYV90cmVlLmdpdC9sb2cv
P2g9Zm9yLTQuMjAtNT4NCj4+Pg0KPj4+IFRoZXJlIHdhcyBhIG1lcmdlIGNvbW1pdCBhbmQgYSBm
ZXcgZXh0cmEgcGF0Y2hlcyBpbiB5b3VyIHRyZWU7IEkgdGhyZXcgdGhlbQ0KPj4+IG91dC4gOi0p
DQo+Pg0KPj4gWWVhaCwgdGhvc2UgYXJlIGEgZmV3IHBhdGNoZXMgSSBuZWVkIGZvciBteSB0ZXN0
aW5nIHBsYXRmb3JtLi4uIEZvcmdvdCB0bw0KPj4gcmVtb3ZlIHRoZW0sIGhvcGUgeW91IGRpZG4n
dCBzcGVuZCB0b28gbXVjaCB0aW1lIG9uIHRoaXMuDQo+IA0KPiBObywgaXQgd2FzIHJhdGhlciBl
YXN5IHRvIHJlbW92ZSB0aGVtLiBJJ3ZlIHNlbnQgYSBwdWxsIHJlcXVlc3Qgb24gdGhlc2U6DQo+
IA0KPiA8VVJMOmh0dHBzOi8vcGF0Y2h3b3JrLmxpbnV4dHYub3JnL3BhdGNoLzUyMDkxLz4NCj4g
