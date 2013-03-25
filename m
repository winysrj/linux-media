Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758468Ab3CYPkr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 11:40:47 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2PFekKN010446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 11:40:46 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] fix compilation with both V4L2 and I2C as 'm'
Date: Mon, 25 Mar 2013 12:40:43 -0300
Message-Id: <1364226043-15283-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When config options are:
	CONFIG_VIDEO_DEV=y
	CONFIG_VIDEO_V4L2=m
	CONFIG_I2C=m

Compilation breaks, as reported by:
	https://bugzilla.kernel.org/show_bug.cgi?id=55681

Before changeset 7b34be71db533f3e0cf93d53cf62d036cdb5418a,
no compilation errors occurred. However, the I2C code there at
v4l2-device was incorrectly disabled.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/v4l2-core/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index a9d3552..768aaf6 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -10,7 +10,7 @@ ifeq ($(CONFIG_COMPAT),y)
   videodev-objs += v4l2-compat-ioctl32.o
 endif
 
-obj-$(CONFIG_VIDEO_DEV) += videodev.o
+obj-$(CONFIG_VIDEO_V4L2) += videodev.o
 obj-$(CONFIG_VIDEO_V4L2_INT_DEVICE) += v4l2-int-device.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
 
-- 
1.8.1.4

