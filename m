Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1046 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2EFM2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 08:28:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [RFCv2 PATCH 00/17] gspca: allow use of control framework and other fixes
Date: Sun,  6 May 2012 14:28:14 +0200
Message-Id: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here is my second version of this patch series.

Thanks to Hans de Goede for his help.

Changes since v1:

- HdG provided some patches that fix zc3xx-related jpeg problems
- controls are now initialized in a new cam_op: init_controls
- converted the stv06xx and mars drivers as well
- switched to V4L2 core locking, except for the DQBUF/QBUF/QUERYBUF ioctls.

Regarding locking: there are two possible methods: either do it all in the
driver, or use the V4L2 core serialization lock. Using the core lock is easy,
but, as HdG pointed out to me, it can introduce unnecessary latency if you
try to dequeue a buffer that is available, but someone else is changing a
control at the same time and is holding the core lock.

The problem on the other hand with driver locking is that in order to change
values in a control handler in the driver (which happens frequently in gspca),
you need to call v4l2_ctrl_[gs]_ctrl in order to correctly take a mutex in the
control handler, preventing someone else from changing the control at the same
time.

Since the driver needs to take its own lock when setting a control you run
into a problem: calling v4l2_ctrl_[gs]_ctrl can only be done if you are not
holding your driver lock, otherwise the s_ctrl op that actually sets the new
control value will also try to get that same lock: deadlock!

It's possible to solve this, but that requires pushing all the locking down
into the subdrivers. And that's a lot of work.

Instead I decided to make it possible to skip taking the core lock for
selected ioctls. The first patch adds that functionality.

This works much better and reduces the code size instead of adding to it.

Tested all four subdrivers with suspend/resume.

HdG: I propose that you take over unless you disagree with my locking changes
or if there are new things that crop up.

The git tree is here: git://linuxtv.org/hverkuil/media_tree.git gspca3

I will take on the first two core patches (I've got some more in that area
as well) and process them myself.

Regards,

	Hans

