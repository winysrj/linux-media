Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:60940 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbZJCO75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 10:59:57 -0400
Message-ID: <4AC766C5.3040001@freemail.hu>
Date: Sat, 03 Oct 2009 16:59:17 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] pac7311: remove redundant register page switching
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

do you know any reason (i.e. a special device needs this) why switch to
register page 0 is done twice in the setcolors() function of pac7311?

I removed the redundant page switch and my Labtec Webcam 2200 still
behaves correctly when I change the "Saturation" control.

Regards,

	Márton Németh

---
From: Márton Németh <nm127@freemail.hu>

Remove redundant register page switching to page 0 when changing the
color control.

The change was tested with Labtec Webcam 2200 (USB ID: 093a:2626).

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr d/drivers/media/video/gspca/pac7311.c e/drivers/media/video/gspca/pac7311.c
--- d/drivers/media/video/gspca/pac7311.c	2009-10-03 09:02:31.000000000 +0200
+++ e/drivers/media/video/gspca/pac7311.c	2009-10-03 16:23:37.000000000 +0200
@@ -579,7 +579,6 @@ static void setcolors(struct gspca_dev *
 	reg_w(gspca_dev, 0xff, 0x03);	/* page 3 */
 	reg_w(gspca_dev, 0x11, 0x01);
 	reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
-	reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
 	for (i = 0; i < 9; i++) {
 		v = a[i] * sd->colors / COLOR_MAX + b[i];
 		reg_w(gspca_dev, 0x0f + 2 * i, (v >> 8) & 0x07);
