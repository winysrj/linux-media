Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:34716 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab1C0HLT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Mar 2011 03:11:19 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id E03F6D4801F
	for <linux-media@vger.kernel.org>; Sun, 27 Mar 2011 09:11:12 +0200 (CEST)
Date: Sun, 27 Mar 2011 09:11:48 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [PATCH] pwc: Handle V4L2_CTRL_FLAG_NEXT_CTRL in queryctrl
Message-ID: <20110327091148.63f5309a@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jean-François Moine <moinejf@free.fr>
---
 drivers/media/video/pwc/pwc-v4l.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index aa87e46..f85c512 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -379,8 +379,27 @@ static int pwc_s_input(struct file *file, void *fh, unsigned int i)
 
 static int pwc_queryctrl(struct file *file, void *fh, struct v4l2_queryctrl *c)
 {
-	int i;
-
+	int i, idx;
+	u32 id;
+
+	id = c->id;
+	if (id & V4L2_CTRL_FLAG_NEXT_CTRL) {
+		id &= V4L2_CTRL_ID_MASK;
+		id++;
+		idx = -1;
+		for (i = 0; i < ARRAY_SIZE(pwc_controls); i++) {
+			if (pwc_controls[i].id < id)
+				continue;
+			if (idx >= 0
+			 && pwc_controls[i].id > pwc_controls[idx].id)
+				continue;
+			idx = i;
+		}
+		if (idx < 0)
+			return -EINVAL;
+		memcpy(c, &pwc_controls[idx], sizeof pwc_controls[0]);
+		return 0;
+	}
 	for (i = 0; i < sizeof(pwc_controls) / sizeof(struct v4l2_queryctrl); i++) {
 		if (pwc_controls[i].id == c->id) {
 			PWC_DEBUG_IOCTL("ioctl(VIDIOC_QUERYCTRL) found\n");
-- 
1.7.4.1
