Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab0BCRYH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 12:24:07 -0500
Message-ID: <4B69B12D.6030105@redhat.com>
Date: Wed, 03 Feb 2010 15:23:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Samuel Ortiz <samuel.ortiz@intel.com>
CC: =?UTF-8?B?UmljaGFyZCBSw7ZqZm9ycw==?=
	<richard.rojfors@pelagicore.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mfd: Add support for the timberdale FPGA.
References: <4B66C36A.4000005@pelagicore.com> <4B693ED7.4060401@redhat.com> <20100203100326.GA3460@sortiz.org> <4B694D69.1090201@redhat.com> <20100203123617.GF3460@sortiz.org>
In-Reply-To: <20100203123617.GF3460@sortiz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Samuel Ortiz wrote:
> On Wed, Feb 03, 2010 at 10:18:17AM +0000, Mauro Carvalho Chehab wrote:
>> Samuel Ortiz wrote:
>>> I'm going to review this patch right now. Typically, mfd core drivers and
>>> their subdevices are submitted as a patchset via my tree, because the
>>> subdevices drivers have dependencies with the core. The mfd core driver is
>>> submitted without any dependencies, and then when the subdevices drivers are
>>> submitted, we add relevant code to the mfd driver. This way we prevent any
>>> build breakage or bisection mess.
>> The drivers at media are generally very complex with dependencies on several other
>> subsystems. In general, almost all depends on i2c, alsa and input, and an increasing
>> number of drivers has also dependencies with platform_data added at arch-dependent
>> includes/drivers. Yet, this specific driver is simple.
>>
>> I generally tend to add those drivers via my tree, since it is generally simpler to
>> prevent breakage/bisection troubles, 
> I see that we have similar issues :)
> 
> 
> 
>> but it is also ok for me if you want to add
>> them via your tree, after I get my ack.
> Great, let's to that then.
> 
> 
>>> The timberdale chip right now doesnt depend on anything, but will soon depend
>>> on the radio driver that's on your tree, but also on a sound and on a network
>>> driver. You'd have to take all those if Richard wants to push them right now.
>> There were one or two minor changes requested on radio-timb patchset. After that
>> changes, we're ready to merge it.
> All right, I'd appreciate if you could cc me on the relevant thread.
> 
> 
> 
>>> So, what I propose is to take the timberdale mfd core driver and the radio
>>> one, with your SOB. Then when Richard wants to submit additional subdevices
>>> drivers I'll be able to take them and we'll avoid polluting your tree with non
>>> media related drivers. Does that make sense to you ?
>> Yes, it does. I don't think Richard is urging with those patches, so my idea is
>> to keep them for linux-next. It would equally work for me if you add the patches
>> on your tree after my ack. The only merge conflicts we may expect from V4L side
>> are related to Kconfig/Makefile, and those will be easy to fix during the merge
>> period.
> Ok, thanks again for your understanding. This is definitely material for the
> next merge window, so I'll merge it into my for-next branch.

The last version of the driver is OK for merging. However, I noticed one issue:
it depends on two drivers that were already merged on my tree:

+config RADIO_TIMBERDALE
+       tristate "Enable the Timberdale radio driver"
+       depends on MFD_TIMBERDALE && VIDEO_V4L2
+       select RADIO_TEF6862
+       select RADIO_SAA7706H

Currently, the dependency seems to happen only at Kconfig level.

Maybe the better is to return to the previous plan: apply it via my tree, as the better
is to have it added after those two radio i2c drivers.

-- 

Cheers,
Mauro

For your convenience, I'm enclosing the latest version of the driver.

Subject: [v4] radio: Add radio-timb
Date: Wed, 03 Feb 2010 15:59:39 -0000
From: Richard Röjfors <richard.rojfors@pelagicore.com>
X-Patchwork-Id: 76738

This patch add supports for the radio system on the Intel Russellville board.

It's a In-Vehicle Infotainment board with a radio tuner and DSP.

This umbrella driver has the DSP and tuner as V4L2 subdevs and calls them
when needed.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

---
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 3f40f37..c242939 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -429,4 +429,14 @@ config RADIO_TEF6862
  	  To compile this driver as a module, choose M here: the
  	  module will be called TEF6862.

