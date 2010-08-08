Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51630 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab0HHW4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Aug 2010 18:56:32 -0400
Received: by pwj7 with SMTP id 7so1099216pwj.19
        for <linux-media@vger.kernel.org>; Sun, 08 Aug 2010 15:56:31 -0700 (PDT)
Message-ID: <4C5F361B.10202@brooks.nu>
Date: Sun, 08 Aug 2010 16:56:27 -0600
From: Lane Brooks <lane@brooks.nu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: OMAP3 Bridge Problems
References: <4C583538.8060504@gmail.com> <4C5AE19B.50609@brooks.nu> <4C5B08BE.8080709@brooks.nu> <201008090029.04455.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201008090029.04455.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  On 08/08/2010 04:29 PM, Laurent Pinchart wrote:
> Hi Lane,
>
> Thanks for the patch.
>
> On Thursday 05 August 2010 20:53:50 Lane Brooks wrote:
>
> [snip]
>
>> I was able to get YUV CCDC capture mode working with rather minimal
>> effort. Attached is a patch with the initial effort. Can you comment?
>
> Writing to the ISPCCDC_SYN_MODE register should be moved to ccdc_configure().
> Just move the switch statement there right after the
>
> 	format =&ccdc->formats[CCDC_PAD_SINK];
>
> line (without the ispctrl_val settings), it should be enough.
>
>> +		isp_reg_writel(isp, ispctrl_val, OMAP3_ISP_IOMEM_MAIN,
>> +			       ISP_CTRL);
> The ISP_CTRL register should be written in isp_select_bridge_input() only. As
> you correctly mention, whether the data is in little endian or big endian
> format should come from platform data, so I think it's fine to force board
> files to set the isp->pdata->parallel.bridge field to the correct value.
Putting the bridge settings in the platform data is tricky because they 
need to change depending on the selected format. For example, for my 
board, when in SGRBG mode, the bridge needs disabled. When in YUV16 
mode, however, I need need to select BIG/LITTLE endian depending on 
whether it is YUYV or UYVY or ...  I am not quite sure how to capture 
that in the platform data without enumerating every supported format 
code in the platform data. The current patch knows (based on the OMAP 
TRM) that YUV16 mode requires the bridge to be enabled. So in the 
platform data I specify the bridge state for SGBRG mode and force the 
bridge to BIG endian in YUV16 mode. This leaves the sensor to switch the 
phasing based on YUYV, YVYU, etc. mode.  I am not sure who should be in 
charge of doing byte swapping in general, but if the input and output 
modes are the same, then big endian should be used to avoid a byte swap. 
In other words, the mode is completely determinable based on the 
formats, so perhaps I should implement it that way. If the input and 
output port require a byte swap, then go little endian, otherwise go big 
endian.

The reason why I put both writes to the ISPCTRL and SYN_MODE registers 
where I did. Moving them to other places will require querying the 
selected format code. Is that what you want as well?

Lane
