Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46696 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbeIFVpL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 17:45:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Hugues FRUCHET <hugues.fruchet@st.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
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
Date: Thu, 06 Sep 2018 20:08:50 +0300
Message-ID: <5889322.4cUpKFCJtK@avalon>
In-Reply-To: <20180814154525.GB16349@w540>
References: <1531912743-24767-1-git-send-email-jacopo@jmondi.org> <d7dff287-d02c-38cb-3a73-d0c578cb2758@st.com> <20180814154525.GB16349@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, 14 August 2018 18:45:25 EEST jacopo mondi wrote:
> On Tue, Aug 07, 2018 at 08:53:23AM +0000, Hugues FRUCHET wrote:
> > Hi Jacopo,
> > 
> > In serie "[PATCH 0/5] Fix OV5640 exposure & gain"
> > https://www.mail-archive.com/linux-media@vger.kernel.org/msg133269.html
> > I've tried to collect fixes around exposure/gain, not only the exposure
> > regression and I would prefer to keep it consistent with the associated
> > procedure test.
> 
> You're right. Please see my other reply, I mixed two different issues
> in this series probably.
> 
> > Moreover I dislike the internal use of control framework functions to
> > disable/enable exposure/gain, on my opinion this has to be kept simpler
> > by just disabling/enabling the right registers.
> 
> Why that? I thought changing parameters exposed as controls should go
> through the control framework to ensure consistency. Maybe I'm wrong.

If I understand the driver correctly, auto-exposure has to be disabled 
temporarily when changing format and size, due to internal hardware 
requirements. The sequence should more or less be

 1. Disable auto-exposure
 2. Configure the format and size
 3. Restore auto-exposure

This sequence is internal to the driver, and should thus not be visible to 
userspace. Going through the control framework to disable and restore auto-
exposure would generate control events that would just confuse userspace. For 
that reason I'd keep all this internal with direct register access instead of 
going through the control framework.

