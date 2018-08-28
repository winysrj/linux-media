Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48665 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbeH1QvL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 12:51:11 -0400
Date: Tue, 28 Aug 2018 14:59:33 +0200
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
Message-ID: <20180828125933.GF3566@w540>
References: <1534412813-10406-1-git-send-email-hugues.fruchet@st.com>
 <20180828125711.GE3566@w540>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CXFpZVxO6m2Ol4tQ"
Content-Disposition: inline
In-Reply-To: <20180828125711.GE3566@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--CXFpZVxO6m2Ol4tQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Aug 28, 2018 at 02:57:11PM +0200, jacopo mondi wrote:
> Hi Hugues,
>    thanks for the patch
>
> On Thu, Aug 16, 2018 at 11:46:53AM +0200, Hugues Fruchet wrote:
> > fixes: 6949d864776e ("media: ov5640: do not change mode if format or frame interval is unchanged").
> >
> > Symptom was fuzzy image because of JPEG default format
> > not being changed according to new format selected, fix this.
> > Init sequence initialises format to YUV422 UYVY but
> > sensor->fmt initial value was set to JPEG, fix this.
> >
> > Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> > ---
> >  drivers/media/i2c/ov5640.c | 21 ++++++++++++++++-----
> >  1 file changed, 16 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> > index 071f4bc..2ddd86d 100644
> > --- a/drivers/media/i2c/ov5640.c
> > +++ b/drivers/media/i2c/ov5640.c
> > @@ -223,6 +223,7 @@ struct ov5640_dev {
> >  	int power_count;
> >
> >  	struct v4l2_mbus_framefmt fmt;
> > +	bool pending_fmt_change;
>
> The foundamental issue here is that 'struct ov5640_mode_info' and
> associated functions do not take the image format into account...
> That would be the real fix, but I understand it requires changing and
> re-testing a lot of stuff :(
>
> But what if instead of adding more flags, don't we use bitfields in a single
> "pending_changes" field? As when, and if, framerate will be made more
> 'dynamic' and we remove the static 15/30FPS configuration from
> ov5640_mode_info, we will have the same problem we have today with
> format with framerate too...
>
> Something like:
>
> struct ov5640_dev {
>         ...
> -       bool pending_mode_change;
> +       #define MODE_CHANGE     BIT(0)
> +       #define FMT_CHANGE      BIT(1)
> +       u8 pending;
>         ...
> }
>
> >
> >  	const struct ov5640_mode_info *current_mode;
> >  	enum ov5640_frame_rate current_fr;
> > @@ -255,7 +256,7 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
> >   * should be identified and removed to speed register load time
> >   * over i2c.
> >   */
> > -
> > +/* YUV422 UYVY VGA@30fps */
> >  static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
> >  	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
> >  	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
> > @@ -1968,9 +1969,12 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
> >
> >  	if (new_mode != sensor->current_mode) {
> >  		sensor->current_mode = new_mode;
> > -		sensor->fmt = *mbus_fmt;
> >  		sensor->pending_mode_change = true;
> >  	}
> > +	if (mbus_fmt->code != sensor->fmt.code) {
> > +		sensor->fmt = *mbus_fmt;
> > +		sensor->pending_fmt_change = true;
> > +	}
>
> That would make this simpler
>
>   		sensor->current_mode = new_mode;
> 		sensor->fmt = *mbus_fmt;
>
>                 if (new_mode != sensor->current_mode)
>                         sensor->pending |= MODE_CHANGE;
> 	        if (mbus_fmt->code != sensor->fmt.code) {
>                         sensor->pending |= FMT_CHANGE;
>

Yeah, well, this is in wrong order of course :)

--CXFpZVxO6m2Ol4tQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbhUc1AAoJEHI0Bo8WoVY8hF8P/34zhjnlW/UMKlEULc04qwnp
ihpE26malTf6nX4sJvheS2NFRkPF9WsboU5hyWysTd8nAbrGeNUUV+mS2qPWmJP0
bCkvnAoZ/UCsm9v9+4856KNHp6yuEwP1K3Lzkaa4a7+6h1MT/d+PpT6mhLwuYsqk
D+h9H5wnLKeFGigcwJduADt7HVFnR9Lrm76Ul222JiHtFywcfk4qKJ2OJNGfRsIq
EpNbEg/waJ1h5M2u3spwL77WssnGs17QaYz/epqKFN6G6lXOYmzCexVAWY5PBjKh
jXzrl32dPAQlbByRDpukn4m7iZYJOfIMOcMEqG6de8XGjarT39jiXOGqgubgtTvu
ER1r+vp0cv1Wisd4TKmMjSA4RrMJq/BNKpfASHi+76tmuedCL586lwqfuDRDnTgE
+3RqXXqmkxvS9CjMWJSPI4AMaYKaed5zZcOaK3QJXAItp15tcWp+4p9vjEPwfveN
V77GaRICGYkztEl9znzIS3vt4Bw5v+9s4OkCYtSfIEMSVvQTwEW2lREXpUgx4uSB
yKoyNAYqsUOh/FfW0kwMfp1xcrHCfoP9qBXdukwSAA0GD9sWpFagC1UL8o49H0+H
6a+LObcKcJ6JqWBe2yDmfaWebRjkBBHo1vuX63FrF4dohxL3umLR3AeZz6sDO0Q8
kqRupLhS4hrZ8yaQYq0T
=rcXf
-----END PGP SIGNATURE-----

--CXFpZVxO6m2Ol4tQ--
