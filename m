Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:64670 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab3CSK2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 06:28:14 -0400
Date: Tue, 19 Mar 2013 11:27:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v6 1/7] media: V4L2: add temporary clock helpers
In-Reply-To: <5148355D.5070806@samsung.com>
Message-ID: <Pine.LNX.4.64.1303191103310.11768@axis700.grange>
References: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de>
 <1363382873-20077-2-git-send-email-g.liakhovetski@gmx.de> <5147934D.2040908@gmail.com>
 <Pine.LNX.4.64.1303190821470.10482@axis700.grange> <5148355D.5070806@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 19 Mar 2013, Sylwester Nawrocki wrote:

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
> Hmm, sorry, I'm not following. How can we store a subdev pointer in the clock
> data structure that has not been registered yet and thus cannot be found
> with v4l2_clk_find() ?

sorry, I meant v4l2_async_subdev_register(), not v4l2_clk_register(), my 
mistake. And I meant v4l2_async_subdev_bind(), v4l2_async_subdev_unbind(). 
Before we had in the subdev driver (see imx074 example)

	/* Tell the bridge the subdevice is about to bind */
	v4l2_async_subdev_bind();

	/* get a clock */
	clk = v4l2_clk_get();
	if (IS_ERR(clk))
		return -EPROBE_DEFER;

	/*
	 * enable the clock - this needs a subdev pointer, that we passed 
	 * to the bridge with v4l2_async_subdev_bind() above
	 */
	v4l2_clk_enable(clk);
	do_probe();
	v4l2_clk_disable(clk);

	/* inform the bridge: binding successful */
	v4l2_async_subdev_bound();

Now we have just

	/* get a clock */
	clk = v4l2_clk_get();
	if (IS_ERR(clk))
		return -EPROBE_DEFER;

	/*
	 * enable the clock - this needs a subdev pointer, that we stored 
	 * in the clock object for the bridge driver to use with 
	 * v4l2_clk_get() above
	 */
	v4l2_clk_enable(clk);
	do_probe();
	v4l2_clk_disable(clk);

	/* inform the bridge: binding successful */
	v4l2_async_subdev_bound();

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