> > Would it be possible that you test my 5 patches serie on your side ?
> 
> I did. I re-based the series on top of my MIPI and timings fixes and
> it actually solves the exposure issues I didn't know I had :)
> 
> I'll comment on v2 as well as soon as I'll get an answer from Steve on
> the CSI-2 issue.
> 
> > On 07/18/2018 03:04 PM, jacopo mondi wrote:
> > > Hi again,
> > > 
> > > On Wed, Jul 18, 2018 at 01:19:03PM +0200, Jacopo Mondi wrote:
> > >> As of:
> > >> commit bf4a4b518c20 ("media: ov5640: Don't force the auto exposure
> > >> state at
> > >> start time") auto-exposure got disabled before programming new capture
> > >> modes to the sensor. Unfortunately the function used to do that
> > >> (ov5640_set_exposure()) does not enable/disable auto-exposure engine
> > >> through register 0x3503[0] bit, but programs registers [0x3500 -
> > >> 0x3502] which represent the desired exposure time when running with
> > >> manual exposure. As a result, auto-exposure was not actually disabled
> > >> at all.
> > >> 
> > >> To actually disable auto-exposure, go through the control framework
> > >> instead of calling ov5640_set_exposure() function directly.
> > >> 
> > >> Also, as auto-gain and auto-exposure are disabled un-conditionally but
> > >> only
> > >> restored to their previous values in ov5640_set_mode_direct() function,
> > >> move controls restoring so that their value is re-programmed
> > >> opportunely after either ov5640_set_mode_direct() or
> > >> ov5640_set_mode_exposure_calc() have been executed.
> > >> 
> > >> Fixes: bf4a4b518c20 ("media: ov5640: Don't force the auto exposure
> > >> state at start time") Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
> > >> 
> > >> ---
> > >> Is it worth doing with auto-gain what we're doing with auto-exposure?
> > >> Cache the value and then re-program it instead of unconditionally
> > >> disable/enable it?> > 
> > > I have missed this patch from Hugues that address almost the same
> > > issue
> > > https://www.mail-archive.com/linux-media@vger.kernel.org/msg133264.html
> > > 
> > > I feel this new one is simpler, and unless we want to avoid going
> > > through the control framework, it is not worth adding new functions to
> > > handle auto-exposure as Hugues' patch is doing.
> > > 
> > > Hugues, do you have comments? Feel free to add your sob or rb tags if
> > > you like to.
> > > 
> > > Thanks
> > > 
> > >     j
> > >> 
> > >> Thanks
> > >> 
> > >>    j
> > >> 
> > >> ---
> > >> ---
> > >> 
> > >>   drivers/media/i2c/ov5640.c | 29 +++++++++++++----------------
> > >>   1 file changed, 13 insertions(+), 16 deletions(-)
> > >> 
> > >> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> > >> index 12b3496..bc75cb7 100644
> > >> --- a/drivers/media/i2c/ov5640.c
> > >> +++ b/drivers/media/i2c/ov5640.c
> > >> @@ -1588,25 +1588,13 @@ static int ov5640_set_mode_exposure_calc(struct
> > >> ov5640_dev *sensor,> >> 
> > >>    * change mode directly
> > >>    */
> > >>   
> > >>   static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
> > >> 
> > >> -				  const struct ov5640_mode_info *mode,
> > >> -				  s32 exposure)
> > >> +				  const struct ov5640_mode_info *mode)
> > >> 
> > >>   {
> > >> 
> > >> -	int ret;
> > >> -
> > >> 
> > >>   	if (!mode->reg_data)
> > >>   	
> > >>   		return -EINVAL;
> > >>   	
> > >>   	/* Write capture setting */
> > >> 
> > >> -	ret = ov5640_load_regs(sensor, mode);
> > >> -	if (ret < 0)
> > >> -		return ret;
> > >> -
> > >> -	/* turn auto gain/exposure back on for direct mode */
> > >> -	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
> > >> -	if (ret)
> > >> -		return ret;
> > >> -
> > >> -	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, exposure);
> > >> +	return  ov5640_load_regs(sensor, mode);
> > >> 
> > >>   }
> > >>   
> > >>   static int ov5640_set_mode(struct ov5640_dev *sensor,
> > >> 
> > >> @@ -1626,7 +1614,7 @@ static int ov5640_set_mode(struct ov5640_dev
> > >> *sensor,
> > >> 
> > >>   		return ret;
> > >>   	
> > >>   	exposure = sensor->ctrls.auto_exp->val;
> > >> 
> > >> -	ret = ov5640_set_exposure(sensor, V4L2_EXPOSURE_MANUAL);
> > >> +	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp,
> > >> V4L2_EXPOSURE_MANUAL);
> > >> 
> > >>   	if (ret)
> > >>   	
> > >>   		return ret;
> > >> 
> > >> @@ -1642,12 +1630,21 @@ static int ov5640_set_mode(struct ov5640_dev
> > >> *sensor,> >> 
> > >>   		 * change inside subsampling or scaling
> > >>   		 * download firmware directly
> > >>   		 */
> > >> 
> > >> -		ret = ov5640_set_mode_direct(sensor, mode, exposure);
> > >> +		ret = ov5640_set_mode_direct(sensor, mode);
> > >> 
> > >>   	}
> > >>   	
> > >>   	if (ret < 0)
> > >>   	
> > >>   		return ret;
> > >> 
> > >> +	/* Restore auto-gain and auto-exposure after mode has changed. */
> > >> +	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
> > >> +	if (ret)
> > >> +		return ret;
> > >> +
> > >> +	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, exposure)
> > >> +	if (ret)
> > >> +		return ret;
> > >> +
> > >> 
> > >>   	ret = ov5640_set_binning(sensor, dn_mode != SCALING);
> > >>   	if (ret < 0)
> > >>   	
> > >>   		return ret;
> > >> 
> > >> --
> > >> 2.7.4


-- 
Regards,

Laurent Pinchart
