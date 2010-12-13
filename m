Return-path: <mchehab@gaivota>
Received: from comal.ext.ti.com ([198.47.26.152]:54268 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab0LMOtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 09:49:46 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 13 Dec 2010 08:49:35 -0600
Subject: RE: [PATCH v5 0/6] davinci vpbe: dm6446 v4l2 driver
Message-ID: <A69FA2915331DC488A831521EAE36FE401BE3EA1DF@dlee06.ent.ti.com>
References: <1292059074-668-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1292059074-668-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Manju,

>2. Fixed Murali's comments on moving davinci_vpbe_readme.txt to different
>patch

different patch or path? My comment was to move the documentation to 
Documentation folder. But it is still in it's original path :(

>
>Manjunath Hadli (6):
>  davinci vpbe: V4L2 display driver for DM644X SoC
>  davinci vpbe: VPBE display driver
>  davinci vpbe: OSD(On Screen Display) block
>  davinci vpbe: VENC( Video Encoder) implementation
>  davinci vpbe: platform specific additions
>  davinci vpbe: Build infrastructure for VPBE driver
>
> arch/arm/mach-davinci/board-dm644x-evm.c           |   79 +-
> arch/arm/mach-davinci/dm644x.c                     |  164 ++-
> arch/arm/mach-davinci/include/mach/dm644x.h        |    4 +
> drivers/media/video/davinci/Kconfig                |   22 +
> drivers/media/video/davinci/Makefile               |    2 +
> .../media/video/davinci/davinci_vpbe_readme.txt    |  100 +
> drivers/media/video/davinci/vpbe.c                 |  837 ++++++++
> drivers/media/video/davinci/vpbe_display.c         | 2099
>++++++++++++++++++++
> drivers/media/video/davinci/vpbe_osd.c             | 1211 +++++++++++
> drivers/media/video/davinci/vpbe_osd_regs.h        |  389 ++++
> drivers/media/video/davinci/vpbe_venc.c            |  574 ++++++
> drivers/media/video/davinci/vpbe_venc_regs.h       |  189 ++
> include/media/davinci/vpbe.h                       |  186 ++
> include/media/davinci/vpbe_display.h               |  146 ++
> include/media/davinci/vpbe_osd.h                   |  397 ++++
> include/media/davinci/vpbe_types.h                 |   93 +
> include/media/davinci/vpbe_venc.h                  |   38 +
> 17 files changed, 6511 insertions(+), 19 deletions(-)
> create mode 100644 drivers/media/video/davinci/davinci_vpbe_readme.txt
> create mode 100644 drivers/media/video/davinci/vpbe.c
> create mode 100644 drivers/media/video/davinci/vpbe_display.c
> create mode 100644 drivers/media/video/davinci/vpbe_osd.c
> create mode 100644 drivers/media/video/davinci/vpbe_osd_regs.h
> create mode 100644 drivers/media/video/davinci/vpbe_venc.c
> create mode 100644 drivers/media/video/davinci/vpbe_venc_regs.h
> create mode 100644 include/media/davinci/vpbe.h
> create mode 100644 include/media/davinci/vpbe_display.h
> create mode 100644 include/media/davinci/vpbe_osd.h
> create mode 100644 include/media/davinci/vpbe_types.h
> create mode 100644 include/media/davinci/vpbe_venc.h
>
>_______________________________________________
>Davinci-linux-open-source mailing list
>Davinci-linux-open-source@linux.davincidsp.com
>http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
