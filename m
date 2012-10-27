Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2J0Unz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:43:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Huang Shijie <shijie8@gmail.com>,
	Kang Yong <kangyong@telegent.com>,
	Zhang Xiaobing <xbzhang@telegent.com>
Subject: [PATCH 53/68] [media] tlg2300: index is unsigned, so never below zero
Date: Sat, 27 Oct 2012 18:41:11 -0200
Message-Id: <1351370486-29040-54-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/tlg2300/pd-video.c:891:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
drivers/media/usb/tlg2300/pd-video.c:926:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

Cc: Huang Shijie <shijie8@gmail.com>
Cc: Kang Yong <kangyong@telegent.com>
Cc: Zhang Xiaobing <xbzhang@telegent.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/tlg2300/pd-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 1f448ac..3082bfa 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -888,7 +888,7 @@ static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *in)
 {
 	struct front_face *front = fh;
 
-	if (in->index < 0 || in->index >= POSEIDON_INPUTS)
+	if (in->index >= POSEIDON_INPUTS)
 		return -EINVAL;
 	strcpy(in->name, pd_inputs[in->index].name);
 	in->type  = V4L2_INPUT_TYPE_TUNER;
@@ -923,7 +923,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
 	struct poseidon *pd = front->pd;
 	s32 ret, cmd_status;
 
-	if (i < 0 || i >= POSEIDON_INPUTS)
+	if (i >= POSEIDON_INPUTS)
 		return -EINVAL;
 	ret = send_set_req(pd, SGNL_SRC_SEL,
 			pd_inputs[i].tlg_src, &cmd_status);
-- 
1.7.11.7

