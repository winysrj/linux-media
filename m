Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58501 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab2AKPSR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 10:18:17 -0500
Received: from localhost.localdomain (unknown [91.178.113.85])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id E9CF135996
	for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 15:18:15 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 0/3] compat_ioctl32 support for custom ioctls
Date: Wed, 11 Jan 2012 16:18:37 +0100
Message-Id: <1326295120-15391-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the second version of the compat_ioctl32 support for V4L2 custom ioctls
support. Compared to v1, the compat_ioctl operation has been renamed to
compat_ioctl32.

Laurent Pinchart (3):
  v4l: Add custom compat_ioctl32 operation
  uvcvideo: Return -ENOTTY in case of unknown ioctl
  uvcvideo: Implement compat_ioctl32 for custom ioctls

 drivers/media/video/uvc/uvc_v4l2.c        |  207 ++++++++++++++++++++++++++++-
 drivers/media/video/v4l2-compat-ioctl32.c |   13 ++-
 include/media/v4l2-dev.h                  |    3 +
 3 files changed, 219 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

