Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39317 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbeJIODv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 10:03:51 -0400
Received: by mail-pl1-f194.google.com with SMTP id w14-v6so319918plp.6
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 23:48:26 -0700 (PDT)
From: Sam Bobrowicz <sam@elite-embedded.com>
To: linux-media@vger.kernel.org
Cc: Sam Bobrowicz <sam@elite-embedded.com>
Subject: [PATCH 1/4] media: ov5640: fix resolution update
Date: Mon,  8 Oct 2018 23:47:59 -0700
Message-Id: <1539067682-60604-2-git-send-email-sam@elite-embedded.com>
In-Reply-To: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
References: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

set_fmt was not properly triggering a mode change when
a new mode was set that happened to have the same format
as the previous mode (for example, when only changing the
frame dimensions). Fix this.

Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
---
 drivers/media/i2c/ov5640.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index eaefdb5..5031aab 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2045,12 +2045,12 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 		goto out;
 	}
 
-	if (new_mode != sensor->current_mode) {
+
+	if (new_mode != sensor->current_mode ||
+	    mbus_fmt->code != sensor->fmt.code) {
+		sensor->fmt = *mbus_fmt;
 		sensor->current_mode = new_mode;
 		sensor->pending_mode_change = true;
-	}
-	if (mbus_fmt->code != sensor->fmt.code) {
-		sensor->fmt = *mbus_fmt;
 		sensor->pending_fmt_change = true;
 	}
 out:
-- 
2.7.4
