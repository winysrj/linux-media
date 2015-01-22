Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37858 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbbAVAOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2015 19:14:30 -0500
Received: by mail-pa0-f48.google.com with SMTP id ey11so4442520pad.7
        for <linux-media@vger.kernel.org>; Wed, 21 Jan 2015 16:14:30 -0800 (PST)
From: Takanari Hayama <taki@igel.co.jp>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH] [media] v4l: vsp1: bru: Fix minimum input pixel size
Date: Thu, 22 Jan 2015 09:14:23 +0900
Message-Id: <1421885663-19565-1-git-send-email-taki@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the spec, the minimum input pixel size for BRU is 1px,
not 4px.

Signed-off-by: Takanari Hayama <taki@igel.co.jp>
---
 drivers/media/platform/vsp1/vsp1_bru.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index b21f381..401e2b7 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -20,7 +20,7 @@
 #include "vsp1_bru.h"
 #include "vsp1_rwpf.h"
 
-#define BRU_MIN_SIZE				4U
+#define BRU_MIN_SIZE				1U
 #define BRU_MAX_SIZE				8190U
 
 /* -----------------------------------------------------------------------------
-- 
1.8.0

