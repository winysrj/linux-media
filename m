Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:42467 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbZATWBF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 17:01:05 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 00590CDC26F
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:42:00 +0100 (CET)
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 4D9DF4C80D9
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:40:40 +0100 (CET)
Received: from [192.168.1.151] (unknown [78.226.152.136])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 4A61E4C80FF
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:40:38 +0100 (CET)
Message-ID: <497644D6.7060102@free.fr>
Date: Tue, 20 Jan 2009 22:40:38 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] gspca: use usb_make_path to report bus info
References: <49764412.8030305@free.fr>
In-Reply-To: <49764412.8030305@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_make_path reports canonical bus info. Use it when reporting bus info
in VIDIOC_QUERYCAP.

Signed-off-by: Thierry MERLE <thierry.merle@free.fr>

diff -r 6ac9dc705aea -r 72ba48adaacd linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Tue Jan 20 22:01:33 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Tue Jan 20 22:06:58 2009 +0100
@@ -977,8 +977,7 @@
 			le16_to_cpu(gspca_dev->dev->descriptor.idVendor),
 			le16_to_cpu(gspca_dev->dev->descriptor.idProduct));
 	}
-	strncpy(cap->bus_info, gspca_dev->dev->bus->bus_name,
-		sizeof cap->bus_info);
+	usb_make_path(gspca_dev->dev, cap->bus_info, sizeof(cap->bus_info));
 	cap->version = DRIVER_VERSION_NUMBER;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
 			  | V4L2_CAP_STREAMING
