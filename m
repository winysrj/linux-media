Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7115 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932669AbeCMLmU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 07:42:20 -0400
Date: Tue, 13 Mar 2018 13:42:17 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v2 2/2] media: ov2680: Add Omnivision OV2680 sensor driver
Message-ID: <20180313114216.vmqmcrdkfz64aedv@paasikivi.fi.intel.com>
References: <20180228152723.26392-1-rui.silva@linaro.org>
 <20180228152723.26392-3-rui.silva@linaro.org>
 <20180309092153.psb5zcs53brlrrep@paasikivi.fi.intel.com>
 <m3r2ootecu.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3r2ootecu.fsf@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 13, 2018 at 11:16:33AM +0000, Rui Miguel Silva wrote:
...
> > > +static int ov2680_gain_set(struct ov2680_dev *sensor, bool
> > > auto_gain)
> > > +{
> > > +	struct ov2680_ctrls *ctrls = &sensor->ctrls;
> > > +	u32 gain;
> > > +	int ret;
> > > +
> > > +	ret = ov2680_mod_reg(sensor, OV2680_REG_R_MANUAL, BIT(1),
> > > +			     auto_gain ? 0 : BIT(1));
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	if (auto_gain || !ctrls->gain->is_new)
> > > +		return 0;
> > > +
> > > +	gain = ctrls->gain->val;
> > > +
> > > +	ret = ov2680_write_reg16(sensor, OV2680_REG_GAIN_PK, gain);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int ov2680_gain_get(struct ov2680_dev *sensor)
> > > +{
> > > +	u32 gain;
> > > +	int ret;
> > > +
> > > +	ret = ov2680_read_reg16(sensor, OV2680_REG_GAIN_PK, &gain);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	return gain;
> > > +}
> > > +
> > > +static int ov2680_auto_gain_enable(struct ov2680_dev *sensor)
> > > +{
> > > +	return ov2680_gain_set(sensor, true);
> > 
> > Just call ov2780_gain_set() in the caller.
> 
> Here if you do not mind I would like to have it this way, on the caller
> side makes explicit that we are disabling/enabling the auto gain,
> instead of going and search what that bool parameter means.
> 
> but, if you do mind... ;)

How about renaming that function as e.g. ov2680_autogain_set()? That's what
it does, doesn't it?

Right now you have these functions doing nothing really useful, cluttering
up the code.

...

> > > +static const struct i2c_device_id ov2680_id[] = {
> > > +	{"ov2680", 0},
> > > +	{ },
> > 
> > You can remove the i2c_device_id table if you use the probe_new callback
> > (instead of probe) below.
> 
> Well this one was hard to debug, so removing the device id table made
> the module not to be auto loaded, and after some debug I found the root
> cause and it looks it is addressed by this [0]. With that patch removing
> the device_id and use probe_new works as expected.
> 
> I will be sending v3 soon.

Great, thanks!

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
