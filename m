Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37151 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2KDTQj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2012 14:16:39 -0500
Received: by mail-we0-f174.google.com with SMTP id t9so2325995wey.19
        for <linux-media@vger.kernel.org>; Sun, 04 Nov 2012 11:16:38 -0800 (PST)
Message-ID: <1352056591.7322.5.camel@Route3278>
Subject: [PATCH] add MAINTAINERS entry
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 04 Nov 2012 19:16:31 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 MAINTAINERS |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 28eeaec..ac738f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4100,6 +4100,22 @@ S:	Maintained
 F:	Documentation/hwmon/it87
 F:	drivers/hwmon/it87.c
 
+IT913X MEDIA DRIVER
+M:	Malcolm Priestley <tvboxspy@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/it913x*
+
+IT913X FE MEDIA DRIVER
+M:	Malcolm Priestley <tvboxspy@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+S:	Maintained
+F:	drivers/media/dvb-frontends/it913x-fe*
+
 IVTV VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
 L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
@@ -4111,6 +4127,14 @@ F:	Documentation/video4linux/*.ivtv
 F:	drivers/media/pci/ivtv/
 F:	include/linux/ivtv*
 
+IX2505V MEDIA DRIVER
+M:	Malcolm Priestley <tvboxspy@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+S:	Maintained
+F:	drivers/media/dvb-frontends/ix2505v*
+
 JC42.4 TEMPERATURE SENSOR DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
 L:	lm-sensors@lm-sensors.org
@@ -4555,6 +4579,14 @@ S:	Maintained
 F:	Documentation/hwmon/lm90
 F:	drivers/hwmon/lm90.c
 
+LME2510 MEDIA DRIVER
+M:	Malcolm Priestley <tvboxspy@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/lmedm04*
+
 LOCKDEP AND LOCKSTAT
 M:	Peter Zijlstra <peterz@infradead.org>
 M:	Ingo Molnar <mingo@redhat.com>
@@ -4645,6 +4677,14 @@ W:	http://www.tazenda.demon.co.uk/phil/linux-hp
 S:	Maintained
 F:	arch/m68k/hp300/
 
+M88RS2000 MEDIA DRIVER
+M:	Malcolm Priestley <tvboxspy@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+S:	Maintained
+F:	drivers/media/dvb-frontends/m88rs2000*
+
 MAC80211
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
-- 
1.7.10.4


