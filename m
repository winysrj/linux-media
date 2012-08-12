Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:35037 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2HLKbS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 06:31:18 -0400
Message-Id: <E1T0VS0-0007u3-LT@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sun, 12 Aug 2012 10:49:03 +0200
Subject: [git:v4l-dvb/for_v3.7] [media] cpia2: Declare MODULE_FIRMWARE usage
To: linuxtv-commits@linuxtv.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] cpia2: Declare MODULE_FIRMWARE usage
Author:  Tim Gardner <tim.gardner@canonical.com>
Date:    Fri Aug 3 13:39:28 2012 -0300

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/video/cpia2/cpia2_core.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=229fd7d2f19c650c34034885180f91574e837bbb

diff --git a/drivers/media/video/cpia2/cpia2_core.c b/drivers/media/video/cpia2/cpia2_core.c
index 17188e2..187012c 100644
--- a/drivers/media/video/cpia2/cpia2_core.c
+++ b/drivers/media/video/cpia2/cpia2_core.c
@@ -31,11 +31,15 @@
 
 #include "cpia2.h"
 
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/firmware.h>
 
+#define FIRMWARE "cpia2/stv0672_vp4.bin"
+MODULE_FIRMWARE(FIRMWARE);
+
 /* #define _CPIA2_DEBUG_ */
 
 #ifdef _CPIA2_DEBUG_
@@ -898,7 +902,7 @@ static int cpia2_send_onebyte_command(struct camera_data *cam,
 static int apply_vp_patch(struct camera_data *cam)
 {
 	const struct firmware *fw;
-	const char fw_name[] = "cpia2/stv0672_vp4.bin";
+	const char fw_name[] = FIRMWARE;
 	int i, ret;
 	struct cpia2_command cmd;
 
