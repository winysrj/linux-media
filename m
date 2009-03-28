Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:49151 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZC1W36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 18:29:58 -0400
Date: Sat, 28 Mar 2009 17:42:56 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Jean-Francois Moine <moinejf@free.fr>
cc: Kyle Guinn <elyk03@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: [PATCH] to add new camera in gspca/mr97310a.c
In-Reply-To: <200903051921.57412.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0903281734270.4177@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <49B038D8.8060702@redhat.com> <alpine.LNX.2.00.0903051457410.27979@banach.math.auburn.edu> <200903051921.57412.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The purpose of the following patch is to add another camera, with the new 
USB Vendor:Product number 0x093a:0x010f to gspca/mr97310a.c. The camera 
has also been added to the list of supported cameras in 
Documentation/gspca.txt.


Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
--------------------------------------------------------------------------------
diff -uprN linuxa/Documentation/video4linux/gspca.txt linuxb/Documentation/video4linux/gspca.txt
--- linuxa/Documentation/video4linux/gspca.txt	2009-03-28 11:48:44.000000000 -0500
+++ linuxb/Documentation/video4linux/gspca.txt	2009-03-28 16:12:07.000000000 -0500
@@ -209,6 +209,7 @@ sunplus		08ca:2050	Medion MD 41437
  sunplus		08ca:2060	Aiptek PocketDV5300
  tv8532		0923:010f	ICM532 cams
  mars		093a:050f	Mars-Semi Pc-Camera
+mr97310a	093a:010f	Sakar Digital no. 77379
  pac207		093a:2460	Qtec Webcam 100
  pac207		093a:2461	HP Webcam
  pac207		093a:2463	Philips SPC 220 NC
diff -uprN linuxa/drivers/media/video/gspca/mr97310a.c linuxb/drivers/media/video/gspca/mr97310a.c
--- linuxa/drivers/media/video/gspca/mr97310a.c	2009-03-28 11:48:44.000000000 -0500
+++ linuxb/drivers/media/video/gspca/mr97310a.c	2009-03-28 15:58:59.000000000 -0500
@@ -321,6 +321,7 @@ static const struct sd_desc sd_desc = {
  /* -- module initialisation -- */
  static const __devinitdata struct usb_device_id device_table[] = {
  	{USB_DEVICE(0x08ca, 0x0111)},
+	{USB_DEVICE(0x093a, 0x010f)},
  	{}
  };
  MODULE_DEVICE_TABLE(usb, device_table);



