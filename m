Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39840 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab2ANSaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 13:30:08 -0500
Received: by bkuw12 with SMTP id w12so699151bku.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 10:30:07 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 14 Jan 2012 19:30:06 +0100
Message-ID: <CAEN_-SDpi9dBj7hVr5f-8ap0ns+iMh8vLAcGQfA4r7XfURTE5Q@mail.gmail.com>
Subject: cx23885: small fix definition of radio tuners
From: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015175cab9eab87fa04b6812be2
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015175cab9eab87fa04b6812be2
Content-Type: text/plain; charset=ISO-8859-1

This time with signed-off header.

--0015175cab9eab87fa04b6812be2
Content-Type: text/x-patch; charset=US-ASCII; name="cx23885-fix-radio-tuners.patch"
Content-Disposition: attachment; filename="cx23885-fix-radio-tuners.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxez0kmv0

U2lnbmVkLW9mZi1ieTogTWlyb3NsYXYgU2x1Z2VuIDx0aHVuZGVyLm1tbUBnbWFpbC5jb20+CkZy
b206IE1pcm9zbGF2IFNsdWdlbiA8dGh1bmRlci5tbW1AZ21haWwuY29tPgpEYXRlOiBNb24sIDEy
IERlYyAyMDExIDAwOjE5OjM0ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gQWxsIHJhZGlvIHR1bmVy
cyBpbiBjeDgzODg1IGRyaXZlciB1c2luZyBzYW1lIGFkZHJlc3MgZm9yIHJhZGlvIGFuZCB0dW5l
ciwgc28gdGhlcmUgaXMgbm8gbmVlZCB0byBwcm9iZQogaXQgdHdpY2UgZm9yIHNhbWUgdHVuZXIg
YW5kIHdlIGNhbiB1c2UgcmFkaW9fdHlwZSBVTlNFVC4gQmUgYXdhcmUgcmFkaW8gc3VwcG9ydCBp
biBjeDIzODg1IGlzIG5vdCB5ZXQKIGNvbXBsZXRlZCwgc28gdGhpcyBpcyBvbmx5IG1pbm9yIGZp
eCBmb3IgZnV0dXJlIHN1cHBvcnQuCgotLS0KIGRyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9j
eDIzODg1LWNhcmRzLmMgfCAgICA0ICsrLS0KIDEgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gy
Mzg4NS9jeDIzODg1LWNhcmRzLmMgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4
NS1jYXJkcy5jCmluZGV4IGMzY2YwODkuLjE4N2M0NjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVk
aWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWNhcmRzLmMKKysrIGIvZHJpdmVycy9tZWRpYS92aWRl
by9jeDIzODg1L2N4MjM4ODUtY2FyZHMuYwpAQCAtMjEzLDggKzIxMyw4IEBAIHN0cnVjdCBjeDIz
ODg1X2JvYXJkIGN4MjM4ODVfYm9hcmRzW10gPSB7CiAJCS5wb3J0YwkJPSBDWDIzODg1X01QRUdf
RFZCLAogCQkudHVuZXJfdHlwZQk9IFRVTkVSX1hDNDAwMCwKIAkJLnR1bmVyX2FkZHIJPSAweDYx
LAotCQkucmFkaW9fdHlwZQk9IFRVTkVSX1hDNDAwMCwKLQkJLnJhZGlvX2FkZHIJPSAweDYxLAor
CQkucmFkaW9fdHlwZQk9IFVOU0VULAorCQkucmFkaW9fYWRkcgk9IEFERFJfVU5TRVQsCiAJCS5p
bnB1dAkJPSB7ewogCQkJLnR5cGUJPSBDWDIzODg1X1ZNVVhfVEVMRVZJU0lPTiwKIAkJCS52bXV4
CT0gQ1gyNTg0MF9WSU4yX0NIMSB8Ci0tIAoxLjcuMi4zCgo=
--0015175cab9eab87fa04b6812be2--
