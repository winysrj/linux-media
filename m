Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbbHURTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 13:19:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH RFC] DocBook/device-drivers: Add drivers/media core stuff
Date: Fri, 21 Aug 2015 14:19:29 -0300
Message-Id: <0b59c6937385d55415fdeeb822c2cf6fc6c79276.1440177559.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of docbook marks at the media subsystem, but
those aren't used.

Add the core headers/code in order to start generating docs.

=======
WARNING:
=======

Please notice that the output is currently broken:
	http://pastebin.com/JcXsqcVH

Before applying this one, we need to fix the stuff there!

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index faf09d4a0ea8..a273c4fd774e 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -216,6 +216,34 @@ X!Isound/sound_firmware.c
 -->
   </chapter>
 
+  <chapter id="mediadev">
+     <title>Media Devices</title>
+!Iinclude/media/media-device.h
+!Iinclude/media/media-devnode.h
+!Iinclude/media/media-entity.h
+!Iinclude/media/v4l2-async.h
+!Iinclude/media/v4l2-ctrls.h
+!Iinclude/media/v4l2-dv-timings.h
+!Iinclude/media/v4l2-event.h
+!Iinclude/media/v4l2-flash-led-class.h
+!Iinclude/media/v4l2-mediabus.h
+!Iinclude/media/v4l2-mem2mem.h
+!Iinclude/media/v4l2-of.h
+!Iinclude/media/v4l2-subdev.h
+!Iinclude/media/videobuf2-core.h
+!Iinclude/media/videobuf2-memops.h
+!Iinclude/media/rc-core.h
+!Iinclude/media/lirc.h
+!Idrivers/media/dvb-core/dvb_ca_en50221.h
+!Edrivers/media/dvb-core/dvb_demux.c
+!Idrivers/media/dvb-core/dvb_frontend.h
+!Idrivers/media/dvb-core/dvb_math.h
+!Edrivers/media/dvb-core/dvb_net.c
+!Idrivers/media/dvb-core/dvb_ringbuffer.h
+!Idrivers/media/dvb-core/dvbdev.h
+
+  </chapter>
+
   <chapter id="uart16x50">
      <title>16x50 UART Driver</title>
 !Edrivers/tty/serial/serial_core.c
-- 
2.4.3

