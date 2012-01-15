Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40080 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2AOSNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 13:13:09 -0500
Received: from localhost.localdomain (unknown [91.178.228.121])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 01F2E35995
	for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 18:13:07 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 0/3] compat_ioctl32 support for custom ioctls
Date: Sun, 15 Jan 2012 19:13:10 +0100
Message-Id: <1326651193-12055-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the third version of the compat_ioctl32 support for V4L2 custom ioctls
support. Compared to v2, the v4l2-compat-ioctl32 module has been merged into
videodev to avoid circular modules dependencies (and also because having two
separate modules didn't make much sense).

Laurent Pinchart (3):
  v4l: Add custom compat_ioctl32 operation
  uvcvideo: Return -ENOTTY in case of unknown ioctl
  uvcvideo: Implement compat_ioctl32 for custom ioctls

 drivers/media/video/Makefile              |    7 +-
 drivers/media/video/uvc/uvc_v4l2.c        |  207 ++++++++++++++++++++++++++++-
 drivers/media/video/v4l2-compat-ioctl32.c |   20 ++--
 include/media/v4l2-dev.h                  |    3 +
 4 files changed, 223 insertions(+), 14 deletions(-)

-- 
Regards,

Laurent Pinchart

