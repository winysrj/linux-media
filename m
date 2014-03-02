Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45500 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaCBSFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Mar 2014 13:05:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@iki.fi
Subject: Re: [PATCH v2] omap3isp: Fix kerneldoc for _module_sync_is_stopping and isp_isr()
Date: Sun, 02 Mar 2014 19:06:26 +0100
Message-ID: <1709992.clf7muDlF1@avalon>
In-Reply-To: <1393608967-9171-1-git-send-email-pmeerw@pmeerw.net>
References: <1603681.R3i3XynjN4@avalon> <1393608967-9171-1-git-send-email-pmeerw@pmeerw.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

Thank you for the patch.

On Friday 28 February 2014 18:36:07 Peter Meerwald wrote:
> use the correct name in the comment describing function
> omap3isp_module_sync_is_stopping()
> 
> isp_isr() never returned IRQ_NONE, remove the comment saying so
> 
> Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/platform/omap3isp/isp.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 5807185..d60a4b7 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -588,9 +588,6 @@ static void isp_isr_sbl(struct isp_device *isp)
>   * @_isp: Pointer to the OMAP3 ISP device
>   *
>   * Handles the corresponding callback if plugged in.
> - *
> - * Returns IRQ_HANDLED when IRQ was correctly handled, or IRQ_NONE when the
> - * IRQ wasn't handled.
>   */
>  static irqreturn_t isp_isr(int irq, void *_isp)
>  {
> @@ -1420,7 +1417,7 @@ int omap3isp_module_sync_idle(struct media_entity *me,
> wait_queue_head_t *wait, }
> 
>  /*
> - * omap3isp_module_sync_is_stopped - Helper to verify if module was
> stopping + * omap3isp_module_sync_is_stopping - Helper to verify if module
> was stopping * @wait: ISP submodule's wait queue for streamoff/interrupt
> synchronization * @stopping: flag which tells module wants to stop
>   *

-- 
Regards,

Laurent Pinchart

