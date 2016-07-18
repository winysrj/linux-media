Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbcGRB4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 27/36] [media] doc-rst: add sh_mobile_ceu_camera crop documentation
Date: Sun, 17 Jul 2016 22:56:10 -0300
Message-Id: <9cbfcd7cf230393d12a587fdad11c60de5c1f7be.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST and add it to media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst          |  1 +
 .../media/v4l-drivers/sh_mobile_ceu_camera.rst     | 57 +++++++++++-----------
 2 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index f761627d3fa1..64556192f12a 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -34,4 +34,5 @@ License".
 	pxa_camera
 	radiotrack
 	saa7134
+	sh_mobile_ceu_camera
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst b/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
index 1e96ce6e2d2f..e40ffea7708c 100644
--- a/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
+++ b/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
@@ -1,5 +1,7 @@
-	Cropping and Scaling algorithm, used in the sh_mobile_ceu_camera driver
-	=======================================================================
+Cropping and Scaling algorithm, used in the sh_mobile_ceu_camera driver
+=======================================================================
+
+Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 
 Terminology
 -----------
@@ -12,29 +14,31 @@ combined scales: sensor_scale * host_scale
 Generic scaling / cropping scheme
 ---------------------------------
 
--1--
-|
--2-- -\
-|      --\
-|         --\
-+-5-- .      -- -3-- -\
-|      `...            -\
-|          `... -4-- .   - -7..
-|                     `.
-|                       `. .6--
-|
-|                        . .6'-
-|                      .´
-|           ... -4'- .´
-|       ...´             - -7'.
-+-5'- .´               -/
-|            -- -3'- -/
-|         --/
-|      --/
--2'- -/
-|
-|
--1'-
+.. code-block:: none
+
+	-1--
+	|
+	-2-- -\
+	|      --\
+	|         --\
+	+-5-- .      -- -3-- -\
+	|      `...            -\
+	|          `... -4-- .   - -7..
+	|                     `.
+	|                       `. .6--
+	|
+	|                        . .6'-
+	|                      .´
+	|           ... -4'- .´
+	|       ...´             - -7'.
+	+-5'- .´               -/
+	|            -- -3'- -/
+	|         --/
+	|      --/
+	-2'- -/
+	|
+	|
+	-1'-
 
 In the above chart minuses and slashes represent "real" data amounts, points and
 accents represent "useful" data, basically, CEU scaled and cropped output,
@@ -134,6 +138,3 @@ Cropping is performed in the following 6 steps:
 5. Calculate and apply host scale = (6' - 6) / (4' - 4)
 
 6. Calculate and apply host crop: 6 - 7 = (5 - 2) * (6' - 6) / (5' - 5)
-
---
-Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
-- 
2.7.4

