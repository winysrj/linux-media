Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57409 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaBALuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Feb 2014 06:50:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nate Weibley <nweibley@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap4iss: Fix overlapping luma/chroma planes & correct end pointers
Date: Sat, 01 Feb 2014 12:51:25 +0100
Message-ID: <1937925.MHQJt8j3r2@avalon>
In-Reply-To: <1390924439-19565-1-git-send-email-nweibley@gmail.com>
References: <1390924439-19565-1-git-send-email-nweibley@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nate,

Thank you for the patch.

On Tuesday 28 January 2014 10:53:59 Nate Weibley wrote:
> The chroma data base address for NV12 formatted data should begin offset
> rows*bytes_per_row from the base address for luminance data. We were OBO
> causing a stripe of green pixels at the bottom of the frame.
> 
> The OMAP TRM indicates RZX_X_PTR_E should contain the maximum number lines
> written to the CBUFF, not the total lines - 1 as used in VSZ registers.

I have a work in progress patch in my internal tree to fix this issue that 
mentions that the resizer eats one line of image for internal state machine 
synchronization purpose (due to a hardware bug).

I can't check this right now as I'm not home, have you seen anything related 
when testing this patch ?

> Signed-off-by: Nate Weibley <nweibley@gmail.com>
> ---
>  drivers/staging/media/omap4iss/iss_resizer.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss_resizer.c
> b/drivers/staging/media/omap4iss/iss_resizer.c index ae831b8..ffb4f0e
> 100644
> --- a/drivers/staging/media/omap4iss/iss_resizer.c
> +++ b/drivers/staging/media/omap4iss/iss_resizer.c
> @@ -159,7 +159,7 @@ static void resizer_set_outaddr(struct
> iss_resizer_device *resizer, u32 addr) if ((informat->code ==
> V4L2_MBUS_FMT_UYVY8_1X16) &&
>  	    (outformat->code == V4L2_MBUS_FMT_YUYV8_1_5X8)) {
>  		u32 c_addr = addr + (resizer->video_out.bpl_value *
> -				     (outformat->height - 1));
> +				     (outformat->height));
> 
>  		/* Ensure Y_BAD_L[6:0] = C_BAD_L[6:0]*/
>  		if ((c_addr ^ addr) & 0x7f) {
> @@ -218,7 +218,7 @@ static void resizer_configure(struct iss_resizer_device
> *resizer) iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_VPS, 0);
>  	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_HPS, 0);
>  	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_VSZ,
> -		      informat->height - 2);
> +		      informat->height - 1);
>  	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SRC_HSZ,
>  		      informat->width - 1);
> 
> @@ -226,7 +226,7 @@ static void resizer_configure(struct iss_resizer_device
> *resizer) iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_I_HPS, 0);
> 
>  	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_O_VSZ,
> -		      outformat->height - 2);
> +		      outformat->height - 1);
>  	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_O_HSZ,
>  		      outformat->width - 1);
> 
> @@ -236,7 +236,7 @@ static void resizer_configure(struct iss_resizer_device
> *resizer) /* Buffer output settings */
>  	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_Y_PTR_S, 0);
>  	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_Y_PTR_E,
> -		      outformat->height - 1);
> +		      outformat->height);
> 
>  	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_Y_OFT,
>  		      resizer->video_out.bpl_value);
> @@ -251,7 +251,7 @@ static void resizer_configure(struct iss_resizer_device
> *resizer) iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_C_PTR_S,
>  			      0);
>  		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_C_PTR_E,
> -			      outformat->height - 1);
> +			      outformat->height);
> 
>  		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_SDR_C_OFT,
>  			      resizer->video_out.bpl_value);

-- 
Regards,

Laurent Pinchart
