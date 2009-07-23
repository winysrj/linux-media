Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:34826 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZGWVOr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 17:14:47 -0400
Received: by ewy26 with SMTP id 26so1335422ewy.37
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 14:14:46 -0700 (PDT)
Message-ID: <4A68D357.3010502@gmail.com>
Date: Thu, 23 Jul 2009 23:17:11 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: mchehab@redhat.com, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

parport[n] is checked before n < MAX_CAMS

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
probably harmless

diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
index 10dbd4a..9e39bc5 100644
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -992,7 +992,7 @@ static int accept_bwqcam(struct parport *port)
 
 	if (parport[0] && strncmp(parport[0], "auto", 4) != 0) {
 		/* user gave parport parameters */
-		for(n=0; parport[n] && n<MAX_CAMS; n++){
+		for (n = 0; n < MAX_CAMS && parport[n]; n++) {
 			char *ep;
 			unsigned long r;
 			r = simple_strtoul(parport[n], &ep, 0);
