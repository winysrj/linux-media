Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:51107 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaC0LeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Mar 2014 07:34:16 -0400
Date: Thu, 27 Mar 2014 12:34:49 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Rob Clark <robdclark@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/6] drm/i2c: tda998x: Move tda998x to a couple
 encoder/connector
Message-ID: <20140327123449.65584e93@armhf>
In-Reply-To: <6885089.l87kb3TNcV@avalon>
References: <cover.1395397665.git.moinejf@free.fr>
	<1458827.cQ6aDWdh1W@avalon>
	<20140325165548.0065b639@armhf>
	<6885089.l87kb3TNcV@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, 26 Mar 2014 18:33:09 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> That could work in your case, but I don't really like that.
> 
> We need to describe the hardware topology, that might be the only point we all 
> agree on. There are various hardware topologies we need to support with 
> different levels of complexity, and several ways to describe them, also with a 
> wide range of complexities and features.
> 
> The more complex the hardware topology, the more complex its description needs 
> to be, and the more complex the code that will parse the description and 
> handle the hardware will be. I don't think there's any doubt here.

But also, the simpler is the topology and the simpler should be its
description.

In your approach, the connections between endpoints are described in
the components themselves, which makes hard for the DT maintainers to
have a global understanding of the video subsystem.

Having the topology described in the master device is clearer, even if
it is complex.

> A given device can be integrated in a wide variety of hardware with different 
> complexities. A driver can't thus always assume that the whole composite 
> display device will match a given class of topologies. This is especially true 
> for encoders and connectors, they can be hooked up directly at the output of a 
> very simple display controller, or can be part of a very complex graph. 
> Encoder and connector drivers can't assume much about how they will be 
> integrated. I want to avoid a situation where using an HDMI encoder already 
> supported in mainline with a different SoC will result in having to rewrite 
> the HDMI encoder driver.

The tda998x chips are simple enough for being used in many boards: one
video input and one serial digital output. I don't see in which
circumstance the driver should be rewritten.

> The story is a bit different for display controllers. While the hardware 
> topology outside (and sometimes inside as well) of the SoC can vary, a display 
> controller often approximately implies a given level of complexity. A cheap 
> SoC with a simple display controller will likely not be used to drive a 4k 
> display requiring 4 encoders running in parallel for instance. While I also 
> want to avoid having to make significant changes to a display controller 
> driver when using the SoC on a different board, I believe the requirement can 
> be slightly relaxed here, and the display controller driver(s) can assume more 
> about the hardware topology than the encoder drivers.

I don't think that the display controllers or the encoders have to know
about the topology. They have well-knwon specific functions and the way
they are interconnected should not impact these functions. If that
would be the case, they should offer a particular configuration
interface to the master driver.

> I've asked myself whether we needed a single, one-size-fits-them-all DT 
> representation of the hardware topology. The view of the world from an 
> external encoder point of view must not depend on the SoC it is hooked up to 
> (this would prevent using a single encoder driver with multiple SoCs), which 
> calls for at least some form of standardization. The topology representation 
> on the display controller side may vary from display controller to display 
> controller, but I believe this would just result in code duplication and 
> having to solve the same problem in multiple drivers. For those reasons I 
> believe that the OF graph proposal to represent the display hardware topology 
> would be a good choice. The bindings are flexible enough to represent both 
> simple and complex hardware.

Your OF graph proposal is rather complex, and it does not even indicate
which way the data flows.

> Now, I don't want to force all display device drivers to implement complex 
> code when they only need to support simple hardware and simple hardware 
> topologies. Not only would that be rightfully rejected, I would be among the 
> ones nack'ing that approach. My opinion is that this calls for the creation of 
> helpers to handle common cases. Several (possibly many) display systems only 
> need (or want) to support linear pipelines at their output(s), made of a 
> single encoder and a single connector. There's no point in duplicating DT 
> parsing or encoder/connector instantiation code in several drivers in that 
> case where helpers could be reused. Several sets of helpers could support 
> different kinds of topologies, with the driver author selecting a set of 
> helpers depending on the expected hardware topology complexity.

I don't like this 'helper' notion. See below.

> We also need to decide on who (as in which driver) will be responsible for 
> binding all devices together. As DRM exposes a single device to userspace, 
> there needs to be a single driver that will perform front line handling of the 
> userspace API and delegate calls to the other drivers involved. I believe it 
> would be logical for that driver to also be in charge of bindings the 
> components together, as it will be the driver that delegate calls to the 
> components. For a similar reason I also believe that that driver should also 
> be the one in control of creating DRM encoders and DRM connectors. The 
> component drivers having only a narrow view of the device they handle, they 
> can't perform that task in a generic way and would thus get tied to specific 
> master drivers because of the assumptions they would make.

I don't see why the encoders and connectors should be created by some
external entity. They are declared in the DT or created by the board
init, so, they exist at system startup time.

> Whether the master driver is the CRTC driver or a separate driver that binds 
> standalone CRTCs, connectors and encoders doesn't in my opinion change my 
> above conclusions. Some SoCs could use a simple-video-card driver like the one 
> you've proposed, and others could implement a display controller driver that 
> would perform the same tasks for more complex pipelines in addition to 
> controlling the display controller's CRTC(s). The simple-video-card driver 
> would perform that same tasks as the helpers I've previously talked about, so 
> the two solutions are pretty similar, and I don't see much added value in the 
> general case in having a simple-video-card driver compared to using helpers in 
> the display controller driver.

In fact, I wonder why there is not only one DRM driver. The global
logic is always the same, and, actually, it is duplicated in each
specific driver. I had this approach in the gspca driver: one main
driver and many specific subdrivers. Once, I even had the idea to
convert your UVC driver into a gspca subdriver, but, at this time, I
had too much work with the other webcams. Nevertheless, it would have
been easy: all the required interfaces were (are still) present in the
main gspca driver.

In the same order of idea, there is only one ALSA SoC driver, and you
cannot say that the audio topology is less complex than the video one.

When thinking about the unique DRM driver, there would no helper anymore:
the driver would offer to each component the functions they need for
working correctly.

> The point that matters to me is that encoders DT bindings and drivers must be 
> identical regardless of whether the master driver is the display controller 
> driver or a driver for a logical composite device. For all those reasons we 
> should use the OF graph DT bindings for the simple-video-card driver should we 
> decide to implement it, and we should create DRM encoders and connectors in 
> the master driver, not in the encoder drivers.

Sorry, but I think that a DRM encoder is the hardware encoder. What
else could it be? At initialization time, the master driver has only to
manage the relation between the video components. It has not to create
entities which already exist. So my preferred scheme is:

- at starting time, each video component initializes its software and
  hardware, and then, plugs itself into the DRM driver.

- from the central video topology, the DRM device waits for all
  components to be plugged and then it links the components together,
  creating the user's view of the system.

If you create the encoders and connectors in the DRM master, the
hardware encoder and connector devices are just like zombies. They must
put something in the system to say they are here and they must also
have a callback function for them to know to which video subsystem they
belong.

On the contrary, if the DRM encoders and connectors are created by the
hardware devices, they are immediately alive and operational.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
