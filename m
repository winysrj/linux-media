Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbbKDNnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2015 08:43:40 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH] [media] device-drivers.tmpl: better organize DVB function calls
Date: Wed,  4 Nov 2015 11:43:08 -0200
Message-Id: <21ed3d634adf42684cec35c31943da826c235688.1446644584.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Classify the functions at the DVB core per API. That makes easier
to understand how they're related to the userspace API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index c2bc8f779a9b..7defa42c4b24 100644
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
+	</sect1>
+	<sect1><title>Digital TV Frontend API</title>
+!Idrivers/media/dvb-core/dvb_frontend.h
+	</sect1>
+	<sect1><title>Digital TV Demux API</title>
 !Pdrivers/media/dvb-core/demux.h Digital TV Demux API
-     </sect1>
-     <sect1><title>Demux Callback API</title>
+	<sect1><title>Demux Callback API</title>
 !Pdrivers/media/dvb-core/demux.h Demux Callback API
-     </sect1>
+	</sect1>
 !Idrivers/media/dvb-core/demux.h
-    </sect1>
+	</sect1>
+	<sect1><title>Digital TV Conditional Access API</title>
+!Idrivers/media/dvb-core/dvb_ca_en50221.h
+	</sect1>
+     </sect1>
     <sect1><title>Remote Controller devices</title>
 !Iinclude/media/rc-core.h
 !Iinclude/media/lirc_dev.h
-- 
2.4.3

