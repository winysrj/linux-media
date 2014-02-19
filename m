Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50400 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbaBSRdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 12:33:43 -0500
Received: from avalon.localnet (unknown [91.178.208.133])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id A8B4B35A46
	for <linux-media@vger.kernel.org>; Wed, 19 Feb 2014 18:32:42 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.15] uvcvideo patches
Date: Wed, 19 Feb 2014 18:34:54 +0100
Message-ID: <12009046.L1L9DmOzHD@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

  [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

for you to fetch changes up to b7857d4ea90742c5a756c12b3fc34c9caf1b942c:

  uvcvideo: Enable VIDIOC_CREATE_BUFS (2014-02-19 18:33:49 +0100)

----------------------------------------------------------------
Laurent Pinchart (2):
      uvcvideo: Remove duplicate check for number of buffers in queue_setup
      uvcvideo: Support allocating buffers larger than the current frame size

Oliver Neukum (1):
      uvcvideo: Simplify redundant check

Philipp Zabel (1):
      uvcvideo: Enable VIDIOC_CREATE_BUFS

Thomas Pugliese (1):
      uvcvideo: Update uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS 
devices

 drivers/media/usb/uvc/uvc_driver.c |  2 +-
 drivers/media/usb/uvc/uvc_queue.c  | 20 +++++++++++++++++---
 drivers/media/usb/uvc/uvc_v4l2.c   | 11 +++++++++++
 drivers/media/usb/uvc/uvc_video.c  |  3 +++
 drivers/media/usb/uvc/uvcvideo.h   |  4 ++--
 5 files changed, 34 insertions(+), 6 deletions(-)

-- 
Regards,

Laurent Pinchart

