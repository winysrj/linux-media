Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48806 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaEHMz3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 08:55:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] mt9p031: Really disable Black Level Calibration in test pattern mode
Date: Thu, 08 May 2014 14:55:53 +0200
Message-ID: <1449257.TN64m7kLSp@avalon>
In-Reply-To: <536B43DC.30802@cisco.com>
References: <1399477255-21207-1-git-send-email-laurent.pinchart@ideasonboard.com> <536B43DC.30802@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 08 May 2014 10:44:12 Hans Verkuil wrote:
> Hi Laurent,
> 
> The patch is correct, but I noticed a pre-existing bug that should be
> fixed. See below.
> 
> On 05/07/14 17:40, Laurent Pinchart wrote:
> > The digital side of the Black Level Calibration (BLC) function must be
> > disabled when generating a test pattern to avoid artifacts in the image.
> > The driver disables BLC correctly at the hardware level, but the feature
> > gets reenabled by v4l2_ctrl_handler_setup() the next time the device is
> > powered on.
> > 
> > Fix this by marking the BLC controls as inactive when generating a test
> > pattern, and ignoring control set requests on inactive controls.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/i2c/mt9p031.c | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> > index 33daace..9102b23 100644
> > --- a/drivers/media/i2c/mt9p031.c
> > +++ b/drivers/media/i2c/mt9p031.c
> > @@ -655,6 +655,9 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
> >  	u16 data;
> >  	int ret;
> > 
> > +	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
> > +		return 0;
> > +
> >  	switch (ctrl->id) {
> >  	case V4L2_CID_EXPOSURE:
> >  		ret = mt9p031_write(client, MT9P031_SHUTTER_WIDTH_UPPER,
> > @@ -709,8 +712,16 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
> >  					MT9P031_READ_MODE_2_ROW_MIR, 0);
> >  	
> >  	case V4L2_CID_TEST_PATTERN:
> > +		/* The digital side of the Black Level Calibration function must
> > +		 * be disabled when generating a test pattern to avoid artifacts
> > +		 * in the image. Activate (deactivate) the BLC-related controls
> > +		 * when the test pattern is enabled (disabled).
> > +		 */
> > +		v4l2_ctrl_activate(mt9p031->blc_auto, ctrl->val == 0);
> > +		v4l2_ctrl_activate(mt9p031->blc_offset, ctrl->val == 0);
> > +
> >  		if (!ctrl->val) {
> > -			/* Restore the black level compensation settings. */
> > +			/* Restore the BLC settings. */
> >  			if (mt9p031->blc_auto->cur.val != 0) {
> >  				ret = mt9p031_s_ctrl(mt9p031->blc_auto);
> 
> This doesn't do what you expect. What you want is to set the blc_auto
> control to the current value, but mt9p031_s_ctrl(mt9p031->blc_auto) will
> set it to the *new* value, which may not be the same. Ditto for doing the
> same for blc_offset.
> 
> It's best to just call mt9p031_write directly, rather than going through
> mt9p031_s_ctrl.

Thanks for catching the problem. I'll fix that in a follow-up patch.

> >  				if (ret < 0)
> > 
> > @@ -735,9 +746,7 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
> >  		if (ret < 0)
> >  			return ret;
> > 
> > -		/* Disable digital black level compensation when using a test
> > -		 * pattern.
> > -		 */
> > +		/* Disable digital BLC when generating a test pattern. */
> >  		ret = mt9p031_set_mode2(mt9p031, MT9P031_READ_MODE_2_ROW_BLC,
> >  					0);
> >  		if (ret < 0)

-- 
Regards,

Laurent Pinchart

