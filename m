Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2753 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab2DSPtl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 11:49:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.5] Various fixes
Date: Thu, 19 Apr 2012 17:48:51 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Manjunath Hadli <manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204191748.51323.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While I was cleaning up some older drivers I came across a few bugs that are
fixed here. The fixes are all trivial one-liners.

Regards,

	Hans

The following changes since commit f4d4e7656b26a6013bc5072c946920d2e2c44e8e:

  [media] em28xx: Make em28xx-input.c a separate module (2012-04-10 20:45:41 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git fixes

for you to fetch changes up to f85e735051e71410bfd695536a25c1013bceeabc:

  vivi: fix duplicate line. (2012-04-19 17:38:52 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      V4L: fix incorrect refcounting.
      V4L2: drivers implementing vidioc_default should also return -ENOTTY
      v4l2-ctrls.c: zero min/max/step/def values for 64 bit integers.
      vivi: fix duplicate line.

 Documentation/video4linux/v4l2-framework.txt |   14 +++++++++-----
 drivers/media/radio/dsbr100.c                |    1 -
 drivers/media/radio/radio-keene.c            |    1 -
 drivers/media/video/cx18/cx18-ioctl.c        |    2 +-
 drivers/media/video/davinci/vpfe_capture.c   |    2 +-
 drivers/media/video/ivtv/ivtv-ioctl.c        |    2 +-
 drivers/media/video/meye.c                   |    2 +-
 drivers/media/video/mxb.c                    |    2 +-
 drivers/media/video/v4l2-ctrls.c             |    1 +
 drivers/media/video/vivi.c                   |    2 +-
 10 files changed, 16 insertions(+), 13 deletions(-)
