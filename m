Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37639 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaIOH6P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 03:58:15 -0400
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id D2CDA20015
	for <linux-media@vger.kernel.org>; Mon, 15 Sep 2014 09:57:07 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.18] [v2] uvcvideo changes
Date: Mon, 15 Sep 2014 10:58:17 +0300
Message-ID: <1451883.FNpbBCZE1z@avalon>
In-Reply-To: <352565057.M5lg4dyeH3@avalon>
References: <352565057.M5lg4dyeH3@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request supersedes the "[GIT PULL FOR v3.18] uvcvideo changes" 
pull request, adding one additional patch from Guennadi.

The following changes since commit 91f96e8b7255537da3a58805cf465003521d7c5f:

  [media] tw68: drop bogus cpu_to_le32() call (2014-09-08 16:40:54 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to fb1ebddc0d84f77a2d6433d982c56ae7f3b5620e:

  v4l2: uvcvideo: Allow using larger buffers (2014-09-11 00:04:39 +0300)

----------------------------------------------------------------
Guennadi Liakhovetski (1):
      v4l2: uvcvideo: Allow using larger buffers

Paul Fertser (1):
      media: usb: uvc: add a quirk for Dell XPS M1330 webcam

Vincent Palatin (2):
      v4l: Add camera pan/tilt speed controls
      v4l: uvcvideo: Add support for pan/tilt speed controls

William Manley (1):
      uvcvideo: Work around buggy Logitech C920 firmware

 Documentation/DocBook/media/v4l/compat.xml   | 10 ++++++
 Documentation/DocBook/media/v4l/controls.xml | 21 +++++++++++++
 drivers/media/usb/uvc/uvc_ctrl.c             | 60 ++++++++++++++++++++++++---
 drivers/media/usb/uvc/uvc_driver.c           | 20 +++++++++++-
 drivers/media/usb/uvc/uvc_v4l2.c             |  1 +
 drivers/media/usb/uvc/uvc_video.c            |  8 ++++-
 drivers/media/usb/uvc/uvcvideo.h             |  5 ++-
 drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
 include/uapi/linux/v4l2-controls.h           |  2 ++
 9 files changed, 122 insertions(+), 7 deletions(-)

-- 
Regards,

Laurent Pinchart

