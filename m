Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44336 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab2HQLJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 07:09:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC 0/5] Generic panel framework
Date: Fri, 17 Aug 2012 13:10 +0200
Message-ID: <15644929.x7ZB0fPYJx@avalon>
In-Reply-To: <1345192694.3158.49.camel@deskari>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com> <1345192694.3158.49.camel@deskari>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

Thanks a lot for the review.

On Friday 17 August 2012 11:38:14 Tomi Valkeinen wrote:
> On Fri, 2012-08-17 at 02:49 +0200, Laurent Pinchart wrote:
> > I will appreciate all reviews, comments, criticisms, ideas, remarks, ...
> > If
> 
> Oookay, where to start... ;)
> 
> A few cosmetic/general comments first.
> 
> I find the file naming a bit strange. You have panel.c, which is the
> core framework, panel-dbi.c, which is the DBI bus, panel-r61517.c, which
> is driver for r61517 panel...
> 
> Perhaps something in this direction (in order): panel-core.c,
> mipi-dbi-bus.c, panel-r61517.c?

That looks good to me. I'll then rename panel_dbi_* to mipi_dbi_*.

> And we probably end up with quite a lot of panel drivers, perhaps we should
> already divide these into separate directories, and then we wouldn't need to
> prefix each panel with "panel-" at all.

What kind of directory structure do you have in mind ? Panels are already 
isolated in drivers/video/panel/ so we could already ditch the panel- prefix 
in drivers.

Would you also create include/video/panel/ ?

> ---
> 
> Should we aim for DT only solution from the start? DT is the direction we
> are going, and I feel the older platform data stuff would be deprecated
> soon.

Don't forget about non-ARM architectures :-/ We need panel drivers for SH as 
well, which doesn't use DT. I don't think that would be a big issue, a DT-
compliant solution should be easy to use through board code and platform data 
as well.

> ---
> 
> Something missing from the intro is how this whole thing should be used.
> It doesn't help if we know how to turn on the panel, we also need to
> display something on it =). So I think some kind of diagram/example of
> how, say, drm would use this thing, and also how the SoC specific DBI
> bus driver would be done, would clarify things.

Of course. If I had all that information already I would have shared it :-) 
This is really a first RFC, my goal is to make sure that I'm going in the 
right direction.

> ---
> 
> We have discussed face to face about the different hardware setups and
> scenarios that we should support, but I'll list some of them here for
> others:
> 
> 1) We need to support chains of external display chips and panels. A
> simple example is a chip that takes DSI in, and outputs DPI. In that
> case we'd have a chain of SoC -> DSI2DPI -> DPI panel.
> 
> In final products I think two external devices is the maximum (at least
> I've never seen three devices in a row), but in theory and in
> development environments the chain can be arbitrarily long. Also the
> connections are not necessarily 1-to-1, but a device can take one input
> while it has two outputs, or a device can take two inputs.
> 
> Now, I think two external devices is a must requirement. I'm not sure if
> supporting more is an important requirement. However, if we support two
> devices, it could be that it's trivial to change the framework to
> support n devices.
> 
> 2) Panels and display chips are all but standard. They very often have
> their own sequences how to do things, have bugs, or implement some
> feature in slightly different way than some other panel. This is why the
> panel driver should be able to control or define the way things happen.
> 
> As an example, Sharp LQ043T1DG01 panel
> (www.sharpsme.com/download/LQ043T1DG01-SP-072106pdf). It is enabled with
> the following sequence:
> 
> - Enable VCC and AVDD regulators
> - Wait min 50ms
> - Enable full video stream (pck, syncs, pixels) from SoC
> - Wait min 0.5ms
> - Set DISP GPIO, which turns on the display panel
> 
> Here we could split the enabling of panel to two parts, prepare (in this
> case starts regulators and waits 50ms) and finish (wait 0.5ms and set
> DISP GPIO), and the upper layer would start the video stream in between.
> 
> I realize this could be done with the PANEL_ENABLE_* levels in your RFC,
> but I don't think the concepts quite match:
> 
> - PANEL_ENABLE_BLANK level is needed for "smart panels", as we need to
> configure them and send the initial frame at that operating level. With
> dummy panels there's really no such level, there's just one enable
> sequence that is always done right away.
> 
> - I find waiting at the beginning of a function very ugly (what are we
> waiting for?) and we'd need that when changing the panel to
> PANEL_ENABLE_ON level.
> 
> - It's still limited if the panel is a stranger one (see following
> example).
> 
> Consider the following theoretical panel enable example, taken to absurd
> level just to show the general problem:
> 
> - Enable regulators
> - Enable video stream
> - Wait 50ms
> - Disable video stream
> - Set enable GPIO
> - Enable video stream
> 
> This one would be rather impossible with the upper layer handling the
> enabling of the video stream. Thus I see that the panel driver needs to
> control the sequences, and the Sharp panel driver's enable would look
> something like:
> 
> regulator_enable(...);
> sleep();
> dpi_enable_video();
> sleep();
> gpip_set(..);

I have to admit I have no better solution to propose at the moment, even if I 
don't really like making the panel control the video stream. When several 
devices will be present in the chain all of them might have similar annoying 
requirements, and my feeling is that the resulting code will be quite messy. 
At the end of the day the only way to really find out is to write an 
implementation.

> Note that even with this model we still need the PANEL_ENABLE levels you
> have.
> 
> ---
> 
> I'm not sure I understand the panel unload problem you mentioned. Nobody
> should have direct references to the panel functions, so there shouldn't
> be any automatic references that would prevent module unloading. So when
> the user does rmmod panel-mypanel, the panel driver's remove will be
> called. It'll unregister itself from the panel framework, which causes
> notifications and the display driver will stop using the panel. After
> that nobody has pointers to the panel, and it can safely be unloaded.
> 
> It could cause some locking issues, though. First the panel's remove
> could take a lock, but the remove sequence would cause the display
> driver to call disable on the panel, which could again try to take the
> same lock...

We have two possible ways of calling panel operations, either directly (panel-
>bus->ops->enable(...)) or indirectly (panel_enable(...)).

The former is what V4L2 currently does with subdevs, and requires display 
drivers to hold a reference to the panel. The later can do without a direct 
reference only if we use a global lock, which is something I would like to 
avoid. A panel-wide lock wouldn't work, as the access function would need to 
take the lock on a panel instance that can be removed at any time.

Note that this issue is not specific to panels, V4L2 will need a solution as 
well when V4L2 subdevs will be instantiated from the DT.

-- 
Regards,

Laurent Pinchart

