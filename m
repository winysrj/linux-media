Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41868 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2LQQwf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 11:52:35 -0500
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-fbdev@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	dri-devel@lists.freedesktop.org, Rob Clark <rob.clark@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v2 0/5] Common Display Framework
In-Reply-To: <1608840.IleINgrx5J@avalon>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <50AF8D79.1070309@ti.com> <1608840.IleINgrx5J@avalon>
Date: Mon, 17 Dec 2012 18:53:37 +0200
Message-ID: <87pq28hb72.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Laurent -

On Mon, 17 Dec 2012, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> Hi Tomi,
>
> I finally have time to work on a v3 :-)
>
> On Friday 23 November 2012 16:51:37 Tomi Valkeinen wrote:
>> On 2012-11-22 23:45, Laurent Pinchart wrote:
>> > From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>> > 
>> > Hi everybody,
>> > 
>> > Here's the second RFC of what was previously known as the Generic Panel
>> > Framework.
>> 
>> Nice work! Thanks for working on this.
>> 
>> I was doing some testing with the code, seeing how to use it in omapdss.
>> Here are some thoughts:
>> 
>> In your model the DSS gets the panel devices connected to it from
>> platform data. After the DSS and the panel drivers are loaded, DSS gets
>> a notification and connects DSS and the panel.
>> 
>> I think it's a bit limited way. First of all, it'll make the DT data a
>> bit more complex (although this is not a major problem). With your
>> model, you'll need something like:
>> 
>> soc-base.dtsi:
>> 
>> dss {
>> 	dpi0: dpi {
>> 	};
>> };
>> 
>> board.dts:
>> 
>> &dpi0 {
>> 	panel = &dpi-panel;
>> };
>> 
>> / {
>> 	dpi-panel: dpi-panel {
>> 		...panel data...;
>> 	};
>> };
>> 
>> Second, it'll prevent hotplug, and even if real hotplug would not be
>> supported, it'll prevent cases where the connected panel must be found
>> dynamically (like reading ID from eeprom).
>
> Hotplug definitely needs to be supported, as the common display framework also 
> targets HDMI and DP. The notification mechanism was actually designed to 
> support hotplug.

I can see the need for a framework for DSI panels and such (in fact Tomi
and I have talked about it like 2-3 years ago already!) but what is the
story for HDMI and DP? In particular, what's the relationship between
DRM and CDF here? Is there a world domination plan to switch the DRM
drivers to use this framework too? ;) Do you have some rough plans how
DRM and CDF should work together in general?

BR,
Jani.


>
> How do you see the proposal preventing hotplug ?
>
>> Third, it kinda creates a cyclical dependency: the DSS needs to know
>> about the panel and calls ops in the panel, and the panel calls ops in
>> the DSS. I'm not sure if this is an actual problem, but I usually find
>> it simpler if calls are done only in one direction.
>
> I don't see any way around that. The panel is not a standalone entity that can 
> only receive calls (as it needs to control video streams, per your request 
> :-)) or only emit calls (as something needs to control it, userspace doesn't 
> control the panel directly).
>
>> What I suggest is take a simpler approach, something alike to how regulators
>> or gpios are used, even if slightly more complex than those: the entity that
>> has a video output (SoC's DSS, external chips) offers that video output as
>> resource. It doesn't know or care who uses it. The user of the video output
>> (panel, external chips) will find the video output (to which it is connected
>> in the HW) by some means, and will use different operations on that output
>> to operate the device.
>> 
>> This would give us something like the following DT data:
>> 
>> soc-base.dtsi:
>> 
>> dss {
>> 	dpi0: dpi {
>> 	};
>> };
>> 
>> board.dts:
>> 
>> / {
>> 	dpi-panel: dpi-panel {
>> 		source = <&dpi0>;
>> 		...panel data...;
>> 	};
>> };
>> 
>> The panel driver would do something like this in its probe:
>> 
>> int dpi_panel_probe()
>> {
>> 	// Find the video source, increase ref
>> 	src = get_video_source_from_of("source");
>> 
>> 	// Reserve the video source for us. others can still get and
>> 	// observe it, but cannot use it as video data source.
>> 	// I think this should cascade upstream, so that after this call
>> 	// each video entity from the panel to the SoC's CRTC is
>> 	// reserved and locked for this video pipeline.
>> 	reserve_video_source(src);
>> 
>> 	// set DPI HW configuration, like DPI data lines. The
>> 	// configuration would come from panel's platform data
>> 	set_dpi_config(src, config);
>> 
>> 	// register this panel as a display.
>> 	register_display(this);
>> }
>> 
>> 
>> The DSS's dpi driver would do something like:
>> 
>> int dss_dpi_probe()
>> {
>> 	// register as a DPI video source
>> 	register_video_source(this);
>> }
>> 
>> A DSI-2-DPI chip would do something like:
>> 
>> int dsi2dpi_probe()
>> {
>> 	// get, reserve and config the DSI bus from SoC
>> 	src = get_video_source_from_of("source");
>> 	reserve_video_source(src);
>> 	set_dsi_config(src, config);
>> 
>> 	// register as a DPI video source
>> 	register_video_source(this);
>> }
>> 
>> 
>> Here we wouldn't have similar display_entity as you have, but video sources
>> and displays. Video sources are elements in the video pipeline, and a video
>> source is used only by the next downstream element. The last element in the
>> pipeline would not be a video source, but a display, which would be used by
>> the upper layer.
>
> I don't think we should handle pure sources, pure sinks (displays) and mixed 
> entities (transceivers) differently. I prefer having abstract entities that 
> can have a source and a sink, and expose the corresponding operations. That 
> would make pipeline handling much easier, as the code will only need to deal 
> with a single type of object. Implementing support for entities with multiple 
> sinks and/or sources would also be possible.
>
>> Video source's ops would deal with things related to the video bus in
>> question, like configuring data lanes, sending DSI packets, etc. The
>> display ops would be more high level things, like enable, update, etc.
>> Actually, I guess you could consider the display to represent and deal
>> with the whole pipeline, while video source deals with the bus between
>> two display entities.
>
> What is missing in your proposal is an explanation of how the panel is 
> controlled. What does your register_display() function register the display 
> with, and what then calls the display operations ?
>
> -- 
> Regards,
>
> Laurent Pinchart
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
