Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47230 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826Ab1JXPle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 11:41:34 -0400
Received: from localhost.localdomain (unknown [85.13.70.251])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 06DF735B60
	for <linux-media@vger.kernel.org>; Mon, 24 Oct 2011 15:41:33 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] uvcvideo: videobuf2-vmalloc support
Date: Mon, 24 Oct 2011 17:42:02 +0200
Message-Id: <1319470924-15703-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

The subject says it all. Now you can only blame me for not using video_ioctl2
(which I'm currently evaluating btw...) and the control framework :-)

Laurent Pinchart (2):
  uvcvideo: Move fields from uvc_buffer::buf to uvc_buffer
  uvcvideo: Use videobuf2-vmalloc

 drivers/media/video/uvc/Kconfig      |    1 +
 drivers/media/video/uvc/uvc_isight.c |   10 +-
 drivers/media/video/uvc/uvc_queue.c  |  554 +++++++++-------------------------
 drivers/media/video/uvc/uvc_v4l2.c   |   19 +-
 drivers/media/video/uvc/uvc_video.c  |   30 +-
 drivers/media/video/uvc/uvcvideo.h   |   37 +--
 6 files changed, 181 insertions(+), 470 deletions(-)

-- 
Regards,

Laurent Pinchart

