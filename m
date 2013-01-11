Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43301 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3AKNcQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:32:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 0/3] Fix uvcvideo revert leftovers
Date: Fri, 11 Jan 2013 14:33:50 +0100
Message-Id: <1357911233-31664-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Those three patches, for v3.8, fix leftovers of commit
ba68c8530a263dc4de440fa10bb20a1c5b9d4ff5 (Partly revert "[media] uvcvideo: Set
error_idx properly for extended controls API failures").

Compared to v1 only the commit message of the first patch has been changed.

Laurent Pinchart (3):
  uvcvideo: Return -EACCES when trying to set a read-only control
  uvcvideo: Cleanup leftovers of partial revert
  uvcvideo: Set error_idx properly for S_EXT_CTRLS failures

 drivers/media/usb/uvc/uvc_ctrl.c |    4 +++-
 drivers/media/usb/uvc/uvc_v4l2.c |    6 ++----
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
Regards,

Laurent Pinchart

