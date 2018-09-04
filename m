Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:51469 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbeIDN6W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2018 09:58:22 -0400
Date: Tue, 4 Sep 2018 11:33:58 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ysato@users.sourceforge.jp, dalias@libc.org,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Remove sh_mobile_ceu_camera from arch/sh
Message-ID: <20180904093358.GK20333@w540>
References: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
 <20180831122558.zv7537uyfw5pcnqj@valkosipuli.retiisi.org.uk>
 <20180903072234.GA4116@w540>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rf72Gf+bfLC8kxKs"
Content-Disposition: inline
In-Reply-To: <20180903072234.GA4116@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--rf72Gf+bfLC8kxKs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi again Sakari,
   sorry, I'm confusing you

On Mon, Sep 03, 2018 at 09:22:34AM +0200, jacopo mondi wrote:
> Hi Sakari,
>
> On Fri, Aug 31, 2018 at 03:25:58PM +0300, Sakari Ailus wrote:
> > Hi Jacopo,
> >
> > On Mon, May 28, 2018 at 06:37:06PM +0200, Jacopo Mondi wrote:
> > > Hello,
> > >     this series removes dependencies on the soc_camera based
> > > sh_mobile_ceu_camera driver from 3 board files in arch/sh and from one
> > > sensor driver used by one of those boards.
> > >
> > > Hans, this means there are no more user of the soc_camera framework that I know
> > > of in Linux, and I guess we can now plan of to remove that framework.
> >
> > What's the status of this set? I think it'd be nice to get it in; the CEU
> > driver is the last using SoC camera framework.
> >

The series went in in the media tree in late June and I now see it in
v4.19-rc2.

Sorry for the confusion.

The other soc_camera series which is pending for approval is the one
removing dependencies on the framework from some SH defconfigs:
https://lkml.org/lkml/2018/7/4/323

Mauro was exitant to take this one through the media tree, and he's
probably right SH maintainers should at least ack the series. So far,
I haven't heard from them.

I'll try to rebase it on latest version and re-send.

Thanks
   j

>
> There's an open comment from Geert on this series.
> I'll resend, then I guess it can be collected.
>
> > I guess an ack from the SH folks would be needed for these patches to go
> > through the media tree.
> >
>
> I would have loved to hear from them on this and other media patches
> which are sh-related. It hasn't happen, and as for the previous patches
> removing usage of the old ceu driver for SH boards, I guess this can go in
> through the media tree. But I let Hans decide how to handle this.
>
> > On the sensor driver patches --- please just move the files. The CEU was
> > the last that it was possible to use the drivers with.
> >
>
> My understanding was that Hans preferred to do it after all
> dependencies are moved away from soc_camera.
>
> Maybe at ELC-E we should have a status-check and decide how to move
> forward with soc_camera deprecation.
>
> Thanks
>    j
>
> > --
> > Kind regards,
> >
> > Sakari Ailus
> > e-mail: sakari.ailus@iki.fi



--rf72Gf+bfLC8kxKs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbjlGGAAoJEHI0Bo8WoVY8fCoP/0F8FsHOYWBYj8TX9i4AOemi
w53upV1NL55gJqnTY6jmAcXy1a626rVd5W25f6eHaSigx1Vm9mGXcElpqG7tRCrW
539AgDdtwXjlFEmGFMB57HKSVw8rvrS+IVelPJxPurCB81yGviB0wAIAGglzyp0K
xRV4/MTKgWu+L9bnINqUZ+uVHbdLNI4O2BRfSBlOteRDHWb1ybQbTctq2noSzBoq
3GeAS5fUt+/hrQqtXxE/O/1egDH7i52nvdvxnWJO9fvWTuN9Qi5jq+5MrQ1hmEDz
28ZWmnx0XgpnzOkvV81OC8K5hndp3KEsJYyfAgOEPFXD2Ns8oOUzOkvaCGmk9opc
hGuW+rNzuydJorKGGd5qm2CpmkdXZiJ1m0sMAgRXamKL0eUVEfl2arwXVzDCSFmU
yhOuUYLrRcTv0xKCQjQGj1YgjFDPVbRMqU/zQcvX9Vx9V9SArPfW6zaCu9Od/SsH
fREVU1hX83i/j7rFisY4rLf+V6xsn/v2bcG0DzRbrr4owong35PFHdBf4Nqjsd6D
3Sspg2LqAihwgH2dAkYSBwyHqd+xK7WrMg5KAi65hMe+znF1YQusuXbhtjlC0xEv
XgTjhoRl2/B7M4muErTK86GyqjYLNTlpWenVQeM5sNtdDYqG2C/xy8orw4olaG0v
/G8G/fKwWVrxbY0aoAcX
=cbPT
-----END PGP SIGNATURE-----

--rf72Gf+bfLC8kxKs--
