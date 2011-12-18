Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40193 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1LRXzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Dec 2011 18:55:48 -0500
Received: from localhost.localdomain (unknown [91.178.220.210])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 14EF735B89
	for <linux-media@vger.kernel.org>; Sun, 18 Dec 2011 23:55:47 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 0/3] compat_ioctl support for custom ioctls
Date: Mon, 19 Dec 2011 00:55:43 +0100
Message-Id: <1324252546-18437-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's an RFC patch set that implements compat_ioctl support in V4L2 for custom
ioctls. While trying to support the UVCIOC_* ioctls with a 32-bit userspace and
a 64-bit kernel, I realized this wasn't possible due to missing support in the
V4L2 core.

Laurent Pinchart (3):
  v4l: Add custom compat_ioctl operation
  uvcvideo: Return -ENOTTY in case of unknown ioctl
  uvcvideo: Implement compat_ioctl for custom ioctls

 drivers/media/video/uvc/uvc_v4l2.c        |  207 ++++++++++++++++++++++++++++-
 drivers/media/video/v4l2-compat-ioctl32.c |   13 ++-
 include/media/v4l2-dev.h                  |    3 +
 3 files changed, 219 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

