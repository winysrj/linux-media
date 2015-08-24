Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:24570 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751079AbbHXKbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 06:31:22 -0400
Subject: Re: [PATCH v3 3/3] media: atmel-isi: add sanity check for supported
 formats in try/set_fmt()
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1440144494-11800-1-git-send-email-josh.wu@atmel.com>
 <1440144494-11800-3-git-send-email-josh.wu@atmel.com>
 <30646920.vM5hNRm83J@avalon>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
From: Josh Wu <josh.wu@atmel.com>
Message-ID: <55DAF263.7070109@atmel.com>
Date: Mon, 24 Aug 2015 18:30:59 +0800
MIME-Version: 1.0
In-Reply-To: <30646920.vM5hNRm83J@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

On 8/22/2015 2:22 AM, Laurent Pinchart wrote:
> Hi Josh,
>
> Thank you for the patch.
>
> On Friday 21 August 2015 16:08:14 Josh Wu wrote:
>> After adding the format check in try_fmt()/set_fmt(), we don't need any
>> format check in configure_geometry(). So make configure_geometry() as
>> void type.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>
>> Changes in v3:
>> - check the whether format is supported, if no then return a default
>>    format.
>> - misc changes according to Laurent's feedback.
>>
>> Changes in v2:
>> - new added patch
>>
>>   drivers/media/platform/soc_camera/atmel-isi.c | 37 ++++++++++++++++++------
>>   1 file changed, 29 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
>> b/drivers/media/platform/soc_camera/atmel-isi.c index fe9247a..84c91d3
>> 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>> @@ -102,17 +102,19 @@ static u32 isi_readl(struct atmel_isi *isi, u32 reg)
>>   	return readl(isi->regs + reg);
>>   }
>>
>> -static int configure_geometry(struct atmel_isi *isi, u32 width,
>> +static void configure_geometry(struct atmel_isi *isi, u32 width,
>>   			u32 height, u32 code)
>>   {
>>   	u32 cfg2;
>>
>>   	/* According to sensor's output format to set cfg2 */
>>   	switch (code) {
>> -	/* YUV, including grey */
>> +	default:
>> +	/* Grey */
>>   	case MEDIA_BUS_FMT_Y8_1X8:
>>   		cfg2 = ISI_CFG2_GRAYSCALE;
>>   		break;
>> +	/* YUV */
>>   	case MEDIA_BUS_FMT_VYUY8_2X8:
>>   		cfg2 = ISI_CFG2_YCC_SWAP_MODE_3;
>>   		break;
>> @@ -126,8 +128,6 @@ static int configure_geometry(struct atmel_isi *isi, u32
>> width, cfg2 = ISI_CFG2_YCC_SWAP_DEFAULT;
>>   		break;
>>   	/* RGB, TODO */
>> -	default:
>> -		return -EINVAL;
>>   	}
>>
>>   	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>> @@ -138,8 +138,23 @@ static int configure_geometry(struct atmel_isi *isi,
>> u32 width, cfg2 |= ((height - 1) << ISI_CFG2_IM_VSIZE_OFFSET)
>>   			& ISI_CFG2_IM_VSIZE_MASK;
>>   	isi_writel(isi, ISI_CFG2, cfg2);
>> +}
>>
>> -	return 0;
>> +static bool is_supported(struct soc_camera_device *icd,
>> +		const u32 pixformat)
>> +{
>> +	switch (pixformat) {
>> +	/* YUV, including grey */
>> +	case V4L2_PIX_FMT_GREY:
>> +	case V4L2_PIX_FMT_YUYV:
>> +	case V4L2_PIX_FMT_UYVY:
>> +	case V4L2_PIX_FMT_YVYU:
>> +	case V4L2_PIX_FMT_VYUY:
>> +		return true;
>> +	/* RGB, TODO */
>> +	default:
>> +		return false;
>> +	}
>>   }
>>
>>   static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
>> @@ -390,10 +405,8 @@ static int start_streaming(struct vb2_queue *vq,
>> unsigned int count) /* Disable all interrupts */
>>   	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
>>
>> -	ret = configure_geometry(isi, icd->user_width, icd->user_height,
>> +	configure_geometry(isi, icd->user_width, icd->user_height,
>>   				icd->current_fmt->code);
>> -	if (ret < 0)
>> -		return ret;
>>
>>   	spin_lock_irq(&isi->lock);
>>   	/* Clear any pending interrupt */
>> @@ -491,6 +504,10 @@ static int isi_camera_set_fmt(struct soc_camera_device
>> *icd, struct v4l2_mbus_framefmt *mf = &format.format;
>>   	int ret;
>>
>> +	/* check with atmel-isi support format, if not support use UYVY */
>> +	if (!is_supported(icd, pix->pixelformat))
>> +		pix->pixelformat = V4L2_PIX_FMT_YUYV;
> The comment mentions UYVY and the code uses YUYV.

Oops, forgotten to change the comments. I'll fix it.
>
>> +
>>   	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
>>   	if (!xlate) {
>>   		dev_warn(icd->parent, "Format %x not found\n",
> Can this still happen ?

I think this warning should not happen if user call set_fmt() with the 
format that get from by get_formats().
But it is a common pattern in soc_camera host code to handle this error.

>
>> @@ -540,6 +557,10 @@ static int isi_camera_try_fmt(struct soc_camera_device
>> *icd, u32 pixfmt = pix->pixelformat;
>>   	int ret;
>>
>> +	/* check with atmel-isi support format, if not support use UYVY */
>> +	if (!is_supported(icd, pix->pixelformat))
>> +		pix->pixelformat = V4L2_PIX_FMT_YUYV;
>> +
>>   	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>>   	if (pixfmt && !xlate) {
>>   		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
> Same comment here.
>
> I wonder whether most of the content of isi_camera_set_fmt() and
> isi_camera_try_fmt() could be factorized out into a shared function.

I agree. the current set_fmt() doesn't touch any hardware, so it's 
almost same as try_fmt().

Best Regards,
Josh Wu
>

