Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:4160 "EHLO
	bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaLAJN2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 04:13:28 -0500
From: Prashant Laddha <prladdha@cisco.com>
To: <hverkuil@xs4all.nl>
Cc: Prashant Laddha <prladdha@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/5] Vivid sine gen: Refactor get_sin_val ()
Date: Mon,  1 Dec 2014 14:33:22 +0530
Message-Id: <1417424604-17340-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1417424604-17340-1-git-send-email-prladdha@cisco.com>
References: <1417424604-17340-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removed recursion. Also reduced few if() checks.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-sin.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-sin.c b/drivers/media/platform/vivid/vivid-sin.c
index 0774bdd..f2158a3 100644
--- a/drivers/media/platform/vivid/vivid-sin.c
+++ b/drivers/media/platform/vivid/vivid-sin.c
@@ -35,21 +35,19 @@ static s32 sin[65] = {
 
 static s32 get_sin_val(u32 index)
 {
-	if(index <= 64)
-		return sin[index];
-	else if (index > 64 && index <= 128) {
-		u32 tab_index = 64 - (index - 64);
-		return sin[tab_index];
-	} else if (index > 128 && index <= 192) {
-		u32 tab_index = index - 128;
-		return (-1) * sin[tab_index];
-	} else if (index > 192 && index <= 255) {
-		u32 tab_index = 64 - (index - 192);
-		return (-1) * sin[tab_index];
-	} else {
-		u32 new_index = index % 256;
-		return get_sin_val(new_index);
-	}
+	s32 sign = 1;
+	u32 tab_index;
+	u32 new_index = index & 0x7F; /* new_index = index % 128*/
+
+	if (index > 128)
+		sign = -1;
+
+	if(new_index <= 64)
+		tab_index = new_index;
+	else
+		tab_index = 64 - (new_index - 64);
+
+	return sign * sin[tab_index];
 }
 
 /*
-- 
1.9.1

