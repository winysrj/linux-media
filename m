Return-path: <linux-media-owner@vger.kernel.org>
Received: from cernmx32.cern.ch ([137.138.144.178]:2343 "EHLO CERNMX32.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151Ab3JOPZH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 11:25:07 -0400
From: Dinesh Ram <dinesh.ram@cern.ch>
To: <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, <edubezval@gmail.com>,
	<dinesh.ram086@gmail.com>, Dinesh Ram <dinesh.ram@cern.ch>
Subject: [REVIEW PATCH 7/9] si4713 : Added MAINTAINERS entry for radio-usb-si4713 driver
Date: Tue, 15 Oct 2013 17:24:43 +0200
Message-ID: <46798a26739dccf476bc3dcce528075dd2731af8.1381850640.git.dinesh.ram@cern.ch>
In-Reply-To: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
References: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> will maintain the USB driver for si4713

Signed-off-by: Dinesh Ram <dinesh.ram@cern.ch>
---
 MAINTAINERS |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 72b1e5c..1ed7363 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7520,7 +7520,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Odd Fixes
-F:	drivers/media/radio/si4713-i2c.?
+F:	drivers/media/radio/si4713/si4713.?
 
 SI4713 FM RADIO TRANSMITTER PLATFORM DRIVER
 M:	Eduardo Valentin <edubezval@gmail.com>
@@ -7528,7 +7528,15 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Odd Fixes
-F:	drivers/media/radio/radio-si4713.c
+F:	drivers/media/radio/si4713/radio-platform-si4713.c
+
+SI4713 FM RADIO TRANSMITTER USB DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/radio/si4713/radio-usb-si4713.c
 
 SIANO DVB DRIVER
 M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
-- 
1.7.9.5

