Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39243 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbbKDOHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2015 09:07:34 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH v2] [media] device-drivers.tmpl: better organize DVB function calls
Date: Wed,  4 Nov 2015 12:07:02 -0200
Message-Id: <b8aabc5ebfec7292c760b49814866baf35e8c5f6.1446645989.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Classify the functions at the DVB core per API. That makes easier
to understand how they're related to the userspace API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index c2bc8f779a9b..fc7242dd5d65 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -238,19 +238,25 @@ X!Isound/sound_firmware.c
 !Iinclude/media/videobuf2-memops.h
      </sect1>
      <sect1><title>Digital TV (DVB) devices</title>
-!Idrivers/media/dvb-core/dvb_ca_en50221.h
-!Idrivers/media/dvb-core/dvb_frontend.h
+	<sect1><title>Digital TV Common functions</title>
 !Idrivers/media/dvb-core/dvb_math.h
 !Idrivers/media/dvb-core/dvb_ringbuffer.h
 !Idrivers/media/dvb-core/dvbdev.h
-     <sect1><title>Digital TV Demux API</title>
-!Pdrivers/media/dvb-core/demux.h Digital TV Demux API
-     </sect1>
-     <sect1><title>Demux Callback API</title>
-!Pdrivers/media/dvb-core/demux.h Demux Callback API
-     </sect1>
+	</sect1>
+	<sect1><title>Digital TV Frontend kABI</title>
+!Idrivers/media/dvb-core/dvb_frontend.h
+	</sect1>
+	<sect1><title>Digital TV Demux kABI</title>
+!Pdrivers/media/dvb-core/demux.h Digital TV Demux
+	<sect1><title>Demux Callback API</title>
+!Pdrivers/media/dvb-core/demux.h Demux Callback
+	</sect1>
 !Idrivers/media/dvb-core/demux.h
-    </sect1>
+	</sect1>
+	<sect1><title>Digital TV Conditional Access kABI</title>
+!Idrivers/media/dvb-core/dvb_ca_en50221.h
+	</sect1>
+     </sect1>
     <sect1><title>Remote Controller devices</title>
 !Iinclude/media/rc-core.h
 !Iinclude/media/lirc_dev.h
diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index f8014aabf37b..f716e14f995f 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -33,7 +33,7 @@
 #include <linux/dvb/dmx.h>
 
 /**
- * DOC: Digital TV Demux API
+ * DOC: Digital TV Demux
  *
  * The kernel demux API defines a driver-internal interface for registering
  * low-level, hardware specific driver to a hardware independent demux layer.
@@ -231,7 +231,7 @@ struct dmx_section_feed {
 };
 
 /**
- * DOC: Demux Callback API
+ * DOC: Demux Callback
  *
  * This kernel-space API comprises the callback functions that deliver filtered
  * data to the demux client. Unlike the other DVB kABIs, these functions are
-- 
2.4.3

