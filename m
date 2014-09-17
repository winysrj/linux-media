Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3252 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaIQJO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 05:14:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/4] saa7134: also capture the WSS signal for 50 Hz VBI capture
Date: Wed, 17 Sep 2014 11:14:32 +0200
Message-Id: <1410945272-48149-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
References: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

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

