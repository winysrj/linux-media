Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4722 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaBKKXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 05:23:08 -0500
Message-ID: <52F9F934.9090202@xs4all.nl>
Date: Tue, 11 Feb 2014 11:19:32 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 35/47] adv7604: Add sink pads
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-36-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-36-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/14 17:42, Laurent Pinchart wrote:
> The ADV7604 has sink pads for its HDMI and analog inputs. Report them.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/adv7604.c | 71 ++++++++++++++++++++++++++++-----------------
>  include/media/adv7604.h     | 14 ---------
>  2 files changed, 45 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 05e7e1a..da32ce9 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -97,13 +97,25 @@ struct adv7604_chip_info {
>   *
>   **********************************************************************
>   */
> +enum adv7604_pad {
> +	ADV7604_PAD_HDMI_PORT_A = 0,
> +	ADV7604_PAD_HDMI_PORT_B = 1,
> +	ADV7604_PAD_HDMI_PORT_C = 2,
> +	ADV7604_PAD_HDMI_PORT_D = 3,
> +	ADV7604_PAD_VGA_RGB = 4,
> +	ADV7604_PAD_VGA_COMP = 5,
> +	/* The source pad is either 1 (ADV7611) or 6 (ADV7604) */

How about making this explicit:

	ADV7604_PAD_SOURCE = 6,
	ADV7611_PAD_SOURCE = 1,

> +	ADV7604_PAD_MAX = 7,
> +};

Wouldn't it make more sense to have this in the header? I would really
like to use the symbolic names for these pads in my bridge driver.

Regards,

	Hans

> +
>  struct adv7604_state {
>  	const struct adv7604_chip_info *info;
>  	struct adv7604_platform_data pdata;
>  	struct v4l2_subdev sd;
> -	struct media_pad pad;
> +	struct media_pad pads[ADV7604_PAD_MAX];
> +	unsigned int source_pad;
>  	struct v4l2_ctrl_handler hdl;
> -	enum adv7604_input_port selected_input;
> +	enum adv7604_pad selected_input;
>  	struct v4l2_dv_timings timings;
>  	struct {
>  		u8 edid[256];
> @@ -775,18 +787,18 @@ static inline bool is_analog_input(struct v4l2_subdev *sd)
>  {
>  	struct adv7604_state *state = to_state(sd);
>  
> -	return state->selected_input == ADV7604_INPUT_VGA_RGB ||
> -	       state->selected_input == ADV7604_INPUT_VGA_COMP;
> +	return state->selected_input == ADV7604_PAD_VGA_RGB ||
> +	       state->selected_input == ADV7604_PAD_VGA_COMP;
>  }
>  
>  static inline bool is_digital_input(struct v4l2_subdev *sd)
>  {
>  	struct adv7604_state *state = to_state(sd);
>  
> -	return state->selected_input == ADV7604_INPUT_HDMI_PORT_A ||
> -	       state->selected_input == ADV7604_INPUT_HDMI_PORT_B ||
> -	       state->selected_input == ADV7604_INPUT_HDMI_PORT_C ||
> -	       state->selected_input == ADV7604_INPUT_HDMI_PORT_D;
> +	return state->selected_input == ADV7604_PAD_HDMI_PORT_A ||
> +	       state->selected_input == ADV7604_PAD_HDMI_PORT_B ||
> +	       state->selected_input == ADV7604_PAD_HDMI_PORT_C ||
> +	       state->selected_input == ADV7604_PAD_HDMI_PORT_D;
>  }
>  
>  /* ----------------------------------------------------------------------- */
> @@ -1066,14 +1078,14 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
>  
>  	switch (state->rgb_quantization_range) {
>  	case V4L2_DV_RGB_RANGE_AUTO:
> -		if (state->selected_input == ADV7604_INPUT_VGA_RGB) {
> +		if (state->selected_input == ADV7604_PAD_VGA_RGB) {
>  			/* Receiving analog RGB signal
>  			 * Set RGB full range (0-255) */
>  			io_write_and_or(sd, 0x02, 0x0f, 0x10);
>  			break;
>  		}
>  
> -		if (state->selected_input == ADV7604_INPUT_VGA_COMP) {
> +		if (state->selected_input == ADV7604_PAD_VGA_COMP) {
>  			/* Receiving analog YPbPr signal
>  			 * Set automode */
>  			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
> @@ -1106,7 +1118,7 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
>  		}
>  		break;
>  	case V4L2_DV_RGB_RANGE_LIMITED:
> -		if (state->selected_input == ADV7604_INPUT_VGA_COMP) {
> +		if (state->selected_input == ADV7604_PAD_VGA_COMP) {
>  			/* YCrCb limited range (16-235) */
>  			io_write_and_or(sd, 0x02, 0x0f, 0x20);
>  			break;
> @@ -1117,7 +1129,7 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
>  
>  		break;
>  	case V4L2_DV_RGB_RANGE_FULL:
> -		if (state->selected_input == ADV7604_INPUT_VGA_COMP) {
> +		if (state->selected_input == ADV7604_PAD_VGA_COMP) {
>  			/* YCrCb full range (0-255) */
>  			io_write_and_or(sd, 0x02, 0x0f, 0x60);
>  			break;
> @@ -1806,7 +1818,7 @@ static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
>  	struct adv7604_state *state = to_state(sd);
>  	u8 *data = NULL;
>  
> -	if (edid->pad > ADV7604_EDID_PORT_D)
> +	if (edid->pad > ADV7604_PAD_HDMI_PORT_D)
>  		return -EINVAL;
>  	if (edid->blocks == 0)
>  		return -EINVAL;
> @@ -1823,10 +1835,10 @@ static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
>  		edid->blocks = state->edid.blocks;
>  
>  	switch (edid->pad) {
> -	case ADV7604_EDID_PORT_A:
> -	case ADV7604_EDID_PORT_B:
> -	case ADV7604_EDID_PORT_C:
> -	case ADV7604_EDID_PORT_D:
> +	case ADV7604_PAD_HDMI_PORT_A:
> +	case ADV7604_PAD_HDMI_PORT_B:
> +	case ADV7604_PAD_HDMI_PORT_C:
> +	case ADV7604_PAD_HDMI_PORT_D:
>  		if (state->edid.present & (1 << edid->pad))
>  			data = state->edid.edid;
>  		break;
> @@ -1880,7 +1892,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
>  	int err;
>  	int i;
>  
> -	if (edid->pad > ADV7604_EDID_PORT_D)
> +	if (edid->pad > ADV7604_PAD_HDMI_PORT_D)
>  		return -EINVAL;
>  	if (edid->start_block != 0)
>  		return -EINVAL;
> @@ -1921,19 +1933,19 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
>  		spa_loc = 0xc0; /* Default value [REF_02, p. 116] */
>  
>  	switch (edid->pad) {
> -	case ADV7604_EDID_PORT_A:
> +	case ADV7604_PAD_HDMI_PORT_A:
>  		state->spa_port_a[0] = edid->edid[spa_loc];
>  		state->spa_port_a[1] = edid->edid[spa_loc + 1];
>  		break;
> -	case ADV7604_EDID_PORT_B:
> +	case ADV7604_PAD_HDMI_PORT_B:
>  		rep_write(sd, 0x70, edid->edid[spa_loc]);
>  		rep_write(sd, 0x71, edid->edid[spa_loc + 1]);
>  		break;
> -	case ADV7604_EDID_PORT_C:
> +	case ADV7604_PAD_HDMI_PORT_C:
>  		rep_write(sd, 0x72, edid->edid[spa_loc]);
>  		rep_write(sd, 0x73, edid->edid[spa_loc + 1]);
>  		break;
> -	case ADV7604_EDID_PORT_D:
> +	case ADV7604_PAD_HDMI_PORT_D:
>  		rep_write(sd, 0x74, edid->edid[spa_loc]);
>  		rep_write(sd, 0x75, edid->edid[spa_loc + 1]);
>  		break;
> @@ -2433,7 +2445,7 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
>  	[ADV7604] = {
>  		.type = ADV7604,
>  		.has_afe = true,
> -		.max_port = ADV7604_INPUT_VGA_COMP,
> +		.max_port = ADV7604_PAD_VGA_COMP,
>  		.num_dv_ports = 4,
>  		.edid_enable_reg = 0x77,
>  		.edid_status_reg = 0x7d,
> @@ -2464,7 +2476,7 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
>  	[ADV7611] = {
>  		.type = ADV7611,
>  		.has_afe = false,
> -		.max_port = ADV7604_INPUT_HDMI_PORT_A,
> +		.max_port = ADV7604_PAD_HDMI_PORT_A,
>  		.num_dv_ports = 1,
>  		.edid_enable_reg = 0x74,
>  		.edid_status_reg = 0x76,
> @@ -2498,6 +2510,7 @@ static int adv7604_probe(struct i2c_client *client,
>  	struct adv7604_platform_data *pdata = client->dev.platform_data;
>  	struct v4l2_ctrl_handler *hdl;
>  	struct v4l2_subdev *sd;
> +	unsigned int i;
>  	u16 val;
>  	int err;
>  
> @@ -2643,8 +2656,14 @@ static int adv7604_probe(struct i2c_client *client,
>  	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
>  			adv7604_delayed_work_enable_hotplug);
>  
> -	state->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	err = media_entity_init(&sd->entity, 1, &state->pad, 0);
> +	state->source_pad = state->info->num_dv_ports
> +			  + (state->info->has_afe ? 2 : 0);
> +	for (i = 0; i < state->source_pad; ++i)
> +		state->pads[i].flags = MEDIA_PAD_FL_SINK;
> +	state->pads[state->source_pad].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	err = media_entity_init(&sd->entity, state->source_pad + 1,
> +				state->pads, 0);
>  	if (err)
>  		goto err_work_queues;
>  
> diff --git a/include/media/adv7604.h b/include/media/adv7604.h
> index b2500bae..22811d3 100644
> --- a/include/media/adv7604.h
> +++ b/include/media/adv7604.h
> @@ -155,20 +155,6 @@ struct adv7604_platform_data {
>  	u8 i2c_vdp;
>  };
>  
> -enum adv7604_input_port {
> -	ADV7604_INPUT_HDMI_PORT_A,
> -	ADV7604_INPUT_HDMI_PORT_B,
> -	ADV7604_INPUT_HDMI_PORT_C,
> -	ADV7604_INPUT_HDMI_PORT_D,
> -	ADV7604_INPUT_VGA_RGB,
> -	ADV7604_INPUT_VGA_COMP,
> -};
> -
> -#define ADV7604_EDID_PORT_A 0
> -#define ADV7604_EDID_PORT_B 1
> -#define ADV7604_EDID_PORT_C 2
> -#define ADV7604_EDID_PORT_D 3
> -
>  #define V4L2_CID_ADV_RX_ANALOG_SAMPLING_PHASE	(V4L2_CID_DV_CLASS_BASE + 0x1000)
>  #define V4L2_CID_ADV_RX_FREE_RUN_COLOR_MANUAL	(V4L2_CID_DV_CLASS_BASE + 0x1001)
>  #define V4L2_CID_ADV_RX_FREE_RUN_COLOR		(V4L2_CID_DV_CLASS_BASE + 0x1002)
> 

