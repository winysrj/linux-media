Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2on0066.outbound.protection.outlook.com ([65.55.169.66]:16157
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758598AbaELO0G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 10:26:06 -0400
Date: Mon, 12 May 2014 22:25:34 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Alexander Shiyan <shc_work@mail.ru>
CC: Sascha Hauer <kernel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: mx1_camera: Remove driver
Message-ID: <20140512142533.GF8330@dragon>
References: <1399788551-8218-1-git-send-email-shc_work@mail.ru>
 <20140512140933.GC8330@dragon> <1399904280.435992890@f125.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399904280.435992890@f125.i.mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 12, 2014 at 06:18:00PM +0400, Alexander Shiyan wrote:
> Mon, 12 May 2014 22:09:34 +0800 от Shawn Guo <shawn.guo@freescale.com>:
> > On Sun, May 11, 2014 at 10:09:11AM +0400, Alexander Shiyan wrote:
> > > That driver hasn't been really maintained for a long time. It doesn't
> > > compile in any way, it includes non-existent headers, has no users,
> > > and marked as "broken" more than year. Due to these factors, mx1_camera
> > > is now removed from the tree.
> > > 
> > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > > ---
> > >  arch/arm/mach-imx/Makefile                      |   3 -
> > >  arch/arm/mach-imx/devices/Kconfig               |   3 -
> > >  arch/arm/mach-imx/devices/Makefile              |   1 -
> > >  arch/arm/mach-imx/devices/devices-common.h      |  10 -
> > >  arch/arm/mach-imx/devices/platform-mx1-camera.c |  42 --
> > >  arch/arm/mach-imx/mx1-camera-fiq-ksym.c         |  18 -
> > >  arch/arm/mach-imx/mx1-camera-fiq.S              |  35 -
> > >  drivers/media/platform/soc_camera/Kconfig       |  13 -
> > >  drivers/media/platform/soc_camera/Makefile      |   1 -
> > >  drivers/media/platform/soc_camera/mx1_camera.c  | 866 ------------------------
> > >  include/linux/platform_data/camera-mx1.h        |  35 -
> > >  11 files changed, 1027 deletions(-)
> > >  delete mode 100644 arch/arm/mach-imx/devices/platform-mx1-camera.c
> > >  delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq-ksym.c
> > >  delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq.S
> > >  delete mode 100644 drivers/media/platform/soc_camera/mx1_camera.c
> > >  delete mode 100644 include/linux/platform_data/camera-mx1.h
> > 
> > Can this patch be split into arch and driver part?  Recently, arm-soc
> > folks do not want to have arch changes go via driver tree, unless that's
> > absolutely necessary.
> 
> Can this patch be applied through arm-soc (imx) tree if it will be approved
> by the linux-media maintainers?

Yes, it can, if linux-media maintainers want.  But I still prefer to two
patches, since I do not see any thing requiring it be one.  Doing that
will ensure we do not run into any merge conflicts.

Shawn
