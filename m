Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52409 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725743AbeJaFYA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 01:24:00 -0400
Date: Tue, 30 Oct 2018 21:28:57 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl, mchehab@kernel.org
Subject: Re: [PATCH 3/4] SoC camera: Remove the framework and the drivers
Message-ID: <20181030202857.GH15991@w540>
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
 <20181029232134.25831-1-sakari.ailus@linux.intel.com>
 <20181030064311.030b6a81@coco.lan>
 <20181030091409.76b07620@coco.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="37nyS7qXrnu4wN2o"
Content-Disposition: inline
In-Reply-To: <20181030091409.76b07620@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--37nyS7qXrnu4wN2o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Tue, Oct 30, 2018 at 09:14:09AM -0300, Mauro Carvalho Chehab wrote:
> Em Tue, 30 Oct 2018 01:21:34 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
>
> > The SoC camera framework has been obsolete for some time and it is no
> > longer functional. A few drivers have been converted to the V4L2
> > sub-device API but for the rest the conversion has not taken place yet.
> >
> > In order to keep the tree clean and to avoid keep maintaining
> > non-functional and obsolete code, remove the SoC camera framework as we=
ll
> > as the drivers that depend on it.
> >
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > Resending, this time with git format-patch -D .
> >
> >  MAINTAINERS                                        |    8 -
> >  drivers/media/i2c/Kconfig                          |    8 -
> >  drivers/media/i2c/Makefile                         |    1 -
> >  drivers/media/i2c/soc_camera/Kconfig               |   66 -
> >  drivers/media/i2c/soc_camera/Makefile              |   10 -
> >  drivers/media/i2c/soc_camera/ov9640.h              |  208 --
> >  drivers/media/i2c/soc_camera/soc_mt9m001.c         |  757 -------
> >  drivers/media/i2c/soc_camera/soc_mt9t112.c         | 1157 -----------
> >  drivers/media/i2c/soc_camera/soc_mt9v022.c         | 1012 ---------
> >  drivers/media/i2c/soc_camera/soc_ov5642.c          | 1087 ----------
> >  drivers/media/i2c/soc_camera/soc_ov772x.c          | 1123 ----------
> >  drivers/media/i2c/soc_camera/soc_ov9640.c          |  738 -------
> >  drivers/media/i2c/soc_camera/soc_ov9740.c          |  996 ---------
> >  drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c      | 1415 -------------
> >  drivers/media/i2c/soc_camera/soc_tw9910.c          |  999 ---------
>
> I don't see why we should remove those. I mean, Jacopo is
> actually converting those drivers to not depend on soc_camera,
> and it is a way better to review those patches with the old
> code in place.

I have converted a few drivers used by some SH boards where I dropped
dependencies on soc_camera, not to remove camera support from those. For
others I don't have cameras to test with, nor I know about boards in
mainline using them.

=46rom my side, driver conversion is done.

>
> So, at least while Jacopo is keep doing this work, I would keep
> at Kernel tree, as it helps to see a diff when the driver changes
> when getting rid of soc_camera dependencies.
>
> So, IMO, the best would be to move those to /staging, eventually
> depending on BROKEN.

However, somebody with a (rather old) development setup using those camera
sensor may wants to see if mainline supports them. We actually had a
few patches coming lately (for ov. I understand Sakari's argument that those
could be retrieved from git history, but a few people will notice imo.
I also understand the additional maintainership burden of keeping them
around, so I'm fine with either ways ;)

This is a list of the current situation in mainline, to have a better
idea:

$for i in `seq 1 9`; do CAM=3D$(head -n $i /tmp/soc_cams | tail -n 1); echo=
  $CAM; find drivers/media/ -name  $CAM; done
t9m001.c
drivers/media/i2c/soc_camera/mt9m001.c
mt9t112.c
drivers/media/i2c/mt9t112.c
drivers/media/i2c/soc_camera/mt9t112.c
mt9v022.c
drivers/media/i2c/soc_camera/mt9v022.c
ov5642.c
drivers/media/i2c/soc_camera/ov5642.c
ov772x.c
drivers/media/i2c/ov772x.c
drivers/media/i2c/soc_camera/ov772x.c
ov9640.c
drivers/media/i2c/soc_camera/ov9640.c
ov9740.c
drivers/media/i2c/soc_camera/ov9740.c
rj54n1cb0c.c
drivers/media/i2c/rj54n1cb0c.c
drivers/media/i2c/soc_camera/rj54n1cb0c.c
tw9910.c
drivers/media/i2c/tw9910.c
drivers/media/i2c/soc_camera/tw9910.c

So it seems to me only the following sensor do not have a
non-soc_camera driver at the moment:

mt9m001.c
mt9v022.c
ov5642.c
ov9640.c
ov9740.c

Thanks
   j

>
> Thanks,
> Mauro

--37nyS7qXrnu4wN2o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb2L8JAAoJEHI0Bo8WoVY8lfAQAKWT2vuZ+w/txYZrDeUqbhRf
f3dCCklpR88dHv65kxgC2gkW1aZLeUxzDW34zTf0hwXyFQ+t1S5Gx8z9aXMT8MHq
Nx+LE7mfl0ZY7pwVtLnqoTHAciofO/FcEd9mfCFutGb7iTeoI4NHH6GV9lq6ql8O
6JjXlIfKvalNYDVZTi0j3cdpdm9Z6LurPIbO+/qh0Rj4X5M9Ac5mgLSazwwClCHD
iACeqXVPZuYA4bHWbr+Tmti2pB8KzI5QRzfErnwdAJVzocDnS+ilqNJeZwDOvnYJ
Ss6bCKdmxob79mW11YmZ5mUCr/KuFMEJevKpzL81qF14KdZYgyKHp8O6jWv83TyV
grL1Pl5T/16Nwq7cK5VDHwW6/gCWS+/h7AEOzvASdZHoM4RJQbzCahVxzzS1WbeP
Fka9TFf78gJT94eo0vCn+NLjZ7s40THjAs9L+WM2H/Af+844E2ZFFCiYUKePbHXT
Y15Uub2BBczvPwKgKRulht061f7LPIYkdcd6DBuDK6M+DgBmvTPfF3i/gOddVOiM
xWOYem9uTZ7uoGFsNasLDrUPc6ZLR4m+ISTTw/pFQDVioGSUZlQBiZYCGLu3wtQS
/hDTH5f5xiuuUCEIaEiLhOIFDM40cInYEgaM2lnCo2LlxTFiysJ6Q9aBYMJIT+hj
eaxRq353dD0e11s1mkue
=mT5E
-----END PGP SIGNATURE-----

--37nyS7qXrnu4wN2o--
