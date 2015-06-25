Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:51905 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbbFYKBF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 06:01:05 -0400
From: Maninder Singh <maninder1.s@samsung.com>
To: crope@iki.fi, mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pankaj.m@samsung.com, Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] usb/airspy: removing unneeded goto
Date: Thu, 25 Jun 2015 15:28:58 +0530
Message-id: <1435226338-16368-1-git-send-email-maninder1.s@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes unneded goto,
reported by coccinelle.

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Reviewed-by: Akhilesh Kumar <akhilesh.k@samsung.com>
---
 drivers/media/usb/airspy/airspy.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 4069234..8f2e1c2 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -937,9 +937,6 @@ static int airspy_set_if_gain(struct airspy *s)
 	ret = airspy_ctrl_msg(s, CMD_SET_VGA_GAIN, 0, s->if_gain->val,
 			&u8tmp, 1);
 	if (ret)
-		goto err;
-err:
-	if (ret)
 		dev_dbg(s->dev, "failed=%d\n", ret);
 
 	return ret;
-- 
1.7.9.5

