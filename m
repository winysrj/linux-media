Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E4FC43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 20:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 775DC2192C
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 20:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392718AbeLVUIc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 15:08:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38956 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730988AbeLVUIc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 15:08:32 -0500
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 6A042809CB; Sat, 22 Dec 2018 21:08:24 +0100 (CET)
Date:   Sat, 22 Dec 2018 21:08:28 +0100
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
Message-ID: <20181222200827.GC15237@amd>
References: <20181221011752.25627-1-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
In-Reply-To: <20181221011752.25627-1-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Merry Christmas!

> This moves all remaining users of the legacy TI_ST driver to hcill (patch=
es
> 1-3). Then patches 4-7 convert wl128x-radio driver to a standard platform
> device driver with support for multiple instances. Patch 7 will result in
> (userless) TI_ST driver no longer supporting radio at runtime. Patch 8-11=
 do
> some cleanups in the wl128x-radio driver. Finally patch 12 removes the TI=
_ST
> specific parts from wl128x-radio and adds the required infrastructure to =
use it
> with the serdev hcill driver instead. The remaining patches 13 and 14 rem=
ove
> the old TI_ST code.
>=20
> The new code has been tested on the Motorola Droid 4. For testing the aud=
io
> should be configured to route Ext to Speaker or Headphone. Then you need =
to
> plug headphone, since its cable is used as antenna. For testing there is a
> 'radio' utility packages in Debian. When you start the utility you need to
> specify a frequency, since initial get_frequency returns an error:
>=20
> $ radio -f 100.0

Ok, it seems  the driver does not work built-in, due to firmware issue:

root@devuan:/home/user# dmesg | grep wl12
[    1.018951] reg-fixed-voltage regulator-wl12xx: GPIO lookup for
consumer (null)
[    1.026550] reg-fixed-voltage regulator-wl12xx: using device tree
for GPIO lookup
[    1.034271] of_get_named_gpiod_flags: can't parse 'gpios' property
of node '/regulator-wl12xx[0]'
[    1.043487] of_get_named_gpiod_flags: parsed 'gpio' property of
node '/regulator-wl12xx[0]' - status (0)
[    4.151885] wl12xx_driver wl12xx.1.auto: Direct firmware load for
ti-connectivity/wl128x-nvs.bin failed with error -2
[   11.368286] vwl1271: disabling
root@devuan:/home/user# find /lib/firmware/ | grep wl128
/lib/firmware/ti-connectivity/wl128x-fw-5-plt.bin
/lib/firmware/ti-connectivity/wl128x-fw-5-mr.bin
/lib/firmware/ti-connectivity/wl128x-fw-5-sr.bin
/lib/firmware/ti-connectivity/wl128x-nvs.bin
root@devuan:/home/user#

Ideas welcome... ... ... am I supposed to compile wl128-nvs.bin into
the kernel using EXTRA_FIRMWARE?

									Pavel


> Merry Christmas!
>=20
> -- Sebastian
>=20
> Sebastian Reichel (14):
>   ARM: dts: LogicPD Torpedo: Add WiLink UART node
>   ARM: dts: IGEP: Add WiLink UART node
>   ARM: OMAP2+: pdata-quirks: drop TI_ST/KIM support
>   media: wl128x-radio: remove module version
>   media: wl128x-radio: remove global radio_disconnected
>   media: wl128x-radio: remove global radio_dev
>   media: wl128x-radio: convert to platform device
>   media: wl128x-radio: use device managed memory allocation
>   media: wl128x-radio: load firmware from ti-connectivity/
>   media: wl128x-radio: simplify fmc_prepare/fmc_release
>   media: wl128x-radio: fix skb debug printing
>   media: wl128x-radio: move from TI_ST to hci_ll driver
>   Bluetooth: btwilink: drop superseded driver
>   misc: ti-st: Drop superseded driver
>=20
>  .../boot/dts/logicpd-torpedo-37xx-devkit.dts  |   8 +
>  arch/arm/boot/dts/omap3-igep0020-rev-f.dts    |   8 +
>  arch/arm/boot/dts/omap3-igep0030-rev-g.dts    |   8 +
>  arch/arm/mach-omap2/pdata-quirks.c            |  52 -
>  drivers/bluetooth/Kconfig                     |  11 -
>  drivers/bluetooth/Makefile                    |   1 -
>  drivers/bluetooth/btwilink.c                  | 350 -------
>  drivers/bluetooth/hci_ll.c                    | 115 ++-
>  drivers/media/radio/wl128x/Kconfig            |   2 +-
>  drivers/media/radio/wl128x/fmdrv.h            |   5 +-
>  drivers/media/radio/wl128x/fmdrv_common.c     | 211 ++--
>  drivers/media/radio/wl128x/fmdrv_common.h     |   4 +-
>  drivers/media/radio/wl128x/fmdrv_v4l2.c       |  55 +-
>  drivers/media/radio/wl128x/fmdrv_v4l2.h       |   2 +-
>  drivers/misc/Kconfig                          |   1 -
>  drivers/misc/Makefile                         |   1 -
>  drivers/misc/ti-st/Kconfig                    |  18 -
>  drivers/misc/ti-st/Makefile                   |   6 -
>  drivers/misc/ti-st/st_core.c                  | 922 ------------------
>  drivers/misc/ti-st/st_kim.c                   | 868 -----------------
>  drivers/misc/ti-st/st_ll.c                    | 169 ----
>  include/linux/ti_wilink_st.h                  | 337 +------
>  22 files changed, 213 insertions(+), 2941 deletions(-)
>  delete mode 100644 drivers/bluetooth/btwilink.c
>  delete mode 100644 drivers/misc/ti-st/Kconfig
>  delete mode 100644 drivers/misc/ti-st/Makefile
>  delete mode 100644 drivers/misc/ti-st/st_core.c
>  delete mode 100644 drivers/misc/ti-st/st_kim.c
>  delete mode 100644 drivers/misc/ti-st/st_ll.c
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlwembsACgkQMOfwapXb+vLWFgCgqP1OniIith3HQ17TAAe96j5P
bWYAn0UPmACF1i3Jfwgxyd0emDZT5BdH
=5eKF
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
