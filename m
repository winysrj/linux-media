Return-path: <linux-media-owner@vger.kernel.org>
Received: from darkcity.gna.ch ([195.226.6.51]:60780 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753445AbbAVHGd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 02:06:33 -0500
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH] reservation: Remove shadowing local variable 'ret'
Date: Thu, 22 Jan 2015 16:00:17 +0900
Message-Id: <1421910017-14627-1-git-send-email-michel@daenzer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michel Dänzer <michel.daenzer@amd.com>

It was causing the return value of fence_is_signaled to be ignored, making
reservation objects signal too early.

Cc: stable@vger.kernel.org
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
---
 drivers/dma-buf/reservation.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index 3c97c8f..8a37af9 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -402,8 +402,6 @@ reservation_object_test_signaled_single(struct fence *passed_fence)
 	int ret = 1;
 
 	if (!test_bit(FENCE_FLAG_SIGNALED_BIT, &lfence->flags)) {
-		int ret;
-
 		fence = fence_get_rcu(lfence);
 		if (!fence)
 			return -1;
-- 
2.1.4

