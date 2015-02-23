Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:39613 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbbBWUTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 15:19:39 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/3] omap3isp trivial enhancements
Date: Mon, 23 Feb 2015 20:19:30 +0000
Message-Id: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Hi Laurent/Sakari,

This patch series is intended to use the helpers provided
by the v4l-core.
Please note I have just compile tested them.

Lad, Prabhakar (3):
  media: omap3isp: ispvideo: drop setting of vb2 buffer state to
    VB2_BUF_STATE_ACTIVE
  media: omap3isp: ispvideo: drop driver specific isp_video_fh
  media: omap3isp: ispvideo: use vb2_fop_mmap/poll

 drivers/media/platform/omap3isp/ispvideo.c | 153 +++++++++--------------------
 drivers/media/platform/omap3isp/ispvideo.h |  13 +--
 2 files changed, 50 insertions(+), 116 deletions(-)

-- 
2.1.0

