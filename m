Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:32909 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbbEFLIf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 07:08:35 -0400
Message-ID: <5549F62C.3040209@xs4all.nl>
Date: Wed, 06 May 2015 13:08:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: matrandg@cisco.com, linux-media@vger.kernel.org
CC: hansverk@cisco.com, p.zabel@pengutronix.de, kernel@pengutronix.de
Subject: Re: [PATCH] Driver for Toshiba TC358743 HDMI to CSI-2 bridge
References: <1430904429-24899-1-git-send-email-matrandg@cisco.com>
In-Reply-To: <1430904429-24899-1-git-send-email-matrandg@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mats,

I have a few comments, see below:

On 05/06/15 11:27, matrandg@cisco.com wrote:
> From: Mats Randgaard <matrandg@cisco.com>
> 
> The driver is tested on our hardware and all the implemented features
> works as expected.
> 
> Missing features:
> - CEC support
> - HDCP repeater support
> - IR support
> 
> Signed-off-by: Mats Randgaard <matrandg@cisco.com>
> ---
>  MAINTAINERS                        |    6 +
>  drivers/media/i2c/Kconfig          |    9 +
>  drivers/media/i2c/Makefile         |    1 +
>  drivers/media/i2c/tc358743.c       | 1838 ++++++++++++++++++++++++++++++++++++
>  drivers/media/i2c/tc358743_regs.h  |  680 +++++++++++++
>  include/media/tc358743.h           |   92 ++
>  include/uapi/linux/v4l2-controls.h |    4 +
>  7 files changed, 2630 insertions(+)
>  create mode 100644 drivers/media/i2c/tc358743.c
>  create mode 100644 drivers/media/i2c/tc358743_regs.h
>  create mode 100644 include/media/tc358743.h
> 

<snip>

> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> new file mode 100644
> index 0000000..e9328c4
> --- /dev/null
> +++ b/drivers/media/i2c/tc358743.c
> @@ -0,0 +1,1838 @@

<snip>

> +/* --------------- AVI --------------- */
> +
> +struct aviInfoFrame {
> +	u8 f17;
> +	u8 y10;
> +	u8 a0;
> +	u8 b10;
> +	u8 s10;
> +	u8 c10;
> +	u8 m10;
> +	u8 r3210;
> +	u8 itc;
> +	u8 ec210;
> +	u8 q10;
> +	u8 sc10;
> +	u8 f47;
> +	u8 vic;
> +	u8 yq10;
> +	u8 cn10;
> +	u8 pr3210;
> +	u16 etb;
> +	u16 sbb;
> +	u16 elb;
> +	u16 srb;
> +};
> +
> +static const char *y10Text[4] = {
> +	"RGB",
> +	"YCbCr 4:2:2",
> +	"YCbCr 4:4:4",
> +	"Future",
> +};
> +
> +static const char *c10Text[4] = {
> +	"No Data",
> +	"SMPTE 170M",
> +	"ITU-R 709",
> +	"Extended Colorimetry information valid",
> +};
> +
> +static const char *itcText[2] = {
> +	"No Data",
> +	"IT content",
> +};
> +
> +static const char *ec210Text[8] = {
> +	"xvYCC601",
> +	"xvYCC709",
> +	"sYCC601",
> +	"AdobeYCC601",
> +	"AdobeRGB",
> +	"5 reserved",
> +	"6 reserved",
> +	"7 reserved",
> +};
> +
> +static const char *q10Text[4] = {
> +	"Default",
> +	"Limited Range",
> +	"Full Range",
> +	"Reserved",
> +};
> +
> +static void parse_avi_infoframe(struct v4l2_subdev *sd, u8 *buf,
> +				struct aviInfoFrame *avi)
> +{
> +	avi->f17 = (buf[1] >> 7) & 0x1;
> +	avi->y10 = (buf[1] >> 5) & 0x3;
> +	avi->a0 = (buf[1] >> 4) & 0x1;
> +	avi->b10 = (buf[1] >> 2) & 0x3;
> +	avi->s10 = buf[1] & 0x3;
> +	avi->c10 = (buf[2] >> 6) & 0x3;
> +	avi->m10 = (buf[2] >> 4) & 0x3;
> +	avi->r3210 = buf[2] & 0xf;
> +	avi->itc = (buf[3] >> 7) & 0x1;
> +	avi->ec210 = (buf[3] >> 4) & 0x7;
> +	avi->q10 = (buf[3] >> 2) & 0x3;
> +	avi->sc10 = buf[3] & 0x3;
> +	avi->f47 = (buf[4] >> 7) & 0x1;
> +	avi->vic = buf[4] & 0x7f;
> +	avi->yq10 = (buf[5] >> 6) & 0x3;
> +	avi->cn10 = (buf[5] >> 4) & 0x3;
> +	avi->pr3210 = buf[5] & 0xf;
> +	avi->etb = buf[6] + 256 * buf[7];
> +	avi->sbb = buf[8] + 256 * buf[9];
> +	avi->elb = buf[10] + 256 * buf[11];
> +	avi->srb = buf[12] + 256 * buf[13];
> +}
> +
> +static void print_avi_infoframe(struct v4l2_subdev *sd)
> +{
> +	u8 buf[14];
> +	u8 avi_len;
> +	u8 avi_ver;
> +	struct aviInfoFrame avi;
> +
> +	if (!is_hdmi(sd)) {
> +		v4l2_info(sd, "receive DVI-D signal (AVI infoframe not supported)\n");
> +		return;
> +	}
> +
> +	avi_ver = i2c_rd8(sd, PK_AVI_1HEAD);
> +	avi_len = i2c_rd8(sd, PK_AVI_2HEAD);
> +	v4l2_info(sd, "AVI infoframe version %d (%d byte)\n", avi_ver, avi_len);
> +
> +	if (avi_ver != 0x02)
> +		return;
> +
> +	i2c_rd(sd, PK_AVI_0BYTE, buf, ARRAY_SIZE(buf));
> +
> +	v4l2_info(sd, "\t%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
> +			buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6],
> +			buf[7], buf[8], buf[9], buf[10], buf[11], buf[12],
> +			buf[13]);
> +
> +	parse_avi_infoframe(sd, buf, &avi);
> +
> +	if (avi.vic)
> +		v4l2_info(sd, "\tVIC: %d\n", avi.vic);
> +	if (avi.itc)
> +		v4l2_info(sd, "\t%s\n", itcText[avi.itc]);
> +
> +	if (avi.y10)
> +		v4l2_info(sd, "\t%s %s\n", y10Text[avi.y10],
> +				!avi.c10 ? "" :
> +				(avi.c10 == 0x3 ? ec210Text[avi.ec210] :
> +				 c10Text[avi.c10]));
> +	else
> +		v4l2_info(sd, "\t%s %s\n", y10Text[avi.y10], q10Text[avi.q10]);
> +}

