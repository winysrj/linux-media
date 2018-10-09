Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39763 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbeJIODw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 10:03:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id c25-v6so332177pfe.6
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 23:48:27 -0700 (PDT)
From: Sam Bobrowicz <sam@elite-embedded.com>
To: linux-media@vger.kernel.org
Cc: Sam Bobrowicz <sam@elite-embedded.com>
Subject: [PATCH 2/4] media: ov5640: fix get_light_freq on auto
Date: Mon,  8 Oct 2018 23:48:00 -0700
Message-Id: <1539067682-60604-3-git-send-email-sam@elite-embedded.com>
In-Reply-To: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
References: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Light frequency was not properly returned when in auto
mode and the detected frequency was 60Hz. Fix this.

Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
---
 drivers/media/i2c/ov5640.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 5031aab..f183222 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1295,6 +1295,7 @@ static int ov5640_get_light_freq(struct ov5640_dev *sensor)
 			light_freq = 50;
 		} else {
 			/* 60Hz */
+			light_freq = 60;
 		}
 	}
 
-- 
2.7.4
