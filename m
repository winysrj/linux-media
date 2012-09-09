Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50521 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab2IISBo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 14:01:44 -0400
Received: by eaac11 with SMTP id c11so540081eaa.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 11:01:43 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/6] gspca_pac7302: make red balance and blue balance controls work again
Date: Sun,  9 Sep 2012 20:02:20 +0200
Message-Id: <1347213744-8509-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a regression from kernel 3.4 which has been introduced with the conversion of the gspca driver to the v4l2 control framework.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Cc: stable@kernel.org
---
 drivers/media/usb/gspca/pac7302.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index e906f56..eb3c90e4 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -616,7 +616,7 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 	sd->red_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 					V4L2_CID_RED_BALANCE, 0, 3, 1, 1);
 	sd->blue_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
-					V4L2_CID_RED_BALANCE, 0, 3, 1, 1);
+					V4L2_CID_BLUE_BALANCE, 0, 3, 1, 1);
 
 	gspca_dev->autogain = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 					V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
-- 
1.7.7

