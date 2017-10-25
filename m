Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:47811 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751328AbdJYGu6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Oct 2017 02:50:58 -0400
Message-ID: <1508914250.6059.0.camel@v3.sk>
Subject: Re: [PATCH] media: usbtv: fix brightness and contrast controls
From: Lubomir Rintel <lkundrak@v3.sk>
To: Adam Sampson <ats@offog.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Date: Wed, 25 Oct 2017 08:50:50 +0200
In-Reply-To: <20171024201446.30021-1-ats@offog.org>
References: <20171024201446.30021-1-ats@offog.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-10-24 at 21:14 +0100, Adam Sampson wrote:
> Because the brightness and contrast controls share a register,
> usbtv_s_ctrl needs to read the existing values for both controls
> before
> inserting the new value. However, the code accidentally wrote to the
> registers (from an uninitialised stack array), rather than reading
> them.
> 
> The user-visible effect of this was that adjusting the brightness
> would
> also set the contrast to a random value, and vice versa -- so it
> wasn't
> possible to correctly adjust the brightness of usbtv's video output.
> 
> Tested with an "EasyDAY" UTV007 device.
> 
> Fixes: c53a846c48f2 ("usbtv: add video controls")
> Signed-off-by: Adam Sampson <ats@offog.org>

Thank you!

Reviewed-By: Lubomir Rintel <lkundrak@v3.sk>

> ---
>  drivers/media/usb/usbtv/usbtv-video.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/usbtv/usbtv-video.c
> b/drivers/media/usb/usbtv/usbtv-video.c
> index 95b5f43..3668a04 100644
> --- a/drivers/media/usb/usbtv/usbtv-video.c
> +++ b/drivers/media/usb/usbtv/usbtv-video.c
> @@ -718,8 +718,8 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
>  	 */
>  	if (ctrl->id == V4L2_CID_BRIGHTNESS || ctrl->id ==
> V4L2_CID_CONTRAST) {
>  		ret = usb_control_msg(usbtv->udev,
> -			usb_sndctrlpipe(usbtv->udev, 0),
> USBTV_CONTROL_REG,
> -			USB_DIR_OUT | USB_TYPE_VENDOR |
> USB_RECIP_DEVICE,
> +			usb_rcvctrlpipe(usbtv->udev, 0),
> USBTV_CONTROL_REG,
> +			USB_DIR_IN | USB_TYPE_VENDOR |
> USB_RECIP_DEVICE,
>  			0, USBTV_BASE + 0x0244, (void *)data, 3, 0);
>  		if (ret < 0)
>  			goto error;
