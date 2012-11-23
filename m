Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43757 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2KWNDE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:03:04 -0500
Received: from avalon.localnet (unknown [91.178.103.90])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 27503359DB
	for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 14:03:03 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.8] uvcvideo patches
Date: Fri, 23 Nov 2012 14:04:04 +0100
Message-ID: <2542325.rC2MOYgHsY@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 304a0807a22852fe3095a62c24b25c4d0e16d003:

  [media] drivers/media/usb/hdpvr/hdpvr-core.c: fix error return code 
(2012-11-22 14:22:31 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Laurent Pinchart (8):
      uvcvideo: Set error_idx properly for extended controls API failures
      uvcvideo: Return -EACCES when trying to access a read/write-only control
      uvcvideo: Don't fail when an unsupported format is requested
      uvcvideo: Set device_caps in VIDIOC_QUERYCAP
      uvcvideo: Return -ENOTTY for unsupported ioctls
      uvcvideo: Add VIDIOC_[GS]_PRIORITY support
      uvcvideo: Mark first output terminal as default video node
      uvcvideo: Fix control value clamping for unsigned integer controls

 drivers/media/usb/uvc/uvc_ctrl.c   |   29 +++++++----
 drivers/media/usb/uvc/uvc_driver.c |   10 ++++
 drivers/media/usb/uvc/uvc_entity.c |    2 +
 drivers/media/usb/uvc/uvc_v4l2.c   |   89 ++++++++++++++++++++++++++++-------
 drivers/media/usb/uvc/uvc_video.c  |    1 +
 drivers/media/usb/uvc/uvcvideo.h   |    8 +++
 6 files changed, 110 insertions(+), 29 deletions(-)

-- 
Regards,

Laurent Pinchart

