Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:36655 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751840AbdKAJRE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 05:17:04 -0400
Message-ID: <1509527817.8832.1.camel@pengutronix.de>
Subject: Re: [PATCH 1/7] media: atomisp: fix ident for assert/return
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        devel@driverdev.osuosl.org
Date: Wed, 01 Nov 2017 10:16:57 +0100
In-Reply-To: <7b2c3c762cad663021b3b3e7aac47b2a8c8d03a9.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
         <7b2c3c762cad663021b3b3e7aac47b2a8c8d03a9.1509465351.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, 2017-10-31 at 12:04 -0400, Mauro Carvalho Chehab wrote:
> On lots of places, assert/return are starting at the first
> column, causing indentation issues, as complained by spatch:
> 
> drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/irq_private.h:32 irq_reg_store() warn: inconsistent indenting
> 
> Used this small script to fix such occurrences:
> 
> for i in $(git grep -l -E "^(assert|return)" drivers/staging/media/); do perl -ne 's/^(assert|return)/\t$1/; print $_' <$i >a && mv a $i; done

This also catches labels that start with "return". Adding some
whitespace to the regular expression may avoid these false positives.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  .../pci/atomisp2/css2400/camera/util/src/util.c    |  2 +-
>  .../hive_isp_css_common/host/event_fifo_private.h  |  2 +-
>  .../host/fifo_monitor_private.h                    | 28 +++++-----
>  .../css2400/hive_isp_css_common/host/gdc.c         |  8 +--
>  .../css2400/hive_isp_css_common/host/gp_device.c   |  2 +-
>  .../hive_isp_css_common/host/gp_device_private.h   | 16 +++---
>  .../hive_isp_css_common/host/gpio_private.h        |  4 +-
>  .../hive_isp_css_common/host/hmem_private.h        |  4 +-
>  .../host/input_formatter_private.h                 | 16 +++---
>  .../hive_isp_css_common/host/input_system.c        | 28 +++++-----
>  .../host/input_system_private.h                    | 64 +++++++++++-----------
>  .../css2400/hive_isp_css_common/host/irq.c         | 30 +++++-----
>  .../css2400/hive_isp_css_common/host/irq_private.h | 12 ++--
>  .../css2400/hive_isp_css_common/host/isp.c         |  4 +-
>  .../css2400/hive_isp_css_common/host/mmu.c         |  6 +-
>  .../css2400/hive_isp_css_common/host/mmu_private.h | 12 ++--
>  .../css2400/hive_isp_css_common/host/sp_private.h  | 60 ++++++++++----------
>  .../atomisp/pci/atomisp2/css2400/sh_css_hrt.c      |  2 +-
>  drivers/staging/media/imx/imx-media-capture.c      |  2 +-
[...]
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index ea145bafb880..149f0e1753a1 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -463,7 +463,7 @@ static int capture_start_streaming(struct vb2_queue *vq, unsigned int count)
>  
>  	return 0;
>  
> -return_bufs:
> +	return_bufs:
>  	spin_lock_irqsave(&priv->q_lock, flags);
>  	list_for_each_entry_safe(buf, tmp, &priv->ready_q, list) {
>  		list_del(&buf->list);

This label should stay at the first column.

regards
Philipp
