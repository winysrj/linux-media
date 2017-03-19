Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:36328 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751513AbdCSOrW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 10:47:22 -0400
Received: by mail-it0-f50.google.com with SMTP id w124so65463113itb.1
        for <linux-media@vger.kernel.org>; Sun, 19 Mar 2017 07:47:21 -0700 (PDT)
Message-ID: <1489934837.3388.4.camel@ndufresne.ca>
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Sun, 19 Mar 2017 10:47:17 -0400
In-Reply-To: <20170319142110.GT21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
         <20170318192258.GL21222@n2100.armlinux.org.uk>
         <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
         <20170318204324.GM21222@n2100.armlinux.org.uk>
         <4e7f91fa-e1c4-1cbc-2542-2aaf19a35329@mentor.com>
         <20170319142110.GT21222@n2100.armlinux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-oWbksnctFIVEBK64NC2I"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-oWbksnctFIVEBK64NC2I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le dimanche 19 mars 2017 =C3=A0 14:21 +0000, Russell King - ARM Linux a
=C3=A9crit=C2=A0:
> > Can it be a point of failure?
>=20
> There's a good reason why I dumped a full debug log using
> GST_DEBUG=3D*:9,
> analysed it for the cause of the failure, and tried several different
> pipelines, including the standard bayer2rgb plugin.
>=20
> Please don't blame this on random stuff after analysis of the logs
> _and_
> reading the appropriate plugin code has shown where the problem is.=C2=A0
> I
> know gstreamer can be very complex, but it's very possible to analyse
> the cause of problems and pin them down with detailed logs in
> conjunction
> with the source code.

I read your analyses with GStreamer, and it was all correct.

Nicolas
--=-oWbksnctFIVEBK64NC2I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAljOmfUACgkQcVMCLawGqBwYkQCdHGmIDjI60X3bEjNEYSdTotbj
t6wAn08cuWsuuBS7qRy1PejA/n9HwYWS
=Qm7P
-----END PGP SIGNATURE-----

--=-oWbksnctFIVEBK64NC2I--
