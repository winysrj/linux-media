Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3103 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaBEH6R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 02:58:17 -0500
Message-ID: <52F1EEDA.6040700@xs4all.nl>
Date: Wed, 05 Feb 2014 08:57:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Philipp Zabel <pza@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH] [media] uvcvideo: Enable VIDIOC_CREATE_BUFS
References: <1391012032-19600-1-git-send-email-p.zabel@pengutronix.de> <1474634.xnVfC2yuQa@avalon> <52EB6214.9030806@xs4all.nl> <3803281.g9jSrV8SES@avalon> <20140202130430.GA15734@pengutronix.de> <52EF5B6B.7030103@xs4all.nl> <52F17208.9010500@gmail.com>
In-Reply-To: <52F17208.9010500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2014 12:04 AM, Sylwester Nawrocki wrote:
> Hi,
> 
> On 02/03/2014 10:03 AM, Hans Verkuil wrote:
>> Hi Philipp, Laurent,
>>
>> On 02/02/2014 02:04 PM, Philipp Zabel wrote:
>>> On Sun, Feb 02, 2014 at 11:21:13AM +0100, Laurent Pinchart wrote:
>>>> Hi Hans,
>>>>
>>>> On Friday 31 January 2014 09:43:00 Hans Verkuil wrote:
>>>>> I think you might want to add a check in uvc_queue_setup to verify the
>>>>> fmt that create_bufs passes. The spec says that: "Unsupported formats
>>>>> will result in an error". In this case I guess that the format basically
>>>>> should match the current selected format.
>>>>>
>>>>> I'm unhappy with the current implementations of create_bufs (see also this
>>>>> patch:
>>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg70796.html).
>>>>>
>>>>> Nobody is actually checking the format today, which isn't good.
>>>>>
>>>>> The fact that the spec says that the fmt field isn't changed by the driver
>>>>> isn't helping as it invalidated my patch from above, although that can be
>>>>> fixed.
>>>>>
>>>>> I need to think about this some more, but for this particular case you can
>>>>> just do a memcmp of the v4l2_pix_format against the currently selected
>>>>> format and return an error if they differ. Unless you want to support
>>>>> different buffer sizes as well?
>>>>
>>>> Isn't the whole point of VIDIOC_CREATE_BUFS being able to create buffers of
>>>> different resolutions than the current active resolution ?
>>
>> Or just additional buffers with the same resolution (or really, the same size).
>>
>>> For that to work the driver in question would need to keep track of per-buffer
>>> format and resolution, and not only of per-queue format and resolution.
>>>
>>> For now, would something like the following be enough? Unfortunately the uvc
>>> driver doesn't keep a v4l2_format around that we could just memcmp against:
>>>
>>> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
>>> index fa58131..7fa469b 100644
>>> --- a/drivers/media/usb/uvc/uvc_v4l2.c
>>> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
>>> @@ -1003,10 +1003,26 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>>>   	case VIDIOC_CREATE_BUFS:
>>>   	{
>>>   		struct v4l2_create_buffers *cb = arg;
>>> +		struct v4l2_pix_format *pix;
>>> +		struct uvc_format *format;
>>> +		struct uvc_frame *frame;
>>>
>>>   		if (!uvc_has_privileges(handle))
>>>   			return -EBUSY;
>>>
>>> +		format = stream->cur_format;
>>> +		frame = stream->cur_frame;
>>> +		pix =&cb->format.fmt.pix;
>>> +
>>> +		if (pix->pixelformat != format->fcc ||
>>> +		    pix->width != frame->wWidth ||
>>> +		    pix->height != frame->wHeight ||
>>> +		    pix->field != V4L2_FIELD_NONE ||
>>> +		    pix->bytesperline != format->bpp * frame->wWidth / 8 ||
>>> +		    pix->sizeimage != stream->ctrl.dwMaxVideoFrameSize ||
>>> +		    pix->colorspace != format->colorspace)
>>
>> I would drop the field and colorspace checks (those do not really affect
>> any size calculations), other than that it looks good.
> 
> That seems completely wrong to me, AFAICT the VIDIOC_CREATE_BUFS was 
> designed
> so that the driver is supposed to allow any format which is supported by the
> hardware.
> What has currently selected format to do with the format passed to
> VIDIOC_CREATE_BUFS ? It should be allowed to create buffers of any size
> (implied by the passed v4l2_pix_format). It is supposed to be checked if
> a buffer meets constraints of current configuration of
> the hardware at QBUF, not at VIDIOC_CREATE_BUFS time. User space may well
> allocate buffers when one image format is set, keep them aside and then
> just before queueing them to the driver may set the format to a different
> one, so the hardware set up matches buffers allocated with 
> VIDIOC_CREATE_BUFS.
> 
> What's the point of having VIDIOC_CREATE_BUFS when you are doing checks
> like above ? Unless I'm missing something that is completely wrong. :)
> Adjusting cb->format.fmt.pix as in VIDIOC_TRY_FORMAT seems more appropriate
> thing to do.

OK, I agree that the code above is wrong. So ignore that.

What should CREATE_BUFS do when it is called?

Should I go back to this patch: http://www.spinics.net/lists/linux-media/msg72171.html

It will at least ensure that the fmt is consistent. It is however not quite
according to the spec since invalid formats are generally 'reformatted' by
TRY_FMT to something valid, and the spec says invalid formats should return
an error. It is possible to do something more advanced here, though: you
could make a copy of v4l2_format, call TRY_FMT on it, and check if there
are any differences with what was passed in. If there are, return an
error.

It's a bit of work, but probably better to do it in the core rather than
depend on drivers to do it (since they won't :-) ).

If queue_setup can rely on fmt to be a valid format, then sizeimage can
just be used as the buffer size.

With regards to checking constraints on QBUF: I see a problem there. For
a regular buffer it can be checked in buf_prepare, but what if a buffer
is already prepared using VIDIOC_PREPARE_BUF, then the format is changed
and you call VIDIOC_QBUF with that prepared buffer? Then there is no
callback where you can check this since the buf_prepare call has already
happened.

Regards,

	Hans
