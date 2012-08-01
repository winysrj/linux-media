Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48858 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab2HAT1K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 15:27:10 -0400
Received: from avalon.localnet (unknown [194.136.87.226])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4AE3835995
	for <linux-media@vger.kernel.org>; Wed,  1 Aug 2012 21:27:09 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.6] uvcvideo fixes
Date: Wed, 01 Aug 2012 21:27:16 +0200
Message-ID: <20386270.Pi24L6Y92g@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Resending the pull request, without changing the git request-pull text this 
time.

The following changes since commit 931efdf58bd83af8d0578a6cc53421675daf6d41:

  Merge branch 'v4l_for_linus' into staging/for_v3.6 (2012-07-14 15:45:44 
-0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Jayakrishnan Memana (1):
      uvcvideo: Reset the bytesused field when recycling an erroneous buffer

 drivers/media/video/uvc/uvc_queue.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
Regards,

Laurent Pinchart
