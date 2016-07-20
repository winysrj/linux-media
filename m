Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbcGTOlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:41:40 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Subject: [PATCH 2/5] [media] doc-rst: Fix some Sphinx warnings
Date: Wed, 20 Jul 2016 11:41:32 -0300
Message-Id: <d612024e7d2acd7ec82c75b5fed271fd61673386.1469025360.git.mchehab@s-opensource.com>
In-Reply-To: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
References: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
In-Reply-To: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
References: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix all remaining media warnings with ReST that are fixable
without changing at the Sphinx code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cx88.rst            | 1 +
 Documentation/media/v4l-drivers/tm6000-cardlist.rst | 2 +-
 drivers/media/dvb-core/dvb_math.h                   | 7 +++++++
 include/media/media-entity.h                        | 6 ++++--
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/v4l-drivers/cx88.rst b/Documentation/media/v4l-drivers/cx88.rst
index 97865007f51f..d8f3a014726a 100644
--- a/Documentation/media/v4l-drivers/cx88.rst
+++ b/Documentation/media/v4l-drivers/cx88.rst
@@ -119,6 +119,7 @@ GPIO 16(I believe) is tied to the IR port (if present).
 From the data sheet:
 
 - Register 24'h20004  PCI Interrupt Status
+
  - bit [18]  IR_SMP_INT Set when 32 input samples have been collected over
  - gpio[16] pin into GP_SAMPLE register.
 
diff --git a/Documentation/media/v4l-drivers/tm6000-cardlist.rst b/Documentation/media/v4l-drivers/tm6000-cardlist.rst
index ca08d4214b38..2fbd3886b5f0 100644
--- a/Documentation/media/v4l-drivers/tm6000-cardlist.rst
+++ b/Documentation/media/v4l-drivers/tm6000-cardlist.rst
@@ -1,5 +1,5 @@
 TM6000 cards list
-===============
+=================
 
 .. code-block:: none
 
diff --git a/drivers/media/dvb-core/dvb_math.h b/drivers/media/dvb-core/dvb_math.h
index 34dc1df03cab..2f0326674ca6 100644
--- a/drivers/media/dvb-core/dvb_math.h
+++ b/drivers/media/dvb-core/dvb_math.h
@@ -30,11 +30,15 @@
  * @value: The value (must be != 0)
  *
  * to use rational values you can use the following method:
+ *
  *   intlog2(value) = intlog2(value * 2^x) - x * 2^24
  *
  * Some usecase examples:
+ *
  *	intlog2(8) will give 3 << 24 = 3 * 2^24
+ *
  *	intlog2(9) will give 3 << 24 + ... = 3.16... * 2^24
+ *
  *	intlog2(1.5) = intlog2(3) - 2^24 = 0.584... * 2^24
  *
  *
@@ -48,10 +52,13 @@ extern unsigned int intlog2(u32 value);
  * @value: The value (must be != 0)
  *
  * to use rational values you can use the following method:
+ *
  *   intlog10(value) = intlog10(value * 10^x) - x * 2^24
  *
  * An usecase example:
+ *
  *	intlog10(1000) will give 3 << 24 = 3 * 2^24
+ *
  *   due to the implementation intlog10(1000) might be not exactly 3 * 2^24
  *
  * look at intlog2 for similar examples
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 83877719bef4..3d885d97d149 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -180,8 +180,10 @@ struct media_pad {
  *			view. The media_entity_pipeline_start() function
  *			validates all links by calling this operation. Optional.
  *
- * .. note:: Those these callbacks are called with struct media_device.@graph_mutex
- * mutex held.
+ * .. note::
+ *
+ *    Those these callbacks are called with struct media_device.@graph_mutex
+ *    mutex held.
  */
 struct media_entity_operations {
 	int (*link_setup)(struct media_entity *entity,
-- 
2.7.4

