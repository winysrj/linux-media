Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:3804 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZGXKh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 06:37:57 -0400
Received: by fg-out-1718.google.com with SMTP id e12so81751fga.17
        for <linux-media@vger.kernel.org>; Fri, 24 Jul 2009 03:37:54 -0700 (PDT)
Message-ID: <4A698F00.4060903@gmail.com>
Date: Fri, 24 Jul 2009 12:37:52 +0200
From: =?ISO-8859-1?Q?H=E1morszky_Bal=E1zs?= <balihb@gmail.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bugzilla-daemon@bugzilla.kernel.org, mchehab@infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [Bug 13708] Aiptek DV-T300 support is incomplete
References: <bug-13708-12914@http.bugzilla.kernel.org/>	<200907201949.n6KJnOdY016111@demeter.kernel.org>	<5c3736670907201337n41f08957r94fcde4383dd74d9@mail.gmail.com> <20090723160138.83a3579e.akpm@linux-foundation.org>
In-Reply-To: <20090723160138.83a3579e.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------050204020407090701040208"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050204020407090701040208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> The patch doesn't apply to current kernels and fixing it looks non-trivial.

I've attached a patch against the latest git tree.

> There's no hurry - please email us a complete (tested, changelogged,
> signed-off) patch when you have time to get onto it, thanks.

I can't test it. The patch worked partially with kernel 2.6.29, but I 
can't get it working with 2.6.30. With 2.6.29 the driver dies after a 
few seconds, but with 2.6.30 the programs won't detect the camera.
Also I only ported the patch to later kernels. I'm not the one who made 
it. The patch is originally from the creator of the driver. I also don't 
know how v4l works, so I have no idea how to fix the patch.

--------------050204020407090701040208
Content-Type: text/x-patch;
 name="zr364xx.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="zr364xx.diff"

--- a/zr364xx.c	2009-07-24 12:19:40.000000000 +0200
+++ b/zr364xx.c	2009-07-24 12:21:14.000000000 +0200
@@ -59,6 +59,7 @@
 #define METHOD0 0
 #define METHOD1 1
 #define METHOD2 2
+#define METHOD3 3
 
 
 /* Module parameters */
@@ -95,7 +96,7 @@ static struct usb_device_id device_table
 	{USB_DEVICE(0x06d6, 0x003b), .driver_info = METHOD0 },
 	{USB_DEVICE(0x0a17, 0x004e), .driver_info = METHOD2 },
 	{USB_DEVICE(0x041e, 0x405d), .driver_info = METHOD2 },
-	{USB_DEVICE(0x08ca, 0x2102), .driver_info = METHOD2 },
+	{USB_DEVICE(0x08ca, 0x2102), .driver_info = METHOD3 },
 	{}			/* Terminating entry */
 };
 
@@ -213,7 +214,7 @@ static message m2[] = {
 };
 
 /* init table */
-static message *init[3] = { m0, m1, m2 };
+static message *init[4] = { m0, m1, m2, m2 };
 
 
 /* JPEG static data in header (Huffman table, etc) */
@@ -347,6 +348,11 @@ static int read_frame(struct zr364xx_cam
 			    cam->buffer[3], cam->buffer[4], cam->buffer[5],
 			    cam->buffer[6], cam->buffer[7], cam->buffer[8]);
 		} else {
+			if (ptr + actual_length - jpeg > MAX_FRAME_SIZE)
+			{
+				DBG("frame too big!");
+				return 0;
+			}
 			memcpy(ptr, cam->buffer, actual_length);
 			ptr += actual_length;
 		}
@@ -847,6 +853,22 @@ static int zr364xx_probe(struct usb_inte
 	m0d1[0] = mode;
 	m1[2].value = 0xf000 + mode;
 	m2[1].value = 0xf000 + mode;
+
+	/* special case for METHOD3, the modes are different */
+	if (cam->method == METHOD3) {
+		switch (mode) {
+		case 1:
+			m2[1].value = 0xf000 + 4;
+			break;
+		case 2:
+			m2[1].value = 0xf000 + 0;
+			break;
+		default:
+			m2[1].value = 0xf000 + 1;
+			break;
+		}
+	}
+
 	header2[437] = cam->height / 256;
 	header2[438] = cam->height % 256;
 	header2[439] = cam->width / 256;

--------------050204020407090701040208--
