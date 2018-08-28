Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:60705 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbeH1Qst (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 12:48:49 -0400
Date: Tue, 28 Aug 2018 14:57:11 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH] media: ov5640: fix mode change regression
Message-ID: <20180828125711.GE3566@w540>
References: <1534412813-10406-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="//IivP0gvsAy3Can"
Content-Disposition: inline
In-Reply-To: <1534412813-10406-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--//IivP0gvsAy3Can
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hugues,
   thanks for the patch

On Thu, Aug 16, 2018 at 11:46:53AM +0200, Hugues Fruchet wrote:
> fixes: 6949d864776e ("media: ov5640: do not change mode if format or frame interval is unchanged").
>
> Symptom was fuzzy image because of JPEG default format
> not being changed according to new format selected, fix this.
> Init sequence initialises format to YUV422 UYVY but
> sensor->fmt initial value was set to JPEG, fix this.
>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/ov5640.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 071f4bc..2ddd86d 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -223,6 +223,7 @@ struct ov5640_dev {
>  	int power_count;
>
>  	struct v4l2_mbus_framefmt fmt;
> +	bool pending_fmt_change;

The foundamental issue here is that 'struct ov5640_mode_info' and
associated functions do not take the image format into account...
That would be the real fix, but I understand it requires changing and
re-testing a lot of stuff :(

But what if instead of adding more flags, don't we use bitfields in a single
"pending_changes" field? As when, and if, framerate will be made more
'dynamic' and we remove the static 15/30FPS configuration from
ov5640_mode_info, we will have the same problem we have today with
format with framerate too...

Something like:

struct ov5640_dev {
        ...
-       bool pending_mode_change;
+       #define MODE_CHANGE     BIT(0)
+       #define FMT_CHANGE      BIT(1)
+       u8 pending;
        ...
}

>
>  	const struct ov5640_mode_info *current_mode;
>  	enum ov5640_frame_rate current_fr;
> @@ -255,7 +256,7 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
>   * should be identified and removed to speed register load time
>   * over i2c.
>   */
> -
> +/* YUV422 UYVY VGA@30fps */
>  static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
>  	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
>  	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
> @@ -1968,9 +1969,12 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
>
>  	if (new_mode != sensor->current_mode) {
>  		sensor->current_mode = new_mode;
> -		sensor->fmt = *mbus_fmt;
>  		sensor->pending_mode_change = true;
>  	}
> +	if (mbus_fmt->code != sensor->fmt.code) {
> +		sensor->fmt = *mbus_fmt;
> +		sensor->pending_fmt_change = true;
> +	}

That would make this simpler

  		sensor->current_mode = new_mode;
		sensor->fmt = *mbus_fmt;

                if (new_mode != sensor->current_mode)
                        sensor->pending |= MODE_CHANGE;
	        if (mbus_fmt->code != sensor->fmt.code) {
                        sensor->pending |= FMT_CHANGE;


>  out:
>  	mutex_unlock(&sensor->lock);
>  	return ret;
> @@ -2544,10 +2548,13 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
>  			ret = ov5640_set_mode(sensor, sensor->current_mode);
>  			if (ret)
>  				goto out;
> +		}
>
> +		if (enable && sensor->pending_fmt_change) {
>  			ret = ov5640_set_framefmt(sensor, &sensor->fmt);
>  			if (ret)
>  				goto out;
> +			sensor->pending_fmt_change = false;
>  		}
>

And that would be accordingly:

                if (sensor->pending & MODE_CHANGE) {
                       ret = ov5640_set_mode(sensor, sensor->current_mode);
                       ....
                }
                if (sensor->pending & FMT_CHANGE) {
                       ret = ov5640_set_framefmt(sensor, &sensor->fmt);
                       ...
                }

What do you (and others) think?

Thanks
   j

>  		if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
> @@ -2642,9 +2649,14 @@ static int ov5640_probe(struct i2c_client *client,
>  		return -ENOMEM;
>
>  	sensor->i2c_client = client;
> +
> +	/*
> +	 * default init sequence initialize sensor to
> +	 * YUV422 UYVY VGA@30fps
> +	 */
>  	fmt = &sensor->fmt;
> -	fmt->code = ov5640_formats[0].code;
> -	fmt->colorspace = ov5640_formats[0].colorspace;
> +	fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
> +	fmt->colorspace = V4L2_COLORSPACE_SRGB;
>  	fmt->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(fmt->colorspace);
>  	fmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
>  	fmt->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(fmt->colorspace);
> @@ -2656,7 +2668,6 @@ static int ov5640_probe(struct i2c_client *client,
>  	sensor->current_fr = OV5640_30_FPS;
>  	sensor->current_mode =
>  		&ov5640_mode_data[OV5640_30_FPS][OV5640_MODE_VGA_640_480];
> -	sensor->pending_mode_change = true;
>
>  	sensor->ae_target = 52;
>
> --
> 2.7.4
>

--//IivP0gvsAy3Can
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbhUanAAoJEHI0Bo8WoVY8I0EP/0mUPbPYAEcBFkYEAYH9uxFl
sPyJPxTAgPgLT2PE2aICC6bRnBTv/3yP1VmJ3JInIWebZ8/M9fNIW2JW/ZBGLP1O
qlS4Eu5BFo0IjT9bhvlyFVbaYaY7uj/sVuTf5bhIASK/+q09UOCjLPSVe4QulpIs
WroDYAEvL3hNaoMD+WIryl4iEZo8c7lNIBCqssZHl2+Gk143nNtwJ95D2RAyNMWn
imwgte8nUfsctxHN5DsP0j0K9BPme2JmCkyy8noiDIl7gvQMam2n7FsMWmOVFWXF
vz4fziK6NRbp/eZC975Ezx9KWPGwxDZgHGIiOv/Vp5RUm3p1UsxlYl/9N+KctcuM
s0/LlkJEroiRYtHB4Wz1PgJ/4pUaxxCp47s3gOrgGYzoHBXdxqcPKtb33gKESH2G
pSqTKSWCb3jaIa4amWG76QrfXeFD0LzzxLjRC+iuzDEZRqqdX/OGfkym6VSdK1E4
hwvLKI+FwqBRrNlApDQZusAxRO0m764n3CMug4bL8H/o6iGQWHcbyU86yR+WSS+W
rRnHpaz18A02T7N/3u6FhYeuJrLHpLp/VfHJbJuJnek21hiAqOtP/C3CTyxrRoJX
tiQWZMLYYEi4ZnOgVa6TSaMD+zpsGZgcimMOiJnN/TGi/gVElVwVW3APesx+4BA/
iR7QSytsoTkE6j+r/jAm
=i5Ep
-----END PGP SIGNATURE-----

--//IivP0gvsAy3Can--
