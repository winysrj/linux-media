Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:47508 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaG0InT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 04:43:19 -0400
Received: by mail-ie0-f169.google.com with SMTP id rd18so5377702iec.14
        for <linux-media@vger.kernel.org>; Sun, 27 Jul 2014 01:43:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53D4B7B8.1040901@xs4all.nl>
References: <CA+NJmkcTpf5Xb4Z8gJFriB58Jtf85ay_jnTS-fM34gA1PBf60g@mail.gmail.com>
 <53D4B013.2060404@xs4all.nl> <CA+NJmkcFLn5kVZe=4yUBcjAGp38-qAz_rx8eVapVnriANqZDNg@mail.gmail.com>
 <53D4B7B8.1040901@xs4all.nl>
From: Isaac Nickaein <nickaein.i@gmail.com>
Date: Sun, 27 Jul 2014 13:12:58 +0430
Message-ID: <CA+NJmkcnKxHWcPv-H9r=SQzOJD-DtnRc9voWz9a=BnsrgBv8kQ@mail.gmail.com>
Subject: Re: "error: redefinition of 'altera_init'" during build on Kernel 3.0.36+
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 27, 2014 at 12:56 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> No. Whoever maintains that repository applied v4l code from some newer
> kernel without apparently ever testing it. This is really the responsibility
> of maintainer of that repository and is out of our control.
>
> You need to address your questions to that repository maintainer, we can't
> help, I'm afraid.
>

Ah I see. I have some issues with v4l2 on this kernel version and I am
trying to upgrade v4l2 to fix that.

One last question: Can I remove current v4l codes in kernel, replace
them with the V4L2 backport (provided by linuxtv), fix the
compatibility issues (hopefully) to get a kernel source with newer
v4l2 code?

I am not sure if the v4l2 backport is the same type of code that is
present in kernel source at "drivers/media/video",
"drivers/media/dvb", etc.


Thanks,
Isaac


