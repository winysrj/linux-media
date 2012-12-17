Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35682 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2LQXRF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 18:17:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Inki Dae <inki.dae@samsung.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Tom Gall <tom.gall@linaro.org>,
	Vikas Sajjan <vikas.sajjan@linaro.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Tue, 18 Dec 2012 00:18:09 +0100
Message-ID: <2444442.ku5goVfJzU@avalon>
In-Reply-To: <50CF3A4B.8030206@ti.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <1608840.IleINgrx5J@avalon> <50CF3A4B.8030206@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2808594.DcTk7mbcg3"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2808594.DcTk7mbcg3
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Monday 17 December 2012 17:29:15 Tomi Valkeinen wrote:
> On 2012-12-17 16:36, Laurent Pinchart wrote:
> > On Friday 23 November 2012 16:51:37 Tomi Valkeinen wrote:
> >> On 2012-11-22 23:45, Laurent Pinchart wrote:
> >>> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> >>> 
> >>> Hi everybody,
> >>> 
> >>> Here's the second RFC of what was previously known as the Generic Panel
> >>> Framework.
> >> 
> >> Nice work! Thanks for working on this.
> >> 
> >> I was doing some testing with the code, seeing how to use it in omapdss.
> >> Here are some thoughts:
> >> 
> >> In your model the DSS gets the panel devices connected to it from
> >> platform data. After the DSS and the panel drivers are loaded, DSS gets
> >> a notification and connects DSS and the panel.
> >> 
> >> I think it's a bit limited way. First of all, it'll make the DT data a
> >> bit more complex (although this is not a major problem). With your
> >> model, you'll need something like:
> >> 
> >> soc-base.dtsi:
> >> 
> >> dss {
> >> 	dpi0: dpi {
> >> 	};
> >> };
> >> 
> >> board.dts:
> >> 
> >> &dpi0 {
> >> 	panel = &dpi-panel;
> >> };
> >> 
> >> / {
> >> 	dpi-panel: dpi-panel {
> >> 		...panel data...;
> >> 	};
> >> };
> >> 
> >> Second, it'll prevent hotplug, and even if real hotplug would not be
> >> supported, it'll prevent cases where the connected panel must be found
> >> dynamically (like reading ID from eeprom).
> > 
> > Hotplug definitely needs to be supported, as the common display framework
> > also targets HDMI and DP. The notification mechanism was actually
> > designed to support hotplug.
> 
> HDMI or DP hotplug may or may not be a different thing than what I talk
> about here. We may have two kinds of hotplug: real linux device hotplug,
> i.e. a linux device appears or is removed during runtime, or just a cable
> hotplug, handled inside a driver, which doesn't have any effect on the linux
> devices.
> 
> If we do implement HDMI and DP monitors with real linux drivers, then yes,
> we could use real hotplug. But we could as well have the monitor driver
> always registered, and just have a driver internal cable-hotplug system.
>
> To be honest, I'm not sure if implementing real hotplug is easily possible,
> as we don't have real, probable (probe-able =) busses. So even if we'd get a
> hotplug event of a new display device, what kind of device would the bus
> master register? It has no way to know that.

I get your point.

My design goal is to handle both HDMI/DP and panels through a single hotplug 
interface. I believe it would be simpler for display controller drivers to 
handle all display entities with a common API instead of implementing support 
for HDMI/DP and panels separately. This would require real HDMI and DP monitor 
drivers. I share your concern, I don't know whether this can work in the end, 
the only way to find out will be to try it.

> > How do you see the proposal preventing hotplug ?
> 
> Well, probably it doesn't prevent. But it doesn't feel right to me.
> 
> Say, if we have a DPI panel, controlled via foo-bus, which has a probing
> mechanism. When the foo-bus master detects a new hardware device, it'll
> create linux device for it. The driver for this device will then be probed.

That's correct. That's how Linux handles devices, and I don't think we should 
diverge from that model without a very good reason to do so. In my 
understanding you agree with me here, could you please confirm that ?

> In the probe function it should somehow register itself to the cdf, or
> perhaps the previous entity in the chain.

The panel driver would register the panel device to CDF in its probe function. 
>From a panel point of view I think we agree that two sets of operations exist.

- The panel control operations are called by an upper layer component (let's 
call it A) to control the panel (retrieve the list of modes, enable the panel, 
...). That upper layer component will usually call the panel in response to a 
userspace request (that can go through several layers in the kernel before 
reaching the panel), but can also call it in response to a hotplug event, 
without userspace being involved.

