Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 28/39] [media] DocBook: Better organize media devices
Date: Sat, 22 Aug 2015 14:28:13 -0300
Message-Id: <23b15f8dc101e7accc41a5025a8b15af6534e674.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of putting all media devices on a flat structure,
split them on 4 types, just like we do with the userspace API:
	Video2Linux devices
	Digital TV (DVB) devices
	Remote Controller devices
	Media Controller devices

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 53a7c5d8b996..5c9375b98303 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -218,25 +218,34 @@ X!Isound/sound_firmware.c
 
   <chapter id="mediadev">
      <title>Media Devices</title>
-!Iinclude/media/media-device.h
-!Iinclude/media/media-devnode.h
-!Iinclude/media/media-entity.h
+
+     <sect1><title>Video2Linux devices</title>
 !Iinclude/media/v4l2-async.h
+!Iinclude/media/v4l2-ctrls.h
+!Iinclude/media/v4l2-dv-timings.h
+!Iinclude/media/v4l2-event.h
 !Iinclude/media/v4l2-flash-led-class.h
+!Iinclude/media/v4l2-mediabus.h
 !Iinclude/media/v4l2-mem2mem.h
 !Iinclude/media/v4l2-of.h
 !Iinclude/media/v4l2-subdev.h
-!Iinclude/media/rc-core.h
+!Iinclude/media/videobuf2-core.h
+!Iinclude/media/videobuf2-memops.h
+     </sect1>
+     <sect1><title>Digital TV (DVB) devices</title>
 !Idrivers/media/dvb-core/dvb_ca_en50221.h
 !Idrivers/media/dvb-core/dvb_frontend.h
 !Idrivers/media/dvb-core/dvb_math.h
 !Idrivers/media/dvb-core/dvb_ringbuffer.h
-!Iinclude/media/v4l2-ctrls.h
-!Iinclude/media/v4l2-event.h
-!Iinclude/media/v4l2-dv-timings.h
-!Iinclude/media/videobuf2-core.h
-!Iinclude/media/videobuf2-memops.h
-!Iinclude/media/v4l2-mediabus.h
+     </sect1>
+     <sect1><title>Remote Controller devices</title>
+!Iinclude/media/rc-core.h
+     </sect1>
+     <sect1><title>Media Controller devices</title>
+!Iinclude/media/media-device.h
+!Iinclude/media/media-devnode.h
+!Iinclude/media/media-entity.h
+     </sect1>
 
   </chapter>
 
-- 
2.4.3

