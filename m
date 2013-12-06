Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1936 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3LFKRl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 05:17:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dinesh.Ram@cern.ch, edubezval@gmail.com,
	Dinesh Ram <dinesh.ram@cern.ch>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 07/11] si4713: Added MAINTAINERS entry for radio-usb-si4713 driver
Date: Fri,  6 Dec 2013 11:17:10 +0100
Message-Id: <1386325034-19344-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
References: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dinesh Ram <Dinesh.Ram@cern.ch>

Hans Verkuil <hverkuil@xs4all.nl> will maintain the USB driver for si4713

Signed-off-by: Dinesh Ram <dinesh.ram@cern.ch>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Eduardo Valentin <edubezval@gmail.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
---
 MAINTAINERS | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8285ed4..c540ed6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7621,7 +7621,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Odd Fixes
-F:	drivers/media/radio/si4713-i2c.?
+F:	drivers/media/radio/si4713/si4713.?
 
 SI4713 FM RADIO TRANSMITTER PLATFORM DRIVER
 M:	Eduardo Valentin <edubezval@gmail.com>
@@ -7629,7 +7629,15 @@ L:	linux-media@vger.kernel.org
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
1.8.4.rc3

