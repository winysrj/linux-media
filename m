Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:37564 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbeKZXmP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 18:42:15 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 2/3] media: stkwebcam: Bugfix for not correctly
 initialized camera
To: Andreas Pape <ap@ca-pape.de>, linux-media@vger.kernel.org
References: <20181123161454.3215-1-ap@ca-pape.de>
 <20181123161454.3215-3-ap@ca-pape.de>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <b527358c-8fb9-fbe5-be19-43e8992e85c7@ideasonboard.com>
Date: Mon, 26 Nov 2018 12:48:08 +0000
MIME-Version: 1.0
In-Reply-To: <20181123161454.3215-3-ap@ca-pape.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

Thank you for the patch,

On 23/11/2018 16:14, Andreas Pape wrote:
> stk_start_stream can only be called successfully if stk_initialise and
> stk_setup_format are called before. When using e.g. cheese it was observed
> that stk_initialise and stk_setup_format have not been called before which
> leads to no picture in that software whereas other tools like guvcview
> worked flawlessly. This patch solves the issue when using e.g. cheese.
> 

This one worries me a little... (but hopefully not too much)


> Signed-off-by: Andreas Pape <ap@ca-pape.de>
> ---
>  drivers/media/usb/stkwebcam/stk-webcam.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
> index e61427e50525..c64928e36a5a 100644
> --- a/drivers/media/usb/stkwebcam/stk-webcam.c
> +++ b/drivers/media/usb/stkwebcam/stk-webcam.c
> @@ -1155,6 +1155,8 @@ static int stk_vidioc_streamon(struct file *filp,
>  	if (dev->sio_bufs == NULL)
>  		return -EINVAL;
>  	dev->sequence = 0;
> +	stk_initialise(dev);
> +	stk_setup_format(dev);

Glancing through the code base - this seems to imply to me that s_fmt
was not set/called (presumably by cheese) as stk_setup_format() is
called only by stk_vidioc_s_fmt_vid_cap() and stk_camera_resume().

Is this an issue?

I presume that this means the camera will just operate in a default
configuration until cheese chooses something more specific.

Actually - looking further this seems to be the case, as the mode is
simply stored in dev->vsettings.mode, and so this last setup stage will
just ensure the configuration of the hardware matches the driver.

So it seems reasonable to me - but should it be set any earlier?
Perhaps not.


Are there any complaints when running v4l2-compliance on this device node?



>  	return stk_start_stream(dev);
>  }
>  
> 

-- 
Regards
--
Kieran
