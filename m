Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33800 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759833AbaCUMfM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 08:35:12 -0400
Date: Fri, 21 Mar 2014 12:34:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>, devel@driverdev.osuosl.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH RFC 26/46] drivers/base: provide an infrastructure for
	componentised subsystems
Message-ID: <20140321123444.GI7528@n2100.arm.linux.org.uk>
References: <20140102212528.GD7383@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1402262144190.10826@axis700.grange> <20140226221939.GC21483@n2100.arm.linux.org.uk> <16403654.Dg5ZqMop7H@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16403654.Dg5ZqMop7H@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 07, 2014 at 12:24:33AM +0100, Laurent Pinchart wrote:
> However, we (as in the V4L2 community, and me personally) would have 
> appreciated to be CC'ed on the proposal. As you might know we already had a 
> solution for this problem, albeit V4L2-specific, in drivers/media/v4l2-
> core/v4l2-async.c.

There's a lot of people who would have liked to be on the Cc, but there's
two problems: 1. the Cc list would be too big for mailing lists to accept
the message, and 2. finding everyone who should be on the Cc list is quite
an impossible task.

> The topic is particularly hot given that a similar solution was also
> proposed as part of the now defunct (or at least hibernating) common
> display framework. 

Yes, I am aware of CDF.  However, the annoying thing is that it's another
case of the bigger picture not being looked at - which is that we don't
need yet another subsystem specific solution to a problem which is not
subsystem specific.

The fact of the matter is that /anyone/ has the opportunity to come up
with a generic solution to this problem, and no one did... instead,
more solutions were generated - the proof is "we solved this in CDF
with a CDF specific solution". :p

> If I had replied to this mail thread without sleeping on it first I
> might not have known better and have got half-paranoid, wondereding
> whether there had been a deliberate attempt to fast-track this API
> before the V4L2 developers noticed. To be perfectly clear, there is
> *NO* implicit or explicit such accusation here, as I know better.

What would have happened is that CDF would have been raised, and there
would be a big long discussion with no real resolution.  The problem
would not have been solved (even partially).  We'd be sitting here right
now still without any kind of solution that anyone can use.

Instead, what we have right now is the opportunity for people to start
making use of this and solving the real problems they have with driver
initialisation.

For example, the IPU on iMX locks up after a number of mode changes, and
it's useful to be able to unload the driver, poke about in the hardware,
and reload it.  Without this problem fixed, that's impossible without
rebooting the kernel, because removing the driver oopses the kernel due
to the broken work-arounds that it has to do - and it has to do those
because this problem has not been solved, despite it being known about
for /years/.

> Accordingly, I would like to comment on the component API, despite the fact 
> that it has been merged in mainline already. The first thing that I believe is 
> missing is documentation. Do you have any pending patch for that, either as 
> kerneldoc or as a text file for Documentation/ ? As I've read the code to 
> understand it I might have missed so design goals, so please bear with the 
> stupid questions that may follow.

There's lots of things in the kernel which you just have to read the code
for - and this is one of them at the moment. :)  (Another is PM domains...)

What I know is that this will not satisfy all your requirements - I don't
want it to initially satisfy everyone's requirements, because that's just
far too big a job, but it satisfies the common problem that most people
are suffering from and have already implemented many badly written driver
specific solutions.

In other words - this is designed to _improve_ the current situation where
we have lots of buggy implementions trying to work around this problem,
factor that code out, and fix up those problems.

Briefly, the idea is:

- there is a master device - lots of these subsystems doing this already
  have that, whether that be ALSA or DRM based stuff.
- then there are the individual component devices and their drivers.

Subsystems like ALSA and DRM are not component based subsystems.  These
subsystems have two states - either they're initialised and the entire
"card system" is known about, or they're not initialised.  There is no
possibility of a piecemeal approach, where they partially come up and
additional stuff gets added later.  With DRM, that's especially true
because of how the userspace API works - to change that probably means
changing stuff all the way through things like the X server and its
xrandr application interface.  This is probably the reason why David said
at KS that DRM isn't going to do the hotplugging of components.

The master device has a privileged position - it gets to make the decision
about which component devices are relevant to it, and when the "card system"
is fully known.  As far as DT goes, we've had a long discussion about this
approach in the past, and we've accepted this approach - we have the
"sound" node which doesn't actually refer to any hardware block, it's a
node which describes how the hardware blocks are connected together, which
gets translated into a platform device.

