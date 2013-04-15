Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2904 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3DOKbl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 06:31:41 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id r3FAVbbY056019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 12:31:39 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 9B59911E00F4
	for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 12:31:36 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] cx25821: driver overhaul
Date: Mon, 15 Apr 2013 12:31:36 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304151231.36707.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the full pull request for all the cx25821 changes for 3.10.
It's identical to the patch series posted Sunday, but adds one last patch
removing cx25821-audio-upstream.c from the Makefile. Hopefully I can add
that functionality back as a proper alsa device for 3.11 or 3.12 at the
latest. For now we just want to get rid of the vfs abuse.

Regards,

	Hans

The following changes since commit 4c41dab4d69fb887884dc571fd70e4ddc41774fb:

  [media] rc: fix single line indentation of keymaps/Makefile (2013-04-14 22:51:41 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cx25821

for you to fetch changes up to 8081cd12560049ff97109f3e4eb3c8bd018e8f4c:

  cx25821: remove cx25821-audio-upstream.c from the Makefile. (2013-04-15 12:23:48 +0200)

----------------------------------------------------------------
Hans Verkuil (31):
      cx25821: do not expose broken video output streams.
      cx25821: the audio channel was registered as a video node.
      cx25821: fix compiler warning
      cx25821: remove bogus radio/vbi/'video-ioctl' support.
      cx25821: remove unused fields, ioctls.
      cx25821: fix log_status, querycap.
      cx25821: make cx25821_sram_channels const.
      cx25821: remove unnecessary global devlist.
      cx25821: s_input didn't check for invalid input.
      cx25821: make lots of externals static.
      cx25821: remove cropping ioctls.
      cx25821: remove bogus dependencies.
      cx25821: embed video_device, clean up some kernel log spam
      cx25821: convert to the control framework.
      cx25821: remove TRUE/FALSE/STATUS_(UN)SUCCESSFUL defines.
      cx25821: remove unnecessary debug messages.
      cx25821: use core locking.
      cx25821: remove 'type' field from cx25821_fh.
      cx25821: move vidq from cx25821_fh to cx25821_channel.
      cx25821: replace resource management functions with fh ownership.
      cx25821: switch to v4l2_fh, add event and prio handling.
      cx25821: g/s/try/enum_fmt related fixes and cleanups.
      cx25821: remove custom ioctls that duplicate v4l2 ioctls.
      cx25821: remove references to subdevices that aren't there.
      cx25821: setup output nodes correctly.
      cx25821: group all fmt functions together.
      cx25821: prepare querycap for output support.
      cx25821: add output format ioctls.
      cx25821: drop cx25821-video-upstream-ch2.c/h.
      cx25821: replace custom ioctls with write()
      cx25821: remove cx25821-audio-upstream.c from the Makefile.

 drivers/media/pci/cx25821/Kconfig                      |    7 +-
 drivers/media/pci/cx25821/Makefile                     |    7 +-
 drivers/media/pci/cx25821/cx25821-alsa.c               |   81 +--
 drivers/media/pci/cx25821/cx25821-audio-upstream.c     |   22 +-
 drivers/media/pci/cx25821/cx25821-cards.c              |   23 -
 drivers/media/pci/cx25821/cx25821-core.c               |  133 +----
 drivers/media/pci/cx25821/cx25821-gpio.c               |    1 +
 drivers/media/pci/cx25821/cx25821-i2c.c                |    3 +-
 drivers/media/pci/cx25821/cx25821-medusa-video.c       |   46 +-
 drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c |  800 ---------------------------
 drivers/media/pci/cx25821/cx25821-video-upstream-ch2.h |  138 -----
 drivers/media/pci/cx25821/cx25821-video-upstream.c     |  519 ++++++-----------
 drivers/media/pci/cx25821/cx25821-video.c              | 1834 ++++++++++++++++---------------------------------------------
 drivers/media/pci/cx25821/cx25821-video.h              |  125 +----
 drivers/media/pci/cx25821/cx25821.h                    |  304 +++-------
 15 files changed, 790 insertions(+), 3253 deletions(-)
 delete mode 100644 drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
 delete mode 100644 drivers/media/pci/cx25821/cx25821-video-upstream-ch2.h
