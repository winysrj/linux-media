Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:57982 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbZJCHfy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 03:35:54 -0400
Message-ID: <4AC6FEDA.30804@freemail.hu>
Date: Sat, 03 Oct 2009 09:35:54 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>
CC: V4L Mailing List <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] pac7311: remove magic value for USB_BUF_SZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The length check in reg_w_var() function is because the buffer contents
is copied to gspca_dev->usb_buf which has the size of USB_BUF_SZ bytes as
defined in drivers/media/video/gspca/gspca.h. Replace the number with
symbol for better readability and maintainability.

The change was tested with Labtec Webcam 2200.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr c/drivers/media/video/gspca/pac7311.c d/drivers/media/video/gspca/pac7311.c
--- c/drivers/media/video/gspca/pac7311.c	2009-10-03 08:47:30.000000000 +0200
+++ d/drivers/media/video/gspca/pac7311.c	2009-10-03 09:02:31.000000000 +0200
@@ -474,7 +474,7 @@ static void reg_w_var(struct gspca_dev *
 			reg_w_page(gspca_dev, page3_7302, sizeof page3_7302);
 			break;
 		default:
-			if (len > 64) {
+			if (len > USB_BUF_SZ) {
 				PDEBUG(D_ERR|D_STREAM,
 					"Incorrect variable sequence");
 				return;
