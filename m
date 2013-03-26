Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35249 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3CZXI1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 19:08:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v6 1/7] media: V4L2: add temporary clock helpers
Date: Wed, 27 Mar 2013 00:09:15 +0100
Message-ID: <2434380.WAg9HcVhPF@avalon>
In-Reply-To: <Pine.LNX.4.64.1303191103310.11768@axis700.grange>
References: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de> <5148355D.5070806@samsung.com> <Pine.LNX.4.64.1303191103310.11768@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 19 March 2013 11:27:56 Guennadi Liakhovetski wrote:
> On Tue, 19 Mar 2013, Sylwester Nawrocki wrote:
> > >>> +	if (!IS_ERR(clk)&&  !try_module_get(clk->ops->owner))
> > >>> +		clk = ERR_PTR(-ENODEV);
> > >>> +	mutex_unlock(&clk_lock);
> > >>> +
> > >>> +	if (!IS_ERR(clk)) {
> > >>> +		clk->subdev = sd;
> > >> 
> > >> Why is this needed ? It seems a strange addition that might potentially
> > >> make transition to the common clocks API more difficult.
> > > 
> > > We got rid of the v4l2_clk_bind() function and the .bind() callback. Now
> > > I need a pointer to subdevice _before_ v4l2_clk_register() (former
> > > v4l2_clk_bound()), that's why I have to store it here.
> > 
> > Hmm, sorry, I'm not following. How can we store a subdev pointer in the
> > clock data structure that has not been registered yet and thus cannot be
> > found with v4l2_clk_find() ?
> 
> sorry, I meant v4l2_async_subdev_register(), not v4l2_clk_register(), my
> mistake. And I meant v4l2_async_subdev_bind(), v4l2_async_subdev_unbind().
> Before we had in the subdev driver (see imx074 example)
> 
> 	/* Tell the bridge the subdevice is about to bind */
> 	v4l2_async_subdev_bind();
> 
> 	/* get a clock */
> 	clk = v4l2_clk_get();
> 	if (IS_ERR(clk))
> 		return -EPROBE_DEFER;
> 
> 	/*
> 	 * enable the clock - this needs a subdev pointer, that we passed
> 	 * to the bridge with v4l2_async_subdev_bind() above
> 	 */
> 	v4l2_clk_enable(clk);
> 	do_probe();
> 	v4l2_clk_disable(clk);
> 
> 	/* inform the bridge: binding successful */
> 	v4l2_async_subdev_bound();
> 
> Now we have just
> 
> 	/* get a clock */
> 	clk = v4l2_clk_get();
> 	if (IS_ERR(clk))
> 		return -EPROBE_DEFER;
> 
> 	/*
> 	 * enable the clock - this needs a subdev pointer, that we stored
> 	 * in the clock object for the bridge driver to use with
> 	 * v4l2_clk_get() above
> 	 */
> 	v4l2_clk_enable(clk);
> 	do_probe();
> 	v4l2_clk_disable(clk);

I'm sorry, but I still don't understand why you need a pointer to the subdev 
in the clock provider implementation of v4l2_clk_enable/disable() :-)

> 	/* inform the bridge: binding successful */
> 	v4l2_async_subdev_bound();

-- 
Regards,

Laurent Pinchart

