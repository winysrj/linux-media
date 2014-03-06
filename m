Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48576 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaCFXXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 18:23:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>, devel@driverdev.osuosl.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH RFC 26/46] drivers/base: provide an infrastructure for componentised subsystems
Date: Fri, 07 Mar 2014 00:24:33 +0100
Message-ID: <16403654.Dg5ZqMop7H@avalon>
In-Reply-To: <20140226221939.GC21483@n2100.arm.linux.org.uk>
References: <20140102212528.GD7383@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1402262144190.10826@axis700.grange> <20140226221939.GC21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

Time for me to jump in. The more, the merrier I suppose.

On Wednesday 26 February 2014 22:19:39 Russell King - ARM Linux wrote:
> On Wed, Feb 26, 2014 at 10:00:25PM +0100, Guennadi Liakhovetski wrote:
> > Hi Russell
> > 
> > (I suspect this my email will be rejected by ALKML too like other my
> > recent emails, but at least other MLs will pick it up and individual CCs
> > too, so, if replying, maybe it would be good to keep my entire reply, all
> > the more that it's going to be very short)
> > 
> > On Thu, 2 Jan 2014, Russell King wrote:
> > > Subsystems such as ALSA, DRM and others require a single card-level
> > > device structure to represent a subsystem.  However, firmware tends to
> > > describe the individual devices and the connections between them.
> > > 
> > > Therefore, we need a way to gather up the individual component devices
> > > together, and indicate when we have all the component devices.
> > > 
> > > We do this in DT by providing a "superdevice" node which specifies
> > > the components, eg:
> > > 	imx-drm {
> > > 		compatible = "fsl,drm";
> > > 		crtcs = <&ipu1>;
> > > 		connectors = <&hdmi>;
> > > 	};
> > 
> > It is a pity linux-media wasn't CC'ed and apparently V4L developers didn't
> > notice this and other related patches in a "clean up" series, and now this
> > patch is already in the mainline. But at least I'd like to ask whether the
> > bindings, defined in
> > Documentation/devicetree/bindings/media/video-interfaces.txt and
> > implemented in drivers/media/v4l2-core/v4l2-of.c have been considered for
> > this job, and - if so - why have they been found unsuitable? Wouldn't it
> > have been better to use and - if needed - extend them to cover any
> > deficiencies? Even though the implementation is currently located under
> > drivers/media/v4l2-code/ it's pretty generic and should be easily
> > transferable to a more generic location.
> 
> The component helpers have nothing to do with DT apart from solving
> the problem of how to deal with subsystems which expect a single device,
> but we have a group of devices and their individual drivers to cope with.
> Subsystems like DRM and ALSA.

(and V4L2)

Point duly taken. First of all I want to mention that your proposal is 
greatly appreciated. This is a problem that crosses subsystem boundaries, and 
should thus be addressed centrally.

However, we (as in the V4L2 community, and me personally) would have 
appreciated to be CC'ed on the proposal. As you might know we already had a 
solution for this problem, albeit V4L2-specific, in drivers/media/v4l2-
core/v4l2-async.c. Whether or not this solution should have been made generic 
instead of coming up with a new separate implementation would of course have 
been debatable, but the most important point would have been to make sure that 
v4l2-async could easily be implemented on top of the common component 
architecture.

The topic is particularly hot given that a similar solution was also proposed 
as part of the now defunct (or at least hibernating) common display framework. 
If I had replied to this mail thread without sleeping on it first I might not 
have known better and have got half-paranoid, wondereding whether there had 
been a deliberate attempt to fast-track this API before the V4L2 developers 
noticed. To be perfectly clear, there is *NO* implicit or explicit such 
accusation here, as I know better.

Let's all take this as a positive opportunity to cooperate more closely, media 
devices still need a huge effort to be cleanly supported on modern hardware, 
and we'll need all the development power we can get.

Accordingly, I would like to comment on the component API, despite the fact 
that it has been merged in mainline already. The first thing that I believe is 
missing is documentation. Do you have any pending patch for that, either as 
kerneldoc or as a text file for Documentation/ ? As I've read the code to 
understand it I might have missed so design goals, so please bear with the 
stupid questions that may follow.

I'll first provide a brief comparison of the two models to make the rest of 
the comments easier to understand.

v4l2-async calls the component master object v4l2_async_notifier. The base 
component child object is a v4l2_subdev instance instead of being a plain 
device. v4l2_subdev instances are stored in v4l2-async lists similarly to how 
the component framework stores objects, except that the list head is directly 
embedded inside the v4l2_subdev structure instead of being part of a separate 
structure allocated by the framework.

The notifier has three callback functions, bound, complete and unbind. The 
bound function is called when one component has been bound to the master. 
Similarly the unbind function is called when one component is about to be 
unbound from the master. The complete function is called when all components 
have been bound, and is thus equivalent to the bind function of the component 
framework.

Notifiers are registered along with a list of match entries. A match entry is 
roughly equivalent to the compare function passed to 
component_master_add_child, except that it includes built-in support for 
matching on an OF node, dev_name or I2C bus number and child address.

Whenever a subdev (component child) is registered with 
v4l2_async_register_subdev (equivalent to component_add), the list of 
notifiers (masters) is walked and their match entries are processed. If a 
matching entry is found the subdev is bound to the notifier immediately, 
otherwise it is added to a list of unbound subdevices (component_list). 
Whenever a notifier (component master) is registered with 
v4l2_async_notifier_register (component_master_add) the list of unbound 
subdevs is walked and every match entry of the notifier is tested. If a 
matching entry is found the subdev is bound to the notifier.

I've seen a couple of core differences in concept between your component model 
and the v4l2-async model:

- The component framework uses private master and component structures. 
Wouldn't it simplify the code from a memory management point of view to expose 
the master structure (which would then be embedded in driver-specific 
structures) and the component structure (which would be embedded in struct 
device) ? The latter would be slightly more intrusive from a struct device 
point of view, so I don't have a strong opinion there yet, exposing the master 
structure only might be better.

- The component framework requires the master to provide an add_components 
operation that will call the component_master_add_child function for every 
component it needs, with a compare function. The add child function is called 
when the master is registered, and then for every component added to the 
system. I'm not sure to understand the design decisions behind this, but these 
two levels of indirection appear pretty complex and confusing. Wouldn't it be 
simpler to pass an array of match entries to the master registration function 
instead and remove the add_components operation ? A match entry would 
basically be a structure with a compare function and a compare_data pointer.

We could also extend the match entry with explicit support for OF node and I2C 
bus number + address matching as those are the most common cases, or at least 
provide a couple of standard compare functions for those cases.

- The component framework doesn't provide partial bind support. Children are 
bound to the master only when all children are available. This makes it 
impossible in practice to implement v4l2-async on top of the component 
framework. What would you think about adding optional partial bind support ? 
The master operations would then have partial bind, complete bind, partial 
unbind and complete unbind functions. Drivers that only need full bind support 
could set the partial bind and unbind functions to NULL.

> It is completely agnostic to whether you're using platform data, DT or
> even ACPI - this code could *not* care less.  None of that comes anywhere
> near what this patch does.  It merely provides a way to collect up
> individual devices from co-operating drivers, and control their binding
> such that a subsystem like DRM or ALSA can be presented with a "card"
> level view of the hardware rather than a multi-device medusa with all
> the buggy, racy, crap fsckage that people come up to make that kind of
> thing work.
> 
> Now, as for the binding above, first, what does "eg" mean... and
> secondly, how would a binding which refers to crtcs and connectors
> have anything to do with ALSA?  Clearly this isn't an example of a
> binding for an ALSA use, which was talked about in the very first
> line of the above commit commentry.  So it's quite clear that what is
> given there is an example of how it /could/ be used.
> 
> I suppose I could have instead turned imx-drm into a completely unusable
> mess by not coming up with some kind of binding, and instead submitted
> a whole pile of completely untested code.  Alternatively, I could've
> used the OF binding as you're suggesting, but that would mean radically
> changing the /existing/ bindings for the IPU as a whole - something
> which others are better suited at as they have a /much/ better
> understanding of the complexities of this hardware than I.
> 
> So, what I have done is implemented - for a driver in staging which is
> still subject to ongoing development and non-stable DT bindings -
> something which allows forward progress with a *minimum* of disruption
> to the existing DT bindings for everyone, while still allowing forward
> progress.
> 
> Better bindings for imx-drm are currently being worked on.  Philipp
> Zabel of Pengutronix is currently looking at it, and has posted many
> RFC patches on this very subject, including moving the V4L2 OF helpers
> to a more suitable location.  OF people have been involved in that
> discussion over the preceding weeks, and there's a working implementation
> of imx-drm using these helpers from v4l2.
> 
> I'm finding people who are working in the same area and trying to get
> everyone talking to each other so that we /do/ end up with a set of
> bindings for the display stuff which are suitable for everyone.  Tomi
> from TI has already expressed his input to this ongoing discussion.
> 
> You're welcome to get involved in those discussions too.
> 
> I hope this makes it clear, and clears up the confusion.
> 
> Thanks.

-- 
Regards,

Laurent Pinchart
