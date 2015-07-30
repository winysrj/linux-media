Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55147 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbbG3QUa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 12:20:30 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
	linux-iio@vger.kernel.org, linux-fbdev@vger.kernel.org,
	linux-i2c@vger.kernel.org, linux-leds@vger.kernel.org,
	Sebastian Reichel <sre@kernel.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	lm-sensors@lm-sensors.org,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	linux-input@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jean Delvare <jdelvare@suse.com>,
	Jonathan Cameron <jic23@kernel.org>,
	linux-media@vger.kernel.org, rtc-linux@googlegroups.com,
	linux-pm@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Takashi Iwai <tiwai@suse.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
	Lee Jones <lee.jones@linaro.org>,
	Bryan Wu <cooloney@gmail.com>, linux-omap@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>, linux-usb@vger.kernel.org,
	linux-spi@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 27/27] i2c: (RFC, don't apply) report OF style modalias when probing using DT
Date: Thu, 30 Jul 2015 18:18:52 +0200
Message-Id: <1438273132-20926-28-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1438273132-20926-1-git-send-email-javier@osg.samsung.com>
References: <1438273132-20926-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An I2C driver that supports both OF and legacy platforms, will have
both a OF and I2C ID table. This means that when built as a module,
the aliases will be filled from both tables but currently always an
alias of the form i2c:<deviceId> is reported, e.g:

$ cat /sys/class/i2c-adapter/i2c-8/8-004b/modalias
i2c:maxtouch

So if a device is probed by matching its compatible string, udev can
get a MODALIAS uevent env var that doesn't match with one of the valid
aliases so the module won't be auto-loaded.

This patch changes the I2C core to report a OF related MODALIAS uevent
(of:N*T*C) env var instead so the module can be auto-loaded and also
report the correct alias using sysfs:

$ cat /sys/class/i2c-adapter/i2c-8/8-004b/modalias
of:NtrackpadT<NULL>Catmel,maxtouch

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>



---

 drivers/i2c/i2c-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 92dddfeb3f39..c0668c2ed9da 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -489,6 +489,10 @@ static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 	struct i2c_client	*client = to_i2c_client(dev);
 	int rc;
 
+	rc = of_device_uevent_modalias(dev, env);
+	if (rc != -ENODEV)
+		return rc;
+
 	rc = acpi_device_uevent_modalias(dev, env);
 	if (rc != -ENODEV)
 		return rc;
@@ -726,6 +730,10 @@ show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 	struct i2c_client *client = to_i2c_client(dev);
 	int len;
 
+	len = of_device_get_modalias(dev, buf, PAGE_SIZE - 1);
+	if (len != -ENODEV)
+		return len;
+
 	len = acpi_device_modalias(dev, buf, PAGE_SIZE -1);
 	if (len != -ENODEV)
 		return len;
-- 
2.4.3

