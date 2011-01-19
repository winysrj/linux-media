Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:43348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab1ASL04 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 06:26:56 -0500
Message-ID: <4D36CA70.8060204@redhat.com>
Date: Wed, 19 Jan 2011 09:26:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: video_device -> v4l2_devnode rename
References: <201101190839.15175.hverkuil@xs4all.nl>
In-Reply-To: <201101190839.15175.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-01-2011 05:39, Hans Verkuil escreveu:
> Hi Mauro,
> 
> We want to rename video_device to v4l2_devnode. So let me know when I can
> finalize my patches and, most importantly, against which branch.
> 
> My current tree:
> 
> http://git.linuxtv.org/hverkuil/media_tree.git?a=shortlog;h=refs/heads/devnode2
> 
> tracks for_2.6.38-rc1 and should apply cleanly at the moment.

Even not being able to handle it for .38, I did a look on the proposed
changes. I'm not convinced about those renaming stuff.

By looking on other subsystems, it seems to me that video_device_register()
is a better name than any other name. Btw, by far, the use of _node for the
device registration on Linux kernel is not usual at all:

$ git grep -e "_register"  --and -e "(" --and -e "node" include |grep -v "of_mdiobus_register("
include/linux/compaction.h:extern int compaction_register_node(struct node *node);
include/linux/compaction.h:static inline int compaction_register_node(struct node *node)
include/linux/swap.h:extern int scan_unevictable_register_node(struct node *node);
include/linux/swap.h:static inline int scan_unevictable_register_node(struct node *node)

There are only 2 functions using it. On those, the "node" at the function 
register name is due to "struct node", and they likely make sense.

A seek for *register*device or *device*register patterns show a lot:

$ git grep -e "_register_device"  --and -e "("  include|wc -l
28

$ git grep -e "_device_register"  --and -e "("  include|wc -l
32

Basically, what I'm trying to say is that, on all subsystems, the function that creates
the devices is called *register*device or *device*register.

Why should we adopt anything different than the kernel convention for V4L2?

Cheers,
Mauro
