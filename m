Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:56824 "EHLO
	bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaLOJTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 04:19:39 -0500
From: Prashant Laddha <prladdha@cisco.com>
To: <hverkuil@xs4all.nl>
Cc: Prashant Laddha <prladdha@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/6] Vivid sine gen: Renamed SIN_TAB_SIZE to SIN_LUT_SIZE
Date: Mon, 15 Dec 2014 14:49:20 +0530
Message-Id: <1418635162-8814-5-git-send-email-prladdha@cisco.com>
In-Reply-To: <1418635162-8814-1-git-send-email-prladdha@cisco.com>
References: <1418635162-8814-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-sin.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-sin.c b/drivers/media/platform/vivid/vivid-sin.c
index c9face9..1ba6df9 100644
--- a/drivers/media/platform/vivid/vivid-sin.c
+++ b/drivers/media/platform/vivid/vivid-sin.c
@@ -23,7 +23,7 @@
 
 #include "vivid-sin.h"
 
-#define SIN_TAB_SIZE 256
+#define SIN_LUT_SIZE 256
 
 static s32 sin[65] = {
 	   0,   31,   63,   94,  125,  156,  187,  218,  249,  279,  310,  340,
@@ -123,7 +123,7 @@ s32 calc_sin(u32 phase)
 	u64 temp0;
 	u64 temp1;
 
-	temp0 = phase * SIN_TAB_SIZE;
+	temp0 = phase * SIN_LUT_SIZE;
 	index = (temp0 * 7) / (44 << FIX_PT_PREC);
 
 	temp0 = (temp0 * 7) / 44;
@@ -145,7 +145,7 @@ s32 calc_cos(u32 phase)
 	u64 temp0;
 	u64 temp1;
 
-	temp0 = phase * SIN_TAB_SIZE;
+	temp0 = phase * SIN_LUT_SIZE;
 	index = (temp0 * 7) / (44 << FIX_PT_PREC);
 
 	temp0 = (temp0 * 7) / 44;
-- 
1.9.1

