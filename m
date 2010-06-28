Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52732 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab0F1IRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 04:17:09 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L4P00I96TOH6A@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Jun 2010 09:17:05 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L4P000KETOHGI@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Jun 2010 09:17:05 +0100 (BST)
Date: Mon, 28 Jun 2010 10:16:56 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH] v4l: mem2mem_testdev: fix g_fmt NULL pointer dereference
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, kyungmin.park@samsung.com, nm127@freemail.hu
Message-id: <1277713016-24339-1-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling g_fmt before s_fmt resulted in a NULL pointer dereference as no
default formats were being selected on probe.

Reported-by: Németh Márton <nm127@freemail.hu>
Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Fix for 2.6.35

 drivers/media/video/mem2mem_testdev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index d4fd8a3..033aa12 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -1000,6 +1000,9 @@ static int m2mtest_probe(struct platform_device *pdev)
 		goto err_m2m;
 	}
 
+	q_data[V4L2_M2M_SRC].fmt = &formats[0];
+	q_data[V4L2_M2M_DST].fmt = &formats[0];
+
 	return 0;
 
 err_m2m:
-- 
1.7.1.240.g225c9

