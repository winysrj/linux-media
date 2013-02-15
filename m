Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4712 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935453Ab3BOIl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 03:41:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.9] tlg2300 compliancy fixes
Date: Fri, 15 Feb 2013 09:41:20 +0100
Cc: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302150941.20918.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Last year I worked on this driver to improve it and fix v4l2-compliance
issues.

It required a lot of effort to even find a USB stick with this chipset
(telegent no longer exists) and unfortunately at some point I managed
to break the USB stick, so I am no longer able to work on it.

This patch series represents that part of the work I've done that has
been tested. I have additional patches in my tlg2300-wip branch:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/tlg2300-wip

but since I am no longer certain at what point in those remaining patches
things broke down I've decided not to post them for upstreaming. If I or
someone else ever manages to get a working tlg2300 that code might be used
for further work.

The only really important thing that still needs to be changed in this driver
is that the video nodes still use .ioctl instead of .unlocked_ioctl. That
will have to be fixed at some point since .ioctl really needs to go.

The code in this pull request is identical to what was posted here:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/60164

and with these two changes:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg58433.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg58435.html

Huang, it would be nice if you could Ack these two. I'm going ahead with
this pull request since the changes are so minor.

Regards,

	Hans


The following changes since commit ed72d37a33fdf43dc47787fe220532cdec9da528:

  [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff) (2013-02-13 18:05:29 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tlg2300

for you to fetch changes up to 3d381d926ee06a82fd6c19bf1f8c38731539d256:

  tlg2300: update MAINTAINERS file. (2013-02-15 09:29:20 +0100)

----------------------------------------------------------------
Hans Verkuil (18):
      tlg2300: use correct device parent.
      tlg2300: fix tuner and frequency handling of the radio device.
      tlg2300: switch to unlocked_ioctl.
      tlg2300: remove ioctls that are invalid for radio devices.
      tlg2300: embed video_device instead of allocating it.
      tlg2300: add control handler for radio device node.
      tlg2300: switch to v4l2_fh.
      tlg2300: fix radio querycap
      tlg2300: add missing video_unregister_device.
      tlg2300: embed video_device.
      tlg2300: fix querycap
      tlg2300: fix frequency handling.
      tlg2300: fix missing audioset.
      tlg2300: implement the control framework.
      tlg2300: remove empty vidioc_try_fmt_vid_cap, add missing g_std.
      tlg2300: allow multiple opens.
      tlg2300: Remove logs() macro.
      tlg2300: update MAINTAINERS file.

 MAINTAINERS                           |    5 +-
 drivers/media/usb/tlg2300/pd-common.h |   26 ++----
 drivers/media/usb/tlg2300/pd-main.c   |   16 ++--
 drivers/media/usb/tlg2300/pd-radio.c  |  225 +++++++++++++++++-----------------------------------
 drivers/media/usb/tlg2300/pd-video.c  |  290 ++++++++++++++++++++++---------------------------------------------
 5 files changed, 184 insertions(+), 378 deletions(-)
