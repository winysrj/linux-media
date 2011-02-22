Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab1BVLbE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 06:31:04 -0500
Message-ID: <4D639E76.3010708@redhat.com>
Date: Tue, 22 Feb 2011 08:31:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some fixes for tuner, tvp5150 and em28xx
References: <20110221231741.71a2149e@pedra> <4D6324DB.5030801@redhat.com> <201102220853.59343.hverkuil@xs4all.nl>
In-Reply-To: <201102220853.59343.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 22-02-2011 04:53, Hans Verkuil escreveu:
> On Tuesday, February 22, 2011 03:52:11 Mauro Carvalho Chehab wrote:
>> Em 21-02-2011 23:17, Mauro Carvalho Chehab escreveu:
>>> This series contain a minor cleanup for tuner and tvp5150, and two fixes
>>> for em28xx controls. Before the em28xx patches, s_ctrl were failing on
>>> qv4l2, because it were returning a positive value of 1 for some calls.
>>>
>>> It also contains a fix for control get/set, as it will now check if the
>>> control exists before actually calling subdev for get/set.
>>>
>>> Mauro Carvalho Chehab (4):
>> ...
>>>   [media] em28xx: Fix return value for s_ctrl
>>>   [media] em28xx: properly handle subdev controls
>>
>> Hans,
>>
>> I discovered the issue with em28xx that I commented you on IRC.
>>
>> There were, in fact, 3 issues. 
>>
>> One is clearly a driver problem, corrected by "em28xx: properly
>> handle subdev controls".
>>
>> The second one being partially qv4l2 and partially driver issue,
>> fixed by "em28xx: Fix return value for s_ctrl". Basically, V4L2
>> API and ioctl man page says that an error is indicated by -1 value,
>> being 0 or positive value a non-error. Well, qv4l2 understands a
>> positive value as -EBUSY. The driver were returning a non-standard
>> value of 1 for s_ctrl. I fixed the driver part.
>>
>> The last issue is with v4l2-ctl and qv4l2. Also, the latest version
>> of xawtv had the same issue, probably due to some changes I did at
>> console/v4l-info.c.
>>
>> What happens is that em28xx doesn't implement the control BASE+4,
>> due to one simple reason: it is not currently defined. The ctrl
>> loop were understanding the -EINVAL return of BASE+4 as the end of
>> the user controls. So, on xawtv, only the 3 image controls were
>> returned. I didn't dig into v4l2-ctl, but there, it doesn't show
>> the first 3 controls. It shows only the audio controls:
>>
>>                          volume (int)  : min=0 max=65535 step=655 default=58880 value=58880 flags=slider
>>                         balance (int)  : min=0 max=65535 step=655 default=32768 value=32768 flags=slider
>>                            bass (int)  : min=0 max=65535 step=655 default=32768 value=32768 flags=slider
>>                          treble (int)  : min=0 max=65535 step=655 default=32768 value=32768 flags=slider
>>                            mute (bool) : default=0 value=0
>>                        loudness (bool) : default=0 value=0
>>
>> The xawtv fix is at:
>> 	http://git.linuxtv.org/xawtv3.git?a=commitdiff;h=fda070af9cfd75b360db1339bde3c6d3c64ed627
>>
>> A similar fix is needed for v4l2-ctl and qv4l2.
> 
> Actually, v4l2-ctrl and qv4l2 handle 'holes' correctly. I think this is a
> different bug relating to the handling of V4L2_CTRL_FLAG_NEXT_CTRL. Can you
> try this patch:
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index ef66d2a..15eda86 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -1364,6 +1364,8 @@ EXPORT_SYMBOL(v4l2_queryctrl);
>  
>  int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
>  {
> +	if (qc->id & V4L2_CTRL_FLAG_NEXT_CTRL)
> +		return -EINVAL;
>  	return v4l2_queryctrl(sd->ctrl_handler, qc);
>  }
>  EXPORT_SYMBOL(v4l2_subdev_queryctrl);
> 
> v4l2-ctl and qv4l2 enumerate the controls using this flag, falling back to the
> old method if the flag isn't supported. The v4l2_subdev_queryctrl function will
> currently handle that flag, but for the controls of the subdev only. This isn't
> right, it should refuse this flag. Without this fix v4l2-ctl will only see the
> controls of the first subdev, which is exactly what you got. I never saw this
> bug because the HVR900 has just a single subdev.

Ok, that makes sense. I'll test the patch and give you a feedback.

> I also suspect that s_ctrl is wrong: can you test setting a video control? I
> think that v4l2_device_call_until_err will always return an error. I'm not sure
> if there is an easy fix for this other than converting em28xx to the control
> framework. I need to think about this.

I've changed it by two subdev calls. The first one queries for the control. If control 
type is zero, it returns an error, otherwise, it will call v4l2_device_all_all (see
patch 4/4). This is sub-optimal, but should fix the bug, and can be sent to -stable.

Cheers,
Mauro

