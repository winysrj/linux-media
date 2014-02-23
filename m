Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52253 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaBWWKC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 17:10:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@iki.fi
Subject: Re: [PATCH] omap3isp: Fix kerneldoc for _module_sync_is_stopping and isp_isr()
Date: Sun, 23 Feb 2014 23:11:17 +0100
Message-ID: <1603681.R3i3XynjN4@avalon>
In-Reply-To: <1393175335-15984-1-git-send-email-pmeerw@pmeerw.net>
References: <1393175335-15984-1-git-send-email-pmeerw@pmeerw.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

Thank you for the patch.

On Sunday 23 February 2014 18:08:55 Peter Meerwald wrote:
> Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
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

While I don't object to this change, doesn't it deserve a brief explanation in 
the commit message ?

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

