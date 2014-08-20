Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4479 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaHTCHW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Aug 2014 22:07:22 -0400
Message-ID: <53F402BE.2010206@xs4all.nl>
Date: Wed, 20 Aug 2014 02:06:54 +0000
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
CC: linux-usb@vger.kernel.org, balbi@ti.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [PATCH v2 2/3] usb: gadget/uvc: also handle v4l2 ioctl ENUM_FMT
References: <1407512339-8433-1-git-send-email-m.grzeschik@pengutronix.de> <1407512339-8433-3-git-send-email-m.grzeschik@pengutronix.de> <2635639.TQ5HekBxN8@avalon>
In-Reply-To: <2635639.TQ5HekBxN8@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2014 05:01 PM, Laurent Pinchart wrote:
> Hi Michael,
> 
> Thank you for the patch.
> 
> (CC'ing Hans Verkuil and the linux-media mailing list)
> 
> On Friday 08 August 2014 17:38:58 Michael Grzeschik wrote:
>> This patch adds ENUM_FMT as possible ioctl to the uvc v4l2 device.
>> That makes userspace applications with a generic IOCTL calling
>> convention make also use of it.
>>
>> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
>> ---
>> v1 -> v2:
>>  - changed first switch case to simple if
>>  - added separate function
>>  - added description field
>>  - bail out on array boundaries
>>
>>  drivers/usb/gadget/uvc_v4l2.c | 30 ++++++++++++++++++++++++++++--
>>  1 file changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
>> index ad48e81..58633bf 100644
>> --- a/drivers/usb/gadget/uvc_v4l2.c
>> +++ b/drivers/usb/gadget/uvc_v4l2.c
>> @@ -55,14 +55,30 @@ struct uvc_format
>>  {
>>  	u8 bpp;
>>  	u32 fcc;
>> +	char *description;
>>  };
>>
>>  static struct uvc_format uvc_formats[] = {
>> -	{ 16, V4L2_PIX_FMT_YUYV  },
>> -	{ 0,  V4L2_PIX_FMT_MJPEG },
>> +	{ 16, V4L2_PIX_FMT_YUYV, "YUV 4:2:2" },
>> +	{ 0,  V4L2_PIX_FMT_MJPEG, "MJPEG" },
> 
> Format descriptions are currently duplicated in every driver, causing higher 
> memory usage and different descriptions for the same format depending on the 
> driver. Hans, should we try to fix this ?

Yes, we should. It's been on my todo list for ages, but at a very low priority.
I'm not planning to work on this in the near future, but if someone else wants
to work on this, then just go ahead.

Regards,

	Hans

> 
>>  };
>>
>>  static int
>> +uvc_v4l2_enum_format(struct uvc_video *video, struct v4l2_fmtdesc *fmt)
>> +{
>> +
> 
> There's an extra blank line here.
> 
>> +	int index = fmt->index;
> 
> You can use fmt->index directly below, there's no need for a local variable.
> 
>> +	if (index >= ARRAY_SIZE(uvc_formats))
>> +		return -EINVAL;
>> +
>> +	strcpy(fmt->description, uvc_formats[index].description);
> 
> How about strlcpy to make sure we don't overflow the buffer ?
> 
>> +	fmt->pixelformat = uvc_formats[index].fcc;
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>>  uvc_v4l2_get_format(struct uvc_video *video, struct v4l2_format *fmt)
>>  {
>>  	fmt->fmt.pix.pixelformat = video->fcc;
>> @@ -183,6 +199,16 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd,
>> void *arg) break;
>>  	}
>>
>> +	case VIDIOC_ENUM_FMT:
>> +	{
>> +		struct v4l2_fmtdesc *fmt = arg;
>> +
>> +		if (fmt->type != video->queue.queue.type)
>> +			return -EINVAL;
>> +
>> +		return uvc_v4l2_enum_format(video, fmt);
>> +	}
>> +
>>  	/* Get & Set format */
>>  	case VIDIOC_G_FMT:
> 

