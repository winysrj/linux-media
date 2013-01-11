Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37229 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3AKNMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:12:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 0/3] Fix uvcvideo revert leftovers
Date: Fri, 11 Jan 2013 14:13:57 +0100
Message-Id: <1357910040-27463-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Those three patches, for v3.8, fix leftovers of commit
ba68c8530a263dc4de440fa10bb20a1c5b9d4ff5 (Partly revert "[media] uvcvideo: Set
error_idx properly for extended controls API failures").

Hans, if you have time, could you please have a look at the patches from a
compliance point of view ? The G_EXT_CTRLS error_idx issue isn't fixed yet,
I'll send a patch for v3.9.

Laurent Pinchart (3):
  uvcvideo: Return -EACCES when trying to access a read/write-only
    control
  uvcvideo: Cleanup leftovers of partial revert
  uvcvideo: Set error_idx properly for S_EXT_CTRLS failures

 drivers/media/usb/uvc/uvc_ctrl.c |    4 +++-
 drivers/media/usb/uvc/uvc_v4l2.c |    6 ++----
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
Regards,

Laurent Pinchart

