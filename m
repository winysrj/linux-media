Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36136 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbeKZX1I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 18:27:08 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 3/3] media: stkwebcam: Bugfix for wrong return values
To: Andreas Pape <ap@ca-pape.de>, linux-media@vger.kernel.org
References: <20181123161454.3215-1-ap@ca-pape.de>
 <20181123161454.3215-4-ap@ca-pape.de>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <d68bde4f-1148-ad5e-37d7-f8c1d102b687@ideasonboard.com>
Date: Mon, 26 Nov 2018 12:33:04 +0000
MIME-Version: 1.0
In-Reply-To: <20181123161454.3215-4-ap@ca-pape.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

Thank you for the patch,

On 23/11/2018 16:14, Andreas Pape wrote:
> usb_control_msg returns in case of a successfully sent message the number
> of sent bytes as a positive number. Don't use this value as a return value
> for stk_camera_read_reg, as a non-zero return value is used as an error
> condition in some cases when stk_camera_read_reg is called.

Yes, and I see the stk_camera_write_reg() also follows this pattern.


> Signed-off-by: Andreas Pape <ap@ca-pape.de>
> ---
>  drivers/media/usb/stkwebcam/stk-webcam.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
> index c64928e36a5a..66a3665fc826 100644
> --- a/drivers/media/usb/stkwebcam/stk-webcam.c
> +++ b/drivers/media/usb/stkwebcam/stk-webcam.c
> @@ -171,7 +171,11 @@ int stk_camera_read_reg(struct stk_camera *dev, u16 index, u8 *value)
>  		*value = *buf;
>  
>  	kfree(buf);
> -	return ret;
> +
> +	if (ret < 0)
> +		return ret;
> +	else
> +		return 0;

I would have said the return 0; could be on it's own, and the else
statement would then not be needed, but I see this follows the style
used by stk_camera_write_reg() - so it looks good to me.

Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>


>  }
>  
>  static int stk_start_stream(struct stk_camera *dev)
> 

-- 
Regards
--
Kieran
