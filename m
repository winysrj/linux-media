Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3335 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab0KMMxM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 07:53:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH 0/6] davinci vpbe: V4L2 Display driver for DM644X
Date: Sat, 13 Nov 2010 13:52:19 +0100
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1289228045-4512-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1289228045-4512-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011131352.20002.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Manju,

I've reviewed the other patches as well. The only one for which I had comments
was patch 2/6.

However, what I think would be useful here is to have an overview document,
either as part of a source or header, or as a separate text document. It is
not easy to get a good overview of how everything fits together, and a document
that describes the various parts and how they fit together would be very
benificial.

I am thinking in particular of vendors building a new board based on this
device: how and where do you define new i2c display devices, how are they
initialized, etc.

Regards,

	Hans

On Monday, November 08, 2010 15:54:05 Manjunath Hadli wrote:
> This driver is written for Texas Instruments's DM644X VPBE IP.
> This SoC supports 2 video planes and 2 OSD planes as part of its 
> OSD (On Screen Display) block. The OSD lanes predminantly support 
> RGB space and the Video planes support YUV data. Out of these 4,
> the 2 video planes are supported as part of the V4L2 driver. These 
> would be enumerated as video2 and video3 dev nodes. 
> The blending and video timing generator unit (VENC- for Video Encoder)
> is the unit which combines/blends the output of these 4 planes
> into a single stream and this output is given to Video input devices
> like TV and other digital LCDs. The software for VENC is designed as
> a subdevice with support for SD(NTSC and PAL) modes and 2 outputs.
> This SoC forms the iniial implementation of its later additions 
> like DM355 and DM365.
> 
> Muralidharan Karicheri (6):
>   davinci vpbe: V4L2 display driver for DM644X SoC
>   davinci vpbe: VPBE display driver
>   davinci vpbe: OSD(On Screen Display ) block
>   davinci vpbe: VENC( Video Encoder) implementation
>   davinci vpbe: platform specific additions
>   davinci vpbe: Build infrastructure for VPBE driver
> 
>  arch/arm/mach-davinci/board-dm644x-evm.c     |   85 +-
>  arch/arm/mach-davinci/dm644x.c               |  181 ++-
>  arch/arm/mach-davinci/include/mach/dm644x.h  |    4 +
>  drivers/media/video/davinci/Kconfig          |   22 +
>  drivers/media/video/davinci/Makefile         |    2 +
>  drivers/media/video/davinci/vpbe.c           |  861 ++++++++++
>  drivers/media/video/davinci/vpbe_display.c   | 2283 ++++++++++++++++++++++++++
>  drivers/media/video/davinci/vpbe_osd.c       | 1208 ++++++++++++++
>  drivers/media/video/davinci/vpbe_osd_regs.h  |  389 +++++
>  drivers/media/video/davinci/vpbe_venc.c      |  617 +++++++
>  drivers/media/video/davinci/vpbe_venc_regs.h |  189 +++
>  include/media/davinci/vpbe.h                 |  187 +++
>  include/media/davinci/vpbe_display.h         |  144 ++
>  include/media/davinci/vpbe_osd.h             |  397 +++++
>  include/media/davinci/vpbe_types.h           |  170 ++
>  include/media/davinci/vpbe_venc.h            |   70 +
>  16 files changed, 6790 insertions(+), 19 deletions(-)
>  create mode 100644 drivers/media/video/davinci/vpbe.c
>  create mode 100644 drivers/media/video/davinci/vpbe_display.c
>  create mode 100644 drivers/media/video/davinci/vpbe_osd.c
>  create mode 100644 drivers/media/video/davinci/vpbe_osd_regs.h
>  create mode 100644 drivers/media/video/davinci/vpbe_venc.c
>  create mode 100644 drivers/media/video/davinci/vpbe_venc_regs.h
>  create mode 100644 include/media/davinci/vpbe.h
>  create mode 100644 include/media/davinci/vpbe_display.h
>  create mode 100644 include/media/davinci/vpbe_osd.h
>  create mode 100644 include/media/davinci/vpbe_types.h
>  create mode 100644 include/media/davinci/vpbe_venc.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
