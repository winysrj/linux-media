Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36164 "EHLO
        mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755237AbcIVWGy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 18:06:54 -0400
Received: by mail-pa0-f50.google.com with SMTP id qn7so15718390pac.3
        for <linux-media@vger.kernel.org>; Thu, 22 Sep 2016 15:06:54 -0700 (PDT)
Subject: Re: TW2866 i2c driver and solo6x10
To: Andrey Utkin <andrey_utkin@fastmail.com>
References: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>
 <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
 <20160919182033.qaom5ji4k43jsu24@acer>
Cc: linux-media <linux-media@vger.kernel.org>
From: Marty Plummer <netz.kernel@gmail.com>
Message-ID: <57c69cbd-950e-ba01-5d6a-efdabe6f6d16@gmail.com>
Date: Thu, 22 Sep 2016 17:06:34 -0500
MIME-Version: 1.0
In-Reply-To: <20160919182033.qaom5ji4k43jsu24@acer>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="P0H1UdXBHuwK9PXfCrLDw1BxWVpgK6oND"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P0H1UdXBHuwK9PXfCrLDw1BxWVpgK6oND
Content-Type: multipart/mixed; boundary="j0pOKBLpx0S3h8eEAWV8d4SSb1muX8oLp";
 protected-headers="v1"
From: Marty Plummer <netz.kernel@gmail.com>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Message-ID: <57c69cbd-950e-ba01-5d6a-efdabe6f6d16@gmail.com>
Subject: Re: TW2866 i2c driver and solo6x10
References: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>
 <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
 <20160919182033.qaom5ji4k43jsu24@acer>
In-Reply-To: <20160919182033.qaom5ji4k43jsu24@acer>

--j0pOKBLpx0S3h8eEAWV8d4SSb1muX8oLp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/19/2016 01:20 PM, Andrey Utkin wrote:
> I'm going to have quite constrained time for participation in this
> driver development, but still I think this is perspective project which=

> is in line with trend of exposing internal details of complex media
> hardware for configuration by V4L2 framework. Also tw286x are used in
> both tw5864 and solo6x10 boards, and in both cases it could be
> controlled better from userspace.
> I think first thing to do is expose tw286x chips as i2c- (or more
> precisely SMBus-) controllable devices. I have accomplished that in som=
e
> way for tw5864, and hopefully I'll manage that for solo6x10.
> But beyond that, I currently don't know.
> A senior mentor would be very appreciated :)
>=20
I do appreciate the assistance. In most of this I'm already in water
above my head for the most part, but I'm making progress. Currently have
a booting kernel (4.8-rc4) and usb support, taking a go at the gmac/phy
driver atm. Its mostly similar to an existing driver, but I'd like to
get it up and running since the primary use of this device is over the
network, so even if we did have proper v4l2 devices it would not be
available over the network. One other thing I'm slightly worried about
is the sii/sil9034 hdmi chip included. Apparently its rather tricky to
get a datasheet for this without a NDA due to the drm stuff built in.


--j0pOKBLpx0S3h8eEAWV8d4SSb1muX8oLp--

--P0H1UdXBHuwK9PXfCrLDw1BxWVpgK6oND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX5FX7AAoJEHWEtN3AMJGNizwQAK7cm46l+5kK0zvtjFQwk9Yl
XKghsDE0D9ZRybLQVFLtsy5qf+aHsJcnvbHbU+g90TSHGwy0qm1n9oU0Yh4hj3yp
bvqtpI6SJwwD/PlGgQiMrprRJmRLMRIomFARNzGE/PNSv9Cj7b99ae67H9dXve3M
w+AmsPi609NoTXNEs7DnkI/DIMlPZsbNRUmE1/pNlQ6movjzA9HEQ5Xpl1UZ7Ame
WgAAabTiFOhPcuWrEWWvBe8zASr0L2XiK/geXI0KnF//mpifECLjIx/ZRrF+TuzH
zPQmAghPCw4Mcez0soodGY/Pgxqt3NYolajY0s4ol2YOm1W7UB/wU4WrMMWmhSSl
pUIg3BJ33NapPdyCOmcoDHz2vFBGmTuw/TWkYm8dnD+y+BCUT2uts5LG+dDxE3J/
kvWdHxtQWiRGy3uYtcr3j3oa8/ciEiZkN+ykGuwMJBSs1Fb4CC2LE83O7KvPvOzN
aEVt6NzWfzL0ip2YX1Hh7CX8zL2y+/Z2BP6SXcYccHaBE+r5BN+JYtRz7FWTOkNV
N/I1GbBdG541mBYQ9MsJsBE7s3bR5i+Ka9omSTldX9ZLTM72S0F04urhhyR/Eyil
CwLNUjEcTWSJnc+D/HjWcRdR72w2EHGxG18oqNccn6UZQG7inYzeDLA1C5rqdeMB
OWNpI3kR+APpJZ7TPoUO
=VvLv
-----END PGP SIGNATURE-----

--P0H1UdXBHuwK9PXfCrLDw1BxWVpgK6oND--