When a master device gets added, it gets added to the list of master
devices, and then it's asked whether all the components that it needs
are present.  Since we don't want to fixate on any one particular
method to make that decision, it calls back via a method to the master
driver for that.  The master then determines which components should
be present, and asks the component helpers to check whether they are.
The master does this in the order which the components are to be later
bound (there's subsystems which have requirements on the ordering of
individual components appearing - for example, with DRM the CRTCs
need to be available before the encoders so that you know the CRTC
indexes to bind the encoders to.)

Each component that is found is added to a master-specific list, making
it unavailable to other masters (any particular component can't be owned
by two masters.)

If a component isn't found, then this process is unwound, and we wait for
more components to show up.

When a component is added, it is added to a list of all components.  All
unbound masters are polled to see whether they require this component in
the same way as above.

When a master indicates that it is complete, the master is bound, which
kicks off what would be the standard driver probe on non-componentised
systems.  Since we now know that we have all the components associated
with this master, this is now safe to do, and the master driver gets to
decide at what point during subsystem initialisation the components
should be bound.  This will normally be when the DRM device private
structures or ALSA card has been allocated, and are available for the
components to bind themselves to.

Should any component or master return a deferred probe, that error code
(or in fact any error code) is propagated all the way back through the
chain, unwinding the effects as we go - including devres allocated
resources.  Eventually, we hit the caller to component_add() or
component_master_add(), which would be a driver probe function, and this
propagates it back to the driver model.

So, the last driver (master or component) gets to eat any errors from
the bring up - that's reasonable, because we can't return an error from
an already completed probe function.  The side effect of this is very
important though - it gets us deferred probing.

That failed driver probe with -EPROBE_DEFER will be retried later,
hopefully when the resources that any one of those components needed is
now available.

Now, that's only half the story - the other half is far more important,
because it's the one which gives the most problems with the current
driver specific implementations, and is the one which leads to kernel
oopses.  That is, what happens when a bound component or master goes
away.

Remember that ALSA and DRM can't cope with that - the only way they can
cope is by having the entire "card system" removed.  It's an all or
nothing case.  With DRM, you wouldn't be able to remove a CRTC for
example, because that would break the CRTC numbering that userspace
sees via the kernel API, and also the CRTC numbering which xrandr Xorg
applications see.

So, when any component/master of a subsystem is removed, the whole setup
is unbound: this starts with the master being unbound, and the master
controls the point at which the components are unbound.  Again, normal
devres actions happen so drivers see proper devres behaviour.

> v4l2-async calls the component master object v4l2_async_notifier. The base 
> component child object is a v4l2_subdev instance instead of being a plain 
> device. v4l2_subdev instances are stored in v4l2-async lists similarly to how 
> the component framework stores objects, except that the list head is directly 
> embedded inside the v4l2_subdev structure instead of being part of a separate 
> structure allocated by the framework.

Right - I didn't want to modify existing structures like struct device,
because they're already bloated enough. Given that this currently affects
a small number of devices, it is unfair to impose this overhead on all
device structures in the kernel.

> The notifier has three callback functions, bound, complete and unbind. The 
> bound function is called when one component has been bound to the master. 
> Similarly the unbind function is called when one component is about to be 
> unbound from the master. The complete function is called when all components 
> have been bound, and is thus equivalent to the bind function of the component 
> framework.

So, what happens after all components have been bound (and the complete
callback has been called), and then one component is removed from the
system?  From your description, it sounds like nothing apart from the
"unbind" callback for that component.

Moreover, what happens if that component is then added back later?
Do you get another "bind" followed by "complete"?

How would a subsystem like, DRM or ALSA, be able to fit into this model
when these subsystems can't tolerate any component going away or being
introduced after the initial bring-up?

> Notifiers are registered along with a list of match entries. A match
> entry is roughly equivalent to the compare function passed to 
> component_master_add_child, except that it includes built-in support for 
> matching on an OF node, dev_name or I2C bus number and child address.

This is something we could add to the component model.  However, one of
the target design goals is that the core should be free of the matching
method, so that we don't end up with something that is specific only to
existing ARM systems.

