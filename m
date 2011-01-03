Return-path: <mchehab@gaivota>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4677 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab1ACORF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 09:17:05 -0500
Received: from tschai.localnet (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id p03EH2m3038374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 15:17:03 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] Fix memory leak in __video_register_device
Date: Mon, 3 Jan 2011 15:17:03 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101031517.03078.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The __video_register_device function memset()s the embedded struct device.

It is common practice for drivers to call video_set_drvdata() before the
video device node is registered. But video_set_drvdata() calls dev_set_drvdata()
in turn, and dev_set_drvdata allocates memory to store the void pointer.

The __video_register_device function makes a copy of the driver data by
calling video_get_drvdata and before memsetting the struct device to 0.
It restores it afterwards.

Unfortunately, due to the memset the memory allocated in struct device is
never freed.

This patch series fixes this situation by no longer doing the memset. This
requires that all drivers always memset the struct video_device before use.

I analyzed *all* v4l drivers and found two that do not do this properly. The
zoran driver uses kmalloc to allocate video_device (although it copies a
video_device template later, so it is actually safe. But it really should
call video_device_alloc). The w9966 driver would likely fail since after the
device is disconnected the old struct may be reused after a reconnect.

But since nobody has this parallel port webcam anymore it is unlikely anyone
would ever notice.

Note that this still does not fix the case if video_register_device bails out
before device_register is called: the memory is still leaked in that case.

But let's tackle the majority of the leaks first.

Regards,

	Hans

The following changes since commit 187134a5875df20356f4dca075db29f294115a47:
  David Henningsson (1):
        [media] DVB: IR support for TechnoTrend CT-3650

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git vdev-fix

Hans Verkuil (3):
      w9966: zero device state after a detach
      zoran: use video_device_alloc instead of kmalloc.
      v4l2-dev: don't memset video_device.dev.

 drivers/media/video/v4l2-dev.c         |    9 ++++-----
 drivers/media/video/w9966.c            |    1 +
 drivers/media/video/zoran/zoran_card.c |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
