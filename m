Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:35206 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbdCSAlU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Mar 2017 20:41:20 -0400
Received: by mail-it0-f51.google.com with SMTP id y18so799500itc.0
        for <linux-media@vger.kernel.org>; Sat, 18 Mar 2017 17:41:19 -0700 (PDT)
Message-ID: <1489884074.21659.7.camel@ndufresne.ca>
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
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
Date: Sat, 18 Mar 2017 20:41:14 -0400
In-Reply-To: <20170318204324.GM21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
         <20170318192258.GL21222@n2100.armlinux.org.uk>
         <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
         <20170318204324.GM21222@n2100.armlinux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-xaD73S9VP/RR5tcyQzYG"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-xaD73S9VP/RR5tcyQzYG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le samedi 18 mars 2017 =C3=A0 20:43 +0000, Russell King - ARM Linux a
=C3=A9crit=C2=A0:
> On Sat, Mar 18, 2017 at 12:58:27PM -0700, Steve Longerbeam wrote:
> > Can you share your gstreamer pipeline? For now, until
> > VIDIOC_ENUM_FRAMESIZES is implemented, try a pipeline that
> > does not attempt to specify a frame rate. I use the attached
> > script for testing, which works for me.
>=20
> It's nothing more than
>=20
> =C2=A0 gst-launch-1.0 -v v4l2src ! <any needed conversions> ! xvimagesink
>=20
> in my case, the conversions are bayer2rgbneon.=C2=A0 However, this only
> shows
> you the frame rate negotiated on the pads (which is actually good
> enough
> to show the issue.)
>=20
> How I stumbled across though this was when I was trying to encode:
>=20
> =C2=A0gst-launch-1.0 v4l2src device=3D/dev/video9 ! bayer2rgbneon ! \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0videoconvert ! x264enc sp=
eed-preset=3D1 ! avimux ! \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0filesink location=3Dtest.=
avi
>=20
> I noticed that vlc would always say it was playing the resulting AVI
> at 30fps.

In practice, I have the impression there is a fair reason why framerate
enumeration isn't implemented (considering there is only 1 valid rate).
Along with the norm fallback, GStreamer could could also consider the
currently set framerate as returned by=C2=A0VIDIOC_G_PARM. At the same time=
,
implementing that enumeration shall be straightforward, and will make a
large amount of existing userspace work.

regards,
Nicolas
--=-xaD73S9VP/RR5tcyQzYG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAljN06oACgkQcVMCLawGqByUagCeI3lU4c6DuhMZIT8TI7IeyLyw
AtgAoKvEUMki8JM51W1VwpEGTKYWTSI9
=pz27
-----END PGP SIGNATURE-----

--=-xaD73S9VP/RR5tcyQzYG--
