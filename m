Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65384 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2BXPYs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 10:24:48 -0500
Received: by mail-yw0-f46.google.com with SMTP id o21so1155342yho.19
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 07:24:48 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: tomas.winkler@intel.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, dan.carpenter@oracle.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 4/9] staging: easycap: Initialize 'ntsc' parameter before usage
Date: Fri, 24 Feb 2012 12:24:17 -0300
Message-Id: <1330097062-31663-4-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
References: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This parameter is now initialized at init_easycap(),
this way we assure it won't be used uninitialized.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/easycap/easycap_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index 9d6dc09..480164d 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -2960,6 +2960,10 @@ static void init_easycap(struct easycap *peasycap,
 	peasycap->audio_isoc_buffer_size = -1;
 
 	peasycap->frame_buffer_many = FRAME_BUFFER_MANY;
+
+	peasycap->ntsc = easycap_ntsc;
+	JOM(8, "defaulting initially to %s\n",
+		easycap_ntsc ? "NTSC" : "PAL");
 }
 
 static int populate_inputset(struct easycap *peasycap)
@@ -2972,7 +2976,6 @@ static int populate_inputset(struct easycap *peasycap)
 
 	inputset = peasycap->inputset;
 
-	/* FIXME: peasycap->ntsc is not yet initialized */
 	fmtidx = peasycap->ntsc ? NTSC_M : PAL_BGHIN;
 
 	m = 0;
@@ -3650,9 +3653,6 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		 * because some udev rules triggers easycap_open()
 		 * immediately after registration, causing a clash.
 		 */
-		peasycap->ntsc = easycap_ntsc;
-		JOM(8, "defaulting initially to %s\n",
-			easycap_ntsc ? "NTSC" : "PAL");
 		rc = reset(peasycap);
 		if (rc) {
 			SAM("ERROR: reset() rc = %i\n", rc);
-- 
1.7.3.4

