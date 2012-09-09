Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50521 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab2IISBu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 14:01:50 -0400
Received: by mail-ey0-f174.google.com with SMTP id c11so540081eaa.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 11:01:50 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/6] gspca_pac7302: increase default value for white balance temperature
Date: Sun,  9 Sep 2012 20:02:22 +0200
Message-Id: <1347213744-8509-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current white balance temperature default value is 4, which is much too small (possible values are 0-255).
Improve the picture quality by increasing the default value to 55, which is the default value used by the Windows driver.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/gspca/pac7302.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index 8c29613..bed34df 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -632,7 +632,7 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 					V4L2_CID_SATURATION, 0, 255, 1, 127);
 	sd->white_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 					V4L2_CID_WHITE_BALANCE_TEMPERATURE,
-					0, 255, 1, 4);
+					0, 255, 1, 55);
 	sd->red_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 					V4L2_CID_RED_BALANCE, 0, 3, 1, 1);
 	sd->blue_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
-- 
1.7.7

