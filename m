Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36721 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbbABLfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 06:35:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] UVC: Remove extra commit on resume()
Date: Fri, 02 Jan 2015 13:35:08 +0200
Message-ID: <59177052.2xsYjgkMSa@avalon>
In-Reply-To: <Pine.LNX.4.64.1409020813180.24932@axis700.grange>
References: <Pine.LNX.4.64.1409020813180.24932@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch, and sorry for the late reply.

On Tuesday 02 September 2014 08:16:28 Guennadi Liakhovetski wrote:
> From: Aviv Greenberg <aviv.d.greenberg@intel.com>
> 
> The UVC spec is a bit vague wrt devices using bulk endpoints,
> specifically, how to signal to a device to start streaming.
> 
> For devices using isoc endpoints, the sequence for start streaming is:
> 1) The host sends PROBE_CONTROL(SET_CUR) PROBE_CONTROL(GET_CUR)
> 2) Host selects desired config and calls COMMIT_CONTROL(SET_CUR)
> 3) Host selects an alt interface other then zero - e.g
> SELECT_ALTERNATE_INTERFACE(1) 4) The device starts streaming
> 
> However for devices using bulk endpoints, there must be *no* alt interface
> other than setting zero. From the UVC spec:
> "A VideoStreaming interface containing a bulk endpoint for streaming shall
> support only alternate setting zero. Additional alternate settings
> containing bulk endpoints are not permitted in a device that is compliant
> with the Video Class specification."
> 
> So for devices using bulk endpoints, step #3 above is irrelevant, and thus
> cannot be used as an indication for the device to start streaming.
> So in practice, such devices start streaming immediately after a
> COMMIT_CONTROL(SET_CUR).
> 
> In the uvc resume() handler, an unsolicited commit is sent, which causes
> devices using bulk endpoints to start streaming unintentionally.
> 
> This patch modifies resume() handler to send a commit only if streaming
> needs to be reestablished, i.e if the device was actually streaming before
> is was suspended.

Speaking of bulk devices, based on your experience, how do devices detect a 
stream stop condition in practice ?

> Signed-off-by: Aviv Greenberg <aviv.d.greenberg@intel.com>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've taken the patch in my tree and will send a pull request for v3.20.

> ---
>  drivers/media/usb/uvc/uvc_video.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 3394c34..c111de2 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1709,15 +1709,15 @@ int uvc_video_resume(struct uvc_streaming *stream,
> int reset)
> 
>  	uvc_video_clock_reset(stream);
> 
> +	if (!uvc_queue_streaming(&stream->queue))
> +		return 0;
> +
>  	ret = uvc_commit_video(stream, &stream->ctrl);
>  	if (ret < 0) {
>  		uvc_queue_enable(&stream->queue, 0);
>  		return ret;
>  	}
> 
> -	if (!uvc_queue_streaming(&stream->queue))
> -		return 0;
> -
>  	ret = uvc_init_video(stream, GFP_NOIO);
>  	if (ret < 0)
>  		uvc_queue_enable(&stream->queue, 0);

-- 
Regards,

Laurent Pinchart

