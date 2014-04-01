Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.comexp.ru ([78.110.60.213]:60477 "EHLO mail.comexp.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbaDANuy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Apr 2014 09:50:54 -0400
Message-ID: <1396355297.2395.1.camel@localhost.localdomain>
Subject: [PATCH v3] saa7134: add vidioc_querystd
From: Mikhail Domrachev <mihail.domrychev@comexp.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Aleksey Igonin <aleksey.igonin@comexp.ru>
Date: Tue, 01 Apr 2014 16:28:17 +0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mikhail Domrachev <mihail.domrychev@comexp.ru>
---
 drivers/media/pci/saa7134/saa7134-empress.c |  1 +
 drivers/media/pci/saa7134/saa7134-reg.h     |  5 ++++
 drivers/media/pci/saa7134/saa7134-video.c   | 41 +++++++++++++++++++++++++++--
 drivers/media/pci/saa7134/saa7134.h         |  1 +
 4 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 0a9047e..a150deb 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -262,6 +262,7 @@ static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_s_input			= saa7134_s_input,
 	.vidioc_s_std			= saa7134_s_std,
 	.vidioc_g_std			= saa7134_g_std,
+	.vidioc_querystd		= saa7134_querystd,
 	.vidioc_log_status		= v4l2_ctrl_log_status,
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
diff --git a/drivers/media/pci/saa7134/saa7134-reg.h b/drivers/media/pci/saa7134/saa7134-reg.h
index e7e0af1..51737b1 100644
--- a/drivers/media/pci/saa7134/saa7134-reg.h
+++ b/drivers/media/pci/saa7134/saa7134-reg.h
@@ -167,17 +167,22 @@
 #define SAA7134_HSYNC_START                     0x106
 #define SAA7134_HSYNC_STOP                      0x107
 #define SAA7134_SYNC_CTRL                       0x108
+#define   SAA7134_SYNC_CTRL_AUFD                (1 << 7)
 #define SAA7134_LUMA_CTRL                       0x109
+#define   SAA7134_LUMA_CTRL_LDEL                (1 << 5)
 #define SAA7134_DEC_LUMA_BRIGHT                 0x10a
 #define SAA7134_DEC_LUMA_CONTRAST               0x10b
 #define SAA7134_DEC_CHROMA_SATURATION           0x10c
 #define SAA7134_DEC_CHROMA_HUE                  0x10d
 #define SAA7134_CHROMA_CTRL1                    0x10e
+#define   SAA7134_CHROMA_CTRL1_AUTO0            (1 << 1)
+#define   SAA7134_CHROMA_CTRL1_FCTC             (1 << 2)
 #define SAA7134_CHROMA_GAIN                     0x10f
 #define SAA7134_CHROMA_CTRL2                    0x110
 #define SAA7134_MODE_DELAY_CTRL                 0x111
 
 #define SAA7134_ANALOG_ADC                      0x114
+#define   SAA7134_ANALOG_ADC_AUTO1              (1 << 2)
 #define SAA7134_VGATE_START                     0x115
 #define SAA7134_VGATE_STOP                      0x116
 #define SAA7134_MISC_VGATE_MSB                  0x117
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index eb472b5..5eb61ca 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -452,19 +452,26 @@ static void video_mux(struct saa7134_dev *dev, int input)
 
 static void saa7134_set_decoder(struct saa7134_dev *dev)
 {
-	int luma_control, sync_control, mux;
+	int luma_control, sync_control, chroma_ctrl1, mux;
 
 	struct saa7134_tvnorm *norm = dev->tvnorm;
 	mux = card_in(dev, dev->ctl_input).vmux;
 
 	luma_control = norm->luma_control;
 	sync_control = norm->sync_control;
+	chroma_ctrl1 = norm->chroma_ctrl1;
 
 	if (mux > 5)
 		luma_control |= 0x80; /* svideo */
 	if (noninterlaced || dev->nosignal)
 		sync_control |= 0x20;
 
+	/* switch on auto standard detection */
+	sync_control |= SAA7134_SYNC_CTRL_AUFD;
+	chroma_ctrl1 |= SAA7134_CHROMA_CTRL1_AUTO0;
+	chroma_ctrl1 &= ~SAA7134_CHROMA_CTRL1_FCTC;
+	luma_control &= ~SAA7134_LUMA_CTRL_LDEL;
+
 	/* setup video decoder */
 	saa_writeb(SAA7134_INCR_DELAY,            0x08);
 	saa_writeb(SAA7134_ANALOG_IN_CTRL1,       0xc0 | mux);
@@ -487,7 +494,7 @@ static void saa7134_set_decoder(struct saa7134_dev *dev)
 		dev->ctl_invert ? -dev->ctl_saturation : dev->ctl_saturation);
 
 	saa_writeb(SAA7134_DEC_CHROMA_HUE,        dev->ctl_hue);
-	saa_writeb(SAA7134_CHROMA_CTRL1,          norm->chroma_ctrl1);
+	saa_writeb(SAA7134_CHROMA_CTRL1,          chroma_ctrl1);
 	saa_writeb(SAA7134_CHROMA_GAIN,           norm->chroma_gain);
 
 	saa_writeb(SAA7134_CHROMA_CTRL2,          norm->chroma_ctrl2);
@@ -1686,6 +1693,35 @@ int saa7134_g_std(struct file *file, void *priv, v4l2_std_id *id)
 }
 EXPORT_SYMBOL_GPL(saa7134_g_std);
 
+static v4l2_std_id saa7134_read_std(struct saa7134_dev *dev)
+{
+	static v4l2_std_id stds[] = {
+		V4L2_STD_UNKNOWN,
+		V4L2_STD_NTSC,
+		V4L2_STD_PAL,
+		V4L2_STD_SECAM };
+
+	v4l2_std_id result = 0;
+
+	u8 st1 = saa_readb(SAA7134_STATUS_VIDEO1);
+	u8 st2 = saa_readb(SAA7134_STATUS_VIDEO2);
+
+	if (!(st2 & 0x1)) /* RDCAP == 0 */
+		result = V4L2_STD_UNKNOWN;
+	else
+		result = stds[st1 & 0x03];
+
+	return result;
+}
+
+int saa7134_querystd(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct saa7134_dev *dev = video_drvdata(file);
+	*std &= saa7134_read_std(dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(saa7134_querystd);
+
 static int saa7134_cropcap(struct file *file, void *priv,
 					struct v4l2_cropcap *cap)
 {
@@ -2084,6 +2120,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_dqbuf			= saa7134_dqbuf,
 	.vidioc_s_std			= saa7134_s_std,
 	.vidioc_g_std			= saa7134_g_std,
+	.vidioc_querystd		= saa7134_querystd,
 	.vidioc_enum_input		= saa7134_enum_input,
 	.vidioc_g_input			= saa7134_g_input,
 	.vidioc_s_input			= saa7134_s_input,
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 2474e84..9c2249b 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -779,6 +779,7 @@ extern struct video_device saa7134_radio_template;
 
 int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id);
 int saa7134_g_std(struct file *file, void *priv, v4l2_std_id *id);
+int saa7134_querystd(struct file *file, void *priv, v4l2_std_id *std);
 int saa7134_enum_input(struct file *file, void *priv, struct v4l2_input *i);
 int saa7134_g_input(struct file *file, void *priv, unsigned int *i);
 int saa7134_s_input(struct file *file, void *priv, unsigned int i);
-- 
1.8.5.3



