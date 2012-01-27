Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm2.telefonica.net ([213.4.138.18]:42692 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753815Ab2A0Wnw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 17:43:52 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] Increase mt2063 frequency_max
Date: Fri, 27 Jan 2012 23:43:28 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QiyIPCLM6jfJBH1"
Message-Id: <201201272343.28624.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_QiyIPCLM6jfJBH1
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Increase mt2063 frequency_max to tune to channel 69(858Mhz).

Jose Alberto

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

--Boundary-00=_QiyIPCLM6jfJBH1
Content-Type: text/x-patch;
  charset="UTF-8";
  name="mt2063.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mt2063.diff"

diff -ur linux/drivers/media/common/tuners/mt2063.c linux.new/drivers/media/common/tuners/mt2063.c
--- linux/drivers/media/common/tuners/mt2063.c	2012-01-22 02:53:17.000000000 +0100
+++ linux.new/drivers/media/common/tuners/mt2063.c	2012-01-27 23:36:23.273848131 +0100
@@ -2226,7 +2226,7 @@
 	.info = {
 		 .name = "MT2063 Silicon Tuner",
 		 .frequency_min = 45000000,
-		 .frequency_max = 850000000,
+		 .frequency_max = 865000000,
 		 .frequency_step = 0,
 		 },
 

--Boundary-00=_QiyIPCLM6jfJBH1--
