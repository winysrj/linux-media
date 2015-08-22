Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbbHVR2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 02/39] [media] DocBook/device-drivers: Add drivers/media core stuff
Date: Sat, 22 Aug 2015 14:27:47 -0300
Message-Id: <0d68d6d9db29daa308db7fb3946b84bc537286b5.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of docbook marks at the media subsystem, but
those aren't used.

Add the core headers/code in order to start generating docs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index faf09d4a0ea8..e3e0f4880770 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -216,6 +216,36 @@ X!Isound/sound_firmware.c
 -->
   </chapter>
 
+  <chapter id="mediadev">
+     <title>Media Devices</title>
+!Iinclude/media/media-device.h
+!Iinclude/media/media-devnode.h
+!Iinclude/media/media-entity.h
+!Iinclude/media/v4l2-async.h
+!Iinclude/media/v4l2-flash-led-class.h
+!Iinclude/media/v4l2-mem2mem.h
+!Iinclude/media/v4l2-of.h
+!Iinclude/media/v4l2-subdev.h
+!Iinclude/media/rc-core.h
+<!-- FIXME: Removed for now due to document generation inconsistency
+X!Iinclude/media/v4l2-ctrls.h
+X!Iinclude/media/v4l2-dv-timings.h
+X!Iinclude/media/v4l2-event.h
+X!Iinclude/media/v4l2-mediabus.h
+X!Iinclude/media/videobuf2-memops.h
+X!Iinclude/media/videobuf2-core.h
+X!Iinclude/media/lirc.h
+X!Edrivers/media/dvb-core/dvb_demux.c
+X!Idrivers/media/dvb-core/dvb_frontend.h
+X!Idrivers/media/dvb-core/dvbdev.h
+X!Edrivers/media/dvb-core/dvb_net.c
+X!Idrivers/media/dvb-core/dvb_ringbuffer.h
+X!Idrivers/media/dvb-core/dvb_ca_en50221.h
+X!Idrivers/media/dvb-core/dvb_math.h
+-->
+
+  </chapter>
+
   <chapter id="uart16x50">
      <title>16x50 UART Driver</title>
 !Edrivers/tty/serial/serial_core.c
diff --git a/drivers/media/dvb-core/dvb_math.h b/drivers/media/dvb-core/dvb_math.h
index aecc867e9404..f586aa001ede 100644
--- a/drivers/media/dvb-core/dvb_math.h
+++ b/drivers/media/dvb-core/dvb_math.h
@@ -30,9 +30,10 @@
  * to use rational values you can use the following method:
  *   intlog2(value) = intlog2(value * 2^x) - x * 2^24
  *
- * example: intlog2(8) will give 3 << 24 = 3 * 2^24
- * example: intlog2(9) will give 3 << 24 + ... = 3.16... * 2^24
- * example: intlog2(1.5) = intlog2(3) - 2^24 = 0.584... * 2^24
+ * Some usecase examples:
+ *	intlog2(8) will give 3 << 24 = 3 * 2^24
+ *	intlog2(9) will give 3 << 24 + ... = 3.16... * 2^24
+ *	intlog2(1.5) = intlog2(3) - 2^24 = 0.584... * 2^24
  *
  * @param value The value (must be != 0)
  * @return log2(value) * 2^24
@@ -45,7 +46,8 @@ extern unsigned int intlog2(u32 value);
  * to use rational values you can use the following method:
  *   intlog10(value) = intlog10(value * 10^x) - x * 2^24
  *
- * example: intlog10(1000) will give 3 << 24 = 3 * 2^24
+ * An usecase example:
+ *	intlog10(1000) will give 3 << 24 = 3 * 2^24
  *   due to the implementation intlog10(1000) might be not exactly 3 * 2^24
  *
  * look at intlog2 for similar examples
-- 
2.4.3

