Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:60028 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2JIXwH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 19:52:07 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so1217189iag.19
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 16:52:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121009192540.61875a29@redhat.com>
References: <1349820063-21955-1-git-send-email-elezegarcia@gmail.com>
	<20121009192540.61875a29@redhat.com>
Date: Tue, 9 Oct 2012 20:52:06 -0300
Message-ID: <CALF0-+W-eGegmb2WPozG1qVhm7sa_E-vqZqt4x4veNCnY-BY1Q@mail.gmail.com>
Subject: Re: [PATCH] [for 3.7] stk1160: Add support for S-Video input
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 9, 2012 at 7:25 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em Tue,  9 Oct 2012 19:01:03 -0300
> Ezequiel Garcia <elezegarcia@gmail.com> escreveu:
>
>> In order to fully replace easycap driver with stk1160,
>> it's also necessary to add S-Video support.
>>
>> A similar patch backported for v3.2 kernel has been
>> tested by three different users.
>>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> ---
>> Hi Mauro,
>>
>> I'm sending this for inclusion in v3.7 second media pull request.
>> I realize it's very late, so I understand if you don't
>> want to pick it.
>>
>>  drivers/media/usb/stk1160/stk1160-core.c |   15 +++++++++++----
>>  drivers/media/usb/stk1160/stk1160-v4l.c  |    7 ++++++-
>>  drivers/media/usb/stk1160/stk1160.h      |    3 ++-
>>  3 files changed, 19 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
>> index b627408..34a26e0 100644
>> --- a/drivers/media/usb/stk1160/stk1160-core.c
>> +++ b/drivers/media/usb/stk1160/stk1160-core.c
>> @@ -100,12 +100,21 @@ int stk1160_write_reg(struct stk1160 *dev, u16 reg, u16 value)
>>
>>  void stk1160_select_input(struct stk1160 *dev)
>>  {
>> +     int route;
>>       static const u8 gctrl[] = {
>> -             0x98, 0x90, 0x88, 0x80
>> +             0x98, 0x90, 0x88, 0x80, 0x98
>>       };
>>
>> -     if (dev->ctl_input < ARRAY_SIZE(gctrl))
>> +     if (dev->ctl_input == STK1160_SVIDEO_INPUT)
>> +             route = SAA7115_SVIDEO3;
>> +     else
>> +             route = SAA7115_COMPOSITE0;
>> +
>> +     if (dev->ctl_input < ARRAY_SIZE(gctrl)) {
>> +             v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
>> +                             route, 0, 0);
>>               stk1160_write_reg(dev, STK1160_GCTRL, gctrl[dev->ctl_input]);
>> +     }
>>  }
>>
>>  /* TODO: We should break this into pieces */
>> @@ -351,8 +360,6 @@ static int stk1160_probe(struct usb_interface *interface,
>>
>>       /* i2c reset saa711x */
>>       v4l2_device_call_all(&dev->v4l2_dev, 0, core, reset, 0);
>> -     v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
>> -                             0, 0, 0);
>>       v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
>>
>>       /* reset stk1160 to default values */
>> diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
>> index fe6e857..6694f9e 100644
>> --- a/drivers/media/usb/stk1160/stk1160-v4l.c
>> +++ b/drivers/media/usb/stk1160/stk1160-v4l.c
>> @@ -419,7 +419,12 @@ static int vidioc_enum_input(struct file *file, void *priv,
>>       if (i->index > STK1160_MAX_INPUT)
>>               return -EINVAL;
>>

Look here... I'm returning EINVAL after  STK1160_MAX_INPUT.
(see below)

>> -     sprintf(i->name, "Composite%d", i->index);
>> +     /* S-Video special handling */
>> +     if (i->index == STK1160_SVIDEO_INPUT)
>> +             sprintf(i->name, "S-Video");
>> +     else
>> +             sprintf(i->name, "Composite%d", i->index);
>> +
>
> Had you ever test this patch with the v4l2-compliance tool?
>
> It seems broken to me: this driver has just two inputs. So, it should return
> -EINVAL for all inputs after that, or otherwise userspace applications that
> query the inputs will loop forever!
>

Actually the driver has five inputs, since there are two kinds of devices:
one with four composites, and another with one composite and one s-video.
So, I simply support all of them, since there's no way to distinguish.

I just tested this patch with v4l2-compliance and with qv4l2 and there
are no regressions.

Unless I'm missing something, I think the patch is OK.
Let me know if you want me to change something.

    Ezequiel.
