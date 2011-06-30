Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:56562 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1F3IcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 04:32:08 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: prompt ISP CCDC freeze-up on STREAMON
Date: Thu, 30 Jun 2011 10:31:53 +0200
Message-Id: <1309422713-18675-2-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1309422713-18675-1-git-send-email-michael.jones@matrix-vision.de>
References: <1309422713-18675-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

---
 yavta.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/yavta.c b/yavta.c
index 2a166c6..95976b4 100644
--- a/yavta.c
+++ b/yavta.c
@@ -485,7 +485,9 @@ static int video_enable(struct device *dev, int enable)
 	int type = dev->type;
 	int ret;
 
+	printf("+%s\n", enable ? "STREAMON" : "STREAMOFF");
 	ret = ioctl(dev->fd, enable ? VIDIOC_STREAMON : VIDIOC_STREAMOFF, &type);
+	printf("-%s\n", enable ? "STREAMON" : "STREAMOFF");
 	if (ret < 0) {
 		printf("Unable to %s streaming: %d.\n", enable ? "start" : "stop",
 			errno);
@@ -1063,6 +1065,7 @@ int main(int argc, char *argv[])
 {
 	struct device dev;
 	int ret;
+	int i;
 
 	/* Options parsings */
 	int do_file = 0, do_capture = 0, do_pause = 0;
@@ -1259,6 +1262,9 @@ int main(int argc, char *argv[])
 		video_enum_inputs(&dev);
 	}
 
+	for (i=0; i<100; i++) {
+		printf("==== %d ====\n", i);
+
 	if (do_set_input) {
 		video_set_input(&dev, input);
 		ret = video_get_input(&dev);
@@ -1313,6 +1319,8 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	}
+
 	video_close(&dev);
 	return 0;
 }
-- 
1.7.5.4


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
