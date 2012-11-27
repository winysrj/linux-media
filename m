Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51117 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab2K0ORU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 09:17:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] media: V4L2: add temporary clock helpers
Date: Tue, 27 Nov 2012 15:18:23 +0100
Message-ID: <3188473.q8yhc1O96z@avalon>
In-Reply-To: <50B1FB29.2060302@iki.fi>
References: <Pine.LNX.4.64.1210301458250.29432@axis700.grange> <50AEACA5.1010805@gmail.com> <50B1FB29.2060302@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Sunday 25 November 2012 13:04:09 Sakari Ailus wrote:
> Sylwester Nawrocki wrote:
> > On 11/14/2012 02:06 PM, Laurent Pinchart wrote:
> > ...
> > 
> >>>>>>>> +
> >>>>>>>> +static DEFINE_MUTEX(clk_lock);
> >>>>>>>> +static LIST_HEAD(v4l2_clk);
> >>>>>>> 
> >>>>>>> As Sylwester mentioned, what about s/v4l2_clk/v4l2_clks/ ?
> >>>>>> 
> >>>>>> Don't you think naming of a static variable isn't important enough?
> >>>>>> ;-) I think code authors should have enough freedom to at least pick
> >>>>>> up single vs. plural form:-) "clks" is too many consonants for my
> >>>>>> taste, if it were anything important I'd rather agree to
> >>>>>> "clk_head" or
> >>>>>> "clk_list" or something similar.
> >>>>> 
> >>>>> clk_list makes sense IMO since the clk_ prefis is the same.
> > 
> > FWIW, clk_list looks fine for me as well.
> > 
> >>>>>>>> +void v4l2_clk_put(struct v4l2_clk *clk)
> >>>>>>>> +{
> >>>>>>>> +    if (!IS_ERR(clk))
> >>>>>>>> +        module_put(clk->ops->owner);
> >>>>>>>> +}
> >>>>>>>> +EXPORT_SYMBOL(v4l2_clk_put);
> >>>>>>>> +
> >>>>>>>> +int v4l2_clk_enable(struct v4l2_clk *clk)
> >>>>>>>> +{
> >>>>>>>> +    if (atomic_inc_return(&clk->enable) == 1&&
> >>>>>>>> clk->ops->enable) {
> >>>>>>>> +        int ret = clk->ops->enable(clk);
> >>>>>>>> +        if (ret<  0)
> >>>>>>>> +            atomic_dec(&clk->enable);
> >>>>>>>> +        return ret;
> >>>>>>>> +    }
> >>>>>>> 
> >>>>>>> I think you need a spinlock here instead of atomic operations. You
> >>>>>>> could get preempted after atomic_inc_return() and before
> >>>>>>> clk->ops->enable() by another process that would call
> >>>>>>> v4l2_clk_enable(). The function would return with enabling the
> >>>>>>> clock.
> >>>>>> 
> >>>>>> Sorry, what's the problem then? "Our" instance will succeed and call
> >>>>>> ->enable() and the preempting instance will see the enable count>  1
> >>>>>> and just return.
> >>>>> 
> >>>>> The clock is guaranteed to be enabled only after the call has
> >>>>> returned. The second caller of v4lw_clk_enable() thus may proceed
> >>>>> without the clock being enabled.
> >>>>> 
> >>>>> In principle enable() might also want to sleep, so how about using a
> >>>>> mutex for the purpose instead of a spinlock?
> >>>> 
> >>>> If enable() needs to sleep we should split the enable call into prepare
> >>>> and enable, like the common clock framework did.
> >>> 
> >>> I'm pretty sure we won't need to toggle this from interrupt context
> >>> which is what the clock framework does, AFAIU. Accessing i2c subdevs
> >>> mandates sleeping already.
> >>> 
> >>> We might not need to have a mutex either if no driver needs to sleep for
> >>> this, still I guess this is more likely. I'm ok with both; just
> >>> thought to mention this.
> >> 
> >> Right, I'm fine with a mutex for now, we'll split enable into enable and
> >> prepare later if needed.
> > 
> > How about just dropping reference counting from this code entirely ?
> > What would be use cases for multiple users of a single clock ? E.g.
> > multiple sensors case where each one uses same clock provided by a host
> > interface ? If we allow the sensor subdev drivers to be setting the clock
> > frequency and each sensor uses different frequency, then I can't see how
> > this can work reliably. I mean it's the clock's provider that should
> > coordinate and reference count the clock users. If a clock is enabled for
> > one sensor and some other sensor is attempting to set different frequency
> > then the set_rate callback should return an error. The clock provider will
> > need use internally a lock for the clock anyway, and to track the clock
> > reference count too. So I'm inclined to leave all this refcounting bits
> > out to individual clock providers.
> 
> The common clock framework achieves this through notifiers. That'd be
> probably overkill in this case.
> 
> What comes to the implementation now, would it be enough if changing the
> clock rate would work once after the clock first had users, with this
> capability renewed once all users are gone?
> 
> I wonder if enabling the clock should be allowed at all if the rate
> hasn't been explicitly set. I don't know of a sensor driver which would
> be able to use a non-predefined clock frequency.

OK, maybe we should try to refocus here.

The purpose of the V4L2 clock helpers is to get rid of clock-related board 
callbacks (or other direct clock provider-consumer dependencies) without 
waiting for the common clock framework to be available on a particular 
platform. With that in mind, the following problems need to be solved.

- Multiple consumers for a single clock

A video sensor and the associated lens and/or flash controllers could share 
the same input clock. How to arbitrate rate requests from the individual 
consumers is still an open problem, but that's true for the common clock 
framework too. I wouldn't vote against requiring the common clock framework 
for this use case. This would mean that most of the locking and reference 
counting could (but doesn't have to) be dropped from the V4L2 clock helpers 
(reference counting can still be useful for debugging purposes).

- Clock provider/consumer outside of V4L2

If the clock provider isn't a V4L2 device, I think the common clock framework 
must be used by the consumer to access the clock. Similarly, if the provider 
is a V4L2 device and the consumer isn't, the common clock framework must be 
used as well (although I don't think this case will happen in practice, I 
can't really imagine a USB transceiver using the ISP clock for instance).

- Common clock framework fallback

This is a new item. Sensor (or other clock consumer) drivers can't tell 
whether the clock provider exposes its clock(s) through the common clock 
framework or through the V4L2 clock helpers. ISP (or other clock provider) 
drivers, on the other hand, are tied to a platform (or a very limited set of 
platforms) and use the common clock framework if available, or the V4L2 clock 
helpers otherwise. During the transition clock consumers will need to support 
both. For that reason I believe that the V4L2 clock helpers should retrieve 
the requested clock through the common clock framework first, and then look at 
the V4L2 clocks if the clock wasn't available from the common clock framework.

-- 
Regards,

Laurent Pinchart

