Return-path: <linux-media-owner@vger.kernel.org>
Received: from server.trebels.com ([217.20.117.122]:48884 "EHLO
	server.trebels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab0GONfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jul 2010 09:35:21 -0400
Subject: [libdvben50221] stack leaks resources on non-MMI session reconnect
From: Stephan Trebels <stephan@trebels.com>
To: linux-media@vger.kernel.org
Cc: stephan@trebels.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1u1CIUtCTqeJhH73A7DQ"
Date: Thu, 15 Jul 2010 15:20:14 +0200
Message-ID: <1279200014.14890.33.camel@stephan-laptop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-1u1CIUtCTqeJhH73A7DQ
Content-Type: multipart/mixed; boundary="=-uhZbV5EMDvdPh+KDUrXI"


--=-uhZbV5EMDvdPh+KDUrXI
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


The issue was, that LIBDVBEN50221 did not allow a CAM to re-establish
the session holding non-MMI resources if using the lowlevel interface.
The session_number was recorded on open, but not freed on close (which
IMO is an bug in the code, I attach the scaled down hg changeset). With
this change, the SMIT CAM with a showtime card works fine according to
tests so far.

The effect was, that the CAM tried to constantly close and re-open the
session and the LIBDVBEN50221 kept telling it, that the resource is
already allocated to a different session.  Additionally this caused the
library to use the _old_ session number in communications with the CAM,
which did not even exist anymore, so caused all writes of CA PMTs to
fail with EINTR.

Stephan

P.S. If there is a better place to report user-space library bugs for
linuxtv, please let me know.

--=-uhZbV5EMDvdPh+KDUrXI
Content-Disposition: attachment; filename="dvb-apps-ca-session-leak.changeset"
Content-Type: text/plain; name="dvb-apps-ca-session-leak.changeset";
	charset="ISO-8859-15"
Content-Transfer-Encoding: base64

IyBIRyBjaGFuZ2VzZXQgcGF0Y2gNCiMgVXNlciBTdGVwaGFuIFRyZWJlbHMgPHN0ZXBoYW5AdHJl
YmVscy5jb20+DQojIERhdGUgMTI3OTE5MjY5NyAtMzYwMA0KIyBOb2RlIElEIDEyOTI4NjU4ZTU3
ZWEwNDZiMzVkZmFiNDg1ZjIzNTU5YjMwMzZkNDINCiMgUGFyZW50ICA0YmE5MzNmZjEzZmJkNjE5
YmU5YmRiYmYwOTdiOGRiZmUwZmJmNjc5DQpDb3JyZWN0bHkgZnJlZSByZXNvdXJjZXMgd2hlbiBh
IHNlc3Npb24gaXMgY2xvc2VkLiBUaGlzIGFsbG93cyBhIENBTSBtb2R1bGUgdG8gcmUtb3BlbiBh
IHNlc3Npb24uDQoNCmRpZmYgLXIgNGJhOTMzZmYxM2ZiIC1yIDEyOTI4NjU4ZTU3ZSBsaWIvbGli
ZHZiZW41MDIyMS9lbjUwMjIxX3N0ZGNhbV9sbGNpLmMNCi0tLSBhL2xpYi9saWJkdmJlbjUwMjIx
L2VuNTAyMjFfc3RkY2FtX2xsY2kuYwlTYXQgSnVsIDAzIDE1OjI1OjE2IDIwMTAgKzAyMDANCisr
KyBiL2xpYi9saWJkdmJlbjUwMjIxL2VuNTAyMjFfc3RkY2FtX2xsY2kuYwlUaHUgSnVsIDE1IDEy
OjE4OjE3IDIwMTAgKzAxMDANCkBAIC0zNzQsMTQgKzM3NCwyMSBAQA0KIAkJfSBlbHNlIGlmIChy
ZXNvdXJjZV9pZCA9PSBFTjUwMjIxX0FQUF9NTUlfUkVTT1VSQ0VJRCkgew0KIAkJCWxsY2ktPnN0
ZGNhbS5tbWlfc2Vzc2lvbl9udW1iZXIgPSBzZXNzaW9uX251bWJlcjsNCiAJCX0NCisJCWJyZWFr
Ow0KIA0KKwljYXNlIFNfU0NBTExCQUNLX1JFQVNPTl9DTE9TRToNCisJCWlmIChyZXNvdXJjZV9p
ZCA9PSBFTjUwMjIxX0FQUF9NTUlfUkVTT1VSQ0VJRCkgew0KKwkJCWxsY2ktPnN0ZGNhbS5tbWlf
c2Vzc2lvbl9udW1iZXIgPSAtMTsNCisJCX0gZWxzZSBpZiAocmVzb3VyY2VfaWQgPT0gRU41MDIy
MV9BUFBfREFURVRJTUVfUkVTT1VSQ0VJRCkgew0KKwkJCWxsY2ktPmRhdGV0aW1lX3Nlc3Npb25f
bnVtYmVyID0gLTE7DQorCQl9IGVsc2UgaWYgKHJlc291cmNlX2lkID09IEVONTAyMjFfQVBQX0FJ
X1JFU09VUkNFSUQpIHsNCisJCQlsbGNpLT5zdGRjYW0uYWlfc2Vzc2lvbl9udW1iZXIgPSAtMTsN
CisJCX0gZWxzZSBpZiAocmVzb3VyY2VfaWQgPT0gRU41MDIyMV9BUFBfQ0FfUkVTT1VSQ0VJRCkg
ew0KKwkJCWxsY2ktPnN0ZGNhbS5jYV9zZXNzaW9uX251bWJlciA9IC0xOw0KKwkJfSBlbHNlIGlm
IChyZXNvdXJjZV9pZCA9PSBFTjUwMjIxX0FQUF9NTUlfUkVTT1VSQ0VJRCkgew0KKwkJCWxsY2kt
PnN0ZGNhbS5tbWlfc2Vzc2lvbl9udW1iZXIgPSAtMTsNCisJCX0NCiAJCWJyZWFrOw0KLSAgICBj
YXNlIFNfU0NBTExCQUNLX1JFQVNPTl9DTE9TRToNCi0gICAgICAgIGlmIChyZXNvdXJjZV9pZCA9
PSBFTjUwMjIxX0FQUF9NTUlfUkVTT1VSQ0VJRCkgew0KLSAgICAgICAgICAgIGxsY2ktPnN0ZGNh
bS5tbWlfc2Vzc2lvbl9udW1iZXIgPSAtMTsNCi0gICAgICAgIH0NCi0NCi0gICAgICAgIGJyZWFr
Ow0KIAl9DQogCXJldHVybiAwOw0KIH0NCg==


--=-uhZbV5EMDvdPh+KDUrXI--

--=-1u1CIUtCTqeJhH73A7DQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw/CwsACgkQaPIaLXoy76MkoQCeO7oLtIeIFRMndS60QJtDWzrn
KZkAoMXKUC43zFgLRzj6PpKpTCykBJHd
=hOaK
-----END PGP SIGNATURE-----

--=-1u1CIUtCTqeJhH73A7DQ--

