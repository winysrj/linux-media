Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:54417 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3DWNBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 09:01:45 -0400
Date: Tue, 23 Apr 2013 15:01:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v9 02/20] V4L2: support asynchronous subdevice registration
In-Reply-To: <1489465.QAtJQiYEWC@avalon>
Message-ID: <Pine.LNX.4.64.1304231435540.1422@axis700.grange>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
 <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de> <516BEB1D.80105@samsung.com>
 <1489465.QAtJQiYEWC@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Mon, 22 Apr 2013, Laurent Pinchart wrote:

> Hi Guennadi and Sylwester,
> 
> On Monday 15 April 2013 13:57:17 Sylwester Nawrocki wrote:
> > On 04/12/2013 05:40 PM, Guennadi Liakhovetski wrote:

[snip]

> > > +
> > > +		if (notifier->unbind)
> > > +			notifier->unbind(notifier, asdl);
> > > +	}
> > > +
> > > +	mutex_unlock(&list_lock);
> > > +
> > > +	if (dev) {
> > > +		while (i--) {
> > > +			if (dev[i] && device_attach(dev[i]) < 0)
> 
> This is my last major pain point.
> 
> To avoid race conditions we need circular references (see http://www.mail-archive.com/linux-media@vger.kernel.org/msg61092.html). We will thus need a 
> way to break the circle by explictly requesting the subdev to release its 
> resources. I'm afraid I have no well-designed solution for that at the moment.

I think we really can design the framework to allow a _safe_ unloading of 
the bridge driver. An rmmod run is not an immediate death - we have time 
to clean up and release all resources properly. As an example, I just had 
a network interface running, but rmmod-ing of one of hardware drivers just 
safely destroyed the interface. In our case, rmmod <bridge> should just 
signal the subdevice to release the clock reference. Whether we have the 
required - is a separate question.

Currently a call to v4l2_clk_get() increments the clock owner use-count. 
This isn't a problem for soc-camera, since there the soc-camera core owns 
the clock. For other bridge drivers they would probably own the clock 
themselves, so, incrementing their use-count would block their modules in 
memory. To avoid that we have to remove that use-count incrementing.

The crash, described in the referenced mail can happen if the subdevice 
driver calls (typically) v4l2_clk_enable() on a clock, that's already been 
freed. Wouldn't a locked look-up in the global clock list in v4l2-clk.c 
prevent such a crash? E.g.

int v4l2_clk_enable(struct v4l2_clk *clk)
{
	struct v4l2_clk *tmp;
	int ret = -ENODEV;

	mutex_lock(&clk_lock);
	list_for_each_entry(tmp, &clk_list, list)
		if (tmp == clk) {
			ret = !try_module_get(clk->ops->owner);
			if (ret)
				ret = -EFAULT;
			break;
		}
	mutex_unlock(&clk_lock);

	if (ret < 0)
		return ret;

	...
}

We'd have to do a similar locked look-up in v4l2_clk_put().

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
