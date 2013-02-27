Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ye0-f182.google.com ([209.85.213.182]:56279 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3B0Oot (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 09:44:49 -0500
Received: by mail-ye0-f182.google.com with SMTP id r9so73252yen.41
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 06:44:48 -0800 (PST)
From: Eduardo Valentin <edubezval@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH 1/1] MAINTAINERS: Add maintainer entry for si4713 FM transmitter driver
Date: Wed, 27 Feb 2013 10:37:39 -0400
Message-Id: <1361975859-20819-1-git-send-email-edubezval@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add maintainer entry for the files composing si4713 FM transmitter driver.

Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
---
 MAINTAINERS |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 870ba56..fe5583e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7070,6 +7070,22 @@ F:	drivers/media/radio/si470x/radio-si470x-common.c
 F:	drivers/media/radio/si470x/radio-si470x.h
 F:	drivers/media/radio/si470x/radio-si470x-usb.c
 
+SI4713 FM RADIO TRANSMITTER I2C DRIVER
+M:	Eduardo Valentin <edubezval@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Odd Fixes
+F:	drivers/media/radio/si4713-i2c.?
+
+SI4713 FM RADIO TRANSMITTER PLATFORM DRIVER
+M:	Eduardo Valentin <edubezval@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Odd Fixes
+F:	drivers/media/radio/radio-si4713.h
+
 SH_VEU V4L2 MEM2MEM DRIVER
 M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
-- 
1.7.7.1.488.ge8e1c

