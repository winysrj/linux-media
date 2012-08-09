Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65146 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2HIUnp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 16:43:45 -0400
Received: by yenl2 with SMTP id l2so951399yen.19
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2012 13:43:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50241CCE.2030000@redhat.com>
References: <1344260302-28849-1-git-send-email-elezegarcia@gmail.com>
	<50241CCE.2030000@redhat.com>
Date: Thu, 9 Aug 2012 17:43:43 -0300
Message-ID: <CALF0-+V=f=5be9AE=mS5O32Vtbgt3yfP0Y+nkVOpJKs5aGOgaA@mail.gmail.com>
Subject: Re: [PATCH v8] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Takashi Iwai <tiwai@suse.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 9, 2012 at 5:25 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Patch looks ok. Just a few comments:
>
> Em 06-08-2012 10:38, Ezequiel Garcia escreveu:
>> This driver adds support for stk1160 usb bridge as used in some
>> video/audio usb capture devices.
>> It is a complete rewrite of staging/media/easycap driver and
>> it's expected as a replacement.
>> ---
>
> Please don't add a "---" here. Everything after a --- are discarded
> by my scripts (and by most other kernel developer scripts).
>

Mmm, that line was meant to separate commit message from
message intended for developers/reviewers.
Do you feel all the text should be part of the commit message?

Anyway, I know currently it's wrong, since the SOB should be part of
commit message.

>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Takashi Iwai <tiwai@suse.de>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
>
> Hmm... weren't it reviewed already be them?
>

Yes, Hans and Sylwester reviewed the various versions and Takashi
reviewed the alsa part.
I added a Cc, so they could review the changes made after their comments.
Do you think I should drop it in v9?

>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> diff --git a/drivers/media/video/stk1160/Makefile b/drivers/media/video/stk1160/Makefile
>> new file mode 100644
>> index 0000000..8f66a78
>> --- /dev/null
>> +++ b/drivers/media/video/stk1160/Makefile
>> @@ -0,0 +1,12 @@
>> +obj-stk1160-ac97-$(CONFIG_VIDEO_STK1160_AC97) := stk1160-ac97.o
>> +
>> +stk1160-y :=         stk1160-core.o \
>> +             stk1160-v4l.o \
>> +             stk1160-video.o \
>> +             stk1160-i2c.o \
>> +             $(obj-stk1160-ac97-y)
>> +
>> +obj-$(CONFIG_VIDEO_STK1160) += stk1160.o
>> +
>> +ccflags-y += -Wall
>
> You shouldn't be adding the above here.
>

Okey.

>> +ccflags-y += -Idrivers/media/video
>
> Ah, please split this patch into two patches: one with the new driver
> addition, and another one with the removal of the driver at staging.
>
> That will help to make the patch smaller, and avoids mixing two different
> things at the same place.
>

No problem. I hope the easycap removal patch passes through vger!

> Thanks,

You are welcome :-)
Ezequiel.
