Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:56027 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752582AbeGDP4M (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 11:56:12 -0400
Date: Wed, 4 Jul 2018 17:56:03 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH 3/5] media: ov5640: fix wrong binning value in exposure
 calculation
Message-ID: <20180704155603.GD1240@w540>
References: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
 <1530709123-12445-4-git-send-email-hugues.fruchet@st.com>
 <20180704143808.GC1240@w540>
 <0ea27226-3aa5-0ce9-ad35-9d2019c71169@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Content-Disposition: inline
In-Reply-To: <0ea27226-3aa5-0ce9-ad35-9d2019c71169@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hugues,

On Wed, Jul 04, 2018 at 03:29:56PM +0000, Hugues FRUCHET wrote:
> Hi Jacopo,
>
> Many thanks for you valuable comments, I hardly understand this exposure
> code, and still some wrongly exposed images are observed switching from
> subsampling to scaling modes.

Thank you for the patches...

Just out of curiosity, have you ever been able to get images in 1280x720
and 1920x1080 mode? I assume so if you're able to switch between two
subsampling modes...

> Steve, do you have more insight to share with us on this code ?
>
> On 07/04/2018 04:38 PM, jacopo mondi wrote:
> > Hi Hugues,
> >
> > On Wed, Jul 04, 2018 at 02:58:41PM +0200, Hugues Fruchet wrote:
> >> ov5640_set_mode_exposure_calc() is checking binning value but
> >> binning value read is buggy and binning value set is done
> >> after calling ov5640_set_mode_exposure_calc(), fix all of this.
> >
> > The ov5640_binning_on() function was indeed wrong (side note: that
> > name is confusing, it should be 0v5640_get_binning() to comply with
> > others..) and always returned 0, but I don't see a fix here for the
> > second part of the issue.
> Mistake from me here, I should have removed "and binning value set is
> done after calling ov5640_set_mode_exposure_calc()" in commit message.
>
> > In facts, during the lenghty exposure
> > calculation process, binning is checked to decide if the preview
> > shutter time should be doubled or not
> >
> > static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
> > 					 const struct ov5640_mode_info *mode)
> > {
> >          ...
> >
> > 	/* read preview shutter */
> > 	ret = ov5640_get_exposure(sensor);
> > 	if (ret < 0)
> > 		return ret;
> > 	prev_shutter = ret;
> > 	ret = ov5640_binning_on(sensor);
> > 	if (ret < 0)
> > 		return ret;
> > 	if (ret && mode->id != OV5640_MODE_720P_1280_720 &&
> > 	    mode->id != OV5640_MODE_1080P_1920_1080)
> > 		prev_shutter *= 2;
> >          ...
> > }
> >
> > My understanding is that reading the value from the register returns
> > the binning settings for the previously configured mode, while the > binning value is later updated for the current mode in
> > ov5640_set_mode(), after 'ov5640_set_mode_exposure_calc()' has already
> > been called. Is this ok?
>
> This is also my understanding.
>

Thanks. This is probably worth fixing. Maybe your exposure issues
depend on this..

> >
> > Also, I assume the code checks for mode->id to figure out if the mode
> > uses subsampling or scaling. Be aware that for 1280x720 mode, the
> > selected scaling mode depends on the FPS, not only on the mode id as
> > it is assumed here.
>
> This is not what I understand from this array:
> static const struct ov5640_mode_info
> ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
> [15fps]
> 		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
> 		 1280, 1892, 720, 740,
> 		 ov5640_setting_15fps_720P_1280_720,
> 		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
> [30fps]
> 		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
> 		 1280, 1892, 720, 740,
> 		 ov5640_setting_30fps_720P_1280_720,
> 		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
>
> => both modes uses subsampling here

You are right, I counted the array entries and 30FPS has a -1
specified as downsizing mode in the last one, so I overlooked it, sorry!

So what is mode->id checked for, if 720p and 1080p modes use different
downsizing modes? Confused ....

>
> >
> > A final note, the 'ov5640_set_mode_exposure_calc()' also writes VTS to
> > update the shutter time to the newly calculated value.
> >
> > 	/* write capture shutter */
> > 	if (cap_shutter > (cap_vts - 4)) {
> > 		cap_vts = cap_shutter + 4;
> > 		ret = ov5640_set_vts(sensor, cap_vts);
> > 		if (ret < 0)
> > 			return ret;
> > 	}
> >
> > Be aware again that VTS is later restored to the mode->vtot value by
> > the 'ov5640_set_timings()' functions, which again, is called later
> > than 'ov5640_set_mode_exposure_calc()'.
> >
> > Wouldn't it be better to postpone exposure calculation after timings
> > and binnings have been set ?
>
> As said, I'm new on all of this but I can give it a try.

Thanks, I also see banding filter being calculated twice, and I'm sure
there are some other things I'm missing. That exposure calculation
procedure seems poorly integrated with the rest of the set_mode()
function :/

Thanks
   j
>
> >
> > Thanks
> >     j
> >
> >>
> >> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> >> ---
> >>   drivers/media/i2c/ov5640.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> >> index 7c569de..f9b256e 100644
> >> --- a/drivers/media/i2c/ov5640.c
> >> +++ b/drivers/media/i2c/ov5640.c
> >> @@ -1357,8 +1357,8 @@ static int ov5640_binning_on(struct ov5640_dev *sensor)
> >>   	ret = ov5640_read_reg(sensor, OV5640_REG_TIMING_TC_REG21, &temp);
> >>   	if (ret)
> >>   		return ret;
> >> -	temp &= 0xfe;
> >> -	return temp ? 1 : 0;
> >> +
> >> +	return temp & BIT(0);
> >>   }
> >>
> >>   static int ov5640_set_binning(struct ov5640_dev *sensor, bool enable)
> >> --
> >> 1.9.1
> >>
>
> Best regards,
> Hugues.

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbPO4TAAoJEHI0Bo8WoVY8gM4QAJZlE5kiODmB5iog0NUuAFI7
OkIfY1QsOhSv58jN42N3v1gtgi52Xqxo0eUG6or9mfYR9OmbIG4cAhtAUk0yQcJK
n2XT3BEryaVt7mic+9atscV24DTvT7wttzGarOJM9lQXSUKY7WVqyuGAIPqaSpGe
6evthcZtVZ0VD31uwAt5yWA02s78IjggvfoStWzOnSn5V+cqZiilJz4uElKV3qI3
5Q6x+cXJtCycHu+YJsTK/J5C7cDH9jc+BHhT+qhWtU7D6ged3Pt5zQOEXUAEOkef
Xcn0DE8U28zfF2bdYekdTBOk6gmRlesaZuYAVg69vlexfOkVa7WTuSCgpWtafXFR
XyqNQ8p0IilN8NgukUxM84e5XaKIka6mdU0pukJYxgd/2FTO5xaibWeypn04KoW6
tLVUBmYugj/+N+J0jj7IOT9ZWyAg9F8SqknfaTTt/sNT3GCNfgsF1WxNM+4J454t
pPPpjuGrVjikqy7K+9ozhagIkCMpsvrAnmiiG6ah0XmCc5FtK1L9qA9XwB6quoOW
riBbiOHIgW8XHVkQTVO1c9uDBFLTc5NGTERSnq7h19QAEqh4FLBJRkXkhLt0niZs
YPsanAWj/zlmqlCyAh8vnm/R65CBNCGGJjioybxsUl7a/9HZBVByNRORi4KxbRvd
KH8ZrcOGQxwekw/IWx8U
=KSLu
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
