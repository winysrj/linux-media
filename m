Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40208 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752066AbeBZHwN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 02:52:13 -0500
Date: Mon, 26 Feb 2018 09:52:10 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: atomisp: convert default struct values to use
 compound-literals with designated initializers.
Message-ID: <20180226075210.5tcackrgh67muven@valkosipuli.retiisi.org.uk>
References: <20171219163513.31378-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219163513.31378-1-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jeremy,

On Tue, Dec 19, 2017 at 04:35:13PM +0000, Jeremy Sowden wrote:
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> index 2283dd1c1c9b..2de9f8eda2da 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> @@ -94,14 +94,4 @@ union ia_css_all_memory_offsets {
>  	} array[IA_CSS_NUM_PARAM_CLASSES];
>  };
>  
> -#define IA_CSS_DEFAULT_ISP_MEM_PARAMS \
> -		{ { { { 0, 0 } } } }

There was a minor conflict here, another patch had changed the first 0 to
NULL. The lines were removed so that was trivial to resolve. The patch is
now applied in my atomisp branch.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
