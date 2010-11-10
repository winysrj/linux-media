Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37790 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0KJNJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 08:09:15 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Muralidharan Karicheri <mkaricheri@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 10 Nov 2010 18:38:57 +0530
Subject: RE: [PATCH 0/6] davinci vpbe: V4L2 Display driver for DM644X
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC1A7C79@dbde02.ent.ti.com>
In-Reply-To: <AANLkTimmDcxZsNEruFrr+qwnairJRZGCsnOTJBA7BPQu@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Murali,
  I will change the name order.
Thanks and Regards,
-manju

On Wed, Nov 10, 2010 at 18:35:16, Muralidharan Karicheri wrote:
> Manjunath,
> 
> Thank you for putting up this patch together. I didn't see the 1/6 of this series in the mailing list. Also it appears as if the patch came from me. Please add my sign-off as second, you being the first.
> 
> Murali
> On Mon, Nov 8, 2010 at 9:54 AM, Manjunath Hadli <manjunath.hadli@ti.com> wrote:
> > This driver is written for Texas Instruments's DM644X VPBE IP.
> > This SoC supports 2 video planes and 2 OSD planes as part of its OSD 
> > (On Screen Display) block. The OSD lanes predminantly support RGB 
> > space and the Video planes support YUV data. Out of these 4, the 2 
> > video planes are supported as part of the V4L2 driver. These would be 
> > enumerated as video2 and video3 dev nodes.
> > The blending and video timing generator unit (VENC- for Video Encoder) 
> > is the unit which combines/blends the output of these 4 planes into a 
> > single stream and this output is given to Video input devices like TV 
> > and other digital LCDs. The software for VENC is designed as a 
> > subdevice with support for SD(NTSC and PAL) modes and 2 outputs.
> > This SoC forms the iniial implementation of its later additions like 
> > DM355 and DM365.
> >
> > Muralidharan Karicheri (6):
> >  davinci vpbe: V4L2 display driver for DM644X SoC
> >  davinci vpbe: VPBE display driver
> >  davinci vpbe: OSD(On Screen Display ) block
> >  davinci vpbe: VENC( Video Encoder) implementation
> >  davinci vpbe: platform specific additions
> >  davinci vpbe: Build infrastructure for VPBE driver
> >
> >  arch/arm/mach-davinci/board-dm644x-evm.c     |   85 +-
> >  arch/arm/mach-davinci/dm644x.c               |  181 ++-
> >  arch/arm/mach-davinci/include/mach/dm644x.h  |    4 +
> >  drivers/media/video/davinci/Kconfig          |   22 +
> >  drivers/media/video/davinci/Makefile         |    2 +
> >  drivers/media/video/davinci/vpbe.c           |  861 ++++++++++
> >  drivers/media/video/davinci/vpbe_display.c   | 2283 
> > ++++++++++++++++++++++++++
> >  drivers/media/video/davinci/vpbe_osd.c       | 1208 ++++++++++++++
> >  drivers/media/video/davinci/vpbe_osd_regs.h  |  389 +++++
> >  drivers/media/video/davinci/vpbe_venc.c      |  617 +++++++
> >  drivers/media/video/davinci/vpbe_venc_regs.h |  189 +++
> >  include/media/davinci/vpbe.h                 |  187 +++
> >  include/media/davinci/vpbe_display.h         |  144 ++
> >  include/media/davinci/vpbe_osd.h             |  397 +++++
> >  include/media/davinci/vpbe_types.h           |  170 ++
> >  include/media/davinci/vpbe_venc.h            |   70 +
> >  16 files changed, 6790 insertions(+), 19 deletions(-)
> >  create mode 100644 drivers/media/video/davinci/vpbe.c
> >  create mode 100644 drivers/media/video/davinci/vpbe_display.c
> >  create mode 100644 drivers/media/video/davinci/vpbe_osd.c
> >  create mode 100644 drivers/media/video/davinci/vpbe_osd_regs.h
> >  create mode 100644 drivers/media/video/davinci/vpbe_venc.c
> >  create mode 100644 drivers/media/video/davinci/vpbe_venc_regs.h
> >  create mode 100644 include/media/davinci/vpbe.h
> >  create mode 100644 include/media/davinci/vpbe_display.h
> >  create mode 100644 include/media/davinci/vpbe_osd.h
> >  create mode 100644 include/media/davinci/vpbe_types.h
> >  create mode 100644 include/media/davinci/vpbe_venc.h
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" 
> > in the body of a message to majordomo@vger.kernel.org More majordomo 
> > info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> --
> Murali Karicheri
> mkaricheri@gmail.com
> 

