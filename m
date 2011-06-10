Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43607 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab1FJOs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 10:48:57 -0400
Received: by wwa36 with SMTP id 36so2861302wwa.1
        for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 07:48:55 -0700 (PDT)
Subject: [PATCH 2/2] radio-timb: Add open function which finds tuner and
 DSP via I2C
From: Richard =?ISO-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 16:48:52 +0200
Message-ID: <1307717332.2420.30.camel@debian>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch uses the platform data and finds a tuner and DSP. This is
done when the user calls open. Not during probe, to allow shorter bootup
time of the system.
This piece of code was actually missing earlier, many of the functions
were not useful without DSP and tuner.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index a185610..64a5e19 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -141,9 +141,42 @@ static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
 	.vidioc_s_ctrl		= timbradio_vidioc_s_ctrl
 };
 
+static int timbradio_fops_open(struct file *file)
+{
+	struct timbradio *tr = video_drvdata(file);
+	struct i2c_adapter *adapt;
+
+	/* find the I2C bus */
+	adapt = i2c_get_adapter(tr->pdata.i2c_adapter);
+	if (!adapt) {
+		printk(KERN_ERR DRIVER_NAME": No I2C bus\n");
+		return -ENODEV;
+	}
+
+	/* now find the tuner and dsp */
+	if (!tr->sd_dsp)
+		tr->sd_dsp = v4l2_i2c_new_subdev_board(&tr->v4l2_dev, adapt,
+			tr->pdata.dsp, NULL);
+
+	if (!tr->sd_tuner)
+		tr->sd_tuner = v4l2_i2c_new_subdev_board(&tr->v4l2_dev, adapt,
+			tr->pdata.tuner, NULL);
+
+	i2c_put_adapter(adapt);
+
+	if (!tr->sd_tuner || !tr->sd_dsp) {
+		printk(KERN_ERR DRIVER_NAME
+			": Failed to get tuner or DSP\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static const struct v4l2_file_operations timbradio_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= video_ioctl2,
+	.open		= timbradio_fops_open,
 };
 
 static int __devinit timbradio_probe(struct platform_device *pdev)

