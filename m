Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4819 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaDQJWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 05:22:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 2/3] bfin_capture: drop unnecessary vb2_is_streaming check.
Date: Thu, 17 Apr 2014 11:21:49 +0200
Message-Id: <1397726510-12005-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397726510-12005-1-git-send-email-hverkuil@xs4all.nl>
References: <1397726510-12005-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The stop_streaming op is only called if streaming is in progress,
so drop the unnecessary 'if (!vb2_is_streaming(vq))' check.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pawel Osciak <pawel@osciak.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index dfb09d4..16f643c 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -433,9 +433,6 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 	struct ppi_if *ppi = bcap_dev->ppi;
 	int ret;
 
-	if (!vb2_is_streaming(vq))
-		return 0;
-
 	bcap_dev->stop = true;
 	wait_for_completion(&bcap_dev->comp);
 	ppi->ops->stop(ppi);
-- 
1.9.2

