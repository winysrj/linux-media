Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10897C43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 22:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB5DE21917
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 22:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391307AbeLVWkv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 17:40:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43102 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388727AbeLVWkv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 17:40:51 -0500
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 59E1080ACF; Sat, 22 Dec 2018 23:40:43 +0100 (CET)
Date:   Sat, 22 Dec 2018 23:40:47 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-bluetooth@vger.kernel.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] Add support for FM radio in hcill and kill TI_ST
Message-ID: <20181222224046.GA8789@amd>
References: <20181221011752.25627-1-sre@kernel.org>
 <20181222200827.GC15237@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20181222200827.GC15237@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This moves all remaining users of the legacy TI_ST driver to hcill (pat=
ches
> > 1-3). Then patches 4-7 convert wl128x-radio driver to a standard platfo=
rm
> > device driver with support for multiple instances. Patch 7 will result =
in
> > (userless) TI_ST driver no longer supporting radio at runtime. Patch 8-=
11 do
> > some cleanups in the wl128x-radio driver. Finally patch 12 removes the =
TI_ST
> > specific parts from wl128x-radio and adds the required infrastructure t=
o use it
> > with the serdev hcill driver instead. The remaining patches 13 and 14 r=
emove
> > the old TI_ST code.
> >=20
> > The new code has been tested on the Motorola Droid 4. For testing the a=
udio
> > should be configured to route Ext to Speaker or Headphone. Then you nee=
d to
> > plug headphone, since its cable is used as antenna. For testing there i=
s a
> > 'radio' utility packages in Debian. When you start the utility you need=
 to
> > specify a frequency, since initial get_frequency returns an error:
> >=20
> > $ radio -f 100.0
>=20
> Ok, it seems  the driver does not work built-in, due to firmware issue:
>=20
> root@devuan:/home/user# dmesg | grep wl12
> [    1.018951] reg-fixed-voltage regulator-wl12xx: GPIO lookup for
> consumer (null)
> [    1.026550] reg-fixed-voltage regulator-wl12xx: using device tree
> for GPIO lookup
> [    1.034271] of_get_named_gpiod_flags: can't parse 'gpios' property
> of node '/regulator-wl12xx[0]'
> [    1.043487] of_get_named_gpiod_flags: parsed 'gpio' property of
> node '/regulator-wl12xx[0]' - status (0)
> [    4.151885] wl12xx_driver wl12xx.1.auto: Direct firmware load for
> ti-connectivity/wl128x-nvs.bin failed with error -2
> [   11.368286] vwl1271: disabling
> root@devuan:/home/user# find /lib/firmware/ | grep wl128
> /lib/firmware/ti-connectivity/wl128x-fw-5-plt.bin
> /lib/firmware/ti-connectivity/wl128x-fw-5-mr.bin
> /lib/firmware/ti-connectivity/wl128x-fw-5-sr.bin
> /lib/firmware/ti-connectivity/wl128x-nvs.bin
> root@devuan:/home/user#
>=20
> Ideas welcome... ... ... am I supposed to compile wl128-nvs.bin into
> the kernel using EXTRA_FIRMWARE?

EXTRA_FIRMWARE gets me further... some of it was not in debian.

"Speaker right" needs to be set to "Ext" in alsamixer, and then... it
works! :-)

Quality does not seem to be great, but that may be mixer settings or
something.

Thanks!
								Pavel

Tested-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlwevW4ACgkQMOfwapXb+vJzsgCfZdE1qOGrkxu0udFUv/CnviXX
YiEAoJTOSIjVZmOCWjdegi9E3mGfQqga
=mus8
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
