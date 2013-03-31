Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab3CaMoh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Mar 2013 08:44:37 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: hverkuil@xs4all.nl
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/2] xawtv: Limit minimum window size to minimum capture resolution
Date: Sun, 31 Mar 2013 14:48:05 +0200
Message-Id: <1364734085-4227-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1364734085-4227-1-git-send-email-hdegoede@redhat.com>
References: <1364734085-4227-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 x11/xawtv.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/x11/xawtv.c b/x11/xawtv.c
index bade35a..9c578da 100644
--- a/x11/xawtv.c
+++ b/x11/xawtv.c
@@ -1636,7 +1636,7 @@ create_launchwin(void)
 int
 main(int argc, char *argv[])
 {
-    int            i;
+    int            i, min_width, min_height;
     unsigned long  freq;
 
     hello_world("xawtv");
@@ -1784,11 +1784,16 @@ main(int argc, char *argv[])
     XSetWMProtocols(XtDisplay(app_shell), XtWindow(app_shell),
 		    &WM_DELETE_WINDOW, 1);
 
+    drv->get_min_size(h_drv, &min_width, &min_height);
+    min_width  = ((min_width + (WIDTH_INC - 1)) / WIDTH_INC) * WIDTH_INC;
+    min_height = ((min_height + (HEIGHT_INC - 1)) / HEIGHT_INC) * HEIGHT_INC;
+    if (debug)
+	fprintf(stderr,"main: window min size %dx%d\n", min_width, min_height);
     XtVaSetValues(app_shell,
 		  XtNwidthInc,  WIDTH_INC,
 		  XtNheightInc, HEIGHT_INC,
-		  XtNminWidth,  WIDTH_INC,
-		  XtNminHeight, HEIGHT_INC,
+		  XtNminWidth,  min_width,
+		  XtNminHeight, min_height,
 		  NULL);
     if (f_drv & CAN_TUNE)
 	XtVaSetValues(chan_shell,
-- 
1.8.1.4

