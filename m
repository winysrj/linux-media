Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB206C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 23:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 576ED2146E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 23:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbfCMXds (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 19:33:48 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37976 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfCMXdr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 19:33:47 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: koike)
        with ESMTPSA id 97FA927E629
Subject: Re: [PATCH v2] media: vimc: propagate pixel format in the stream
To:     kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org
Cc:     lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org, andrealmeid@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20190313013725.6964-1-helen.koike@collabora.com>
 <6988fbd1-523f-de6f-205c-61a94669ffcf@ideasonboard.com>
From:   Helen Koike <helen.koike@collabora.com>
Openpgp: preference=signencrypt
Autocrypt: addr=helen.koike@collabora.com; keydata=
 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
Message-ID: <d4b3df9c-9b0b-96c3-7731-4f74975a6097@collabora.com>
Date:   Wed, 13 Mar 2019 20:33:36 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <6988fbd1-523f-de6f-205c-61a94669ffcf@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 3/13/19 10:24 AM, Kieran Bingham wrote:
> Hi Helen,
> 
> Glancing through I saw one tiny thing below: Not a full review...
> 
>   s/vimc_cap_supported_pixftm/vimc_cap_supported_pixfmt/

Thanks for spotting that, fixed in v3 :)

Helen

> 
> 
> --
> Regards
> 
> Kieran
> 
> 
> On 13/03/2019 01:37, Helen Koike wrote:
>> Media bus codes were being mapped to pixelformats, which causes a
>> limitation on vimc because not all pixelformats can be mapped to media
>> bus codes.
>> Also, media bus codes are an internal configuration from the device.
>> Userspace only assures media bus codes matches between pads and expects
>> the image in a given pixelformat. So we can allow almost any media bus
>> format to be configured between pads, except for debayer that expects a
>> media bus code of type bayer in the sink pad.
>>
>> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>>
>> ---
>> Hello,
>>
>> I fixed the errors "v4l2-compliance -m0" was reporting (thanks Hans for
>> testing, I'll be more carefull next time), I also removed some
>> dead code from the vimc-common.h header (thanks Andre for the review).
>> I hope this looks find now, please let me knof if you see anything else.
>>
>> The series depends on
>> "[PATCH] media: Introduce helpers to fill pixel format structs "
>>
>> Thanks,
>> Helen
>>
>> Changes in v2:
>> - use __u32 for vimc_mbus_list[] as it is compared with userspace
>> objects
>> - remove struct vimc_pix_map and vimc_pix_map_*() function scopes from
>> header that are not required anymore.
>> - fix failing "v4l2-compliance -m0" tests by adding
>> vimc_mbus_code_supported() and checking the mbus code given by userspace
>> in set_fmt functions.
>>
>>  drivers/media/platform/vimc/vimc-capture.c  |  76 +++--
>>  drivers/media/platform/vimc/vimc-common.c   | 309 ++++++++------------
>>  drivers/media/platform/vimc/vimc-common.h   |  58 ++--
>>  drivers/media/platform/vimc/vimc-debayer.c  |  81 +++--
>>  drivers/media/platform/vimc/vimc-scaler.c   |  63 ++--
>>  drivers/media/platform/vimc/vimc-sensor.c   |  51 +---
>>  drivers/media/platform/vimc/vimc-streamer.c |   2 +
>>  drivers/media/platform/vimc/vimc-streamer.h |   6 +
>>  8 files changed, 304 insertions(+), 342 deletions(-)
>>
>> diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
>> index e976a9d6b460..6377974879d7 100644
>> --- a/drivers/media/platform/vimc/vimc-capture.c
>> +++ b/drivers/media/platform/vimc/vimc-capture.c
>> @@ -28,6 +28,32 @@
>>  
>>  #define VIMC_CAP_DRV_NAME "vimc-capture"
>>  
>> +static const u32 vimc_cap_supported_pixftm[] = {
> 
> Should that be vimc_cap_supported_pixfmt? (s/ftm/fmt/)
> 
>> +	V4L2_PIX_FMT_BGR24,
>> +	V4L2_PIX_FMT_RGB24,
>> +	V4L2_PIX_FMT_ARGB32,
>> +	V4L2_PIX_FMT_SBGGR8,
>> +	V4L2_PIX_FMT_SGBRG8,
>> +	V4L2_PIX_FMT_SGRBG8,
>> +	V4L2_PIX_FMT_SRGGB8,
>> +	V4L2_PIX_FMT_SBGGR10,
>> +	V4L2_PIX_FMT_SGBRG10,
>> +	V4L2_PIX_FMT_SGRBG10,
>> +	V4L2_PIX_FMT_SRGGB10,
>> +	V4L2_PIX_FMT_SBGGR10ALAW8,
>> +	V4L2_PIX_FMT_SGBRG10ALAW8,
>> +	V4L2_PIX_FMT_SGRBG10ALAW8,
>> +	V4L2_PIX_FMT_SRGGB10ALAW8,
>> +	V4L2_PIX_FMT_SBGGR10DPCM8,
>> +	V4L2_PIX_FMT_SGBRG10DPCM8,
>> +	V4L2_PIX_FMT_SGRBG10DPCM8,
>> +	V4L2_PIX_FMT_SRGGB10DPCM8,
>> +	V4L2_PIX_FMT_SBGGR12,
>> +	V4L2_PIX_FMT_SGBRG12,
>> +	V4L2_PIX_FMT_SGRBG12,
>> +	V4L2_PIX_FMT_SRGGB12,
>> +};
>> +
>>  struct vimc_cap_device {
>>  	struct vimc_ent_device ved;
>>  	struct video_device vdev;
>> @@ -101,29 +127,25 @@ static int vimc_cap_try_fmt_vid_cap(struct file *file, void *priv,
>>  				    struct v4l2_format *f)
>>  {
>>  	struct v4l2_pix_format *format = &f->fmt.pix;
>> -	const struct vimc_pix_map *vpix;
>>  
>>  	format->width = clamp_t(u32, format->width, VIMC_FRAME_MIN_WIDTH,
>>  				VIMC_FRAME_MAX_WIDTH) & ~1;
>>  	format->height = clamp_t(u32, format->height, VIMC_FRAME_MIN_HEIGHT,
>>  				 VIMC_FRAME_MAX_HEIGHT) & ~1;
>>  
>> -	/* Don't accept a pixelformat that is not on the table */
>> -	vpix = vimc_pix_map_by_pixelformat(format->pixelformat);
>> -	if (!vpix) {
>> -		format->pixelformat = fmt_default.pixelformat;
>> -		vpix = vimc_pix_map_by_pixelformat(format->pixelformat);
>> -	}
>> -	/* TODO: Add support for custom bytesperline values */
>> -	format->bytesperline = format->width * vpix->bpp;
>> -	format->sizeimage = format->bytesperline * format->height;
>> +	vimc_colorimetry_clamp(format);
>>  
>>  	if (format->field == V4L2_FIELD_ANY)
>>  		format->field = fmt_default.field;
>>  
>> -	vimc_colorimetry_clamp(format);
>> +	/* TODO: Add support for custom bytesperline values */
>>  
>> -	return 0;
>> +	/* Don't accept a pixelformat that is not on the table */
>> +	if (!v4l2_format_info(format->pixelformat))
>> +		format->pixelformat = fmt_default.pixelformat;
>> +
>> +	return v4l2_fill_pixfmt(format, format->pixelformat,
>> +				format->width, format->height);
>>  }
>>  
>>  static int vimc_cap_s_fmt_vid_cap(struct file *file, void *priv,
>> @@ -159,27 +181,31 @@ static int vimc_cap_s_fmt_vid_cap(struct file *file, void *priv,
>>  static int vimc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
>>  				     struct v4l2_fmtdesc *f)
>>  {
>> -	const struct vimc_pix_map *vpix = vimc_pix_map_by_index(f->index);
>> -
>> -	if (!vpix)
>> +	if (f->index >= ARRAY_SIZE(vimc_cap_supported_pixftm))
>>  		return -EINVAL;
>>  
>> -	f->pixelformat = vpix->pixelformat;
>> +	f->pixelformat = vimc_cap_supported_pixftm[f->index];
>>  
>>  	return 0;
>>  }
>>  
>> +static bool vimc_cap_is_pixfmt_supported(u32 pixelformat)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(vimc_cap_supported_pixftm); i++)
>> +		if (vimc_cap_supported_pixftm[i] == pixelformat)
>> +			return true;
>> +	return false;
>> +}
>> +
>>  static int vimc_cap_enum_framesizes(struct file *file, void *fh,
>>  				    struct v4l2_frmsizeenum *fsize)
>>  {
>> -	const struct vimc_pix_map *vpix;
>> -
>>  	if (fsize->index)
>>  		return -EINVAL;
>>  
>> -	/* Only accept code in the pix map table */
>> -	vpix = vimc_pix_map_by_code(fsize->pixel_format);
>> -	if (!vpix)
>> +	if (!vimc_cap_is_pixfmt_supported(fsize->pixel_format))
>>  		return -EINVAL;
>>  
>>  	fsize->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
>> @@ -253,6 +279,7 @@ static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
>>  		return ret;
>>  	}
>>  
>> +	vcap->stream.producer_pixfmt = vcap->format.pixelformat;
>>  	ret = vimc_streamer_s_stream(&vcap->stream, &vcap->ved, 1);
>>  	if (ret) {
>>  		media_pipeline_stop(entity);
>> @@ -403,7 +430,6 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
>>  {
>>  	struct v4l2_device *v4l2_dev = master_data;
>>  	struct vimc_platform_data *pdata = comp->platform_data;
>> -	const struct vimc_pix_map *vpix;
>>  	struct vimc_cap_device *vcap;
>>  	struct video_device *vdev;
>>  	struct vb2_queue *q;
>> @@ -458,10 +484,8 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
>>  
>>  	/* Set default frame format */
>>  	vcap->format = fmt_default;
>> -	vpix = vimc_pix_map_by_pixelformat(vcap->format.pixelformat);
>> -	vcap->format.bytesperline = vcap->format.width * vpix->bpp;
>> -	vcap->format.sizeimage = vcap->format.bytesperline *
>> -				 vcap->format.height;
>> +	v4l2_fill_pixfmt(&vcap->format, vcap->format.pixelformat,
>> +			 vcap->format.width, vcap->format.height);
>>  
>>  	/* Fill the vimc_ent_device struct */
>>  	vcap->ved.ent = &vcap->vdev.entity;
>> diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
>> index 0adbfd8fd26d..dcfefaf4fa61 100644
>> --- a/drivers/media/platform/vimc/vimc-common.c
>> +++ b/drivers/media/platform/vimc/vimc-common.c
>> @@ -20,192 +20,139 @@
>>  
>>  #include "vimc-common.h"
>>  
>> -/*
>> - * NOTE: non-bayer formats need to come first (necessary for enum_mbus_code
>> - * in the scaler)
>> - */
>> -static const struct vimc_pix_map vimc_pix_map_list[] = {
>> -	/* TODO: add all missing formats */
>> -
>> -	/* RGB formats */
>> -	{
>> -		.code = MEDIA_BUS_FMT_BGR888_1X24,
>> -		.pixelformat = V4L2_PIX_FMT_BGR24,
>> -		.bpp = 3,
>> -		.bayer = false,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_RGB888_1X24,
>> -		.pixelformat = V4L2_PIX_FMT_RGB24,
>> -		.bpp = 3,
>> -		.bayer = false,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_ARGB8888_1X32,
>> -		.pixelformat = V4L2_PIX_FMT_ARGB32,
>> -		.bpp = 4,
>> -		.bayer = false,
>> -	},
>> -
>> -	/* Bayer formats */
>> -	{
>> -		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SBGGR8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SGBRG8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SGBRG8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SGRBG8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SGRBG8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SRGGB8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SRGGB8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SBGGR10_1X10,
>> -		.pixelformat = V4L2_PIX_FMT_SBGGR10,
>> -		.bpp = 2,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SGBRG10_1X10,
>> -		.pixelformat = V4L2_PIX_FMT_SGBRG10,
>> -		.bpp = 2,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SGRBG10_1X10,
>> -		.pixelformat = V4L2_PIX_FMT_SGRBG10,
>> -		.bpp = 2,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SRGGB10_1X10,
>> -		.pixelformat = V4L2_PIX_FMT_SRGGB10,
>> -		.bpp = 2,
>> -		.bayer = true,
>> -	},
>> -
>> -	/* 10bit raw bayer a-law compressed to 8 bits */
>> -	{
>> -		.code = MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SBGGR10ALAW8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SGBRG10ALAW8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SGRBG10ALAW8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SRGGB10ALAW8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -
>> -	/* 10bit raw bayer DPCM compressed to 8 bits */
>> -	{
>> -		.code = MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SBGGR10DPCM8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SGBRG10DPCM8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SGRBG10DPCM8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8,
>> -		.pixelformat = V4L2_PIX_FMT_SRGGB10DPCM8,
>> -		.bpp = 1,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SBGGR12_1X12,
>> -		.pixelformat = V4L2_PIX_FMT_SBGGR12,
>> -		.bpp = 2,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SGBRG12_1X12,
>> -		.pixelformat = V4L2_PIX_FMT_SGBRG12,
>> -		.bpp = 2,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SGRBG12_1X12,
>> -		.pixelformat = V4L2_PIX_FMT_SGRBG12,
>> -		.bpp = 2,
>> -		.bayer = true,
>> -	},
>> -	{
>> -		.code = MEDIA_BUS_FMT_SRGGB12_1X12,
>> -		.pixelformat = V4L2_PIX_FMT_SRGGB12,
>> -		.bpp = 2,
>> -		.bayer = true,
>> -	},
>> +const __u32 vimc_mbus_list[] = {
>> +	MEDIA_BUS_FMT_FIXED,
>> +	MEDIA_BUS_FMT_RGB444_1X12,
>> +	MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE,
>> +	MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
>> +	MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE,
>> +	MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
>> +	MEDIA_BUS_FMT_RGB565_1X16,
>> +	MEDIA_BUS_FMT_BGR565_2X8_BE,
>> +	MEDIA_BUS_FMT_BGR565_2X8_LE,
>> +	MEDIA_BUS_FMT_RGB565_2X8_BE,
>> +	MEDIA_BUS_FMT_RGB565_2X8_LE,
>> +	MEDIA_BUS_FMT_RGB666_1X18,
>> +	MEDIA_BUS_FMT_RBG888_1X24,
>> +	MEDIA_BUS_FMT_RGB666_1X24_CPADHI,
>> +	MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
>> +	MEDIA_BUS_FMT_BGR888_1X24,
>> +	MEDIA_BUS_FMT_GBR888_1X24,
>> +	MEDIA_BUS_FMT_RGB888_1X24,
>> +	MEDIA_BUS_FMT_RGB888_2X12_BE,
>> +	MEDIA_BUS_FMT_RGB888_2X12_LE,
>> +	MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
>> +	MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA,
>> +	MEDIA_BUS_FMT_ARGB8888_1X32,
>> +	MEDIA_BUS_FMT_RGB888_1X32_PADHI,
>> +	MEDIA_BUS_FMT_RGB101010_1X30,
>> +	MEDIA_BUS_FMT_RGB121212_1X36,
>> +	MEDIA_BUS_FMT_RGB161616_1X48,
>> +	MEDIA_BUS_FMT_Y8_1X8,
>> +	MEDIA_BUS_FMT_UV8_1X8,
>> +	MEDIA_BUS_FMT_UYVY8_1_5X8,
>> +	MEDIA_BUS_FMT_VYUY8_1_5X8,
>> +	MEDIA_BUS_FMT_YUYV8_1_5X8,
>> +	MEDIA_BUS_FMT_YVYU8_1_5X8,
>> +	MEDIA_BUS_FMT_UYVY8_2X8,
>> +	MEDIA_BUS_FMT_VYUY8_2X8,
>> +	MEDIA_BUS_FMT_YUYV8_2X8,
>> +	MEDIA_BUS_FMT_YVYU8_2X8,
>> +	MEDIA_BUS_FMT_Y10_1X10,
>> +	MEDIA_BUS_FMT_Y10_2X8_PADHI_LE,
>> +	MEDIA_BUS_FMT_UYVY10_2X10,
>> +	MEDIA_BUS_FMT_VYUY10_2X10,
>> +	MEDIA_BUS_FMT_YUYV10_2X10,
>> +	MEDIA_BUS_FMT_YVYU10_2X10,
>> +	MEDIA_BUS_FMT_Y12_1X12,
>> +	MEDIA_BUS_FMT_UYVY12_2X12,
>> +	MEDIA_BUS_FMT_VYUY12_2X12,
>> +	MEDIA_BUS_FMT_YUYV12_2X12,
>> +	MEDIA_BUS_FMT_YVYU12_2X12,
>> +	MEDIA_BUS_FMT_UYVY8_1X16,
>> +	MEDIA_BUS_FMT_VYUY8_1X16,
>> +	MEDIA_BUS_FMT_YUYV8_1X16,
>> +	MEDIA_BUS_FMT_YVYU8_1X16,
>> +	MEDIA_BUS_FMT_YDYUYDYV8_1X16,
>> +	MEDIA_BUS_FMT_UYVY10_1X20,
>> +	MEDIA_BUS_FMT_VYUY10_1X20,
>> +	MEDIA_BUS_FMT_YUYV10_1X20,
>> +	MEDIA_BUS_FMT_YVYU10_1X20,
>> +	MEDIA_BUS_FMT_VUY8_1X24,
>> +	MEDIA_BUS_FMT_YUV8_1X24,
>> +	MEDIA_BUS_FMT_UYYVYY8_0_5X24,
>> +	MEDIA_BUS_FMT_UYVY12_1X24,
>> +	MEDIA_BUS_FMT_VYUY12_1X24,
>> +	MEDIA_BUS_FMT_YUYV12_1X24,
>> +	MEDIA_BUS_FMT_YVYU12_1X24,
>> +	MEDIA_BUS_FMT_YUV10_1X30,
>> +	MEDIA_BUS_FMT_UYYVYY10_0_5X30,
>> +	MEDIA_BUS_FMT_AYUV8_1X32,
>> +	MEDIA_BUS_FMT_UYYVYY12_0_5X36,
>> +	MEDIA_BUS_FMT_YUV12_1X36,
>> +	MEDIA_BUS_FMT_YUV16_1X48,
>> +	MEDIA_BUS_FMT_UYYVYY16_0_5X48,
>> +	MEDIA_BUS_FMT_SBGGR8_1X8,
>> +	MEDIA_BUS_FMT_SGBRG8_1X8,
>> +	MEDIA_BUS_FMT_SGRBG8_1X8,
>> +	MEDIA_BUS_FMT_SRGGB8_1X8,
>> +	MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8,
>> +	MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8,
>> +	MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8,
>> +	MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8,
>> +	MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8,
>> +	MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8,
>> +	MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
>> +	MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8,
>> +	MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE,
>> +	MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE,
>> +	MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE,
>> +	MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE,
>> +	MEDIA_BUS_FMT_SBGGR10_1X10,
>> +	MEDIA_BUS_FMT_SGBRG10_1X10,
>> +	MEDIA_BUS_FMT_SGRBG10_1X10,
>> +	MEDIA_BUS_FMT_SRGGB10_1X10,
>> +	MEDIA_BUS_FMT_SBGGR12_1X12,
>> +	MEDIA_BUS_FMT_SGBRG12_1X12,
>> +	MEDIA_BUS_FMT_SGRBG12_1X12,
>> +	MEDIA_BUS_FMT_SRGGB12_1X12,
>> +	MEDIA_BUS_FMT_SBGGR14_1X14,
>> +	MEDIA_BUS_FMT_SGBRG14_1X14,
>> +	MEDIA_BUS_FMT_SGRBG14_1X14,
>> +	MEDIA_BUS_FMT_SRGGB14_1X14,
>> +	MEDIA_BUS_FMT_SBGGR16_1X16,
>> +	MEDIA_BUS_FMT_SGBRG16_1X16,
>> +	MEDIA_BUS_FMT_SGRBG16_1X16,
>> +	MEDIA_BUS_FMT_SRGGB16_1X16,
>> +	MEDIA_BUS_FMT_JPEG_1X8,
>> +	MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8,
>> +	MEDIA_BUS_FMT_AHSV8888_1X32,
>>  };
>>  
>> -const struct vimc_pix_map *vimc_pix_map_by_index(unsigned int i)
>> -{
>> -	if (i >= ARRAY_SIZE(vimc_pix_map_list))
>> -		return NULL;
>> -
>> -	return &vimc_pix_map_list[i];
>> -}
>> -EXPORT_SYMBOL_GPL(vimc_pix_map_by_index);
>> -
>> -const struct vimc_pix_map *vimc_pix_map_by_code(u32 code)
>> +/* Helper function to check mbus codes */
>> +bool vimc_mbus_code_supported(__u32 code)
>>  {
>>  	unsigned int i;
>>  
>> -	for (i = 0; i < ARRAY_SIZE(vimc_pix_map_list); i++) {
>> -		if (vimc_pix_map_list[i].code == code)
>> -			return &vimc_pix_map_list[i];
>> -	}
>> -	return NULL;
>> +	for (i = 0; i < ARRAY_SIZE(vimc_mbus_list); i++)
>> +		if (code == vimc_mbus_list[i])
>> +			return true;
>> +	return false;
>>  }
>> -EXPORT_SYMBOL_GPL(vimc_pix_map_by_code);
>> +EXPORT_SYMBOL_GPL(vimc_mbus_code_supported);
>>  
>> -const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat)
>> +/* Helper function to enumerate mbus codes */
>> +int vimc_enum_mbus_code(struct v4l2_subdev *sd,
>> +			struct v4l2_subdev_pad_config *cfg,
>> +			struct v4l2_subdev_mbus_code_enum *code)
>>  {
>> -	unsigned int i;
>> +	if (code->index >= ARRAY_SIZE(vimc_mbus_list))
>> +		return -EINVAL;
>>  
>> -	for (i = 0; i < ARRAY_SIZE(vimc_pix_map_list); i++) {
>> -		if (vimc_pix_map_list[i].pixelformat == pixelformat)
>> -			return &vimc_pix_map_list[i];
>> -	}
>> -	return NULL;
>> +	code->code = vimc_mbus_list[code->index];
>> +	return 0;
>>  }
>> -EXPORT_SYMBOL_GPL(vimc_pix_map_by_pixelformat);
>> +EXPORT_SYMBOL_GPL(vimc_enum_mbus_code);
>>  
>>  /* Helper function to allocate and initialize pads */
>>  struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pads_flag)
>> @@ -277,15 +224,13 @@ static int vimc_get_mbus_format(struct media_pad *pad,
>>  							 struct video_device,
>>  							 entity);
>>  		struct vimc_ent_device *ved = video_get_drvdata(vdev);
>> -		const struct vimc_pix_map *vpix;
>>  		struct v4l2_pix_format vdev_fmt;
>>  
>>  		if (!ved->vdev_get_format)
>>  			return -ENOIOCTLCMD;
>>  
>>  		ved->vdev_get_format(ved, &vdev_fmt);
>> -		vpix = vimc_pix_map_by_pixelformat(vdev_fmt.pixelformat);
>> -		v4l2_fill_mbus_format(&fmt->format, &vdev_fmt, vpix->code);
>> +		v4l2_fill_mbus_format(&fmt->format, &vdev_fmt, 0);
>>  	} else {
>>  		return -EINVAL;
>>  	}
>> @@ -325,8 +270,12 @@ int vimc_link_validate(struct media_link *link)
>>  	/* The width, height and code must match. */
>>  	if (source_fmt.format.width != sink_fmt.format.width
>>  	    || source_fmt.format.height != sink_fmt.format.height
>> -	    || source_fmt.format.code != sink_fmt.format.code)
>> +	    || (source_fmt.format.code && sink_fmt.format.code &&
>> +		source_fmt.format.code != sink_fmt.format.code)) {
>> +		pr_err("vimc: format doesn't match in link %s->%s\n",
>> +			link->source->entity->name, link->sink->entity->name);
>>  		return -EPIPE;
>> +	}
>>  
>>  	/*
>>  	 * The field order must match, or the sink field order must be NONE
>> diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
>> index 07987eab988f..98e5ffaf98fb 100644
>> --- a/drivers/media/platform/vimc/vimc-common.h
>> +++ b/drivers/media/platform/vimc/vimc-common.h
>> @@ -22,6 +22,8 @@
>>  #include <media/media-device.h>
>>  #include <media/v4l2-device.h>
>>  
>> +#include "vimc-streamer.h"
>> +
>>  #define VIMC_PDEV_NAME "vimc"
>>  
>>  /* VIMC-specific controls */
>> @@ -77,23 +79,6 @@ struct vimc_platform_data {
>>  	char entity_name[32];
>>  };
>>  
>> -/**
>> - * struct vimc_pix_map - maps media bus code with v4l2 pixel format
>> - *
>> - * @code:		media bus format code defined by MEDIA_BUS_FMT_* macros
>> - * @bbp:		number of bytes each pixel occupies
>> - * @pixelformat:	pixel format devined by V4L2_PIX_FMT_* macros
>> - *
>> - * Struct which matches the MEDIA_BUS_FMT_* codes with the corresponding
>> - * V4L2_PIX_FMT_* fourcc pixelformat and its bytes per pixel (bpp)
>> - */
>> -struct vimc_pix_map {
>> -	unsigned int code;
>> -	unsigned int bpp;
>> -	u32 pixelformat;
>> -	bool bayer;
>> -};
>> -
>>  /**
>>   * struct vimc_ent_device - core struct that represents a node in the topology
>>   *
>> @@ -115,12 +100,30 @@ struct vimc_pix_map {
>>  struct vimc_ent_device {
>>  	struct media_entity *ent;
>>  	struct media_pad *pads;
>> +	struct vimc_stream *stream;
>>  	void * (*process_frame)(struct vimc_ent_device *ved,
>>  				const void *frame);
>>  	void (*vdev_get_format)(struct vimc_ent_device *ved,
>>  			      struct v4l2_pix_format *fmt);
>>  };
>>  
>> +/**
>> + * vimc_mbus_code_supported - helper to check supported mbus codes
>> + *
>> + * Helper function to check if mbus code is enumerated by vimc_enum_mbus_code()
>> + */
>> +bool vimc_mbus_code_supported(__u32 code);
>> +
>> +/**
>> + * vimc_enum_mbus_code - enumerate mbus codes
>> + *
>> + * Helper function to be pluged in .enum_mbus_code from
>> + * struct v4l2_subdev_pad_ops.
>> + */
>> +int vimc_enum_mbus_code(struct v4l2_subdev *sd,
>> +			struct v4l2_subdev_pad_config *cfg,
>> +			struct v4l2_subdev_mbus_code_enum *code);
>> +
>>  /**
>>   * vimc_pads_init - initialize pads
>>   *
>> @@ -155,27 +158,6 @@ static inline void vimc_pads_cleanup(struct media_pad *pads)
>>   */
>>  int vimc_pipeline_s_stream(struct media_entity *ent, int enable);
>>  
>> -/**
>> - * vimc_pix_map_by_index - get vimc_pix_map struct by its index
>> - *
>> - * @i:			index of the vimc_pix_map struct in vimc_pix_map_list
>> - */
>> -const struct vimc_pix_map *vimc_pix_map_by_index(unsigned int i);
>> -
>> -/**
>> - * vimc_pix_map_by_code - get vimc_pix_map struct by media bus code
>> - *
>> - * @code:		media bus format code defined by MEDIA_BUS_FMT_* macros
>> - */
>> -const struct vimc_pix_map *vimc_pix_map_by_code(u32 code);
>> -
>> -/**
>> - * vimc_pix_map_by_pixelformat - get vimc_pix_map struct by v4l2 pixel format
>> - *
>> - * @pixelformat:	pixel format devined by V4L2_PIX_FMT_* macros
>> - */
>> -const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat);
>> -
>>  /**
>>   * vimc_ent_sd_register - initialize and register a subdev node
>>   *
>> diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
>> index 20826f209731..419ad57a4f5c 100644
>> --- a/drivers/media/platform/vimc/vimc-debayer.c
>> +++ b/drivers/media/platform/vimc/vimc-debayer.c
>> @@ -26,6 +26,9 @@
>>  #include "vimc-common.h"
>>  
>>  #define VIMC_DEB_DRV_NAME "vimc-debayer"
>> +/* This module only supports tranforming a bayer format to V4L2_PIX_FMT_RGB24 */
>> +#define VIMC_DEB_SRC_PIXFMT V4L2_PIX_FMT_RGB24
>> +#define VIMC_DEB_SRC_MBUS_FMT_DEFAULT MEDIA_BUS_FMT_RGB888_1X24
>>  
>>  static unsigned int deb_mean_win_size = 3;
>>  module_param(deb_mean_win_size, uint, 0000);
>> @@ -44,6 +47,7 @@ enum vimc_deb_rgb_colors {
>>  };
>>  
>>  struct vimc_deb_pix_map {
>> +	u32 pixelformat;
>>  	u32 code;
>>  	enum vimc_deb_rgb_colors order[2][2];
>>  };
>> @@ -73,61 +77,73 @@ static const struct v4l2_mbus_framefmt sink_fmt_default = {
>>  
>>  static const struct vimc_deb_pix_map vimc_deb_pix_map_list[] = {
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SBGGR8,
>>  		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
>>  		.order = { { VIMC_DEB_BLUE, VIMC_DEB_GREEN },
>>  			   { VIMC_DEB_GREEN, VIMC_DEB_RED } }
>>  	},
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SGBRG8,
>>  		.code = MEDIA_BUS_FMT_SGBRG8_1X8,
>>  		.order = { { VIMC_DEB_GREEN, VIMC_DEB_BLUE },
>>  			   { VIMC_DEB_RED, VIMC_DEB_GREEN } }
>>  	},
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SGRBG8,
>>  		.code = MEDIA_BUS_FMT_SGRBG8_1X8,
>>  		.order = { { VIMC_DEB_GREEN, VIMC_DEB_RED },
>>  			   { VIMC_DEB_BLUE, VIMC_DEB_GREEN } }
>>  	},
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SRGGB8,
>>  		.code = MEDIA_BUS_FMT_SRGGB8_1X8,
>>  		.order = { { VIMC_DEB_RED, VIMC_DEB_GREEN },
>>  			   { VIMC_DEB_GREEN, VIMC_DEB_BLUE } }
>>  	},
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SBGGR10,
>>  		.code = MEDIA_BUS_FMT_SBGGR10_1X10,
>>  		.order = { { VIMC_DEB_BLUE, VIMC_DEB_GREEN },
>>  			   { VIMC_DEB_GREEN, VIMC_DEB_RED } }
>>  	},
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SGBRG10,
>>  		.code = MEDIA_BUS_FMT_SGBRG10_1X10,
>>  		.order = { { VIMC_DEB_GREEN, VIMC_DEB_BLUE },
>>  			   { VIMC_DEB_RED, VIMC_DEB_GREEN } }
>>  	},
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SGRBG10,
>>  		.code = MEDIA_BUS_FMT_SGRBG10_1X10,
>>  		.order = { { VIMC_DEB_GREEN, VIMC_DEB_RED },
>>  			   { VIMC_DEB_BLUE, VIMC_DEB_GREEN } }
>>  	},
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SRGGB10,
>>  		.code = MEDIA_BUS_FMT_SRGGB10_1X10,
>>  		.order = { { VIMC_DEB_RED, VIMC_DEB_GREEN },
>>  			   { VIMC_DEB_GREEN, VIMC_DEB_BLUE } }
>>  	},
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SBGGR12,
>>  		.code = MEDIA_BUS_FMT_SBGGR12_1X12,
>>  		.order = { { VIMC_DEB_BLUE, VIMC_DEB_GREEN },
>>  			   { VIMC_DEB_GREEN, VIMC_DEB_RED } }
>>  	},
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SGBRG12,
>>  		.code = MEDIA_BUS_FMT_SGBRG12_1X12,
>>  		.order = { { VIMC_DEB_GREEN, VIMC_DEB_BLUE },
>>  			   { VIMC_DEB_RED, VIMC_DEB_GREEN } }
>>  	},
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SGRBG12,
>>  		.code = MEDIA_BUS_FMT_SGRBG12_1X12,
>>  		.order = { { VIMC_DEB_GREEN, VIMC_DEB_RED },
>>  			   { VIMC_DEB_BLUE, VIMC_DEB_GREEN } }
>>  	},
>>  	{
>> +		.pixelformat = V4L2_PIX_FMT_SRGGB12,
>>  		.code = MEDIA_BUS_FMT_SRGGB12_1X12,
>>  		.order = { { VIMC_DEB_RED, VIMC_DEB_GREEN },
>>  			   { VIMC_DEB_GREEN, VIMC_DEB_BLUE } }
>> @@ -168,41 +184,32 @@ static int vimc_deb_enum_mbus_code(struct v4l2_subdev *sd,
>>  				   struct v4l2_subdev_pad_config *cfg,
>>  				   struct v4l2_subdev_mbus_code_enum *code)
>>  {
>> -	/* We only support one format for source pads */
>> -	if (IS_SRC(code->pad)) {
>> -		struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
>> -
>> -		if (code->index)
>> -			return -EINVAL;
>> -
>> -		code->code = vdeb->src_code;
>> -	} else {
>> +	/* For the sink pad we only support codes in the map_list */
>> +	if (IS_SINK(code->pad)) {
>>  		if (code->index >= ARRAY_SIZE(vimc_deb_pix_map_list))
>>  			return -EINVAL;
>>  
>>  		code->code = vimc_deb_pix_map_list[code->index].code;
>> +		return 0;
>>  	}
>>  
>> -	return 0;
>> +	return vimc_enum_mbus_code(sd, cfg, code);
>>  }
>>  
>>  static int vimc_deb_enum_frame_size(struct v4l2_subdev *sd,
>>  				    struct v4l2_subdev_pad_config *cfg,
>>  				    struct v4l2_subdev_frame_size_enum *fse)
>>  {
>> -	struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
>> -
>>  	if (fse->index)
>>  		return -EINVAL;
>>  
>> +	/* For the sink pad we only support codes in the map_list */
>>  	if (IS_SINK(fse->pad)) {
>>  		const struct vimc_deb_pix_map *vpix =
>>  			vimc_deb_pix_map_by_code(fse->code);
>>  
>>  		if (!vpix)
>>  			return -EINVAL;
>> -	} else if (fse->code != vdeb->src_code) {
>> -		return -EINVAL;
>>  	}
>>  
>>  	fse->min_width = VIMC_FRAME_MIN_WIDTH;
>> @@ -258,6 +265,9 @@ static int vimc_deb_set_fmt(struct v4l2_subdev *sd,
>>  	struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
>>  	struct v4l2_mbus_framefmt *sink_fmt;
>>  
>> +	if (!vimc_mbus_code_supported(fmt->format.code))
>> +		fmt->format.code = sink_fmt_default.code;
>> +
>>  	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
>>  		/* Do not change the format while stream is on */
>>  		if (vdeb->src_frame)
>> @@ -270,11 +280,11 @@ static int vimc_deb_set_fmt(struct v4l2_subdev *sd,
>>  
>>  	/*
>>  	 * Do not change the format of the source pad,
>> -	 * it is propagated from the sink
>> +	 * it is propagated from the sink (except for the code)
>>  	 */
>>  	if (IS_SRC(fmt->pad)) {
>> +		vdeb->src_code = fmt->format.code;
>>  		fmt->format = *sink_fmt;
>> -		/* TODO: Add support for other formats */
>>  		fmt->format.code = vdeb->src_code;
>>  	} else {
>>  		/* Set the new format in the sink pad */
>> @@ -306,7 +316,7 @@ static const struct v4l2_subdev_pad_ops vimc_deb_pad_ops = {
>>  	.set_fmt		= vimc_deb_set_fmt,
>>  };
>>  
>> -static void vimc_deb_set_rgb_mbus_fmt_rgb888_1x24(struct vimc_deb_device *vdeb,
>> +static void vimc_deb_set_rgb_pix_rgb24(struct vimc_deb_device *vdeb,
>>  						  unsigned int lin,
>>  						  unsigned int col,
>>  						  unsigned int rgb[3])
>> @@ -323,25 +333,38 @@ static int vimc_deb_s_stream(struct v4l2_subdev *sd, int enable)
>>  	struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
>>  
>>  	if (enable) {
>> -		const struct vimc_pix_map *vpix;
>> +		u32 src_pixelformat = vdeb->ved.stream->producer_pixfmt;
>> +		const struct v4l2_format_info *pix_info;
>>  		unsigned int frame_size;
>>  
>>  		if (vdeb->src_frame)
>>  			return 0;
>>  
>> -		/* Calculate the frame size of the source pad */
>> -		vpix = vimc_pix_map_by_code(vdeb->src_code);
>> -		frame_size = vdeb->sink_fmt.width * vdeb->sink_fmt.height *
>> -				vpix->bpp;
>> -
>> -		/* Save the bytes per pixel of the sink */
>> -		vpix = vimc_pix_map_by_code(vdeb->sink_fmt.code);
>> -		vdeb->sink_bpp = vpix->bpp;
>> +		/* We only support translating bayer to RGB24 */
>> +		if (src_pixelformat != V4L2_PIX_FMT_RGB24) {
>> +			dev_err(vdeb->dev,
>> +				"translating to pixfmt (%s) is not supported\n",
>> +				v4l2_get_fourcc_name(src_pixelformat));
>> +			return -EINVAL;
>> +		}
>>  
>>  		/* Get the corresponding pixel map from the table */
>>  		vdeb->sink_pix_map =
>>  			vimc_deb_pix_map_by_code(vdeb->sink_fmt.code);
>>  
>> +		/* Request bayer format from the pipeline for the sink pad */
>> +		vdeb->ved.stream->producer_pixfmt =
>> +			vdeb->sink_pix_map->pixelformat;
>> +
>> +		/* Calculate frame_size of the source */
>> +		pix_info = v4l2_format_info(src_pixelformat);
>> +		frame_size = vdeb->sink_fmt.width * vdeb->sink_fmt.height *
>> +			     pix_info->bpp[0];
>> +
>> +		/* Get bpp from the sink */
>> +		pix_info = v4l2_format_info(vdeb->sink_pix_map->pixelformat);
>> +		vdeb->sink_bpp = pix_info->bpp[0];
>> +
>>  		/*
>>  		 * Allocate the frame buffer. Use vmalloc to be able to
>>  		 * allocate a large amount of memory
>> @@ -542,14 +565,14 @@ static int vimc_deb_comp_bind(struct device *comp, struct device *master,
>>  
>>  	/* Initialize the frame format */
>>  	vdeb->sink_fmt = sink_fmt_default;
>> +	vdeb->src_code = VIMC_DEB_SRC_MBUS_FMT_DEFAULT;
>>  	/*
>>  	 * TODO: Add support for more output formats, we only support
>> -	 * RGB888 for now
>> +	 * RGB24 for now.
>>  	 * NOTE: the src format is always the same as the sink, except
>>  	 * for the code
>>  	 */
>> -	vdeb->src_code = MEDIA_BUS_FMT_RGB888_1X24;
>> -	vdeb->set_rgb_src = vimc_deb_set_rgb_mbus_fmt_rgb888_1x24;
>> +	vdeb->set_rgb_src = vimc_deb_set_rgb_pix_rgb24;
>>  
>>  	return 0;
>>  }
>> diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
>> index 2028afa4ef7a..fbdd72b9303b 100644
>> --- a/drivers/media/platform/vimc/vimc-scaler.c
>> +++ b/drivers/media/platform/vimc/vimc-scaler.c
>> @@ -35,6 +35,12 @@ MODULE_PARM_DESC(sca_mult, " the image size multiplier");
>>  #define IS_SRC(pad)	(pad)
>>  #define MAX_ZOOM	8
>>  
>> +static const u32 vimc_sca_supported_pixftm[] = {
>> +	V4L2_PIX_FMT_BGR24,
>> +	V4L2_PIX_FMT_RGB24,
>> +	V4L2_PIX_FMT_ARGB32,
>> +};
>> +
>>  struct vimc_sca_device {
>>  	struct vimc_ent_device ved;
>>  	struct v4l2_subdev sd;
>> @@ -57,6 +63,16 @@ static const struct v4l2_mbus_framefmt sink_fmt_default = {
>>  	.colorspace = V4L2_COLORSPACE_DEFAULT,
>>  };
>>  
>> +static bool vimc_sca_is_pixfmt_supported(u32 pixelformat)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(vimc_sca_supported_pixftm); i++)
>> +		if (vimc_sca_supported_pixftm[i] == pixelformat)
>> +			return true;
>> +	return false;
>> +}
>> +
>>  static int vimc_sca_init_cfg(struct v4l2_subdev *sd,
>>  			     struct v4l2_subdev_pad_config *cfg)
>>  {
>> @@ -76,35 +92,13 @@ static int vimc_sca_init_cfg(struct v4l2_subdev *sd,
>>  	return 0;
>>  }
>>  
>> -static int vimc_sca_enum_mbus_code(struct v4l2_subdev *sd,
>> -				   struct v4l2_subdev_pad_config *cfg,
>> -				   struct v4l2_subdev_mbus_code_enum *code)
>> -{
>> -	const struct vimc_pix_map *vpix = vimc_pix_map_by_index(code->index);
>> -
>> -	/* We don't support bayer format */
>> -	if (!vpix || vpix->bayer)
>> -		return -EINVAL;
>> -
>> -	code->code = vpix->code;
>> -
>> -	return 0;
>> -}
>> -
>>  static int vimc_sca_enum_frame_size(struct v4l2_subdev *sd,
>>  				    struct v4l2_subdev_pad_config *cfg,
>>  				    struct v4l2_subdev_frame_size_enum *fse)
>>  {
>> -	const struct vimc_pix_map *vpix;
>> -
>>  	if (fse->index)
>>  		return -EINVAL;
>>  
>> -	/* Only accept code in the pix map table in non bayer format */
>> -	vpix = vimc_pix_map_by_code(fse->code);
>> -	if (!vpix || vpix->bayer)
>> -		return -EINVAL;
>> -
>>  	fse->min_width = VIMC_FRAME_MIN_WIDTH;
>>  	fse->min_height = VIMC_FRAME_MIN_HEIGHT;
>>  
>> @@ -141,13 +135,6 @@ static int vimc_sca_get_fmt(struct v4l2_subdev *sd,
>>  
>>  static void vimc_sca_adjust_sink_fmt(struct v4l2_mbus_framefmt *fmt)
>>  {
>> -	const struct vimc_pix_map *vpix;
>> -
>> -	/* Only accept code in the pix map table in non bayer format */
>> -	vpix = vimc_pix_map_by_code(fmt->code);
>> -	if (!vpix || vpix->bayer)
>> -		fmt->code = sink_fmt_default.code;
>> -
>>  	fmt->width = clamp_t(u32, fmt->width, VIMC_FRAME_MIN_WIDTH,
>>  			     VIMC_FRAME_MAX_WIDTH) & ~1;
>>  	fmt->height = clamp_t(u32, fmt->height, VIMC_FRAME_MIN_HEIGHT,
>> @@ -166,6 +153,9 @@ static int vimc_sca_set_fmt(struct v4l2_subdev *sd,
>>  	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
>>  	struct v4l2_mbus_framefmt *sink_fmt;
>>  
>> +	if (!vimc_mbus_code_supported(fmt->format.code))
>> +		fmt->format.code = sink_fmt_default.code;
>> +
>>  	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
>>  		/* Do not change the format while stream is on */
>>  		if (vsca->src_frame)
>> @@ -208,7 +198,7 @@ static int vimc_sca_set_fmt(struct v4l2_subdev *sd,
>>  
>>  static const struct v4l2_subdev_pad_ops vimc_sca_pad_ops = {
>>  	.init_cfg		= vimc_sca_init_cfg,
>> -	.enum_mbus_code		= vimc_sca_enum_mbus_code,
>> +	.enum_mbus_code		= vimc_enum_mbus_code,
>>  	.enum_frame_size	= vimc_sca_enum_frame_size,
>>  	.get_fmt		= vimc_sca_get_fmt,
>>  	.set_fmt		= vimc_sca_set_fmt,
>> @@ -219,15 +209,22 @@ static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
>>  	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
>>  
>>  	if (enable) {
>> -		const struct vimc_pix_map *vpix;
>> +		u32 pixelformat = vsca->ved.stream->producer_pixfmt;
>> +		const struct v4l2_format_info *pix_info;
>>  		unsigned int frame_size;
>>  
>>  		if (vsca->src_frame)
>>  			return 0;
>>  
>> +		if (!vimc_sca_is_pixfmt_supported(pixelformat)) {
>> +			dev_err(vsca->dev, "pixfmt (%s) is not supported\n",
>> +				v4l2_get_fourcc_name(pixelformat));
>> +			return -EINVAL;
>> +		}
>> +
>>  		/* Save the bytes per pixel of the sink */
>> -		vpix = vimc_pix_map_by_code(vsca->sink_fmt.code);
>> -		vsca->bpp = vpix->bpp;
>> +		pix_info = v4l2_format_info(pixelformat);
>> +		vsca->bpp = pix_info->bpp[0];
>>  
>>  		/* Calculate the width in bytes of the src frame */
>>  		vsca->src_line_size = vsca->sink_fmt.width *
>> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
>> index d7891d3bbeaa..081e54204c9f 100644
>> --- a/drivers/media/platform/vimc/vimc-sensor.c
>> +++ b/drivers/media/platform/vimc/vimc-sensor.c
>> @@ -65,34 +65,13 @@ static int vimc_sen_init_cfg(struct v4l2_subdev *sd,
>>  	return 0;
>>  }
>>  
>> -static int vimc_sen_enum_mbus_code(struct v4l2_subdev *sd,
>> -				   struct v4l2_subdev_pad_config *cfg,
>> -				   struct v4l2_subdev_mbus_code_enum *code)
>> -{
>> -	const struct vimc_pix_map *vpix = vimc_pix_map_by_index(code->index);
>> -
>> -	if (!vpix)
>> -		return -EINVAL;
>> -
>> -	code->code = vpix->code;
>> -
>> -	return 0;
>> -}
>> -
>>  static int vimc_sen_enum_frame_size(struct v4l2_subdev *sd,
>>  				    struct v4l2_subdev_pad_config *cfg,
>>  				    struct v4l2_subdev_frame_size_enum *fse)
>>  {
>> -	const struct vimc_pix_map *vpix;
>> -
>>  	if (fse->index)
>>  		return -EINVAL;
>>  
>> -	/* Only accept code in the pix map table */
>> -	vpix = vimc_pix_map_by_code(fse->code);
>> -	if (!vpix)
>> -		return -EINVAL;
>> -
>>  	fse->min_width = VIMC_FRAME_MIN_WIDTH;
>>  	fse->max_width = VIMC_FRAME_MAX_WIDTH;
>>  	fse->min_height = VIMC_FRAME_MIN_HEIGHT;
>> @@ -117,14 +96,17 @@ static int vimc_sen_get_fmt(struct v4l2_subdev *sd,
>>  
>>  static void vimc_sen_tpg_s_format(struct vimc_sen_device *vsen)
>>  {
>> -	const struct vimc_pix_map *vpix =
>> -				vimc_pix_map_by_code(vsen->mbus_format.code);
>> +	u32 pixelformat = vsen->ved.stream->producer_pixfmt;
>> +	const struct v4l2_format_info *pix_info;
>> +
>> +	pix_info = v4l2_format_info(pixelformat);
>>  
>>  	tpg_reset_source(&vsen->tpg, vsen->mbus_format.width,
>>  			 vsen->mbus_format.height, vsen->mbus_format.field);
>> -	tpg_s_bytesperline(&vsen->tpg, 0, vsen->mbus_format.width * vpix->bpp);
>> +	tpg_s_bytesperline(&vsen->tpg, 0,
>> +			   vsen->mbus_format.width * pix_info->bpp[0]);
>>  	tpg_s_buf_height(&vsen->tpg, vsen->mbus_format.height);
>> -	tpg_s_fourcc(&vsen->tpg, vpix->pixelformat);
>> +	tpg_s_fourcc(&vsen->tpg, pixelformat);
>>  	/* TODO: add support for V4L2_FIELD_ALTERNATE */
>>  	tpg_s_field(&vsen->tpg, vsen->mbus_format.field, false);
>>  	tpg_s_colorspace(&vsen->tpg, vsen->mbus_format.colorspace);
>> @@ -135,13 +117,6 @@ static void vimc_sen_tpg_s_format(struct vimc_sen_device *vsen)
>>  
>>  static void vimc_sen_adjust_fmt(struct v4l2_mbus_framefmt *fmt)
>>  {
>> -	const struct vimc_pix_map *vpix;
>> -
>> -	/* Only accept code in the pix map table */
>> -	vpix = vimc_pix_map_by_code(fmt->code);
>> -	if (!vpix)
>> -		fmt->code = fmt_default.code;
>> -
>>  	fmt->width = clamp_t(u32, fmt->width, VIMC_FRAME_MIN_WIDTH,
>>  			     VIMC_FRAME_MAX_WIDTH) & ~1;
>>  	fmt->height = clamp_t(u32, fmt->height, VIMC_FRAME_MIN_HEIGHT,
>> @@ -161,6 +136,9 @@ static int vimc_sen_set_fmt(struct v4l2_subdev *sd,
>>  	struct vimc_sen_device *vsen = v4l2_get_subdevdata(sd);
>>  	struct v4l2_mbus_framefmt *mf;
>>  
>> +	if (!vimc_mbus_code_supported(fmt->format.code))
>> +		fmt->format.code = fmt_default.code;
>> +
>>  	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
>>  		/* Do not change the format while stream is on */
>>  		if (vsen->frame)
>> @@ -193,7 +171,7 @@ static int vimc_sen_set_fmt(struct v4l2_subdev *sd,
>>  
>>  static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
>>  	.init_cfg		= vimc_sen_init_cfg,
>> -	.enum_mbus_code		= vimc_sen_enum_mbus_code,
>> +	.enum_mbus_code		= vimc_enum_mbus_code,
>>  	.enum_frame_size	= vimc_sen_enum_frame_size,
>>  	.get_fmt		= vimc_sen_get_fmt,
>>  	.set_fmt		= vimc_sen_set_fmt,
>> @@ -215,7 +193,8 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
>>  				container_of(sd, struct vimc_sen_device, sd);
>>  
>>  	if (enable) {
>> -		const struct vimc_pix_map *vpix;
>> +		u32 pixelformat = vsen->ved.stream->producer_pixfmt;
>> +		const struct v4l2_format_info *pix_info;
>>  		unsigned int frame_size;
>>  
>>  		if (vsen->kthread_sen)
>> @@ -223,8 +202,8 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
>>  			return 0;
>>  
>>  		/* Calculate the frame size */
>> -		vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
>> -		frame_size = vsen->mbus_format.width * vpix->bpp *
>> +		pix_info = v4l2_format_info(pixelformat);
>> +		frame_size = vsen->mbus_format.width * pix_info->bpp[0] *
>>  			     vsen->mbus_format.height;
>>  
>>  		/*
>> diff --git a/drivers/media/platform/vimc/vimc-streamer.c b/drivers/media/platform/vimc/vimc-streamer.c
>> index 5a3bda62fbc8..c19093b6c787 100644
>> --- a/drivers/media/platform/vimc/vimc-streamer.c
>> +++ b/drivers/media/platform/vimc/vimc-streamer.c
>> @@ -52,6 +52,7 @@ static void vimc_streamer_pipeline_terminate(struct vimc_stream *stream)
>>  	while (stream->pipe_size) {
>>  		stream->pipe_size--;
>>  		ved = stream->ved_pipeline[stream->pipe_size];
>> +		ved->stream = NULL;
>>  		stream->ved_pipeline[stream->pipe_size] = NULL;
>>  
>>  		if (!is_media_entity_v4l2_subdev(ved->ent))
>> @@ -87,6 +88,7 @@ static int vimc_streamer_pipeline_init(struct vimc_stream *stream,
>>  			return -EINVAL;
>>  		}
>>  		stream->ved_pipeline[stream->pipe_size++] = ved;
>> +		ved->stream = stream;
>>  
>>  		if (is_media_entity_v4l2_subdev(ved->ent)) {
>>  			sd = media_entity_to_v4l2_subdev(ved->ent);
>> diff --git a/drivers/media/platform/vimc/vimc-streamer.h b/drivers/media/platform/vimc/vimc-streamer.h
>> index a7c5ac5ace4f..2b3667408794 100644
>> --- a/drivers/media/platform/vimc/vimc-streamer.h
>> +++ b/drivers/media/platform/vimc/vimc-streamer.h
>> @@ -25,6 +25,11 @@
>>   * processed in the pipeline.
>>   * @pipe_size:		size of @ved_pipeline
>>   * @kthread:		thread that generates the frames of the stream.
>> + * @producer_pixfmt:	the pixel format requested from the pipeline. This must
>> + * be set just before calling vimc_streamer_s_stream(ent, 1). This value is
>> + * propagated up to the source of the base image (usually a sensor node) and
>> + * can be modified by entities during s_stream callback to request a different
>> + * format from rest of the pipeline.
>>   *
>>   * When the user call stream_on in a video device, struct vimc_stream is
>>   * used to keep track of all entities and subdevices that generates and
>> @@ -35,6 +40,7 @@ struct vimc_stream {
>>  	struct vimc_ent_device *ved_pipeline[VIMC_STREAMER_PIPELINE_MAX_SIZE];
>>  	unsigned int pipe_size;
>>  	struct task_struct *kthread;
>> +	u32 producer_pixfmt;
>>  };
>>  
>>  /**
>>
> 
> 
