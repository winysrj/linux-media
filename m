Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:61878 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab3LPIWq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 03:22:46 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 1/2] [media] Documentation/DocBook/media/v4l/subdev-formats.xml: fix a typo
Date: Mon, 16 Dec 2013 09:16:45 +0100
Message-Id: <1387181806-17021-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1387181806-17021-1-git-send-email-ospite@studenti.unina.it>
References: <1387181806-17021-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The xref to the v4l2-mbus-pixelcode-yuv8 table gets rendered as "Table
4.22, “YUV Formats”", so use the verb in the third person singular
because it refers to "Table":
  s/list/lists/

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index f72c1cc..bbe30cd 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -1178,7 +1178,7 @@
       U, Y, V, Y order will be named <constant>V4L2_MBUS_FMT_UYVY8_2X8</constant>.
       </para>
 
-	<para><xref linkend="v4l2-mbus-pixelcode-yuv8"/> list existing packet YUV
+	<para><xref linkend="v4l2-mbus-pixelcode-yuv8"/> lists existing packet YUV
 	formats and describes the organization of each pixel data in each sample.
 	When a format pattern is split across multiple samples each of the samples
 	in the pattern is described.</para>
-- 
1.8.5.1

