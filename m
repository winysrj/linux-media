Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:59474 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbcGDNUa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:20:30 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] MAINTAINERS: change maintainer for gscpa/pwc/radio-shark
Message-ID: <606f9f65-2ca9-d2dd-b9e2-e12a9aeaa0f7@xs4all.nl>
Date: Mon, 4 Jul 2016 15:20:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede has no more time to work on those, so I'll take over.
For gspca/pwc I'll do 'Odd Fixes', for radio-shark I'll be a
full maintainer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 02299fd..9499b8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5163,10 +5163,10 @@ S:	Maintained
 F:	drivers/media/usb/gspca/m5602/

 GSPCA PAC207 SONIXB SUBDRIVER
-M:	Hans de Goede <hdegoede@redhat.com>
+M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-S:	Maintained
+S:	Odd Fixes
 F:	drivers/media/usb/gspca/pac207.c

 GSPCA SN9C20X SUBDRIVER
@@ -5184,10 +5184,10 @@ S:	Maintained
 F:	drivers/media/usb/gspca/t613.c

 GSPCA USB WEBCAM DRIVER
-M:	Hans de Goede <hdegoede@redhat.com>
+M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-S:	Maintained
+S:	Odd Fixes
 F:	drivers/media/usb/gspca/

 GUID PARTITION TABLE (GPT)
@@ -9237,10 +9237,10 @@ F:	Documentation/video4linux/README.pvrusb2
 F:	drivers/media/usb/pvrusb2/

 PWC WEBCAM DRIVER
-M:	Hans de Goede <hdegoede@redhat.com>
+M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-S:	Maintained
+S:	Odd Fixes
 F:	drivers/media/usb/pwc/*

 PWM FAN DRIVER
@@ -9455,14 +9455,14 @@ F:	drivers/video/fbdev/aty/radeon*
 F:	include/uapi/linux/radeonfb.h

 RADIOSHARK RADIO DRIVER
-M:	Hans de Goede <hdegoede@redhat.com>
+M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/radio/radio-shark.c

 RADIOSHARK2 RADIO DRIVER
-M:	Hans de Goede <hdegoede@redhat.com>
+M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
-- 
2.8.1

