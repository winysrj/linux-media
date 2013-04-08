Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62251 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934908Ab3DHKgZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:36:25 -0400
Date: Mon, 8 Apr 2013 12:36:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v6 1/7] media: V4L2: add temporary clock helpers
In-Reply-To: <5147934D.2040908@gmail.com>
Message-ID: <Pine.LNX.4.64.1304081234050.29945@axis700.grange>
References: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de>
 <1363382873-20077-2-git-send-email-g.liakhovetski@gmx.de> <5147934D.2040908@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Mar 2013, Sylwester Nawrocki wrote:

[snip]

> > +unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk)
> > +{
> > +	if (!clk->ops->get_rate)
> > +		return -ENOSYS;
> 
> I guess we should just WARN if this callback is null and return 0
> or return value type of this function needs to be 'long'. Otherwise
> we'll get insanely large frequency value by casting this error code
> to unsigned long.

Comparing to the CCF: AFAICS, they do the same, you're supposed to use 
IS_ERR_VALUE() on the clock rate, obtained from clk_get_rate().

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
