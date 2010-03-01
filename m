Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out04.alice.it ([85.37.17.100]:1526 "EHLO
	smtp-out04.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0CALxu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 06:53:50 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	Max Thrun <bear24rw@gmail.com>
Subject: [PATCH v2 05/11] ov534: Fix and document setting manual exposure
Date: Mon,  1 Mar 2010 12:53:34 +0100
Message-Id: <1267444414-29248-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <20100301121035.8677f284.ospite@studenti.unina.it>
References: <20100301121035.8677f284.ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document that even if the state is a u8 value, both MSB and LSB are set
as sd->exposure represents half of the value we are going to set into
registers.

Skip setting exposure when AEC is enabled.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
The code was already doing the right thing, I just overlooked it.

Regards,
   Antonio

 linux/drivers/media/video/gspca/ov534.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -686,6 +686,15 @@
 	struct sd *sd = (struct sd *) gspca_dev;
 	u8 val;
 
+	if (sd->aec)
+		return;
+
+	/* 'val' is one byte and represents half of the exposure value we are
+	 * going to set into registers, a two bytes value:
+	 * 
+	 *    MSB: ((u16) val << 1) >> 8   == val >> 7
+	 *    LSB: ((u16) val << 1) & 0xff == val << 1
+	 */
 	val = sd->exposure;
 	sccb_reg_write(gspca_dev, 0x08, val >> 7);
 	sccb_reg_write(gspca_dev, 0x10, val << 1);
