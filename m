Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45490 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab2GWSfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 14:35:45 -0400
Received: by lbbgm6 with SMTP id gm6so8356587lbb.19
        for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 11:35:43 -0700 (PDT)
Message-ID: <500D997B.9060606@gmail.com>
Date: Mon, 23 Jul 2012 20:35:39 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <ameersk@gmail.com>
CC: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com
Subject: Re: [PATCH v2 01/01] media: gscaler: Add new driver for generic scaler
References: <1341484061-10914-1-git-send-email-shaik.ameer@samsung.com> <1341484061-10914-2-git-send-email-shaik.ameer@samsung.com> <4FFF20D3.4020806@gmail.com> <CAFSwF2f7QmdgYM_PEU7ZqFezOx2nj4gSRKo+pedseaJZw_8sVA@mail.gmail.com>
In-Reply-To: <CAFSwF2f7QmdgYM_PEU7ZqFezOx2nj4gSRKo+pedseaJZw_8sVA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 07/23/2012 08:18 AM, Shaik Ameer Basha wrote:
>>> +struct gsc_fmt *find_fmt(u32 *pixelformat, u32 *mbus_code, int index)
>>> +{
>>> +     struct gsc_fmt *fmt, *def_fmt = NULL;
>>> +     unsigned int i;
>>> +
>>> +     if (index>= ARRAY_SIZE(gsc_formats))
>>
>>          if (index>= (int)ARRAY_SIZE(gsc_formats))
> 
> changed the function prototype to take "u32 index"....

Yeah, that's fine too, since you seem not to be passing negative values
as the third argument to this function.

>>
>> (otherwise negative indexes won't work)
>>
>>> +             return NULL;
>>> +
>>> +     for (i = 0; i<   ARRAY_SIZE(gsc_formats); ++i) {
>>> +             fmt = get_format(i);
>>> +             if (pixelformat&&   fmt->pixelformat == *pixelformat)
>>> +                     return fmt;
>>> +             if (mbus_code&&   fmt->mbus_code == *mbus_code)
>>> +                     return fmt;
>>> +             if (index == i)
>>> +                     def_fmt = fmt;
>>> +     }
>>> +     return def_fmt;
>>> +
>>> +}
...
>>> +     cap->capabilities = V4L2_CAP_STREAMING |
>>> +             V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>>
>> Need to set device_caps as well:
>>
>>   cap->device_caps = V4L2_CAP_STREAMING |
>>                      V4L2_CAP_VIDEO_CAPTURE_MPLANE |
>>                      V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>>
>>   cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>>
> 
> OK. I will change that.
> 
>>
>> Howewer this will probably need to be
>>
>>   cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
>>
>> as per http://www.mail-archive.com/linux-media@vger.kernel.org/msg48498.html
>> by the time this patch is to be merged (v3.7 ?).
>>
> 
> currently my plan is to merge these changes in v3.6.
> Isn't it possible ????

I presume it's still possible. It depends how quick you resolve all
issues pointed out during reviews. However v3.6 merge window has already
opened. So you should probably send the pull request this week at the 
latest. And don't worry too much about the new M2M capability flag.

However, there was previously a rule that everything for next release
must be pushed to the -next tree before a merge window opens.
If this is still in force then it's already too late.

I would suggest to address the review comments and to send a pull 
request to Mauro and let him decide if he pulls it for 3.6 or not.

Here is some more details regarding patch submitting rules:
http://linuxtv.org/wiki/index.php/Maintaining_Git_trees

>>> +     return 0;
>>> +}
>>> +
>> [...]
>>> +static int gsc_m2m_g_selection(struct file *file, void *fh,
>>> +                     struct v4l2_selection *s)
>>> +{
>>> +     struct gsc_frame *frame;
>>> +     struct gsc_ctx *ctx = fh_to_ctx(fh);
>>> +
>>> +     if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)&&
>>> +         (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
>>> +             return -EINVAL;
>>> +
>>> +     frame = ctx_get_frame(ctx, s->type);
>>> +     if (IS_ERR(frame))
>>> +             return PTR_ERR(frame);
>>> +
>>> +     switch (s->target) {
>>> +     case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>>> +     case V4L2_SEL_TGT_COMPOSE_BOUNDS:
>>> +     case V4L2_SEL_TGT_CROP_BOUNDS:
>>> +     case V4L2_SEL_TGT_CROP_DEFAULT:
>>> +             s->r.left = 0;
>>> +             s->r.top = 0;
>>> +             s->r.width = frame->f_width;
>>> +             s->r.height = frame->f_height;
>>> +             return 0;
>>> +
>>> +     case V4L2_SEL_TGT_COMPOSE_ACTIVE:
>>> +     case V4L2_SEL_TGT_CROP_ACTIVE:
>>
>> Please use V4L2_SEL_TGT_CROP/COMPOSE instead of V4L2_SEL_TGT_CROP/COMPOSE_ACTIVE
>> which is being phased out.
>>
>> http://git.linuxtv.org/media_tree.git/commit/c133482300113b3b71fa4a1fd2118531e765b36a
>>
> 
> currently, I am rebasing the code on media-next git...
> http://linuxtv.org/git/mchehab/media-next.git
> 
> I am not able to find the above changes mentioned in this git...
> do you want me to rebase my code on top of the patch you provided ????
> 
> Or should i use any other git repository for rebasing my code ???

The proper tree you should base your patches of off for next kernel
release is:

git://linuxtv.org/media_tree.git
branch: staging/for_v{N + 0.1}, where N is current kernel release.

So in your case staging/for_v3.6. You'll find there the changes 
I talked about previously and other patches queued up for v3.6.

More details can be found here:
http://git.linuxtv.org/media_tree.git

--

Regards,
Sylwester
