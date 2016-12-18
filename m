Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48332 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753716AbcLRV5S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Dec 2016 16:57:18 -0500
Date: Sun, 18 Dec 2016 23:56:41 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161218215641.GR16630@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161213210506.GA11569@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161213210506.GA11569@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, Dec 13, 2016 at 10:05:06PM +0100, Pavel Machek wrote:
> Hi!
> 
> I have finally found the old mail you were refering to. Let me go
> through it.
> 
> > > +/*
> > > + * Convert exposure time `us' to rows. Modify `us' to make it to
> > > + * correspond to the actual exposure time.
> > > + */
> > > +static int et8ek8_exposure_us_to_rows(struct et8ek8_sensor *sensor, u32 *us)
> > 
> > Should a driver do something like this to begin with?
> > 
> > The smiapp driver does use the native unit of exposure (lines) for the
> > control and I think the et8ek8 driver should do so as well.
> > 
> > The HBLANK, VBLANK and PIXEL_RATE controls are used to provide the user with
> > enough information to perform the conversion (if necessary).
> 
> Well... I believe exposure in usec is preffered format for userspace
> to work with (because then it can change resolution and keep camera
> settings) but I see kernel code is quite ugly. Let me see what I can do...

That's not so important IMO --- the granularity may matter and there's no
way you can properly communicate that to the user if you use a non-native
unit.

My preference is the native unit, but considering that you've got an
existing user space application and perhaps even more importantly, it's very
unlikely the device would be used elsewhere.

The smiapp driver uses lines. Up to you.

> 
> > > +	if (ret) {
> > > +		dev_warn(dev, "can't get clock-frequency\n");
> > > +		return ret;
> > > +	}
> > > +
> > > +	mutex_init(&sensor->power_lock);
> > 
> > mutex_destroy() should be called on the mutex if probe fails after this and
> > in remove().
> 
> Ok.
> 
> > > +static int __exit et8ek8_remove(struct i2c_client *client)
> > > +{
> > > +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> > > +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> > > +
> > > +	if (sensor->power_count) {
> > > +		gpiod_set_value(sensor->reset, 0);
> > > +		clk_disable_unprepare(sensor->ext_clk);
> > 
> > How about the regulator? Could you call et8ek8_power_off() instead?
> 
> Hmm. Actually if we hit this, it indicates something funny is going
> on, no? I guess I'll add WARN_ON there...

Yes. A WARN_ON() would be good.

> 
> > > +++ b/drivers/media/i2c/et8ek8/et8ek8_reg.h
> > > @@ -0,0 +1,96 @@
> > > +/*
> > > + * et8ek8.h
> > 
> > et8ek8_reg.h
> 
> Ok.
> 
> Thanks for patience,

Same to you! :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
