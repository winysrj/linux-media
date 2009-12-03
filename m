Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:63519 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbZLCJrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 04:47:51 -0500
From: Alexander Beregalov <a.beregalov@gmail.com>
To: hverkuil@xs4all.nl, mchehab@redhat.com,
	linux-media@vger.kernel.org, linux-next@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] V4L/DVB: pms: KERNEL_VERSION requires version.h
Date: Thu,  3 Dec 2009 12:48:27 +0300
Message-Id: <1259833707-23776-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this build error:
drivers/media/video/pms.c:682: error: implicit declaration of function 'KERNEL_VERSION'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/media/video/pms.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index 00228d5..a118bb1 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -35,6 +35,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <linux/mutex.h>
+#include <linux/version.h>
 
 #include <asm/uaccess.h>
 
-- 
1.6.5.3

