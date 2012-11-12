Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37250 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754068Ab2KLXh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 18:37:56 -0500
Date: Tue, 13 Nov 2012 01:37:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] media: V4L2: add temporary clock helpers
Message-ID: <20121112233750.GQ25623@valkosipuli.retiisi.org.uk>
References: <Pine.LNX.4.64.1210301458250.29432@axis700.grange>
 <Pine.LNX.4.64.1210311307550.9048@axis700.grange>
 <20121111223317.GM25623@valkosipuli.retiisi.org.uk>
 <12527629.75AJWSknHq@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12527629.75AJWSknHq@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Nov 12, 2012 at 12:06:50PM +0100, Laurent Pinchart wrote:
> On Monday 12 November 2012 00:33:17 Sakari Ailus wrote:
> > On Wed, Oct 31, 2012 at 02:02:54PM +0100, Guennadi Liakhovetski wrote:
> > > On Wed, 31 Oct 2012, Laurent Pinchart wrote:
> > ...
> > 
> > > > > +#include <linux/atomic.h>
> > > > > +#include <linux/errno.h>
> > > > > +#include <linux/list.h>
> > > > > +#include <linux/module.h>
> > > > > +#include <linux/mutex.h>
> > > > > +#include <linux/string.h>
> > > > > +
> > > > > +#include <media/v4l2-clk.h>
> > > > > +#include <media/v4l2-subdev.h>
> > > > > +
> > > > > +static DEFINE_MUTEX(clk_lock);
> > > > > +static LIST_HEAD(v4l2_clk);
> > > > 
> > > > As Sylwester mentioned, what about s/v4l2_clk/v4l2_clks/ ?
> > > 
> > > Don't you think naming of a static variable isn't important enough? ;-) I
> > > think code authors should have enough freedom to at least pick up single
> > > vs. plural form:-) "clks" is too many consonants for my taste, if it were
> > > anything important I'd rather agree to "clk_head" or "clk_list" or
> > > something similar.
> > 
> > clk_list makes sense IMO since the clk_ prefis is the same.
> > 
> > ...
> > 
> > > > > +void v4l2_clk_put(struct v4l2_clk *clk)
> > > > > +{
> > > > > +	if (!IS_ERR(clk))
> > > > > +		module_put(clk->ops->owner);
> > > > > +}
> > > > > +EXPORT_SYMBOL(v4l2_clk_put);
> > > > > +
> > > > > +int v4l2_clk_enable(struct v4l2_clk *clk)
> > > > > +{
> > > > > +	if (atomic_inc_return(&clk->enable) == 1 && clk->ops->enable) {
> > > > > +		int ret = clk->ops->enable(clk);
> > > > > +		if (ret < 0)
> > > > > +			atomic_dec(&clk->enable);
> > > > > +		return ret;
> > > > > +	}
> > > > 
> > > > I think you need a spinlock here instead of atomic operations. You could
> > > > get preempted after atomic_inc_return() and before clk->ops->enable()
> > > > by another process that would call v4l2_clk_enable(). The function
> > > > would return with enabling the clock.
> > > 
> > > Sorry, what's the problem then? "Our" instance will succeed and call
> > > ->enable() and the preempting instance will see the enable count > 1 and
> > > just return.
> > 
> > The clock is guaranteed to be enabled only after the call has returned. The
> > second caller of v4lw_clk_enable() thus may proceed without the clock being
> > enabled.
> > 
> > In principle enable() might also want to sleep, so how about using a mutex
> > for the purpose instead of a spinlock?
> 
> If enable() needs to sleep we should split the enable call into prepare and 
> enable, like the common clock framework did.

I'm pretty sure we won't need to toggle this from interrupt context which is
what the clock framework does, AFAIU. Accessing i2c subdevs mandates
sleeping already.

We might not need to have a mutex either if no driver needs to sleep for
this, still I guess this is more likely. I'm ok with both; just thought to
mention this.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
