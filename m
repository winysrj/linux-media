Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51754 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751742AbcFIXOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 19:14:23 -0400
Date: Fri, 10 Jun 2016 02:13:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media]: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20160609231349.GA26360@valkosipuli.retiisi.org.uk>
References: <20160501134122.GG26360@valkosipuli.retiisi.org.uk>
 <1462287004-21099-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160525214544.GL26360@valkosipuli.retiisi.org.uk>
 <57533212.3020406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57533212.3020406@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ivaylo,

On Sat, Jun 04, 2016 at 10:54:58PM +0300, Ivaylo Dimitrov wrote:
> Hi,
> 
> On 26.05.2016 00:45, Sakari Ailus wrote:
> >Hi Ivaylo,
> >
> >I've got some comments here but I haven't reviewed everything yet. What's
> >missing is
> >
> >- the user space interface for selecting the sensor configuration "mode",
> >
> >- passing information on the sensor configuration to the user space.
> >
> >I'll try to take a look at those some time in the near future.
> >
> 
> ok
> 
> >
> >I very much appreciate your work towards finally upstreaming this! :-)
> >
> >On Tue, May 03, 2016 at 05:50:04PM +0300, Ivaylo Dimitrov wrote:
> >>The sensor is found in Nokia N900 main camera
> >>
> >>Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> >>---
> >>  .../bindings/media/i2c/toshiba,et8ek8.txt          |   53 +
> >>  drivers/media/i2c/Kconfig                          |    1 +
> >>  drivers/media/i2c/Makefile                         |    1 +
> >>  drivers/media/i2c/et8ek8/Kconfig                   |    6 +
> >>  drivers/media/i2c/et8ek8/Makefile                  |    2 +
> >>  drivers/media/i2c/et8ek8/et8ek8_driver.c           | 1711 ++++++++++++++++++++
> >>  drivers/media/i2c/et8ek8/et8ek8_mode.c             |  591 +++++++
> >>  drivers/media/i2c/et8ek8/et8ek8_reg.h              |  100 ++
> >>  include/uapi/linux/v4l2-controls.h                 |    5 +
> >>  9 files changed, 2470 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> >>  create mode 100644 drivers/media/i2c/et8ek8/Kconfig
> >>  create mode 100644 drivers/media/i2c/et8ek8/Makefile
> >>  create mode 100644 drivers/media/i2c/et8ek8/et8ek8_driver.c
> >>  create mode 100644 drivers/media/i2c/et8ek8/et8ek8_mode.c
> >>  create mode 100644 drivers/media/i2c/et8ek8/et8ek8_reg.h
> >>
> >>diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> >>new file mode 100644
> >>index 0000000..55f712c
> >>--- /dev/null
> >>+++ b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> >>@@ -0,0 +1,53 @@
> >>+Toshiba et8ek8 5MP sensor
> >>+
> >>+Toshiba et8ek8 5MP sensor is an image sensor found in Nokia N900 device
> >>+
> >>+More detailed documentation can be found in
> >>+Documentation/devicetree/bindings/media/video-interfaces.txt .
> >>+
> >>+
> >>+Mandatory properties
> >>+--------------------
> >>+
> >>+- compatible: "toshiba,et8ek8"
> >>+- reg: I2C address (0x3e, or an alternative address)
> >>+- vana-supply: Analogue voltage supply (VANA), typically 2,8 volts (sensor
> >>+  dependent).
> >
> >As these are bindings for a particular sensor, 2,8 volts it is.
> >
> >The sensor has also a digital voltage supply but it might be controlled by
> >the same GPIO which controls the CCP2 switch. Ugly stuff. Perhaps we could
> >just omit that here.
> >
> 
> ok
> 
> >>+- clocks: External clock to the sensor
> >>+- clock-frequency: Frequency of the external clock to the sensor
> >>+
> >>+
> >>+Optional properties
> >>+-------------------
> >>+
> >>+- reset-gpios: XSHUTDOWN GPIO
> >
> >I guess this should be mandatory.
> >
> 
> yeah. Also, I will change xxx-lanes to optional
> 
> >>+
> >>+
> >>+Endpoint node mandatory properties
> >>+----------------------------------
> >>+
> >>+- clock-lanes: <0>
> >>+- data-lanes: <1..n>
> >>+- remote-endpoint: A phandle to the bus receiver's endpoint node.
> >>+
> >>+
> >>+Example
> >>+-------
> >>+
> >>+&i2c3 {
> >>+	clock-frequency = <400000>;
> >>+
> >>+	cam1: camera@3e {
> >>+		compatible = "toshiba,et8ek8";
> >>+		reg = <0x3e>;
> >>+		vana-supply = <&vaux4>;
> >>+		clocks = <&isp 0>;
> >>+		clock-frequency = <9600000>;
> >>+		reset-gpio = <&gpio4 6 GPIO_ACTIVE_HIGH>; /* 102 */
> >>+		port {
> >>+			csi_cam1: endpoint {
> >>+				remote-endpoint = <&csi_out1>;
> >>+			};
> >>+		};
> >>+	};
> >>+};
> >
> >Please split the DT documentation from the driver.
> >
> 
> Split it how? Send as series [patch 1] - driver, [patch 2] - doc?

Yes, please. As the ad5820, for instance.

> 
> >I remember having discussed showing the module in DT with Sebastian but I
> >couldn't find the patches anywhere. We currently consider the lens and
> >sensor entirely separate, the module has not been shown in software as
> >there's been nothing to control it.
> >
> 
> Not sure what am I supposed to do with that comment :)

Not necessarily anything. But I'd like to continue the discussion on the
topic. :-)

