Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37427 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3ASTN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 14:13:27 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so2304345eei.35
        for <linux-media@vger.kernel.org>; Sat, 19 Jan 2013 11:13:26 -0800 (PST)
Message-ID: <50FAF07A.2050401@googlemail.com>
Date: Sat, 19 Jan 2013 20:14:02 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: return -ENOTTY for tuner + frequency ioctls if
 the device has no tuner
References: <1358081450-5705-1-git-send-email-fschaefer.oss@googlemail.com> <201301160931.11802.hverkuil@xs4all.nl> <50F982E2.8050108@googlemail.com> <201301182001.16704.hverkuil@xs4all.nl>
In-Reply-To: <201301182001.16704.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.01.2013 20:01, schrieb Hans Verkuil:
> On Fri January 18 2013 18:14:10 Frank Schäfer wrote:
>> Am 16.01.2013 09:31, schrieb Hans Verkuil:
>>> On Tue 15 January 2013 18:06:57 Frank Schäfer wrote:
>>>> Am 14.01.2013 10:20, schrieb Hans Verkuil:
>>>>> On Sun January 13 2013 13:50:50 Frank Schäfer wrote:
>>>>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>>>>> ---
>>>>>>  drivers/media/usb/em28xx/em28xx-video.c |    8 ++++++++
>>>>>>  1 Datei geändert, 8 Zeilen hinzugefügt(+)
>>>>>>
>>>>>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
>>>>>> index 2eabf2a..4a7f73c 100644
>>>>>> --- a/drivers/media/usb/em28xx/em28xx-video.c
>>>>>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
>>>>>> @@ -1204,6 +1204,8 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>>>>>>  	struct em28xx         *dev = fh->dev;
>>>>>>  	int                   rc;
>>>>>>  
>>>>>> +	if (dev->tuner_type == TUNER_ABSENT)
>>>>>> +		return -ENOTTY;
>>>>>>  	rc = check_dev(dev);
>>>>>>  	if (rc < 0)
>>>>>>  		return rc;
>>>>>> @@ -1224,6 +1226,8 @@ static int vidioc_s_tuner(struct file *file, void *priv,
>>>>>>  	struct em28xx         *dev = fh->dev;
>>>>>>  	int                   rc;
>>>>>>  
>>>>>> +	if (dev->tuner_type == TUNER_ABSENT)
>>>>>> +		return -ENOTTY;
>>>>>>  	rc = check_dev(dev);
>>>>>>  	if (rc < 0)
>>>>>>  		return rc;
>>>>>> @@ -1241,6 +1245,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>>>>>>  	struct em28xx_fh      *fh  = priv;
>>>>>>  	struct em28xx         *dev = fh->dev;
>>>>>>  
>>>>>> +	if (dev->tuner_type == TUNER_ABSENT)
>>>>>> +		return -ENOTTY;
>>>>>>  	if (0 != f->tuner)
>>>>>>  		return -EINVAL;
>>>>>>  
>>>>>> @@ -1255,6 +1261,8 @@ static int vidioc_s_frequency(struct file *file, void *priv,
>>>>>>  	struct em28xx         *dev = fh->dev;
>>>>>>  	int                   rc;
>>>>>>  
>>>>>> +	if (dev->tuner_type == TUNER_ABSENT)
>>>>>> +		return -ENOTTY;
>>>>>>  	rc = check_dev(dev);
>>>>>>  	if (rc < 0)
>>>>>>  		return rc;
>>>>>>
>>>>> Rather than doing this in each ioctl, I recommend using v4l2_disable_ioctl
>>>>> instead. See for example drivers/media/pci/ivtv/ivtv-streams.c.
>>>> Hmm, thanks.
>>>> I just did the same we currently do for the VIDIOC_G/S/QUERY_STD and
>>>> VIDIOC_G/S_AUDIO ioctls, but yeah, disabling seems to be better.
>>>> Btw, what about VIDIOC_G/S_PARAM ? Do they make sense for cameras ?
>>> Absolutely. Actually, s_parm should be disabled in the non-camera case
>>> since s_parm only makes sense for webcams.
>> Sorry for the delay, I wanted to take a deeper look into the API spec
>> first...
>>
>> Actually... why do you think VIDIOC_S/G_PARM should be disabled for
>> non-camera devices ?
> I didn't say that: only S_PARM makes generally no sense for non-camera
> devices since the fps can't be changed (G/S_PARM are very ugly ioctls,
> but that's another story).

Ok, that's how I've understood the spec, too.
The only exception for which S_PARM would make sense for non-camera
devices seems to be drivers that support selecting the number of
internally used buffers.

>
>> At least G_PARM seems to make sense, because frame interval and the
>> number of buffers can always be reported.
>>
>> Two further questions that came up while reading the spec and the driver
>> code:
>> 1) Which ioctls can VBI devices have ? I'm thinking about
>> VIDIOC_G/S_TUNER, VIDIOC_G/S_FREQUENCY, VIDIOC_G/S/QUERY_STD,
>> VIDIOC_G/S_PARM.
> Correct, except for S_PARM.
>
>> 2) Are VIDIOC_G/S_AUDIO generally suitable or even mandatory for radio
>> devices ?
> Those should not be used for radio devices.
>
>> 3) Supporting VIDIOC_CROPCAP without VIDIOC_G/S_CROP doesn't make sense,
>> right ?
> Correct. The spec says that CROPCAP is a mandatory ioctl, but that was never
> enforced and I believe that we decided during the last media summit to correct
> this in the spec (which hasn't happened yet).

Ah, ok, thanks.

The spec seems to be up-to-date:
"This ioctl must be implemented for video capture or output devices that
support cropping and/or scaling and/or have non-square pixels, and for
overlay devices."

>
>> Do you know if G/S_CROP has ever been supported by the em28xx
>> driver ?
> I faintly remember seeing code for this at one time, but I may be wrong. If
> some patches were posted, then it was a long time ago.

Hmmm... must have been even before 2.6.27.

> BTW, you are aware of the v4l2-compliance tool? I can't remember if I ever
> mentioned it to you. It's part of v4l-utils and tests driver compliance with
> the V4L2 API.

Yes, I heard about it but never used it up to now. It seems like this is
a good reason to test it. :)

I will try to send a patch series that fixes the remaining em28xx ioctl
issues tomorrow.
I wouldn't wonder if further questions arise, please be patient with me. ;)

Regards,
Frank

