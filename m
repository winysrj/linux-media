Return-path: <mchehab@pedra>
Received: from mailfe02.c2i.net ([212.247.154.34]:39674 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755787Ab1EZHxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 03:53:51 -0400
Received: from [188.126.198.129] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe02.swip.net (CommuniGate Pro SMTP 5.2.19)
  with ESMTPA id 131997512 for linux-media@vger.kernel.org; Thu, 26 May 2011 09:53:49 +0200
From: Hans Petter Selasky <hselasky@c2i.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH v2] Correct error code from -ENOMEM to -EINVAL. Make sure the return value is set in all cases.
Date: Thu, 26 May 2011 09:52:33 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105260952.33551.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From 9b38a5c9878b5e4be2899ae291c4524f5f5fc218 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Thu, 26 May 2011 09:49:52 +0200
Subject: [PATCH] Correct error code from -ENOMEM to -EINVAL. Make sure the return value is set in all cases.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/media/video/sr030pc30.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
index c901721..8afb0e8 100644
--- a/drivers/media/video/sr030pc30.c
+++ b/drivers/media/video/sr030pc30.c
@@ -726,8 +726,10 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
 	const struct sr030pc30_platform_data *pdata = info->pdata;
 	int ret;
 
-	if (WARN(pdata == NULL, "No platform data!\n"))
-		return -ENOMEM;
+	if (pdata == NULL) {
+		WARN(1, "No platform data!\n");
+		return -EINVAL;
+	}
 
 	/*
 	 * Put sensor into power sleep mode before switching off
@@ -746,6 +748,7 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
 	if (on) {
 		ret = sr030pc30_base_config(sd);
 	} else {
+		ret = 0;
 		info->curr_win = NULL;
 		info->curr_fmt = NULL;
 	}
-- 
1.7.1.1

