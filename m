Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:41437 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbeICLlf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2018 07:41:35 -0400
Date: Mon, 3 Sep 2018 09:22:34 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ysato@users.sourceforge.jp, dalias@libc.org,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Remove sh_mobile_ceu_camera from arch/sh
Message-ID: <20180903072234.GA4116@w540>
References: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
 <20180831122558.zv7537uyfw5pcnqj@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20180831122558.zv7537uyfw5pcnqj@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Fri, Aug 31, 2018 at 03:25:58PM +0300, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Mon, May 28, 2018 at 06:37:06PM +0200, Jacopo Mondi wrote:
> > Hello,
> >     this series removes dependencies on the soc_camera based
> > sh_mobile_ceu_camera driver from 3 board files in arch/sh and from one
> > sensor driver used by one of those boards.
> >
> > Hans, this means there are no more user of the soc_camera framework that I know
> > of in Linux, and I guess we can now plan of to remove that framework.
>
> What's the status of this set? I think it'd be nice to get it in; the CEU
> driver is the last using SoC camera framework.
>

There's an open comment from Geert on this series.
I'll resend, then I guess it can be collected.

> I guess an ack from the SH folks would be needed for these patches to go
> through the media tree.
>

I would have loved to hear from them on this and other media patches
which are sh-related. It hasn't happen, and as for the previous patches
removing usage of the old ceu driver for SH boards, I guess this can go in
through the media tree. But I let Hans decide how to handle this.

> On the sensor driver patches --- please just move the files. The CEU was
> the last that it was possible to use the drivers with.
>

My understanding was that Hans preferred to do it after all
dependencies are moved away from soc_camera.

Maybe at ELC-E we should have a status-check and decide how to move
forward with soc_camera deprecation.

Thanks
   j

> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbjOEjAAoJEHI0Bo8WoVY827QQAL5BBLuOSE1Usaz9SuA9h0MB
YGANEAEsK9TKaSpDtRT5mf4IqOAUztETRPnP99kjGV2w2EKQhESRCt7H4wOVHyba
1cSCzXESbwT0Nnb54jkbb/LJX7Cy/ks+jGQGvSBG9y8zC2fTc8zwWGoeXqquJLgN
wImMWDdehPiNolJuWQN+9RoXGlXDiYr6Fr9SZuBDtc1THxUToDpGvyXvvs1PfPrP
8sXtZFD6MAnaDDZMk05g63w8z3Q353WfLub6KMLfn4w4ON3j3SZxcTFqGs3PdZA4
OsM6kCM3SdHiGxPR7RVmlqVUn/YyoF1DqOV0GZJzHSZ1TBHunly9guhxbHo7+oCZ
wm0BhHgvH7NvvHTfCR5Qvis26pG4/wkjCq96ylK9mSJ+bJ3bb03beown2b6th7d1
smv3R9g/5/UOW230Z3RKGVlDsSrd6ebZ8fcS82fNUHjoHlM2YSOohkeympPcnvoT
UkEJ+AKQ9+XgDZOA5Abrbe+/3owhCMbmd8z1y7in+vPekqwuhCWj05vwilYq6BY1
hgxQuAY5CjrfJEhhgFJd/FJ5qtj14h+Hps/rrTp+dQYrqoP1LDXYOVoi9tf7YswP
Oii5YpV6c8dyVN5VXCCLho2uUT3pF0sm7Xc+RZxvRskUgx8jAxr1fSyiZGaAV26Q
qOXrAaF4G4gIY52Y+jSA
=yu/f
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
