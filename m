Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57907 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab2CBR2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 12:28:51 -0500
Received: from avalon.localnet (unknown [91.178.172.210])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8FFE97B0D
	for <linux-media@vger.kernel.org>; Fri,  2 Mar 2012 18:28:50 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2] V4L custom compat_ioctl32 support and uvcvideo changes for v3.4
Date: Fri, 02 Mar 2012 18:29:08 +0100
Message-ID: <3599272.HaRRMUkdNT@avalon>
In-Reply-To: <7606670.NSjiUfzPCc@avalon>
References: <7606670.NSjiUfzPCc@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit e8ca6d20a65d9d94693a0ed99b12d95b882dc859:

  [media] tveeprom: update hauppauge tuner list thru 181 (2012-02-28 18:46:53 
-0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

This now includes that linux/atomic.h patch from Andrew Morton that was 
forgotten in the previous pull request.

Andrew Morton (1):
      uvcvideo: uvc_driver.c: use linux/atomic.h

Javier Martin (1):
      uvcvideo: Allow userptr IO mode

Laurent Pinchart (5):
      uvcvideo: Avoid division by 0 in timestamp calculation
      v4l: Add custom compat_ioctl32 operation
      uvcvideo: Return -ENOTTY in case of unknown ioctl
      uvcvideo: Implement compat_ioctl32 for custom ioctls
      uvcvideo: Add support for Dell XPS m1530 integrated webcam

 drivers/media/video/Makefile              |    7 +-
 drivers/media/video/uvc/uvc_driver.c      |   11 ++-
 drivers/media/video/uvc/uvc_queue.c       |    2 +-
 drivers/media/video/uvc/uvc_v4l2.c        |  207 +++++++++++++++++++++++++++-
 drivers/media/video/uvc/uvc_video.c       |   14 ++-
 drivers/media/video/v4l2-compat-ioctl32.c |   20 ++--
 include/media/v4l2-dev.h                  |    3 +
 7 files changed, 243 insertions(+), 21 deletions(-)

-- 
Regards,

Laurent Pinchart

