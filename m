Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:42413 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390516AbeHPNID (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 09:08:03 -0400
Date: Thu, 16 Aug 2018 12:10:23 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hugues Fruchet <hugues.fruchet@st.com>, akinobu.mita@gmail.com
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v2 5/5] media: ov5640: fix restore of last mode set
Message-ID: <20180816101023.GA19047@w540>
References: <1534155586-26974-1-git-send-email-hugues.fruchet@st.com>
 <1534155586-26974-6-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <1534155586-26974-6-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hugues,
    thanks for the patch

On Mon, Aug 13, 2018 at 12:19:46PM +0200, Hugues Fruchet wrote:
> Mode setting depends on last mode set, in particular
> because of exposure calculation when downscale mode
> change between subsampling and scaling.
> At stream on the last mode was wrongly set to current mode,
> so no change was detected and exposure calculation
> was not made, fix this.

I actually see a different issue here...

The issue I see here depends on the format programmed through
set_fmt() never being applied when using the sensor with a media
controller equipped device (in this case an i.MX6 board) through
capture sessions, and the not properly calculated exposure you see may
be a consequence of this.

I'll try to write down what I see, with the help of some debug output.

- At probe time mode 640x460@30 is programmed:
  [    1.651216] ov5640_probe: Initial mode with id: 2

- I set the format on the sensor's pad and it gets not applied but
  marked as pending as the sensor is powered off:

  #media-ctl --set-v4l2 "'ov5640 2-003c':0[fmt:UYVY2X8/320x240 field:none]"
   [   65.611983] ov5640_set_fmt: NEW mode with id: 1 - PENDING

- I start streaming with yavta, and the sensor receives a power on;
  this causes the 'initial' format to be re-programmed and the pending
  change to be ignored:

  #yavta -c10 -n4 -f YUYV -s $320x240  -F"../frame-#.yuv" /dev/video4
   [   69.395018] ov5640_set_power:1805 - on
   [   69.431342] ov5640_restore_mode:1711
   [   69.996882] ov5640_set_mode: Apply mode with id: 0

  The 'ov5640_set_mode()' call from 'ov5640_restore_mode()' clears the
  sensor->pending flag, discarding the newly requested format, for
  this reason, at s_stream() time, the pending flag is not set
  anymore.

Are you using a media-controller system? I suspect in non-mc cases,
the set_fmt is applied through a single power_on/power_off session, not
causing the 'restore_mode()' issue. Is this the case for you or your
issue is differnt?

Edit:
Mita-san tried to address the issue of the output pixel format not
being restored when the image format was restored in
19ad26f9e6e1 ("media: ov5640: add missing output pixel format setting")

I understand the issue he tried to fix, but shouldn't the pending
format (if any) be applied instead of the initial one unconditionally?

Thanks
   j

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

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbdU1+AAoJEHI0Bo8WoVY8Q54P/jV0VA4F8ketYrrSiBVBfzqy
tEJeiy9AWUZHhj8igviRdKIUv4fJCH2Cme0Lowk2xMzdE6VKvTvbnsfLOZW0M0as
ocCZz9lonfONi4OUMYHsdx6dJVk+feNuI165FLPKVDuRBJEh2HvZ2GqOaw19zSCV
RcsuCqkna0CF08RtE8ZRZgXiQlyq0VcqEXbOgOxt3cG1aGrO7WzWyQFWB+h0pmD7
Axgf31WYQ0ES+yJig2edxbVGWdmSzhEr8W/07uekPN0fgH/fbfWe4t9Tfmq6S3n/
D98m/t2u6SGtE8ifewdx8tAzO6TffLlYQxc0HCwyYv3DYb2EoanR7d1AgoeDqEFL
G+zCdMiAtuhJQeTGerJqPF+A//cLhcScqtXebNKIqWpaBwIwHLHsLWLezzD2il6H
40DKsRBjCeIA99F2PtYSrMJeYrH/y+86AL9DWfpP8KupPAP0PCMrvo7+QgU7rkFg
QUd2W04pvvVXcT20xlEO9dd57SVXTucX45cLaRopVEOSgYtw8Hlnz55kNwBxjIoH
W8+JnMofOwvCia9FMdy4xt2KkCNkGE0KzlMxoS5+vTFjq2giOib8pKYsC0AuvUGy
EnefBF+trFUqOS/IpQcOMYf/Oif9b1pdlqIj3OSifdOSiBybPHsmP80LhDNHQIMf
4+juYgNu3FYOTlTNQl0G
=ffbh
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
