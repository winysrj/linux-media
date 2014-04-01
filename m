Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36731 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaDARzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 13:55:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Rob Clark <robdclark@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/6] drm/i2c: tda998x: Move tda998x to a couple encoder/connector
Date: Tue, 01 Apr 2014 19:55:53 +0200
Message-ID: <13965577.WG3RMZsPrH@avalon>
In-Reply-To: <20140327123449.65584e93@armhf>
References: <cover.1395397665.git.moinejf@free.fr> <6885089.l87kb3TNcV@avalon> <20140327123449.65584e93@armhf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-François,

Sorry for the late reply.

On Thursday 27 March 2014 12:34:49 Jean-Francois Moine wrote:
> On Wed, 26 Mar 2014 18:33:09 +0100 Laurent Pinchart wrote:
> > That could work in your case, but I don't really like that.
> > 
> > We need to describe the hardware topology, that might be the only point we
> > all agree on. There are various hardware topologies we need to support
> > with different levels of complexity, and several ways to describe them,
> > also with a wide range of complexities and features.
> > 
> > The more complex the hardware topology, the more complex its description
> > needs to be, and the more complex the code that will parse the
> > description and handle the hardware will be. I don't think there's any
> > doubt here.
>
> But also, the simpler is the topology and the simpler should be its
> description.

I wouldn't put it so strongly. I believe we can slightly relax our 
requirements regarding DT bindings complexity as long as drivers remain 
simple. There's of course no reason to use more complex bindings just for the 
sake of it.

> In your approach, the connections between endpoints are described in the
> components themselves, which makes hard for the DT maintainers to have a
> global understanding of the video subsystem.
> 
> Having the topology described in the master device is clearer, even if it is
> complex.

First of all, let's clarify what a "master device" is. In the "simple-video-
card" example you've proposed the master device is a logical device (with a DT 
node that has no corresponding hardware device). The second approach I can 
think of is to make the IP core that implements the CRTC (which I usually call 
display controller) be the master device. Let's note that the second case 
makes both the link and "global description" DT binding styles possible.

My concern with the "global description" bindings style is that the approach 
only applies to simple hardware and can't be generalized. Now, I'm not too 
concerned about using that approach for simple hardware and a link-based 
approach for more complex hardware. The "slave" components, however, need to 
use a single DT bindings style, regardless of the DT bindings used by the 
master device. That's why I believe we should try to standardize one DT 
bindings style for master devices, even if it results in a slightly more 
complex DT description than strictly needed in some cases.

> > A given device can be integrated in a wide variety of hardware with
> > different complexities. A driver can't thus always assume that the whole
> > composite display device will match a given class of topologies. This is
> > especially true for encoders and connectors, they can be hooked up
> > directly at the output of a very simple display controller, or can be
> > part of a very complex graph. Encoder and connector drivers can't assume
> > much about how they will be integrated. I want to avoid a situation where
> > using an HDMI encoder already supported in mainline with a different SoC
> > will result in having to rewrite the HDMI encoder driver.
> 
> The tda998x chips are simple enough for being used in many boards: one video
> input and one serial digital output. I don't see in which circumstance the
> driver should be rewritten.

It shouldn't, that's the whole point ;-) I wasn't talking about the tda998x 
only, but about encoder drivers in general. I have a display controller in a 
Renesas SoC that has two LVDS encoders that output LVDS signals out of the 
SoC. One LVDS port is connected to an LVDS panel (a connector from a DRM point 
of view), the second one to an LVDS receiver that outputs parallel RGB data to 
an HDMI encoder. The LVDS encoder can't thus assume any particular downstream 
topology and its driver thus can't create DRM encoder and connector instances. 
The same could be true for an HDMI encoder in theory, although an HDMI encoder 
connected on the same board directly to an HDMI decoder that outputs RGB data 
to a panel is probably a case that will be rarely seen in practice.

In the general case an encoder driver can't assume any specific upstream or 
downstream topology. As long as DRM can't expose the real hardware topology to 
userspace, someone needs to decide on how to map the hardware topology to the 
DRM topology exposed to userspace. Encoder drivers can't take that role and 
thus shouldn't create DRM encoder and connector instances themselves.

> > The story is a bit different for display controllers. While the hardware
> > topology outside (and sometimes inside as well) of the SoC can vary, a
> > display controller often approximately implies a given level of
> > complexity. A cheap SoC with a simple display controller will likely not
> > be used to drive a 4k display requiring 4 encoders running in parallel
> > for instance. While I also want to avoid having to make significant
> > changes to a display controller driver when using the SoC on a different
> > board, I believe the requirement can be slightly relaxed here, and the
> > display controller driver(s) can assume more about the hardware topology
> > than the encoder drivers.
> 
> I don't think that the display controllers or the encoders have to know
> about the topology. They have well-knwon specific functions and the way they
> are interconnected should not impact these functions. If that would be the
> case, they should offer a particular configuration interface to the master
> driver.

