Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59326 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbeJaTCD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 15:02:03 -0400
Date: Wed, 31 Oct 2018 07:04:28 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: jacopo mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        hverkuil@xs4all.nl
Subject: Re: [PATCH 3/4] SoC camera: Remove the framework and the drivers
Message-ID: <20181031070428.4f9bb283@coco.lan>
In-Reply-To: <20181031093202.skhoqwnisqmhan4p@paasikivi.fi.intel.com>
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
        <20181029232134.25831-1-sakari.ailus@linux.intel.com>
        <20181030064311.030b6a81@coco.lan>
        <20181030091409.76b07620@coco.lan>
        <20181030202857.GH15991@w540>
        <20181030173513.64f8ebe1@coco.lan>
        <20181031093202.skhoqwnisqmhan4p@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 31 Oct 2018 11:32:02 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
>=20
> On Tue, Oct 30, 2018 at 05:35:23PM -0300, Mauro Carvalho Chehab wrote:
> > Em Tue, 30 Oct 2018 21:28:57 +0100
> > jacopo mondi <jacopo@jmondi.org> escreveu:
> >  =20
> > > Hi Mauro,
> > >=20
> > > On Tue, Oct 30, 2018 at 09:14:09AM -0300, Mauro Carvalho Chehab wrote=
: =20
> > > > Em Tue, 30 Oct 2018 01:21:34 +0200
> > > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > > >   =20
> > > > > The SoC camera framework has been obsolete for some time and it i=
s no
> > > > > longer functional. A few drivers have been converted to the V4L2
> > > > > sub-device API but for the rest the conversion has not taken plac=
e yet.
> > > > >
> > > > > In order to keep the tree clean and to avoid keep maintaining
> > > > > non-functional and obsolete code, remove the SoC camera framework=
 as well
