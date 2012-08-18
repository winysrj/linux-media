Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48523 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2HRBQA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 21:16:00 -0400
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
Date: Sat, 18 Aug 2012 03:16:16 +0200
Message-ID: <4948190.AFNtaaFKXQ@avalon>
In-Reply-To: <1345203751.3158.99.camel@deskari>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com> <15644929.x7ZB0fPYJx@avalon> <1345203751.3158.99.camel@deskari>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On Friday 17 August 2012 14:42:31 Tomi Valkeinen wrote:
> On Fri, 2012-08-17 at 13:10 +0200, Laurent Pinchart wrote:
> > What kind of directory structure do you have in mind ? Panels are already
> > isolated in drivers/video/panel/ so we could already ditch the panel-
> > prefix in drivers.
> 
> The same directory also contains files for the framework and buses. But
> perhaps there's no need for additional directories if the amount of
> non-panel files is small. And you can easily see from the name that they
> are not panel drivers (e.g. mipi_dbi_bus.c).

I don't expect the directory to contain many non-panel files, so let's keep it 
as-is for now.

mipi-dbi-bus might not belong to include/video/panel/ though, as it can be 
used for non-panel devices (at least in theory). The future mipi-dsi-bus 
certainly will.

> > Would you also create include/video/panel/ ?
> 
> Perhaps that would be good. Well, having all the files prefixed with
> panel- is not bad as such, but just feel extra.
> 
> > > ---
> > > 
> > > Should we aim for DT only solution from the start? DT is the direction
> > > we are going, and I feel the older platform data stuff would be
> > > deprecated soon.
> > 
> > Don't forget about non-ARM architectures :-/ We need panel drivers for SH
> > as well, which doesn't use DT. I don't think that would be a big issue, a
> > DT- compliant solution should be easy to use through board code and
> > platform data as well.
> 
> I didn't forget about them as I didn't even think about them ;). I
> somehow had the impression that other architectures would also use DT,
> sooner or later. I could be mistaken, though.
> 
> And true, it's not a big issue to support both DT and non-DT versions,
> but I've been porting omap stuff for DT and keeping the old platform
> data stuff also there, and it just feels burdensome. For very simple
> panels it's easy, but when you've passing lots of parameters the code
> starts to get longer.
> 
> > > This one would be rather impossible with the upper layer handling the
> > > enabling of the video stream. Thus I see that the panel driver needs to
> > > control the sequences, and the Sharp panel driver's enable would look
> > > something like:
> > > 
> > > regulator_enable(...);
> > > sleep();
> > > dpi_enable_video();
> > > sleep();
> > > gpip_set(..);
> > 
> > I have to admit I have no better solution to propose at the moment, even
> > if I don't really like making the panel control the video stream. When
> > several devices will be present in the chain all of them might have
> > similar annoying requirements, and my feeling is that the resulting code
> > will be quite messy. At the end of the day the only way to really find
> > out is to write an implementation.
> 
> If we have a chain of devices, and each device uses the bus interface
> from the previous device in the chain, there shouldn't be a problem. In
> that model each device can handle the task however is best for it.
> 
> I think the problems come from the divided control we'll have. I mean,
> if the panel driver would decide itself what to send to its output, and
> it would provide the data (think of an i2c device), this would be very
> simple. And it actually is for things like configuration data etc, but
> not so for video stream.

Would you be able to send incremental patches on top of v2 to implement the 
solution you have in mind ? It would be neat if you could also implement mipi-
dsi-bus for the OMAP DSS and test the code with a real device :-)

> > > It could cause some locking issues, though. First the panel's remove
> > > could take a lock, but the remove sequence would cause the display
> > > driver to call disable on the panel, which could again try to take the
> > > same lock...
> > 
> > We have two possible ways of calling panel operations, either directly
> > (panel->bus->ops->enable(...)) or indirectly (panel_enable(...)).
> > 
> > The former is what V4L2 currently does with subdevs, and requires display
> > drivers to hold a reference to the panel. The later can do without a
> > direct reference only if we use a global lock, which is something I would
> > like to
> 
> Wouldn't panel_enable() just do the same panel->bus->ops->enable()
> anyway, and both require a panel reference? I don't see the difference.

Indeed, you're right. I'm not sure what I was thinking about.

> > avoid. A panel-wide lock wouldn't work, as the access function would need
> > to take the lock on a panel instance that can be removed at any time.
>
> Can't this be handled with some kind of get/put refcounting? If there's
> a ref, it can't be removed.

Trouble will come when the display driver will hold a reference to the panel, 
and the panel will hold a reference to the display driver (for instance 
because the display driver provides the DBI/DSI bus, or because it provides a 
clock used by the panel).

> Generally about locks, if we define that panel ops may only be called
> exclusively, does it simplify things? I think we can make such
> requirements, as there should be only one display framework that handles
> the panel. Then we don't need locking for things like enable/disable.

Pushing locking to callers would indeed simplify panel drivers, but we need to 
make sure we won't need to expose a panel to several callers in the future.

> Of course we need to be careful about things where calls come from
> "outside" the display framework. I guess one such thing is rmmod, but if
> that causes a notification to the display framework, which again handles
> locking, it shouldn't be a problem.
> 
> Another thing to be careful about is if the panel internally uses irqs,
> workqueues, sysfs files or such. In that case it needs to handle
> locking.

Of course panels will need to manage concurrency for their own infrastructure.

-- 
Regards,

Laurent Pinchart

