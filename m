Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:53177 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbeHPWxc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 18:53:32 -0400
Date: Thu, 16 Aug 2018 21:53:00 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v2 5/5] media: ov5640: fix restore of last mode set
Message-ID: <20180816195300.GB30122@w540>
References: <1534155586-26974-1-git-send-email-hugues.fruchet@st.com>
 <1534155586-26974-6-git-send-email-hugues.fruchet@st.com>
 <20180816101023.GA19047@w540>
 <3ad25a94-3de0-1a9a-ff02-30d3d282b363@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <3ad25a94-3de0-1a9a-ff02-30d3d282b363@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hugues,

On Thu, Aug 16, 2018 at 03:07:54PM +0000, Hugues FRUCHET wrote:
> Hi Jacopo,
>
> On 08/16/2018 12:10 PM, jacopo mondi wrote:
> > Hi Hugues,
> >      thanks for the patch
> >
> > On Mon, Aug 13, 2018 at 12:19:46PM +0200, Hugues Fruchet wrote:
> >> Mode setting depends on last mode set, in particular
> >> because of exposure calculation when downscale mode
> >> change between subsampling and scaling.
> >> At stream on the last mode was wrongly set to current mode,
> >> so no change was detected and exposure calculation
> >> was not made, fix this.
> >
> > I actually see a different issue here...
>
> Which problem do you have exactly, you got a VGA JPEG instead of a QVGA
> YUYV ?
>

Not a matter of image format but sizes. I printed out the format
applied and it seems to me it was always the initial one.
On a second thought, a pipeline with a mis-configuration would not
have ever started streaming, so I should have investigated better.

> >
> > The issue I see here depends on the format programmed through
> > set_fmt() never being applied when using the sensor with a media
> > controller equipped device (in this case an i.MX6 board) through
> > capture sessions, and the not properly calculated exposure you see may
> > be a consequence of this.
> >
> > I'll try to write down what I see, with the help of some debug output.
> >
> > - At probe time mode 640x460@30 is programmed:
> >    [    1.651216] ov5640_probe: Initial mode with id: 2
> >
> > - I set the format on the sensor's pad and it gets not applied but
> >    marked as pending as the sensor is powered off:
> >
> >    #media-ctl --set-v4l2 "'ov5640 2-003c':0[fmt:UYVY2X8/320x240 field:none]"
> >     [   65.611983] ov5640_set_fmt: NEW mode with id: 1 - PENDING
>
> So here sensor->current_mode is set to <1>;//QVGA
> and sensor->pending_mode_change is set to true;
>
> >
> > - I start streaming with yavta, and the sensor receives a power on;
> >    this causes the 'initial' format to be re-programmed and the pending
> >    change to be ignored:
> >
> >    #yavta -c10 -n4 -f YUYV -s $320x240  -F"../frame-#.yuv" /dev/video4
> >     [   69.395018] ov5640_set_power:1805 - on
> >     [   69.431342] ov5640_restore_mode:1711
> >     [   69.996882] ov5640_set_mode: Apply mode with id: 0
> >
> >    The 'ov5640_set_mode()' call from 'ov5640_restore_mode()' clears the
> >    sensor->pending flag, discarding the newly requested format, for
> >    this reason, at s_stream() time, the pending flag is not set
> >    anymore.
>
> OK but before clearing sensor->pending_mode_change, set_mode() is
> loading registers corresponding to sensor->current_mode:
> static int ov5640_set_mode(struct ov5640_dev *sensor,
> 			   const struct ov5640_mode_info *orig_mode)
> {
> ==>	const struct ov5640_mode_info *mode = sensor->current_mode;
> ...
> 	ret = ov5640_set_mode_direct(sensor, mode, exposure);
>
> => so mode <1> is expected to be set now, so I don't understand your trace:
> ">     [   69.996882] ov5640_set_mode: Apply mode with id: 0"
> Which variable do you trace that shows "0" ?
>
>
> >
> > Are you using a media-controller system? I suspect in non-mc cases,
> > the set_fmt is applied through a single power_on/power_off session, not
> > causing the 'restore_mode()' issue. Is this the case for you or your
> > issue is differnt?
> >
> > Edit:
> > Mita-san tried to address the issue of the output pixel format not
> > being restored when the image format was restored in
> > 19ad26f9e6e1 ("media: ov5640: add missing output pixel format setting")
> >
> > I understand the issue he tried to fix, but shouldn't the pending
> > format (if any) be applied instead of the initial one unconditionally?
>
> This is what does the ov5640_restore_mode(), set the current mode
> (sensor->current_mode), that is done through this line:
> 	/* now restore the last capture mode */
> 	ret = ov5640_set_mode(sensor, &ov5640_mode_init_data);
> => note that the comment above is weird, in fact it is the "current"
> mode that is set.
> => note also that the 2nd parameter is not the mode to be set but the
> previously applied mode ! (ie loaded in ov5640 registers). This is used
> to decide if we have to go to the "set_mode_exposure_calc" or
> "set_mode_direct".

This is where I got lost... Sorry for the sloppy comment, now I get
what your patch was for :)