The drivers/video/hdmi.c has new InfoFrame logging functions that should
be used instead rather than duplicating code. See adv7842_log_infoframes
in the adv7842 driver.

<snip>

> +static int tc358743_get_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
> +{
> +	struct tc358743_state *state = to_state(sd);
> +	u8 vi_rep = i2c_rd8(sd, VI_REP);
> +
> +	if (format->pad != 0)
> +		return -EINVAL;
> +
> +	format->format.code = state->mbus_fmt_code;
> +	format->format.width = state->timings.bt.width;
> +	format->format.height = state->timings.bt.height;
> +	format->format.field = V4L2_FIELD_NONE;
> +
> +	switch (vi_rep & MASK_VOUT_COLOR_SEL) {
> +	case MASK_VOUT_COLOR_RGB_FULL:
> +	case MASK_VOUT_COLOR_RGB_LIMITED:
> +		format->format.colorspace = V4L2_COLORSPACE_SRGB;
> +		break;
> +	case MASK_VOUT_COLOR_601_YCBCR_LIMITED:
> +	case MASK_VOUT_COLOR_601_YCBCR_FULL:
> +		format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +		break;
> +	case MASK_VOUT_COLOR_709_YCBCR_FULL:
> +	case MASK_VOUT_COLOR_709_YCBCR_LIMITED:
> +		format->format.colorspace = V4L2_COLORSPACE_REC709;
> +		break;
> +	default:
> +		format->format.colorspace = 0;
> +		break;
> +	}
> +
> +	return 0;
> +}

tc358743_get_fmt should move to the PAD OPS section below:

<snip>

> +
> +/* --------------- PAD OPS --------------- */

I.e. here.

<snip>

> +
> +/* --------------- CUSTOM CTRLS --------------- */
> +
> +static const struct v4l2_ctrl_config tc358743_ctrl_audio_sampling_rate = {
> +	.id = TC358743_CID_AUDIO_SAMPLING_RATE,
> +	.name = "Audio sampling rate",
> +	.type = V4L2_CTRL_TYPE_INTEGER,
> +	.min = 0,
> +	.max = 768000,
> +	.step = 1,
> +	.def = 0,
> +	.flags = V4L2_CTRL_FLAG_READ_ONLY,
> +};
> +
> +static const struct v4l2_ctrl_config tc358743_ctrl_audio_present = {
> +	.id = TC358743_CID_AUDIO_PRESENT,
> +	.name = "Audio present",
> +	.type = V4L2_CTRL_TYPE_BOOLEAN,
> +	.min = 0,
> +	.max = 1,
> +	.step = 1,
> +	.def = 0,
> +	.flags = V4L2_CTRL_FLAG_READ_ONLY,
> +};
> +
> +/* --------------- PROBE / REMOVE --------------- */
> +
> +static int tc358743_probe(struct i2c_client *client,
> +			  const struct i2c_device_id *id)
> +{
> +	static struct v4l2_dv_timings default_timing =
> +		V4L2_DV_BT_CEA_640X480P59_94;
> +	struct tc358743_state *state;
> +	struct tc358743_platform_data *pdata = client->dev.platform_data;
> +	struct v4l2_subdev *sd;
> +	int err;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -EIO;
> +	v4l_dbg(1, debug, client, "chip found @ 0x%x (%s)\n",
> +		client->addr << 1, client->adapter->name);
> +
> +	state = devm_kzalloc(&client->dev, sizeof(struct tc358743_state),
> +			GFP_KERNEL);
> +	if (!state)
> +		return -ENOMEM;
> +
> +	/* platform data */
> +	if (!pdata) {
> +		v4l_err(client, "No platform data!\n");
> +		return -ENODEV;
> +	}
> +	state->pdata = *pdata;
> +
> +	state->i2c_client = client;
> +	sd = &state->sd;
> +	v4l2_i2c_subdev_init(sd, client, &tc358743_ops);
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;

Drop the HAS_DEVNODE flag. This driver doesn't need that (at least at
the moment).

