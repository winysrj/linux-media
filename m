Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:7759 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab2C0JtJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Mar 2012 05:49:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.4] Add missing slab.h to radio-rtrack2.c
Date: Tue, 27 Mar 2012 11:39:21 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203271139.21762.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Missed this one, this patch should solve this issue:

http://www.spinics.net/lists/linux-media/msg45880.html

Slab.h was added to all the other isa drivers, but not radio-rtrack2.c.

Subject: [PATCH] radio-rtrack2: add missing slab.h.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-rtrack2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/radio-rtrack2.c b/drivers/media/radio/radio-
rtrack2.c
index b275c5d..b1f844c 100644
--- a/drivers/media/radio/radio-rtrack2.c
+++ b/drivers/media/radio/radio-rtrack2.c
@@ -17,6 +17,7 @@
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/mutex.h>
 #include <linux/io.h>		/* outb, outb_p			*/
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include "radio-isa.h"
-- 
1.7.7.3

