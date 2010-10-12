Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:33824 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab0JLPXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Oct 2010 11:23:05 -0400
Received: from lancelot.localnet (unknown [91.178.99.53])
	by perceval.irobotique.be (Postfix) with ESMTPSA id C4C1035CA9
	for <linux-media@vger.kernel.org>; Tue, 12 Oct 2010 15:23:02 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] uvcvideo driver patches for 2.6.37
Date: Tue, 12 Oct 2010 17:22:59 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010121723.00285.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

This series has been posted on the linux-media mailing list on Wednesday the
6th of October as

"[PATCH 00/14] uvcvideo patches for 2.6.37"

PAtch 08/14 has been modified to generate sequence numbers starting at 0, as
required by the V4L2 specification. The series is otherwise unmodified.

The following changes since commit 9147e3dbca0712a5435cd2ea7c48d39344f904eb:

  V4L/DVB: cx231xx: use core-assisted lock (2010-10-09 15:30:10 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Laurent Pinchart (13):
      uvcvideo: Fix support for Medion Akoya All-in-one PC integrated webcam
      uvcvideo: Restrict frame rates for Chicony CNF7129 webcam
      uvcvideo: Blacklist more controls for Hercules Dualpix Exchange
      uvcvideo: Constify the uvc_entity_match_guid arguments
      uvcvideo: Print query name in uvc_query_ctrl()
      uvcvideo: Update e-mail address and copyright notices
      uvcvideo: Set bandwidth to at least 1024 with the FIX_BANDWIDTH quirk
      uvcvideo: Generate discontinuous sequence numbers when frames are lost
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
