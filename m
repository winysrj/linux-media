Return-path: <linux-media-owner@vger.kernel.org>
Received: from cernmx30.cern.ch ([137.138.144.177]:27339 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105Ab3JOPZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 11:25:03 -0400
From: Dinesh Ram <dinesh.ram@cern.ch>
To: <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, <edubezval@gmail.com>,
	<dinesh.ram086@gmail.com>, Dinesh Ram <dinesh.ram@cern.ch>
Subject: [REVIEW PATCH 3/9] si4713 : Reorganized includes in si4713.c/h
Date: Tue, 15 Oct 2013 17:24:39 +0200
Message-ID: <5616278fea088e7f34d3456ced8b0f3e8295b24f.1381850640.git.dinesh.ram@cern.ch>
In-Reply-To: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
References: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moved the header <linux/regulator/consumer.h> from si4713.c to si4713.h

Signed-off-by: Dinesh Ram <dinesh.ram@cern.ch>
---
 drivers/media/radio/si4713/si4713.c |    1 -
 drivers/media/radio/si4713/si4713.h |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 24ae41d..1da9364 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -31,7 +31,6 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
-#include <linux/regulator/consumer.h>
 
 #include "si4713.h"
 
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
index c274e1f..dc0ce66 100644
--- a/drivers/media/radio/si4713/si4713.h
+++ b/drivers/media/radio/si4713/si4713.h
@@ -15,6 +15,7 @@
 #ifndef SI4713_I2C_H
 #define SI4713_I2C_H
 
+#include <linux/regulator/consumer.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
 #include <media/si4713.h>
-- 
1.7.9.5

