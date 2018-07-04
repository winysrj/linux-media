Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:34503 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752277AbeGDOiN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 10:38:13 -0400
Date: Wed, 4 Jul 2018 16:38:08 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH 3/5] media: ov5640: fix wrong binning value in exposure
 calculation
Message-ID: <20180704143808.GC1240@w540>
References: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
 <1530709123-12445-4-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <1530709123-12445-4-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hugues,

On Wed, Jul 04, 2018 at 02:58:41PM +0200, Hugues Fruchet wrote:
> ov5640_set_mode_exposure_calc() is checking binning value but
> binning value read is buggy and binning value set is done
> after calling ov5640_set_mode_exposure_calc(), fix all of this.

The ov5640_binning_on() function was indeed wrong (side note: that
name is confusing, it should be 0v5640_get_binning() to comply with
others..) and always returned 0, but I don't see a fix here for the
second part of the issue. In facts, during the lenghty exposure
calculation process, binning is checked to decide if the preview
shutter time should be doubled or not

static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
					 const struct ov5640_mode_info *mode)
{
        ...

	/* read preview shutter */
	ret = ov5640_get_exposure(sensor);
	if (ret < 0)
		return ret;
	prev_shutter = ret;
	ret = ov5640_binning_on(sensor);
	if (ret < 0)
		return ret;
	if (ret && mode->id != OV5640_MODE_720P_1280_720 &&
	    mode->id != OV5640_MODE_1080P_1920_1080)
		prev_shutter *= 2;
        ...
}

My understanding is that reading the value from the register returns
the binning settings for the previously configured mode, while the
binning value is later updated for the current mode in
ov5640_set_mode(), after 'ov5640_set_mode_exposure_calc()' has already
been called. Is this ok?

Also, I assume the code checks for mode->id to figure out if the mode
uses subsampling or scaling. Be aware that for 1280x720 mode, the
selected scaling mode depends on the FPS, not only on the mode id as
it is assumed here.

A final note, the 'ov5640_set_mode_exposure_calc()' also writes VTS to
update the shutter time to the newly calculated value.

	/* write capture shutter */
	if (cap_shutter > (cap_vts - 4)) {
		cap_vts = cap_shutter + 4;
		ret = ov5640_set_vts(sensor, cap_vts);
		if (ret < 0)
			return ret;
	}

Be aware again that VTS is later restored to the mode->vtot value by
the 'ov5640_set_timings()' functions, which again, is called later
than 'ov5640_set_mode_exposure_calc()'.

Wouldn't it be better to postpone exposure calculation after timings
and binnings have been set?

Thanks
   j

>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/ov5640.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 7c569de..f9b256e 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -1357,8 +1357,8 @@ static int ov5640_binning_on(struct ov5640_dev *sensor)
>  	ret = ov5640_read_reg(sensor, OV5640_REG_TIMING_TC_REG21, &temp);
>  	if (ret)
>  		return ret;
> -	temp &= 0xfe;
> -	return temp ? 1 : 0;
> +
> +	return temp & BIT(0);
>  }
>
>  static int ov5640_set_binning(struct ov5640_dev *sensor, bool enable)
> --
> 1.9.1
>

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbPNvQAAoJEHI0Bo8WoVY8M7YP/1mFDJLthUFZKNgK6U4Kh07P
LSGuBK369ESBY5sbW4TotHsGDLhRS5mXwWvYUoYPHW+BZo5Zqwl2LuxOOqQzu3eB
96aCzr28R7TfSNPccr3odRxO24K78cdFF8mcDuNLHE/8oKaVAxTH8wf84wCrGecZ
pJJXqgSwzfCe4v/lZrXdPEJcpt6+d1unBJqxd0B14xwq7WYwYKNww4Xi7ySqleMu
Y98eHLAT3bIEsBgPlp2KEV+EQx0vMAAU2vbQLQmo1MBNkYLnVF7T0vhkVtUp8M9l
FHZtJikHy8qB9YUUyNvyRsHl6FwgThZxft7WYVvQGxit18GMnKIljlZNy6EkwZgY
0rAQDLMFdYOJzgxW9Rz/kDZIJ7BG8j6Xr0dFdGF5WogZ0Ut7tYY9syRd/6uLLRTV
CF+rtJt1xpazFZZGzq8bmieWHjf7S0MtP+1FDctqYEWUt3dmXeROSBjbSpYjtH89
qn5C3YA59uoQfdAjP0NUunLnNlreFHJOu3cvxUlS1gQH1WBZwoZkA3WS+zZKk3Ol
RvjunSIjdpFG9vW87XNeiMpXbMP8008jjhKo7sdbvR7kRvesLCqjuPfW5B3cGto2
3Le9YFtR3Zj/DA+hMqXvFsTMFyfHwUN9AvoVOhsVCjmaWaJkitC2b80I2ffU8Pvx
taAsrEvaMHjPyRroWCkU
=6IQn
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
