Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51623 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab3HIMvu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:51:50 -0400
Received: from avalon.localnet (unknown [109.134.65.8])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8E1CE363DA
	for <linux-media@vger.kernel.org>; Fri,  9 Aug 2013 14:51:31 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.12] Mixed V4L2 core and vb2 patches
Date: Fri, 09 Aug 2013 14:52:56 +0200
Message-ID: <5985260.CIUTh5xNqB@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit dfb9f94e8e5e7f73c8e2bcb7d4fb1de57e7c333d:

  [media] stk1160: Build as a module if SND is m and audio support is selected 
(2013-08-01 14:55:25 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/core

for you to fetch changes up to c751c5876e39470dedc627349743a662108dd99d:

  v4l: async: Make it safe to unregister unregistered notifier (2013-08-09 
14:48:30 +0200)

----------------------------------------------------------------
Laurent Pinchart (5):
      videobuf2-core: Verify planes lengths for output buffers
      v4l: of: Use of_get_child_by_name()
      v4l: of: Drop acquired reference to node when getting next endpoint
      v4l: Fix colorspace conversion error in sample code
      v4l: async: Make it safe to unregister unregistered notifier

 Documentation/DocBook/media/v4l/pixfmt.xml |  6 +++---
 drivers/media/v4l2-core/v4l2-async.c       |  6 ++++++
 drivers/media/v4l2-core/v4l2-of.c          |  9 +++------
 drivers/media/v4l2-core/videobuf2-core.c   | 39 +++++++++++++++++++++++++++++
 4 files changed, 51 insertions(+), 9 deletions(-)

-- 
Regards,

Laurent Pinchart

