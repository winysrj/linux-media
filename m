Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37635 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751020AbaIZLMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 07:12:05 -0400
Date: Fri, 26 Sep 2014 14:01:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 17/17] smiapp: Decrease link frequency if media bus pixel
 format BPP requires
Message-ID: <20140926110156.GO2939@valkosipuli.retiisi.org.uk>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
 <1410986741-6801-18-git-send-email-sakari.ailus@iki.fi>
 <24769200.DuP3evaK0j@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24769200.DuP3evaK0j@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for your comments.

On Fri, Sep 26, 2014 at 01:44:03PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Wednesday 17 September 2014 23:45:41 Sakari Ailus wrote:
> > Decrease the link frequency to the next lower if the user chooses a media
> > bus code (BPP) cannot be achieved using the selected link frequency.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/i2c/smiapp/smiapp-core.c |   20 ++++++++++++++++++--
> >  1 file changed, 18 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> > b/drivers/media/i2c/smiapp/smiapp-core.c index 537ca92..ce2c34d 100644
> > --- a/drivers/media/i2c/smiapp/smiapp-core.c
> > +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> > @@ -286,11 +286,27 @@ static int smiapp_pll_update(struct smiapp_sensor
> > *sensor)
> > 
> >  	pll->binning_horizontal = sensor->binning_horizontal;
> >  	pll->binning_vertical = sensor->binning_vertical;
> > -	pll->link_freq =
> > -		sensor->link_freq->qmenu_int[sensor->link_freq->val];
> >  	pll->scale_m = sensor->scale_m;
> >  	pll->bits_per_pixel = sensor->csi_format->compressed;
> > 
> > +	if (!test_bit(sensor->link_freq->val,
> > +		      &sensor->valid_link_freqs[
> > +			      sensor->csi_format->compressed
> > +			      - SMIAPP_COMPRESSED_BASE])) {
> > +		/*
> > +		 * Setting the link frequency will perform PLL
> > +		 * re-calculation already, so skip that.
> > +		 */
> > +		return __v4l2_ctrl_s_ctrl(
> > +			sensor->link_freq,
> > +			__ffs(sensor->valid_link_freqs[
> > +				      sensor->csi_format->compressed
> > +				      - SMIAPP_COMPRESSED_BASE]));
> 
> I have an uneasy feeling about this, as smiapp_pll_update is called from the 
> link freq s_ctrl handler. Have you double-checked the recursion bounds ?

We haven't actually done any PLL tree calculation yet here. The condition
will evaluate true in a case when the user chooses a format which isn't
available on a given link frequency, or chooses a link frequency which isn't
available for a given format.

The condition will be false the next time the function is called since we've
just chosen a valid combination of the two.

But now that you brought the topic up, I think the link frequency selection
should just probably return -EBUSY if the selected link frquency cannot be
used. Also __ffs() should be __fls() instead in order to still come up with
the highest link freqency.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
