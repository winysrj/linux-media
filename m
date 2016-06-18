Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57701 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbcFRPXD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 11:23:03 -0400
Date: Sat, 18 Jun 2016 17:22:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	mchehab@osg.samsung.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20160618152259.GC8392@amd>
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1465659593-16858-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1465659593-16858-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> The sensor is found in Nokia N900 main camera
> 
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>

> +/*
> + *
> + * Register access helpers
> + *
> + */
> +
> +/*
> + * Read a 8/16/32-bit i2c register.  The value is returned in 'val'.
> + * Returns zero if successful, or non-zero otherwise.
> + */

Turn the first comment into "normal" comment style, and merge the two
comments?


> +static int et8ek8_i2c_read_reg(struct i2c_client *client, u16 data_length,
> +			       u16 reg, u32 *val)
> +{
> +	int r;
> +	struct i2c_msg msg[1];

Uff. That's a bit non-traditional. Use plain "struct i2c_msg msg;" if
you have just one?

> +		/* Now we start writing ... */
> +		r = et8ek8_i2c_buffered_write_regs(client, regs, cnt);
> +
> +		/* ... and then check that everything was OK */
> +		if (r < 0) {
> +			dev_err(&client->dev, "i2c transfer error !!!\n");
> +			return r;

I'd reduce number of "!"s in the message.

> +		/*
> +		 * If we ran into a sleep statement when going through
> +		 * the list, this is where we snooze for the required time
> +		 */
> +		if (next->type == ET8EK8_REG_DELAY) {
> +			set_current_state(TASK_UNINTERRUPTIBLE);
> +			schedule_timeout(msecs_to_jiffies(next->val));

Open-coded set_current_state(), and no restore, makes me
suspicious. Can msleep() be used here?

> +{
> +	int r;
> +	struct i2c_msg msg[1];

I'd avoid array for single entry. (You'll need to make it &msg below,
but...)

> +/*
> + * Return time of one row in microseconds, .8 fixed point format.
> + * If the sensor is not set to any mode, return zero.
> + */

typedef int fixedfp; then use it where .8 fixed point is used?

> +static int et8ek8_set_test_pattern(struct et8ek8_sensor *sensor, s32 mode)
> +{
...
> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x111B,
> +				    tp_mode << 4);
> +	if (rval)
> +		goto out;
> +
> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1121,
> +				    cbh_mode << 7);
> +	if (rval)
> +		goto out;
> +
> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1124,
> +				    cbv_mode << 7);
> +	if (rval)
> +		goto out;
> +
> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x112C, din_sw);
> +	if (rval)
> +		goto out;
> +
> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1420, r1420);
> +
> +out:
> +	return rval;
> +}

I'd avoid gotos when all it does is return.

> +/*
> + *
> + * Stingray sensor mode settings for Scooby
> + *
> + *
> + */

I'd fix it to normal comment style... and possibly remove it. Can you
understand what it says?

> +	},
> +	.regs = {
> +		{ ET8EK8_REG_8BIT, 0x1239, 0x4F },	/*        */
> +		{ ET8EK8_REG_8BIT, 0x1238, 0x02 },	/*        */
> +		{ ET8EK8_REG_8BIT, 0x123B, 0x70 },	/*        */
> +		{ ET8EK8_REG_8BIT, 0x123A, 0x05 },	/*        */
> +		{ ET8EK8_REG_8BIT, 0x121B, 0x63 },	/*        */
> +		{ ET8EK8_REG_8BIT, 0x1220, 0x85 },	/*        */
> +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },	/*        */
> +		{ ET8EK8_REG_8BIT, 0x1222, 0x58 },	/*        */
> +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },	/*        */
> +		{ ET8EK8_REG_8BIT, 0x121D, 0x63 },	/*        */
> +		{ ET8EK8_REG_8BIT, 0x125D, 0x83 },	/*        */
> +		{ ET8EK8_REG_TERM, 0, 0}
> +	}

I'd remove the empty comments...

> +struct et8ek8_meta_reglist meta_reglist = {
> +	.version = "V14 03-June-2008",

Do we need the version?

> +	.reglist = {
> +		{ .ptr = &mode1_poweron_mode2_16vga_2592x1968_12_07fps },
> +		{ .ptr = &mode1_16vga_2592x1968_13_12fps_dpcm10_8 },
> +		{ .ptr = &mode3_4vga_1296x984_29_99fps_dpcm10_8 },
> +		{ .ptr = &mode4_svga_864x656_29_88fps },
> +		{ .ptr = &mode5_vga_648x492_29_93fps },
> +		{ .ptr = &mode2_16vga_2592x1968_3_99fps },
> +		{ .ptr = &mode_648x492_5fps },
> +		{ .ptr = &mode3_4vga_1296x984_5fps },
> +		{ .ptr = &mode_4vga_1296x984_25fps_dpcm10_8 },
> +		{ .ptr = 0 }
> +	}
> +};

I'd say .ptr = NULL.

> +struct v4l2_mbus_framefmt;
> +struct v4l2_subdev_pad_mbus_code_enum;
> +
> +struct et8ek8_mode {
> +	/* Physical sensor resolution and current image window */
> +	__u16 sensor_width;
> +	__u16 sensor_height;
> +	__u16 sensor_window_origin_x;
> +	__u16 sensor_window_origin_y;
> +	__u16 sensor_window_width;
> +	__u16 sensor_window_height;

If this can not be included from userland, convert __uX -> uX.

> +#define ET8EK8_MAX_LEN			32
> +struct et8ek8_meta_reglist {
> +	char version[ET8EK8_MAX_LEN];
> +	union {
> +		struct et8ek8_reglist *ptr;
> +	} reglist[];
> +};

What is going on here? union with single entry is strange...

(And thanks for doing all the work.)

Best regards,
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
