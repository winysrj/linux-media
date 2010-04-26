Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:6043 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab0DZPxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 11:53:52 -0400
Received: by fg-out-1718.google.com with SMTP id d23so2607047fga.1
        for <linux-media@vger.kernel.org>; Mon, 26 Apr 2010 08:53:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <023ccb019586ffff0282505abb5cb2c20f194fc4.1272267137.git.hverkuil@xs4all.nl>
References: <cover.1272267136.git.hverkuil@xs4all.nl>
	 <023ccb019586ffff0282505abb5cb2c20f194fc4.1272267137.git.hverkuil@xs4all.nl>
Date: Mon, 26 Apr 2010 11:53:44 -0400
Message-ID: <w2g30353c3d1004260853n2ab69475pa00ae57aa4e5bb41@mail.gmail.com>
Subject: Re: [PATCH 05/15] [RFC] saa7115: convert to the new control framework
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 26, 2010 at 3:33 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/saa7115.c |  180 ++++++++++++++++++-----------------------
>  1 files changed, 80 insertions(+), 100 deletions(-)
>
> diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
> index 72eaa66..8db056f 100644
> --- a/drivers/media/video/saa7115.c
> +++ b/drivers/media/video/saa7115.c
> @@ -45,6 +45,7 @@
>  #include <linux/i2c.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-i2c-drv.h>
>  #include <media/saa7115.h>
> @@ -65,16 +66,17 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
>
>  struct saa711x_state {
>        struct v4l2_subdev sd;
> +       struct v4l2_ctrl_handler hdl;
> +
> +       /* chroma gain control cluster */
> +       struct v4l2_ctrl *agc;
> +       struct v4l2_ctrl *gain;
> +
>        v4l2_std_id std;
>        int input;
>        int output;
>        int enable;
>        int radio;
> -       int bright;
> -       int contrast;
> -       int hue;
> -       int sat;
> -       int chroma_agc;
>        int width;
>        int height;
>        u32 ident;
> @@ -90,6 +92,11 @@ static inline struct saa711x_state *to_state(struct v4l2_subdev *sd)
>        return container_of(sd, struct saa711x_state, sd);
>  }
>
> +static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
> +{
> +       return &container_of(ctrl->handler, struct saa711x_state, hdl)->sd;
> +}
> +
>  /* ----------------------------------------------------------------------- */
>
>  static inline int saa711x_write(struct v4l2_subdev *sd, u8 reg, u8 value)
> @@ -741,96 +748,53 @@ static int saa711x_s_clock_freq(struct v4l2_subdev *sd, u32 freq)
>        return 0;
>  }
>
> -static int saa711x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +static int saa711x_g_ctrl(struct v4l2_ctrl *ctrl)
>  {
> +       struct v4l2_subdev *sd = to_sd(ctrl);
>        struct saa711x_state *state = to_state(sd);
> -       u8 val;
>
>        switch (ctrl->id) {
> -       case V4L2_CID_BRIGHTNESS:
> -               if (ctrl->value < 0 || ctrl->value > 255) {
> -                       v4l2_err(sd, "invalid brightness setting %d\n", ctrl->value);
> -                       return -ERANGE;
> -               }
> -
> -               state->bright = ctrl->value;
> -               saa711x_write(sd, R_0A_LUMA_BRIGHT_CNTL, state->bright);
> -               break;
> -
> -       case V4L2_CID_CONTRAST:
> -               if (ctrl->value < 0 || ctrl->value > 127) {
> -                       v4l2_err(sd, "invalid contrast setting %d\n", ctrl->value);
> -                       return -ERANGE;
> -               }
> -
> -               state->contrast = ctrl->value;
> -               saa711x_write(sd, R_0B_LUMA_CONTRAST_CNTL, state->contrast);
> -               break;
> -
> -       case V4L2_CID_SATURATION:
> -               if (ctrl->value < 0 || ctrl->value > 127) {
> -                       v4l2_err(sd, "invalid saturation setting %d\n", ctrl->value);
> -                       return -ERANGE;
> -               }
> -
> -               state->sat = ctrl->value;
> -               saa711x_write(sd, R_0C_CHROMA_SAT_CNTL, state->sat);
> -               break;
> -
> -       case V4L2_CID_HUE:
> -               if (ctrl->value < -128 || ctrl->value > 127) {
> -                       v4l2_err(sd, "invalid hue setting %d\n", ctrl->value);
> -                       return -ERANGE;
> -               }
> -
> -               state->hue = ctrl->value;
> -               saa711x_write(sd, R_0D_CHROMA_HUE_CNTL, state->hue);
> -               break;
>        case V4L2_CID_CHROMA_AGC:
> -               val = saa711x_read(sd, R_0F_CHROMA_GAIN_CNTL);
> -               state->chroma_agc = ctrl->value;
> -               if (ctrl->value)
> -                       val &= 0x7f;
> -               else
> -                       val |= 0x80;
> -               saa711x_write(sd, R_0F_CHROMA_GAIN_CNTL, val);
> +               /* chroma gain cluster */
> +               if (state->agc->cur.val)
> +                       state->gain->cur.val =
> +                               saa711x_read(sd, R_0F_CHROMA_GAIN_CNTL) & 0x7f;
>                break;
> -       case V4L2_CID_CHROMA_GAIN:
> -               /* Chroma gain cannot be set when AGC is enabled */
> -               if (state->chroma_agc == 1)
> -                       return -EINVAL;
> -               saa711x_write(sd, R_0F_CHROMA_GAIN_CNTL, ctrl->value | 0x80);
> -               break;
> -       default:
> -               return -EINVAL;
>        }
> -
>        return 0;
>  }
>
> -static int saa711x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +static int saa711x_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> +       struct v4l2_subdev *sd = to_sd(ctrl);
>        struct saa711x_state *state = to_state(sd);
>
>        switch (ctrl->id) {
>        case V4L2_CID_BRIGHTNESS:
> -               ctrl->value = state->bright;
> +               saa711x_write(sd, R_0A_LUMA_BRIGHT_CNTL, ctrl->val);
>                break;
> +
>        case V4L2_CID_CONTRAST:
> -               ctrl->value = state->contrast;
> +               saa711x_write(sd, R_0B_LUMA_CONTRAST_CNTL, ctrl->val);
>                break;
> +
>        case V4L2_CID_SATURATION:
> -               ctrl->value = state->sat;
> +               saa711x_write(sd, R_0C_CHROMA_SAT_CNTL, ctrl->val);
>                break;
> +
>        case V4L2_CID_HUE:
> -               ctrl->value = state->hue;
> +               saa711x_write(sd, R_0D_CHROMA_HUE_CNTL, ctrl->val);
>                break;
> +
>        case V4L2_CID_CHROMA_AGC:
> -               ctrl->value = state->chroma_agc;
> -               break;
> -       case V4L2_CID_CHROMA_GAIN:
> -               ctrl->value = saa711x_read(sd, R_0F_CHROMA_GAIN_CNTL) & 0x7f;
> +               /* chroma gain cluster */
> +               if (state->agc->val)
> +                       saa711x_write(sd, R_0F_CHROMA_GAIN_CNTL, state->gain->val);
> +               else
> +                       saa711x_write(sd, R_0F_CHROMA_GAIN_CNTL, state->gain->val | 0x80);
> +               v4l2_ctrl_activate(state->gain, !state->agc->val);
>                break;
> +
>        default:
>                return -EINVAL;
>        }

