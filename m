Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:43581 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750830AbdDCIVM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 04:21:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-ctrls.c: fix RGB quantization range control menu
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <32481bd6-1c56-43f1-f3fb-7ec99b4c8503@xs4all.nl>
Date: Mon, 3 Apr 2017 10:21:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All control menus use the english capitalization rules of titles.

The only menu not following these rules is the RGB Quantization Range control
menu. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b9e08e3d6e0e..b4b364f68695 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -459,8 +459,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	};
 	static const char * const dv_rgb_range[] = {
 		"Automatic",
-		"RGB limited range (16-235)",
-		"RGB full range (0-255)",
+		"RGB Limited Range (16-235)",
+		"RGB Full Range (0-255)",
 		NULL,
 	};
 	static const char * const dv_it_content_type[] = {
