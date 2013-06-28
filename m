Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3399 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab3F1IfC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 04:35:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] usbtv: fix dependency
Date: Fri, 28 Jun 2013 10:24:15 +0200
Cc: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306281024.15428.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a dependency problem as found by Randy Dunlap:

https://lkml.org/lkml/2013/6/27/501

Mauro, is there any reason for any V4L2 driver to depend on VIDEO_DEV instead of
just VIDEO_V4L2?

Some drivers depend on VIDEO_DEV, some on VIDEO_V4L2, some on both. It's all
pretty chaotic.

Regards,

	Hans

diff --git a/drivers/media/usb/usbtv/Kconfig b/drivers/media/usb/usbtv/Kconfig
index 8864436..7c5b860 100644
--- a/drivers/media/usb/usbtv/Kconfig
+++ b/drivers/media/usb/usbtv/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_USBTV
         tristate "USBTV007 video capture support"
-        depends on VIDEO_DEV
+        depends on VIDEO_V4L2
         select VIDEOBUF2_VMALLOC
 
         ---help---
