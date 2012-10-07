Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.poss.co.nz ([210.54.213.75]:1753 "EHLO riffraff.iposs.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750860Ab2JGBTy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Oct 2012 21:19:54 -0400
From: Michael West <michael@iposs.co.nz>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>
Date: Sun, 7 Oct 2012 14:19:48 +1300
Subject: RE: Media_build broken by [PATCH RFC v3 5/5] m5mols: Implement
 .get_frame_desc subdev callback
Message-ID: <DCBB30B3D32C824F800041EE82CABAAE03203D63BB2A@duckworth.iposs.co.nz>
References: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com>
 <1348674853-24596-6-git-send-email-s.nawrocki@samsung.com>
 <50704D26.9020201@hoogenraad.net> <50707704.5030402@gmail.com>
 <50707BE0.9010209@hoogenraad.net> <5070A3C9.8040409@gmail.com>
In-Reply-To: <5070A3C9.8040409@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VGhpcyBwYXRjaCBjaGFuZ2VzIHZlcnNpb25zLnR4dCBhbmQgZGlzYWJsZXMgIFZJREVPX001TU9M
UyB3aGljaCBmaXhlZCB0aGUgYnVpbGQgZm9yIG15IDMuMiBrZXJuZWwgYnV0IGxvb2tpbmcgYXQg
dGhlIGxvZ3MgaXQgbG9va3MgbGlrZSB0aGlzIGlzIG5vdCB0aGUgd2F5IHRvIGZpeCBpdCBhcyBp
dCdzIG5vdCBqdXN0IGEgMy42KyBwcm9ibGVtIGFzIGl0IGRvZXMgbm90IGJ1aWxkIG9uIDMuNiBh
cyB3ZWxsLi4uICBTbyBwcm9iYWJseSBiZXN0IHRvIGZpbmQgd2h5IGl0IGRvZXNuJ3QgYnVpbGQg
b24gdGhlIGN1cnJlbnQga2VybmVsIGZpcnN0Lg0KDQotLS0NCiB2NGwvdmVyc2lvbnMudHh0IHwg
ICAgMiArKw0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBh
L3Y0bC92ZXJzaW9ucy50eHQgYi92NGwvdmVyc2lvbnMudHh0DQppbmRleCAzMjg2NTFlLi4zNDk2
OTVjIDEwMDY0NA0KLS0tIGEvdjRsL3ZlcnNpb25zLnR4dA0KKysrIGIvdjRsL3ZlcnNpb25zLnR4
dA0KQEAgLTQsNiArNCw4IEBADQogWzMuNi4wXQ0KICMgbmVlZHMgZGV2bV9jbGtfZ2V0LCBjbGtf
ZW5hYmxlLCBjbGtfZGlzYWJsZQ0KIFZJREVPX0NPREENCisjIGJyb2tlbiBhZGQgcmVhc29uIGhl
cmUNCitWSURFT19NNU1PTFMNCiANCiBbMy40LjBdDQogIyBuZWVkcyBkZXZtX3JlZ3VsYXRvcl9i
dWxrX2dldA0KLS0gDQoxLjcuOS41DQoNCj5PbiAxMC8wNi8yMDEyIDA4OjQzIFBNLCBKYW4gSG9v
Z2VucmFhZCB3cm90ZToNCj4+IFRoYW5rcy4NCj4+DQo+PiBJIHNlZSBzZXZlcmFsIGRyaXZlcnMg
ZGlzYWJsZWQgZm9yIGxvd2VyIGtlcm5lbCB2ZXJzaW9ucyBpbiBteSBLY29uZmlnIGZpbGUuDQo+
PiBJIGFtIG5vdCBzdXJlIGhvdyB0aGlzIGlzIGFjY29tcGxpc2hlZCwgYnV0IGl0IHdvdWxkIGJl
IGhlbHBmdWwgaWYgdGhlIA0KPj4gRnVqaXRzdSBNLTVNT0xTIDhNUCBzZW5zb3Igc3VwcG9ydCBp
cyBhdXRvbWF0aWNhbGx5IGRpc2FibGVkIGZvciANCj4+IGtlcm5lbDwgIDMuNg0KPj4NCj4+IEkg
Zml4ZWQgaXQgaW4gbXkgdmVyc2lvbiBieSByZXBsYWNpbmcgU1pfMU0gYnkgKDEwMjQqMTAyNCku
DQo+PiBJIGRpZCBub3QgbmVlZCB0aGUgZHJpdmVyLCBidXQgYXQgbGVhc3QgaXQgY29tcGlsZWQg
Li4uDQo+DQo+QSBwYXRjaCBmb3IgdjRsL3ZlcnNpb25zLnR4dCBpcyBuZWVkZWQgWzFdLg0KPkkn
bGwgc2VlIGlmIEkgY2FuIHByZXBhcmUgdGhhdC4NCj5odHRwOi8vZ2l0LmxpbnV4dHYub3JnL21l
ZGlhX2J1aWxkLmdpdC9oaXN0b3J5LzVkMDBkYmE2YWFmMGY5MWE3NDJkOTBmZDFlMTJlMGZiMmQz
NjI1M2U6L3Y0bC92ZXJzaW9ucy50eHQgDQoNCg==
