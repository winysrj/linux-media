Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdDRLbg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 07:31:36 -0400
Date: Tue, 18 Apr 2017 13:31:26 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Haim Daniel <haimdaniel@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v3] [media] staging: css2400: fix checkpatch error
Message-ID: <20170418113126.GA15397@kroah.com>
References: <20170329072838.GA8008@kroah.com>
 <1490773808-7242-1-git-send-email-haimdaniel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490773808-7242-1-git-send-email-haimdaniel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 29, 2017 at 10:50:08AM +0300, Haim Daniel wrote:
> isp_capture_defs.h: clean up ERROR: Macros with complex values should be enclosed in parentheses
> 
> Signed-off-by: Haim Daniel <haimdaniel@gmail.com>
> ---
>  .../pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h   | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h
> index aa413df..117c7a2 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h
> @@ -19,7 +19,7 @@
>  #define _ISP_CAPTURE_BITS_PER_ELEM                32  /* only for data, not SOP */						           
>  #define _ISP_CAPTURE_BYTES_PER_ELEM               (_ISP_CAPTURE_BITS_PER_ELEM/8	)				           
>  #define _ISP_CAPTURE_BYTES_PER_WORD               32		/* 256/8 */	
> -#define _ISP_CAPTURE_ELEM_PER_WORD                _ISP_CAPTURE_BYTES_PER_WORD / _ISP_CAPTURE_BYTES_PER_ELEM		           
> +#define _ISP_CAPTURE_ELEM_PER_WORD                (_ISP_CAPTURE_BYTES_PER_WORD / _ISP_CAPTURE_BYTES_PER_ELEM)

Why only fix one of these instances?

And why is this define even needed?  No one touches it, right?

Also, please cc: Alan on patches to this driver when you resend.  You
are using scripts/get_maintainer.pl, right?

thanks,

greg k-h
