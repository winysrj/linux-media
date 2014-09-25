Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:50909 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaIYOZS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 10:25:18 -0400
Received: by mail-lb0-f170.google.com with SMTP id n15so996852lbi.15
        for <linux-media@vger.kernel.org>; Thu, 25 Sep 2014 07:25:16 -0700 (PDT)
Message-ID: <54242629.6040208@googlemail.com>
Date: Thu, 25 Sep 2014 16:26:49 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] em28xx: fix VBI handling logic
References: <c3e1b2c823189385494c01a7c776700f0e8d5913.1411142521.git.mchehab@osg.samsung.com>	<8444ab3f16a454ab8d2eaefb8990193313c2ac33.1411142521.git.mchehab@osg.samsung.com>	<5421CAB2.3030804@googlemail.com>	<20140923201838.48cddea1@recife.lan>	<54241FB0.3000904@googlemail.com> <20140925110712.31795d6b@recife.lan>
In-Reply-To: <20140925110712.31795d6b@recife.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Resending because my crappy modem crashed while sending)

Am 25.09.2014 um 16:07 schrieb Mauro Carvalho Chehab:
> Em Thu, 25 Sep 2014 15:59:12 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 24.09.2014 um 01:18 schrieb Mauro Carvalho Chehab:
>>> Em Tue, 23 Sep 2014 21:32:02 +0200
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>> Am 19.09.2014 um 18:02 schrieb Mauro Carvalho Chehab:
>>>>> When both VBI and video are streaming, and video stream is stopped,
>>>>> a subsequent trial to restart it will fail, because S_FMT will
>>>>> return -EBUSY.
>>>>>
>>>>> That prevents applications like zvbi to work properly.
>>>>>
>>>>> Please notice that, while this fix it fully for zvbi, the
>>>>> best is to get rid of streaming_users and res_get logic as a hole.
>>>>>
>>>>> However, this single-line patch is better to be merged at -stable.
>>>>>
>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>>
>>>>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
>>>>> index 08569cbccd95..d75e7f82dfb9 100644
>>>>> --- a/drivers/media/usb/em28xx/em28xx-video.c
>>>>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
>>>>> @@ -1351,7 +1351,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>>>>>  	struct em28xx *dev = video_drvdata(file);
>>>>>  	struct em28xx_v4l2 *v4l2 = dev->v4l2;
>>>>>  
>>>>> -	if (v4l2->streaming_users > 0)
>>>>> +	if (vb2_is_busy(&v4l2->vb_vidq))
>>>> Looks dangerous.
>>> Why Dangerous? 
>> You are an experienced kernel developer. If you still fail to see that
>> after so many years, sorry, I can't help you.
>>
>>> Did you identify any problem?
>> Yes I've identified a potential problem.
>> Read it again, it's in the line you skipped in this reply.
> Did you read the video_ioctl_ops struct?
>
> See:
>
> 	.vidioc_g_fmt_vid_cap       = vidioc_g_fmt_vid_cap,
> 	.vidioc_try_fmt_vid_cap     = vidioc_try_fmt_vid_cap,
> 	.vidioc_s_fmt_vid_cap       = vidioc_s_fmt_vid_cap,
> 	.vidioc_g_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
> 	.vidioc_try_fmt_vbi_cap     = vidioc_g_fmt_vbi_cap,
> 	.vidioc_s_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
> 	.vidioc_enum_framesizes     = vidioc_enum_framesizes,
> 	.vidioc_g_audio             = vidioc_g_audio,
> 	.vidioc_s_audio             = vidioc_s_audio,
>
> Only the video node calls s_fmt_vid_cap. There's nothing to be
> set for VBI. In other words, a call to VIDIOC_S_FMT will
> actually call vidioc_g_fmt_vbi_cap() if called from VBI.
>
> So, I was unable to see any potencial issues.
Yes, I checked that, too. No problems here.

I was concerned about the||consequences of the
em28xx_set_video_format||() call.
It calls em28xx_resolution_set() which in turn calls

em28xx_set_outfmt()
em28xx_accumulator_set()
em28xx_capture_area_set()||
em28xx_scaler_set()

So lot's of device registers are reconfigured.
That might cause problems even if the register values don't change.

If that has been verified and it causes no problems, than of course
everything is fine.

Regards,
Frank

>
>>> With what application?
>> I would be willing to spend more time on this and test this critical
>> patch (like I already did in the past).
>> But I don't have access to analog TV here at the moment, sorry. It would
>> have to wait ~2 weeks.
> On my tests with the 3 existing VBI apps, they all worked fine
> after the patch, no matter if the VBI or the video application
> is started first.
>
> That's why I asked.
>
> Regards,
> Mauro

