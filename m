Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36219 "EHLO
        mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756415AbcIVWag (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 18:30:36 -0400
Received: by mail-pa0-f42.google.com with SMTP id qn7so15874771pac.3
        for <linux-media@vger.kernel.org>; Thu, 22 Sep 2016 15:30:36 -0700 (PDT)
Subject: Re: TW2866 i2c driver and solo6x10
To: Andrey Utkin <andrey_utkin@fastmail.com>
References: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>
 <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
 <20160919182033.qaom5ji4k43jsu24@acer>
 <57c69cbd-950e-ba01-5d6a-efdabe6f6d16@gmail.com>
 <20160922221713.kvi3q4qcobye6m5b@acer>
Cc: linux-media <linux-media@vger.kernel.org>
From: Marty Plummer <netz.kernel@gmail.com>
Message-ID: <5873da5b-d402-6757-a7ab-16bdd9eed091@gmail.com>
Date: Thu, 22 Sep 2016 17:30:33 -0500
MIME-Version: 1.0
In-Reply-To: <20160922221713.kvi3q4qcobye6m5b@acer>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WXu7qtlf5Cjdx41f3f2cdbBdcAtCoMnGM"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WXu7qtlf5Cjdx41f3f2cdbBdcAtCoMnGM
Content-Type: multipart/mixed; boundary="7XqCNo35xRNW4D7vKpcwqxiHiLqVtG24M";
 protected-headers="v1"
From: Marty Plummer <netz.kernel@gmail.com>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Message-ID: <5873da5b-d402-6757-a7ab-16bdd9eed091@gmail.com>
Subject: Re: TW2866 i2c driver and solo6x10
References: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>
 <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
 <20160919182033.qaom5ji4k43jsu24@acer>
 <57c69cbd-950e-ba01-5d6a-efdabe6f6d16@gmail.com>
 <20160922221713.kvi3q4qcobye6m5b@acer>
In-Reply-To: <20160922221713.kvi3q4qcobye6m5b@acer>

--7XqCNo35xRNW4D7vKpcwqxiHiLqVtG24M
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/22/2016 05:17 PM, Andrey Utkin wrote:
> So is the actual machine x86 or ARM?
> Do the tw28xx chips behind the bus (i2c as you said) show up in any way=

> at all? Is something like i2c controller available? Or it's ARM and we
> should tell kernel how to "find" the i2c line by feeding correct
> devicetree to it?
>=20
This particular device is ARM. I can't be certain right now, as I've not
gotten to the point of handling the i2c bus; In the kernel module that
it currently uses it has hard-coded i2c addresses for each chip and does
a small for-loop to do the setup i2c stuffs. I could see about getting
the i2c bus running really quick and see if the various i2c tools
buildroot provides can see them, if that's helpful.

If you could provide a list of useful info and how to acquire it I'd be
more than willing to probe stuff for it.


--7XqCNo35xRNW4D7vKpcwqxiHiLqVtG24M--

--WXu7qtlf5Cjdx41f3f2cdbBdcAtCoMnGM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX5FuJAAoJEHWEtN3AMJGNRoAP/j9g2IHjiLTKsOOD7YpneJWG
baxSEv3wQu7eas9u1oapLZWAGkgup0t7ak/X45HD86BigW3KmvOVouz4WcxrPlBu
Rvr/s1P7Sr+0co7tP2qcn/geXx/A5PkpXcUZwOeHS0vudOQdZi0EKZNngXHRQCER
AjCS/2J4in8+2DeqAQAMuQOHxAzmRwiAfOgyIHlDKqZXWFl3slyzpyBY+yQbdc07
SNSbWr0xjpATD28cYaPj3pXifkxmezKyQydAQq7lbiW1O5aGGi9e/K2XNQ56JPln
x3AY4KqfSt79QiqHA8oz5k1UOExVmQVrvn4JHmwalipCTQZnBnfsWCY2cdzhCNTF
HdZ62IOBxUCkQgMOLv/ACBHtMtF//eZT+zBxWOqZXNfuaHEUNFVGZfnghptp71BT
EhnaTpfG9POgSXKhEWp1ogGkRpEq6/AaNvmuDHFG+vVgnhHqUnq/hNeqjEvea5MK
ZNfXbR6gJncmav4s1mDYO+B+0P2vaYz+WI7Fe+P1ZDnQkfYiMUsckLwDhZz+1fuM
T8HVwlLoNAgFNCVZ7swaUtZ3jKGvaQO7VZ6T09O7gW/mPy+wgxIiwM9JEv8z/kZB
oqp/l00xSNgst9sgl4+pU4r2B90oxrSR+aH7a2X13nr7FrfneyMHFf00dDRqAjcc
dNtUhUi5Fg0i0eFTfVOK
=LZz4
-----END PGP SIGNATURE-----

--WXu7qtlf5Cjdx41f3f2cdbBdcAtCoMnGM--
