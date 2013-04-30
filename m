Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33061 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3D3G3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 02:29:14 -0400
Received: by mail-pd0-f169.google.com with SMTP id 10so129458pdc.14
        for <linux-media@vger.kernel.org>; Mon, 29 Apr 2013 23:29:14 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/4] [media] s3c-camif: Fix incorrect variable type
Date: Tue, 30 Apr 2013 11:46:19 +0530
Message-Id: <1367302581-15478-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1367302581-15478-1-git-send-email-sachin.kamat@linaro.org>
References: <1367302581-15478-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'rotation' was an 8 bit variable and hence could not have values
greater than 255. Since we need higher values, chnage it to 16
bit type.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s3c-camif/camif-core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
index 261134b..35d2fcd 100644
--- a/drivers/media/platform/s3c-camif/camif-core.h
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -229,7 +229,7 @@ struct camif_vp {
 	unsigned int		state;
 	u16			fmt_flags;
 	u8			id;
-	u8			rotation;
+	u16			rotation;
 	u8			hflip;
 	u8			vflip;
 	unsigned int		offset;
-- 
1.7.9.5

