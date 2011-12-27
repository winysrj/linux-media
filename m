Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23506 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1L0OHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 09:07:35 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LWV003378KMCL@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Dec 2011 14:07:34 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LWV00DVJ8KLZZ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Dec 2011 14:07:34 +0000 (GMT)
Date: Tue, 27 Dec 2011 15:07:24 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-mfc: Fix volatile controls setup
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	mchehab@redhat.com, Kamil Debski <k.debski@samsung.com>
Message-id: <1324994844-9883-1-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index 844a4d7..c25ec02 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -165,7 +165,7 @@ static struct mfc_control controls[] = {
 		.maximum = 32,
 		.step = 1,
 		.default_value = 1,
-		.flags = V4L2_CTRL_FLAG_VOLATILE,
+		.is_volatile = 1,
 	},
 };
 
-- 
1.7.0.4

