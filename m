Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45338 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab2GERWt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 13:22:49 -0400
Received: by ghrr11 with SMTP id r11so7655027ghr.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 10:22:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+XzNOiM+TA3rzY2NGSyXgFL8SuVU_yP0GTpcFMavQmNSg@mail.gmail.com>
References: <1339509222-2714-1-git-send-email-elezegarcia@gmail.com>
	<1339509222-2714-2-git-send-email-elezegarcia@gmail.com>
	<4FF5C77C.7030500@redhat.com>
	<CALF0-+XzNOiM+TA3rzY2NGSyXgFL8SuVU_yP0GTpcFMavQmNSg@mail.gmail.com>
Date: Thu, 5 Jul 2012 14:22:47 -0300
Message-ID: <CALF0-+X3=8kcyz30cqYAH7nunEZyKpvkq0gh70_TB-r-jbutig@mail.gmail.com>
Subject: Re: [PATCH] em28xx: Remove useless runtime->private_data usage
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, Jul 5, 2012 at 1:57 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:

>>
>>       snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
>>       dev->adev.capture_pcm_substream = substream;
>> -     runtime->private_data = dev;
>
>
> Are you sure that this can be removed? I think this is used internally
> by the alsa API, but maybe something has changed and this is not
> required anymore.

Yes, I'm sure.

>
> Had you test em28xx audio with this change?

No, I did not test it.

To make this patch, I've considered two things:

1. Alsa documentation [1]
This is from chapter 5, "Private Data" section.

---
You can allocate a record for the substream and store it in
runtime->private_data. Usually, this is done in the open callback.
Don't mix this with pcm->private_data. The pcm->private_data usually
points to the chip instance assigned statically at the creation of
PCM, while the runtime->private_data points to a dynamic data
structure created at the PCM open callback.

  static int snd_xxx_open(struct snd_pcm_substream *substream)
  {
          struct my_pcm_data *data;
          ....
          data = kmalloc(sizeof(*data), GFP_KERNEL);
          substream->runtime->private_data = data;
          ....
  }
---

I think the part "Don't mix this with pcm->private_data", is the one
related to this case.
Also, what alsa documentation calls "chip instance" is our em28xx
device structure.

2. Regular kernel practice:
Normally, private_data fields are suppose to be (private) data the
driver author wants
the core subsystem to pass him as callback parameter. The core
subsystem is not supposed
to use it in anyway (he wouldn't know how).
So, if you don't use it anywhere else in your code, it's safe to remove it.

If still in doubt, just don't apply it.

I'm not really concerned about one extra line,
rather about drivers doing unnecessary stuff,
and then others take these drivers as example
and spread the bloatness all over the place, so to speak.

[1] http://www.alsa-project.org/~tiwai/writing-an-alsa-driver/ch05s05.html
