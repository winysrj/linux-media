Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59897 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2EBLHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 07:07:39 -0400
Received: from avalon.localnet (unknown [91.178.164.248])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 35B0C7B0B
	for <linux-media@vger.kernel.org>; Wed,  2 May 2012 13:07:38 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.5] (v2) uvcvideo fixes
Date: Wed, 02 May 2012 13:08:02 +0200
Message-ID: <7550258.7G4aWM84fU@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's one more uvcvideo patch for v3.5. The first two patches have already 
been submitted in a previous pull request.

The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:

  [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Laurent Pinchart (3):
      uvcvideo: Fix ENUMINPUT handling
      MAINTAINERS: Update UVC driver's mailing list address
      uvcvideo: Use videobuf2 .get_unmapped_area() implementation

 MAINTAINERS                         |    2 +-
 drivers/media/video/uvc/uvc_queue.c |   43 ++++++++++------------------------
 drivers/media/video/uvc/uvc_v4l2.c  |    2 +-
 3 files changed, 15 insertions(+), 32 deletions(-)

-- 
Regards,

Laurent Pinchart

