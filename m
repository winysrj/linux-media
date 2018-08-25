Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57827 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbeHYScv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Aug 2018 14:32:51 -0400
Date: Sat, 25 Aug 2018 16:53:35 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v2 5/5] media: ov5640: fix restore of last mode set
Message-ID: <20180825145335.GL26480@w540>
References: <1534155586-26974-1-git-send-email-hugues.fruchet@st.com>
 <1534155586-26974-6-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oYAXToTM8kn9Ra/9"
Content-Disposition: inline
In-Reply-To: <1534155586-26974-6-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oYAXToTM8kn9Ra/9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hugues,
 one more comment on this patch..

On Mon, Aug 13, 2018 at 12:19:46PM +0200, Hugues Fruchet wrote:
> Mode setting depends on last mode set, in particular
> because of exposure calculation when downscale mode
> change between subsampling and scaling.
> At stream on the last mode was wrongly set to current mode,
> so no change was detected and exposure calculation
> was not made, fix this.
>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/ov5640.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index c110a6a..923cc30 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -225,6 +225,7 @@ struct ov5640_dev {
>  	struct v4l2_mbus_framefmt fmt;
>
>  	const struct ov5640_mode_info *current_mode;
> +	const struct ov5640_mode_info *last_mode;
>  	enum ov5640_frame_rate current_fr;
>  	struct v4l2_fract frame_interval;
>
> @@ -1628,6 +1629,9 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
>  	bool auto_exp =  sensor->ctrls.auto_exp->val == V4L2_EXPOSURE_AUTO;
>  	int ret;
>
> +	if (!orig_mode)
> +		orig_mode = mode;
> +

Am I wrong or with the introduction of last_mode we could drop the
'orig_mode' parameter (which has confused me already :/ ) from the
set_mode() function?

Just set here 'orig_mode = sensor->last_mode' and make sure last_mode
is intialized properly at probe time...

Or is there some other value in keeping the orig_mode parameter here?

Thanks
   j

>  	dn_mode = mode->dn_mode;
>  	orig_dn_mode = orig_mode->dn_mode;
>
> @@ -1688,6 +1692,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
>  		return ret;
>
>  	sensor->pending_mode_change = false;
> +	sensor->last_mode = mode;
>
>  	return 0;
>
> @@ -2551,7 +2556,8 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
>
>  	if (sensor->streaming == !enable) {
>  		if (enable && sensor->pending_mode_change) {
> -			ret = ov5640_set_mode(sensor, sensor->current_mode);
> +			ret = ov5640_set_mode(sensor, sensor->last_mode);
> +
>  			if (ret)
>  				goto out;
>
> --
> 2.7.4
>

--oYAXToTM8kn9Ra/9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbgW1vAAoJEHI0Bo8WoVY8WHEP/0tFXXVTMaL0AZoSqFD0Dtg6
nLgWU6T3GVnaoVbuQWoU6J9C0PIyfPZ87a6CkKAVBb79xydv+i8RcIhfz+6RKK/h
nwIRrVp2w3+AF8kaNcJvdbm1WweDZqpIqW7E6dC8FmSZH9msi9hyc/KvklhpazGi
0QO2THq/H3PVxpGKYfyxqHCmrvxAMLUkt/I2wmNfnEAZEaGG59vpd0XzWo12km9l
9CxV63sM5gOhcyVNtzMPY3pX26JuVbmZGYLeIy5UF0TR6CLBscPU6ERMfUml2hCB
lACM+JJGM54l3JYlqgNg+NoIJicTFRtaAyWf8GIW28NkzjmrZZWffVObJ4HQyJ0r
Ph3sMzujwbRYX7G6TcnPgd2xU02l4KCNyVZgjdQMZgRk4NGm+LiakS4g+MWVavwP
sWwgS25rdb8w3i8NmXpKvJFWotqY4jrdMnrM0QChB1f9dhghWAb4oFREpoaYoew1
srP5sYmZQDdKQw5R/aOBiKt80K85Q8+iq4D1lhjBO2Uo2U/6sIyoOIhaxd4ArGkk
SR2tfDQFF37FPzOMANINgBFxtVS6Zc+DmEfmicoRndCUw/OJZc8bNwtZG1nSAPI3
z+BCaXsd/dqblhCArvynhBQlTiHhliXvLGpxN5woEy13mSfK90RE4jY82/w57AYX
P6O9WZVIAVXGmF/nFUKE
=uVvx
-----END PGP SIGNATURE-----

--oYAXToTM8kn9Ra/9--
