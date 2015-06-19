Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48048 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbbFSM3K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 08:29:10 -0400
Message-ID: <55840AFD.5080700@xs4all.nl>
Date: Fri, 19 Jun 2015 14:28:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Pablo Anton <pablo.anton@veo-labs.com>, hans.verkuil@cisco.com
CC: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, lars@metafoo.de,
	Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Subject: Re: [PATCH v2] media: i2c: ADV7604: Migrate to regmap
References: <1434443919-3196-1-git-send-email-pablo.anton@veo-labs.com>
In-Reply-To: <1434443919-3196-1-git-send-email-pablo.anton@veo-labs.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2015 10:38 AM, Pablo Anton wrote:
> This is a preliminary patch in order to add support for ALSA.
> It replaces all current i2c access with regmap.
> 
> Signed-off-by: Pablo Anton <pablo.anton@veo-labs.com>
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>

After fixing the missing return value check that Lars-Peter found you can
add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
> v2: Rebase after renaming
> 
>  drivers/media/i2c/adv7604.c | 337 ++++++++++++++++++++++++++++++++------------
>  1 file changed, 244 insertions(+), 93 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 60ffcf0..38ae454 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -36,6 +36,7 @@
>  #include <linux/v4l2-dv-timings.h>
>  #include <linux/videodev2.h>
>  #include <linux/workqueue.h>
> +#include <linux/regmap.h>
>  
>  #include <media/adv7604.h>
>  #include <media/v4l2-ctrls.h>
> @@ -166,6 +167,9 @@ struct adv76xx_state {
>  	/* i2c clients */
>  	struct i2c_client *i2c_clients[ADV76XX_PAGE_MAX];
>  
> +	/* Regmaps */
> +	struct regmap *regmap[ADV76XX_PAGE_MAX];
> +
>  	/* controls */
>  	struct v4l2_ctrl *detect_tx_5v_ctrl;
>  	struct v4l2_ctrl *analog_sampling_phase_ctrl;
> @@ -346,66 +350,39 @@ static inline unsigned vtotal(const struct v4l2_bt_timings *t)
>  
>  /* ----------------------------------------------------------------------- */
>  
> -static s32 adv_smbus_read_byte_data_check(struct i2c_client *client,
> -		u8 command, bool check)
> -{
> -	union i2c_smbus_data data;
> -
> -	if (!i2c_smbus_xfer(client->adapter, client->addr, client->flags,
> -			I2C_SMBUS_READ, command,
> -			I2C_SMBUS_BYTE_DATA, &data))
> -		return data.byte;
> -	if (check)
> -		v4l_err(client, "error reading %02x, %02x\n",
> -				client->addr, command);
> -	return -EIO;
> -}
> -
> -static s32 adv_smbus_read_byte_data(struct adv76xx_state *state,
> -				    enum adv76xx_page page, u8 command)
> +static int adv76xx_read_check(struct adv76xx_state *state,
> +			     int client_page, u8 reg)
>  {
> -	return adv_smbus_read_byte_data_check(state->i2c_clients[page],
> -					      command, true);
> -}
> -
> -static s32 adv_smbus_write_byte_data(struct adv76xx_state *state,
> -				     enum adv76xx_page page, u8 command,
> -				     u8 value)
> -{
> -	struct i2c_client *client = state->i2c_clients[page];
> -	union i2c_smbus_data data;
> +	struct i2c_client *client = state->i2c_clients[client_page];
>  	int err;
> -	int i;
> +	unsigned int val;
>  
> -	data.byte = value;
> -	for (i = 0; i < 3; i++) {
> -		err = i2c_smbus_xfer(client->adapter, client->addr,
> -				client->flags,
> -				I2C_SMBUS_WRITE, command,
> -				I2C_SMBUS_BYTE_DATA, &data);
> -		if (!err)
> -			break;
> +	err = regmap_read(state->regmap[client_page], reg, &val);
> +
> +	if (err) {
> +		v4l_err(client, "error reading %02x, %02x\n",
> +				client->addr, reg);
> +		return err;
>  	}
> -	if (err < 0)
> -		v4l_err(client, "error writing %02x, %02x, %02x\n",
> -				client->addr, command, value);
> -	return err;
> +	return val;
>  }
>  
> -static s32 adv_smbus_write_i2c_block_data(struct adv76xx_state *state,
> -					  enum adv76xx_page page, u8 command,
> -					  unsigned length, const u8 *values)
> +/* adv76xx_write_block(): Write raw data with a maximum of I2C_SMBUS_BLOCK_MAX
> + * size to one or more registers.
> + *
> + * A value of zero will be returned on success, a negative errno will
> + * be returned in error cases.
> + */
> +static int adv76xx_write_block(struct adv76xx_state *state, int client_page,
> +			      unsigned int init_reg, const void *val,
> +			      size_t val_len)
>  {
> -	struct i2c_client *client = state->i2c_clients[page];
> -	union i2c_smbus_data data;
> +	struct regmap *regmap = state->regmap[client_page];
> +
> +	if (val_len > I2C_SMBUS_BLOCK_MAX)
> +		val_len = I2C_SMBUS_BLOCK_MAX;
>  
> -	if (length > I2C_SMBUS_BLOCK_MAX)
> -		length = I2C_SMBUS_BLOCK_MAX;
> -	data.block[0] = length;
> -	memcpy(data.block + 1, values, length);
> -	return i2c_smbus_xfer(client->adapter, client->addr, client->flags,
> -			      I2C_SMBUS_WRITE, command,
> -			      I2C_SMBUS_I2C_BLOCK_DATA, &data);
> +	return regmap_raw_write(regmap, init_reg, val, val_len);
>  }
>  
>  /* ----------------------------------------------------------------------- */
> @@ -414,14 +391,14 @@ static inline int io_read(struct v4l2_subdev *sd, u8 reg)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_IO, reg);
> +	return adv76xx_read_check(state, ADV76XX_PAGE_IO, reg);
>  }
>  
>  static inline int io_write(struct v4l2_subdev *sd, u8 reg, u8 val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_IO, reg, val);
> +	return regmap_write(state->regmap[ADV76XX_PAGE_IO], reg, val);
>  }
>  
>  static inline int io_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
> @@ -433,71 +410,70 @@ static inline int avlink_read(struct v4l2_subdev *sd, u8 reg)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_read_byte_data(state, ADV7604_PAGE_AVLINK, reg);
> +	return adv76xx_read_check(state, ADV7604_PAGE_AVLINK, reg);
>  }
>  
>  static inline int avlink_write(struct v4l2_subdev *sd, u8 reg, u8 val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_write_byte_data(state, ADV7604_PAGE_AVLINK, reg, val);
> +	return regmap_write(state->regmap[ADV7604_PAGE_AVLINK], reg, val);
>  }
>  
>  static inline int cec_read(struct v4l2_subdev *sd, u8 reg)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_CEC, reg);
> +	return adv76xx_read_check(state, ADV76XX_PAGE_CEC, reg);
>  }
>  
>  static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_CEC, reg, val);
> +	return regmap_write(state->regmap[ADV76XX_PAGE_CEC], reg, val);
>  }
>  
>  static inline int infoframe_read(struct v4l2_subdev *sd, u8 reg)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_INFOFRAME, reg);
> +	return adv76xx_read_check(state, ADV76XX_PAGE_INFOFRAME, reg);
>  }
>  
>  static inline int infoframe_write(struct v4l2_subdev *sd, u8 reg, u8 val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_INFOFRAME,
> -					 reg, val);
> +	return regmap_write(state->regmap[ADV76XX_PAGE_INFOFRAME], reg, val);
>  }
>  
>  static inline int afe_read(struct v4l2_subdev *sd, u8 reg)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_AFE, reg);
> +	return adv76xx_read_check(state, ADV76XX_PAGE_AFE, reg);
>  }
>  
>  static inline int afe_write(struct v4l2_subdev *sd, u8 reg, u8 val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_AFE, reg, val);
> +	return regmap_write(state->regmap[ADV76XX_PAGE_AFE], reg, val);
>  }
>  
>  static inline int rep_read(struct v4l2_subdev *sd, u8 reg)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_REP, reg);
> +	return adv76xx_read_check(state, ADV76XX_PAGE_REP, reg);
>  }
>  
>  static inline int rep_write(struct v4l2_subdev *sd, u8 reg, u8 val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_REP, reg, val);
> +	return regmap_write(state->regmap[ADV76XX_PAGE_REP], reg, val);
>  }
>  
>  static inline int rep_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
> @@ -509,28 +485,37 @@ static inline int edid_read(struct v4l2_subdev *sd, u8 reg)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_EDID, reg);
> +	return adv76xx_read_check(state, ADV76XX_PAGE_EDID, reg);
>  }
>  
>  static inline int edid_write(struct v4l2_subdev *sd, u8 reg, u8 val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_EDID, reg, val);
> +	return regmap_write(state->regmap[ADV76XX_PAGE_EDID], reg, val);
>  }
>  
>  static inline int edid_write_block(struct v4l2_subdev *sd,
> -					unsigned len, const u8 *val)
> +					unsigned int total_len, const u8 *val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  	int err = 0;
> -	int i;
> +	int i = 0;
> +	int len = 0;
> +
> +	v4l2_dbg(2, debug, sd, "%s: write EDID block (%d byte)\n",
> +				__func__, total_len);
>  
> -	v4l2_dbg(2, debug, sd, "%s: write EDID block (%d byte)\n", __func__, len);
> +	while (!err && i < total_len) {
> +		len = (total_len - i) > I2C_SMBUS_BLOCK_MAX ?
> +				I2C_SMBUS_BLOCK_MAX :
> +				(total_len - i);
> +
> +		err = adv76xx_write_block(state, ADV76XX_PAGE_EDID,
> +				i, val + i, len);
> +		i += len;
> +	}
>  
> -	for (i = 0; !err && i < len; i += I2C_SMBUS_BLOCK_MAX)
> -		err = adv_smbus_write_i2c_block_data(state, ADV76XX_PAGE_EDID,
> -				i, I2C_SMBUS_BLOCK_MAX, val + i);
>  	return err;
>  }
>  
> @@ -560,7 +545,7 @@ static inline int hdmi_read(struct v4l2_subdev *sd, u8 reg)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_HDMI, reg);
> +	return adv76xx_read_check(state, ADV76XX_PAGE_HDMI, reg);
>  }
>  
>  static u16 hdmi_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
> @@ -572,7 +557,7 @@ static inline int hdmi_write(struct v4l2_subdev *sd, u8 reg, u8 val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_HDMI, reg, val);
> +	return regmap_write(state->regmap[ADV76XX_PAGE_HDMI], reg, val);
>  }
>  
>  static inline int hdmi_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
> @@ -584,14 +569,14 @@ static inline int test_write(struct v4l2_subdev *sd, u8 reg, u8 val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_TEST, reg, val);
> +	return regmap_write(state->regmap[ADV76XX_PAGE_TEST], reg, val);
>  }
>  
>  static inline int cp_read(struct v4l2_subdev *sd, u8 reg)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_read_byte_data(state, ADV76XX_PAGE_CP, reg);
> +	return adv76xx_read_check(state, ADV76XX_PAGE_CP, reg);
>  }
>  
>  static u16 cp_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
> @@ -603,7 +588,7 @@ static inline int cp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_write_byte_data(state, ADV76XX_PAGE_CP, reg, val);
> +	return regmap_write(state->regmap[ADV76XX_PAGE_CP], reg, val);
>  }
>  
>  static inline int cp_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
> @@ -615,14 +600,14 @@ static inline int vdp_read(struct v4l2_subdev *sd, u8 reg)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_read_byte_data(state, ADV7604_PAGE_VDP, reg);
> +	return adv76xx_read_check(state, ADV7604_PAGE_VDP, reg);
>  }
>  
>  static inline int vdp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  
> -	return adv_smbus_write_byte_data(state, ADV7604_PAGE_VDP, reg, val);
> +	return regmap_write(state->regmap[ADV7604_PAGE_VDP], reg, val);
>  }
>  
>  #define ADV76XX_REG(page, offset)	(((page) << 8) | (offset))
> @@ -633,13 +618,15 @@ static int adv76xx_read_reg(struct v4l2_subdev *sd, unsigned int reg)
>  {
>  	struct adv76xx_state *state = to_state(sd);
>  	unsigned int page = reg >> 8;
> +	unsigned int val;
>  
>  	if (!(BIT(page) & state->info->page_mask))
>  		return -EINVAL;
>  
>  	reg &= 0xff;
> +	regmap_read(state->regmap[page], reg, &val);
>  
> -	return adv_smbus_read_byte_data(state, page, reg);
> +	return val;
>  }
>  #endif
>  
> @@ -653,7 +640,7 @@ static int adv76xx_write_reg(struct v4l2_subdev *sd, unsigned int reg, u8 val)
>  
>  	reg &= 0xff;
>  
> -	return adv_smbus_write_byte_data(state, page, reg, val);
> +	return regmap_write(state->regmap[page], reg, val);
>  }
>  
>  static void adv76xx_write_reg_seq(struct v4l2_subdev *sd,
> @@ -949,8 +936,8 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
>  		/* Should only be set in auto-graphics mode [REF_02, p. 91-92] */
>  		/* setup PLL_DIV_MAN_EN and PLL_DIV_RATIO */
>  		/* IO-map reg. 0x16 and 0x17 should be written in sequence */
> -		if (adv_smbus_write_i2c_block_data(state, ADV76XX_PAGE_IO,
> -						   0x16, 2, pll))
> +		if (regmap_raw_write(state->regmap[ADV76XX_PAGE_IO],
> +					0x16, pll, 2))
>  			v4l2_err(sd, "writing to reg 0x16 and 0x17 failed\n");
>  
>  		/* active video - horizontal timing */
> @@ -1001,8 +988,8 @@ static void adv76xx_set_offset(struct v4l2_subdev *sd, bool auto_offset, u16 off
>  	offset_buf[3] = offset_c & 0x0ff;
>  
>  	/* Registers must be written in this order with no i2c access in between */
> -	if (adv_smbus_write_i2c_block_data(state, ADV76XX_PAGE_CP,
> -					   0x77, 4, offset_buf))
> +	if (regmap_raw_write(state->regmap[ADV76XX_PAGE_CP],
> +			0x77, offset_buf, 4))
>  		v4l2_err(sd, "%s: i2c error writing to CP reg 0x77, 0x78, 0x79, 0x7a\n", __func__);
>  }
>  
> @@ -1031,8 +1018,8 @@ static void adv76xx_set_gain(struct v4l2_subdev *sd, bool auto_gain, u16 gain_a,
>  	gain_buf[3] = ((gain_c & 0x0ff));
>  
>  	/* Registers must be written in this order with no i2c access in between */
> -	if (adv_smbus_write_i2c_block_data(state, ADV76XX_PAGE_CP,
> -					   0x73, 4, gain_buf))
> +	if (regmap_raw_write(state->regmap[ADV76XX_PAGE_CP],
> +			     0x73, gain_buf, 4))
>  		v4l2_err(sd, "%s: i2c error writing to CP reg 0x73, 0x74, 0x75, 0x76\n", __func__);
>  }
>  
> @@ -2674,6 +2661,151 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
>  	return 0;
>  }
>  
> +static const struct regmap_config adv76xx_regmap_cnf[] = {
> +	{
> +		.name			= "io",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "avlink",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "cec",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "infoframe",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "esdp",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "epp",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "afe",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "rep",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "edid",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +
> +	{
> +		.name			= "hdmi",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "test",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "cp",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "vdp",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +};
> +
> +static int configure_regmap(struct adv76xx_state *state, int region)
> +{
> +	int err;
> +
> +	if (!state->i2c_clients[region])
> +		return -ENODEV;
> +
> +	if (!state->regmap[region]) {
> +
> +		state->regmap[region] =
> +			devm_regmap_init_i2c(state->i2c_clients[region],
> +					     &adv76xx_regmap_cnf[region]);
> +
> +		if (IS_ERR(state->regmap[region])) {
> +			err = PTR_ERR(state->regmap[region]);
> +			v4l_err(state->i2c_clients[region],
> +					"Error initializing regmap %d with error %d\n",
> +					region, err);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int configure_regmaps(struct adv76xx_state *state)
> +{
> +	int i, err;
> +
> +	for (i = 0 ; i < ADV76XX_PAGE_MAX; i++) {
> +		err = configure_regmap(state, i);
> +		if (err && (err != -ENODEV))
> +			return err;
> +	}
> +	return 0;
> +}
> +
>  static int adv76xx_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *id)
>  {
> @@ -2683,7 +2815,7 @@ static int adv76xx_probe(struct i2c_client *client,
>  	struct v4l2_ctrl_handler *hdl;
>  	struct v4l2_subdev *sd;
>  	unsigned int i;
> -	u16 val;
> +	unsigned int val, val2;
>  	int err;
>  
>  	/* Check if the adapter supports the needed features */
> @@ -2747,22 +2879,36 @@ static int adv76xx_probe(struct i2c_client *client,
>  		client->addr);
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  
> +	/* Configure IO Regmap region */
> +	err = configure_regmap(state, ADV76XX_PAGE_IO);
> +
> +	if (err) {
> +		v4l2_info(sd, "Error configuring IO regmap region\n");
> +		return -ENODEV;
> +	}
> +
>  	/*
>  	 * Verify that the chip is present. On ADV7604 the RD_INFO register only
>  	 * identifies the revision, while on ADV7611 it identifies the model as
>  	 * well. Use the HDMI slave address on ADV7604 and RD_INFO on ADV7611.
>  	 */
>  	if (state->info->type == ADV7604) {
> -		val = adv_smbus_read_byte_data_check(client, 0xfb, false);
> +		regmap_read(state->regmap[ADV76XX_PAGE_IO], 0xfb, &val);
>  		if (val != 0x68) {
>  			v4l2_info(sd, "not an adv7604 on address 0x%x\n",
>  					client->addr << 1);
>  			return -ENODEV;
>  		}
>  	} else {
> -		val = (adv_smbus_read_byte_data_check(client, 0xea, false) << 8)
> -		    | (adv_smbus_read_byte_data_check(client, 0xeb, false) << 0);
> -		if (val != 0x2051) {
> +		regmap_read(state->regmap[ADV76XX_PAGE_IO],
> +				0xea,
> +				&val);
> +		val2 = val << 8;
> +		regmap_read(state->regmap[ADV76XX_PAGE_IO],
> +			    0xeb,
> +			    &val);
> +		val2 |= val;
> +		if (val2 != 0x2051) {
>  			v4l2_info(sd, "not an adv7611 on address 0x%x\n",
>  					client->addr << 1);
>  			return -ENODEV;
> @@ -2853,6 +2999,11 @@ static int adv76xx_probe(struct i2c_client *client,
>  	if (err)
>  		goto err_work_queues;
>  
> +	/* Configure regmaps */
> +	err = configure_regmaps(state);
> +	if (err)
> +		goto err_entity;
> +
>  	err = adv76xx_core_init(sd);
>  	if (err)
>  		goto err_entity;
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
