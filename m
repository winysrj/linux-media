Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:53304 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaERUgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 May 2014 16:36:16 -0400
Date: Sun, 18 May 2014 22:36:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Alexander Shiyan <shc_work@mail.ru>,
	Shawn Guo <shawn.guo@freescale.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Sascha Hauer <kernel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] media: mx1_camera: Remove driver
In-Reply-To: <5370F95D.4080207@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1405182230170.23804@axis700.grange>
References: <1399788551-8218-1-git-send-email-shc_work@mail.ru>
 <1399904280.435992890@f125.i.mail.ru> <20140512142533.GF8330@dragon>
 <1399909608.365840986@f391.i.mail.ru> <5370F95D.4080207@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 12 May 2014, Hans Verkuil wrote:

> On 05/12/2014 05:46 PM, Alexander Shiyan wrote:
> > Mon, 12 May 2014 22:25:34 +0800 от Shawn Guo <shawn.guo@freescale.com>:
> >> On Mon, May 12, 2014 at 06:18:00PM +0400, Alexander Shiyan wrote:
> >>> Mon, 12 May 2014 22:09:34 +0800 от Shawn Guo <shawn.guo@freescale.com>:
> >>>> On Sun, May 11, 2014 at 10:09:11AM +0400, Alexander Shiyan wrote:
> >>>>> That driver hasn't been really maintained for a long time. It doesn't
> >>>>> compile in any way, it includes non-existent headers, has no users,
> >>>>> and marked as "broken" more than year. Due to these factors, mx1_camera
> >>>>> is now removed from the tree.
> >>>>>
> >>>>> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> >>>>> ---
> >>>>>  arch/arm/mach-imx/Makefile                      |   3 -
> >>>>>  arch/arm/mach-imx/devices/Kconfig               |   3 -
> >>>>>  arch/arm/mach-imx/devices/Makefile              |   1 -
> >>>>>  arch/arm/mach-imx/devices/devices-common.h      |  10 -
> >>>>>  arch/arm/mach-imx/devices/platform-mx1-camera.c |  42 --
> >>>>>  arch/arm/mach-imx/mx1-camera-fiq-ksym.c         |  18 -
> >>>>>  arch/arm/mach-imx/mx1-camera-fiq.S              |  35 -
> >>>>>  drivers/media/platform/soc_camera/Kconfig       |  13 -
> >>>>>  drivers/media/platform/soc_camera/Makefile      |   1 -
> >>>>>  drivers/media/platform/soc_camera/mx1_camera.c  | 866 ------------------------
> >>>>>  include/linux/platform_data/camera-mx1.h        |  35 -
> >>>>>  11 files changed, 1027 deletions(-)
> >>>>>  delete mode 100644 arch/arm/mach-imx/devices/platform-mx1-camera.c
> >>>>>  delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq-ksym.c
> >>>>>  delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq.S
> >>>>>  delete mode 100644 drivers/media/platform/soc_camera/mx1_camera.c
> >>>>>  delete mode 100644 include/linux/platform_data/camera-mx1.h
> >>>>
> >>>> Can this patch be split into arch and driver part?  Recently, arm-soc
> >>>> folks do not want to have arch changes go via driver tree, unless that's
> >>>> absolutely necessary.
> >>>
> >>> Can this patch be applied through arm-soc (imx) tree if it will be approved
> >>> by the linux-media maintainers?
> >>
> >> Yes, it can, if linux-media maintainers want.  But I still prefer to two
> >> patches, since I do not see any thing requiring it be one.  Doing that
> >> will ensure we do not run into any merge conflicts.
> > 
> > ARM part and linux-media part are interconnected by using single header
> > <linux/platform_data/camera-mx1.h>. So removing a driver in a separated
> > patch will touch ARM part in any case.
> 
> But the linux-media driver depends on BROKEN, so that isn't build in any
> case, right?

Either way works for me. You can have my

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

if it is pulled via the ARM tree or you can split it into two patches and 
I can take the V4L part via my tree. In that case maybe it would be better 
to either guarantee, that the arch part is applied first or you leave the 
header for the next version or you remove it together with the arch part, 
not the driver part.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