> Regards,
>
>         Hans
>
>>
>> To bypass this error, I manually added these two includes to
>> v4l2-.fh.h file (I guess this is not a good approach):
>>
>> #include <linux/module.h>
>> #include <linux/export.h>
>>
>> Now when I run make, I get different errors. Here is the output
>> truncated to 100 lines (there are many errors):
>>
>>
>> root@localhost:~/v4l2/media_build# make
>> make -C /root/v4l2/media_build/v4l
>> make[1]: Entering directory `/root/v4l2/media_build/v4l'
>> creating symbolic links...
>> make -C firmware prep
>> make[2]: Entering directory `/root/v4l2/media_build/v4l/firmware'
>> make[2]: Leaving directory `/root/v4l2/media_build/v4l/firmware'
>> make -C firmware
>> make[2]: Entering directory `/root/v4l2/media_build/v4l/firmware'
>> make[2]: Nothing to be done for `default'.
>> make[2]: Leaving directory `/root/v4l2/media_build/v4l/firmware'
>> Kernel build directory is /lib/modules/3.0.36+/build
>> make -C ../linux apply_patches
>> make[2]: Entering directory `/root/v4l2/media_build/linux'
>> Patches for 3.0.36+ already applied.
>> make[2]: Leaving directory `/root/v4l2/media_build/linux'
>> make -C /lib/modules/3.0.36+/build SUBDIRS=/root/v4l2/media_build/v4l  modules
>> make[2]: Entering directory `/lib/modules/3.0.36+/build'
>>   CC [M]  /root/v4l2/media_build/v4l/au0828-video.o
>> In file included from include/linux/cache.h:4:0,
>>                  from include/linux/time.h:7,
>>                  from include/linux/stat.h:60,
>>                  from include/linux/module.h:10,
>>                  from /root/v4l2/media_build/v4l/au0828-video.c:31:
>> /root/v4l2/media_build/v4l/au0828-video.c: In function 'au0828_v4l2_close':
>> /root/v4l2/media_build/v4l/au0828-video.c:1086:28: error: 'struct
>> au0828_dev' has no member named 'v4l2_dev'
>>    v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
>>                             ^
>> include/linux/kernel.h:659:49: note: in definition of macro 'container_of'
>>   const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>>                                                  ^
>> include/linux/list.h:419:13: note: in expansion of macro 'list_entry'
>>   for (pos = list_entry((head)->next, typeof(*pos), member); \
>>              ^
>> /root/v4l2/media_build/v4l/../linux/include/media/v4l2-device.h:140:3:
>> note: in expansion of macro 'list_for_each_entry'
>>    list_for_each_entry((sd), &(v4l2_dev)->subdevs, list) \
>>    ^
>> /root/v4l2/media_build/v4l/../linux/include/media/v4l2-device.h:184:3:
>> note: in expansion of macro '__v4l2_device_call_subdevs_p'
>>    __v4l2_device_call_subdevs_p(v4l2_dev, __sd,  \
>>    ^
>> /root/v4l2/media_build/v4l/au0828-video.c:1086:3: note: in expansion
>> of macro 'v4l2_device_call_all'
>>    v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
>>    ^
>> In file included from include/linux/module.h:9:0,
>>                  from /root/v4l2/media_build/v4l/au0828-video.c:31:
>> /root/v4l2/media_build/v4l/au0828-video.c:1086:28: error: 'struct
>> au0828_dev' has no member named 'v4l2_dev'
>>    v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
>>                             ^
>> include/linux/list.h:420:24: note: in definition of macro 'list_for_each_entry'
>>        &pos->member != (head);  \
>>                         ^
>> /root/v4l2/media_build/v4l/../linux/include/media/v4l2-device.h:184:3:
>> note: in expansion of macro '__v4l2_device_call_subdevs_p'
>>    __v4l2_device_call_subdevs_p(v4l2_dev, __sd,  \
>>    ^
>> /root/v4l2/media_build/v4l/au0828-video.c:1086:3: note: in expansion
>> of macro 'v4l2_device_call_all'
>>    v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
>>    ^
>> In file included from include/linux/cache.h:4:0,
>>                  from include/linux/time.h:7,
>>                  from include/linux/stat.h:60,
>>                  from include/linux/module.h:10,
>>                  from /root/v4l2/media_build/v4l/au0828-video.c:31:
>> /root/v4l2/media_build/v4l/au0828-video.c: In function 'au0828_init_tuner':
>> /root/v4l2/media_build/v4l/au0828-video.c:1120:27: error: 'struct
>> au0828_dev' has no member named 'v4l2_dev'
>>   v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, dev->std);
>>                            ^
>> include/linux/kernel.h:659:49: note: in definition of macro 'container_of'
>>   const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>>                                                  ^
>> include/linux/list.h:419:13: note: in expansion of macro 'list_entry'
>>   for (pos = list_entry((head)->next, typeof(*pos), member); \
>>              ^
>> /root/v4l2/media_build/v4l/../linux/include/media/v4l2-device.h:140:3:
>> note: in expansion of macro 'list_for_each_entry'
>>    list_for_each_entry((sd), &(v4l2_dev)->subdevs, list) \
>>    ^
>> /root/v4l2/media_build/v4l/../linux/include/media/v4l2-device.h:184:3:
>> note: in expansion of macro '__v4l2_device_call_subdevs_p'
>>    __v4l2_device_call_subdevs_p(v4l2_dev, __sd,  \
>>    ^
>> /root/v4l2/media_build/v4l/au0828-video.c:1120:2: note: in expansion
>> of macro 'v4l2_device_call_all'
>>   v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, dev->std);
>>   ^
>> In file included from include/linux/module.h:9:0,
>>                  from /root/v4l2/media_build/v4l/au0828-video.c:31:
>> /root/v4l2/media_build/v4l/au0828-video.c:1120:27: error: 'struct
>> au0828_dev' has no member named 'v4l2_dev'
>>   v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, dev->std);
>>                            ^
>> include/linux/list.h:420:24: note: in definition of macro 'list_for_each_entry'
>>        &pos->member != (head);  \
>>                         ^
>> /root/v4l2/media_build/v4l/../linux/include/media/v4l2-device.h:184:3:
>> note: in expansion of macro '__v4l2_device_call_subdevs_p'
>>    __v4l2_device_call_subdevs_p(v4l2_dev, __sd,  \
>>    ^
>> /root/v4l2/media_build/v4l/au0828-video.c:1120:2: note: in expansion
>> of macro 'v4l2_device_call_all'
>>   v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, dev->std);
>>   ^
>> In file included from include/linux/cache.h:4:0,
>>                  from include/linux/time.h:7,
>>                  from include/linux/stat.h:60,
>>                  from include/linux/module.h:10,
>>                  from /root/v4l2/media_build/v4l/au0828-video.c:31:
>> /root/v4l2/media_build/v4l/au0828-video.c:1121:27: error: 'struct
>> au0828_dev' has no member named 'v4l2_dev'
>>   v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
>>                            ^
>> include/linux/kernel.h:659:49: note: in definition of macro 'container_of'
>>   const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>>                                                  ^
>> include/linux/list.h:419:13: note: in expansion of macro 'list_entry'
>>   for (pos = list_entry((head)->next, typeof(*pos), member); \
>>              ^
>> /root/v4l2/media_build/v4l/../linux/include/media/v4l2-device.h:140:3:
>> note: in expansion of macro 'list_for_each_entry'
>>    list_for_each_entry((sd), &(v4l2_dev)->subdevs, list) \
>>    ^
>> /root/v4l2/media_build/v4l/../linux/include/media/v4l2-device.h:184:3:
>> note: in expansion of macro '__v4l2_device_call_subdevs_p'
>>    __v4l2_device_call_subdevs_p(v4l2_dev, __sd,  \
>>    ^
>> /root/v4l2/media_build/v4l/au0828-video.c:1121:2: note: in expansion
>> of macro 'v4l2_device_call_all'
>>   v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
>>   ^
>> In file included from include/linux/module.h:9:0,
>>                  from /root/v4l2/media_build/v4l/au0828-video.c:31:
>> /root/v4l2/media_build/v4l/au0828-video.c:1121:27: error: 'struct
>> au0828_dev' has no member named 'v4l2_dev'
>>   v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
>>                            ^
>> include/linux/list.h:420:24: note: in definition of macro 'list_for_each_entry'
>>        &pos->member != (head);  \
>>                         ^
>> /root/v4l2/media_build/v4l/../linux/include/media/v4l2-device.h:184:3:
>> note: in expansion of macro '__v4l2_device_call_subdevs_p'
>>    __v4l2_device_call_subdevs_p(v4l2_dev, __sd,  \
>>    ^
>> /root/v4l2/media_build/v4l/au0828-video.c:1121:2: note: in expansion
>> of macro 'v4l2_device_call_all'
>>   v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
>>   ^
>> /root/v4l2/media_build/v4l/au0828-video.c: In function 'au0828_v4l2_poll':
>> /root/v4l2/media_build/v4l/au0828-video.c:1171:2: error: implicit
>> declaration of function 'poll_requested_events'
>> [-Werror=implicit-function-declaration]
>>   unsigned long req_events = poll_requested_events(wait);
>>   ^
>>
>>
>> On Sun, Jul 27, 2014 at 12:23 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 07/27/2014 08:47 AM, Isaac Nickaein wrote:
>>>> Hello,
>>>>
>>>> I get the following error when I try to build the V4L2 on Kernel
>>>> 3.0.36+ for ARM architecture:
>>>>
>>>> /root/v4l2/media_build/v4l/altera.c:2417:5: error: redefinition of 'altera_init'
>>>>  int altera_init(struct altera_config *config, const struct firmware *fw)
>>>>      ^
>>>> In file included from /root/v4l2/media_build/v4l/altera.c:32:0:
>>>> /root/v4l2/media_build/v4l/../linux/include/misc/altera.h:41:19: note:
>>>> previous definition of 'altera_init' was here
>>>>  static inline int altera_init(struct altera_config *config,
>>>>                    ^
>>>>
>>>>
>>>> I checked the altera.h code and apparently, the IS_ENABLED macro is
>>>> not defined and causes this problem. I have prepared kernel source at
>>>> /lib/modules/3.0.36+/build/ and it builds successfully.
>>>>
>>>> Can anyone help me on this issue?
>>>
>>> What kernel tree are you using? There is no IS_ENABLED in 3.0, so apparently
>>> you have a patched kernel. Do you actually need that altera driver? If not,
>>> then why not disable it in the kernel config?
>>>
>>> Regards,
>>>
>>>         Hans
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
