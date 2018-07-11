Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:34801 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbeGKHYp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 03:24:45 -0400
Date: Wed, 11 Jul 2018 09:21:48 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
Message-ID: <20180711072148.GH8180@w540>
References: <1531247768-15362-1-git-send-email-jacopo@jmondi.org>
 <e9057214-2e1a-df78-8983-c63c80448cb1@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jRdC2OsRnuV8iIl8"
Content-Disposition: inline
In-Reply-To: <e9057214-2e1a-df78-8983-c63c80448cb1@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jRdC2OsRnuV8iIl8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Tue, Jul 10, 2018 at 02:10:54PM -0700, Steve Longerbeam wrote:
> Hi Jacopo,
>
> Sorry to report my testing on SabreSD has same result
> as last time. This series fixes the LP-11 timeout at stream
> on but captured images are still blank. I tried the 640x480
> mode with UYVY2X8. Here is the pad config:

This saddens me :(

I'm capturing with the same format and sizes... this shouldn't be the
issue

Could you confirm this matches what you have in your tree?
5dc2c80 media: ov5640: Fix timings setup code
b35e757 media: i2c: ov5640: Re-work MIPI startup sequence
3c4a737 media: ov5640: fix frame interval enumeration
41cb1c7 media: ov5640: adjust xclk_max
c3f3ba3 media: ov5640: add support of module orientation
ce85705 media: ov5640: add HFLIP/VFLIP controls support
8663341 media: ov5640: Program the visible resolution
476dec0 media: ov5640: Add horizontal and vertical totals
dba13a0 media: ov5640: Change horizontal and vertical resolutions name
8f57c2f media: ov5640: Init properly the SCLK dividers

Thanks
   j

>
> # media-ctl --get-v4l2 "'ov5640 1-003c':0"
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 [fmt:UYVY8_2X8/640x480@1/30 field:n=
one colorspace:srgb xfer:srgb
> ycbcr:601 quantization:full-range]
>
> Steve
>
> On 07/10/2018 11:36 AM, Jacopo Mondi wrote:
> >Hello,
> >    this series fixes capture operations on i.MX6Q platforms (and possib=
le other
> >platforms reported not working) using MIPI CSI-2 interface.
> >
> >This iteration expands the v1 version with an additional fix, initially
> >submitted by Maxime in his series:
> >[PATCH v3 00/12] media: ov5640: Misc cleanup and improvements
> >https://www.spinics.net/lists/linux-media/msg134436.html
> >
> >The original patch has been reported not fully fixing the issues by Dani=
el Mack
> >in his comment here below (on a Qualcomm platform if I'm not wrong):
> >https://www.spinics.net/lists/linux-media/msg134524.html
> >On my i.MX6Q testing platform that patch alone does not fix MIPI capture
> >neither.
> >
> >The version I'm sending here re-introduces some of the timings parameter=
s in the
> >initial configuration blob (not in the single mode ones), which apparent=
ly has
> >to be at least initially programmed to allow the driver to later program=
 them
> >singularly in the 'set_timings()' function. Unfortunately I do not have =
a real
> >rationale behind this which explains why it has to be done this way :(
> >
> >For the MIPI startup sequence re-work patch, no changes compared to v1.
> >Steve reported he has verified the LP-11 timout issue is solved on his t=
esting
> >platform too. For more details, please refer to the v1 cover letter:
> >https://www.mail-archive.com/linux-media@vger.kernel.org/msg133352.html
> >
> >Thanks
> >    j
> >
> >Jacopo Mondi (1):
> >   media: i2c: ov5640: Re-work MIPI startup sequence
> >
> >Samuel Bobrowicz (1):
> >   media: ov5640: Fix timings setup code
> >
> >  drivers/media/i2c/ov5640.c | 107 ++++++++++++++++++++++++++++++++++---=
--------
> >  1 file changed, 82 insertions(+), 25 deletions(-)
> >
> >--
> >2.7.4
> >
>

--jRdC2OsRnuV8iIl8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbRbAMAAoJEHI0Bo8WoVY8Y5IP/jtQ6KA+F82HNzs+BKMEkfaa
KhxuWyr9l/9vPuvILTryIjKHCHSworp/tljpBxzuVUe4IIYbY5hmUSHsBWQldl2q
3+h/lwS6AnmHSvfFEkKKwVCqBxSqMudPSfoMxtYuzxkzWLMtjG3rMzAmyZQmNaCM
ET3eUe3Gu4osradwt97m14aM/xNEGlW0KEmZIT1gIMo35Hbgaw4H+cq/7ilQnFLY
mnyhKluKS7RDrRNfjzbRWP0kQs/b/lf2cvUlf/m/R4I2H+Imwj/WR5NKcFYFyIxx
KhB/UD+C8WhRCAo4gCKFjJsqnG14jY3puuQnrKnUYEUrq9n7anjtXdfcl4ongRbi
a/E0YGFmKHg222pyzEK0KcHB2Xdi+iXXfL/DGbz2v6Ze8rOu7SnlEs45CgGWhqBy
bPJLd1nem0StBodK/d6hem4ZqmqOlpHlPcW+uft7rE+G8U1YN8596oVzgDq1vARk
v4owmEOV4GOgUVlYgqBt3ZbJxG0iCC7D89H9Qc910Nle7TXuuYUVlwdpaBWIhCpu
gCYZBBrHz4xGiLOr5H7AVsPVRXykxrIVQkISibujyKkNJbLfD/YQ4tqCvraUQaUf
kB5zi8c4m0B2DJU+O7IAluJL7cVLN5nx3tNWj86NFZRBpdtsonea6JUYmgVlzad+
YAaXSJw6RhDzebikhNHp
=qY6P
-----END PGP SIGNATURE-----

--jRdC2OsRnuV8iIl8--
