Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:52219 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbeJJSTq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 14:19:46 -0400
Date: Wed, 10 Oct 2018 12:58:04 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        loic.poulain@linaro.org, slongerbeam@gmail.com, daniel@zonque.org,
        maxime.ripard@bootlin.com
Subject: Re: [PATCH 1/4] media: ov5640: fix resolution update
Message-ID: <20181010105804.GD7677@w540>
References: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
 <1539067682-60604-2-git-send-email-sam@elite-embedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="q9KOos5vDmpwPx9o"
Content-Disposition: inline
In-Reply-To: <1539067682-60604-2-git-send-email-sam@elite-embedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--q9KOos5vDmpwPx9o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sam,
   thanks for the patch, I see the same issue you reported, but I
think this patch can be improved.

(expanding the Cc list to all people involved in recent ov5640
developemts, not just for this patch, but for the whole series to look
at. Copying names from another series cover letter, hope it is
complete.)

On Mon, Oct 08, 2018 at 11:47:59PM -0700, Sam Bobrowicz wrote:
> set_fmt was not properly triggering a mode change when
> a new mode was set that happened to have the same format
> as the previous mode (for example, when only changing the
> frame dimensions). Fix this.
>
> Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
> ---
>  drivers/media/i2c/ov5640.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index eaefdb5..5031aab 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -2045,12 +2045,12 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
>  		goto out;
>  	}
>
> -	if (new_mode != sensor->current_mode) {
> +
> +	if (new_mode != sensor->current_mode ||
> +	    mbus_fmt->code != sensor->fmt.code) {
> +		sensor->fmt = *mbus_fmt;
>  		sensor->current_mode = new_mode;
>  		sensor->pending_mode_change = true;
> -	}
> -	if (mbus_fmt->code != sensor->fmt.code) {
> -		sensor->fmt = *mbus_fmt;
>  		sensor->pending_fmt_change = true;
>  	}

How I did reproduce the issue:

# Set 1024x768 on ov5640 without changing the image format
# (default image size at startup is 640x480)
$ media-ctl --set-v4l2 "'ov5640 2-003c':0[fmt:UYVY2X8/1024x768 field:none]"
  sensor->pending_mode_change = true; //verified this flag gets set

# Start streaming, after having configured the whole pipeline to work
# with 1024x768
$  yavta -c10 -n4 -f UYVY -s 1024x768 /dev/video4
   Unable to start streaming: Broken pipe (32).

# Inspect which part of pipeline validation went wrong
# Turns out the sensor->fmt field is not updated, and when get_fmt()
# is called, the old one is returned.
$ media-ctl -e "ov5640 2-003c" -p
  ...
  [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range]
                 ^^^ ^^^

So yes, sensor->fmt is not udapted as it should be when only image
resolution is changed.

Although I still see value in having two separate flags for the
'mode_change' (which in ov5640 lingo is resolution) and 'fmt_change' (which
in ov5640 lingo is the image format), and write their configuration to
registers only when they get actually changed.

For this reasons I would like to propse the following patch which I
have tested by:
1) changing resolution only
2) changing format only
3) change both

What do you and others think?

Thanks
  j

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index eaefdb5..e392b9d 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2020,6 +2020,7 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
        struct ov5640_dev *sensor = to_ov5640_dev(sd);
        const struct ov5640_mode_info *new_mode;
        struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
+       struct v4l2_mbus_framefmt *fmt;
        int ret;

        if (format->pad != 0)
@@ -2037,22 +2038,19 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
        if (ret)
                goto out;

-       if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
-               struct v4l2_mbus_framefmt *fmt =
-                       v4l2_subdev_get_try_format(sd, cfg, 0);
+       if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+               fmt = v4l2_subdev_get_try_format(sd, cfg, 0);
+       else
+               fmt = &sensor->fmt;

-               *fmt = *mbus_fmt;
-               goto out;
-       }
+       *fmt = *mbus_fmt;

        if (new_mode != sensor->current_mode) {
                sensor->current_mode = new_mode;
                sensor->pending_mode_change = true;
        }
-       if (mbus_fmt->code != sensor->fmt.code) {
-               sensor->fmt = *mbus_fmt;
+       if (mbus_fmt->code != sensor->fmt.code)
                sensor->pending_fmt_change = true;
-       }
 out:
        mutex_unlock(&sensor->lock);
        return ret;

>  out:
> --
> 2.7.4
>

--q9KOos5vDmpwPx9o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbvds8AAoJEHI0Bo8WoVY8KuMQAL2U+wSjUqYwT3UyJZd05FYA
xYUpWTCcdUrzYNtkyjz9M2NsFgBj9+D+LXLI4JsV0Zc7bVAwhCz6IhQ5mlWCKV0F
SL2hi1rkZ1W5C9yrl+l4hV9hv92ym7hUW2jHC0DrHf/GQAJpgHBN1SXESYsZq4HQ
8+JwRv5PU2L1Urnp17KOuZm8uscsPcm5tEFIFqfiyuYi3FPjFqSICltd7BnJhq92
N4KAU1uJzh8cJEykyYZUt9KcV6F/u/4bm2PQwkwBaQpX9+kJWElO0UVKpb2RTXDT
c7Cf4yZc8ShAnP/viy3XxwyU1n8v73J/UHwjdb02DVeIC+meliBGv2YfJJgZHBmn
2Oy2qcZCk4JnNhrMN4/i+VXyEc+IMs16lHabPCDupgPs/tVsq5f+vV5Ck0qEMq4K
mCAv2n+0sHT0m5Eqco2YUD3CbDjTXiStyRH3vBO1GRYLsnhAJKm84gFehfFE16fk
3OmwgJP+afM9S3NUr1zZ8V/jZFM6LR7qLnT4DJWfNT1oyvsCan42O/txuMzHD5pn
sCNkrqLa1SjNVCjpM9Y0ejLCBjL2ld7S8t+0cd92ir/3CMVi7fORSBbQifQ66YQO
3+ShN/j2cpmNMgI4IPXeiSOxRs0juuzFop/kHRvI4B1csIVZU4Psx4OCCW9LsCkt
PlDb4BdxWR53McHVZgYx
=uloh
-----END PGP SIGNATURE-----

--q9KOos5vDmpwPx9o--
