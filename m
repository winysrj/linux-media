Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48872 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab0JFI7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:39 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 6537235CA5
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:38 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/14] uvcvideo patches for 2.6.37
Date: Wed,  6 Oct 2010 10:59:38 +0200
Message-Id: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Here's a bunch of uvcvideo patches for 2.6.37, including bug fixes (the first 2
patches should already be queued for 2.6.36), buggy camera workarounds, locking
fixes and core driver changes.

I will send a pull request on Friday.

Laurent Pinchart (13):
  uvcvideo: Fix support for Medion Akoya All-in-one PC integrated
    webcam
  uvcvideo: Restrict frame rates for Chicony CNF7129 webcam
  uvcvideo: Blacklist more controls for Hercules Dualpix Exchange
  uvcvideo: Constify the uvc_entity_match_guid arguments
  uvcvideo: Print query name in uvc_query_ctrl()
  uvcvideo: Update e-mail address and copyright notices
  uvcvideo: Set bandwidth to at least 1024 with the FIX_BANDWIDTH quirk
  uvcvideo: Generate discontinuous sequence numbers when frames are
    lost
  uvcvideo: Hardcode the index/selector relationship for XU controls
  uvcvideo: Embed uvc_control_info inside struct uvc_control
  uvcvideo: Delay initialization of XU controls
  uvcvideo: Fix bogus XU controls information
  uvcvideo: Fix uvc_query_v4l2_ctrl() and uvc_xu_ctrl_query() locking

Martin Rubli (1):
  uvcvideo: Remove sysadmin requirements for UVCIOC_CTRL_MAP

 drivers/media/video/uvc/uvc_ctrl.c   |  712 ++++++++++++++++++++--------------
 drivers/media/video/uvc/uvc_driver.c |   42 ++-
 drivers/media/video/uvc/uvc_isight.c |    2 +-
 drivers/media/video/uvc/uvc_queue.c  |   11 +-
 drivers/media/video/uvc/uvc_status.c |    4 +-
 drivers/media/video/uvc/uvc_v4l2.c   |   56 +--
 drivers/media/video/uvc/uvc_video.c  |   52 +++-
 drivers/media/video/uvc/uvcvideo.h   |   41 +--
 8 files changed, 528 insertions(+), 392 deletions(-)

-- 
Regards,

Laurent Pinchart