However, one of the issues here is how to pass this information in - it
can't be a static array (see below.)

> Whenever a subdev (component child) is registered with 
> v4l2_async_register_subdev (equivalent to component_add), the list of 
> notifiers (masters) is walked and their match entries are processed. If a 
> matching entry is found the subdev is bound to the notifier immediately, 
> otherwise it is added to a list of unbound subdevices (component_list). 
> Whenever a notifier (component master) is registered with 
> v4l2_async_notifier_register (component_master_add) the list of unbound 
> subdevs is walked and every match entry of the notifier is tested. If a 
> matching entry is found the subdev is bound to the notifier.

The more interesting question is what happens when a component is removed.
This is what kills a lot of bad implementations of this right now.  It's
basically impossible to remove any component without oopsing the kernel.

> I've seen a couple of core differences in concept between your component
> model and the v4l2-async model:
> 
> - The component framework uses private master and component structures. 
> Wouldn't it simplify the code from a memory management point of view to
> expose the master structure (which would then be embedded in driver-specific 
> structures) and the component structure (which would be embedded in struct 
> device) ?

This doesn't work everywhere.  Take ALSA as an example.  There is struct
snd_card.  This is created by snd_card_create() and allocates your driver
private data structure for you in addition to the snd_card.

When you want to tear down the snd_card, this includes freeing all memory
associated with it, including the driver private data structure.  If a
component helper data structure were to be embedded in the driver private
data structure, it would also be freed - while still being registered
into component stuff.

Conversely, if you created the snd_card outside of the component stuff,
then you have no real way to remove the components when they go away.

Of course, the driver could allocate its own struct just for this, but
then where does it store a pointer to that?  In the driver data?  What
if the subsystem (and some do) insist on putting their own data in the
struct device driver data pointer?

DRM used to do exactly that (it's changed very recently to allow drivers
to do their own thing wrt driver_data - but this wasn't the case when the
component stuff was written, which was shortly after kernel summit.)

So, that's why I made the decision to have it as a separate structure.
Using the solution you're suggesting would result in unnecessary
restrictions on how drivers and subsystems should behave.

I don't think any of us want to go through changing the way lots of
subsystems and possibly hundreds of drivers work in this regard.  Hence,
while it may not appear the simplest solution, in the bigger picture,
it's better not to impose any kind of avoidable requirements on drivers.

> - The component framework requires the master to provide an add_components 
> operation that will call the component_master_add_child function for every 
> component it needs, with a compare function. The add child function is
> called when the master is registered, and then for every component added
> to the system. I'm not sure to understand the design decisions behind
> this, but these two levels of indirection appear pretty complex and
> confusing. Wouldn't it be simpler to pass an array of match entries to
> the master registration function instead and remove the add_components
> operation ? A match entry would basically be a structure with a compare
> function and a compare_data pointer.

We could supply an array of match function, match data, but the issue
here is that the match data generally isn't constant - the driver would
have to allocate an array of {function, data} and register that array
into the component helper.  Not much problem with that, except it
results in more complexity.

> We could also extend the match entry with explicit support for OF node
> and I2C bus number + address matching as those are the most common cases,
> or at least provide a couple of standard compare functions for those cases.

This I don't like, because it's making assumptions about the struct
device, encoding subsystem and firmware specific knowledge.  It's
fine to do that as a match helper, but not as something core.

> - The component framework doesn't provide partial bind support. Children
> are bound to the master only when all children are available. This makes
> it impossible in practice to implement v4l2-async on top of the component 
> framework. What would you think about adding optional partial bind support ? 

As you can see from the above explanation, this is intentional in this
iteration, as this is the common requirement for these subsystems that
it's trying to solve the problem for.

That's not to say that it can't be done - at the moment I have some
concerns from the point of view of these other subsystems which don't
support partial bind, and ensuring that partial bind doesn't get
mis-used there.

In any case, there is scope for the way the master discovers its
components to be changed, and I feel that would be a pre-requisit to
partial bind support.

Philipp's work on imx-drm for example, has ended up allocating an
ordered list of devices, though there's patches around to remove that
again.  That was necessary due to a work-around for the brokenness in
existing imx-drm for the CRTC nodes (which prevents a successful match
against a previously found component) which will now be removed.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
