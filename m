Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26068 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbdK1OPs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 09:15:48 -0500
Date: Tue, 28 Nov 2017 17:15:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 1/3] media: staging: atomisp: fix for sparse "using
 plain integer as NULL pointer" warnings.
Message-ID: <20171128141524.kpvqbowgmpkzwfuz@mwanda>
References: <20171127122125.GB8561@kroah.com>
 <20171127124450.28799-1-jeremy@azazel.net>
 <20171127124450.28799-2-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127124450.28799-2-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 27, 2017 at 12:44:48PM +0000, Jeremy Sowden wrote:
> The "address" member of struct ia_css_host_data is a pointer-to-char, so define default as NULL.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  .../css2400/runtime/isp_param/interface/ia_css_isp_param_types.h        | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> index 8e651b80345a..6fee3f7fd184 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> @@ -95,7 +95,7 @@ union ia_css_all_memory_offsets {
>  };
>  
>  #define IA_CSS_DEFAULT_ISP_MEM_PARAMS \
> -		{ { { { 0, 0 } } } }
> +		{ { { { NULL, 0 } } } }

This define is way ugly and instead of making superficial changes, you
should try to eliminate it.

People look at warnings as a bad thing but they are actually a valuable
resource which call attention to bad code.  By making this change you're
kind of wasting the warning.  The bad code is still there, it's just
swept under the rug but like a dead mouse carcass it's still stinking up
the living room.  We should leave the warning there until it irritates
someone enough to fix it properly.

regards,
dan carpenter
