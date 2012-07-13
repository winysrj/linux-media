Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34845 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2GMPHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 11:07:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: tony_nie@realsil.com.cn
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: calculate  maximum packet size of endpoint
Date: Fri, 13 Jul 2012 17:07:49 +0200
Message-ID: <1581435.miT8jWPryc@avalon>
In-Reply-To: <4FFFDF29.1030706@realsil.com.cn>
References: <1339040645-15554-1-git-send-email-tony_nie@realsil.com.cn> <4FFFDF29.1030706@realsil.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On Friday 13 July 2012 16:41:13 Tony. Nie wrote:
> Hi ALL,
> 
> I just found that Realtek's USB3.0 camera RTS5825 cannot work on usb3.0
> mode, and find a issue in UVC driver.
> 
> USB group had changed the means of wMaxPacketSize of endpoint descriptor
> from USB2.0 to USB3.0, Please refer to the section 9.6.6 of USB
> specification(U2 and U3).
> 
> I think the method of calculating maximum packet size of usb3.0 isoc
> endpoint should differ from usb2.0.
> While in the lasted UVC driver, the algorism was according to usb2.0
> spec in function uvc_init_video_isoc and
> uvc_init_video. Is it wrong?

This can indeed be a problem. Could you please send me the lsusb -v output for 
that device ?

> -------- Original Message --------
> Subject: 	[PATCH] uvcvideo:Support for Realtek USB3.0 WebCam
> Date: 	Thu, 7 Jun 2012 11:44:05 +0800
> From: 	聂江涛 <tony_nie@realsil.com.cn>
> To: 	linux-media@vger.kernel.org <linux-media@vger.kernel.org>
> CC: 	聂江涛 <tony_nie@realsil.com.cn>
> 
> From: Tony.Nie <tony_nie@realsil.com.cn>
> 
> The method of calculating max bandwidth of usb2.0 isoc endpoint differed
> from usb3.0. The uvc_init_videio() and uvc_init_video_isoc() must be
> re-implemented to get correct packet size.
> 
> Signed-off-by: Tony.Nie <tony_nie@realsil.com.cn>
> ---
>  drivers/media/video/uvc/uvc_video.c |   47
> +++++++++++++++++++++++++++++------ 1 files changed, 39 insertions(+), 8
> deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_video.c
> b/drivers/media/video/uvc/uvc_video.c index b76b0ac..5915377 100644
> --- a/drivers/media/video/uvc/uvc_video.c
> +++ b/drivers/media/video/uvc/uvc_video.c
> @@ -1441,13 +1441,23 @@ static void uvc_uninit_video(struct uvc_streaming
> *stream, int free_buffers) static int uvc_init_video_isoc(struct
> uvc_streaming *stream,
>  	struct usb_host_endpoint *ep, gfp_t gfp_flags)
>  {
> +	struct usb_interface *intf = stream->intf;
> +	struct usb_device *udev = interface_to_usbdev(intf);
>  	struct urb *urb;
>  	unsigned int npackets, i, j;
>  	u16 psize;
>  	u32 size;
> 
> -	psize = le16_to_cpu(ep->desc.wMaxPacketSize);
> -	psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
> +	if (udev->speed == USB_SPEED_SUPER) {
> +		int mult = (ep->ss_ep_comp.bmAttributes & 0X3) + 1;
> +		int burst = ep->ss_ep_comp.bMaxBurst + 1;
> +		psize = le16_to_cpu(ep->desc.wMaxPacketSize);
> +		psize = psize * mult * burst;
> +	} else {
> +		psize = le16_to_cpu(ep->desc.wMaxPacketSize);
> +		psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
> +	}
> +
>  	size = stream->ctrl.dwMaxVideoFrameSize;
> 
>  	npackets = uvc_alloc_urb_buffers(stream, size, psize, gfp_flags);
> @@ -1549,6 +1559,7 @@ static int uvc_init_video_bulk(struct uvc_streaming
> *stream, static int uvc_init_video(struct uvc_streaming *stream, gfp_t
> gfp_flags) {
>  	struct usb_interface *intf = stream->intf;
> +	struct usb_device *udev = interface_to_usbdev(intf);
>  	struct usb_host_endpoint *ep;
>  	unsigned int i;
>  	int ret;
> @@ -1580,6 +1591,8 @@ static int uvc_init_video(struct uvc_streaming
> *stream, gfp_t gfp_flags) "B/frame bandwidth.\n", bandwidth);
>  		}
> 
> +		if (udev->speed == USB_SPEED_SUPER)
> +			best_psize = 1024 * 16 * 3;
>  		for (i = 0; i < intf->num_altsetting; ++i) {
>  			struct usb_host_interface *alts;
>  			unsigned int psize;
> @@ -1591,12 +1604,30 @@ static int uvc_init_video(struct uvc_streaming
> *stream, gfp_t gfp_flags) continue;
> 
>  			/* Check if the bandwidth is high enough. */
> -			psize = le16_to_cpu(ep->desc.wMaxPacketSize);
> -			psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
> -			if (psize >= bandwidth && psize <= best_psize) {
> -				altsetting = i;
> -				best_psize = psize;
> -				best_ep = ep;
> +			if (udev->speed == USB_SPEED_HIGH) {

What about full speed devices ?

> +				psize = le16_to_cpu(ep->desc.wMaxPacketSize);
> +				psize = (psize & 0x07ff) *
> +					(1 + ((psize >> 11) & 3));
> +				if (psize >= bandwidth && psize <= best_psize) {
> +					altsetting = i;
> +					best_psize = psize;
> +					best_ep = ep;
> +				}

This test is copied in the next branch of the outer if and can be moved after 
it.

> +			} else if (udev->speed == USB_SPEED_SUPER) {
> +				int mult = 1 +
> +					(ep->ss_ep_comp.bmAttributes & 0x3);



> +				int burst = ep->ss_ep_comp.bMaxBurst + 1;
> +				psize = le16_to_cpu(ep->desc.wMaxPacketSize);
> +				psize = psize * mult * burst;

Shouldn't you use ep->ss_ep_comp.wBytesPerInterval instead ?

> +				uvc_trace(UVC_TRACE_VIDEO,
> +						"mult:%d burst:%d psize:%d\n",
> +						mult, burst, psize);
> +				if (psize >= bandwidth && psize <= best_psize) {
> +					altsetting = i;
> +					best_psize = psize;
> +					best_ep = ep;
> +				}
> +
>  			}
>  		}

-- 
Regards,

Laurent Pinchart

