Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:40454 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936563AbaBDXEo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 18:04:44 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so4695332eaj.35
        for <linux-media@vger.kernel.org>; Tue, 04 Feb 2014 15:04:42 -0800 (PST)
Message-ID: <52F17208.9010500@gmail.com>
Date: Wed, 05 Feb 2014 00:04:40 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Philipp Zabel <pza@pengutronix.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH] [media] uvcvideo: Enable VIDIOC_CREATE_BUFS
References: <1391012032-19600-1-git-send-email-p.zabel@pengutronix.de> <1474634.xnVfC2yuQa@avalon> <52EB6214.9030806@xs4all.nl> <3803281.g9jSrV8SES@avalon> <20140202130430.GA15734@pengutronix.de> <52EF5B6B.7030103@xs4all.nl>
In-Reply-To: <52EF5B6B.7030103@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/03/2014 10:03 AM, Hans Verkuil wrote:
> Hi Philipp, Laurent,
>
> On 02/02/2014 02:04 PM, Philipp Zabel wrote:
>> On Sun, Feb 02, 2014 at 11:21:13AM +0100, Laurent Pinchart wrote:
>>> Hi Hans,
>>>
>>> On Friday 31 January 2014 09:43:00 Hans Verkuil wrote:
>>>> I think you might want to add a check in uvc_queue_setup to verify the
>>>> fmt that create_bufs passes. The spec says that: "Unsupported formats
>>>> will result in an error". In this case I guess that the format basically
>>>> should match the current selected format.
>>>>
>>>> I'm unhappy with the current implementations of create_bufs (see also this
>>>> patch:
>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg70796.html).
>>>>
>>>> Nobody is actually checking the format today, which isn't good.
>>>>
>>>> The fact that the spec says that the fmt field isn't changed by the driver
>>>> isn't helping as it invalidated my patch from above, although that can be
>>>> fixed.
>>>>
>>>> I need to think about this some more, but for this particular case you can
>>>> just do a memcmp of the v4l2_pix_format against the currently selected
>>>> format and return an error if they differ. Unless you want to support
>>>> different buffer sizes as well?
>>>
>>> Isn't the whole point of VIDIOC_CREATE_BUFS being able to create buffers of
>>> different resolutions than the current active resolution ?
>
> Or just additional buffers with the same resolution (or really, the same size).
>
>> For that to work the driver in question would need to keep track of per-buffer
>> format and resolution, and not only of per-queue format and resolution.
>>
>> For now, would something like the following be enough? Unfortunately the uvc
>> driver doesn't keep a v4l2_format around that we could just memcmp against:
>>
>> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
>> index fa58131..7fa469b 100644
>> --- a/drivers/media/usb/uvc/uvc_v4l2.c
>> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
>> @@ -1003,10 +1003,26 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>>   	case VIDIOC_CREATE_BUFS:
>>   	{
>>   		struct v4l2_create_buffers *cb = arg;
>> +		struct v4l2_pix_format *pix;
>> +		struct uvc_format *format;
>> +		struct uvc_frame *frame;
>>
>>   		if (!uvc_has_privileges(handle))
>>   			return -EBUSY;
>>
>> +		format = stream->cur_format;
>> +		frame = stream->cur_frame;
>> +		pix =&cb->format.fmt.pix;
>> +
>> +		if (pix->pixelformat != format->fcc ||
>> +		    pix->width != frame->wWidth ||
>> +		    pix->height != frame->wHeight ||
>> +		    pix->field != V4L2_FIELD_NONE ||
>> +		    pix->bytesperline != format->bpp * frame->wWidth / 8 ||
>> +		    pix->sizeimage != stream->ctrl.dwMaxVideoFrameSize ||
>> +		    pix->colorspace != format->colorspace)
>
> I would drop the field and colorspace checks (those do not really affect
> any size calculations), other than that it looks good.

That seems completely wrong to me, AFAICT the VIDIOC_CREATE_BUFS was 
designed
so that the driver is supposed to allow any format which is supported by the
hardware.
What has currently selected format to do with the format passed to
VIDIOC_CREATE_BUFS ? It should be allowed to create buffers of any size
(implied by the passed v4l2_pix_format). It is supposed to be checked if
a buffer meets constraints of current configuration of
the hardware at QBUF, not at VIDIOC_CREATE_BUFS time. User space may well
allocate buffers when one image format is set, keep them aside and then
just before queueing them to the driver may set the format to a different
one, so the hardware set up matches buffers allocated with 
VIDIOC_CREATE_BUFS.

What's the point of having VIDIOC_CREATE_BUFS when you are doing checks
like above ? Unless I'm missing something that is completely wrong. :)
Adjusting cb->format.fmt.pix as in VIDIOC_TRY_FORMAT seems more appropriate
thing to do.

Thanks,
Sylwester
