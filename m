Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1388 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbaGQIJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 04:09:46 -0400
Received: from tschai.lan (173-38-208-170.cisco.com [173.38.208.170])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6H89f1i053695
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 10:09:44 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 7D0912A1FD1
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 10:09:40 +0200 (CEST)
Message-ID: <53C784C4.2020904@xs4all.nl>
Date: Thu, 17 Jul 2014 10:09:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] A bunch of
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are all little fixes for issues I found while working on the vivi
replacement +  some docbook fixes.

Usually all for fairly obscure corner cases, but that's what you write a
test driver for, after all.

Regards,

	Hans

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks (2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git core-fixes

for you to fetch changes up to 2eb86fa0840ac281cc5ca0a63f1339fa00245c7d:

  v4l2-ioctl.c: check vfl_type in ENUM_FMT. (2014-07-14 14:55:47 +0200)

----------------------------------------------------------------
Hans Verkuil (12):
      DocBook media: fix wrong spacing
      DocBook media: add missing dqevent src_change field.
      DocBook media: fix incorrect header reference
      v4l2-ioctl: call g_selection before calling cropcap
      v4l2-ioctl: clips, clipcount and bitmap should not be zeroed.
      v4l2-ioctl: clear reserved field of G/S_SELECTION.
      v4l2-ioctl: remove pointless INFO_FL_CLEAR.
      v4l2-dev: don't debug poll unless the debug level > 2
      videodev2.h: add V4L2_FIELD_HAS_T_OR_B macro
      v4l2-dev: streamon/off is only a valid ioctl for video, vbi and sdr
      v4l2-ioctl.c: fix enum_freq_bands handling
      v4l2-ioctl.c: check vfl_type in ENUM_FMT.

 Documentation/DocBook/media/v4l/pixfmt.xml             |   2 +-
 Documentation/DocBook/media/v4l/selection-api.xml      |  95 ++++++++++++++++++++++++++++++++-------------------------------
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml     |   6 ++++
 Documentation/DocBook/media/v4l/vidioc-g-selection.xml |  40 +++++++++++++--------------
 drivers/media/v4l2-core/v4l2-dev.c                     |   6 ++--
 drivers/media/v4l2-core/v4l2-ioctl.c                   | 103 +++++++++++++++++++++++++++++++++++++++++++++------------------------
 include/uapi/linux/videodev2.h                         |   4 +++
 7 files changed, 148 insertions(+), 108 deletions(-)
