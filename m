Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35099 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbcEWHlg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 03:41:36 -0400
Date: Mon, 23 May 2016 09:41:32 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	sakari.ailus@iki.fi
Subject: Re: [PATCHv3] support for AD5820 camera auto-focus coil
Message-ID: <20160523074132.GD29844@pali>
References: <20160517181927.GA28741@amd>
 <20160521054336.GA27123@amd>
 <573FFF51.1000004@gmail.com>
 <20160521105607.GA20071@amd>
 <574049EF.2090208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <574049EF.2090208@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 21 May 2016 14:43:43 Ivaylo Dimitrov wrote:
> >diff --git a/include/media/ad5820.h b/include/media/ad5820.h
> >new file mode 100644
> >index 0000000..f5a1565
> >--- /dev/null
> >+++ b/include/media/ad5820.h
> >@@ -0,0 +1,70 @@
> >+/*
> >+ * include/media/ad5820.h
> >+ *
> >+ * Copyright (C) 2008 Nokia Corporation
> >+ * Copyright (C) 2007 Texas Instruments
> >+ *
> >+ * Contact: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> >+ *          Sakari Ailus <sakari.ailus@nokia.com>
> >+ *
> >+ * Based on af_d88.c by Texas Instruments.
> >+ *
> >+ * This program is free software; you can redistribute it and/or
> >+ * modify it under the terms of the GNU General Public License
> >+ * version 2 as published by the Free Software Foundation.
> >+ *
> >+ * This program is distributed in the hope that it will be useful, but
> >+ * WITHOUT ANY WARRANTY; without even the implied warranty of
> >+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> >+ * General Public License for more details.
> >+ *
> >+ * You should have received a copy of the GNU General Public License
> >+ * along with this program; if not, write to the Free Software
> >+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> >+ * 02110-1301 USA
> >+ */
> >+
> >+#ifndef AD5820_H
> >+#define AD5820_H
> >+
> >+#include <linux/i2c.h>
> >+#include <linux/mutex.h>
> >+#include <linux/videodev2.h>
> >+
> >+#include <media/v4l2-ctrls.h>
> >+#include <media/v4l2-subdev.h>
> >+
> >+struct regulator;
> >+
> >+#define AD5820_NAME		"ad5820"
> >+#define AD5820_I2C_ADDR		(0x18 >> 1)

Maybe write I2C address is more readable form? What is reason such
bit shift format?

> >+/* Register definitions */
> >+#define AD5820_POWER_DOWN		(1 << 15)
> >+#define AD5820_DAC_SHIFT		4
> 
> Do those defines really belong here? Isn't it better if they are moved to
> ad5820.c?

For me it looks like this is private for ad5820.c.

> >+#define AD5820_RAMP_MODE_LINEAR		(0 << 3)
> >+#define AD5820_RAMP_MODE_64_16		(1 << 3)
> >+
> >+struct ad5820_platform_data {
> >+	int (*set_xshutdown)(struct v4l2_subdev *subdev, int set);
> >+};

This is for legacy board code support right? We need DT support for N900
as legacy board code is going to be deleted.

> >+#define to_ad5820_device(sd)	container_of(sd, struct ad5820_device, subdev)
> >+
> >+struct ad5820_device {
> >+	struct v4l2_subdev subdev;
> >+	struct ad5820_platform_data *platform_data;
> >+	struct regulator *vana;
> >+
> >+	struct v4l2_ctrl_handler ctrls;
> >+	u32 focus_absolute;
> >+	u32 focus_ramp_time;
> >+	u32 focus_ramp_mode;
> >+
> >+	struct mutex power_lock;
> >+	int power_count;
> >+
> >+	int standby : 1;
> >+};
> >+
> 
> The same for struct ad5820_device, is it really part of the public API?

Yes, this is also private for ad5820.c

> >+#endif /* AD5820_H */
> >
> >
> >

-- 
Pali Rohár
pali.rohar@gmail.com
