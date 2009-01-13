Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:63398 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbZAMKmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 05:42:55 -0500
Date: Tue, 13 Jan 2009 12:42:51 +0200
From: Tony Lindgren <tony@atomide.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Subject: Re: [REVIEW PATCH 05/14] OMAP: CAM: Add ISP Front end
Message-ID: <20090113104251.GC7344@atomide.com>
References: <A24693684029E5489D1D202277BE894416429F9B@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A24693684029E5489D1D202277BE894416429F9B@dlee02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Aguirre Rodriguez, Sergio Alberto <saaguirre@ti.com> [090113 04:04]:
> This adds the OMAP ISP Front end modules to the kernel. Includes:
> * ISP CCDC Driver
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/isp/ispccdc.c | 1488 +++++++++++++++++++++++++++++++++++++
>  drivers/media/video/isp/ispccdc.h |  200 +++++
>  2 files changed, 1688 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/isp/ispccdc.c
>  create mode 100644 drivers/media/video/isp/ispccdc.h
> 
> diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
> new file mode 100644
> index 0000000..f200baf
> --- /dev/null
> +++ b/drivers/media/video/isp/ispccdc.c
> @@ -0,0 +1,1488 @@
> +/*
> + * drivers/media/video/isp/ispccdc.c
> + *
> + * Driver Library for CCDC module in TI's OMAP3 Camera ISP
> + *
> + * Copyright (C) 2008 Texas Instruments, Inc.
> + *
> + * Contributors:
> + *     Senthilvadivu Guruswamy <svadivu@ti.com>
> + *     Pallavi Kulkarni <p-kulkarni@ti.com>
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
> + * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
> + * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
> + */
> +
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/sched.h>
> +#include <linux/delay.h>
> +#include <linux/types.h>
> +#include <asm/mach-types.h>

You should not need mach-types.h in drivers. Please check if it can be
left out. If it cannot be left out, you probably have something that
should be passed from board-*.c files in platform_data.

Regards,

Tony
