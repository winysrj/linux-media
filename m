Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36739 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbcFDTQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2016 15:16:23 -0400
Received: by mail-wm0-f67.google.com with SMTP id m124so5720008wme.3
        for <linux-media@vger.kernel.org>; Sat, 04 Jun 2016 12:16:22 -0700 (PDT)
Subject: Re: [PATCH] [media]: Driver for Toshiba et8ek8 5MP sensor
To: Pavel Machek <pavel@ucw.cz>
References: <20160501134122.GG26360@valkosipuli.retiisi.org.uk>
 <1462287004-21099-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160524111901.GB18307@amd>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <57532903.4090606@gmail.com>
Date: Sat, 4 Jun 2016 22:16:19 +0300
MIME-Version: 1.0
In-Reply-To: <20160524111901.GB18307@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 24.05.2016 14:19, Pavel Machek wrote:
> Hi!
>
>> The sensor is found in Nokia N900 main camera
>>
>> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
>
>> +/*
>> + * A buffered write method that puts the wanted register write
>> + * commands in a message list and passes the list to the i2c framework
>> + */
>> +static int et8ek8_i2c_buffered_write_regs(struct i2c_client *client,
>> +					  const struct et8ek8_reg *wnext,
>> +					  int cnt)
>> +{
>> +	/* FIXME: check how big cnt is */
>> +	struct i2c_msg msg[cnt];
>> +	unsigned char data[cnt][6];
>
> Uff, no, variable length arrays in the kernel. No, I don't think that
> should be done. Rather allocate maximum length here and then check its
>> cnt?
>

ok

>> +/*
>> + * Write a list of registers to i2c device.
>> + *
>> + * The list of registers is terminated by ET8EK8_REG_TERM.
>> + * Returns zero if successful, or non-zero otherwise.
>> + */
>> +static int et8ek8_i2c_write_regs(struct i2c_client *client,
>> +				 const struct et8ek8_reg reglist[])
>> +{
>> +	int r, cnt = 0;
>> +	const struct et8ek8_reg *next, *wnext;
>> +
>> +	if (!client->adapter)
>> +		return -ENODEV;
>> +
>> +	if (reglist == NULL)
>
> (!reglist) ? :-). Actually, you can keep your preffered style there,
> but maybe ammount of if (something that can not happen) return
> ... should be reduced. Noone should ever call this without valid
> reglist or client->adapter, right?
>

Well, I always prefer if (!var) style, will change all the code to use it.

However, I prefer to keep the check here, I guess it compiles to two 
instructions not in some hot path.

>> +		return -EINVAL;
>> +
>> +	/* Initialize list pointers to the start of the list */
>> +	next = wnext = reglist;
>> +
>> +	do {
>> +		/*
>> +		 * We have to go through the list to figure out how
>> +		 * many regular writes we have in a row
>> +		 */
>> +		while (next->type != ET8EK8_REG_TERM
>> +		       && next->type != ET8EK8_REG_DELAY) {
>> +			/*
>> +			 * Here we check that the actual length fields
>> +			 * are valid
>> +			 */
>> +			if (next->type != ET8EK8_REG_8BIT
>> +			    &&  next->type != ET8EK8_REG_16BIT) {
>
> Extra space after &&
>

ok

>> +				dev_err(&client->dev,
>> +					"Invalid value on entry %d 0x%x\n",
>> +					cnt, next->type);
>> +				return -EINVAL;
>> +			}
>
> And maybe this could be just BUG_ON().
>
Yeah, makes sense, will change it.

>> +static struct et8ek8_reglist *et8ek8_reglist_find_mode_fmt(
>> +		struct et8ek8_meta_reglist *meta,
>> +		struct v4l2_mbus_framefmt *fmt)
>> +{
>> +	struct et8ek8_reglist **list = et8ek8_reglist_first(meta);
>> +	struct et8ek8_reglist *best_match = NULL;
>> +	struct et8ek8_reglist *best_other = NULL;
>> +	struct v4l2_mbus_framefmt format;
>> +	unsigned int max_dist_match = (unsigned int)-1;
>> +	unsigned int max_dist_other = (unsigned int)-1;
>> +
>> +	/* Find the mode with the closest image size. The distance between
>> +	 * image sizes is the size in pixels of the non-overlapping regions
>
> You may want to run checkpatch. I guess it will complain. I doubt it
> matters much :-).
>

I always run it before submitting :), but it didn't complain here. Or 
I've missed it. Anyway, going to fix that comment.

>> +	while (meta->reglist[nlists].ptr != NULL)
>> +		nlists++;
>
> ...!= NULL) can be removed. ... here and in other places.
>

ok

>> +
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x111B,
>> +				    tp_mode << 4);
>> +	if (rval)
>> +		goto out;
>> +
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1121,
>> +				    cbh_mode << 7);
>> +	if (rval)
>> +		goto out;
>> +
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1124,
>> +				    cbv_mode << 7);
>> +	if (rval)
>> +		goto out;
>> +
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x112C, din_sw);
>> +	if (rval)
>> +		goto out;
>> +
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1420, r1420);
>> +	if (rval)
>> +		goto out;
>> +
>> +out:
>> +	return rval;
>> +}
>
> Goto out when all out does is return is a bit of overkill.
>

yeah :)

>> +static int et8ek8_get_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct et8ek8_sensor *sensor =
>> +		container_of(ctrl->handler, struct et8ek8_sensor, ctrl_handler);
>> +	const struct et8ek8_mode *mode = &sensor->current_reglist->mode;
>> +
>> +	switch (ctrl->id) {
>> +	case ET8EK8_CID_USER_FRAME_WIDTH:
>> +		ctrl->cur.val = mode->width;
>> +		break;
>> +	case ET8EK8_CID_USER_FRAME_HEIGHT:
>> +		ctrl->cur.val = mode->height;
>> +		break;
>> +	case ET8EK8_CID_USER_VISIBLE_WIDTH:
>> +		ctrl->cur.val = mode->window_width;
>> +		break;
>> +	case ET8EK8_CID_USER_VISIBLE_HEIGHT:
>> +		ctrl->cur.val = mode->window_height;
>> +		break;
>> +	case ET8EK8_CID_USER_SENSITIVITY:
>> +		ctrl->cur.val = mode->sensitivity;
>> +		break;
>> +	}
>
> default: return -EINVAL ?
>

I checked a couple of other driver, nowhere there is such a case, I 
guess framework takes care of that.

>> +	/*
>> +	 * Calculate average pixel clock per line. Assume buffers can spread
>> +	 * the data over horizontal blanking time. Rounding upwards.
>> +	 * Formula taken from stock Nokia N900 kernel
>> +	 */
>
> "kernel."  ?
>

ok

>> +static int et8ek8_power_off(struct et8ek8_sensor *sensor)
>> +{
>> +	int rval;
>> +
>> +	gpiod_set_value(sensor->reset, 0);
>> +	udelay(1);
>> +
>> +	clk_disable_unprepare(sensor->ext_clk);
>> +
>> +	rval = regulator_disable(sensor->vana);
>> +	return rval;
>> +}
>
> get rid of rval, return directly?
>

ok

>> +	udelay(10); /* I wish this is a good value */
>
> Me too ;-).
>

Well, this is a comment from the original driver authors, I hope all 
their wishes to fulfil. I will leave that as it is and wait for Sakari's 
comment on it.

>> +static int et8ek8_g_priv_mem(struct v4l2_subdev *subdev)
>> +{
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +	unsigned int length = ET8EK8_PRIV_MEM_SIZE;
>> +	unsigned int offset = 0;
>> +	u8 *ptr  = sensor->priv_mem;
>> +	int rval = 0;
>> +
>> +	/* Read the EEPROM window-by-window, each window 8 bytes */
>> +	do {
>> +		u8 buffer[PRIV_MEM_WIN_SIZE];
>> +		struct i2c_msg msg;
>> +		int bytes, i;
>> +		int ofs;
>> +
>> +		/* Set the current window */
>> +		rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x0001,
>> +					    0xe0 | (offset >> 3));
>> +		if (rval < 0)
>> +			goto out;
>
> out: only does return, cleaning it up here will help readability.
>
>> +		/* Wait for status bit */
>> +		for (i = 0; i < 1000; ++i) {
>> +			u32 status;
>> +
>> +			rval = et8ek8_i2c_read_reg(client, ET8EK8_REG_8BIT,
>> +						   0x0003, &status);
>> +			if (rval < 0)
>> +				goto out;
>> +			if ((status & 0x08) == 0)
>> +				break;
>> +			usleep_range(1000, 2000);
>> +		};
>> +
>> +		if (i == 1000) {
>> +			rval = -EIO;
>> +			goto out;
>> +		}
>
> Especially here.
>
>> +		if (rval < 0)
>> +			goto out;
>> +		rval = 0;
>
> And here.
>

ok

>
>> +#ifndef ET8EK8REGS_H
>> +#define ET8EK8REGS_H
>> +
>> +#include <linux/i2c.h>
>> +#include <linux/types.h>
>> +#include <linux/videodev2.h>
>> +#include <linux/v4l2-subdev.h>
>> +
>> +struct v4l2_mbus_framefmt;
>> +struct v4l2_subdev_pad_mbus_code_enum;
>> +
>> +#define ET8EK8_MAGIC			0x531A0002
>> +
>> +struct et8ek8_mode {
>> +	/* Physical sensor resolution and current image window */
>> +	__u16 sensor_width;
>> +	__u16 sensor_height;
>
> Is this exported to userspace?
>

afaik no, but see Sakari's reply.

Many thanks for the review.
Ivo
