Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761149Ab0J0Mbo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 08:31:44 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lee Jones <lee.jones@canonical.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 7/7] gspca_ov519: generate release button event on stream stop if needed
Date: Wed, 27 Oct 2010 14:35:26 +0200
Message-Id: <1288182926-25400-8-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
References: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Generate a release button event when the button is still pressed when the
stream stops.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/ov519.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/ov519.c b/drivers/media/video/gspca/ov519.c
index 6cf6855..7e86faf 100644
--- a/drivers/media/video/gspca/ov519.c
+++ b/drivers/media/video/gspca/ov519.c
@@ -3912,7 +3912,6 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	   pressed while we weren't streaming */
 	sd->snapshot_needs_reset = 1;
 	sd_reset_snapshot(gspca_dev);
-	sd->snapshot_pressed = 0;
 
 	sd->first_frame = 3;
 
@@ -3940,6 +3939,15 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 
 	if (sd->bridge == BRIDGE_W9968CF)
 		w9968cf_stop0(sd);
+
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+	/* If the last button state is pressed, release it now! */
+	if (sd->snapshot_pressed) {
+		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
+		input_sync(gspca_dev->input_dev);
+		sd->snapshot_pressed = 0;
+	}
+#endif
 }
 
 static void ov51x_handle_button(struct gspca_dev *gspca_dev, u8 state)
-- 
1.7.3.1

