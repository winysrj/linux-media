Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1306 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaCFHqR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 02:46:17 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id s267kEr7013377
	for <linux-media@vger.kernel.org>; Thu, 6 Mar 2014 08:46:16 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 097FE2A1887
	for <linux-media@vger.kernel.org>; Thu,  6 Mar 2014 08:46:13 +0100 (CET)
Message-ID: <531827C4.60308@xs4all.nl>
Date: Thu, 06 Mar 2014 08:46:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.15] vb2: fixes, balancing callbacks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request is identical to the REVIEWv4 series:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg72474.html

except for being rebased to the latest master branch.

Take special note: the first three patches ("vb2: Check if there are buffers before
streamon", "vb2: fix read/write regression" and "vb2: fix PREPARE_BUF regression")
are patches for 3.14 that have already been processed by you. However, this patch
series relies on them being present. I have not tried it, but I doubt if this
series applies without them being there.

This patch series adds debugging code to check for unbalanced ops and then proceeds
to fix all the bugs I found with that debugging code and some more that I found
while testing nasty streaming corner cases with v4l2-compliance.

Regards,

	Hans

The following changes since commit bfd0306462fdbc5e0a8c6999aef9dde0f9745399:

  [media] v4l: Document timestamp buffer flag behaviour (2014-03-05 16:48:28 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vb2-part1

for you to fetch changes up to 8028d16f6406661755f405c49078d6f8c93dd3ec:

  vivi: fix ENUM_FRAMEINTERVALS implementation (2014-03-05 21:45:19 +0100)

----------------------------------------------------------------
Hans Verkuil (17):
      vb2: fix read/write regression
      vb2: fix PREPARE_BUF regression
      vb2: add debugging code to check for unbalanced ops
      vb2: change result code of buf_finish to void
      pwc: do not decompress the image unless the state is DONE
      vb2: call buf_finish from __queue_cancel.
      vb2: consistent usage of periods in videobuf2-core.h
      vb2: fix buf_init/buf_cleanup call sequences
      vb2: rename queued_count to owned_by_drv_count
      vb2: don't init the list if there are still buffers
      vb2: only call start_streaming if sufficient buffers are queued
      vb2: properly clean up PREPARED and QUEUED buffers
      vb2: replace BUG by WARN_ON
      vb2: fix streamoff handling if streamon wasn't called.
      vb2: call buf_finish after the state check.
      vivi: correctly cleanup after a start_streaming failure
      vivi: fix ENUM_FRAMEINTERVALS implementation

Ricardo Ribalda Delgado (1):
      vb2: Check if there are buffers before streamon

 drivers/media/parport/bw-qcam.c                 |   6 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c         |   7 +-
 drivers/media/platform/davinci/vpbe_display.c   |   6 +-
 drivers/media/platform/davinci/vpif_capture.c   |   7 +-
 drivers/media/platform/davinci/vpif_display.c   |   7 +-
 drivers/media/platform/marvell-ccic/mcam-core.c |   3 +-
 drivers/media/platform/s5p-tv/mixer_video.c     |   6 +-
 drivers/media/platform/vivi.c                   |  18 ++-
 drivers/media/usb/pwc/pwc-if.c                  |  17 ++-
 drivers/media/usb/uvc/uvc_queue.c               |   6 +-
 drivers/media/v4l2-core/videobuf2-core.c        | 594 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 drivers/staging/media/davinci_vpfe/vpfe_video.c |   3 +-
 drivers/staging/media/go7007/go7007-v4l2.c      |   3 +-
 include/media/videobuf2-core.h                  | 113 +++++++++++----
 14 files changed, 565 insertions(+), 231 deletions(-)
