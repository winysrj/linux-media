Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3300 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3BJRxG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:53:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 01/12] stk-webcam: the initial hflip and vflip setup was the wrong way around
Date: Sun, 10 Feb 2013 18:52:42 +0100
Message-Id: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
In-Reply-To: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This resulted in an upside-down picture.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 4cbab08..71ac307 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1305,15 +1305,15 @@ static int stk_camera_probe(struct usb_interface *interface,
 	if (hflip != -1)
 		dev->vsettings.hflip = hflip;
 	else if (dmi_check_system(stk_upside_down_dmi_table))
-		dev->vsettings.hflip = 1;
-	else
 		dev->vsettings.hflip = 0;
+	else
+		dev->vsettings.hflip = 1;
 	if (vflip != -1)
 		dev->vsettings.vflip = vflip;
 	else if (dmi_check_system(stk_upside_down_dmi_table))
-		dev->vsettings.vflip = 1;
-	else
 		dev->vsettings.vflip = 0;
+	else
+		dev->vsettings.vflip = 1;
 	dev->n_sbufs = 0;
 	set_present(dev);
 
-- 
1.7.10.4

