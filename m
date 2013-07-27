Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:47347 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014Ab3G0OsW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jul 2013 10:48:22 -0400
Message-ID: <1374936520.3405.5.camel@palomino.walls.org>
Subject: Re: [PATCH] cx23885[v4]: Fix interrupt storm when enabling IR
 receiver.
From: Andy Walls <awalls@md.metrocast.net>
To: Luis Alves <ljalvs@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org, crope@iki.fi
Date: Sat, 27 Jul 2013 10:48:40 -0400
In-Reply-To: <1374671161-3144-1-git-send-email-ljalvs@gmail.com>
References: <1374671161-3144-1-git-send-email-ljalvs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2013-07-24 at 14:06 +0100, Luis Alves wrote:
> Hi,
> Removed wrong description in the header file. Sorry about that...
> 
> New patch for this issue. Changes:
>  - Added flatiron readreg and writereg functions prototypes (new header file).
>  - Modified the av work handler to preserve all other register bits when dealing
>    with the interrupt flag.
> 
> Regards,
> Luis
> 
> 
> Signed-off-by: Luis Alves <ljalvs@gmail.com>

Looks OK to me.
Theoretically you did'nt need to bitwise-OR in the 0x80, e.g.

	cx23885_flatiron_write(dev, 0x1f,
				cx23885_flatiron_read(dev, 0x1f));

should work as well, since the set interrupt status bit will clear that
bit on the write back of the bit.

But this patch is good enough. :)

Acked-by: Andy Walls <awalls@md.metrocast.net>

> ---
>  drivers/media/pci/cx23885/cx23885-av.c    |   13 +++++++++++++
>  drivers/media/pci/cx23885/cx23885-video.c |    4 ++--
>  drivers/media/pci/cx23885/cx23885-video.h |   26 ++++++++++++++++++++++++++
>  3 files changed, 41 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/media/pci/cx23885/cx23885-video.h
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-av.c b/drivers/media/pci/cx23885/cx23885-av.c
> index e958a01..c443b7a 100644
> --- a/drivers/media/pci/cx23885/cx23885-av.c
> +++ b/drivers/media/pci/cx23885/cx23885-av.c
> @@ -23,6 +23,7 @@
>  
>  #include "cx23885.h"
>  #include "cx23885-av.h"
> +#include "cx23885-video.h"
>  
>  void cx23885_av_work_handler(struct work_struct *work)
>  {
> @@ -32,5 +33,17 @@ void cx23885_av_work_handler(struct work_struct *work)
>  
>  	v4l2_subdev_call(dev->sd_cx25840, core, interrupt_service_routine,
>  			 PCI_MSK_AV_CORE, &handled);
> +
> +	/* Getting here with the interrupt not handled
> +	   then probbaly flatiron does have pending interrupts.
> +	*/
> +	if (!handled) {
> +		/* clear left and right adc channel interrupt request flag */
> +		cx23885_flatiron_write(dev, 0x1f,
> +			cx23885_flatiron_read(dev, 0x1f) | 0x80);
> +		cx23885_flatiron_write(dev, 0x23,
> +			cx23885_flatiron_read(dev, 0x23) | 0x80);
> +	}
> +
>  	cx23885_irq_enable(dev, PCI_MSK_AV_CORE);
>  }
> diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
> index e33d1a7..f4e7cef 100644
> --- a/drivers/media/pci/cx23885/cx23885-video.c
> +++ b/drivers/media/pci/cx23885/cx23885-video.c
> @@ -417,7 +417,7 @@ static void res_free(struct cx23885_dev *dev, struct cx23885_fh *fh,
>  	mutex_unlock(&dev->lock);
>  }
>  
> -static int cx23885_flatiron_write(struct cx23885_dev *dev, u8 reg, u8 data)
> +int cx23885_flatiron_write(struct cx23885_dev *dev, u8 reg, u8 data)
>  {
>  	/* 8 bit registers, 8 bit values */
>  	u8 buf[] = { reg, data };
> @@ -428,7 +428,7 @@ static int cx23885_flatiron_write(struct cx23885_dev *dev, u8 reg, u8 data)
>  	return i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
>  }
>  
> -static u8 cx23885_flatiron_read(struct cx23885_dev *dev, u8 reg)
> +u8 cx23885_flatiron_read(struct cx23885_dev *dev, u8 reg)
>  {
>  	/* 8 bit registers, 8 bit values */
>  	int ret;
> diff --git a/drivers/media/pci/cx23885/cx23885-video.h b/drivers/media/pci/cx23885/cx23885-video.h
> new file mode 100644
> index 0000000..c961a2b
> --- /dev/null
> +++ b/drivers/media/pci/cx23885/cx23885-video.h
> @@ -0,0 +1,26 @@
> +/*
> + *  Driver for the Conexant CX23885/7/8 PCIe bridge
> + *
> + *  Copyright (C) 2010  Andy Walls <awalls@md.metrocast.net>
> + *
> + *  This program is free software; you can redistribute it and/or
> + *  modify it under the terms of the GNU General Public License
> + *  as published by the Free Software Foundation; either version 2
> + *  of the License, or (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + *  02110-1301, USA.
> + */
> +
> +#ifndef _CX23885_VIDEO_H_
> +#define _CX23885_VIDEO_H_
> +int cx23885_flatiron_write(struct cx23885_dev *dev, u8 reg, u8 data);
> +u8 cx23885_flatiron_read(struct cx23885_dev *dev, u8 reg);
> +#endif


