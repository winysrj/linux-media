Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:44664 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753353Ab2FJBow (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 21:44:52 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: [PATCH 1/9] tvaudio: fix TDA9873 constants
Date: Sun, 10 Jun 2012 03:43:50 +0200
Message-Id: <1339292638-12205-2-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <20120609214100.GA1598@minime.bse>
References: <20120609214100.GA1598@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These constants were unused so far but need | instead of &.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
---
 drivers/media/video/tvaudio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index c5b1a73..9b85e2a 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -583,7 +583,7 @@ static void tda985x_setmode(struct CHIPSTATE *chip, int mode)
 #define TDA9873_TR_MASK     (7 << 2)
 #define TDA9873_TR_MONO     4
 #define TDA9873_TR_STEREO   1 << 4
-#define TDA9873_TR_REVERSE  (1 << 3) & (1 << 2)
+#define TDA9873_TR_REVERSE  ((1 << 3) | (1 << 2))
 #define TDA9873_TR_DUALA    1 << 2
 #define TDA9873_TR_DUALB    1 << 3
 
@@ -653,11 +653,11 @@ static void tda985x_setmode(struct CHIPSTATE *chip, int mode)
 #define TDA9873_MOUT_DUALA  0
 #define TDA9873_MOUT_DUALB  1 << 3
 #define TDA9873_MOUT_ST     1 << 4
-#define TDA9873_MOUT_EXTM   (1 << 4 ) & (1 << 3)
+#define TDA9873_MOUT_EXTM   ((1 << 4) | (1 << 3))
 #define TDA9873_MOUT_EXTL   1 << 5
-#define TDA9873_MOUT_EXTR   (1 << 5 ) & (1 << 3)
-#define TDA9873_MOUT_EXTLR  (1 << 5 ) & (1 << 4)
-#define TDA9873_MOUT_MUTE   (1 << 5 ) & (1 << 4) & (1 << 3)
+#define TDA9873_MOUT_EXTR   ((1 << 5) | (1 << 3))
+#define TDA9873_MOUT_EXTLR  ((1 << 5) | (1 << 4))
+#define TDA9873_MOUT_MUTE   ((1 << 5) | (1 << 4) | (1 << 3))
 
 /* Status bits: (chip read) */
 #define TDA9873_PONR        0 /* Power-on reset detected if = 1 */
-- 
1.7.0.5

