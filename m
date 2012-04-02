Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57287 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2DBJId (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 05:08:33 -0400
Received: from avalon.localnet (unknown [91.178.102.58])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C254D7B0D
	for <linux-media@vger.kernel.org>; Mon,  2 Apr 2012 11:08:31 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.4] uvcvideo race condition fix
Date: Mon, 02 Apr 2012 11:08:26 +0200
Message-ID: <1615008.aWoPirfL1O@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a critical fix for uvcvideo that should go in v3.4 (and be backported 
to v3.3, I've CC'ed stable@vger.kernel.org in the patch).

The following changes since commit 296da3cd14db9eb5606924962b2956c9c656dbb0:

  [media] pwc: poll(): Check that the device has not beem claimed for 
streaming already (2012-03-27 11:42:04 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable

Laurent Pinchart (1):
      uvcvideo: Fix race-related crash in uvc_video_clock_update()

 drivers/media/video/uvc/uvc_video.c |   50 ++++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 18 deletions(-)

-- 
Regards,

Laurent Pinchart

