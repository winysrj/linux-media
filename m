Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2104 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3LFKRg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 05:17:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dinesh.Ram@cern.ch, edubezval@gmail.com,
	Dinesh Ram <dinesh.ram@cern.ch>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 03/11] si4713: Reorganized includes in si4713.c/h
Date: Fri,  6 Dec 2013 11:17:06 +0100
Message-Id: <1386325034-19344-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
References: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dinesh Ram <Dinesh.Ram@cern.ch>

Moved the header <linux/regulator/consumer.h> from si4713.c to si4713.h

Signed-off-by: Dinesh Ram <dinesh.ram@cern.ch>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Eduardo Valentin <edubezval@gmail.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/media/radio/si4713/si4713.c | 1 -
 drivers/media/radio/si4713/si4713.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 5d26b9a..096947c 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -31,7 +31,6 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
-#include <linux/regulator/consumer.h>
 
 #include "si4713.h"
 
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
index 25cdea2..1410cd2 100644
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
1.8.4.rc3

