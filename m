Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2238 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaIUJjH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 05:39:07 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8L9d0ST097923
	for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 11:39:02 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6494A2A002F
	for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 11:38:55 +0200 (CEST)
Message-ID: <541E9CAF.7070501@xs4all.nl>
Date: Sun, 21 Sep 2014 11:38:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] saa7134: also capture the WSS signal for 50 Hz VBI capture
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The saa7134 driver missed capturing line 23 of the VBI area for the
50 Hz formats. Include that line in the VBI capture.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-vbi.c   | 2 +-
 drivers/media/pci/saa7134/saa7134-video.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index c06dbe1..4f0b101 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -43,7 +43,7 @@ MODULE_PARM_DESC(vbibufs,"number of vbi buffers, range 2-32");
 
 /* ------------------------------------------------------------------ */
 
-#define VBI_LINE_COUNT     16
+#define VBI_LINE_COUNT     17
 #define VBI_LINE_LENGTH  2048
 #define VBI_SCALE       0x200
 
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 0cfa2ca..fc4a427 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -201,7 +201,7 @@ static struct saa7134_format formats[] = {
 		.video_v_start = 24,	\
 		.video_v_stop  = 311,	\
 		.vbi_v_start_0 = 7,	\
-		.vbi_v_stop_0  = 22,	\
+		.vbi_v_stop_0  = 23,	\
 		.vbi_v_start_1 = 319,   \
 		.src_timing    = 4
 
-- 
2.1.0

