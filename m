Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44075 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696AbaHZVzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:18 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 02/35] [media] vpif_capture: get rid of some unused vars
Date: Tue, 26 Aug 2014 18:54:38 -0300
Message-Id: <1409090111-8290-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/davinci/vpif_capture.c: In function 'vpif_channel_isr':
drivers/media/platform/davinci/vpif_capture.c:376:18: warning: variable 'field'
 set but not used [-Wunused-but-set-variable]
  enum v4l2_field field;
                  ^
drivers/media/platform/davinci/vpif_capture.c: In function 'vpif_calculate_offs
ets':
drivers/media/platform/davinci/vpif_capture.c:536:23: warning: variable 'vpitch
' set but not used [-Wunused-but-set-variable]
  unsigned int hpitch, vpitch, sizeimage;
                       ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index b054b7eec53d..cf15bb1962ef 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -373,7 +373,6 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 	struct vpif_device *dev = &vpif_obj;
 	struct common_obj *common;
 	struct channel_obj *ch;
-	enum v4l2_field field;
 	int channel_id = 0;
 	int fid = -1, i;
 
@@ -383,8 +382,6 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 
 	ch = dev->dev[channel_id];
 
-	field = ch->common[VPIF_VIDEO_INDEX].fmt.fmt.pix.field;
-
 	for (i = 0; i < VPIF_NUMBER_OF_OBJECTS; i++) {
 		common = &ch->common[i];
 		/* skip If streaming is not started in this channel */
@@ -533,7 +530,7 @@ static int vpif_update_std_info(struct channel_obj *ch)
  */
 static void vpif_calculate_offsets(struct channel_obj *ch)
 {
-	unsigned int hpitch, vpitch, sizeimage;
+	unsigned int hpitch, sizeimage;
 	struct video_obj *vid_ch = &(ch->video);
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
@@ -552,7 +549,6 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 	sizeimage = common->fmt.fmt.pix.sizeimage;
 
 	hpitch = common->fmt.fmt.pix.bytesperline;
-	vpitch = sizeimage / (hpitch * 2);
 
 	if ((V4L2_FIELD_NONE == vid_ch->buf_field) ||
 	    (V4L2_FIELD_INTERLACED == vid_ch->buf_field)) {
-- 
1.9.3

