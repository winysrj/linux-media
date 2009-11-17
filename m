Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:61201 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbZKQGrk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 01:47:40 -0500
Message-ID: <4B02470C.7000205@freemail.hu>
Date: Tue, 17 Nov 2009 07:47:40 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca: add sanity check for mandatory operations
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@fremail.hu>

Add check for the mandatory config, init, start and pkt_scan
gspca subdriver operations.

Signed-off-by: Márton Németh <nm127@fremail.hu>
---
diff -r 182b5f8fa160 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Sun Nov 15 10:05:30 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Tue Nov 17 07:42:34 2009 +0100
@@ -2035,6 +2035,12 @@
 		return -ENODEV;
 	}

+	/* check for mandatory operations */
+	BUG_ON(!sd_desc->config);
+	BUG_ON(!sd_desc->init);
+	BUG_ON(!sd_desc->start);
+	BUG_ON(!sd_desc->pkt_scan);
+
 	/* create the device */
 	if (dev_size < sizeof *gspca_dev)
 		dev_size = sizeof *gspca_dev;
