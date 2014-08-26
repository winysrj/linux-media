Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbaHZVzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:18 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 01/35] [media] vpif_display: get rid of some unused vars
Date: Tue, 26 Aug 2014 18:54:37 -0300
Message-Id: <1409090111-8290-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/davinci/vpif_display.c: In function 'vpif_channel_isr':
drivers/media/platform/davinci/vpif_display.c:363:18: warning: variable 'field'
 set but not used [-Wunused-but-set-variable]
  enum v4l2_field field;
                  ^
drivers/media/platform/davinci/vpif_display.c: In function 'vpif_calculate_offs
ets':
drivers/media/platform/davinci/vpif_display.c:505:23: warning: variable 'vpitch
' set but not used [-Wunused-but-set-variable]
  unsigned int hpitch, vpitch, sizeimage;
                       ^
drivers/media/platform/davinci/vpif_display.c: In function 'vpif_set_output':
drivers/media/platform/davinci/vpif_display.c:816:27: warning: variable 'subdev
_info' set but not used [-Wunused-but-set-variable]
  struct vpif_subdev_info *subdev_info = NULL;

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/davinci/vpif_display.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index a03ec7381cfe..aaa9ec06630f 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -360,7 +360,6 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 	struct vpif_device *dev = &vpif_obj;
 	struct channel_obj *ch;
 	struct common_obj *common;
-	enum v4l2_field field;
 	int fid = -1, i;
 	int channel_id = 0;
 
@@ -369,7 +368,6 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	ch = dev->dev[channel_id];
-	field = ch->common[VPIF_VIDEO_INDEX].fmt.fmt.pix.field;
 	for (i = 0; i < VPIF_NUMOBJECTS; i++) {
 		common = &ch->common[i];
 		/* If streaming is started in this channel */
@@ -502,7 +500,7 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	enum v4l2_field field = common->fmt.fmt.pix.field;
 	struct video_obj *vid_ch = &ch->video;
-	unsigned int hpitch, vpitch, sizeimage;
+	unsigned int hpitch, sizeimage;
 
 	if (V4L2_FIELD_ANY == common->fmt.fmt.pix.field) {
 		if (ch->vpifparams.std_info.frm_fmt)
@@ -516,7 +514,6 @@ static void vpif_calculate_offsets(struct channel_obj *ch)
 	sizeimage = common->fmt.fmt.pix.sizeimage;
 
 	hpitch = common->fmt.fmt.pix.bytesperline;
-	vpitch = sizeimage / (hpitch * 2);
 	if ((V4L2_FIELD_NONE == vid_ch->buf_field) ||
 	    (V4L2_FIELD_INTERLACED == vid_ch->buf_field)) {
 		common->ytop_off = 0;
@@ -813,17 +810,14 @@ static int vpif_set_output(struct vpif_display_config *vpif_cfg,
 {
 	struct vpif_display_chan_config *chan_cfg =
 		&vpif_cfg->chan_config[ch->channel_id];
-	struct vpif_subdev_info *subdev_info = NULL;
 	struct v4l2_subdev *sd = NULL;
 	u32 input = 0, output = 0;
 	int sd_index;
 	int ret;
 
 	sd_index = vpif_output_to_subdev(vpif_cfg, chan_cfg, index);
-	if (sd_index >= 0) {
+	if (sd_index >= 0)
 		sd = vpif_obj.sd[sd_index];
-		subdev_info = &vpif_cfg->subdevinfo[sd_index];
-	}
 
 	if (sd) {
 		input = chan_cfg->outputs[index].input_route;
-- 
1.9.3

