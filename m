Return-path: <mchehab@gaivota>
Received: from bear.ext.ti.com ([192.94.94.41]:48751 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab0LWMB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 07:01:56 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 23 Dec 2010 17:31:33 +0530
Subject: RE: [PATCH v10 0/8] davinci vpbe: dm6446 v4l2 driver
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930247F9A810@dbde02.ent.ti.com>
In-Reply-To: <1293105217-16735-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, Dec 23, 2010 at 17:23:37, Hadli, Manjunath wrote:
> version10: addressed Kevin's and Sergei's comments
> on:
> 1.Lines spacing.
> 2.Language errors
  3.Now based on Kevin Hilman's tree :)
> 
> Manjunath Hadli (8):
>   davinci vpbe: V4L2 display driver for DM644X SoC
>   davinci vpbe: VPBE display driver
>   davinci vpbe: OSD(On Screen Display) block
>   davinci vpbe: VENC( Video Encoder) implementation
>   davinci vpbe: platform specific additions-khilman
>   davinci vpbe: board specific additions
>   davinci vpbe: Build infrastructure for VPBE driver
>   davinci vpbe: Readme text for Dm6446 vpbe
> 
>  Documentation/video4linux/README.davinci-vpbe |   93 ++
>  arch/arm/mach-davinci/board-dm644x-evm.c      |   81 +-
>  arch/arm/mach-davinci/dm644x.c                |  172 ++-
>  arch/arm/mach-davinci/include/mach/dm644x.h   |    4 +
>  drivers/media/video/davinci/Kconfig           |   22 +
>  drivers/media/video/davinci/Makefile          |    2 +
>  drivers/media/video/davinci/vpbe.c            |  836 ++++++++++
>  drivers/media/video/davinci/vpbe_display.c    | 2099 +++++++++++++++++++++++++
>  drivers/media/video/davinci/vpbe_osd.c        | 1211 ++++++++++++++
>  drivers/media/video/davinci/vpbe_osd_regs.h   |  389 +++++
>  drivers/media/video/davinci/vpbe_venc.c       |  568 +++++++
>  drivers/media/video/davinci/vpbe_venc_regs.h  |  189 +++
>  include/media/davinci/vpbe.h                  |  186 +++
>  include/media/davinci/vpbe_display.h          |  146 ++
>  include/media/davinci/vpbe_osd.h              |  397 +++++
>  include/media/davinci/vpbe_types.h            |   93 ++
>  include/media/davinci/vpbe_venc.h             |   38 +
>  17 files changed, 6505 insertions(+), 21 deletions(-)  create mode 100644 Documentation/video4linux/README.davinci-vpbe
>  create mode 100644 drivers/media/video/davinci/vpbe.c
>  create mode 100644 drivers/media/video/davinci/vpbe_display.c
>  create mode 100644 drivers/media/video/davinci/vpbe_osd.c
>  create mode 100644 drivers/media/video/davinci/vpbe_osd_regs.h
>  create mode 100644 drivers/media/video/davinci/vpbe_venc.c
>  create mode 100644 drivers/media/video/davinci/vpbe_venc_regs.h
>  create mode 100644 include/media/davinci/vpbe.h  create mode 100644 include/media/davinci/vpbe_display.h
>  create mode 100644 include/media/davinci/vpbe_osd.h  create mode 100644 include/media/davinci/vpbe_types.h
>  create mode 100644 include/media/davinci/vpbe_venc.h
> 
> 

