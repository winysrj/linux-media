Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:47658 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab1ASNps (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 08:45:48 -0500
Message-ID: <4D36EB0A.9050002@matrix-vision.de>
Date: Wed, 19 Jan 2011 14:45:46 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Martin Hostettler <martin@neutronstar.dyndns.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH V2] v4l: OMAP3 ISP CCDC: Add support for 8bit greyscale
 sensors
References: <1295386062-10618-1-git-send-email-martin@neutronstar.dyndns.org> <201101190027.19904.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101190027.19904.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Martin,

a couple of comments inline below.

On 01/19/2011 12:27 AM, Laurent Pinchart wrote:
> Hi Martin,
> 
> Thanks for the patch. One comment below.
> 
> On Tuesday 18 January 2011 22:27:42 Martin Hostettler wrote:
>> Adds support for V4L2_MBUS_FMT_Y8_1X8 format and 8bit data width in
>> synchronous interface.
>>
>> When in 8bit mode don't apply DC substraction of 64 per default as this
>> would remove 1/4 of the sensor range.
>>
>> When using V4L2_MBUS_FMT_Y8_1X8 (or possibly another 8bit per pixel) mode
>> set the CDCC to output 8bit per pixel instead of 16bit.
>>
>> Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
>> ---
>>  drivers/media/video/isp/ispccdc.c  |   22 ++++++++++++++++++----
>>  drivers/media/video/isp/ispvideo.c |    2 ++
>>  2 files changed, 20 insertions(+), 4 deletions(-)
>>
>> Changes since first version:
>> 	- forward ported to current media.git
>>
>> diff --git a/drivers/media/video/isp/ispccdc.c
>> b/drivers/media/video/isp/ispccdc.c index 578c8bf..c7397c9 100644
>> --- a/drivers/media/video/isp/ispccdc.c
>> +++ b/drivers/media/video/isp/ispccdc.c
>> @@ -43,6 +43,7 @@ __ccdc_get_format(struct isp_ccdc_device *ccdc, struct
>> v4l2_subdev_fh *fh, unsigned int pad, enum v4l2_subdev_format_whence
>> which);
>>
>>  static const unsigned int ccdc_fmts[] = {
>> +	V4L2_MBUS_FMT_Y8_1X8,
>>  	V4L2_MBUS_FMT_SGRBG10_1X10,
>>  	V4L2_MBUS_FMT_SRGGB10_1X10,
>>  	V4L2_MBUS_FMT_SBGGR10_1X10,
>> @@ -1127,6 +1128,9 @@ static void ccdc_configure(struct isp_ccdc_device
>> *ccdc) ccdc->syncif.datsz = pdata ? pdata->width : 10;
>>  	ispccdc_config_sync_if(ccdc, &ccdc->syncif);
>>
>> +	/* CCDC_PAD_SINK */
>> +	format = &ccdc->formats[CCDC_PAD_SINK];
>> +
>>  	syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
>>
>>  	/* Use the raw, unprocessed data when writing to memory. The H3A and
>> @@ -1144,10 +1148,15 @@ static void ccdc_configure(struct isp_ccdc_device
>> *ccdc) else
>>  		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
>>
>> -	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
>> +	/* Use PACK8 mode for 1byte per pixel formats */
>>
>> -	/* CCDC_PAD_SINK */
>> -	format = &ccdc->formats[CCDC_PAD_SINK];
>> +	if (isp_video_format_info(format->code)->bpp <= 8)
>> +		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
>> +	else
>> +		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
>> +

It would make sense to me to move this bit into ispccdc_config_sync_if().

>> +
>> +	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
>>
>>  	/* Mosaic filter */
>>  	switch (format->code) {
>> @@ -2244,7 +2253,12 @@ int isp_ccdc_init(struct isp_device *isp)
>>  	ccdc->syncif.vdpol = 0;
>>
>>  	ccdc->clamp.oblen = 0;
>> -	ccdc->clamp.dcsubval = 64;
>> +
>> +	if (isp->pdata->subdevs->interface == ISP_INTERFACE_PARALLEL
>> +	    && isp->pdata->subdevs->bus.parallel.width <= 8)
>> +		ccdc->clamp.dcsubval = 0;
>> +	else
>> +		ccdc->clamp.dcsubval = 64;
> 
> I don't like this too much. What happens if you have several sensors connected 
> to the system with different bus width ?

I see Laurent's point here.  Maybe move the dcsubval assignment into
ccdc_configure().  Also, don't we also want to remove dcsubval for an
8-bit serially-attached sensor?  In ccdc_configure() you could make it
conditional on the mbus format's width on the CCDC sink pad.

> 
>>  	ccdc->vpcfg.pixelclk = 0;
>>
>> diff --git a/drivers/media/video/isp/ispvideo.c
>> b/drivers/media/video/isp/ispvideo.c index 5f984e4..cd3d331 100644
>> --- a/drivers/media/video/isp/ispvideo.c
>> +++ b/drivers/media/video/isp/ispvideo.c
>> @@ -221,6 +221,8 @@ isp_video_check_format(struct isp_video *video, struct
>> isp_video_fh *vfh) }
>>
>>  static struct isp_format_info formats[] = {
>> +	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
>> +	  V4L2_MBUS_FMT_Y8_1X8, V4L2_PIX_FMT_GREY, 8, },
>>  	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
>>  	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
>>  	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
> 


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
