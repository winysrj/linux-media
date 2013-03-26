Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35242 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3CZXH3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 19:07:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v6 1/7] media: V4L2: add temporary clock helpers
Date: Wed, 27 Mar 2013 00:08:16 +0100
Message-ID: <1598121.fJbo9t3qkg@avalon>
In-Reply-To: <5148355D.5070806@samsung.com>
References: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1303190821470.10482@axis700.grange> <5148355D.5070806@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday 19 March 2013 10:52:29 Sylwester Nawrocki wrote:
> On 03/19/2013 08:32 AM, Guennadi Liakhovetski wrote:
> > On Mon, 18 Mar 2013, Sylwester Nawrocki wrote:
> >> On 03/15/2013 10:27 PM, Guennadi Liakhovetski wrote:
> [...]
> 
> >>> diff --git a/drivers/media/v4l2-core/v4l2-clk.c
> >>> b/drivers/media/v4l2-core/v4l2-clk.c
> >>> new file mode 100644
> >>> index 0000000..3505972
> >>> --- /dev/null
> >>> +++ b/drivers/media/v4l2-core/v4l2-clk.c

[snip]

> >>> +static struct v4l2_clk *v4l2_clk_find(const struct v4l2_subdev *sd,
> >>> +				      const char *dev_id, const char *id)
> >>> +{
> >>> +	struct v4l2_clk *clk;
> >>> +
> >>> +	list_for_each_entry(clk,&clk_list, list) {
> >>> +		if (!sd || !(sd->flags&  V4L2_SUBDEV_FL_IS_I2C)) {
> >>> +			if (strcmp(dev_id, clk->dev_id))
> >>> +				continue;
> >>> +		} else {
> >>> +			char *i2c = strstr(dev_id, clk->dev_id);
> >>> +			if (!i2c || i2c == dev_id || *(i2c - 1) != ' ')
> >>> +				continue;
> >>> +		}
> >>> +
> >>> +		if (!id || !clk->id || !strcmp(clk->id, id))
> >>> +			return clk;
> >>> +	}
> >>> +
> >>> +	return ERR_PTR(-ENODEV);
> >>> +}
> >>> +
> >>> +struct v4l2_clk *v4l2_clk_get(struct v4l2_subdev *sd, const char *id)
> >>> +{
> >>> +	struct v4l2_clk *clk;
> >>> +
> >>> +	mutex_lock(&clk_lock);
> >>> +	clk = v4l2_clk_find(sd, sd->name, id);
> >> 
> >> Couldn't we just pass the I2C client's struct device name to this
> >> function ?
> > 
> > Certainly not. This is a part of the generic V4L2 clock API, it's not I2C
> > specific.
> 
> I have been thinking about something like dev_name(sd->dev), but struct
> v4l2_subdev doesn't have struct device associated with it.

But the caller of v4l2_clk_get() will have a struct device * available, so I 
think it would make sense to pass a struct device * to v4l2_clk_get() and call 
dev_name() on it internally. Clocks would be registered with the device ID as 
well. This requires knowledge of the clock user device in the clock provider, 
but no knowledge of the clock user module name.
 
> >> And if the host driver that registers a clock for its sub-device knows
> >> the type of device (I2C, SPI client, etc.) why we need to even bother
> >> with checking the subdev/bus type in v4l2_clk_find() function above, when
> >> the host could properly format dev_id when it registers a clock ?
> > 
> > This has been discussed. The host doesn't know the name of the I2C driver,
> > that would attach to this subdevice at the time, it registers the clock.
> > This is the easiest way to oversome this problem.
> 
> OK, thanks for reminding. It would be probably much easier to associate
> the clock with struct device, not with subdev driver. Devices have more
> clear naming rules (at last I2C, SPI clients). And most host drivers
> already have information about I2C bus id, just I2C slave address would
> need to be passed to the host driver so it can register a clock for its
> subdev.
> 
> >> Then the subdev would just pass its struct device pointer to this API to
> >> find its clock. What am I missing here ?
> > I don't think there's a 1-to-1 correspondence between devices and V4L2
> > subdevices.
> 
> I would expect at least a subdev that needs a clock to have struct device
> associated with it. It would be also much easier this way to use generic
> clocks API in the device tree instantiated systems.

I agree. Let's not overdesign the v4l2-clock API to support clock users 
without a struct device. This is a transitional API only after all.

> >>> +	if (!IS_ERR(clk)&&  !try_module_get(clk->ops->owner))
> >>> +		clk = ERR_PTR(-ENODEV);
> >>> +	mutex_unlock(&clk_lock);
> >>> +
> >>> +	if (!IS_ERR(clk)) {
> >>> +		clk->subdev = sd;
> >> 
> >> Why is this needed ? It seems a strange addition that might potentially
> >> make transition to the common clocks API more difficult.
> > 
> > We got rid of the v4l2_clk_bind() function and the .bind() callback. Now I
> > need a pointer to subdevice _before_ v4l2_clk_register() (former
> > v4l2_clk_bound()), that's why I have to store it here.
> 
> Hmm, sorry, I'm not following. How can we store a subdev pointer in the
> clock data structure that has not been registered yet and thus cannot be
> found with v4l2_clk_find() ?
> 
> >>> +		atomic_inc(&clk->use_count);
> >>> +	}
> >>> +
> >>> +	return clk;
> >>> +}
> >>> +EXPORT_SYMBOL(v4l2_clk_get);

-- 
Regards,

Laurent Pinchart

