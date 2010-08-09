Return-path: <laurent.pinchart@ideasonboard.com>
Received: from perceval.irobotique.be ([92.243.18.41]:36824 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab0HIJYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 05:24:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lane Brooks <lane@brooks.nu>
Subject: Re: OMAP3 Bridge Problems
Date: Mon, 9 Aug 2010 11:25:55 +0200
Cc: linux-media@vger.kernel.org
References: <4C583538.8060504@gmail.com> <201008090029.04455.laurent.pinchart@ideasonboard.com> <4C5F361B.10202@brooks.nu>
In-Reply-To: <4C5F361B.10202@brooks.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008091125.56159.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lane,

On Monday 09 August 2010 00:56:27 Lane Brooks wrote:
> On 08/08/2010 04:29 PM, Laurent Pinchart wrote:
> > Hi Lane,
> > 
> > Thanks for the patch.
> > 
> > On Thursday 05 August 2010 20:53:50 Lane Brooks wrote:
> > 
> > [snip]
> > 
> >> I was able to get YUV CCDC capture mode working with rather minimal
> >> effort. Attached is a patch with the initial effort. Can you comment?
> > 
> > Writing to the ISPCCDC_SYN_MODE register should be moved to
> > ccdc_configure(). Just move the switch statement there right after the
> > 
> > 	format =&ccdc->formats[CCDC_PAD_SINK];
> > 
> > line (without the ispctrl_val settings), it should be enough.
> > 
> >> +		isp_reg_writel(isp, ispctrl_val, OMAP3_ISP_IOMEM_MAIN,
> >> +			       ISP_CTRL);
> > 
> > The ISP_CTRL register should be written in isp_select_bridge_input()
> > only. As you correctly mention, whether the data is in little endian or
> > big endian format should come from platform data, so I think it's fine
> > to force board files to set the isp->pdata->parallel.bridge field to the
> > correct value.
> 
> Putting the bridge settings in the platform data is tricky because they
> need to change depending on the selected format. For example, for my
> board, when in SGRBG mode, the bridge needs disabled. When in YUV16
> mode, however, I need need to select BIG/LITTLE endian depending on
> whether it is YUYV or UYVY or ...

Ah right... So your sensor can output both Bayer and YUV data ? What sensor is 
that BTW ?

> I am not quite sure how to capture that in the platform data without
> enumerating every supported format code in the platform data. The current
> patch knows (based on the OMAP TRM) that YUV16 mode requires the bridge to
> be enabled. So in the platform data I specify the bridge state for SGBRG
> mode and force the bridge to BIG endian in YUV16 mode. This leaves the
> sensor to switch the phasing based on YUYV, YVYU, etc. mode.  I am not sure
> who should be in charge of doing byte swapping in general, but if the input
> and output modes are the same, then big endian should be used to avoid a
> byte swap. In other words, the mode is completely determinable based on the
> formats, so perhaps I should implement it that way. If the input and output
> port require a byte swap, then go little endian, otherwise go big endian.

OK I understand. The best solution (for now) would then be to modify 
isp_configure_bridge(). I wrote a few patches that modify how platform data is 
handled, but I can't commit them at the moment (they depend on other patches 
that I still need to clean up).

> The reason why I put both writes to the ISPCTRL and SYN_MODE registers
> where I did. Moving them to other places will require querying the
> selected format code. Is that what you want as well?

For SYN_MODE, definitely. For ISPCTRL, you can hack isp_configure_bridge() to 
retrieve the current CCDC input format, and we'll write a proper fix right 
after I commit my platform data restructuring patches.

-- 
Regards,

Laurent Pinchart