As explained above, part of the problem comes from the fact that we need to 
expose a logical topology to userspace that doesn't map 1:1 to the hardware 
topology. We can discuss whether or not this should be changed, but I believe 
that's out of scope. As we'll need to map logical encoders and connectors to 
real hardware in the foreseeable future we need a solution to that problem, 
and I believe the display controller should be in control of the mapping 
(possibly using helpers).

> > I've asked myself whether we needed a single, one-size-fits-them-all DT
> > representation of the hardware topology. The view of the world from an
> > external encoder point of view must not depend on the SoC it is hooked up
> > to (this would prevent using a single encoder driver with multiple SoCs),
> > which calls for at least some form of standardization. The topology
> > representation on the display controller side may vary from display
> > controller to display controller, but I believe this would just result in
> > code duplication and having to solve the same problem in multiple
> > drivers. For those reasons I believe that the OF graph proposal to
> > represent the display hardware topology would be a good choice. The
> > bindings are flexible enough to represent both simple and complex
> > hardware.
> 
> Your OF graph proposal is rather complex,

I agree it's slightly more complex than your simple-video-card proposal for 
simple hardware, but I don't see it as overly complex, as long as we can 
provide helper functions that moves the parsing complexity out of drivers (at 
least drivers for simple hardware).

> and it does not even indicate which way the data flows.

Please note that the OF graph DT bindings are not set in stone. If we need to 
indicate the data flow direction (and I assume we will need to at some point) 
that should just be discussed and implemented.

> > Now, I don't want to force all display device drivers to implement complex
> > code when they only need to support simple hardware and simple hardware
> > topologies. Not only would that be rightfully rejected, I would be among
> > the ones nack'ing that approach. My opinion is that this calls for the
> > creation of helpers to handle common cases. Several (possibly many)
> > display systems only need (or want) to support linear pipelines at their
> > output(s), made of a single encoder and a single connector. There's no
> > point in duplicating DT parsing or encoder/connector instantiation code
> > in several drivers in that case where helpers could be reused. Several
> > sets of helpers could support different kinds of topologies, with the
> > driver author selecting a set of helpers depending on the expected
> > hardware topology complexity.
> 
> I don't like this 'helper' notion. See below.
> 
> > We also need to decide on who (as in which driver) will be responsible for
> > binding all devices together. As DRM exposes a single device to userspace,
> > there needs to be a single driver that will perform front line handling of
> > the userspace API and delegate calls to the other drivers involved. I
> > believe it would be logical for that driver to also be in charge of
> > bindings the components together, as it will be the driver that delegate
> > calls to the components. For a similar reason I also believe that that
> > driver should also be the one in control of creating DRM encoders and DRM
> > connectors. The component drivers having only a narrow view of the device
> > they handle, they can't perform that task in a generic way and would thus
> > get tied to specific master drivers because of the assumptions they would
> > make.
> 
> I don't see why the encoders and connectors should be created by some
> external entity. They are declared in the DT or created by the board init,
> so, they exist at system startup time.

As explained above, the hardware encoders and connectors are declared in DT, 
but they don't map 1:1 to the logical encoders and connectors exposed by DRM 
to userspace.

Obviously, in some cases (and probably a majority of cases today), the mapping 
will be 1:1, and the DRM encoders and connectors could be created by the 
encoder drivers, but that won't scale to more complex hardware. The transition 
to DT is a disruption that I'd like to take as an opportunity to model things 
correctly. We *could* transition to DT by creating encoders and connectors in 
encoder drivers, but a second disruption will then be needed in the near 
future to transition to a model that can handle most hardware. The drm_bridge 
API was a first step in such a direction, and I think we should take it into 
account.

> > Whether the master driver is the CRTC driver or a separate driver that
> > binds standalone CRTCs, connectors and encoders doesn't in my opinion
> > change my above conclusions. Some SoCs could use a simple-video-card
> > driver like the one you've proposed, and others could implement a display
> > controller driver that would perform the same tasks for more complex
> > pipelines in addition to controlling the display controller's CRTC(s).
> > The simple-video-card driver would perform that same tasks as the helpers
> > I've previously talked about, so the two solutions are pretty similar,
> > and I don't see much added value in the general case in having a
> > simple-video-card driver compared to using helpers in the display
> > controller driver.
> 
> In fact, I wonder why there is not only one DRM driver. The global logic is
> always the same, and, actually, it is duplicated in each specific driver.

