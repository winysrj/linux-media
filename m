Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:34165 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbbICXOj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2015 19:14:39 -0400
Received: by laeb10 with SMTP id b10so2868951lae.1
        for <linux-media@vger.kernel.org>; Thu, 03 Sep 2015 16:14:37 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	lars@metafoo.de
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 1/3] adv7180: implement g_std() method
Date: Fri, 04 Sep 2015 02:14:35 +0300
Message-ID: <55445603.CDVZru8CKl@wasted.cogentembedded.com>
In-Reply-To: <6015647.cjLjRfTWc7@wasted.cogentembedded.com>
References: <6015647.cjLjRfTWc7@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit cccb83f7a184 ([media] adv7180: add more subdev video ops) forgot to add
the g_std() video method. Its implementation seems identical to the querystd()
method,  so we  can just  point at adv7180_querystd()...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
 drivers/media/i2c/adv7180.c |    1 +
 1 file changed, 1 insertion(+)

Index: media_tree/drivers/media/i2c/adv7180.c
===================================================================
--- media_tree.orig/drivers/media/i2c/adv7180.c
+++ media_tree/drivers/media/i2c/adv7180.c
@@ -717,6 +717,7 @@ static int adv7180_g_mbus_config(struct
 }
 
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
+	.g_std = adv7180_querystd,
 	.s_std = adv7180_s_std,
 	.querystd = adv7180_querystd,
 	.g_input_status = adv7180_g_input_status,

