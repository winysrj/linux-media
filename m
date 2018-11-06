Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53589 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbeKFRvg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 12:51:36 -0500
Date: Tue, 6 Nov 2018 09:27:27 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Adam Ford <aford173@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>, steve_longerbeam@mentor.com,
        Jagan Teki <jagan@amarulasolutions.com>,
        p.zabel@pengutronix.de, Fabio Estevam <fabio.estevam@nxp.com>,
        gstreamer-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
Message-ID: <20181106082727.GW15991@w540>
References: <CAHCN7xKhGAXs0jGv96CfOfLQfVubxzsdE9UjpDu+4NM6oLDGWw@mail.gmail.com>
 <bc034299-4a32-f248-d09a-0d1b5872a506@mentor.com>
 <CAHCN7xKVUgpyCb5k7s0PNXW-efySSwP25ZGMLdbFnohATPwKhg@mail.gmail.com>
 <20181023230259.GA3766@w540>
 <CAHCN7xJaY_916OLHvaN_q1FwM2vqH5UXzVxLAS4DuEV0icPUXg@mail.gmail.com>
 <20181024140820.GB3766@w540>
 <CAHCN7xKbAuTmic+L-a2o1NreSCmYBKzzvmHuUTGZtVHELFoirg@mail.gmail.com>
 <CAHCN7xLP13PDT_VhV_iQzRB+VS7N4AxY+BObtLpz4bJ6RfxfWg@mail.gmail.com>
 <CAOMZO5Dkwrv4k=KGit+4wFFSr=ec94OpjUW56_D_aamjNPQH6g@mail.gmail.com>
 <CAHCN7xKs=wO9dxVAo=yxjWm10jH6TmAfgYwAfAd=J2uBT3rK1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aHyShe78FfJzbeER"
Content-Disposition: inline
In-Reply-To: <CAHCN7xKs=wO9dxVAo=yxjWm10jH6TmAfgYwAfAd=J2uBT3rK1w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aHyShe78FfJzbeER
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Adam,

On Mon, Nov 05, 2018 at 04:32:33PM -0600, Adam Ford wrote:
> On Mon, Oct 29, 2018 at 8:49 AM Fabio Estevam <festevam@gmail.com> wrote:
> >
> > Hi Adam,
> >
> > On Sun, Oct 28, 2018 at 3:58 PM Adam Ford <aford173@gmail.com> wrote:
> >
> > > Does anyone know when the media branch get's merged into the mainline
> > > kernel?  I assume we're in the merge window with 4.19 just having been
> > > released.  Once these have been merged into the mainline, I'll go
> > > through and start requesting they get pulled into 4.19 and/or 4.14
> > > if/when appropriate.
> >
> > This should happen in 4.20-rc1, which will probably be out next  Sunday.
> I sent an e-mail to stable with a list of a variety of patches for the
> ov5640 to be applied to 4.19.y  So far all looks pretty good, but I
> think I found on minor bug:

Thanks!

>
> If I attempt to change just the resolution, it doesn't take.
>
> Initial read
> media-ctl --get-v4l2 "'ov5640 2-0010':0"
> [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb
> ycbcr:601 quantization:full-range]
>
> Change resolution
> # media-ctl --set-v4l2 "'ov5640 2-0010':0[fmt:UYVY2X8/720x480 field:none]"
>
> Read it back
> # media-ctl --get-v4l2 "'ov5640 2-0010':0"
> [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb
> ycbcr:601 quantization:full-range]
>
> However, if I change the resolution AND the format to something other
> than UYVY2x8, the resolution changes. I can then change the format
> back to UYVY and capture and stream video at 1080p and 720x480.
> I can work around this, but I thought I'd mention it.  I was trying to
> figure out a patch to apply to the mailing list myself, but I wasn't
> able to fix it quickly.

Thanks, you are right, this is a known issue :(

There have been patches to address this issue floating around the
mailing list, none of them has yet made it up to inclusion.

Sam has sent a patch to fix this:
https://patchwork.linuxtv.org/patch/52489/

Hugues had something similar I cannot find, if I'm not wrong, and I
carry myself the patch I posted in the patchwork discussion in my
trees.

Feel free to go through the media list and comment. One more report on
this would help to increase chances to have one of those patches
re-sent and then included.

Also, bug reports are always very welcome, but to maximize the chances
they receive the required attention, could you make a new email thread
next time and drop this one please?

Thanks
  j

>
> adam
> adam

--aHyShe78FfJzbeER
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb4VBvAAoJEHI0Bo8WoVY89u8QAKTJtiKq5vUKEk2WmDfyjb/p
8/m+NgtmK44q6o0NgLC0IRoL7BpTZeMS14wKs6nX+YFqYJiZrlmzZf21Y1WNJ8XN
P2yqAsVTqKcf9rRyikbebxkC7BpFNyIRAoM1PrIcYZRdGMgiyl7XCnQ3/IShdaz0
WWILE7C1Pao8TF1a5aj7vcUxHHtaN8mrzTJ1yV1RZHVUd5xyQTL5aY2jEPowuRWH
x0Bljl3eu0uNHTZ5606aKDfFZavYjmK+cMnIfdVhtGay4Mp50RHEgWyEUPDJVXdc
taG1srOWF5xZNb0IMda/N6G5ATagXZnOOcl4cYgEBfCIVMEU1SNbHOSFWsWhoFHo
+WVydTkSoh2cvkWh0IS6hH+niteX7khC4zFJ+hxoGB/fBSXKEn2MVyp8GnWJUgfO
MxY+ub4lMumtFe4aWMYig2p7YcfaOlcJZkfxjKadQoSGMWveGcA/ZiA0qM4d1hEj
tv3THpF4nT62pSJVyskmjVFWWOSXW9qg7xGQs7OsJZXWENdF3Qaa2htfN+bzYFX2
YVhNS2govC/rhmhCXokR+Sw58tOpqFqQN0UromKB256D6eeo3iKLHf2BA//fXe80
d1SHg+WXslqUjdMNgHzGniPfdE4DJWdmzUu/IKs9VhVHpgjHqJERwIsyo8ZG910k
GLinMZzGgR6vwdtVMNWn
=m7tn
-----END PGP SIGNATURE-----

--aHyShe78FfJzbeER--
