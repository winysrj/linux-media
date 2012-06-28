Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41840 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2F1LZP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 07:25:15 -0400
Received: from avalon.localnet (unknown [91.178.148.221])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id F197A35A40
	for <linux-media@vger.kernel.org>; Thu, 28 Jun 2012 13:25:13 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.6] uvcvideo fixes
Date: Thu, 28 Jun 2012 13:25:18 +0200
Message-ID: <1484282.DCLrSed1NR@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit a99817ca60d206be3645d156f755cf065e949c58:

  Merge branch 'v4l_for_linus' into staging/for_v3.6 (2012-06-27 08:57:09 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Jayakrishnan (1):
      uvcvideo: Fix frame drop in bulk video stream

Laurent Pinchart (2):
      uvcvideo: Document the struct uvc_xu_control_query query field
      uvcvideo: Fix alternate setting selection

 drivers/media/video/uvc/uvc_video.c |    7 +++++--
 include/linux/uvcvideo.h            |    3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart

