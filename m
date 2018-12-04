Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52708 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbeLDNdG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 08:33:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [GIT PULL FOR v4.21] uvcvideo updates, part 2
Date: Tue, 04 Dec 2018 15:33:37 +0200
Message-ID: <1894973.pJ2Bl7CWkv@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 9b90dc85c718443a3e573a0ccf55900ff4fa73ae:

  media: seco-cec: add missing header file to fix build (2018-12-03 15:11:00 
-0500)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/async

for you to fetch changes up to e1b1c84504a76ea48ac0f459c5efb64935dc3dde:

  media: uvcvideo: Utilise for_each_uvc_urb iterator (2018-12-04 15:11:15 
+0200)

----------------------------------------------------------------
Kieran Bingham (10):
      media: uvcvideo: Refactor URB descriptors
      media: uvcvideo: Convert decode functions to use new context structure
      media: uvcvideo: Protect queue internals with helper
      media: uvcvideo: queue: Simplify spin-lock usage
      media: uvcvideo: queue: Support asynchronous buffer handling
      media: uvcvideo: Abstract streaming object lifetime
      media: uvcvideo: Move decode processing to process context
      media: uvcvideo: Split uvc_video_enable into two
      media: uvcvideo: Rename uvc_{un,}init_video()
      media: uvcvideo: Utilise for_each_uvc_urb iterator

 drivers/media/usb/uvc/uvc_driver.c |  65 ++++++++---
 drivers/media/usb/uvc/uvc_isight.c |   6 +-
 drivers/media/usb/uvc/uvc_queue.c  | 110 ++++++++++++++----
 drivers/media/usb/uvc/uvc_video.c  | 274 ++++++++++++++++++++++-------------
 drivers/media/usb/uvc/uvcvideo.h   |  65 +++++++++--
 5 files changed, 369 insertions(+), 151 deletions(-)

-- 
Regards,

Laurent Pinchart
