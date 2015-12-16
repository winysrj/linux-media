Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43007 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739AbbLPIeT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 03:34:19 -0500
Received: from avalon.localnet (unknown [207.140.26.138])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 9CEFA2089A
	for <linux-media@vger.kernel.org>; Wed, 16 Dec 2015 09:34:16 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.5] uvcvideo fixes
Date: Wed, 16 Dec 2015 10:34:15 +0200
Message-ID: <2036755.YzEXZnQRn7@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 991ce92f8de24cde063d531246602b6e14d3fef2:

  [media] use https://linuxtv.org for LinuxTV URLs (2015-12-04 10:38:59 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to 0f7c221741d0bd27aa658604fa5e1a660de87115:

  uvcvideo: small cleanup in uvc_video_clock_update() (2015-12-14 04:00:19 
+0200)

----------------------------------------------------------------
Anton V. Shokurov (1):
      uvcvideo: Fix reading the current exposure value of UVC

Dan Carpenter (1):
      uvcvideo: small cleanup in uvc_video_clock_update()

 drivers/media/usb/uvc/uvc_ctrl.c  | 3 ++-
 drivers/media/usb/uvc/uvc_video.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart

