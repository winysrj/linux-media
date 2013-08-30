Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:45449 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab3H3L3v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 07:29:51 -0400
From: Dinesh Ram <dinram@cisco.com>
To: linux-media@vger.kernel.org
Cc: dinesh.ram@cern.ch, Dinesh Ram <dinram@cisco.com>
Subject: [PATCH 6/6] si4713 : Added MAINTAINERS entry for radio-usb-si4713 driver
Date: Fri, 30 Aug 2013 13:28:24 +0200
Message-Id: <3c4c1fcee2e6d52919548289aa87316ca1dfa8f7.1377861337.git.dinram@cisco.com>
In-Reply-To: <1377862104-15429-1-git-send-email-dinram@cisco.com>
References: <1377862104-15429-1-git-send-email-dinram@cisco.com>
In-Reply-To: <a661e3d7ccefe3baa8134888a0471ce1e5463f47.1377861337.git.dinram@cisco.com>
References: <a661e3d7ccefe3baa8134888a0471ce1e5463f47.1377861337.git.dinram@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> will maintain the USB driver for si4713

Signed-off-by: Dinesh Ram <dinram@cisco.com>
---
 MAINTAINERS | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2618ce..ddd4d5f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7412,7 +7412,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Odd Fixes
-F:	drivers/media/radio/si4713-i2c.?
+F:	drivers/media/radio/si4713/si4713.?
 
 SI4713 FM RADIO TRANSMITTER PLATFORM DRIVER
 M:	Eduardo Valentin <edubezval@gmail.com>
@@ -7420,7 +7420,15 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Odd Fixes
-F:	drivers/media/radio/radio-si4713.h
+F:	drivers/media/radio/si4713/radio-platform-si4713.c
+
+KEENE FM RADIO TRANSMITTER DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/radio/si4713/radio-usb-si4713.c
 
 SIANO DVB DRIVER
 M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
-- 
1.8.4.rc2

