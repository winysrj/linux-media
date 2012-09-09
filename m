Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42428 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab2IISBx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 14:01:53 -0400
Received: by mail-ee0-f46.google.com with SMTP id c1so640416eek.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 11:01:52 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 5/6] gspca_pac7302: avoid duplicate calls of the image quality adjustment functions on capturing start
Date: Sun,  9 Sep 2012 20:02:23 +0200
Message-Id: <1347213744-8509-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to call the image quality adjustment functions in sd_start.
The gspca main driver calls v4l2_ctrl_handler_setup in gspca_init_transfer,
which already applies all image control values.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/gspca/pac7302.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index bed34df..71fa5a4 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -673,14 +673,6 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	reg_w_var(gspca_dev, start_7302,
 		page3_7302, sizeof(page3_7302));
-	setbrightcont(gspca_dev);
-	setcolors(gspca_dev);
-	setwhitebalance(gspca_dev);
-	setredbalance(gspca_dev);
-	setbluebalance(gspca_dev);
-	setexposure(gspca_dev);
-	setgain(gspca_dev);
-	sethvflip(gspca_dev);
 
 	sd->sof_read = 0;
 	sd->autogain_ignore_frames = 0;
-- 
1.7.7

