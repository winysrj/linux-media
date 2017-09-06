Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:32161 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751814AbdIFH7K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Sep 2017 03:59:10 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4l-utils] configure.ac: drop --disable-libv4l, disable
 plugin support instead
Date: Wed, 6 Sep 2017 07:59:06 +0000
Message-ID: <cf9649ce-2205-881b-12b6-560b1d1641cc@st.com>
References: <20170821210206.21055-1-thomas.petazzoni@free-electrons.com>
 <eb9e0ad2-1003-f861-9cc0-7bdb77939af8@xs4all.nl>
 <20170902152913.437413aa@windsurf.lan>
In-Reply-To: <20170902152913.437413aa@windsurf.lan>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A7B21FE2C911E42A66364D4166A7CA8@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgYWxsLA0KDQpUaGFua3MgVGhvbWFzIGZvciB0aGUgcGF0Y2ggYW5kIHNvcnJ5IGZvciBkZWxh
eSwgdGVzdGVkIE9LIG9uIG15IHNpZGUgDQp3aXRoIFNUTTMyRjQyOUktRVZBTCBib2FyZCBydW5u
aW5nIG5vLU1NVSBTVE0zMkY0MjkgY2hpcC4NCg0KVGVzdGVkLWJ5OiBIdWd1ZXMgRnJ1Y2hldCA8
aHVndWVzLmZydWNoZXRAc3QuY29tPg0KDQpPbiAwOS8wMi8yMDE3IDAzOjI5IFBNLCBUaG9tYXMg
UGV0YXp6b25pIHdyb3RlOg0KPiBIZWxsbywNCj4gDQo+IE9uIFdlZCwgMjMgQXVnIDIwMTcgMTM6
MDY6MTMgKzAyMDAsIEhhbnMgVmVya3VpbCB3cm90ZToNCj4+IE9uIDA4LzIxLzE3IDIzOjAyLCBU
aG9tYXMgUGV0YXp6b25pIHdyb3RlOg0KPj4+IEluIGNvbW1pdCAyZTYwNGRmYmNkMDliOTNmMDgw
OGNlZGIyYTBiMzI0YzU1NjlhNTk5ICgiY29uZmlndXJlLmFjOiBhZGQNCj4+PiAtLWRpc2FibGUt
bGlidjRsIG9wdGlvbiIpLCBhbiBvcHRpb24gLS1kaXNhYmxlLWxpYnY0bCB3YXMgYWRkZWQuIEFz
DQo+Pj4gcGFydCBvZiB0aGlzLCBsaWJ2NGwgaXMgbm8gbG9uZ2VyIGJ1aWx0IGF0IGFsbCBpbiBz
dGF0aWMgbGlua2luZw0KPj4+IGNvbmZpZ3VyYXRpb25zLCBqdXN0IGJlY2F1c2UgbGlidjRsIHVz
ZXMgZGxvcGVuKCkgZm9yIHBsdWdpbiBzdXBwb3J0Lg0KPj4+DQo+Pj4gSG93ZXZlciwgcGx1Z2lu
IHN1cHBvcnQgaXMgb25seSBhIHNpZGUgZmVhdHVyZSBvZiBsaWJ2NGwsIGFuZCBvbmUgbWF5DQo+
Pj4gbmVlZCB0byB1c2UgbGlidjRsIGluIHN0YXRpYyBjb25maWd1cmF0aW9ucywganVzdCB3aXRo
b3V0IHBsdWdpbg0KPj4+IHN1cHBvcnQuDQo+Pj4NCj4+PiBUaGVyZWZvcmUsIHRoaXMgY29tbWl0
Og0KPj4+DQo+Pj4gICAtIEVzc2VudGlhbGx5IHJldmVydHMgMmU2MDRkZmJjZDA5YjkzZjA4MDhj
ZWRiMmEwYjMyNGM1NTY5YTU5OSwgc28NCj4+PiAgICAgdGhhdCBsaWJ2NGwgY2FuIGJlIGJ1aWx0
IGluIHN0YXRpYyBsaW5raW5nIGNvbmZpZ3VyYXRpb25zIGFnYWluLg0KPj4+DQo+Pj4gICAtIEFk
anVzdHMgdGhlIGNvbXBpbGF0aW9uIG9mIGxpYnY0bDIgc28gdGhhdCB0aGUgcGx1Z2luIHN1cHBv
cnQgaXMNCj4+PiAgICAgbm90IGNvbXBpbGVkIGluIHdoZW4gZGxvcGVuKCkgaW4gc3RhdGljIGxp
bmtpbmcgY29uZmlndXJhdGlvbg0KPj4+ICAgICAoZGxvcGVuIGlzIG5vdCBhdmFpbGFibGUpLg0K
Pj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogVGhvbWFzIFBldGF6em9uaSA8dGhvbWFzLnBldGF6em9u
aUBmcmVlLWVsZWN0cm9ucy5jb20+DQo+Pj4gLS0tDQo+Pj4gTk9URTogdGhpcyB3YXMgb25seSBi
dWlsZC10aW1lIHRlc3RlZCwgbm90IHJ1bnRpbWUgdGVzdGVkLg0KPj4NCj4+IEh1Z3VlcywgY2Fu
IHlvdSB0ZXN0IHRoaXMgdG8gbWFrZSBzdXJlIHRoaXMgc3RpbGwgZG9lcyB3aGF0IHlvdSBuZWVk
Pw0KPj4NCj4+IEl0IGxvb2tzIGdvb2QgdG8gbWUsIGJ1dCBJJ2QgbGlrZSB0byBtYWtlIHN1cmUg
aXQgd29ya3MgZm9yIHlvdSBhcyB3ZWxsDQo+PiBiZWZvcmUgY29tbWl0dGluZyB0aGlzLg0KPiAN
Cj4gVGhhbmtzIGZvciB5b3VyIGZlZWRiYWNrLiBVbmZvcnR1bmF0ZWx5LCBIdWd1ZXMgaGFzIG5v
dCBhbnN3ZXJlZC4gV2hhdA0KPiBjYW4gd2UgZG8gPw0KPiANCj4gVGhhbmtzLA0KPiANCj4gVGhv
bWFzDQo+IA==
