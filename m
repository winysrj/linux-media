Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38001 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3BDPDZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 10:03:25 -0500
Received: by mail-ie0-f173.google.com with SMTP id 9so5815490iec.4
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2013 07:03:24 -0800 (PST)
Message-ID: <51108564.8090609@gmail.com>
Date: Mon, 04 Feb 2013 23:07:00 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 08/18] tlg2300: fix radio querycap
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <e745ec830817f4eab48445b0e205a7b568a0e2b0.1359627298.git.hans.verkuil@cisco.com> <510F3AE8.3080205@gmail.com> <201302040938.17407.hverkuil@xs4all.nl>
In-Reply-To: <201302040938.17407.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=gb18030; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年02月04日 03:38, Hans Verkuil 写道:
> On Mon February 4 2013 05:36:56 Huang Shijie wrote:
>> 于 2013年01月31日 05:25, Hans Verkuil 写道:
>>> From: Hans Verkuil<hans.verkuil@cisco.com>
>>>
>>> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
>>> ---
>>>   drivers/media/usb/tlg2300/pd-radio.c |    7 ++++++-
>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
>>> index 854ffa0..80307d3 100644
>>> --- a/drivers/media/usb/tlg2300/pd-radio.c
>>> +++ b/drivers/media/usb/tlg2300/pd-radio.c
>>> @@ -147,7 +147,12 @@ static int vidioc_querycap(struct file *file, void *priv,
>>>   	strlcpy(v->driver, "tele-radio", sizeof(v->driver));
>>>   	strlcpy(v->card, "Telegent Poseidon", sizeof(v->card));
>>>   	usb_make_path(p->udev, v->bus_info, sizeof(v->bus_info));
>>> -	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
>>> +	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
>>> +	/* Report all capabilities of the USB device */
>>> +	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS |
>>> +			V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VBI_CAPTURE |
>> why add these video/vbi capabilities?
> The capabilities field contains the V4L2 capabilities of the whole device
> (i.e. radio+video+vbi), the device_caps field contains the capabilities of
> just that node.
>
> In the past different drivers interpreted the capabilities field differently:
> either with the capabilities of the whole device or the capabilities of just
> that device node. This situation was clarified recently and the device_caps
> field was added instead so both the caps for the full device and the current
> device node are now available.
>
> This wasn't there when the tlg2300 driver was developed, and the spec was
> never clear enough regarding the meaning of the capabilities field.
>
> So this is a later improvement to the V4L2 API.


thanks for the explanation.

Acked-by: Huang Shijie <shijie8@gmail.com>


> Regards,
>
> 	Hans
>
>>> +			V4L2_CAP_AUDIO | V4L2_CAP_STREAMING
>>> +			V4L2_CAP_READWRITE;
>>>   	return 0;
>>>   }
>>>