>
> the ov5640_restore_mode() also set the current pixel format
> (sensor->fmt), that is done through this line:
> 	return ov5640_set_framefmt(sensor, &sensor->fmt);
> ==> This is what have fixed Mita-san, this line was missing previously,
> leading to "mode registers" being loaded but not the "pixel format
> registers".
>
>
> PS: There are two other "set mode" related changes that are related to this:
> 1) 6949d864776e ("media: ov5640: do not change mode if format or frame
> interval is unchanged")
> => this is merged in media master, unfortunately I've introduced a
> regression on "pixel format" side that I've fixed in this patchset :
> 2) https://www.mail-archive.com/linux-media@vger.kernel.org/msg134413.html
> Symptom was a noisy image when capturing QVGA YUV (in fact captured as
> JPEG data).

I see, thanks for the detailed explanation!

Thanks
   j

>
>
> Best regards,
> Hugues.
>
> >
> > Thanks
> >     j
> >
> >>
> >> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> >> ---
> >>   drivers/media/i2c/ov5640.c | 8 +++++++-
> >>   1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> >> index c110a6a..923cc30 100644
> >> --- a/drivers/media/i2c/ov5640.c
> >> +++ b/drivers/media/i2c/ov5640.c
> >> @@ -225,6 +225,7 @@ struct ov5640_dev {
> >>   	struct v4l2_mbus_framefmt fmt;
> >>
> >>   	const struct ov5640_mode_info *current_mode;
> >> +	const struct ov5640_mode_info *last_mode;
> >>   	enum ov5640_frame_rate current_fr;
> >>   	struct v4l2_fract frame_interval;
> >>
> >> @@ -1628,6 +1629,9 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
> >>   	bool auto_exp =  sensor->ctrls.auto_exp->val == V4L2_EXPOSURE_AUTO;
> >>   	int ret;
> >>
> >> +	if (!orig_mode)
> >> +		orig_mode = mode;
> >> +
> >>   	dn_mode = mode->dn_mode;
> >>   	orig_dn_mode = orig_mode->dn_mode;
> >>
> >> @@ -1688,6 +1692,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
> >>   		return ret;
> >>
> >>   	sensor->pending_mode_change = false;
> >> +	sensor->last_mode = mode;
> >>
> >>   	return 0;
> >>
> >> @@ -2551,7 +2556,8 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
> >>
> >>   	if (sensor->streaming == !enable) {
> >>   		if (enable && sensor->pending_mode_change) {
> >> -			ret = ov5640_set_mode(sensor, sensor->current_mode);
> >> +			ret = ov5640_set_mode(sensor, sensor->last_mode);
> >> +
> >>   			if (ret)
> >>   				goto out;
> >>
> >> --
> >> 2.7.4
> >>

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbddYcAAoJEHI0Bo8WoVY8kpoQALi52RHKN6F4mB2eOkrZ8bWg
sIdOo11F37ROTmFWYWtyuhSX/UxA37pLnzBgleumGjtTS5gYdLl6McsH5PDwqz0s
/G/sIIvMjVwmHGt5+w+ysf7erolXU5ljip2NXjbmjT3QvkScEK0cG+acNTeV5VTA
paIL2TpXOMS7lfkpqK0cKpYHIqx2IyaAuDju5T7j4BYd+tR04dMNeysuCzPhufWW
rKuZgodrt76sds0kIXK8SuoFpLboGAe3SK/6q6D7MgiOFSfK3yDPiI5xfw2uHPIU
4vLJduoyS25fijW2wuEmeduMveafpqN8CfkiCYXtvby6cfcCLOZaQlIYHRle7uyQ
FD5F+n1JvOjhZ4zc/9mxGPm1n5ZmLQW8fd3/9B15ABP3bR/cjtgvzuIrFelJSugD
syZ6tOFN6f45gJX72S2Oh1xpOI7Y4Y8XgXgdhb7ukf8hJOoriEyB8onf/J416ewc
yNVZgqWaTVI4pfd0YSxTy0YiiWVgK+TWF+BkEsExgAUGU+uRaRmDtVfN3SVrRl4m
oxO9VDvsIYDlb4EfAg+dzBi2Nk0eek2Mwuv4yXNH2muUEmA7WkbdJHD0Qz86Kt7t
dsv7XAz3yfCGQPXbhWJXyf+0O5VevJ2mVADzZ/8I+5IK6cbaVqh/1E/Yq28mqOi2
UkBBSQ2rtsrz/G61/oGa
=fuaL
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
