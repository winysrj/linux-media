Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48384 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752956AbcLRWBL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Dec 2016 17:01:11 -0500
Date: Mon, 19 Dec 2016 00:01:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161218220105.GS16630@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161214130310.GA15405@pali>
 <20161214201202.GB28424@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214201202.GB28424@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Wed, Dec 14, 2016 at 09:12:02PM +0100, Pavel Machek wrote:
> Hi!
> 
> > On Wednesday 14 December 2016 13:24:51 Pavel Machek wrote:
> > >  
> > > Add driver for et8ek8 sensor, found in Nokia N900 main camera. Can be
> > > used for taking photos in 2.5MP resolution with fcam-dev.
> > > 
> > > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > 
> > > ---
> > > From v4 I did cleanups to coding style and removed various oddities.
> > > 
> > > Exposure value is now in native units, which simplifies the code.
> > > 
> > > The patch to add device tree bindings was already acked by device tree
> > > people.
> 
> > > +	default:
> > > +		WARN_ONCE(1, ET8EK8_NAME ": %s: invalid message length.\n",
> > > +			  __func__);
> > 
> > dev_warn_once()
> ...
> > > +	if (WARN_ONCE(cnt > ET8EK8_MAX_MSG,
> > > +		      ET8EK8_NAME ": %s: too many messages.\n", __func__)) {
> > 
> > Maybe replace it with dev_warn_once() too? That condition in WARN_ONCE
> > does not look nice...
> ...
> > > +			if (WARN(next->type != ET8EK8_REG_8BIT &&
> > > +				 next->type != ET8EK8_REG_16BIT,
> > > +				 "Invalid type = %d", next->type)) {
> > dev_warn()
> >
> > > +	WARN_ON(sensor->power_count < 0);
> > 
> > Rather some dev_warn()? Do we need stack trace here?
> 
> I don't see what is wrong with WARN(). These are not expected to
> trigger, if they do we'll fix it. If you feel strongly about this,
> feel free to suggest a patch.

I think WARN() is good. It's a driver bug and it deserves to be notified.

> 
> > > +static int et8ek8_i2c_reglist_find_write(struct i2c_client *client,
> > > +					 struct et8ek8_meta_reglist *meta,
> > > +					 u16 type)
> > > +{
> > > +	struct et8ek8_reglist *reglist;
> > > +
> > > +	reglist = et8ek8_reglist_find_type(meta, type);
> > > +	if (!reglist)
> > > +		return -EINVAL;
> > > +
> > > +	return et8ek8_i2c_write_regs(client, reglist->regs);
> > > +}
> > > +
> > > +static struct et8ek8_reglist **et8ek8_reglist_first(
> > > +		struct et8ek8_meta_reglist *meta)
> > > +{
> > > +	return &meta->reglist[0].ptr;
> > > +}
> > 
> > Above code looks like re-implementation of linked-list. Does not kernel
> > already provide some?
> 
> Its actually array of pointers as far as I can tell. I don't think any
> helpers would be useful here.
> 
> > > +	new = et8ek8_gain_table[gain];
> > > +
> > > +	/* FIXME: optimise I2C writes! */
> > 
> > Is this FIMXE still valid?
> 
> Probably. Lets optimize it after merge.

I guess it's been like this since 2008 or so. I guess the comment could be
simply removed, it's not a real problem.

> 
> > > +	if (sensor->power_count) {
> > > +		WARN_ON(1);
> > 
> > Such warning is probably not useful...
> 
> It should not happen, AFAICT. That's why I'd like to know if it does.
> 
> > > +#include "et8ek8_reg.h"
> > > +
> > > +/*
> > > + * Stingray sensor mode settings for Scooby
> > > + */
> > 
> > Are settings for this sensor Stingray enough?
> 
> Seems to work well enough for me. If more modes are needed, we can add
> them later.

AFAIR the module is called Stingray.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
