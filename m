Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:46879 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858Ab1F0Gpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 02:45:49 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Mon, 27 Jun 2011 12:15:40 +0530
Subject: RE: [RESEND PATCH v19 0/6] davinci vpbe: dm6446 v4l2 driver
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF737@dbde02.ent.ti.com>
In-Reply-To: <4E00EFD1.40307@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks Mauro. I will make sure I send you a pull request from a git tree.

-Manju

On Wed, Jun 22, 2011 at 00:54:01, Mauro Carvalho Chehab wrote:
> Em 17-06-2011 04:03, Hadli, Manjunath escreveu:
> > Mauro,
> > 
> > Can you consider this patch series for a pull?
> 
> Next time, could you please add on your tree and send me a git pull request?
> 
> Patchwork is currently not reliable. I have a backup process, but a git pull request works better and I won't have the risk of applying the wrong patches or at a wrong order.
> 
> In this specific case, as all patches were caught by patchwork, I'll apply from your emails after reviewing them.
> 
> Thanks,
> Mauro
> 
> > 
> > -Manju
> > 
> > On Fri, Jun 17, 2011 at 12:31:30, Hadli, Manjunath wrote:
> >> fixed a wrong file inclusion in one of the patches
> >>
> >> Manjunath Hadli (6):
> >>   davinci vpbe: V4L2 display driver for DM644X SoC
> >>   davinci vpbe: VPBE display driver
> >>   davinci vpbe: OSD(On Screen Display) block
> >>   davinci vpbe: VENC( Video Encoder) implementation
> >>   davinci vpbe: Build infrastructure for VPBE driver
> >>   davinci vpbe: Readme text for Dm6446 vpbe
> >>
> >>  Documentation/video4linux/README.davinci-vpbe |   93 ++
> >>  drivers/media/video/davinci/Kconfig           |   23 +
> >>  drivers/media/video/davinci/Makefile          |    2 +
> >>  drivers/media/video/davinci/vpbe.c            |  864 ++++++++++++
> >>  drivers/media/video/davinci/vpbe_display.c    | 1860 +++++++++++++++++++++++++
> >>  drivers/media/video/davinci/vpbe_osd.c        | 1231 ++++++++++++++++
> >>  drivers/media/video/davinci/vpbe_osd_regs.h   |  364 +++++
> >>  drivers/media/video/davinci/vpbe_venc.c       |  566 ++++++++
> >>  drivers/media/video/davinci/vpbe_venc_regs.h  |  177 +++
> >>  include/media/davinci/vpbe.h                  |  184 +++
> >>  include/media/davinci/vpbe_display.h          |  147 ++
> >>  include/media/davinci/vpbe_osd.h              |  394 ++++++
> >>  include/media/davinci/vpbe_types.h            |   91 ++
> >>  include/media/davinci/vpbe_venc.h             |   45 +
> >>  14 files changed, 6041 insertions(+), 0 deletions(-)  create mode 
> >> 100644 Documentation/video4linux/README.davinci-vpbe
> >>  create mode 100644 drivers/media/video/davinci/vpbe.c
> >>  create mode 100644 drivers/media/video/davinci/vpbe_display.c
> >>  create mode 100644 drivers/media/video/davinci/vpbe_osd.c
> >>  create mode 100644 drivers/media/video/davinci/vpbe_osd_regs.h
> >>  create mode 100644 drivers/media/video/davinci/vpbe_venc.c
> >>  create mode 100644 drivers/media/video/davinci/vpbe_venc_regs.h
> >>  create mode 100644 include/media/davinci/vpbe.h  create mode 100644 
> >> include/media/davinci/vpbe_display.h
> >>  create mode 100644 include/media/davinci/vpbe_osd.h  create mode 
> >> 100644 include/media/davinci/vpbe_types.h
> >>  create mode 100644 include/media/davinci/vpbe_venc.h
> >>
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" 
> > in the body of a message to majordomo@vger.kernel.org More majordomo 
> > info at  http://vger.kernel.org/majordomo-info.html
> 
> 

