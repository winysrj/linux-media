Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:50986 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab1ATJjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 04:39:12 -0500
Message-ID: <4D3802BD.4090106@matrix-vision.de>
Date: Thu, 20 Jan 2011 10:39:09 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Martin Hostettler <martin@neutronstar.dyndns.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH V2] v4l: OMAP3 ISP CCDC: Add support for 8bit greyscale
 sensors
References: <1295386062-10618-1-git-send-email-martin@neutronstar.dyndns.org> <201101190027.19904.laurent.pinchart@ideasonboard.com> <4D36EB0A.9050002@matrix-vision.de> <201101191738.52668.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101191738.52668.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 01/19/2011 05:38 PM, Laurent Pinchart wrote:
> Hi Michael,
> 
<snip>
>>>> @@ -1144,10 +1148,15 @@ static void ccdc_configure(struct
>>>> isp_ccdc_device *ccdc) else
>>>>
>>>>  		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
>>>>
>>>> -	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
>>>> +	/* Use PACK8 mode for 1byte per pixel formats */
>>>>
>>>> -	/* CCDC_PAD_SINK */
>>>> -	format = &ccdc->formats[CCDC_PAD_SINK];
>>>> +	if (isp_video_format_info(format->code)->bpp <= 8)
>>>> +		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
>>>> +	else
>>>> +		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
>>>> +
>>
>> It would make sense to me to move this bit into ispccdc_config_sync_if().
> 
> Why do you think so ? This configures how the data is written to memory, while 
> ispccdc_config_sync_if() configures the CCDC input interface.

I see. I was only thinking of ispccdc_config_sync_if() as configuring
the CCDC_SYN_MODE register.  I was in fact wondering why the other
syn_mode assignments weren't made in there.  Now that I understand the
division, I agree that setting PACK8 makes sense wherever the other
memory-writing settings are.

> 
>>>> +
>>>> +	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
>>>>
>>>>  	/* Mosaic filter */
>>>>  	switch (format->code) {
>>>>
>>>> @@ -2244,7 +2253,12 @@ int isp_ccdc_init(struct isp_device *isp)
>>>>
>>>>  	ccdc->syncif.vdpol = 0;
>>>>  	
>>>>  	ccdc->clamp.oblen = 0;
>>>>
>>>> -	ccdc->clamp.dcsubval = 64;
>>>> +
>>>> +	if (isp->pdata->subdevs->interface == ISP_INTERFACE_PARALLEL
>>>> +	    && isp->pdata->subdevs->bus.parallel.width <= 8)
>>>> +		ccdc->clamp.dcsubval = 0;
>>>> +	else
>>>> +		ccdc->clamp.dcsubval = 64;
>>>
>>> I don't like this too much. What happens if you have several sensors
>>> connected to the system with different bus width ?
>>
>> I see Laurent's point here.  Maybe move the dcsubval assignment into
>> ccdc_configure().  Also, don't we also want to remove dcsubval for an
>> 8-bit serially-attached sensor?  In ccdc_configure() you could make it
>> conditional on the mbus format's width on the CCDC sink pad.
> 
> This piece of code only sets the default value. If the user sets another 
> value, the driver must not override it silently when the video stream is 
> started. I'm not really sure how to properly fix this. The best solution is of 
> course to set the value from userspace.

I see the predicament. 64 is a bad default value for 8-bit data, but we
can't at init time know whether we're going to have 8-bit data or
10(+)-bit data to set a different default.  And you can't make a 64-or-0
decision at runtime because the user may have set a custom value after
init (although this isn't currently possible).  But I don't think a user
should have to adjust dcsubval just because he changed to an 8-bit image
and wants a decent image.  Especially since at the moment the user can't
do that anyway.  What I keep coming back to, though it sounds ugly, is 2
different default values for dcsubval.

> 
>>>>  	ccdc->vpcfg.pixelclk = 0;
> 


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
