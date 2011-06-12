Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab1FLOLf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 10:11:35 -0400
Message-ID: <4DF4C912.7050805@redhat.com>
Date: Sun, 12 Jun 2011 11:11:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: Re: [RFCv1 PATCH 7/7] tuner-core: s_tuner should not change tuner
 mode.
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl> <201106121336.18395.hverkuil@xs4all.nl> <4DF4AA3F.5040005@redhat.com> <201106121423.17503.hverkuil@xs4all.nl>
In-Reply-To: <201106121423.17503.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-06-2011 09:23, Hans Verkuil escreveu:
> On Sunday, June 12, 2011 13:59:59 Mauro Carvalho Chehab wrote:
>> Em 12-06-2011 08:36, Hans Verkuil escreveu:
>>> On Saturday, June 11, 2011 21:04:57 Mauro Carvalho Chehab wrote:
>>>> Em 11-06-2011 14:27, Hans Verkuil escreveu:
>>>>> On Saturday, June 11, 2011 15:54:59 Mauro Carvalho Chehab wrote:
>>>>>> Em 11-06-2011 10:34, Hans Verkuil escreveu:
>>>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>>
>>>>>>> According to the spec the tuner type field is not used when calling
>>>>>>> S_TUNER: index, audmode and reserved are the only writable fields.
>>>>>>>
>>>>>>> So remove the type check. Instead, just set the audmode if the current
>>>>>>> tuner mode is set to radio.
>>>>>>
>>>>>> I suspect that this patch also breaks support for a separate radio tuner.
>>>>>> if tuner-type is not properly filled, then the easiest fix would be to
>>>>>> revert some changes done at the tuner cleanup/fixup patches applied on .39.
>>>>>> Yet, the previous logic were trying to hint the device mode, with is bad
>>>>>> (that's why it was changed).
>>>>>>
>>>>>> The proper change seems to add a parameter to this callback, set by the
>>>>>> bridge driver, informing if the device is using radio or video mode.
>>>>>> We need also to patch the V4L API specs, as it allows using a video node
>>>>>> for radio, and vice versa. This is not well supported, and it seems silly
>>>>>> to keep it at the specs and needing to add hints at the drivers due to
>>>>>> that.
>>>>>
>>>>> So, just to make sure I understand correctly what you want. The bridge or
>>>>> platform drivers will fill in the vf->type (for g/s_frequency) or vt->type
>>>>> (for g/s_tuner) based on the device node: RADIO if /dev/radio is used,
>>>>> TV for anything else.
>>>>
>>>> Yes. I remember I've reviewed the bridge drivers when I rewrote the tuner code.
>>>> Of course, I might have left something else. Btw, the older code were also
>>>> requiring it.
>>>>
>>>> The cx18 implementation were merged after the changes, so maybe it is not doing 
>>>> the right thing.
>>>
>>> Actually, G_TUNER was wrong for bttv, ivtv, cx18 and pvrusb2. So it wasn't
>>> just some random driver that failed to set vf/vt->type.
>>
>> G_FREQUENCY were broken just on cx18. As I said before, filling the type were
>> always required.
> 
> No, it wasn't required in the past. I'm happy with that change, but that
> should be documented in v4l2-subdev.h since that's where the subdev ops are
> documented. I will add such documentation in a RFCv5 patch series.
> 
>> Anyway, I've added a proper documentation for it. See the
>> patch bellow.
>>
>> The same patch should be done also for G_TUNER.
> 
> And s_tuner.
> 
>>
>>>>> What about VIDIOC_S_FREQUENCY? The spec says that the app needs to fill this
>>>>> in. Will we just overwrite vf->type or will we check and return -EINVAL if
>>>>> the app tries to set e.g. a TV frequency on /dev/radio?
>>>>
>>>> That's a very good question. What happens is that the V4L2 API used to allow
>>>> opening a /dev/radio device for TV (or even for VBI). IMHO, this were a trouble
>>>> at the API specs. I think that this were changed on newer versions of the spec.
>>>
>>> If you want, then I can add an extra patch to my v4 patch series that returns
>>> -EINVAL in video_ioctl2 if S_FREQUENCY is called with an inconsistent tuner type.
>>> (inconsistent with the device node's type, that is).
>>
>> The reason why check_mode returns -EINVAL is that this error code may need to be
>> returned to the caller. You should note, however, that the bridge code may need
>> to be fixed if you return the check_mode error code, as otherwise the error will
>> simply be discarded or it it will break devices with two tuners.
>>
>> For example, currently, bttv driver uses v4l2_device_call_all() for it.
>> So, any errors returned by it will be simply discarded.
>>
>> If some bridge driver is using v4l2_device_call_until_err(), it will stop on the first
>> tuner that gets an error.
>>
>> The solution is to implement a v4l2_device_call_until_not_err() and use it for the
>> tuner commands.
> 
> That's not unreasonably to do at some point in time, but it doesn't actually
> answer my question, which is: should the core refuse VIDIOC_S_FREQUENCY calls
> where the type doesn't match the device node (i.e. radio vs tv)? I think it
> makes no sense to call VIDIOC_S_FREQUENCY on a radio node with type ANALOG_TV.

No. The core shouldn't do it, otherwise tuner will break. The code doesn't know if
the opened device is radio or video.

> 
> ...
> 
>>>>> What about this:
>>>>>
>>>>> Opening /dev/radio effectively starts the radio mode. So if there is TV
>>>>> capture in progress, then the open should return -EBUSY. Otherwise it
>>>>> switches the tuner to radio mode. And it stays in radio mode until the
>>>>> last filehandle of /dev/radio is closed. At that point it will automatically
>>>>> switch back to TV mode (if there is one, of course).
>>>>
>>>> No. This would break existing applications. The mode switch should be done
>>>> at S_FREQUENCY (e. g. when the radio application is tuning into a channel).
>>>
>>> This is not what happens today as the switch to radio occurs as soon as you open
>>> the radio node. It's the reason for the s_radio op.
>>
>> The s_radio op is something that I wanted to remove. It was there in the past to feed
>> the TV/radio hint logic. I wrote a patch for it, but I ended by discarding from my
>> final queue (I can't remember why).
>>
>> I think that the hint logic were completely removed, but we may need to take a look
>> on the callers for s_radio. I'll check it right now.
> 
> I'm fairly certain s_radio was added to explicitly set the tuner into radio mode.
> It replaced something even uglier, but I can't remember what that was.
> 
>>> The V4L2 specification is silent on this topic, unfortunately. And I'm not sure
>>> how applications handle this.
>>>
>>> I think only changing the mode when calling S_FREQUENCY (and S_STD) is a good
>>> thing since this automatic mode switch when just opening a node goes against
>>> the V4L2 philosophy. Just opening a node shouldn't change the state of the
>>> device.
>>
>> Agreed.
>>
>> commit a307ec69602894c917485f331f8d1fef31c411b8
>> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Date:   Sun Jun 12 08:36:34 2011 -0300
>>
>>     [media] tuner: fix g_frequency subdev call and properly document it
>>     
>>     The tuner type needs to be initialized before calling g_frequency.
>>     cx18 doesn't do it. Fix the logic and properly document the function.
>>     
>>     While here, remove a duplicated line at cx88.
>>     
>>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
>> index 1933d4d..5463548 100644
>> --- a/drivers/media/video/cx18/cx18-ioctl.c
>> +++ b/drivers/media/video/cx18/cx18-ioctl.c
>> @@ -611,6 +611,11 @@ static int cx18_g_frequency(struct file *file, void *fh,
>>  	if (vf->tuner != 0)
>>  		return -EINVAL;
>>  
>> +	if (test_bit(CX18_F_I_RADIO_USER, &cx->i_flags))
>> +		vf->type = V4L2_TUNER_RADIO;
>> +	else
>> +		vf->type = V4L2_TUNER_ANALOG_TV;
>> +
> 
> NACK.
> 
> This sets the type to the current mode. But what we want is to set the type to
> the current device node. That's what my RFCv4 does (and that patch requires no
> driver change).

I didn't get your RFCv4 patches here yet, but the fix should be at the driver: it
needs to set the type before calling g_frequency. G_FREQUENCY shouldn't change the
device mode, but, instead, to return the frequency and mode currently in usage..

> Although, to be honest, I did something similar to this patch in pvrusb2, but
> that's because I have no idea to get hold of the calling device node there.
> That hardware abstraction layer in pvrusb2 abstracts way too much :-(
> 
>>  	cx18_call_all(cx, tuner, g_frequency, vf);
>>  	return 0;
>>  }
>> diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
>> index cef4f28..13636f7 100644
>> --- a/drivers/media/video/cx88/cx88-video.c
>> +++ b/drivers/media/video/cx88/cx88-video.c
>> @@ -1394,7 +1394,6 @@ static int vidioc_g_frequency (struct file *file, void *priv,
>>  	if (unlikely(UNSET == core->board.tuner_type))
>>  		return -EINVAL;
>>  
>> -	/* f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV; */
>>  	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>>  	f->frequency = core->freq;
> 
> Same here. No longer needed with the RFCv4 series.
> 
>>  
>> diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
>> index 5748d04..34cd9b0 100644
>> --- a/drivers/media/video/tuner-core.c
>> +++ b/drivers/media/video/tuner-core.c
>> @@ -1133,6 +1133,17 @@ static int tuner_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
>>  	return 0;
>>  }
>>  
>> +/**
>> + * tuner_g_frequency - Gets the tuned frequency for the tuner
>> + * @sd: pointer to struct v4l2_subdev
>> + * @f: opinter to struct v4l2_frequency
>> + *
>> + * At return, the structure f will be filled with tuner frequency,
>> + * if the tuner matches the f->type.
>> + * Note: f->type should be initialized before calling it.
>> + * as userspace won't initialize f->type, it is up to the bridge driver
>> + * to set it to either V4L2_TUNER_RADIO or V4L2_TUNER_ANALOG_TV.
>> + */
>>  static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
>>  {
>>  	struct tuner *t = to_tuner(sd);
>>
>>
> 
> I'll add documentation to v4l2-subdev.h.

The doc should also be at tuner-core.

> 
> Regards,
> 
> 	Hans

