Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4478 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2FXL1o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:27:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Anatolij Gustschin <agust@denx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sensoray Linux Development <linux-dev@sensoray.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	mitov@issp.bas.bg
Subject: [RFC PATCH 00/26] Remove the V4L2_FL_LOCK_ALL_FOPS flag
Date: Sun, 24 Jun 2012 13:25:52 +0200
Message-Id: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

In the 3.5 kernel a change was made regarding core locking (i.e. how locking
is done if the 'lock' field is set in struct video_device). Before kernel 3.5
all file operations would be locked in that case. But this turned out to be
problematic, adding unnecessary latencies in some cases (poll) and potentially
introducing a deadlock in mmap: the kernel takes the mm semaphore before calling
the driver's file operation, where the core lock is taken, whereas other file
ops take the core lock first, and in case of a page fault the mm semaphore
will be taken. This scenario is very unlikely, but the lockdep checker will
complain about it.

So in kernel 3.5 we decided not to take the core lock anymore for file
operations other than unlocked_ioctl. Instead the driver will have to do
the locking. As a temporary measure the flag V4L2_FL_LOCK_ALL_FOPS was
introduced that, if set, would force the core to take the lock anyway for
all file operations. In other words, drivers that were not converted yet
to do their own locking for non-unlocked_ioctl file operations would just
set this flag and keep the old behavior.

This patch series goes through all those drivers and pushed the locking
down into the driver and removes this legacy flag.

These patches just push the locking down and do not do anything smart (except
for some additional dead code removal in saa7146, or if I was 100% certain no
locking was needed for a particular file operation). In particular for mmap
it will still take the core lock, it just does it in the driver now, making it
easier to change in a future patch.

I have already tested ivtv, saa7146, cpia2, usbvision, em28xx, tm6000,
mem2mem_testdev and cx231xx. I hope to test vpif_capture/display tomorrow.

The others need to be tested and/or reviewed by others (i.e. you!).

I'd really want to get rid of this flag as soon as possible as it makes the
v4l2 core lock handling unnecessarily complex, and it also complicates the
core and vb2 enhancements patch series I am working on:

http://www.spinics.net/lists/linux-media/msg49299.html

So please take a look, test if you can, and let me know if it is OK.

Regards,

	Hans

