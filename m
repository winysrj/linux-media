Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57613 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1LOJjx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:39:53 -0500
Received: by wgbdr13 with SMTP id dr13so3732677wgb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 01:39:52 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hverkuil@xs4all.nl,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 1/2] media: tvp5150 Fix default input selection.
Date: Thu, 15 Dec 2011 10:39:46 +0100
Message-Id: <1323941987-23428-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In page 23 of the datasheet of this chip (SLES098A)
it is stated that de default input for this chip
is Composite AIP1A which is the same as COMPOSITE0
in the driver.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/tvp5150.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index e927d25..26cc75b 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -993,7 +993,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	}
 
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
-	core->input = TVP5150_COMPOSITE1;
+	core->input = TVP5150_COMPOSITE0;
 	core->enable = 1;
 
 	v4l2_ctrl_handler_init(&core->hdl, 4);
-- 
1.7.0.4

