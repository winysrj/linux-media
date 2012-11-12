Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37342 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2KLLDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 06:03:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] media: V4L2: add temporary clock helpers
Date: Mon, 12 Nov 2012 12:04:16 +0100
Message-ID: <2036621.k9xkWqC1fF@avalon>
In-Reply-To: <Pine.LNX.4.64.1210311307550.9048@axis700.grange>
References: <Pine.LNX.4.64.1210301458250.29432@axis700.grange> <1771793.hErFTLlAOS@avalon> <Pine.LNX.4.64.1210311307550.9048@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 31 October 2012 14:02:54 Guennadi Liakhovetski wrote:
> On Wed, 31 Oct 2012, Laurent Pinchart wrote:
> > On Tuesday 30 October 2012 15:18:38 Guennadi Liakhovetski wrote:
> > > Typical video devices like camera sensors require an external clock
> > > source. Many such devices cannot even access their hardware registers
> > > without a running clock. These clock sources should be controlled by
> > > their consumers. This should be performed, using the generic clock
> > > framework. Unfortunately so far only very few systems have been ported
> > > to that framework. This patch adds a set of temporary helpers, mimicking
> > > the generic clock API, to V4L2. Platforms, adopting the clock API,
> > > should switch to using it. Eventually this temporary API should be
> > > removed.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > > 
> > > v2: integrated most fixes from Sylwester & Laurent,
> > > 
> > > (1) do not register identical clocks
> > > (2) add clock refcounting
> > > (3) more robust locking
> > > (4) duplicate strings to prevent dereferencing invalid memory
> > > (5) add a private data pointer
> > > (6) return an error in get_rate() / set_rate() if clock isn't enabled
> > > (7) support .id=NULL per subdevice
> > > 
> > > Thanks to all reviewers!
> > > 
> > >  drivers/media/v4l2-core/Makefile   |    2 +-
> > >  drivers/media/v4l2-core/v4l2-clk.c |  169 +++++++++++++++++++++++++++++
> > >  include/media/v4l2-clk.h           |   51 +++++++++++
> > >  3 files changed, 221 insertions(+), 1 deletions(-)
> > >  create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
> > >  create mode 100644 include/media/v4l2-clk.h

[snip]

> > > +int v4l2_clk_enable(struct v4l2_clk *clk)
> > > +{
> > > +	if (atomic_inc_return(&clk->enable) == 1 && clk->ops->enable) {
> > > +		int ret = clk->ops->enable(clk);
> > > +		if (ret < 0)
> > > +			atomic_dec(&clk->enable);
> > > +		return ret;
> > > +	}
> > 
> > I think you need a spinlock here instead of atomic operations. You could
> > get preempted after atomic_inc_return() and before clk->ops->enable() by
> > another process that would call v4l2_clk_enable(). The function would
> > return with enabling the clock.
> 
> Sorry, what's the problem then? "Our" instance will succeed and call
> ->enable() and the preempting instance will see the enable count > 1 and
> just return.

CPU 0                              CPU 1
-----------------------------------------------------------------------------

v4l2_clk_enable()
atomic_inc_return() returns 1

                                   v4l2_clk_enable()
                                   atomic_inc_return() returns 2
                                   returns 0 to caller, clock is not enabled
                                   caller uses the clock and fails

clk->ops->enable()

This could also happen on a non-SMP system if the first task is interrupted 
between the atomic_inc_return() and clk->ops->enable() calls.

> > One solution would be to add a spinlock to struct v4l2_clk and modify the
> > enable field from atomic_t to plain unsigned int.
> > 
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL(v4l2_clk_enable);
> > > +
> > > +void v4l2_clk_disable(struct v4l2_clk *clk)
> > > +{
> > > +	int enable = atomic_dec_return(&clk->enable);
> > > +
> > > +	if (WARN(enable < 0, "Unbalanced %s()!\n", __func__)) {
> > 
> > Could you add the clock name to the debug message ?
> 
> You mean device / connection IDs? Could do, yes.

Yes.

> > > +		atomic_inc(&clk->enable);
> > > +		return;
> > > +	}
> > > +
> > > +	if (!enable && clk->ops->disable)
> > > +		clk->ops->disable(clk);
> > > +}
> > > +EXPORT_SYMBOL(v4l2_clk_disable);

[snip]

> > > +void v4l2_clk_unregister(struct v4l2_clk *clk)
> > > +{
> > > +	WARN(atomic_read(&clk->enable),
> > > +	     "Unregistering still enabled %s:%s clock!\n", clk->dev_id,
> > > clk->id);
> > 
> > Shouldn't this warning be based on a get/put refcount instead of an enable
> > refcount ?
> 
> In principle - yes, so, you vote for one more counter?...

Either one more counter, or dropping the warning.

> > I would also turn it into a BUG_ON. The kernel will crash later anyway
> > when the clock user will try to disable the clock, as you free the clock
> > object here.
> 
> s/when/if/ ;-) With BUG_ON() you, probably, only get one stack dump here,
> with WARN() you get both - one with the _unregister() stack and one with
> the _disable() and / or _put() stack... Don't you think the latter option
> is more informative?

What bothers me is that the later disable/put might not crash immediately but 
could lead to memory corruption with potential severe consequences if the 
memory has been reallocated.

> > > +	mutex_lock(&clk_lock);
> > > +	list_del(&clk->list);
> > > +	mutex_unlock(&clk_lock);
> > > +
> > > +	kfree(clk->id);
> > > +	kfree(clk->dev_id);
> > > +	kfree(clk);

-- 
Regards,

Laurent Pinchart