+config RADIO_TIMBERDALE
+	tristate "Enable the Timberdale radio driver"
+	depends on MFD_TIMBERDALE && VIDEO_V4L2
+	select RADIO_TEF6862
+	select RADIO_SAA7706H
+	---help---
+	  This is a kind of umbrella driver for the Radio Tuner and DSP
+	  found behind the Timberdale FPGA on the Russellville board.
+	  Enabling this driver will automatically select the DSP and tuner.
+
  endif # RADIO_ADAPTERS
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 01922ad..8973850 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -24,5 +24,6 @@ obj-$(CONFIG_RADIO_SI470X) += si470x/
  obj-$(CONFIG_USB_MR800) += radio-mr800.o
  obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
  obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
+obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o

  EXTRA_CFLAGS += -Isound
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
new file mode 100644
index 0000000..0de457f
--- /dev/null
+++ b/drivers/media/radio/radio-timb.c
@@ -0,0 +1,244 @@
+/*
+ * radio-timb.c Timberdale FPGA Radio driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/version.h>
+#include <linux/io.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <media/timb_radio.h>
+
+#define DRIVER_NAME "timb-radio"
+
+struct timbradio {
+	struct timb_radio_platform_data	pdata;
+	struct v4l2_subdev	*sd_tuner;
+	struct v4l2_subdev	*sd_dsp;
+	struct video_device	video_dev;
+	struct v4l2_device	v4l2_dev;
+};
+
+
+static int timbradio_vidioc_querycap(struct file *file, void  *priv,
+	struct v4l2_capability *v)
+{
+	strlcpy(v->driver, DRIVER_NAME, sizeof(v->driver));
+	strlcpy(v->card, "Timberdale Radio", sizeof(v->card));
+	snprintf(v->bus_info, sizeof(v->bus_info), "platform:"DRIVER_NAME);
+	v->version = KERNEL_VERSION(0, 0, 1);
+	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	return 0;
+}
+
+static int timbradio_vidioc_g_tuner(struct file *file, void *priv,
+	struct v4l2_tuner *v)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_tuner, tuner, g_tuner, v);
+}
+
+static int timbradio_vidioc_s_tuner(struct file *file, void *priv,
+	struct v4l2_tuner *v)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_tuner, tuner, s_tuner, v);
+}
+
+static int timbradio_vidioc_g_input(struct file *filp, void *priv,
+	unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int timbradio_vidioc_s_input(struct file *filp, void *priv,
+	unsigned int i)
+{
+	return i ? -EINVAL : 0;
+}
+
+static int timbradio_vidioc_g_audio(struct file *file, void *priv,
+	struct v4l2_audio *a)
+{
+	a->index = 0;
+	strlcpy(a->name, "Radio", sizeof(a->name));
+	a->capability = V4L2_AUDCAP_STEREO;
+	return 0;
+}
+
+static int timbradio_vidioc_s_audio(struct file *file, void *priv,
+	struct v4l2_audio *a)
+{
+	return a->index ? -EINVAL : 0;
+}
+
+static int timbradio_vidioc_s_frequency(struct file *file, void *priv,
+	struct v4l2_frequency *f)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_tuner, tuner, s_frequency, f);
+}
+
+static int timbradio_vidioc_g_frequency(struct file *file, void *priv,
+	struct v4l2_frequency *f)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_tuner, tuner, g_frequency, f);
+}
+
+static int timbradio_vidioc_queryctrl(struct file *file, void *priv,
+	struct v4l2_queryctrl *qc)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_dsp, core, queryctrl, qc);
+}
+
+static int timbradio_vidioc_g_ctrl(struct file *file, void *priv,
+	struct v4l2_control *ctrl)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_dsp, core, g_ctrl, ctrl);
+}
+
+static int timbradio_vidioc_s_ctrl(struct file *file, void *priv,
+	struct v4l2_control *ctrl)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_dsp, core, s_ctrl, ctrl);
+}
+
+static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
+	.vidioc_querycap	= timbradio_vidioc_querycap,
+	.vidioc_g_tuner		= timbradio_vidioc_g_tuner,
+	.vidioc_s_tuner		= timbradio_vidioc_s_tuner,
+	.vidioc_g_frequency	= timbradio_vidioc_g_frequency,
+	.vidioc_s_frequency	= timbradio_vidioc_s_frequency,
+	.vidioc_g_input		= timbradio_vidioc_g_input,
+	.vidioc_s_input		= timbradio_vidioc_s_input,
+	.vidioc_g_audio		= timbradio_vidioc_g_audio,
+	.vidioc_s_audio		= timbradio_vidioc_s_audio,
+	.vidioc_queryctrl	= timbradio_vidioc_queryctrl,
+	.vidioc_g_ctrl		= timbradio_vidioc_g_ctrl,
+	.vidioc_s_ctrl		= timbradio_vidioc_s_ctrl
+};
+
+static const struct v4l2_file_operations timbradio_fops = {
+	.owner		= THIS_MODULE,
+	.ioctl		= video_ioctl2,
+};
+
+static int __devinit timbradio_probe(struct platform_device *pdev)
+{
+	struct timb_radio_platform_data *pdata = pdev->dev.platform_data;
+	struct timbradio *tr;
+	int err;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "Platform data missing\n");
+		err = -EINVAL;
+		goto err;
+	}
+
+	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
+	if (!tr) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	tr->pdata = *pdata;
+
+	strlcpy(tr->video_dev.name, "Timberdale Radio",
+		sizeof(tr->video_dev.name));
+	tr->video_dev.fops = &timbradio_fops;
+	tr->video_dev.ioctl_ops = &timbradio_ioctl_ops;
+	tr->video_dev.release = video_device_release_empty;
+	tr->video_dev.minor = -1;
+
+	strlcpy(tr->v4l2_dev.name, DRIVER_NAME, sizeof(tr->v4l2_dev.name));
+	err = v4l2_device_register(NULL, &tr->v4l2_dev);
+	if (err)
+		goto err_v4l2_dev;
+
+	tr->video_dev.v4l2_dev = &tr->v4l2_dev;
+
+	err = video_register_device(&tr->video_dev, VFL_TYPE_RADIO, -1);
+	if (err) {
+		dev_err(&pdev->dev, "Error reg video\n");
+		goto err_video_req;
+	}
+
+	video_set_drvdata(&tr->video_dev, tr);
+
+	platform_set_drvdata(pdev, tr);
+	return 0;
+
+err_video_req:
+	video_device_release_empty(&tr->video_dev);
+	v4l2_device_unregister(&tr->v4l2_dev);
+err_v4l2_dev:
+	kfree(tr);
+err:
+	dev_err(&pdev->dev, "Failed to register: %d\n", err);
+
+	return err;
+}
+
+static int __devexit timbradio_remove(struct platform_device *pdev)
+{
+	struct timbradio *tr = platform_get_drvdata(pdev);
+
+	video_unregister_device(&tr->video_dev);
+	video_device_release_empty(&tr->video_dev);
+
+	v4l2_device_unregister(&tr->v4l2_dev);
+
+	kfree(tr);
+
+	return 0;
+}
+
+static struct platform_driver timbradio_platform_driver = {
+	.driver = {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= timbradio_probe,
+	.remove		= timbradio_remove,
+};
+
+/*--------------------------------------------------------------------------*/
+
+static int __init timbradio_init(void)
+{
+	return platform_driver_register(&timbradio_platform_driver);
+}
+
+static void __exit timbradio_exit(void)
+{
+	platform_driver_unregister(&timbradio_platform_driver);
+}
+
+module_init(timbradio_init);
+module_exit(timbradio_exit);
+
+MODULE_DESCRIPTION("Timberdale Radio driver");
+MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:"DRIVER_NAME);
diff --git a/include/media/timb_radio.h b/include/media/timb_radio.h
new file mode 100644
index 0000000..fcd32a3
--- /dev/null
+++ b/include/media/timb_radio.h
@@ -0,0 +1,36 @@
+/*
+ * timb_radio.h Platform struct for the Timberdale radio driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _TIMB_RADIO_
+#define _TIMB_RADIO_ 1
+
+#include <linux/i2c.h>
+
+struct timb_radio_platform_data {
+	int i2c_adapter; /* I2C adapter where the tuner and dsp are attached */
+	struct {
+		const char *module_name;
+		struct i2c_board_info *info;
+	} tuner;
+	struct {
+		const char *module_name;
+		struct i2c_board_info *info;
+	} dsp;
+};
+
+#endif


