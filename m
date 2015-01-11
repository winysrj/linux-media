Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:32791 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbbAKPfJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2015 10:35:09 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so15477742wgh.2
        for <linux-media@vger.kernel.org>; Sun, 11 Jan 2015 07:35:07 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mike Isely <isely@pobox.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] usb: pvrusb2: pvrusb2-hdw: Remove unused function
Date: Sun, 11 Jan 2015 16:38:14 +0100
Message-Id: <1420990694-19925-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the function pvr2_hdw_cmd_powerdown() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c |    5 -----
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h |    3 ---
 2 files changed, 8 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 9623b62..972fa23 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -4035,11 +4035,6 @@ int pvr2_hdw_cmd_powerup(struct pvr2_hdw *hdw)
 }
 
 
-int pvr2_hdw_cmd_powerdown(struct pvr2_hdw *hdw)
-{
-	return pvr2_issue_simple_cmd(hdw,FX2CMD_POWER_OFF);
-}
-
 
 int pvr2_hdw_cmd_decoder_reset(struct pvr2_hdw *hdw)
 {
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
index 4184707..b108aaf 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
@@ -271,9 +271,6 @@ int pvr2_hdw_cmd_deep_reset(struct pvr2_hdw *);
 /* Execute simple reset command */
 int pvr2_hdw_cmd_powerup(struct pvr2_hdw *);
 
-/* suspend */
-int pvr2_hdw_cmd_powerdown(struct pvr2_hdw *);
-
 /* Order decoder to reset */
 int pvr2_hdw_cmd_decoder_reset(struct pvr2_hdw *);
 
-- 
1.7.10.4

