Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52212 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1KDMqS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 08:46:18 -0400
Received: from localhost.localdomain (unknown [91.178.160.144])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D558435997
	for <linux-media@vger.kernel.org>; Fri,  4 Nov 2011 12:46:16 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/6] uvcvideo: Miscellaneous fixes
Date: Fri,  4 Nov 2011 13:46:11 +0100
Message-Id: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here are miscellaneous fixes that were sleeping in dark corners of my git
trees. They're pretty straightforward, and I intend to push them to v3.3.

The patches are based on top of the videobuf2 conversion patches that I've
previously posted to the list. As I haven't received any comment I'll assume
they're perfect, so there's no need to repost them ;-)

Laurent Pinchart (6):
  uvcvideo: Handle uvc_init_video() failure in uvc_video_enable()
  uvcvideo: Remove duplicate definitions of UVC_STREAM_* macros
  uvcvideo: Add support for LogiLink Wireless Webcam
  uvcvideo: Make uvc_commit_video() static
  uvcvideo: Don't skip erroneous payloads
  uvcvideo: Ignore GET_RES error for XU controls

 drivers/media/video/uvc/uvc_ctrl.c   |   17 +++++++++++++-
 drivers/media/video/uvc/uvc_driver.c |    9 ++++++++
 drivers/media/video/uvc/uvc_video.c  |   37 ++++++++++++++-------------------
 drivers/media/video/uvc/uvcvideo.h   |    3 +-
 4 files changed, 41 insertions(+), 25 deletions(-)

-- 
Regards,

Laurent Pinchart