> +
> +	/* i2c access */
> +	/* read the interrupt mask register, it should carry the
> +	 * default values, as it hasn't been touched at this point.
> +	 */
> +	if (i2c_rd16(sd, INTMASK) != 0x0400) {
> +		v4l2_info(sd, "not a TC358743 on address 0x%x\n",
> +			  client->addr << 1);
> +		return -ENODEV;
> +	}
> +
> +	/* control handlers */
> +	v4l2_ctrl_handler_init(&state->hdl, 3);
> +
> +	/* private controls */
> +	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(&state->hdl, NULL,
> +			V4L2_CID_DV_RX_POWER_PRESENT, 0, 1, 0, 0);
> +
> +	/* custom controls */
> +	state->audio_sampling_rate_ctrl = v4l2_ctrl_new_custom(&state->hdl,
> +			&tc358743_ctrl_audio_sampling_rate, NULL);
> +
> +	state->audio_present_ctrl = v4l2_ctrl_new_custom(&state->hdl,
> +			&tc358743_ctrl_audio_present, NULL);
> +
> +	sd->ctrl_handler = &state->hdl;
> +	if (state->hdl.error) {
> +		err = state->hdl.error;
> +		goto err_hdl;
> +	}
> +
> +	if (tc358743_update_controls(sd)) {
> +		err = -ENODEV;
> +		goto err_hdl;
> +	}
> +
> +	/* work queues */
> +	state->work_queues = create_singlethread_workqueue(client->name);
> +	if (!state->work_queues) {
> +		v4l2_err(sd, "Could not create work queue\n");
> +		err = -ENOMEM;
> +		goto err_hdl;
> +	}
> +
> +	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
> +			tc358743_delayed_work_enable_hotplug);
> +
> +	tc358743_initial_setup(sd);
> +
> +	tc358743_s_dv_timings(sd, &default_timing);
> +
> +	state->mbus_fmt_code = MEDIA_BUS_FMT_RGB888_1X24;
> +	tc358743_set_csi_color_space(sd);
> +
> +	tc358743_init_interrupts(sd);
> +	tc358743_enable_interrupts(sd, tx_5v_power_present(sd));
> +	i2c_wr16(sd, INTMASK, ~(MASK_HDMI_MSK | MASK_CSI_MSK) & 0xffff);
> +
> +	v4l2_ctrl_handler_setup(sd->ctrl_handler);
> +
> +	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
> +		  client->addr << 1, client->adapter->name);
> +
> +	return 0;
> +
> +err_hdl:
> +	v4l2_ctrl_handler_free(&state->hdl);
> +	return err;
> +}

<snip>

> +/* notify events */
> +#define TC358743_FMT_CHANGE     1

Use the new V4L2_EVENT_SOURCE_CHANGE event instead.

Actually, this is a good time to use this patch:

https://patchwork.linuxtv.org/patch/28839/

I've been waiting for a driver that uses this, and this is exactly
when it should be used.

Apply that patch first, then use V4L2_DEVICE_NOTIFY_EVENT to notify
the bridge driver of a v4l2_event (V4L2_EVENT_SOURCE_CHANGE in this
case).

> +
> +/* custom controls */
> +/* Audio sample rate in Hz */
> +#define TC358743_CID_AUDIO_SAMPLING_RATE (V4L2_CID_USER_TC358743_BASE + 0)
> +/* Audio present status */
> +#define TC358743_CID_AUDIO_PRESENT       (V4L2_CID_USER_TC358743_BASE + 1)

I wonder if this should be turned into standardized controls. But I think this
is OK for now and it can be replaced later if necessary.

> +
> +#endif
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 9f6e108..d448c53 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -174,6 +174,10 @@ enum v4l2_colorfx {
>   * We reserve 16 controls for this driver. */
>  #define V4L2_CID_USER_ADV7180_BASE		(V4L2_CID_USER_BASE + 0x1070)
>  
> +/* The base for the tc358743 driver controls.
> + * We reserve 16 controls for this driver. */
> +#define V4L2_CID_USER_TC358743_BASE		(V4L2_CID_USER_BASE + 0x1080)
> +
>  /* MPEG-class control IDs */
>  /* The MPEG controls are applicable to all codec controls
>   * and the 'MPEG' part of the define is historical */
> 

Regards,

	Hans
