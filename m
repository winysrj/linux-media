Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:63728 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZKHFyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 00:54:20 -0500
Message-ID: <4AF65D0D.4090707@freemail.hu>
Date: Sun, 08 Nov 2009 06:54:21 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca pac7302: handle return values in sd_start()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Add some missing return value evaluations.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr a/linux/drivers/media/video/gspca/pac7302.c b/linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	2009-11-08 05:33:10.000000000 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	2009-11-08 06:35:16.000000000 +0100
@@ -886,11 +886,11 @@ static int sd_start(struct gspca_dev *gs
 	if (0 <= ret)
 		ret = setbluebalance(gspca_dev);
 	if (0 <= ret)
-		setgain(gspca_dev);
+		ret = setgain(gspca_dev);
 	if (0 <= ret)
-		setexposure(gspca_dev);
+		ret = setexposure(gspca_dev);
 	if (0 <= ret)
-		sethvflip(gspca_dev);
+		ret = sethvflip(gspca_dev);
 	if (0 <= ret)
 		ret = setedgedetect(gspca_dev);
 	if (0 <= ret)
