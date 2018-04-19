Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34864 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbeDSKgb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 06:36:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 01/12] media: ov5640: Add auto-focus feature
Date: Thu, 19 Apr 2018 13:36:39 +0300
Message-ID: <1761345.E0v0rRdO8P@avalon>
In-Reply-To: <20180416123701.15901-2-maxime.ripard@bootlin.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com> <20180416123701.15901-2-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thank you for the patch.

On Monday, 16 April 2018 15:36:50 EEST Maxime Ripard wrote:
> From: Myl=E8ne Josserand <mylene.josserand@bootlin.com>
>=20
> Add the auto-focus ENABLE/DISABLE feature as V4L2 control.
> Disabled by default.
>=20
> Signed-off-by: Myl=E8ne Josserand <mylene.josserand@bootlin.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/media/i2c/ov5640.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 852026baa2e7..a33e45f8e2b0 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -82,8 +82,9 @@
>  #define OV5640_REG_POLARITY_CTRL00	0x4740
>  #define OV5640_REG_MIPI_CTRL00		0x4800
>  #define OV5640_REG_DEBUG_MODE		0x4814
> -#define OV5640_REG_ISP_FORMAT_MUX_CTRL	0x501f
> +#define OV5640_REG_ISP_CTRL03		0x5003
>  #define OV5640_REG_PRE_ISP_TEST_SET1	0x503d
> +#define OV5640_REG_ISP_FORMAT_MUX_CTRL	0x501f
>  #define OV5640_REG_SDE_CTRL0		0x5580
>  #define OV5640_REG_SDE_CTRL1		0x5581
>  #define OV5640_REG_SDE_CTRL3		0x5583
> @@ -186,6 +187,7 @@ struct ov5640_ctrls {
>  		struct v4l2_ctrl *auto_gain;
>  		struct v4l2_ctrl *gain;
>  	};
> +	struct v4l2_ctrl *auto_focus;
>  	struct v4l2_ctrl *brightness;
>  	struct v4l2_ctrl *saturation;
>  	struct v4l2_ctrl *contrast;
> @@ -2155,6 +2157,12 @@ static int ov5640_set_ctrl_test_pattern(struct
> ov5640_dev *sensor, int value) 0xa4, value ? 0xa4 : 0);
>  }
>=20
> +static int ov5640_set_ctrl_focus(struct ov5640_dev *sensor, int value)
> +{
> +	return ov5640_mod_reg(sensor, OV5640_REG_ISP_CTRL03,
> +			      BIT(1), value ? BIT(1) : 0);

According to the datasheet, bit 1 in register 0x5003 is "Draw window for AF=
C=20
enable". The draw window module is further documented as being "used to=20
display a window on top of live video. It is usually used by autofocus to=20
display a focus window". Are you sure the bit controls the autofocus itself=
 ?

=46urthermore, do all 0V5640 camera modules include a VCM ?

> +}
> +
>  static int ov5640_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct v4l2_subdev *sd =3D ctrl_to_sd(ctrl);
> @@ -2223,6 +2231,9 @@ static int ov5640_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_TEST_PATTERN:
>  		ret =3D ov5640_set_ctrl_test_pattern(sensor, ctrl->val);
>  		break;
> +	case V4L2_CID_FOCUS_AUTO:
> +		ret =3D ov5640_set_ctrl_focus(sensor, ctrl->val);
> +		break;
>  	default:
>  		ret =3D -EINVAL;
>  		break;
> @@ -2285,6 +2296,9 @@ static int ov5640_init_controls(struct ov5640_dev
> *sensor) ARRAY_SIZE(test_pattern_menu) - 1,
>  					     0, 0, test_pattern_menu);
>=20
> +	ctrls->auto_focus =3D v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_AUTO,
> +					      0, 1, 1, 0);
> +
>  	if (hdl->error) {
>  		ret =3D hdl->error;
>  		goto free_ctrls;

=2D-=20
Regards,

Laurent Pinchart
