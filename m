Return-path: <mchehab@localhost>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57942 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab1GJSOg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 14:14:36 -0400
Received: by iyb12 with SMTP id 12so3072407iyb.19
        for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 11:14:36 -0700 (PDT)
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Sun, 10 Jul 2011 18:14:16 +0000
Message-ID: <CAH9NwWeGQfBqaS36tQ=T3+1tM3i4Govzzkw0ur_hut07M36_HA@mail.gmail.com>
Subject: [PATCH 1/3] Add 8-bit and 16-bit YCrCb media bus pixel codes
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Signed-off-by: Christian Gmeiner
---
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 5ea7f75..11b916d 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -92,6 +92,10 @@ enum v4l2_mbus_pixelcode {

        /* JPEG compressed formats - next is 0x4002 */
        V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
+
+       /* YCrCb formats - next is 0x5003 */
+       V4L2_MBUS_FMT_YCRCB_1X8 = 0x5001,
+       V4L2_MBUS_FMT_YCRCB_1X16 = 0x5002,
 };

 /**
--
1.7.6
