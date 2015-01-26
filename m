Return-path: <linux-media-owner@vger.kernel.org>
Received: from cavendish.fsfeurope.org ([217.69.89.162]:44792 "EHLO
	cavendish.fsfeurope.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbbAZKpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 05:45:11 -0500
Received: from localhost (localhost [127.0.0.1])
	by cavendish.fsfeurope.org (Postfix) with ESMTP id 6A89E63AC0E
	for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 11:38:21 +0100 (CET)
Received: from cavendish.fsfeurope.org ([127.0.0.1])
	by localhost (cavendish.fsfeurope.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id swmdwrgU0T6y for <linux-media@vger.kernel.org>;
	Mon, 26 Jan 2015 11:38:19 +0100 (CET)
Received: from [10.0.0.70] (dynamic-adsl-78-12-229-93.clienti.tiscali.it [78.12.229.93])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	(Authenticated sender: lucabon)
	by cavendish.fsfeurope.org (Postfix) with ESMTPSA id 10EA563A623
	for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 11:38:18 +0100 (CET)
Message-ID: <54C61919.7050508@scarsita.it>
Date: Mon, 26 Jan 2015 11:38:17 +0100
From: Luca Bonissi <lucabon@scarsita.it>
MIME-Version: 1.0
To: Linux Media <linux-media@vger.kernel.org>
Subject: [PATCH] media: gspca_vc032x - wrong bytesperline
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I found a problem on vc032x gspca usb webcam subdriver: "bytesperline" 
property is wrong for YUYV and YVYU formats.
With recent v4l-utils library (>=0.9.1), that uses "bytesperline" for 
pixel format conversion, the result is a wrong jerky image.

Patch tested on my laptop (USB webcam Logitech Orbicam 046d:0892).

--- drivers/media/usb/gspca/vc032x.c.orig       2014-08-04 
00:25:02.000000000 +0200
+++ drivers/media/usb/gspca/vc032x.c    2015-01-12 00:28:39.423311693 +0100
@@ -68,12 +68,12 @@

  static const struct v4l2_pix_format vc0321_mode[] = {
         {320, 240, V4L2_PIX_FMT_YVYU, V4L2_FIELD_NONE,
-               .bytesperline = 320,
+               .bytesperline = 320 * 2,
                 .sizeimage = 320 * 240 * 2,
                 .colorspace = V4L2_COLORSPACE_SRGB,
                 .priv = 1},
         {640, 480, V4L2_PIX_FMT_YVYU, V4L2_FIELD_NONE,
-               .bytesperline = 640,
+               .bytesperline = 640 * 2,
                 .sizeimage = 640 * 480 * 2,
                 .colorspace = V4L2_COLORSPACE_SRGB,
                 .priv = 0},
@@ -97,12 +97,12 @@
  };
  static const struct v4l2_pix_format bi_mode[] = {
         {320, 240, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
-               .bytesperline = 320,
+               .bytesperline = 320 * 2,
                 .sizeimage = 320 * 240 * 2,
                 .colorspace = V4L2_COLORSPACE_SRGB,
                 .priv = 2},
         {640, 480, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
-               .bytesperline = 640,
+               .bytesperline = 640 * 2,
                 .sizeimage = 640 * 480 * 2,
                 .colorspace = V4L2_COLORSPACE_SRGB,
                 .priv = 1},

