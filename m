Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38137 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0D1Lv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 07:51:29 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Wed, 28 Apr 2010 06:51:23 -0500
Subject: RE: [PATCH-V7] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on
 top of DSS2
Message-ID: <A24693684029E5489D1D202277BE894454F7830E@dlee02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1270634430-5549-2-git-send-email-hvaibhav@ti.com>
 <A24693684029E5489D1D202277BE894454F77EAB@dlee02.ent.ti.com>
 <19F8576C6E063C45BE387C64729E7394044E2A59ED@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044E2A59ED@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Hiremath, Vaibhav
> Sent: Wednesday, April 28, 2010 1:17 AM
> To: Aguirre, Sergio; linux-media@vger.kernel.org
> Cc: mchehab@redhat.com; Karicheri, Muralidharan; hverkuil@xs4all.nl
> Subject: RE: [PATCH-V7] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver
> on top of DSS2
> 
> > -----Original Message-----
> > From: Aguirre, Sergio
> > Sent: Wednesday, April 28, 2010 12:27 AM
> > To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> > Cc: mchehab@redhat.com; Karicheri, Muralidharan; hverkuil@xs4all.nl
> > Subject: RE: [PATCH-V7] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2
> driver on
> > top of DSS2
> >
> > Vaibhav,
> >
> > > -----Original Message-----
> > > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > > owner@vger.kernel.org] On Behalf Of Hiremath, Vaibhav
> > > Sent: Wednesday, April 07, 2010 5:01 AM
> > > To: linux-media@vger.kernel.org
> > > Cc: mchehab@redhat.com; Karicheri, Muralidharan; hverkuil@xs4all.nl;
> > > Hiremath, Vaibhav
> > > Subject: [PATCH-V7] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver
> on
> > > top of DSS2
> > >
> > > From: Vaibhav Hiremath <hvaibhav@ti.com>
> > >
> > > Features Supported -
> > > 	1. Provides V4L2 user interface for the video pipelines of DSS
> > > 	2. Basic streaming working on LCD, DVI and TV.
> > > 	3. Works on latest DSS2 library from Tomi
> > > 	4. Support for various pixel formats like YUV, UYVY, RGB32, RGB24,
> > > 	   RGB565
> > > 	5. Supports Alpha blending.
> > > 	6. Supports Color keying both source and destination.
> > > 	7. Supports rotation.
> > > 	8. Supports cropping.
> > > 	9. Supports Background color setting.
> > > 	10. Allocated buffers to only needed size
> > >
> >
> > This patch is broken in latest kernel. There are 2 main problems:
> [Hiremath, Vaibhav] Sergio,
> 
> I do have patch fixing this issue and waiting V4L2 master to get updated
> first. I have attached patch here.
> 
> The very first thing is this patch has been created against latest
> V4L2/master branch and not linux-omap branch. So there could be some gap
> between the merges of 2 branches.
> 
> Also on regular basis (almost daily) I am making sure that all the patches
> which are submitted to the list are still get applied cleanly and works,
> obviously against their respective repositories.

Ok, apologies. I didn't knew you kept an updated patch somewhere else.

I sincerely thought you haven't reposted this patch again. I'll look to the most updated version.

Thanks,
Sergio

> 
> Thanks,
> Vaibhav
> >
> > 1. ARCH_OMAP24XX and ARCH_OMAP34XX doesn't exist anymore in latest
> kernel.
> >
> > Tony has left only ARCH_OMAP2420, ARCH_OMAP2430 and ARCH_OMAP3430. So, I
> did
> > the change represented in patch #0001.
> >
> > 2. It doesn't compile.
> >
> > See attached log.
> >
> > I was able to partially fix some problems:
> >
> > drivers/media/video/omap/omap_vout.c: In function 'vidioc_reqbufs':
> > drivers/media/video/omap/omap_vout.c:1841: error: implicit declaration
> of
> > function 'kfree'
> > drivers/media/video/omap/omap_vout.c: In function
> > 'omap_vout_create_video_devices':
> > drivers/media/video/omap/omap_vout.c:2375: error: implicit declaration
> of
> > function 'kmalloc'
> > ...
> > drivers/media/video/omap/omap_vout.c: In function 'omap_vout_probe':
> > drivers/media/video/omap/omap_vout.c:2514: error: implicit declaration
> of
> > function 'kzalloc'
> > drivers/media/video/omap/omap_vout.c:2514: warning: assignment makes
> pointer
> > from integer without a cast
> >
> > With the attached patch #0002. But still the other problems are related
> to
> > latest DSS2 framework changes.
> >
> > Can you please take a look at those?
> >
> > Regards,
> > Sergio
> >
> > > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > > ---
> > >  drivers/media/video/Kconfig             |    2 +
> > >  drivers/media/video/Makefile            |    2 +
> > >  drivers/media/video/omap/Kconfig        |   11 +
> > >  drivers/media/video/omap/Makefile       |    7 +
> > >  drivers/media/video/omap/omap_vout.c    | 2644
> > > +++++++++++++++++++++++++++++++
> > >  drivers/media/video/omap/omap_voutdef.h |  147 ++
> > >  drivers/media/video/omap/omap_voutlib.c |  293 ++++
> > >  drivers/media/video/omap/omap_voutlib.h |   34 +
> > >  8 files changed, 3140 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/media/video/omap/Kconfig
> > >  create mode 100644 drivers/media/video/omap/Makefile
> > >  create mode 100644 drivers/media/video/omap/omap_vout.c
> > >  create mode 100644 drivers/media/video/omap/omap_voutdef.h
> > >  create mode 100644 drivers/media/video/omap/omap_voutlib.c
> > >  create mode 100644 drivers/media/video/omap/omap_voutlib.h
> > >
> >
> > <snip>
