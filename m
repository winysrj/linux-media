Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59446 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977AbbHXJkL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 05:40:11 -0400
Date: Mon, 24 Aug 2015 06:40:06 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 7/8] [media] media: add a debug message to warn about
 gobj creation/removal
Message-ID: <20150824064006.126b4f46@recife.lan>
In-Reply-To: <5814209.73Ea5OdygA@avalon>
References: <cover.1439981515.git.mchehab@osg.samsung.com>
	<2758453.qxSJXS9IU1@avalon>
	<20150821180931.4c492767@recife.lan>
	<5814209.73Ea5OdygA@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 22 Aug 2015 01:54:07 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Friday 21 August 2015 18:09:31 Mauro Carvalho Chehab wrote:
> > Em Fri, 21 Aug 2015 20:54:29 +0300 Laurent Pinchart escreveu:
> > > On Friday 21 August 2015 07:19:21 Mauro Carvalho Chehab wrote:
> > >> Em Fri, 21 Aug 2015 04:32:51 +0300 Laurent Pinchart escreveu:
> > >>> On Wednesday 19 August 2015 08:01:54 Mauro Carvalho Chehab wrote:
> > >>>> It helps to check if the media controller is doing the
> > >>>> right thing with the object creation and removal.
> > >>>> 
> > >>>> No extra code/data will be produced if DEBUG or
> > >>>> CONFIG_DYNAMIC_DEBUG is not enabled.
> > >>> 
> > >>> CONFIG_DYNAMIC_DEBUG is often enabled.
> > >> 
> > >> True, but once a driver/core is properly debugged, images without DEBUG
> > >> could be used in production, if the amount of memory constraints are
> > >> too tight.
> > >> 
> > >> > You're more or less adding function call tracing in this patch, isn't
> > >> > that something that ftrace is supposed to do ?
> > >> 
> > >> Ftrace is a great infrastructure and helps a lot when we need to
> > >> identify bottlenecks and other performance related stuff, but it
> > >> doesn't replace debug functions.
> > >> 
> > >> There are some fundamental differences on what you could do with ftrace
> > >> and what you can't.
> > >> 
> > >> At least on this stage, what I need is something that will provide
> > >> output via serial console when the driver gets loaded, and that provides
> > >> a synchronous output with the other Kernel messages.
> > >> 
> > >> This is the only way to debug certain OOPSes that are happening during
> > >> the development of the patches.
> > >> 
> > >> This is something you cannot do with ftrace, but dynamic DEBUG works
> > >> like a charm.
> > > 
> > > I understand the need for debug messages during development of a patch
> > > series, but I don't think this level of debugging belongs to mainline.
> > > Debug messages for function call tracing, even more in patch 6/8 and 7/8,
> > > is frowned upon in the kernel.
> > > 
> > > Or maybe I got it wrong and patches 6/8 and 7/8 are only for development
> > > and you don't plan to get them in mainline ?
> > 
> > As we've agreed, the first phase won't have dynamic support. Both patches
> > 6/8 and 7/8 are important until then.
> 
> Why are they more important with dynamic support ?

Because it helps to identify if the creation/removal of the objects are
being done at the right order. If the media_device got unregistered
and kfreed before unregistering the devices, things will go bad.
Also, a PAD can't be destroyed if any links that reference it still
exists.

I got tons of troubles like that during the development of the PATCH v7
series.

> > So, they should reach mainline together with the first MC new gen series.
> 
> Patch 6/8 states in its commit message that
> 
> "We can only free the media device after being sure that no graph object is 
> used. In order to help tracking it, let's add debug messages that will print 
> when the media controller gets registered or unregistered."
> 
> Instead of debug messages that need to be enabled and tracked manually, why 
> not detecting the condition and issuing a WARN_ON() ?

Because I'm not sure how to write such patch ;) I don't know any
algorithm that could be used to detect that a kfree() happening at the
wrong order.

My old proposal were to use kref() for that, but neither you nor Lars
saw the need for that. Also, after looking deeper in the code, adding
a kref() for the graph objects isn't trivial.

My original idea to support dynamic objects is to have a code at
media_graph_init() that would increment the kref() count for the
created object and for the referenced objects (like the two pads
on a data link and the media_device), and decrementing kref() at
media_graph_remove(). The actual function that would free the memory
would be called when kref() count reaches zero.

In other words, if we add a kref() count for the objects and for
media_device, then we can get rid of patch 6/8, but we're not there
yet.

For that to work, there are several changes that would be needed:

- The media_device should be dynamically allocated;

- All graph objects can only be created after having the media
  device created, and should not be embedded;

- The PAD allocation should be moved to the MC core.

IMO, that's the best solution if we were starting to design MC
right now. However, changing the drivers at this moment to do
that will require retest the MC there, with means that the
driver maintainer should very likely be helping. That's an
unlikely scenario, unfortunately.

So, I guess we'll need to find another way. That's why we need
to keep patch 6/8 until we figure out a solution for that.

Regards,
Mauro

