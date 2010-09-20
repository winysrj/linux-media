Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4676 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab0ITVhZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Sep 2010 17:37:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCHES] First version of the V4L2 core locking patches
Date: Mon, 20 Sep 2010 23:37:01 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009202337.01948.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

I've made a first version of the core locking patches available here:

http://git.linuxtv.org/hverkuil/v4l-dvb.git?a=shortlog;h=refs/heads/test

I'm actually surprised how trivial the patches are. Which makes me wonder if
I am overlooking something, it feels too easy.

One thing I did not yet have time to analyze fully is if it is really OK to
unlock/relock the vdev_lock in videobuf_waiton. I hope it is, because without
this another thread will find it impossible to access the video node while it
is in waiton.

Currently I've only tested with vivi. I hope to be able to spend more time
this week for a more thorough analysis and converting a few more drivers to
this.

In the meantime, please feel free to shoot at this code!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
