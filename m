Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out28.alice.it ([85.33.2.28]:1238 "EHLO
	smtp-out28.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbZIIXgf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 19:36:35 -0400
Date: Thu, 10 Sep 2009 01:36:07 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: James Blanford <jhblanford@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca stv06xx performance regression - request for testing
Message-Id: <20090910013607.b277b0cc.ospite@studenti.unina.it>
In-Reply-To: <20090909181139.06ab4ed5@blackbart.localnet.prv>
References: <20090909181139.06ab4ed5@blackbart.localnet.prv>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Sep_2009_01_36_07_+0200_sp_e_hsb+EX3Luu1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Thu__10_Sep_2009_01_36_07_+0200_sp_e_hsb+EX3Luu1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Sep 2009 18:11:39 -0400
James Blanford <jhblanford@gmail.com> wrote:

> Howdy folks,
>=20
> Now that I have my old quickcam express working, I can confirm that the
> frame rate is half what it was with the old out-of-tree driver.  The
> gspca driver is throwing out every other frame.  When a frame is
> completed, a new frame is started with a new frame buffer that passes
> the test for being properly queued.  But after the first packet is
> analysed by the subdriver, the exact same test fails and the entire
> frame is marked for discard.
>=20

I also have a QuickCam Express, the one with pb0100 sensor.
It is slow indeed, but I can't really make a comparison with the old
driver.

> I'm hoping someone has a few minutes to make a little patch, run the
> cam for a couple seconds and look at the debug log.  Any comments are
> welcome as well.
>=20

I get some discarded frames with stv06xx , but not as regularly as you.
Also, no discarded frames with ov534 subdriver.

Here's the log:

[55231.009253] gspca: main v2.7.0 registered
[55231.011569] STV06xx: Probing for a stv06xx device
[55231.011575] gspca: probing 046d:0840
[55231.011582] STV06xx: Configuring camera
[55231.024510] STV06xx: Photobit pb0100 sensor detected
[55231.024517] STV06xx: Initializing camera
[55231.310369] gspca: probe ok
[55231.310408] usbcore: registered new interface driver STV06xx
[55231.310413] STV06xx: registered
[55445.692828] Frame alloc
[55446.298735] New frame - first packet
[55446.426667] Frame completed
[55446.426674] New frame - first packet
[55446.426677] Frame marked for discard
[55446.554582] New frame - first packet
[55446.714487] Frame completed
[55446.714495] New frame - first packet
[55446.874375] Frame completed
[55446.874383] New frame - first packet
[55447.034246] Frame completed
[55447.034253] New frame - first packet
[55447.194141] Frame completed
[55447.194150] New frame - first packet
[55447.354020] Frame completed
[55447.354027] New frame - first packet
[55447.354029] Frame marked for discard
[55447.481948] New frame - first packet
[55447.641846] Frame completed
[55447.641853] New frame - first packet
[55447.801725] Frame completed
[55447.801732] New frame - first packet
[55447.961596] Frame completed
[55447.961603] New frame - first packet
[55448.121467] Frame completed
[55448.121474] New frame - first packet
[55448.281355] Frame completed
[55448.281363] New frame - first packet
[55448.409305] Frame completed
[55448.409313] New frame - first packet
[55448.569191] Frame completed
[55448.569199] New frame - first packet
[55448.729067] Frame completed
[55448.729075] New frame - first packet
[55448.888939] Frame completed
[55448.888946] New frame - first packet
[55449.048822] Frame completed
[55449.048830] New frame - first packet
[55449.208710] Frame completed
[55449.208717] New frame - first packet
[55449.336668] Frame completed
[55449.336675] New frame - first packet
[55449.496532] Frame completed
[55449.496540] New frame - first packet
[55449.656421] Frame completed
[55449.656429] New frame - first packet
[55449.816286] Frame completed
[55449.816294] New frame - first packet
[55449.976166] Frame completed
[55449.976173] New frame - first packet
[55449.976175] Frame marked for discard
[55450.136047] New frame - first packet

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Thu__10_Sep_2009_01_36_07_+0200_sp_e_hsb+EX3Luu1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqoO+cACgkQ5xr2akVTsAH9lQCcD7nYaT2KLcK8gG0J77tkcmKc
iEYAn00X2mV31UBVhRzMkME1SlA1kLSM
=kzsG
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Sep_2009_01_36_07_+0200_sp_e_hsb+EX3Luu1--
