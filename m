Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40423 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbbHVR2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:37 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 18/39] [media] DocBook: add dvb_math.h to documentation
Date: Sat, 22 Aug 2015 14:28:03 -0300
Message-Id: <3a8ad6c7a40480d9d09a83f4a5277e9aa43f3669.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are already some comments at dvb_math.h that are ready
for DocBook, although not properly formatted.

Convert them, fix some issues and add this file to
the device-drivers DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index fb5c16a24e4b..21fc7684d706 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -229,6 +229,7 @@ X!Isound/sound_firmware.c
 !Iinclude/media/rc-core.h
 !Idrivers/media/dvb-core/dvb_ca_en50221.h
 !Idrivers/media/dvb-core/dvb_frontend.h
+!Idrivers/media/dvb-core/dvb_math.h
 <!-- FIXME: Removed for now due to document generation inconsistency
 X!Iinclude/media/v4l2-ctrls.h
 X!Iinclude/media/v4l2-dv-timings.h
@@ -241,7 +242,6 @@ X!Edrivers/media/dvb-core/dvb_demux.c
 X!Idrivers/media/dvb-core/dvbdev.h
 X!Edrivers/media/dvb-core/dvb_net.c
 X!Idrivers/media/dvb-core/dvb_ringbuffer.h
-X!Idrivers/media/dvb-core/dvb_math.h
 -->
 
   </chapter>
diff --git a/drivers/media/dvb-core/dvb_math.h b/drivers/media/dvb-core/dvb_math.h
index f586aa001ede..34dc1df03cab 100644
--- a/drivers/media/dvb-core/dvb_math.h
+++ b/drivers/media/dvb-core/dvb_math.h
@@ -25,7 +25,9 @@
 #include <linux/types.h>
 
 /**
- * computes log2 of a value; the result is shifted left by 24 bits
+ * cintlog2 - computes log2 of a value; the result is shifted left by 24 bits
+ *
+ * @value: The value (must be != 0)
  *
  * to use rational values you can use the following method:
  *   intlog2(value) = intlog2(value * 2^x) - x * 2^24
@@ -35,13 +37,15 @@
  *	intlog2(9) will give 3 << 24 + ... = 3.16... * 2^24
  *	intlog2(1.5) = intlog2(3) - 2^24 = 0.584... * 2^24
  *
- * @param value The value (must be != 0)
- * @return log2(value) * 2^24
+ *
+ * return: log2(value) * 2^24
  */
 extern unsigned int intlog2(u32 value);
 
 /**
- * computes log10 of a value; the result is shifted left by 24 bits
+ * intlog10 - computes log10 of a value; the result is shifted left by 24 bits
+ *
+ * @value: The value (must be != 0)
  *
  * to use rational values you can use the following method:
  *   intlog10(value) = intlog10(value * 10^x) - x * 2^24
@@ -52,8 +56,7 @@ extern unsigned int intlog2(u32 value);
  *
  * look at intlog2 for similar examples
  *
- * @param value The value (must be != 0)
- * @return log10(value) * 2^24
+ * return: log10(value) * 2^24
  */
 extern unsigned int intlog10(u32 value);
 
-- 
2.4.3

