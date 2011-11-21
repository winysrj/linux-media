Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53858 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab1KUJCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 04:02:48 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LV000HRW6GMZ3@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Nov 2011 09:02:46 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV000DR06GMCA@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Nov 2011 09:02:46 +0000 (GMT)
Date: Mon, 21 Nov 2011 10:02:38 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: video: s5p-tv: fix build break
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1321866159-27749-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes following build break:

drivers/media/video/s5p-tv/mixer_video.c:828: error: ‘THIS_MODULE’ undeclared here (not in a function)
make[4]: *** [drivers/media/video/s5p-tv/mixer_video.o] Error 1
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [drivers/media/video/s5p-tv] Error 2

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/s5p-tv/mixer_video.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index e90f63e..0e3316b 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -17,6 +17,7 @@
 #include <linux/videodev2.h>
 #include <media/videobuf2-fb.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/version.h>
 #include <linux/timer.h>
 #include <media/videobuf2-dma-contig.h>
-- 
1.7.1.569.g6f426

