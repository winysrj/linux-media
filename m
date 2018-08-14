Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42663 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbeHNSdN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 14:33:13 -0400
Date: Tue, 14 Aug 2018 17:45:25 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: "mchehab@kernel.org" <mchehab@kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "sam@elite-embedded.com" <sam@elite-embedded.com>,
        "jagan@amarulasolutions.com" <jagan@amarulasolutions.com>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "pza@pengutronix.de" <pza@pengutronix.de>,
        "steve_longerbeam@mentor.com" <steve_longerbeam@mentor.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "daniel@zonque.org" <daniel@zonque.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] media: ov5640: Fix auto-exposure disabling
Message-ID: <20180814154525.GB16349@w540>
References: <1531912743-24767-1-git-send-email-jacopo@jmondi.org>
 <1531912743-24767-3-git-send-email-jacopo@jmondi.org>
 <20180718130407.GU8180@w540>
 <d7dff287-d02c-38cb-3a73-d0c578cb2758@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <d7dff287-d02c-38cb-3a73-d0c578cb2758@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hugues,

On Tue, Aug 07, 2018 at 08:53:23AM +0000, Hugues FRUCHET wrote:
> Hi Jacopo,
>
> In serie "[PATCH 0/5] Fix OV5640 exposure & gain"
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg133269.html
> I've tried to collect fixes around exposure/gain, not only the exposure
> regression and I would prefer to keep it consistent with the associated
> procedure test.

You're right. Please see my other reply, I mixed two different issues
in this series probably.

> Moreover I dislike the internal use of control framework functions to
> disable/enable exposure/gain, on my opinion this has to be kept simpler
> by just disabling/enabling the right registers.

Why that? I thought changing parameters exposed as controls should go
through the control framework to ensure consistency. Maybe I'm wrong.

> Would it be possible that you test my 5 patches serie on your side ?

I did. I re-based the series on top of my MIPI and timings fixes and
it actually solves the exposure issues I didn't know I had :)

I'll comment on v2 as well as soon as I'll get an answer from Steve on
the CSI-2 issue.

Thanks
   j

