Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46402 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732106AbeHGAb2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 20:31:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: uvcvideo: Make some structs const
Date: Tue, 07 Aug 2018 01:21:01 +0300
Message-ID: <5812728.94RVy69Rc3@avalon>
In-Reply-To: <0e85822616b665b20bc5b883d5be4a1265137f87.1509816184.git.joe@perches.com>
References: <0e85822616b665b20bc5b883d5be4a1265137f87.1509816184.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joe,

Thank you for the patch.

On Saturday, 4 November 2017 19:23:29 EEST Joe Perches wrote:
> Move some data to text
> 
> $ size drivers/media/usb/uvc/uvc_ctrl.o*
>    text	   data	    bss	    dec	    hex	filename
>   34323	   2364	      0	  36687	   8f4f	drivers/media/usb/uvc/
uvc_ctrl.o.new
> 28659	   8028	      0	  36687	   8f4f	drivers/media/usb/uvc/
uvc_ctrl.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and taken in my tree.

> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index 20397aba6849..44a0554bf62d 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -37,7 +37,7 @@
>   * Controls
>   */
> 
> -static struct uvc_control_info uvc_ctrls[] = {
> +static const struct uvc_control_info uvc_ctrls[] = {
>  	{
>  		.entity		= UVC_GUID_UVC_PROCESSING,
>  		.selector	= UVC_PU_BRIGHTNESS_CONTROL,
> @@ -420,7 +420,7 @@ static void uvc_ctrl_set_rel_speed(struct
> uvc_control_mapping *mapping, data[first+1] = min_t(int, abs(value), 0xff);
>  }
> 
> -static struct uvc_control_mapping uvc_ctrl_mappings[] = {
> +static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
>  	{
>  		.id		= V4L2_CID_BRIGHTNESS,
>  		.name		= "Brightness",


-- 
Regards,

Laurent Pinchart
