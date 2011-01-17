Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1169 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab1AQXay (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 18:30:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] Implement kref counting for video nodes and use in dsbr100
Date: Tue, 18 Jan 2011 00:30:41 +0100
Cc: David Ellingsworth <david@identd.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101180030.41625.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

These patches where posted as RFC on January 3rd. I thought I made a pull 
request for them since that time since there were no comments. It turned
out I didn't, so here it is.

The new v4l2_device release function is needed for any hotpluggable device
that has more than one device node. It makes it easy to write just one
single cleanup function. It is also needed to do safe device node
unregistration in disconnect functions.

Regards,

	Hans

The following changes since commit 5e3e7cceb14392123c7bb9638038d4a0574bb295:
  Hans Verkuil (1):
        [media] v4l2-device: fix 'use-after-freed' oops

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git dsbr100

Hans Verkuil (4):
      v4l2-device: add kref and a release function
      v4l2-framework.txt: document new v4l2_device release() callback
      dsbr100: convert to unlocked_ioctl
      dsbr100: ensure correct disconnect sequence.

 Documentation/video4linux/v4l2-framework.txt |   15 +++
 drivers/media/radio/dsbr100.c                |  128 ++++++++------------------
 drivers/media/video/v4l2-dev.c               |    8 ++
 drivers/media/video/v4l2-device.c            |   15 +++
 include/media/v4l2-device.h                  |   11 ++
 5 files changed, 87 insertions(+), 90 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