> > > > > as the drivers that depend on it.
> > > > >
> > > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > > ---
> > > > > Resending, this time with git format-patch -D .
> > > > >
> > > > >  MAINTAINERS                                        |    8 -
> > > > >  drivers/media/i2c/Kconfig                          |    8 -
> > > > >  drivers/media/i2c/Makefile                         |    1 -
> > > > >  drivers/media/i2c/soc_camera/Kconfig               |   66 -
> > > > >  drivers/media/i2c/soc_camera/Makefile              |   10 -
> > > > >  drivers/media/i2c/soc_camera/ov9640.h              |  208 --
> > > > >  drivers/media/i2c/soc_camera/soc_mt9m001.c         |  757 -------
> > > > >  drivers/media/i2c/soc_camera/soc_mt9t112.c         | 1157 ------=
-----
> > > > >  drivers/media/i2c/soc_camera/soc_mt9v022.c         | 1012 ------=
---
> > > > >  drivers/media/i2c/soc_camera/soc_ov5642.c          | 1087 ------=
----
> > > > >  drivers/media/i2c/soc_camera/soc_ov772x.c          | 1123 ------=
----
> > > > >  drivers/media/i2c/soc_camera/soc_ov9640.c          |  738 -------
> > > > >  drivers/media/i2c/soc_camera/soc_ov9740.c          |  996 ------=
---
> > > > >  drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c      | 1415 ------=
-------
> > > > >  drivers/media/i2c/soc_camera/soc_tw9910.c          |  999 ------=
---   =20
> > > >
> > > > I don't see why we should remove those. I mean, Jacopo is
> > > > actually converting those drivers to not depend on soc_camera,
> > > > and it is a way better to review those patches with the old
> > > > code in place.   =20
> > >=20
> > > I have converted a few drivers used by some SH boards where I dropped
> > > dependencies on soc_camera, not to remove camera support from those. =
For
> > > others I don't have cameras to test with, nor I know about boards in
> > > mainline using them.
> > >=20
> > > From my side, driver conversion is done.
> > >  =20
> > > >
> > > > So, at least while Jacopo is keep doing this work, I would keep
> > > > at Kernel tree, as it helps to see a diff when the driver changes
> > > > when getting rid of soc_camera dependencies.
> > > >
> > > > So, IMO, the best would be to move those to /staging, eventually
> > > > depending on BROKEN.   =20
> > >=20
> > > However, somebody with a (rather old) development setup using those c=
amera
> > > sensor may wants to see if mainline supports them. We actually had a
> > > few patches coming lately (for ov. I understand Sakari's argument tha=
t those
> > > could be retrieved from git history, but a few people will notice imo.
> > > I also understand the additional maintainership burden of keeping them
> > > around, so I'm fine with either ways ;)
> > >=20
> > > This is a list of the current situation in mainline, to have a better
> > > idea:
> > >=20
> > > $for i in `seq 1 9`; do CAM=3D$(head -n $i /tmp/soc_cams | tail -n 1)=
; echo  $CAM; find drivers/media/ -name  $CAM; done
> > > t9m001.c
> > > drivers/media/i2c/soc_camera/mt9m001.c
> > > mt9t112.c
> > > drivers/media/i2c/mt9t112.c
> > > drivers/media/i2c/soc_camera/mt9t112.c
> > > mt9v022.c
> > > drivers/media/i2c/soc_camera/mt9v022.c
> > > ov5642.c
> > > drivers/media/i2c/soc_camera/ov5642.c
> > > ov772x.c
> > > drivers/media/i2c/ov772x.c
> > > drivers/media/i2c/soc_camera/ov772x.c
> > > ov9640.c
> > > drivers/media/i2c/soc_camera/ov9640.c
> > > ov9740.c
> > > drivers/media/i2c/soc_camera/ov9740.c
> > > rj54n1cb0c.c
> > > drivers/media/i2c/rj54n1cb0c.c
> > > drivers/media/i2c/soc_camera/rj54n1cb0c.c
> > > tw9910.c
> > > drivers/media/i2c/tw9910.c
> > > drivers/media/i2c/soc_camera/tw9910.c
> > >=20
> > > So it seems to me only the following sensor do not have a
> > > non-soc_camera driver at the moment:
> > >=20
> > > mt9m001.c
> > > mt9v022.c
> > > ov5642.c
> > > ov9640.c
> > > ov9740.c =20
> >=20
> > Ok. So, what about keeping just those 5 drivers at staging? If, after an
> > year, people won't do conversions, we can just drop them. =20
>=20
> They've been there for years without anyone converting them. Do note that
> the conversion can be still done once the code is removed.

Well, people converted a lot of drivers already. See above. It is
just that it takes time. The same applied to lirc: it stayed at
staging for years. People gradually converted the drivers until
we finally got rid of them.

That is the goal of staging: to give people some time to fix
issues on broken drivers.

> We did the same for a big bunch of sensor drivers that came with the
> atomisp2 driver. I don't see a difference here.

No, we only removed the atomisp driver after being sure that
the only party that was pushing it lost its interest on fixing
the issues. Even so, we waited for a while, as other parties
might manifest their interests on doing that.

Also, in the case of atomisp, there were no other drivers
depending on it, so removing it was a way easier and straight
forward.

The point is: there's absolutely no reason why we should rush
it, doing a half-baked removal, where several parts of the non
working code would be left on drivers and even the header file
for soc_camera.h would be kept.

The right way to do it is:

1) remove include soc_camera.h on drivers that don't need it anymore;
2) Move things to staging. There are actually two tasks here:
  2a) get rid of useless soc-camera depend code on drivers/board code,
      removing their dependencies of soc_camera.h;
  2b) move the soc-camera dependent code that makes sense to
      staging (sensors - and maybe driver/board code for platforms
      that are still be actively maintained);
3) wait for a couple of Kernel releases;
4) drop everything related to soc_camera from staging.

=46rom the e-mail from Jacopo, from sensors PoV, only those sensor
drivers may make sense to keep for a while:

	soc_mt9m001.c
	soc_mt9v022.c
	soc_ov5642.c
	soc_ov9640.c
	soc_ov9740.c =20

So, on step 2, we can very likely get rid of the other sensor drivers
that already exists and don't depend on soc_camera.

Thanks,
Mauro
