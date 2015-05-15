Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35272 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992576AbbEOVcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 17:32:41 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	maxx <maxx@spaceboyz.net>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] radio-bcm2048: Enable access to automute and ctrl registers
Date: Fri, 15 May 2015 23:31:51 +0200
Message-Id: <1431725511-7379-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: maxx <maxx@spaceboyz.net>

This enables access to automute function of the chip via sysfs and
gives direct access to FM_AUDIO_CTRL0/1 registers, also via sysfs. I
don't think this is so important but helps in developing radio scanner
apps.

Patch writen by maxx@spaceboyz.net

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Cc: maxx@spaceboyz.net
---
 drivers/staging/media/bcm2048/radio-bcm2048.c |   96 +++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 1482d4b..8f9ba7b 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -826,6 +826,93 @@ static int bcm2048_get_mute(struct bcm2048_device *bdev)
 	return err;
 }
 
+static int bcm2048_set_automute(struct bcm2048_device *bdev, u8 automute)
+{
+	int err;
+
+	mutex_lock(&bdev->mutex);
+
+	err = bcm2048_send_command(bdev, BCM2048_I2C_FM_AUDIO_PAUSE, automute);
+
+	mutex_unlock(&bdev->mutex);
+	return err;
+}
+
+static int bcm2048_get_automute(struct bcm2048_device *bdev)
+{
+	int err;
+	u8 value;
+
+	mutex_lock(&bdev->mutex);
+
+	err = bcm2048_recv_command(bdev, BCM2048_I2C_FM_AUDIO_PAUSE, &value);
+
+	mutex_unlock(&bdev->mutex);
+
+	if (!err)
+		err = value;
+
+	return err;
+}
+
+static int bcm2048_set_ctrl0(struct bcm2048_device *bdev, u8 value)
+{
+	int err;
+
+	mutex_lock(&bdev->mutex);
+
+	err = bcm2048_send_command(bdev, BCM2048_I2C_FM_AUDIO_CTRL0, value);
+
+	mutex_unlock(&bdev->mutex);
+	return err;
+}
+
+static int bcm2048_set_ctrl1(struct bcm2048_device *bdev, u8 value)
+{
+	int err;
+
+	mutex_lock(&bdev->mutex);
+
+	err = bcm2048_send_command(bdev, BCM2048_I2C_FM_AUDIO_CTRL1, value);
+
+	mutex_unlock(&bdev->mutex);
+	return err;
+}
+
+static int bcm2048_get_ctrl0(struct bcm2048_device *bdev)
+{
+	int err;
+	u8 value;
+
+	mutex_lock(&bdev->mutex);
+
+	err = bcm2048_recv_command(bdev, BCM2048_I2C_FM_AUDIO_CTRL0, &value);
+
+	mutex_unlock(&bdev->mutex);
+
+	if (!err)
+		err = value;
+
+	return err;
+}
+
+static int bcm2048_get_ctrl1(struct bcm2048_device *bdev)
+{
+	int err;
+	u8 value;
+
+	mutex_lock(&bdev->mutex);
+
+	err = bcm2048_recv_command(bdev, BCM2048_I2C_FM_AUDIO_CTRL1, &value);
+
+	mutex_unlock(&bdev->mutex);
+
+	if (!err)
+		err = value;
+
+	return err;
+}
+
 static int bcm2048_set_audio_route(struct bcm2048_device *bdev, u8 route)
 {
 	int err;
@@ -2058,6 +2145,9 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
 
 DEFINE_SYSFS_PROPERTY(power_state, unsigned, int, "%u", 0)
 DEFINE_SYSFS_PROPERTY(mute, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(automute, unsigned, int, "%x", 0)
+DEFINE_SYSFS_PROPERTY(ctrl0, unsigned, int, "%x", 0)
+DEFINE_SYSFS_PROPERTY(ctrl1, unsigned, int, "%x", 0)
 DEFINE_SYSFS_PROPERTY(audio_route, unsigned, int, "%u", 0)
 DEFINE_SYSFS_PROPERTY(dac_output, unsigned, int, "%u", 0)
 
@@ -2095,6 +2185,12 @@ static struct device_attribute attrs[] = {
 		bcm2048_power_state_write),
 	__ATTR(mute, S_IRUGO | S_IWUSR, bcm2048_mute_read,
 		bcm2048_mute_write),
+	__ATTR(automute, S_IRUGO | S_IWUSR, bcm2048_automute_read,
+		bcm2048_automute_write),
+	__ATTR(ctrl0, S_IRUGO | S_IWUSR, bcm2048_ctrl0_read,
+		bcm2048_ctrl0_write),
+	__ATTR(ctrl1, S_IRUGO | S_IWUSR, bcm2048_ctrl1_read,
+		bcm2048_ctrl1_write),
 	__ATTR(audio_route, S_IRUGO | S_IWUSR, bcm2048_audio_route_read,
 		bcm2048_audio_route_write),
 	__ATTR(dac_output, S_IRUGO | S_IWUSR, bcm2048_dac_output_read,
-- 
1.7.9.5

