Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1959 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1ASL7v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 06:59:51 -0500
Message-ID: <697cdbf8159360de2a68ca7ce3adb329.squirrel@webmail.xs4all.nl>
In-Reply-To: <4D36CA70.8060204@redhat.com>
References: <201101190839.15175.hverkuil@xs4all.nl>
    <4D36CA70.8060204@redhat.com>
Date: Wed, 19 Jan 2011 12:59:39 +0100
Subject: Re: video_device -> v4l2_devnode rename
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Em 19-01-2011 05:39, Hans Verkuil escreveu:
>> Hi Mauro,
>>
>> We want to rename video_device to v4l2_devnode. So let me know when I
>> can
>> finalize my patches and, most importantly, against which branch.
>>
>> My current tree:
>>
>> http://git.linuxtv.org/hverkuil/media_tree.git?a=shortlog;h=refs/heads/devnode2
>>
>> tracks for_2.6.38-rc1 and should apply cleanly at the moment.
>
> Even not being able to handle it for .38, I did a look on the proposed
> changes. I'm not convinced about those renaming stuff.
>
> By looking on other subsystems, it seems to me that
> video_device_register()
> is a better name than any other name. Btw, by far, the use of _node for
> the
> device registration on Linux kernel is not usual at all:
>
> $ git grep -e "_register"  --and -e "(" --and -e "node" include |grep -v
> "of_mdiobus_register("
> include/linux/compaction.h:extern int compaction_register_node(struct node
> *node);
> include/linux/compaction.h:static inline int
> compaction_register_node(struct node *node)
> include/linux/swap.h:extern int scan_unevictable_register_node(struct node
> *node);
> include/linux/swap.h:static inline int
> scan_unevictable_register_node(struct node *node)
>
> There are only 2 functions using it. On those, the "node" at the function
> register name is due to "struct node", and they likely make sense.
>
> A seek for *register*device or *device*register patterns show a lot:
>
> $ git grep -e "_register_device"  --and -e "("  include|wc -l
> 28
>
> $ git grep -e "_device_register"  --and -e "("  include|wc -l
> 32
>
> Basically, what I'm trying to say is that, on all subsystems, the function
> that creates
> the devices is called *register*device or *device*register.
>
> Why should we adopt anything different than the kernel convention for
> V4L2?

I'm sure we went through this before.

1) the name originates from the time that drivers had only one video node.
It makes little sense anymore when drivers can create many video, radio,
vbi and later v4l-subdev nodes. The key thing is that this driver
registers a V4L2 node.

2) struct v4l2_device and struct video_device look too similar. While
v4l2_device represents the whole V4L2 hardware, the video_device
represents the video/radio/vbi/... device node only.

3) (less important) all types/functions within the v4l2 framework now have
the v4l2_ prefix, except this one. Aligning this will make everything more
consistent and recognizable.

We're not like most other subsystems where often just a single device node
is registered. We have much more complex hardware. So I think that
'v4l2_devnode' much more clearly identifies what it represents than
'video_device'.

Regards,

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

