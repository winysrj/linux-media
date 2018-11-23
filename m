Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:46787 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387885AbeKWWh4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 17:37:56 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH] seco-cec: fix Makefile
Message-ID: <5365e2c4-bbe9-ba75-db84-22501f1c43f5@xs4all.nl>
Date: Fri, 23 Nov 2018 12:53:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the incorrect obj-y.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/seco-cec/Makefile b/drivers/media/platform/seco-cec/Makefile
index 09900b087d02..a3f2c6bd3ac0 100644
--- a/drivers/media/platform/seco-cec/Makefile
+++ b/drivers/media/platform/seco-cec/Makefile
@@ -1 +1 @@
-obj-y += seco-cec.o
+obj-$(CONFIG_VIDEO_SECO_CEC) += seco-cec.o
