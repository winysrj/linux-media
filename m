Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:64891 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752562AbeADSZN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 13:25:13 -0500
Date: Thu, 4 Jan 2018 19:24:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kieran Bingham <kbingham@kernel.org>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        kieran.bingham@ideasonboard.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Baoyou Xie <baoyou.xie@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Aviv Greenberg <avivgr@gmail.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Patrick Johnson <teknotus@teknot.us>,
        Jim Lin <jilin@nvidia.com>
Subject: Re: [RFC/RFT PATCH 1/6] uvcvideo: Refactor URB descriptors
In-Reply-To: <cac2db68616f9855ceb5a57786f1ee8631b9df79.1515010476.git-series.kieran.bingham@ideasonboard.com>
Message-ID: <alpine.DEB.2.20.1801041607070.13441@axis700.grange>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com> <cac2db68616f9855ceb5a57786f1ee8631b9df79.1515010476.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Just minor suggestions below:

On Wed, 3 Jan 2018, Kieran Bingham wrote:

> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> We currently store three separate arrays for each URB reference we hold.
> 
> Objectify the data needed to track URBs into a single uvc_urb structure,
> allowing better object management and tracking of the URB.
> 
> All accesses to the data pointers through stream, are converted to use a
> uvc_urb pointer for consistency.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 46 ++++++++++++++++++++------------
>  drivers/media/usb/uvc/uvcvideo.h  | 18 ++++++++++---
>  2 files changed, 44 insertions(+), 20 deletions(-)

[snip]

> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index 19e725e2bda5..4afa8ce13ea7 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -479,6 +479,20 @@ struct uvc_stats_stream {
>  	unsigned int max_sof;		/* Maximum STC.SOF value */
>  };
>  
> +/**
> + * struct uvc_urb - URB context management structure
> + *
> + * @urb: described URB. Must be allocated with usb_alloc_urb()

Didn't you mean "describes?"

> + * @urb_buffer: memory storage for the URB
> + * @urb_dma: DMA coherent addressing for the urb_buffer

The whole struct describes URBs, so, I wouldn't repeat that in these two 
field names, I'd just call them "buffer" and "dma." OTOH, later you add 
more fields like "stream," which aren't per-URB, so, maybe you want to 
keep these prefixes.

Thanks
Guennadi

> + */
> +struct uvc_urb {
> +	struct urb *urb;
> +
> +	char *urb_buffer;
> +	dma_addr_t urb_dma;
> +};
> +
>  struct uvc_streaming {
>  	struct list_head list;
>  	struct uvc_device *dev;
> @@ -521,9 +535,7 @@ struct uvc_streaming {
>  		__u32 max_payload_size;
>  	} bulk;
>  
> -	struct urb *urb[UVC_URBS];
> -	char *urb_buffer[UVC_URBS];
> -	dma_addr_t urb_dma[UVC_URBS];
> +	struct uvc_urb uvc_urb[UVC_URBS];
>  	unsigned int urb_size;
>  
>  	__u32 sequence;
> -- 
> git-series 0.9.1
> 
