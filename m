Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0054.outbound.protection.outlook.com ([104.47.32.54]:37279
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751004AbeEAVVj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 May 2018 17:21:39 -0400
Date: Tue, 1 May 2018 14:21:28 -0700
From: Hyun Kwon <hyun.kwon@xilinx.com>
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        Satish Kumar Nagireddy <SATISHNA@xilinx.com>
Subject: Re: [PATCH v4 02/10] xilinx: v4l: dma: Use the
 dmaengine_terminate_all() wrapper
Message-ID: <20180501212127.GA9872@smtp.xilinx.com>
References: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
 <2e5f2c04ea48a617f86206c1b7f0f799649fa6dc.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <2e5f2c04ea48a617f86206c1b7f0f799649fa6dc.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Satish,

Thanks for the patch.

On Mon, 2018-04-30 at 18:35:05 -0700, Satish Kumar Nagireddy wrote:
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Calling dmaengine_device_control() to terminate transfers is an internal
> API that will disappear, use the stable API wrapper instead.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
> ---
>  drivers/media/platform/xilinx/xilinx-dma.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index cb20ada..a5bf345 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -434,6 +434,7 @@ static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	return 0;
>  
>  error_stop:
> +	dmaengine_terminate_all(dma->dma);

The patch and change are incorrectly mapped. The change adds dma termination
on error, which doesn't match with patch description.

And this API is deprecated. Please use dmaengine_terminate_sync() instead.
Probably it makes sense to change another call of dmaengine_terminate_all()
in this file. You can also do it in a separate patch. Up to you.

Thanks,
-hyun

>  	media_pipeline_stop(&dma->video.entity);
>  
>  error:
> -- 
> 2.1.1
> 