This might not have been done before, but errors from sa71xx_write
should be propagated to caller. A successful write should not be
assumed. This applies for all uses of sa711x_write above. I'd probably
do the following:

1. Declare a local variable called rc initialized to -EINVAL
2. Store the result of sa711x_write into rc for each case.
3. Remove the default case.
4. Return the value of rc.

Regards,

David Ellingsworth

> @@ -1221,25 +1185,6 @@ static int saa711x_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>        return 0;
>  }
>
> -static int saa711x_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
> -{
> -       switch (qc->id) {
> -       case V4L2_CID_BRIGHTNESS:
> -               return v4l2_ctrl_query_fill(qc, 0, 255, 1, 128);
> -       case V4L2_CID_CONTRAST:
> -       case V4L2_CID_SATURATION:
> -               return v4l2_ctrl_query_fill(qc, 0, 127, 1, 64);
> -       case V4L2_CID_HUE:
> -               return v4l2_ctrl_query_fill(qc, -128, 127, 1, 0);
> -       case V4L2_CID_CHROMA_AGC:
> -               return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> -       case V4L2_CID_CHROMA_GAIN:
> -               return v4l2_ctrl_query_fill(qc, 0, 127, 1, 48);
> -       default:
> -               return -EINVAL;
> -       }
> -}
> -
>  static int saa711x_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
>  {
>        struct saa711x_state *state = to_state(sd);
> @@ -1516,17 +1461,27 @@ static int saa711x_log_status(struct v4l2_subdev *sd)
>                break;
>        }
>        v4l2_info(sd, "Width, Height:   %d, %d\n", state->width, state->height);
> +       v4l2_ctrl_handler_log_status(&state->hdl, sd->name);
>        return 0;
>  }
>
>  /* ----------------------------------------------------------------------- */
>
> +static const struct v4l2_ctrl_ops saa711x_ctrl_ops = {
> +       .s_ctrl = saa711x_s_ctrl,
> +       .g_ctrl = saa711x_g_ctrl,
> +};
> +
>  static const struct v4l2_subdev_core_ops saa711x_core_ops = {
>        .log_status = saa711x_log_status,
>        .g_chip_ident = saa711x_g_chip_ident,
> -       .g_ctrl = saa711x_g_ctrl,
> -       .s_ctrl = saa711x_s_ctrl,
> -       .queryctrl = saa711x_queryctrl,
> +       .g_ext_ctrls = v4l2_sd_g_ext_ctrls,
> +       .try_ext_ctrls = v4l2_sd_try_ext_ctrls,
> +       .s_ext_ctrls = v4l2_sd_s_ext_ctrls,
> +       .g_ctrl = v4l2_sd_g_ctrl,
> +       .s_ctrl = v4l2_sd_s_ctrl,
> +       .queryctrl = v4l2_sd_queryctrl,
> +       .querymenu = v4l2_sd_querymenu,
>        .s_std = saa711x_s_std,
>        .reset = saa711x_reset,
>        .s_gpio = saa711x_s_gpio,
> @@ -1571,8 +1526,9 @@ static int saa711x_probe(struct i2c_client *client,
>  {
>        struct saa711x_state *state;
>        struct v4l2_subdev *sd;
> -       int     i;
> -       char    name[17];
> +       struct v4l2_ctrl_handler *hdl;
> +       int i;
> +       char name[17];
>        char chip_id;
>        int autodetect = !id || id->driver_data == 1;
>
> @@ -1611,15 +1567,37 @@ static int saa711x_probe(struct i2c_client *client,
>                return -ENOMEM;
>        sd = &state->sd;
>        v4l2_i2c_subdev_init(sd, client, &saa711x_ops);
> +
> +       hdl = &state->hdl;
> +       v4l2_ctrl_handler_init(hdl, 6);
> +       /* add in ascending ID order */
> +       v4l2_ctrl_new_std(hdl, &saa711x_ctrl_ops,
> +                       V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
> +       v4l2_ctrl_new_std(hdl, &saa711x_ctrl_ops,
> +                       V4L2_CID_CONTRAST, 0, 127, 1, 64);
> +       v4l2_ctrl_new_std(hdl, &saa711x_ctrl_ops,
> +                       V4L2_CID_SATURATION, 0, 127, 1, 64);
> +       v4l2_ctrl_new_std(hdl, &saa711x_ctrl_ops,
> +                       V4L2_CID_HUE, -128, 127, 1, 0);
> +       state->agc = v4l2_ctrl_new_std(hdl, &saa711x_ctrl_ops,
> +                       V4L2_CID_CHROMA_AGC, 0, 1, 1, 1);
> +       state->gain = v4l2_ctrl_new_std(hdl, &saa711x_ctrl_ops,
> +                       V4L2_CID_CHROMA_GAIN, 0, 127, 1, 40);
> +       sd->ctrl_handler = hdl;
> +       if (hdl->error) {
> +               int err = hdl->error;
> +
> +               v4l2_ctrl_handler_free(hdl);
> +               kfree(state);
> +               return err;
> +       }
> +       state->agc->flags |= V4L2_CTRL_FLAG_UPDATE;
> +       v4l2_ctrl_cluster(2, &state->agc);
> +
>        state->input = -1;
>        state->output = SAA7115_IPORT_ON;
>        state->enable = 1;
>        state->radio = 0;
> -       state->bright = 128;
> -       state->contrast = 64;
> -       state->hue = 0;
> -       state->sat = 64;
> -       state->chroma_agc = 1;
>        switch (chip_id) {
>        case '1':
>                state->ident = V4L2_IDENT_SAA7111;
> @@ -1667,6 +1645,7 @@ static int saa711x_probe(struct i2c_client *client,
>        if (state->ident > V4L2_IDENT_SAA7111A)
>                saa711x_writeregs(sd, saa7115_init_misc);
>        saa711x_set_v4lstd(sd, V4L2_STD_NTSC);
> +       v4l2_ctrl_handler_setup(hdl);
>
>        v4l2_dbg(1, debug, sd, "status: (1E) 0x%02x, (1F) 0x%02x\n",
>                saa711x_read(sd, R_1E_STATUS_BYTE_1_VD_DEC),
> @@ -1681,6 +1660,7 @@ static int saa711x_remove(struct i2c_client *client)
>        struct v4l2_subdev *sd = i2c_get_clientdata(client);
>
>        v4l2_device_unregister_subdev(sd);
> +       v4l2_ctrl_handler_free(sd->ctrl_handler);
>        kfree(to_state(sd));
>        return 0;
>  }
> --
> 1.6.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
