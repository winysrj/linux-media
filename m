Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab2KPPrR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 10:47:17 -0500
Message-ID: <50A65FF2.8020801@redhat.com>
Date: Fri, 16 Nov 2012 13:46:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Kirill Smelkov <kirr@mns.spb.ru>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4] [media] vivi: Teach it to tune FPS
References: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru> <201211021542.21944.hverkuil@xs4all.nl> <20121107113001.GA3097@tugrik.mns.mnsspb.ru> <201211161438.09046.hverkuil@xs4all.nl>
In-Reply-To: <201211161438.09046.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-11-2012 11:38, Hans Verkuil escreveu:
> On Wed November 7 2012 12:30:01 Kirill Smelkov wrote:
>> On Fri, Nov 02, 2012 at 03:42:21PM +0100, Hans Verkuil wrote:
>>> Thanks for the ping, I forgot about this patch...
>>
>> Thanks for feedback and for waiting. I'm here again...
>>
>>
>>> On Tue October 23 2012 15:35:21 Kirill Smelkov wrote:
>>>> On Tue, Oct 23, 2012 at 08:40:04AM +0200, Hans Verkuil wrote:
>>>>> On Mon October 22 2012 19:01:40 Kirill Smelkov wrote:
>>>>>> On Mon, Oct 22, 2012 at 04:16:14PM +0200, Hans Verkuil wrote:
>>>>>>> On Mon October 22 2012 15:54:44 Kirill Smelkov wrote:
>>>>>>>> I was testing my video-over-ethernet subsystem today, and vivi seemed to
>>>>>>>> be perfect video source for testing when one don't have lots of capture
>>>>>>>> boards and cameras. Only its framerate was hardcoded to NTSC's 30fps,
>>>>>>>> while in my country we usually use PAL (25 fps). That's why the patch.
>>>>>>>> Thanks.
>>>>>>>
>>>>>>> Rather than introducing a module option, it's much nicer if you can
>>>>>>> implement enum_frameintervals and g/s_parm. This can be made quite flexible
>>>>>>> allowing you to also support 50/59.94/60 fps.
>>>>>>
>>>>>> Thanks for feedback. I've reworked the patch for FPS to be set via
>>>>>> ->{g,s}_parm(), and yes now it is more flexble, because one can set
>>>>>> different FPS on different vivi devices. Only I don't know V4L2 ioctls
>>>>>> details well enough and various drivers do things differently. The patch
>>>>>> is below. Is it ok?
>>>>>
>>>>> Close, but it's not quite there.
>>>>>
>>>>> You should run the v4l2-compliance tool from the v4l-utils.git repository
>>>>> (take the master branch). That will report any errors in your implementation.
>>>>>
>>>>> In this case g/s_parm doesn't set readbuffers (set it to 1) and if timeperframe
>>>>> equals { 0, 0 }, then you should get a nominal framerate (let's stick to 29.97
>>>>> for that). I would set the nominal framerate whenever the denominator == 0.
>>>>>
>>>>> For vidioc_enum_frameintervals you need to check the IN fields and fill in the
>>>>> stepwise struct.
>>>>
>>>> Thanks for pointers and info about v4l2-compliance handy-tool. I've
>>>> tried to correct all the issues you mentioned above and here is the
>>>> patch.
>>>>
>>>> (Only requirement to set stepwise.step to 1.0 for
>>>>   V4L2_FRMIVAL_TYPE_CONTINUOUS seems a bit illogical to me, but anyway,
>>>>   that's what the V4L2 spec requires...)
>>>>
>>>> Thanks,
>>>> Kirill
>>>>
>>>> ---- 8< ----
>>>> From: Kirill Smelkov <kirr@mns.spb.ru>
>>>> Date: Tue, 23 Oct 2012 16:56:59 +0400
>>>> Subject: [PATCH v3] [media] vivi: Teach it to tune FPS
>>>>
>>>> I was testing my video-over-ethernet subsystem yesterday, and vivi
>>>> seemed to be perfect video source for testing when one don't have lots
>>>> of capture boards and cameras. Only its framerate was hardcoded to
>>>> NTSC's 30fps, while in my country we usually use PAL (25 fps) and I
>>>> needed that to precisely simulate bandwidth.
>>>>
>>>> That's why here is this patch with ->enum_frameintervals() and
>>>> ->{g,s}_parm() implemented as suggested by Hans Verkuil which passes
>>>> v4l2-compliance and manual testing through v4l2-ctl -P / -p <fps>.
>>>>
>>>> Regarding newly introduced __get_format(u32 pixelformat) I decided not
>>>> to convert original get_format() to operate on fourcc codes, since >= 3
>>>> places in driver need to deal with v4l2_format and otherwise it won't be
>>>> handy.
>>>>
>>>> Thanks.
>>>>
>>>> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
>>>> ---
>>>>   drivers/media/platform/vivi.c | 84 ++++++++++++++++++++++++++++++++++++++-----
>>>>   1 file changed, 75 insertions(+), 9 deletions(-)
>>>>
>>>> V3:
>>>>      - corrected issues with V4L2 spec compliance as pointed by Hans
>>>>        Verkuil.
>>>>
>>>> V2:
>>>>
>>>>      - reworked FPS setting from module param to via ->{g,s}_parm() as suggested
>>>>        by Hans Verkuil.
>>>>
>>>>
>>>> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
>>>> index 3e6902a..3adea58 100644
>>>> --- a/drivers/media/platform/vivi.c
>>>> +++ b/drivers/media/platform/vivi.c
>>>> @@ -36,10 +36,6 @@
>>>>
>>>>   #define VIVI_MODULE_NAME "vivi"
>>>>
>>>> -/* Wake up at about 30 fps */
>>>> -#define WAKE_NUMERATOR 30
>>>> -#define WAKE_DENOMINATOR 1001
>>>> -
>>>>   #define MAX_WIDTH 1920
>>>>   #define MAX_HEIGHT 1200
>>>>
>>>> @@ -69,6 +65,9 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
>>>>   /* Global font descriptor */
>>>>   static const u8 *font8x16;
>>>>
>>>> +/* default to NTSC timeperframe */
>>>> +static const struct v4l2_fract TPF_DEFAULT = {.numerator = 1001, .denominator = 30000};
>>>
>>> Keep the name lower case: tpf_default. Upper case is for defines only.
>>
>> ok
>>
>> [...]
>>
>>>> @@ -1049,6 +1054,63 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
>>>>   	return 0;
>>>>   }
>>>>
>>>> +/* timeperframe is arbitrary and continous */
>>>> +static int vidioc_enum_frameintervals(struct file *file, void *priv,
>>>> +					     struct v4l2_frmivalenum *fival)
>>>> +{
>>>> +	struct vivi_fmt *fmt;
>>>> +
>>>> +	if (fival->index)
>>>> +		return -EINVAL;
>>>> +
>>>> +	fmt = __get_format(fival->pixel_format);
>>>> +	if (!fmt)
>>>> +		return -EINVAL;
>>>> +
>>>> +	/* regarding width width & height - we support any */
>>>> +
>>>> +	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>>>> +
>>>> +	/* fill in stepwise as required by V4L2 spec, i.e.
>>>> +	 *
>>>> +	 * min <= (step = 1.0) <= max
>>>> +	 */
>>>> +	fival->stepwise.step = (struct v4l2_fract) {1, 1};
>>>> +	fival->stepwise.min  = (struct v4l2_fract) {1, 1};
>>>> +	fival->stepwise.max  = (struct v4l2_fract) {2, 1};
>>>
>>> Shouldn't max for {60, 1} or perhaps even {120, 1} if you want to be able to test 120 Hz
>>> framerates? {2, 1} is 2 fps, which is a bit low :-)
>>
>>   [ see below ... ]
>>
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int vidioc_g_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
>>>> +{
>>>> +	struct vivi_dev *dev = video_drvdata(file);
>>>> +
>>>> +	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>>> +		return -EINVAL;
>>>> +
>>>> +	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
>>>> +	parm->parm.capture.timeperframe = dev->timeperframe;
>>>> +	parm->parm.capture.readbuffers  = 1;
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
>>>> +{
>>>> +	struct vivi_dev *dev = video_drvdata(file);
>>>> +
>>>> +	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>>> +		return -EINVAL;
>>>> +
>>>> +	dev->timeperframe = parm->parm.capture.timeperframe.denominator ?
>>>
>>> This should check that the fps is between the min and max values as reported by
>>> vidioc_enum_frameintervals(). Fall back to the default if the values are out of
>>> range.
>>
>> {2, 1} is 0.5 fps and {120, 1} is 1/120 fps :) but anyway, why should we
>> set that artificial limits here?
>>
>> Thanks for catching the actual bug, but I propose we set min=1/infty and
>> max=infty so that the user chooses which tpf/fps he/she needs, be it
>> 9000 fps or 1 frame per hour. And imho it's better to clip the value,
>> than to fallback to default (but we still reset it if */0 is coming from
>> userspace).
>>
>> Said all that, here is the interdiff and updated patch.
>>
>> Thanks,
>> Kirill
>>
>> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
>> index 37d0af8..5d1b374 100644
>> --- a/drivers/media/platform/vivi.c
>> +++ b/drivers/media/platform/vivi.c
>> @@ -65,8 +65,11 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
>>   /* Global font descriptor */
>>   static const u8 *font8x16;
>>
>> -/* default to NTSC timeperframe */
>> -static const struct v4l2_fract TPF_DEFAULT = {.numerator = 1001, .denominator = 30000};
>> +/* timeperframe: min/max and default */
>> +static const struct v4l2_fract
>> +	tpf_min     = {.numerator = 1,		.denominator = UINT_MAX},  /* 1/infty */
>> +	tpf_max     = {.numerator = UINT_MAX,	.denominator = 1},         /* infty */
>
> I understand your reasoning here, but I wouldn't go with UINT_MAX here. Something like
> 1/1000 tpf (or 1 ms) up to 86400/1 tpf (or once a day). With UINT_MAX I am afraid we
> might hit application errors when they manipulate these values. The shortest time
> between frames is 1 ms anyway.
>
> It's the only comment I have, it looks good otherwise.

As those will be a arbitrary values, I suggest to declare a macro for it at the
beginning of vivi.c file, with some comment explaining the rationale of the choose,
and what else needs to be changed, if this changes (e. g. less than 1ms would require
changing the image generation logic, to avoid producing frames with equal content).

Regards,
Mauro

