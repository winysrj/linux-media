Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753640AbdC2HbL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 03:31:11 -0400
Date: Wed, 29 Mar 2017 09:28:38 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Haim Daniel <haimdaniel@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] [media] staging: css2400: fix checkpatch error
Message-ID: <20170329072838.GA8008@kroah.com>
References: <b0bf9753-54d7-5178-5339-37b24d7e8191@gmail.com>
 <1490771548-6134-1-git-send-email-haimdaniel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490771548-6134-1-git-send-email-haimdaniel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 29, 2017 at 10:12:28AM +0300, Haim Daniel wrote:
> isp_capture_defs.h:

What is this line for?

> fix checkpatch ERROR: 

Trailing whitespace?

> Macros with complex values should be enclosed in parentheses
> 
> Signed-off-by: Haim Daniel <haimdaniel@gmail.com>
> ---
>  .../pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h   | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h
> index aa413df..78cbbf6 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h
> @@ -19,7 +19,7 @@
>  #define _ISP_CAPTURE_BITS_PER_ELEM                32  /* only for data, not SOP */						           
>  #define _ISP_CAPTURE_BYTES_PER_ELEM               (_ISP_CAPTURE_BITS_PER_ELEM/8	)				           
>  #define _ISP_CAPTURE_BYTES_PER_WORD               32		/* 256/8 */	
> -#define _ISP_CAPTURE_ELEM_PER_WORD                _ISP_CAPTURE_BYTES_PER_WORD / _ISP_CAPTURE_BYTES_PER_ELEM		           
> +#define _ISP_CAPTURE_ELEM_PER_WORD                (_ISP_CAPTURE_BYTES_PER_WORD / _ISP_CAPTURE_BYTES_PER_ELEM)         

Does this change really make sense?  Why keep the trailing whitespace if
you touch the line?

thanks,

greg k-h
