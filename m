Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:37586 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbeKZXm7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 18:42:59 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 1/3] media: stkwebcam: Support for ASUS A6VM notebook
 added.
To: Andreas Pape <ap@ca-pape.de>, linux-media@vger.kernel.org
References: <20181123161454.3215-1-ap@ca-pape.de>
 <20181123161454.3215-2-ap@ca-pape.de>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <ca22a6ae-f17a-8158-99af-376657adf730@ideasonboard.com>
Date: Mon, 26 Nov 2018 12:48:53 +0000
MIME-Version: 1.0
In-Reply-To: <20181123161454.3215-2-ap@ca-pape.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

Thank you for the patch,

On 23/11/2018 16:14, Andreas Pape wrote:
> The ASUS A6VM notebook has a built in stk11xx webcam which is mounted
> in a way that the video is vertically and horizontally flipped.
> Therefore this notebook is added to the special handling in the driver
> to automatically flip the video into the correct orientation.
> 
> Signed-off-by: Andreas Pape <ap@ca-pape.de>
> ---
>  drivers/media/usb/stkwebcam/stk-webcam.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
> index e11d5d5b7c26..e61427e50525 100644
> --- a/drivers/media/usb/stkwebcam/stk-webcam.c
> +++ b/drivers/media/usb/stkwebcam/stk-webcam.c
> @@ -116,6 +116,13 @@ static const struct dmi_system_id stk_upside_down_dmi_table[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "T12Rg-H")
>  		}
>  	},
> +	{
> +		.ident = "ASUS A6VM",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "A6VM")
> +		}

I guess these strings match the strings produced by dmi-decode on your
laptop?

Assuming so:

Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>


> +	},
>  	{}
>  };
>  
> 

-- 
Regards
--
Kieran
