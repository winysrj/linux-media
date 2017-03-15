Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:34935 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbdCOS4U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 14:56:20 -0400
Received: by mail-qt0-f175.google.com with SMTP id x35so20098935qtc.2
        for <linux-media@vger.kernel.org>; Wed, 15 Mar 2017 11:55:14 -0700 (PDT)
Message-ID: <1489604109.4593.4.camel@ndufresne.ca>
Subject: Re: media / v4l2-mc: wishlist for complex cameras (was Re: [PATCH
 v4 14/36] [media] v4l2-mc: add a function to inherit controls from a
 pipeline)
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Philippe De Muyter <phdm@macq.eu>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Pavel Machek <pavel@ucw.cz>, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Date: Wed, 15 Mar 2017 14:55:09 -0400
In-Reply-To: <20170315105049.GA12099@frolo.macqel>
References: <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
         <20170310125342.7f047acf@vento.lan>
         <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
         <20170311082549.576531d0@vento.lan>
         <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
         <20170314004533.3b3cd44b@vento.lan>
         <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
         <20170314072143.498cde9b@vento.lan> <20170314223254.GA7141@amd>
         <20170314215420.6fc63c67@vento.lan> <20170315105049.GA12099@frolo.macqel>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-7fq51Td7eGbeBp/kWBM3"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-7fq51Td7eGbeBp/kWBM3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 15 mars 2017 =C3=A0 11:50 +0100, Philippe De Muyter a =C3=A9cri=
t=C2=A0:
> > I would say: camorama, xawtv3, zbar, google talk, skype. If it runs
> > with those, it will likely run with any other application.
> >=20
>=20
> I would like to add the 'v4l2src' plugin of gstreamer, and on the
> imx6 its

While it would be nice if somehow you would get v4l2src to work (in
some legacy/emulation mode through libv4l2), the longer plan is to
implement smart bin that handle several v4l2src, that can do the
required interactions so we can expose similar level of controls as
found in Android Camera HAL3, and maybe even further assuming userspace
can change the media tree at run-time. We might be a long way from
there, specially that some of the features depends on how much the
hardware can do. Just being able to figure-out how to build the MC tree
dynamically seems really hard when thinking of generic mechanism. Also,
Request API will be needed.

I think for this one, we'll need some userspace driver that enable the
features (not hide them), and that's what I'd be looking for from
libv4l2 in this regard.

> imx-specific counterpart 'imxv4l2videosrc' from the gstreamer-imx
> package
> at https://github.com/Freescale/gstreamer-imx, and 'v4l2-ctl'.

This one is specific to IMX hardware using vendor driver. You can
probably ignore that.

Nicolas
--=-7fq51Td7eGbeBp/kWBM3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAljJjg0ACgkQcVMCLawGqBzWHACfQymBOSCSce0cthYH9b7XZ0jx
87wAnR09ioCl/7XxAg/iQxU6O3boR99I
=mn5/
-----END PGP SIGNATURE-----

--=-7fq51Td7eGbeBp/kWBM3--
