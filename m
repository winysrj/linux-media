Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34519 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbcEXJEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 05:04:37 -0400
Date: Tue, 24 May 2016 11:04:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	sakari.ailus@iki.fi
Subject: Re: [PATCHv3] support for AD5820 camera auto-focus coil
Message-ID: <20160524090433.GA1277@amd>
References: <20160517181927.GA28741@amd>
 <20160521054336.GA27123@amd>
 <573FFF51.1000004@gmail.com>
 <20160521105607.GA20071@amd>
 <574049EF.2090208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <574049EF.2090208@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> >+static int ad5820_registered(struct v4l2_subdev *subdev)
> >+{
> >+	struct ad5820_device *coil = to_ad5820_device(subdev);
> >+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> >+
> >+	coil->vana = regulator_get(&client->dev, "VANA");
> 
> devm_regulator_get()?

I'd rather avoid devm_ here. Driver is simple enough to allow it.

> >+#define AD5820_RAMP_MODE_LINEAR		(0 << 3)
> >+#define AD5820_RAMP_MODE_64_16		(1 << 3)
> >+
> >+struct ad5820_platform_data {
> >+	int (*set_xshutdown)(struct v4l2_subdev *subdev, int set);
> >+};
> >+
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

Let me check what can be done with it.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
