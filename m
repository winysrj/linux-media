Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:57791
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751709AbaELPmr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 11:42:47 -0400
Date: Mon, 12 May 2014 22:09:34 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Alexander Shiyan <shc_work@mail.ru>
CC: <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] media: mx1_camera: Remove driver
Message-ID: <20140512140933.GC8330@dragon>
References: <1399788551-8218-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1399788551-8218-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 11, 2014 at 10:09:11AM +0400, Alexander Shiyan wrote:
> That driver hasn't been really maintained for a long time. It doesn't
> compile in any way, it includes non-existent headers, has no users,
> and marked as "broken" more than year. Due to these factors, mx1_camera
> is now removed from the tree.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  arch/arm/mach-imx/Makefile                      |   3 -
>  arch/arm/mach-imx/devices/Kconfig               |   3 -
>  arch/arm/mach-imx/devices/Makefile              |   1 -
>  arch/arm/mach-imx/devices/devices-common.h      |  10 -
>  arch/arm/mach-imx/devices/platform-mx1-camera.c |  42 --
>  arch/arm/mach-imx/mx1-camera-fiq-ksym.c         |  18 -
>  arch/arm/mach-imx/mx1-camera-fiq.S              |  35 -
>  drivers/media/platform/soc_camera/Kconfig       |  13 -
>  drivers/media/platform/soc_camera/Makefile      |   1 -
>  drivers/media/platform/soc_camera/mx1_camera.c  | 866 ------------------------
>  include/linux/platform_data/camera-mx1.h        |  35 -
>  11 files changed, 1027 deletions(-)
>  delete mode 100644 arch/arm/mach-imx/devices/platform-mx1-camera.c
>  delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq-ksym.c
>  delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq.S
>  delete mode 100644 drivers/media/platform/soc_camera/mx1_camera.c
>  delete mode 100644 include/linux/platform_data/camera-mx1.h

Can this patch be split into arch and driver part?  Recently, arm-soc
folks do not want to have arch changes go via driver tree, unless that's
absolutely necessary.

Shawn
