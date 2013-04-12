Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40406 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab3DLOUE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 10:20:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1UQepf-0003XR-Av
	for linux-media@vger.kernel.org; Fri, 12 Apr 2013 16:20:03 +0200
Received: from hsi-kbw-5-56-247-189.hsi17.kabel-badenwuerttemberg.de ([5.56.247.189])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 12 Apr 2013 16:20:03 +0200
Received: from sur5r by hsi-kbw-5-56-247-189.hsi17.kabel-badenwuerttemberg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 12 Apr 2013 16:20:03 +0200
To: linux-media@vger.kernel.org
From: Jakob Haufe <sur5r@sur5r.net>
Subject: [PATCH] Add support for Delock 61959
Date: Fri, 12 Apr 2013 16:18:40 +0200
Message-ID: <20130412161840.4bf01fc2@samsa.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: base64
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LS0tLS1CRUdJTiBQR1AgU0lHTkVEIE1FU1NBR0UtLS0tLQ0KSGFzaDogU0hBMQ0KDQpEZWxvY2sg
NjE5NTkgc2VlbXMgdG8gYmUgYSByZWxhYmVsZWQgdmVyc2lvbiBvZiBNYXhtZWRpYSBVQjQyNS1U
QyB3aXRoIGENCmRpZmZlcmVudCBVU0IgSUQuIFBDQiBpcyBtYXJrZWQgYXMgIlVCNDI1LVRDIFZl
cjogQSIgYW5kIHRoaXMgY2hhbmdlDQptYWtlcyBpdCB3b3JrIHdpdGhvdXQgYW55IG9idmlvdXMg
cHJvYmxlbXMuDQoNClNpZ25lZC1vZmYtYnk6IEpha29iIEhhdWZlIDxzdXI1ckBzdXI1ci5uZXQ+
DQotIC0tLQ0KIGRyaXZlcnMvbWVkaWEvdXNiL2VtMjh4eC9lbTI4eHgtY2FyZHMuYyB8ICAgIDIg
KysNCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL21lZGlhL3VzYi9lbTI4eHgvZW0yOHh4LWNhcmRzLmMgYi9kcml2ZXJzL21lZGlhL3VzYi9l
bTI4eHgvZW0yOHh4LWNhcmRzLmMNCmluZGV4IDFkMzg2NmYuLjgyOTUwYWEgMTAwNjQ0DQotIC0t
LSBhL2RyaXZlcnMvbWVkaWEvdXNiL2VtMjh4eC9lbTI4eHgtY2FyZHMuYw0KKysrIGIvZHJpdmVy
cy9tZWRpYS91c2IvZW0yOHh4L2VtMjh4eC1jYXJkcy5jDQpAQCAtMjE3Myw2ICsyMTczLDggQEAg
c3RydWN0IHVzYl9kZXZpY2VfaWQgZW0yOHh4X2lkX3RhYmxlW10gPSB7DQogICAgICAgICAgICAg
ICAgICAgICAgICAuZHJpdmVyX2luZm8gPSBFTTI4NjBfQk9BUkRfRUFTWUNBUCB9LA0KICAgICAg
ICB7IFVTQl9ERVZJQ0UoMHgxYjgwLCAweGU0MjUpLA0KICAgICAgICAgICAgICAgICAgICAgICAg
LmRyaXZlcl9pbmZvID0gRU0yODc0X0JPQVJEX01BWE1FRElBX1VCNDI1X1RDIH0sDQorICAgICAg
IHsgVVNCX0RFVklDRSgweDFiODAsIDB4ZTFjYyksIC8qIERlbG9jayA2MTk1OSAqLw0KKyAgICAg
ICAgICAgICAgICAgICAgICAgLmRyaXZlcl9pbmZvID0gRU0yODc0X0JPQVJEX01BWE1FRElBX1VC
NDI1X1RDIH0sDQogICAgICAgIHsgVVNCX0RFVklDRSgweDIzMDQsIDB4MDI0MiksDQogICAgICAg
ICAgICAgICAgICAgICAgICAuZHJpdmVyX2luZm8gPSBFTTI4ODRfQk9BUkRfUENUVl81MTBFIH0s
DQogICAgICAgIHsgVVNCX0RFVklDRSgweDIwMTMsIDB4MDI1MSksDQotIC0tIA0KMS43LjEwLjQN
Cg0KDQotIC0tIA0KY2V0ZXJ1bSBjZW5zZW8gbWljcm9zb2Z0ZW0gZXNzZSBkZWxlbmRhbS4NCi0t
LS0tQkVHSU4gUEdQIFNJR05BVFVSRS0tLS0tDQpWZXJzaW9uOiBHbnVQRyB2MS40LjEyIChHTlUv
TGludXgpDQoNCmlFWUVBUkVDQUFZRkFsRm9GOEFBQ2drUTFZQWhEaWMrYWRhSVBRQ2ZaUSs2Z1VI
L0pBNk4yUVZzYTducnBaeUwNCnZTc0FuM2Urek1pRmlNODBWbjFvVEdyZ25raER4ZmN4DQo9bU9j
Rw0KLS0tLS1FTkQgUEdQIFNJR05BVFVSRS0tLS0tDQo=


