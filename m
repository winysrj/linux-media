Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50630 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab2LQO52 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 09:57:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 17 Dec 2012 15:58:43 +0100
Message-ID: <2541365.P6Gsa5p3NZ@avalon>
In-Reply-To: <20121123195607.GA20990@avionic-0098.adnet.avionic-design.de>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <20121123195607.GA20990@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2988743.Jr5vB5y2I3"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2988743.Jr5vB5y2I3
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Thierry,

On Friday 23 November 2012 20:56:07 Thierry Reding wrote:
> On Thu, Nov 22, 2012 at 10:45:31PM +0100, Laurent Pinchart wrote:
> [...]
> 
> > Display entities are accessed by driver using notifiers. Any driver can
> > register a display entity notifier with the CDF, which then calls the
> > notifier when a matching display entity is registered. The reason for
> > this asynchronous mode of operation, compared to how drivers acquire
> > regulator or clock resources, is that the display entities can use
> > resources provided by the display driver. For instance a panel can be a
> > child of the DBI or DSI bus controlled by the display device, or use a
> > clock provided by that device. We can't defer the display device probe
> > until the panel is registered and also defer the panel device probe until
> > the display is registered. As most display drivers need to handle output
> > devices hotplug (HDMI monitors for instance), handling other display
> > entities through a notification system seemed to be the easiest solution.
> > 
> > Note that this brings a different issue after registration, as display
> > controller and display entity drivers would take a reference to each
> > other. Those circular references would make driver unloading impossible.
> > One possible solution to this problem would be to simulate an unplug event
> > for the display entity, to force the display driver to release the dislay
> > entities it uses. We would need a userspace API for that though. Better
> > solutions would of course be welcome.
> 
> Maybe I don't understand all of the underlying issues correctly, but a
> parent/child model would seem like a better solution to me. We discussed
> this back when designing the DT bindings for Tegra DRM and came to the
> conclusion that the output resource of the display controller (RGB,
> HDMI, DSI or TVO) was the most suitable candidate to be the parent of
> the panel or display attached to it. The reason for that decision was
> that it keeps the flow of data or addressing of nodes consistent. So the
> chain would look something like this (on Tegra):
> 
> 	CPU
> 	+-host1x
> 	  +-dc
> 	    +-rgb
> 	    | +-panel
> 	    +-hdmi
> 	      +-monitor
> 
> In a natural way this makes the output resource the master of the panel
> or display. From a programming point of view this becomes quite easy to
> implement and is very similar to how other busses like I2C or SPI are
> modelled. In device tree these would be represented as subnodes, while
> with platform data some kind of lookup could be done like for regulators
> or alternatively a board setup registration mechanism like what's in
> place for I2C or SPI.

That works well for panels that have a shared control and video bus (DBI, DSI) 
or only a video bus (DPI), but breaks when you need to support panels with 
separate control and video busses, such as panels with a parallel data bus and 
an I2C or SPI control bus.

Both Linux and DT have a tree-based device model. Devices can have a single 
parent, so you can't represent your panel as a child of both the video source 
and the control bus master. We have the exact same problem in V4L2 with I2C 
camera sensors that output video data on a separate parallel or serial bus, 
and we decided to handle the device as a child of its control bus master. This 
model makes usage of the Linux power management model easier (but not 
straightforward when power management dependencies exist across video busses, 
outside of the kernel device tree).

As the common display framework should handle both panels with common control 
and video busses and panels with separate busses in a similar fashion, DT 
bindings needs to reference the panel through a phandle, even though in some 
cases they could technically just be children of the display controller.

-- 
Regards,

Laurent Pinchart

--nextPart2988743.Jr5vB5y2I3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQzzMjAAoJEIkPb2GL7hl1JYQIAIQXvi0KWU7ltksU7wh3Su7H
f0y8EydbKgXxgs9ZY83GMpTwDpBdWZR6rLN+FuJejKiKhxZuVJ6tn00K2U+dY3KL
VZQW3qbmP0AXuYN67mRUiBnKdwsZi6ItyNwwJTYNwKW8i1QlLV+NMW0yfyebWyGK
edN3FS1kgrmckUBRy32oe2+krfhHqDq5y7f1wp86QEg9M7WjBsZ40pFRlGhHKUfD
JdUdQbQPg6UztfMaJ/WeNaVCCD2VH/9rhMRGLp5NDTpxA/dOXfMttSvl5C9WEx6e
et1EfjfyYmw30VTIJnCQpOgSZgDG6u9qAvXdswQ/2EqlLWWSb3lpxdOMhuKkZGI=
=y6qr
-----END PGP SIGNATURE-----

--nextPart2988743.Jr5vB5y2I3--