> 
> >Sebastian: do you still have those patches around somewhere?
> >
> >>diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> >>index 993dc50..e964787 100644
> >>--- a/drivers/media/i2c/Kconfig
> >>+++ b/drivers/media/i2c/Kconfig
> >>@@ -629,6 +629,7 @@ config VIDEO_S5K5BAF
> >>  	  camera sensor with an embedded SoC image signal processor.
> >>
> >>  source "drivers/media/i2c/smiapp/Kconfig"
> >>+source "drivers/media/i2c/et8ek8/Kconfig"
> >>
> >>  config VIDEO_S5C73M3
> >>  	tristate "Samsung S5C73M3 sensor support"
> >>diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> >>index 94f2c99..907b180 100644
> >>--- a/drivers/media/i2c/Makefile
> >>+++ b/drivers/media/i2c/Makefile
> >>@@ -2,6 +2,7 @@ msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
> >>  obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
> >>
> >>  obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
> >>+obj-$(CONFIG_VIDEO_ET8EK8)	+= et8ek8/
> >>  obj-$(CONFIG_VIDEO_CX25840) += cx25840/
> >>  obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
> >>  obj-y				+= soc_camera/
> >>diff --git a/drivers/media/i2c/et8ek8/Kconfig b/drivers/media/i2c/et8ek8/Kconfig
> >>new file mode 100644
> >>index 0000000..1439936
> >>--- /dev/null
> >>+++ b/drivers/media/i2c/et8ek8/Kconfig
> >>@@ -0,0 +1,6 @@
> >>+config VIDEO_ET8EK8
> >>+	tristate "ET8EK8 camera sensor support"
> >>+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> >>+	---help---
> >>+	  This is a driver for the Toshiba ET8EK8 5 MP camera sensor.
> >>+	  It is used for example in Nokia N900 (RX-51).
> >>diff --git a/drivers/media/i2c/et8ek8/Makefile b/drivers/media/i2c/et8ek8/Makefile
> >>new file mode 100644
> >>index 0000000..66d1b7d
> >>--- /dev/null
> >>+++ b/drivers/media/i2c/et8ek8/Makefile
> >>@@ -0,0 +1,2 @@
> >>+et8ek8-objs			+= et8ek8_mode.o et8ek8_driver.o
> >>+obj-$(CONFIG_VIDEO_ET8EK8)	+= et8ek8.o
> >>diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> >>new file mode 100644
> >>index 0000000..1eaef78
> >>--- /dev/null
> >>+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> >>@@ -0,0 +1,1711 @@
> >>+/*
> >>+ * et8ek8_driver.c
> >>+ *
> >>+ * Copyright (C) 2008 Nokia Corporation
> >>+ *
> >>+ * Contact: Sakari Ailus <sakari.ailus@iki.fi>
> >>+ *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> >
> >tuukkat76@gmail.com
> >
> 
> ok
> 
> >>+ *
> >>+ * Based on code from Toni Leinonen <toni.leinonen@offcode.fi>.
> >>+ *
> >>+ * This driver is based on the Micron MT9T012 camera imager driver
> >>+ * (C) Texas Instruments.
> >>+ *
> >>+ * This program is free software; you can redistribute it and/or
> >>+ * modify it under the terms of the GNU General Public License
> >>+ * version 2 as published by the Free Software Foundation.
> >>+ *
> >>+ * This program is distributed in the hope that it will be useful, but
> >>+ * WITHOUT ANY WARRANTY; without even the implied warranty of
> >>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> >>+ * General Public License for more details.
> >>+ */
> >>+
> >>+#include <linux/clk.h>
> >>+#include <linux/delay.h>
> >>+#include <linux/i2c.h>
> >>+#include <linux/kernel.h>
> >>+#include <linux/module.h>
> >>+#include <linux/mutex.h>
> >>+#include <linux/gpio/consumer.h>
> >
> >Alphabetical order, please.
> >
> 
> ok
> 
> >>+#include <linux/regulator/consumer.h>
> >>+#include <linux/slab.h>
> >>+#include <linux/sort.h>
> >>+#include <linux/version.h>
> >
> >Is linux/version.h needed?
> >
> 
> no, will remove it
> 
> >>+#include <linux/v4l2-mediabus.h>
> >>+
> >>+#include <media/media-entity.h>
> >>+#include <media/v4l2-ctrls.h>
> >>+#include <media/v4l2-device.h>
> >>+#include <media/v4l2-subdev.h>
> >>+
> >>+#include "et8ek8_reg.h"
> >>+
> >>+#define ET8EK8_NAME		"et8ek8"
> >>+#define ET8EK8_PRIV_MEM_SIZE	128
> >>+
> >>+#define ET8EK8_CID_USER_FRAME_WIDTH	(V4L2_CID_USER_ET8EK8_BASE + 1)
> >>+#define ET8EK8_CID_USER_FRAME_HEIGHT	(V4L2_CID_USER_ET8EK8_BASE + 2)
> >>+#define ET8EK8_CID_USER_VISIBLE_WIDTH	(V4L2_CID_USER_ET8EK8_BASE + 3)
> >>+#define ET8EK8_CID_USER_VISIBLE_HEIGHT	(V4L2_CID_USER_ET8EK8_BASE + 4)
> >>+#define ET8EK8_CID_USER_SENSITIVITY	(V4L2_CID_USER_ET8EK8_BASE + 5)
> >
> >If you have custom controls,
> >
> 
> hmm?

Yes, this is apparently left unfinished and it's a bit hard to grasp what
was the real meaning behind that comment. I agree.

What I meant to say that the controls would be better to be defined in a
header file. However, the interface to access the information shouldn't be
controls.

In this case, I believe the information is already provided to the user:
VIDIOC_SUBDEV_S_FMT is used to set the output format, and as none of the
modes use cropping.

In order to resolve this, I suggest dropping these controls.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