- The panel calls video operations of the entity that provides it with a video 
stream (the video source entity, let's call it B) to configure and control the 
video bus.

A and B could be implemented in the same driver or in two separate drivers, 
but at the end of the day I don't think that matters much. A needs a reference 
to the panel, and the panel needs a reference to B, that's all we need to 
provide, regardless of whether A and B come from the same kernel module or 
not.

> This sounds to me that the link is from the panel to the previous entity,
> not the other way around as you describe, and also the previous entity
> doesn't know of the panel entities.

The data flows from the video source to the panel (I'm 100% confident that we 
agree on that :-)), and the video source is controlled by the panel as per 
your request. The link is thus from the video source to the panel, but is 
controlled by the sink, not the source.

> >> Third, it kinda creates a cyclical dependency: the DSS needs to know
> >> about the panel and calls ops in the panel, and the panel calls ops in
> >> the DSS. I'm not sure if this is an actual problem, but I usually find
> >> it simpler if calls are done only in one direction.
> > 
> > I don't see any way around that. The panel is not a standalone entity that
> > can only receive calls (as it needs to control video streams, per your
> > request :-)) or only emit calls (as something needs to control it,
> > userspace doesn't control the panel directly).
> 
> Right, but as I see it, the destination of the panel's calls, and the source
> of the calls to panel are different things. The destination is the bus
> layer, dealing with the video signal being transferred. The source is a bit
> higher level thing, something that's controlling the display in general.

That's correct. They can both be implemented in the same driver, but they're 
different logical entities. (I actually think they should be implemented in 
the same driver, but that's not very relevant here.)

> >> Here we wouldn't have similar display_entity as you have, but video
> >> sources and displays. Video sources are elements in the video pipeline,
> >> and a video source is used only by the next downstream element. The last
> >> element in the pipeline would not be a video source, but a display, which
> >> would be used by the upper layer.
> > 
> > I don't think we should handle pure sources, pure sinks (displays) and
> > mixed entities (transceivers) differently. I prefer having abstract
> > entities that can have a source and a sink, and expose the corresponding
> > operations. That would make pipeline handling much easier, as the code
> > will only need to deal with a single type of object. Implementing support
> > for entities with multiple sinks and/or sources would also be possible.
> 
> Ok. I think having pure sources is simpler model, but it's true that if
> we need to iterate and study the pipeline during runtime, it's probably
> better to have single entities with multiple sources/sinks.

A pure source is an entity with a source pad only that only exposes source pad 
operations, I think the complexity to handle them from the panel point of view 
would roughly be the same (there might be an extra argument to a couple of 
functions with a pad number, but that's more or less it).

> >> Video source's ops would deal with things related to the video bus in
> >> question, like configuring data lanes, sending DSI packets, etc. The
> >> display ops would be more high level things, like enable, update, etc.
> >> Actually, I guess you could consider the display to represent and deal
> >> with the whole pipeline, while video source deals with the bus between
> >> two display entities.
> > 
> > What is missing in your proposal is an explanation of how the panel is
> > controlled. What does your register_display() function register the
> > display with, and what then calls the display operations ?
> 
> In my particular case, the omapfb calls the display operations, which is
> the higher level "manager" for the whole display. So omapfb does calls
> both to the DSS side and to the panel side of the pipeline.
> 
> I agree that making calls to both ends is a bit silly, but then again, I
> think it also happens in your model, it's just hidden there.

That's probably the biggest difference between our models. Let's discuss it 
face to face tomorrow and hopefully come up with an agreement.

-- 
Regards,

Laurent Pinchart

--nextPart2808594.DcTk7mbcg3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQz6g9AAoJEIkPb2GL7hl1LNMH/2UQ00BW9saMUhrTUe5Ue+hp
rUKN4MQdoakAolEv/tsluk63iWnznMS8QN5UJ051CUuHy1KSvJwrLn5+cnTfSMpD
AvFPMlT6/QqvshwGdC+TtaUS5k/X8bLOt2dy+6iX038yZwgq0Iy0DiK64Az4GkLQ
3jPaxfeGhIas973WsZqtvh/hiPempgXZ1u+IebWsTAO1zT3CwsYcW6oj3h7qDBS6
xpttGPGzbrrBHCDZRJifnVWwG2wsxO1h3Jpl0aqBr8KHMoNEPblQ6CdQIXNdHP3+
LqpEPJM0uSeBsCGRL9oRiVsDIv8jihbDEzUeGZh/+43aOxn/+WXQPXEEtAfe00g=
=PrKT
-----END PGP SIGNATURE-----

--nextPart2808594.DcTk7mbcg3--