That's quite a good question, and I agree that several DRM drivers, especially 
drivers for embedded systems, are pretty similar in architecture.

The CRTC helpers are a pretty good example of an attempt to share common code 
between drivers. The Intel DRM driver used them, developers then realized that 
it made their life more difficult, and decided to implement the DRM API 
directly instead of using the helpers.

The devil is in the details. Architectures can seem similar, but subtle 
difference can make a common implementation not only complex and difficult to 
maintain (as changing it will impact all drivers), but also useless when it 
tries to cater for the needs of everybody. An abstraction for something that 
can't be abstracted is just pointless.

I'm all for sharing code. This should, in my opinion, be done by providing 
optional helpers that drivers can use. That's how the CRTC helpers work, 
that's how the V4L2 control framework and videobuf2 library work, and that 
allows drivers to provide their own implementation in the rare cases when the 
generic helpers are not good enough. I think simple helpers that work in 90% 
of the cases are much better than really complex helpers that would achieve a 
95% coverage only anyway.

Given that several embedded DRM drivers duplicate code it might be that a 
different set of CRTC helpers could be better for that class of hardware. If 
you want to experiment with you I'd be glad to discuss requirements and 
architectures.

> I had this approach in the gspca driver: one main driver and many specific
> subdrivers. Once, I even had the idea to convert your UVC driver into a
> gspca subdriver, but, at this time, I had too much work with the other
> webcams. Nevertheless, it would have been easy: all the required interfaces
> were (are still) present in the main gspca driver.

If you look into the details of the uvcvideo driver you'll find that it 
wouldn't be that easy. UVC is a special case in that its architecture is 
pretty different from the other webcam drivers. For instance the driver 
doesn't use the V4L2 control framework, as its needs regarding controls are 
quite special. I've discussed this with Hans Verkuil and we've concluded (at 
least for the time being) that implementing the features uvcvideo requires in 
the control framework would make the framework way too complex, just because 
of a single driver.

This is just a counterexample of course. It doesn't mean that code shouldn't 
be shared, quite the contrary.

> In the same order of idea, there is only one ALSA SoC driver, and you cannot
> say that the audio topology is less complex than the video one.

I can't really comment on that, I don't have enough knowledge of ALSA.

> When thinking about the unique DRM driver, there would no helper anymore:
> the driver would offer to each component the functions they need for working
> correctly.

That's where things get hairy. There will be one driver that won't fit in the 
model. There will then be two options: filling the framework with exceptions 
and corner cases for just one user, create a spaghetti mess in common code, or 
allowing drivers to opt-out. I'm a strong believer in the second option. For 
the sake of completeness I want to mention the third option, which is to make 
the framework so thin that in becomes a wrapper that mostly translates 
function calls 1:1, which is pretty useless.

We're getting out of scope here though. I'd be happy to continue discussing 
the single DRM driver with you, but let's do so in a separate mail thread 
then.

> > The point that matters to me is that encoders DT bindings and drivers must
> > be identical regardless of whether the master driver is the display
> > controller driver or a driver for a logical composite device. For all
> > those reasons we should use the OF graph DT bindings for the
> > simple-video-card driver should we decide to implement it, and we should
> > create DRM encoders and connectors in the master driver, not in the
> > encoder drivers.
> 
> Sorry, but I think that a DRM encoder is the hardware encoder. What else
> could it be?

As explained above, a DRM encoder is a logical entity that usually corresponds 
to a hardware encoder, but that can also correspond to several encoders 
chained (sometimes using the drm_bridge abstraction, but not always).

> At initialization time, the master driver has only to manage the relation
> between the video components. It has not to create entities which already
> exist. So my preferred scheme is:
> 
> - at starting time, each video component initializes its software and
>   hardware, and then, plugs itself into the DRM driver.
> 
> - from the central video topology, the DRM device waits for all
>   components to be plugged and then it links the components together,
>   creating the user's view of the system.

So far I agree with you, but I believe this calls for an in-kernel view of the 
components possibly different than the drm_encoder and drm_connector objects.
 
> If you create the encoders and connectors in the DRM master, the hardware
> encoder and connector devices are just like zombies. They must put something
> in the system to say they are here and they must also have a callback
> function for them to know to which video subsystem they belong.
>
> On the contrary, if the DRM encoders and connectors are created by the
> hardware devices, they are immediately alive and operational.

-- 
Regards,

Laurent Pinchart

