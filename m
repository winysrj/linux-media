Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab3JUJ2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 05:28:04 -0400
Date: Mon, 21 Oct 2013 11:28:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH/RFC 1/2] V4L2: soc-camera: work around unbalanced calls to
 .s_power()
Message-ID: <Pine.LNX.4.64.1310211107420.32101@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some non soc-camera drivers, e.g. em28xx, use subdevice drivers, originally
written for soc-camera, which use soc_camera_power_on() and
soc_camera_power_off() helpers to implement their .s_power() methods. Those
helpers in turn can enable and disable a clock, if it is supplied to them
as a parameter. This works well when camera host drivers balance their
calls to subdevices' .s_power() methods. However, some such drivers fail to
do that, which leads to unbalanced calls to v4l2_clk_enable() /
v4l2_clk_disable(), which then in turn produce kernel warnings. Such
behaviour is wrong and should be fixed, however, sometimes it is difficult,
because some of those drivers are rather old and use lots of subdevices,
which all should be tested after such a fix. To support such drivers this
patch adds a work-around, allowing host drivers or platforms to set a flag,
in which case soc-camera helpers will only enable the clock, if it is
disabled, and disable it only once on the first call to .s_power(0).

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

As promised yesterday, this is an alternative approach to fixing the 
em28xx problem, compile tested only.

 drivers/media/platform/soc_camera/soc_camera.c |   22 ++++++++++++++++------
 include/media/soc_camera.h                     |   14 ++++++++++++++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 387a232..21136a2 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -71,11 +71,21 @@ static int video_dev_create(struct soc_camera_device *icd);
 int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd,
 			struct v4l2_clk *clk)
 {
-	int ret = clk ? v4l2_clk_enable(clk) : 0;
-	if (ret < 0) {
-		dev_err(dev, "Cannot enable clock: %d\n", ret);
-		return ret;
+	int ret;
+	bool clock_toggle;
+
+	if (clk && (!ssdd->unbalanced_power ||
+		    !test_and_set_bit(0, &ssdd->clock_state))) {
+		ret = v4l2_clk_enable(clk);
+		if (ret < 0) {
+			dev_err(dev, "Cannot enable clock: %d\n", ret);
+			return ret;
+		}
+		clock_toggle = true;
+	} else {
+		clock_toggle = false;
 	}
+
 	ret = regulator_bulk_enable(ssdd->num_regulators,
 					ssdd->regulators);
 	if (ret < 0) {
@@ -98,7 +108,7 @@ epwron:
 	regulator_bulk_disable(ssdd->num_regulators,
 			       ssdd->regulators);
 eregenable:
-	if (clk)
+	if (clock_toggle)
 		v4l2_clk_disable(clk);
 
 	return ret;
@@ -127,7 +137,7 @@ int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd
 		ret = ret ? : err;
 	}
 
-	if (clk)
+	if (clk && (!ssdd->unbalanced_power || test_and_clear_bit(0, &ssdd->clock_state)))
 		v4l2_clk_disable(clk);
 
 	return ret;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 34d2414..5678a39 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -150,6 +150,15 @@ struct soc_camera_subdev_desc {
 	struct regulator_bulk_data *regulators;
 	int num_regulators;
 
+	/*
+	 * Set unbalanced_power to true to deal with legacy drivers, failing to
+	 * balance their calls to subdevice's .s_power() method. clock_state is
+	 * then used internally by helper functions, it shouldn't be touched by
+	 * drivers or the platform code.
+	 */
+	bool unbalanced_power;
+	unsigned long clock_state;
+
 	/* Optional callbacks to power on or off and reset the sensor */
 	int (*power)(struct device *, int);
 	int (*reset)(struct device *);
@@ -206,6 +215,11 @@ struct soc_camera_link {
 	struct regulator_bulk_data *regulators;
 	int num_regulators;
 
+	/* Set by platforms to handle misbehaving drivers */
+	bool unbalanced_power;
+	/* Used by soc-camera helper functions */
+	unsigned long clock_state;
+
 	/* Optional callbacks to power on or off and reset the sensor */
 	int (*power)(struct device *, int);
 	int (*reset)(struct device *);
-- 
1.7.2.5

