Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47250 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbcE0UdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 16:33:14 -0400
Date: Fri, 27 May 2016 22:33:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv4] support for AD5820 camera auto-focus coil
Message-ID: <20160527203311.GA13282@amd>
References: <20160517181927.GA28741@amd>
 <20160521054336.GA27123@amd>
 <573FFF51.1000004@gmail.com>
 <20160521105607.GA20071@amd>
 <574049EF.2090208@gmail.com>
 <20160524090433.GA1277@amd>
 <20160524091746.GA14536@amd>
 <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > + * Contact: Tuukka Toivonen
> > + *          Sakari Ailus
> 
> Could you put the e-mail addresses back, please?
> 
> Tuukka's e-mail is tuukkat76 at gmail.com .

Ok.

> > +#include <linux/module.h>
> > +#include <linux/errno.h>
> > +#include <linux/i2c.h>
> > +#include <linux/kernel.h>
> > +#include <linux/regulator/consumer.h>
> 
> Alphabetical order would be nice. The same below.

I was afraid you'd ask. Ok.

> > +/**
> > + * @brief I2C write using i2c_transfer().
> > + * @param coil - the driver data structure
> > + * @param data - register value to be written
> 
> This does not look entirely right. But you could just remove the entire
> comment. It's useless.

Ok.
> > +	int ret = 0;
> > +
> > +	/*
> > +	 * Go to standby first as real power off my be denied by the hardware
> > +	 * (single power line control for both coil and sensor).
> > +	 */
> > +	if (standby) {
> > +		coil->standby = 1;
> > +		ret = ad5820_update_hw(coil);
> > +	}
> > +
> > +	ret |= regulator_disable(coil->vana);
> 
> This is actually an error code and you shouldn't use or to combine two error
> codes. The result will make no sense.
> 
> It might be the driver did this in the past but it should not be done. The
> right thing, as elsewhere, is to assign the value to ret and check it. The
> assigment in declaration may be dropped as well.

Yeah, its broken. Let me fix it. 

> I think this happens in a few places in the driver.

Actually this was the only place left.


> > +	struct ad5820_device *coil = to_ad5820_device(subdev);
> > +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> > +
> > +	coil->vana = regulator_get(&client->dev, "VANA");
> 
> Is there a reason not to acquire this in probe instead?

Yeah, new version will do that (already done, Dmitry was faster).

> > +	if (IS_ERR(coil->vana)) {
> > +		dev_err(&client->dev, "could not get regulator for vana\n");
> > +		return -ENODEV;
> 
> I wonder if -EPROBE_DEFER might be the right error code here.

..and should handle PROBE_DEFER, too.

> > +static int ad5820_probe(struct i2c_client *client,
> > +			const struct i2c_device_id *devid)
> > +{
> > +	struct ad5820_device *coil;
> > +	int ret = 0;
> 
> No need to assign ret here.

Ok.

> > +
> > +	coil = kzalloc(sizeof(*coil), GFP_KERNEL);
> 
> You could use devm_kzalloc() here and drop kfree() below and in _remove().
> 
> The driver might be actually older than the devm_*() functions. Not sure. At
> least they were not widely used back then. :-)

Already done, Dmitry was faster.

> > +static int __exit ad5820_remove(struct i2c_client *client)
> > +{
> > +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> > +	struct ad5820_device *coil = to_ad5820_device(subdev);
> > +
> > +	v4l2_device_unregister_subdev(&coil->subdev);
> > +	v4l2_ctrl_handler_free(&coil->ctrls);
> > +	media_entity_cleanup(&coil->subdev.entity);
> > +	if (coil->vana)
> > +		regulator_put(coil->vana);
> 
> mutex_destroy(&coil->power_lock);
> 
> Here. And in probe() error paths as well.

Ok. Can do, altrough it is pretty much a NOP in the error paths.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