>
> Best regards,
> Hugues.
>
> On 07/18/2018 03:04 PM, jacopo mondi wrote:
> > Hi again,
> >
> > On Wed, Jul 18, 2018 at 01:19:03PM +0200, Jacopo Mondi wrote:
> >> As of:
> >> commit bf4a4b518c20 ("media: ov5640: Don't force the auto exposure state at
> >> start time") auto-exposure got disabled before programming new capture modes to
> >> the sensor. Unfortunately the function used to do that (ov5640_set_exposure())
> >> does not enable/disable auto-exposure engine through register 0x3503[0] bit, but
> >> programs registers [0x3500 - 0x3502] which represent the desired exposure time
> >> when running with manual exposure. As a result, auto-exposure was not actually
> >> disabled at all.
> >>
> >> To actually disable auto-exposure, go through the control framework instead of
> >> calling ov5640_set_exposure() function directly.
> >>
> >> Also, as auto-gain and auto-exposure are disabled un-conditionally but only
> >> restored to their previous values in ov5640_set_mode_direct() function, move
> >> controls restoring so that their value is re-programmed opportunely after
> >> either ov5640_set_mode_direct() or ov5640_set_mode_exposure_calc() have been
> >> executed.
> >>
> >> Fixes: bf4a4b518c20 ("media: ov5640: Don't force the auto exposure state at start time")
> >> Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
> >>
> >> ---
> >> Is it worth doing with auto-gain what we're doing with auto-exposure? Cache the
> >> value and then re-program it instead of unconditionally disable/enable it?
> >
> > I have missed this patch from Hugues that address almost the same
> > issue
> > https://www.mail-archive.com/linux-media@vger.kernel.org/msg133264.html
> >
> > I feel this new one is simpler, and unless we want to avoid going
> > through the control framework, it is not worth adding new functions to
> > handle auto-exposure as Hugues' patch is doing.
> >
> > Hugues, do you have comments? Feel free to add your sob or rb tags if
> > you like to.
> >
> > Thanks
> >     j
> >
> >>
> >> Thanks
> >>    j
> >> ---
> >> ---
> >>   drivers/media/i2c/ov5640.c | 29 +++++++++++++----------------
> >>   1 file changed, 13 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> >> index 12b3496..bc75cb7 100644
> >> --- a/drivers/media/i2c/ov5640.c
> >> +++ b/drivers/media/i2c/ov5640.c
> >> @@ -1588,25 +1588,13 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
> >>    * change mode directly
> >>    */
> >>   static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
> >> -				  const struct ov5640_mode_info *mode,
> >> -				  s32 exposure)
> >> +				  const struct ov5640_mode_info *mode)
> >>   {
> >> -	int ret;
> >> -
> >>   	if (!mode->reg_data)
> >>   		return -EINVAL;
> >>
> >>   	/* Write capture setting */
> >> -	ret = ov5640_load_regs(sensor, mode);
> >> -	if (ret < 0)
> >> -		return ret;
> >> -
> >> -	/* turn auto gain/exposure back on for direct mode */
> >> -	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
> >> -	if (ret)
> >> -		return ret;
> >> -
> >> -	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, exposure);
> >> +	return  ov5640_load_regs(sensor, mode);
> >>   }
> >>
> >>   static int ov5640_set_mode(struct ov5640_dev *sensor,
> >> @@ -1626,7 +1614,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
> >>   		return ret;
> >>
> >>   	exposure = sensor->ctrls.auto_exp->val;
> >> -	ret = ov5640_set_exposure(sensor, V4L2_EXPOSURE_MANUAL);
> >> +	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, V4L2_EXPOSURE_MANUAL);
> >>   	if (ret)
> >>   		return ret;
> >>
> >> @@ -1642,12 +1630,21 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
> >>   		 * change inside subsampling or scaling
> >>   		 * download firmware directly
> >>   		 */
> >> -		ret = ov5640_set_mode_direct(sensor, mode, exposure);
> >> +		ret = ov5640_set_mode_direct(sensor, mode);
> >>   	}
> >>
> >>   	if (ret < 0)
> >>   		return ret;
> >>
> >> +	/* Restore auto-gain and auto-exposure after mode has changed. */
> >> +	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, exposure)
> >> +	if (ret)
> >> +		return ret;
> >> +
> >>   	ret = ov5640_set_binning(sensor, dn_mode != SCALING);
> >>   	if (ret < 0)
> >>   		return ret;
> >> --
> >> 2.7.4
> >>

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbcvkVAAoJEHI0Bo8WoVY8kNIP/29wy792MwBosnrNDyO4IH2R
u2if2bnyKiRmmwA7gxrtXcBnaR7CQhbG7qF6+Fl/xANevxV74CWNBO0zbLtLhYxL
QHKj9JeTizcey8RBgNb3cIwAcyIMxWBKlPZbyyLSFS+/IFr6ZSA4uymNw9WU5MXC
CGeLLXPtJ1emHXmPBI3sHBgu7+qnfAfqm3OfQUrDiTEBw4bF2HPOhd1wpTyARWWY
GJwfImX9+zYFfvoLqtlEF5cf+8Z68V/utRtCgIO16Bdb8k8q3SikJXyAmPwK19p2
8n7j3n88zrJz+givHMUgAQtAcHszckUnSQ2bXELz+QlIm3XYsEy7Z4UzowenUp/p
MJxQpg95L+sKHS8beotclmCxo5qpJsn0t2MvU0zDbdLWe+b6AcdjL6EX+dEmLtoc
6JcT4h9jXMjG40TU8sR3NW/chapXY4bz/pcoZN4x0+89BPuguqIJA8Hst5mwwPao
2OvHKkd8dwlIL0YuA142wETQLLmJCpZ94Yw+/kjw+GqP7My1lVngPjEUQR3Qoux1
HQHaxd4nNeGWnKqU681gE0b3CnC7tBKnFSTJXnIOQSGpFUmlui1nLdRKkxGvxU7d
FSGwko/xrT38Sxdk9IFXcfDjwA+sC3hdUDUWsLRXbppHO5VvRd00+R77iUEkoyPo
8dyVA71j/szkiNsxfJ3L
=YLdE
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
