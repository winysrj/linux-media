Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43088 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbaHYRMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:12:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/12] msi001: logging changes
Date: Mon, 25 Aug 2014 20:11:53 +0300
Message-Id: <1408986718-3881-7-git-send-email-crope@iki.fi>
In-Reply-To: <1408986718-3881-1-git-send-email-crope@iki.fi>
References: <1408986718-3881-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove function name from debug logs. Logging system could add it
automatically.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/msi001.c | 56 ++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/media/tuners/msi001.c b/drivers/media/tuners/msi001.c
index ee99e37..26019e7 100644
--- a/drivers/media/tuners/msi001.c
+++ b/drivers/media/tuners/msi001.c
@@ -67,7 +67,8 @@ static int msi001_set_gain(struct msi001 *s, int lna_gain, int mixer_gain,
 {
 	int ret;
 	u32 reg;
-	dev_dbg(&s->spi->dev, "%s: lna=%d mixer=%d if=%d\n", __func__,
+
+	dev_dbg(&s->spi->dev, "lna=%d mixer=%d if=%d\n",
 			lna_gain, mixer_gain, if_gain);
 
 	reg = 1 << 0;
@@ -83,7 +84,7 @@ static int msi001_set_gain(struct msi001 *s, int lna_gain, int mixer_gain,
 
 	return 0;
 err:
-	dev_dbg(&s->spi->dev, "%s: failed %d\n", __func__, ret);
+	dev_dbg(&s->spi->dev, "failed %d\n", ret);
 	return ret;
 };
 
@@ -94,6 +95,7 @@ static int msi001_set_tuner(struct msi001 *s)
 	u32 reg;
 	u64 f_vco, tmp64;
 	u8 mode, filter_mode, lo_div;
+
 	static const struct {
 		u32 rf;
 		u8 mode;
@@ -145,9 +147,7 @@ static int msi001_set_tuner(struct msi001 *s)
 	#define R_REF 4
 	#define F_OUT_STEP 1
 
-	dev_dbg(&s->spi->dev,
-			"%s: f_rf=%d f_if=%d\n",
-			__func__, f_rf, f_if);
+	dev_dbg(&s->spi->dev, "f_rf=%d f_if=%d\n", f_rf, f_if);
 
 	for (i = 0; i < ARRAY_SIZE(band_lut); i++) {
 		if (f_rf <= band_lut[i].rf) {
@@ -198,8 +198,7 @@ static int msi001_set_tuner(struct msi001 *s)
 
 	s->bandwidth->val = bandwidth_lut[i].freq;
 
-	dev_dbg(&s->spi->dev, "%s: bandwidth selected=%d\n",
-			__func__, bandwidth_lut[i].freq);
+	dev_dbg(&s->spi->dev, "bandwidth selected=%d\n", bandwidth_lut[i].freq);
 
 	f_vco = (u64) (f_rf + f_if + f_if1) * lo_div;
 	tmp64 = f_vco;
@@ -225,9 +224,8 @@ static int msi001_set_tuner(struct msi001 *s)
 	tmp += 1ul * F_REF * R_REF * frac / thresh;
 	tmp /= lo_div;
 
-	dev_dbg(&s->spi->dev,
-			"%s: rf=%u:%u n=%d thresh=%d frac=%d\n",
-				__func__, f_rf, tmp, n, thresh, frac);
+	dev_dbg(&s->spi->dev, "rf=%u:%u n=%d thresh=%d frac=%d\n",
+				f_rf, tmp, n, thresh, frac);
 
 	ret = msi001_wreg(s, 0x00000e);
 	if (ret)
@@ -276,7 +274,7 @@ static int msi001_set_tuner(struct msi001 *s)
 
 	return 0;
 err:
-	dev_dbg(&s->spi->dev, "%s: failed %d\n", __func__, ret);
+	dev_dbg(&s->spi->dev, "failed %d\n", ret);
 	return ret;
 };
 
@@ -284,7 +282,8 @@ static int msi001_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct msi001 *s = sd_to_msi001(sd);
 	int ret;
-	dev_dbg(&s->spi->dev, "%s: on=%d\n", __func__, on);
+
+	dev_dbg(&s->spi->dev, "on=%d\n", on);
 
 	if (on)
 		ret = 0;
@@ -301,7 +300,8 @@ static const struct v4l2_subdev_core_ops msi001_core_ops = {
 static int msi001_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 {
 	struct msi001 *s = sd_to_msi001(sd);
-	dev_dbg(&s->spi->dev, "%s: index=%d\n", __func__, v->index);
+
+	dev_dbg(&s->spi->dev, "index=%d\n", v->index);
 
 	strlcpy(v->name, "Mirics MSi001", sizeof(v->name));
 	v->type = V4L2_TUNER_RF;
@@ -315,14 +315,16 @@ static int msi001_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 static int msi001_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *v)
 {
 	struct msi001 *s = sd_to_msi001(sd);
-	dev_dbg(&s->spi->dev, "%s: index=%d\n", __func__, v->index);
+
+	dev_dbg(&s->spi->dev, "index=%d\n", v->index);
 	return 0;
 }
 
 static int msi001_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 {
 	struct msi001 *s = sd_to_msi001(sd);
-	dev_dbg(&s->spi->dev, "%s: tuner=%d\n", __func__, f->tuner);
+
+	dev_dbg(&s->spi->dev, "tuner=%d\n", f->tuner);
 	f->frequency = s->f_tuner;
 	return 0;
 }
@@ -332,8 +334,9 @@ static int msi001_s_frequency(struct v4l2_subdev *sd,
 {
 	struct msi001 *s = sd_to_msi001(sd);
 	unsigned int band;
-	dev_dbg(&s->spi->dev, "%s: tuner=%d type=%d frequency=%u\n",
-			__func__, f->tuner, f->type, f->frequency);
+
+	dev_dbg(&s->spi->dev, "tuner=%d type=%d frequency=%u\n",
+			f->tuner, f->type, f->frequency);
 
 	if (f->frequency < ((bands[0].rangehigh + bands[1].rangelow) / 2))
 		band = 0;
@@ -349,8 +352,9 @@ static int msi001_enum_freq_bands(struct v4l2_subdev *sd,
 		struct v4l2_frequency_band *band)
 {
 	struct msi001 *s = sd_to_msi001(sd);
-	dev_dbg(&s->spi->dev, "%s: tuner=%d type=%d index=%d\n",
-			__func__, band->tuner, band->type, band->index);
+
+	dev_dbg(&s->spi->dev, "tuner=%d type=%d index=%d\n",
+			band->tuner, band->type, band->index);
 
 	if (band->index >= ARRAY_SIZE(bands))
 		return -EINVAL;
@@ -380,9 +384,10 @@ static int msi001_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct msi001 *s = container_of(ctrl->handler, struct msi001, hdl);
 
 	int ret;
+
 	dev_dbg(&s->spi->dev,
-			"%s: id=%d name=%s val=%d min=%lld max=%lld step=%lld\n",
-			__func__, ctrl->id, ctrl->name, ctrl->val,
+			"id=%d name=%s val=%d min=%lld max=%lld step=%lld\n",
+			ctrl->id, ctrl->name, ctrl->val,
 			ctrl->minimum, ctrl->maximum, ctrl->step);
 
 	switch (ctrl->id) {
@@ -403,8 +408,7 @@ static int msi001_s_ctrl(struct v4l2_ctrl *ctrl)
 				s->mixer_gain->cur.val, s->if_gain->val);
 		break;
 	default:
-		dev_dbg(&s->spi->dev, "%s: unkown control %d\n",
-				__func__, ctrl->id);
+		dev_dbg(&s->spi->dev, "unkown control %d\n", ctrl->id);
 		ret = -EINVAL;
 	}
 
@@ -419,7 +423,8 @@ static int msi001_probe(struct spi_device *spi)
 {
 	struct msi001 *s;
 	int ret;
-	dev_dbg(&spi->dev, "%s:\n", __func__);
+
+	dev_dbg(&spi->dev, "\n");
 
 	s = kzalloc(sizeof(struct msi001), GFP_KERNEL);
 	if (s == NULL) {
@@ -466,7 +471,8 @@ static int msi001_remove(struct spi_device *spi)
 {
 	struct v4l2_subdev *sd = spi_get_drvdata(spi);
 	struct msi001 *s = sd_to_msi001(sd);
-	dev_dbg(&spi->dev, "%s:\n", __func__);
+
+	dev_dbg(&spi->dev, "\n");
 
 	/*
 	 * Registered by v4l2_spi_new_subdev() from master driver, but we must
-- 
http://palosaari.fi/

