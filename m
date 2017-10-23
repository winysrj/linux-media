Return-path: <linux-media-owner@vger.kernel.org>
From: David Laight <David.Laight@ACULAB.COM>
To: "'Petrosyan, Ludwig'" <ludwig.petrosyan@desy.de>,
        Logan Gunthorpe <logang@deltatee.com>
CC: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>
Subject: RE: Enabling peer to peer device transactions for PCIe devices
Date: Mon, 23 Oct 2017 16:08:48 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DD00A04EA@AcuExch.aculab.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de>
 <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com>
 <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
In-Reply-To: <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RnJvbTogUGV0cm9zeWFuIEx1ZHdpZw0KPiBTZW50OiAyMiBPY3RvYmVyIDIwMTcgMDc6MTQNCj4g
Q291bGQgYmUgSSBoYXZlIGRvbmUgaXMgc3R1cGlkLi4uDQo+IEJ1dCBhdCBmaXJzdCBzaWdodCBp
dCBoYXMgdG8gYmUgc2ltcGxlOg0KPiBUaGUgUENJZSBXcml0ZSB0cmFuc2FjdGlvbnMgYXJlIGFk
ZHJlc3Mgcm91dGVkLCBzbyBpZiBpbiB0aGUgcGFja2V0IGhlYWRlciB0aGUgb3RoZXIgZW5kcG9p
bnQgYWRkcmVzcw0KPiBpcyB3cml0dGVuIHRoZSBUTFAgaGFzIHRvIGJlIHJvdXRlZCAoYnkgUENJ
ZSBTd2l0Y2ggdG8gdGhlIGVuZHBvaW50KSwgdGhlIERNQSByZWFkaW5nIGZyb20gdGhlIGVuZA0K
PiBwb2ludCBpcyByZWFsbHkgd3JpdGUgdHJhbnNhY3Rpb25zIGZyb20gdGhlIGVuZHBvaW50LCB1
c3VhbGx5IChYaWxpbnggY29yZSkgdG8gc3RhcnQgRE1BIG9uZSBoYXMgdG8NCj4gd3JpdGUgdG8g
dGhlIERNQSBjb250cm9sIHJlZ2lzdGVyIG9mIHRoZSBlbmRwb2ludCB0aGUgZGVzdGluYXRpb24g
YWRkcmVzcy4gU28gSSBoYXZlIGNoYW5nZSB0aGUgZGV2aWNlDQo+IGRyaXZlciB0byBzZXQgaW4g
dGhpcyByZWdpc3RlciB0aGUgcGh5c2ljYWwgYWRkcmVzcyBvZiB0aGUgb3RoZXIgZW5kcG9pbnQg
KGdldF9yZXNvdXJjZSBzdGFydCBjYWxsZWQNCj4gdG8gb3RoZXIgZW5kcG9pbnQsIGFuZCBpdCBp
cyB0aGUgc2FtZSBhZGRyZXNzIHdoaWNoIEkgY291bGQgc2VlIGluIGxzcGNpIC12dnZ2IC1zIGJ1
cy1hZGRyZXNzIG9mIHRoZQ0KPiBzd2l0Y2ggcG9ydCwgbWVtb3JpZXMgYmVoaW5kIGJyaWRnZSks
IHNvIG5vdyB0aGUgZW5kcG9pbnQgaGFzIHRvIHN0YXJ0IHNlbmQgd3JpdGVzIFRMUCB3aXRoIHRo
ZSBvdGhlcg0KPiBlbmRwb2ludCBhZGRyZXNzIGluIHRoZSBUTFAgaGVhZGVyLg0KPiBCdXQgdGhp
cyBpcyBub3Qgd29ya2luZyAoSSB3YW50IHRvIHVuZGVyc3RhbmQgd2h5IC4uLiksIGJ1dCBJIGNv
dWxkIHNlZSB0aGUgZmlyc3QgYWRkcmVzcyBvZiB0aGUNCj4gZGVzdGluYXRpb24gZW5kcG9pbnQg
aXMgY2hhbmdlZCAod2l0aCB0aGUgd3JvbmcgdmFsdWUgMHhGRiksDQo+IG5vdyBJIHdhbnQgdG8g
dHJ5IHByZXBhcmUgaW4gdGhlIGRyaXZlciBvZiBvbmUgZW5kcG9pbnQgdGhlIERNQSBidWZmZXIg
LCBidXQgdXNpbmcgcGh5c2ljYWwgYWRkcmVzcyBvZg0KPiB0aGUgb3RoZXIgZW5kcG9pbnQsDQo+
IENvdWxkIGJlIGl0IHdpbGwgbmV2ZXIgd29yaywgYnV0IEkgd2FudCB0byB1bmRlcnN0YW5kIHdo
eSwgdGhlcmUgaXMgbXkgZXJyb3IgLi4uDQoNCkl0IGlzIGFsc28gd29ydGggY2hlY2tpbmcgdGhh
dCB0aGUgaGFyZHdhcmUgYWN0dWFsbHkgc3VwcG9ydHMgcDJwIHRyYW5zZmVycy4NCldyaXRlcyBh
cmUgbW9yZSBsaWtlbHkgdG8gYmUgc3VwcG9ydGVkIHRoZW4gcmVhZHMuDQpJU1RSIHRoYXQgc29t
ZSBpbnRlbCBjcHVzIHN1cHBvcnQgc29tZSBwMnAgd3JpdGVzLCBidXQgdGhlcmUgY291bGQgZWFz
aWx5DQpiZSBlcnJhdGEgYWdhaW5zdCB0aGVtLg0KDQpJJ2QgY2VydGFpbmx5IHRlc3QgYSBzaW5n
bGUgd29yZCB3cml0ZSB0byByZWFkL3dyaXRlIG1lbW9yeSBsb2NhdGlvbi4NCkZpcnN0IHZlcmlm
eSBhZ2FpbnN0IGtlcm5lbCBtZW1vcnksIHRoZW4gYWdhaW5zdCBhICdzbGF2ZScgYm9hcmQuDQoN
CkkgZG9uJ3Qga25vdyBhYm91dCBYaWxpbnggZnBnYSwgYnV0IHdlJ3ZlIGhhZCAnZnVuJyBnZXR0
aW5nIEFsdGVyYSBmcGdhDQp0byBkbyBzZW5zaWJsZSBQQ0llIGN5Y2xlcyAoSSBlbmRlZCB1cCB3
cml0aW5nIGEgc2ltcGxlIGRtYSBjb250cm9sbGVyIA0KdGhhdCB3b3VsZCBnZW5lcmF0ZSBsb25n
IFRMUCkuDQpXZSBhbHNvIGZvdW5kIGEgYnVnIGluIHRoZSBBbHRlcmEgbG9naWMgdGhhdCBwcm9j
ZXNzZWQgaW50ZXJsZWF2ZWQNCnJlYWQgY29tcGxldGlvbnMuDQoNCglEYXZpZA0KDQo=
