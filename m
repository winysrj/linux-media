Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34702 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbeDSJtp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 05:49:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 02/12] media: ov5640: Add light frequency control
Date: Thu, 19 Apr 2018 12:44:18 +0300
Message-ID: <1757295.VWosiQ25QR@avalon>
In-Reply-To: <20180416123701.15901-3-maxime.ripard@bootlin.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com> <20180416123701.15901-3-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thank you for the patch.

On Monday, 16 April 2018 15:36:51 EEST Maxime Ripard wrote:
> From: Myl=E8ne Josserand <mylene.josserand@bootlin.com>
>=20
> Add the light frequency control to be able to set the frequency
> to manual (50Hz or 60Hz) or auto.
>=20
> Signed-off-by: Myl=E8ne Josserand <mylene.josserand@bootlin.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/media/i2c/ov5640.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>=20
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index a33e45f8e2b0..28122341fc35 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -189,6 +189,7 @@ struct ov5640_ctrls {
>  	};
>  	struct v4l2_ctrl *auto_focus;
>  	struct v4l2_ctrl *brightness;
> +	struct v4l2_ctrl *light_freq;
>  	struct v4l2_ctrl *saturation;
>  	struct v4l2_ctrl *contrast;
>  	struct v4l2_ctrl *hue;
> @@ -2163,6 +2164,21 @@ static int ov5640_set_ctrl_focus(struct ov5640_dev
> *sensor, int value) BIT(1), value ? BIT(1) : 0);
>  }
>=20
> +static int ov5640_set_ctl_light_freq(struct ov5640_dev *sensor, int valu=
e)

To stay consistent with the other functions, I propose calling this=20
ov5640_set_ctrl_light_freq().

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +{
> +	int ret;
> +
> +	ret =3D ov5640_mod_reg(sensor, OV5640_REG_HZ5060_CTRL01, BIT(7),
> +			     (value =3D=3D V4L2_CID_POWER_LINE_FREQUENCY_AUTO) ?
> +			     0: BIT(7));
> +	if (ret)
> +		return ret;
> +
> +	return ov5640_mod_reg(sensor, OV5640_REG_HZ5060_CTRL00, BIT(2),
> +			      (value =3D=3D V4L2_CID_POWER_LINE_FREQUENCY_50HZ) ?
> +			      BIT(2): 0);
> +}
> +
>  static int ov5640_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct v4l2_subdev *sd =3D ctrl_to_sd(ctrl);
> @@ -2234,6 +2250,9 @@ static int ov5640_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_FOCUS_AUTO:
>  		ret =3D ov5640_set_ctrl_focus(sensor, ctrl->val);
>  		break;
> +	case V4L2_CID_POWER_LINE_FREQUENCY:
> +		ret =3D ov5640_set_ctl_light_freq(sensor, ctrl->val);
> +		break;
>  	default:
>  		ret =3D -EINVAL;
>  		break;
> @@ -2298,6 +2317,11 @@ static int ov5640_init_controls(struct ov5640_dev
> *sensor)
>=20
>  	ctrls->auto_focus =3D v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_AUTO,
>  					      0, 1, 1, 0);
> +	ctrls->light_freq =3D
> +		v4l2_ctrl_new_std_menu(hdl, ops,
> +				       V4L2_CID_POWER_LINE_FREQUENCY,
> +				       V4L2_CID_POWER_LINE_FREQUENCY_AUTO, 0,
> +				       V4L2_CID_POWER_LINE_FREQUENCY_50HZ);
>=20
>  	if (hdl->error) {
>  		ret =3D hdl->error;

=2D-=20
Regards,

Laurent Pinchart
