Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.211.175]:46695 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbZIGXfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 19:35:43 -0400
Received: by ywh5 with SMTP id 5so3993362ywh.4
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 16:35:46 -0700 (PDT)
Date: Tue, 8 Sep 2009 09:36:05 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] Key filter for BeholdTV cards.
Message-ID: <20090908093605.25f8c68d@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/W_CCQcf9C1tuLp=eKO7uvLE"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/W_CCQcf9C1tuLp=eKO7uvLE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All.

When fast push-pull button of remote control we can received incorrect
key code 0x00. Key information from IR decoder has ID of remote control 2 bytes,
byte of key code and byte of mirror key code.
Correct data
0x86 0x6B 0x00 0xFF

Wrong data
0x86 0x6B 0x00 0x00

This patch added additional test of mirror byte for filtering.

diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Mon Sep 07 18:05:54 2009 +1000
@@ -286,6 +286,10 @@
 	 * So, skip not our, if disable full codes mode.
 	 */
 	if (data[10] != 0x6b && data[11] != 0x86 && disable_other_ir)
+		return 0;
+
+	/* Wrong data decode fix */
+	if (data[9] != (unsigned char)(~data[8]))
 		return 0;
 
 	*ir_key = data[9];
Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.
--MP_/W_CCQcf9C1tuLp=eKO7uvLE
Content-Type: text/x-patch; name=behold_remote.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_remote.patch

diff -r 2b49813f8482 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Mon Sep 07 18:05:54 2009 +1000
@@ -286,6 +286,10 @@
 	 * So, skip not our, if disable full codes mode.
 	 */
 	if (data[10] != 0x6b && data[11] != 0x86 && disable_other_ir)
+		return 0;
+
+	/* Wrong data decode fix */
+	if (data[9] != (unsigned char)(~data[8]))
 		return 0;
 
 	*ir_key = data[9];
Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/W_CCQcf9C1tuLp=eKO7uvLE--
