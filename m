Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39750 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab0KUUct (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 15:32:49 -0500
Received: from localhost.localdomain (unknown [91.178.49.10])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5728B35C96
	for <linux-media@vger.kernel.org>; Sun, 21 Nov 2010 20:32:48 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] [FOR 2.6.37] uvcvideo: BKL removal
Date: Sun, 21 Nov 2010 21:32:48 +0100
Message-Id: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi everybody,

Here are 5 patches to the uvcvideo driver that implements proper locking where
it was missing and switch from ioctl to unlocked_ioctl, getting rid of the BKL.

As locking can be tricky, patch review would be appreciated.

Laurent Pinchart (5):
  uvcvideo: Lock controls mutex when querying menus
  uvcvideo: Move mutex lock/unlock inside uvc_free_buffers
  uvcvideo: Move mmap() handler to uvc_queue.c
  uvcvideo: Lock stream mutex when accessing format-related information
  uvcvideo: Convert to unlocked_ioctl

 drivers/media/video/uvc/uvc_ctrl.c  |   48 +++++++++-
 drivers/media/video/uvc/uvc_queue.c |  133 +++++++++++++++++++++-----
 drivers/media/video/uvc/uvc_v4l2.c  |  183 +++++++++++------------------------
 drivers/media/video/uvc/uvc_video.c |    3 -
 drivers/media/video/uvc/uvcvideo.h  |   10 ++-
 5 files changed, 221 insertions(+), 156 deletions(-)

-- 
Regards,

Laurent Pinchart

