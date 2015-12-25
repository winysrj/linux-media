Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33173 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbbLYRZf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2015 12:25:35 -0500
Received: by mail-lb0-f169.google.com with SMTP id sv6so64030321lbb.0
        for <linux-media@vger.kernel.org>; Fri, 25 Dec 2015 09:25:34 -0800 (PST)
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	jh1009.sung@samsung.com, linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] [media] vim2m: return error if driver registration fails
Date: Fri, 25 Dec 2015 18:25:16 +0100
Message-Id: <1451064316-6992-1-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/vim2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index e18fb9f..da37a59 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1079,7 +1079,7 @@ static int __init vim2m_init(void)
 	if (ret)
 		platform_device_unregister(&vim2m_pdev);
 
-	return 0;
+	return ret;
 }
 
 module_init(vim2m_init);
-- 
2.6.3

