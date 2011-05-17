Return-path: <mchehab@pedra>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36479 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561Ab1EQXSl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 19:18:41 -0400
Date: Wed, 18 May 2011 00:18:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	beagleboard@googlegroups.com, carlighting@yahoo.co.nz,
	g.liakhovetski@gmx.de, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] mt9p031: Add mt9p031 sensor driver.
Message-ID: <20110517231821.GB5913@n2100.arm.linux.org.uk>
References: <1305624528-5595-1-git-send-email-javier.martin@vista-silicon.com> <1305624528-5595-2-git-send-email-javier.martin@vista-silicon.com> <201105171334.01607.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105171334.01607.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, May 17, 2011 at 01:33:52PM +0200, Laurent Pinchart wrote:
> Hi Javier,
> 
> Thanks for the patch.

Sorry, but this laziness is getting beyond a joke...  And the fact that
apparantly no one is picking up on it other than me is also a joke.

> > +static int mt9p031_power_on(struct mt9p031 *mt9p031)
> > +{
> > +	int ret;
> > +
> > +	if (mt9p031->pdata->set_xclk)
> > +		mt9p031->pdata->set_xclk(&mt9p031->subdev, 54000000);
> > +	/* turn on VDD_IO */
> > +	ret = regulator_enable(mt9p031->reg_2v8);
> > +	if (ret) {
> > +		pr_err("Failed to enable 2.8v regulator: %d\n", ret);
> > +		return -1;

And why all these 'return -1's?  My guess is that this is plain laziness
on the authors part.

> > +static int mt9p031_set_params(struct i2c_client *client,
> > +			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
> 
> set_params should apply the parameters, not change them. They should have 
> already been validated by the callers.
> 
> > +{
...
> > +err:
> > +	return -1;

And again...

> > +}
> > +
> > +static int mt9p031_set_crop(struct v4l2_subdev *sd,
> > +				struct v4l2_subdev_fh *fh,
> > +				struct v4l2_subdev_crop *crop)
> > +{
...

> > +	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> > +		ret = mt9p031_set_params(client, &rect, xskip, yskip);
> > +		if (ret < 0)
> > +			return ret;

So this propagates the lazy 'return -1' all the way back to userspace.
This is utter crap - really it is, and I'm getting sick and tired of
telling people that they should not use 'return -1'.  It's down right
lazy and sloppy programming.

I wish people would stop doing it.  I wish people would review their own
stuff for this _before_ posting it onto a mailing list, so I don't have
to keep complaining about it.  And I wish people reviewing drivers would
also look for this as well and complain about it.

'return -1' is generally a big fat warning sign that the author is doing
something wrong, and should _always_ be investigated and complained about.
