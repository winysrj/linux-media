Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailhub4.uq.edu.au ([130.102.149.131]:49500 "EHLO
	mailhub4.uq.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZAVGAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 01:00:05 -0500
Received: from smtp4.uq.edu.au (smtp4.uq.edu.au [130.102.128.19])
	by mailhub4.uq.edu.au (8.13.8/8.13.8) with ESMTP id n0M5krZk018424
	for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 15:46:53 +1000
Received: from g5160130 (g516-0130.itee.uq.edu.au [130.102.67.59])
	by smtp4.uq.edu.au (8.13.8/8.13.8) with SMTP id n0M5kqCi024457
	for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 15:46:53 +1000
Message-ID: <E71DEEA082EA4F44BB65295ECBF996C7@itee.uq.edu.au>
From: "Douglas Kosovic" <douglask@itee.uq.edu.au>
To: <linux-media@vger.kernel.org>
Subject: [PATCH] IVCE-8784 support for V4L2 bttv driver
Date: Thu, 22 Jan 2009 15:46:53 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please find below a patch for the IVCE-8784.

It's a quad Bt878 PCI-e x1 capture board that's basically the same as the
IVC-200 (quad Bt878 PCI) capture board that's currently supported in
the V4L2 bttv driver.

Manufacturer's web page for IVCE-8784 with photo and info:
  http://www.iei.com.tw/en/product_IPC.asp?model=IVCE-8784

Signed-off-by: Douglas Kosovic <douglask@itee.uq.edu.au>

Thanks,
Doug

diff -r f4d7d0b84940 linux/drivers/media/video/bt8xx/bttv-cards.c
--- a/linux/drivers/media/video/bt8xx/bttv-cards.c Sun Jan 18 10:55:38 2009 
+0000
+++ b/linux/drivers/media/video/bt8xx/bttv-cards.c Thu Jan 22 15:42:30 2009 
+1000
@@ -247,6 +247,10 @@
  { 0xa182ff0d, BTTV_BOARD_IVC120,        "IVC-120G" },
  { 0xa182ff0e, BTTV_BOARD_IVC120,        "IVC-120G" },
  { 0xa182ff0f, BTTV_BOARD_IVC120,        "IVC-120G" },
+ { 0xf0500000, BTTV_BOARD_IVCE8784,      "IVCE-8784" },
+ { 0xf0500001, BTTV_BOARD_IVCE8784,      "IVCE-8784" },
+ { 0xf0500002, BTTV_BOARD_IVCE8784,      "IVCE-8784" },
+ { 0xf0500003, BTTV_BOARD_IVCE8784,      "IVCE-8784" },

  { 0x41424344, BTTV_BOARD_GRANDTEC,      "GrandTec Multi Capture" },
  { 0x01020304, BTTV_BOARD_XGUARD,        "Grandtec Grand X-Guard" },
@@ -2182,6 +2186,19 @@
   .muxsel         = { 2 },
   .pll            = PLL_28,
  },
+ [BTTV_BOARD_IVCE8784] = {
+  .name           = "IVCE-8784",
+  .video_inputs   = 1,
+  .audio_inputs   = 0,
+  .tuner          = UNSET,
+  .tuner_type     = UNSET,
+  .tuner_addr = ADDR_UNSET,
+  .radio_addr     = ADDR_UNSET,
+  .svhs           = UNSET,
+  .gpiomask       = 0xdf,
+  .muxsel         = { 2 },
+  .pll            = PLL_28,
+ },
  [BTTV_BOARD_XGUARD] = {
   .name           = "Grand X-Guard / Trust 814PCI",
   .video_inputs   = 16,
diff -r f4d7d0b84940 linux/drivers/media/video/bt8xx/bttv.h
--- a/linux/drivers/media/video/bt8xx/bttv.h Sun Jan 18 10:55:38 2009 +0000
+++ b/linux/drivers/media/video/bt8xx/bttv.h Thu Jan 22 15:42:30 2009 +1000
@@ -181,6 +181,7 @@
 #define BTTV_BOARD_VD012     0x99
 #define BTTV_BOARD_VD012_X1     0x9a
 #define BTTV_BOARD_VD012_X2     0x9b
+#define BTTV_BOARD_IVCE_8784     0x9c


 /* more card-specific defines */


