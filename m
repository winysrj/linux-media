Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40373 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaFXWNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 18:13:22 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so1056836wgg.20
        for <linux-media@vger.kernel.org>; Tue, 24 Jun 2014 15:13:21 -0700 (PDT)
Date: Wed, 25 Jun 2014 00:13:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Denis Carikli <denis@eukrea.com>, dri-devel@lists.freedesktop.org,
	devel@driverdev.osuosl.org,
	Eric =?utf-8?Q?B=C3=A9nard?= <eric@eukrea.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v14 06/10] drm: drm_display_mode: add signal polarity
 flags
Message-ID: <20140624221318.GA30183@mithrandir>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
 <1402913484-25910-6-git-send-email-denis@eukrea.com>
 <20140624145745.GR32514@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20140624145745.GR32514@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2014 at 03:57:46PM +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 16, 2014 at 12:11:20PM +0200, Denis Carikli wrote:
> > We need a way to pass signal polarity informations
> >   between DRM panels, and the display drivers.
> >=20
> > To do that, a pol_flags field was added to drm_display_mode.
> >=20
> > Signed-off-by: Denis Carikli <denis@eukrea.com>
>=20
> This patch needs an ack from the DRM people - can someone review it
> please?  This series has now been round 14 revisions and it's about
> time it was properly reviewed - or a statement made if it's
> unacceptable.

I didn't follow all of the earlier discussions around this, but it seems
to me like data-enable polarity and the pixel data edge flags are
properties of the interface rather than the video mode.

struct drm_display_mode represents the video timings and I'm not sure if
it's a good idea to extend it with this type of information.

Maybe we need to add a separate type of device to store these parameters
(much like we've done for MIPI DSI devices).

Thierry

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTqff+AAoJEN0jrNd/PrOhMDYP/3UoGEBsG+WRM/zNypLJ4tmq
2PcHJtTEWeaUIT+U0XJxrVRJX3SGqKzwKzsKbeJ9dcTMbfuJQu2A0p3Wp1vlM8l0
L3gMKRFdpOuE+zagkHGQdE4/RY6CWax4pzGiB6vwvqpA31RK8zn//uv3XynM9z6s
Qom3yUUkaDEHSzBME0Xf4u/3rpYz6ixeXmPO92ttpxVcGBB9S4r27jwrHDcuwyr9
w49pqy6pGrm6AyP/HfDNSi5MzWThwpZ0DueMo1fLM3MmxH0PgAdzTFM96oO08qW1
STDOqHWWR3ZfRZnKr01z9OdmhXB+QyMDQfyeltZcaiBncPODCWY6JXQlp79VbsZ6
E+XR5LPW3WrtPL2+CD2YskHdUFVNBj8hDuNRy3/TlURm7i+uiaACPm5MraEyVmqQ
swpF9r6Qo/kbZ2yvVFsz/JCqxgNGWn2TRCLedTcs+S9appxGpqSWxcNt2GhVEGhw
K0bR4snxmrhsjNY3MMqxFR4e8SMwMHSEf9WWYOUWePIa86rJjHW3ltWjE0qsP8Gc
RQG7X1+CDciXZaePAMa3grR7C51iUysH8O1qUO90Xyxqq0ghLj2bdJLUKWnBhtzh
ouWPTUv8e3TRrWJJmH2tctquOuonR2UvupkKSIF6W0IbsiFBWVPWB7639e4TN2gV
7G3etHyGJYvcaIk9lQrG
=y5w2
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
