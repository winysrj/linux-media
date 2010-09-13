Return-path: <mchehab@localhost.localdomain>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41234 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab0IMEiu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 00:38:50 -0400
Received: by ywh1 with SMTP id 1so1892258ywh.19
        for <linux-media@vger.kernel.org>; Sun, 12 Sep 2010 21:38:50 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Sep 2010 12:38:50 +0800
Message-ID: <AANLkTinudKj2DkZof_98jXLe_kXcKM9_gfd2uLq2LX+Z@mail.gmail.com>
Subject: [PATCH] V4L/DVB: gspca - sonixj: Add webcam 0c45:612b
From: Alexander Goncharov <alexzandersss@gmail.com>
To: moinejf@free.fr
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Hi!
Add support webcam speedlink reflect2.

--- a/Documentation/video4linux/gspca.txt       2010-09-13
07:07:37.000000000 +0800
+++ b/Documentation/video4linux/gspca.txt       2010-09-13
10:25:23.017875028 +0800
@@ -308,6 +308,7 @@ sonixj              0c45:610c       PC Camera (SN9C128)
 sonixj         0c45:610e       PC Camera (SN9C128)
 sonixj         0c45:6128       Microdia/Sonix SNP325
 sonixj         0c45:612a       Avant Camera
+sonixj         0c45:612b       Speed-Link REFLECT2
 sonixj         0c45:612c       Typhoon Rasy Cam 1.3MPix
 sonixj         0c45:6130       Sonix Pccam
 sonixj         0c45:6138       Sn9c120 Mo4000
--- a/drivers/media/video/gspca/sonixj.c        2010-09-13
07:07:37.000000000 +0800
+++ b/drivers/media/video/gspca/sonixj.c        2010-09-13
10:24:29.381879935 +0800
@@ -3031,6 +3031,7 @@ static const __devinitdata struct usb_de
        {USB_DEVICE(0x0c45, 0x6128), BS(SN9C120, OM6802)},      /*sn9c325?*/
 /*bw600.inf:*/
        {USB_DEVICE(0x0c45, 0x612a), BS(SN9C120, OV7648)},      /*sn9c325?*/
+       {USB_DEVICE(0x0c45, 0x612b), BS(SN9C110, ADCM1700)},
        {USB_DEVICE(0x0c45, 0x612c), BS(SN9C110, MO4000)},
        {USB_DEVICE(0x0c45, 0x612e), BS(SN9C110, OV7630)},
 /*     {USB_DEVICE(0x0c45, 0x612f), BS(SN9C110, ICM105C)}, */

Signed-off-by: Alexander Goncharov <alexzandersss@gmail.com>
