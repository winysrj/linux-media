Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49682 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755714AbZDCKWG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2009 06:22:06 -0400
Date: Fri, 3 Apr 2009 12:22:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Darius Augulis <augulis.darius@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V3] Add camera (CSI) driver for MX1
In-Reply-To: <20090403080923.3222.80609.stgit@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0904031204280.4729@axis700.grange>
References: <20090403080923.3222.80609.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, we're almost there:-) Should be the last iteration.

On Fri, 3 Apr 2009, Darius Augulis wrote:

> From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> 
> Changelog since V2:
> - My signed-off line added
> - Makefile updated
> - .init and .exit removed from pdata
> - includes sorted
> - Video memory limit added
> - Pointers in free_buffer() fixed
> - Indentation fixed
> - Spinlocks added
> - PM implementation removed
> - Added missed clk_put()
> - pdata test added
> - CSI device renamed
> - Platform flags fixed
> - "i.MX" replaced by "MX1" in debug prints

I usually put such changelogs below the "---" line, so it doesn't appear 
in the git commit message, and here you just put a short description of 
the patch.

> 
> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> ---

[snip]

> diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
> index e0783e6..7113b3e 100644
> --- a/arch/arm/plat-mxc/include/mach/memory.h
> +++ b/arch/arm/plat-mxc/include/mach/memory.h
> @@ -24,4 +24,12 @@
>  #define PHYS_OFFSET		UL(0x80000000)
>  #endif
>  
> +#if defined(CONFIG_MX1_VIDEO)

This #ifdef is not needed any more now, the file is not compiled if 
CONFIG_MX1_VIDEO is not defined.

> +	/* Make choises, based on platform choice */
> +	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
> +		(common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
> +			if (pcdev->pdata->flags & MX1_CAMERA_VSYNC_HIGH)
> +				common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
> +			else
> +				common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
> +	}
> +
> +	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
> +		(common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
> +			if (pcdev->pdata->flags & MX1_CAMERA_PCLK_RISING)
> +				common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
> +			else
> +				common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
> +	}
> +
> +	if ((common_flags & SOCAM_DATA_ACTIVE_HIGH) &&
> +		(common_flags & SOCAM_DATA_ACTIVE_LOW)) {
> +			if (pcdev->pdata->flags & MX1_CAMERA_DATA_HIGH)
> +				common_flags &= ~SOCAM_DATA_ACTIVE_LOW;
> +			else
> +				common_flags &= ~SOCAM_DATA_ACTIVE_HIGH;
> +	}

In all three clauses above pdata can be NULL.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
