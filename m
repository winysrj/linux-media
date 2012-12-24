Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55350 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2LXRIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 12:08:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
Cc: Dave Airlie <airlied@gmail.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Archit Taneja <archit@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Inki Dae <inki.dae@samsung.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Tom Gall <tom.gall@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	marcus.lorentzon@linaro.org
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 24 Dec 2012 18:09:29 +0100
Message-ID: <5538783.cf2rXfYmRW@avalon>
In-Reply-To: <50D047CF.2040904@stericsson.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <CAPM=9txFJzJ0haTyBnr8hEmmqNb+gSAyBno+Zs0Z-qvVMTwz9A@mail.gmail.com> <50D047CF.2040904@stericsson.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marcus,

On Tuesday 18 December 2012 11:39:11 Marcus Lorentzon wrote:
> On 12/18/2012 06:04 AM, Dave Airlie wrote:
> >> Many developers showed interest in the first RFC, and I've had the
> >> opportunity to discuss it with most of them. I would like to thank (in
> >> no particular order) Tomi Valkeinen for all the time he spend helping me
> >> to draft v2, Marcus Lorentzon for his useful input during Linaro Connect
> >> Q4 2012, and Linaro for inviting me to Connect and providing a venue to
> >> discuss this topic.
> > 
> > So this might be a bit off topic but this whole CDF triggered me
> > looking at stuff I generally avoid:
>
> I like the effort, right now it seems like x86 and arm display sub systems
> are quite different in terms of DRM driver (and HW) design. I think this is
> partly due to little information shared about these different architectures
> and ideas behind the choices made. I hope some discussion will light up both
> sides. And an early discussion will hopefully give you less pain when CDF
> drivers starts to get pushed your way.

On the topic of discussions, would anyone be interested in a 
BoF/brainstorming/whatever session during the FOSDEM ?

> > The biggest problem I'm having currently with the whole ARM graphics
> > and output world is the proliferation of platform drivers for every
> > little thing. The whole ordering of operations with respect to things
> > like suspend/resume or dynamic power management is going to be a real
> > nightmare if there are dependencies between the drivers. How do you
> > enforce ordering of s/r operations between all the various components?
> 
> Could you give an example? Personally I don't think it is that many. I
> might not have counted the plat devs in all arm drivers. But the STE one
> have one per HW IP block in the HW (1 DSS + 3 DSI encoder/formatters).
> Then of course there are all these panel devices. But I hope that when
> CDF is "finished" we will have DSI devices on the DSI bus and DBI
> devices on the DBI bus. I think most vendors have used platform devices
> for these since they normally can't be probed in a generic way. But as
> they are off SoC I feel this is not the best choice. And then many of
> the panels are I2C devices (control bus) and that I guess is similar to
> "x86" encoders/connectors?

Tomi Valkeinen proposed dropping the DSI and DBI busses in favor of the 
platform bus. Although I still believe that DSI and DBI busses would make 
sense, I agree that they don't provide much in terms of probing and power 
management. You can read the discussion at http://www.spinics.net/lists/linux-
fbdev/msg09250.html.

> Another part of the difference I feel is that in x86 a DRM device is
> most likely a PCI device, and as such has one huge driver for all IPs on
> that board. The closest thing we get to that in ARM is probably the DSS
> (collection of IPs on SoC, like 3D, 2D, display output, encoders). But
> it doesn't fell right to create a single driver for all these. And as
> you know often 3D is even from a separate vendor. All these lead up to a
> slight increase in the number of devices and drivers. Right way, I feel
> so, but you are welcome to show a better way.
> 
> > The other thing I'd like you guys to do is kill the idea of fbdev and
> > v4l drivers that are "shared" with the drm codebase, really just
> > implement fbdev and v4l on top of the drm layer, some people might
> > think this is some sort of maintainer thing, but really nothing else
> > makes sense, and having these shared display frameworks just to avoid
> > having using drm/kms drivers seems totally pointless. Fix the drm
> > fbdev emulation if an fbdev interface is needed. But creating a fourth
> > framework because our previous 3 frameworks didn't work out doesn't
> > seem like a situation I want to get behind too much.
> 
> I have no intention to use CDF outside KMS connector/encoder and I have
> not heard Laurent talk about this either.

I don't either. CDF will mostly target KMS connectors, and can also be used 
for KMS encoders. I have no plan to touch the CRTC.

> Personally I see CDF as "helpers" to create and reuse connector/encoder
> drivers between SoCs instead of each SoC do their own panel drivers (which
> would be about a hundred, times the number of supported SoCs). We probably
> need to discuss the connector/encoder mappings to CDF/panels.

That's a topic I was planning to discuss at some point. One of the issues is 
that the KMS model can only have 3 entities in the pipeline, while hardware 
pipelines (especially in the embedded world) could be made of 4 or more 
entities (such as CRTC -> DSI encoder -> DSI to HDMI converter -> HDMI 
connector). We might not have to expose all details to userspace, but we need 
mapping rules.

> But I think we need to flush out the higher level details like control bus
> vs. data bus vs. display entities. While I like the generic way of the
> display entities, I also like the pure bus/device/driver model without too
> many generalizations.
> Do you have any support in x86 world that could be compared to mobile
> phone DSI/DBI/DPI panels? That is, different encoder/lcd-driver chips
> between the on chip/cpu/SoC CRTC and the external LCD depending on
> product (mobile/netbook/...) or is it all HDMI/DP/LVDS etc on x86?
> And if you do, how do you model/setup/share all those in DRM driver? Or
> it is manageable (< 10) and not up in the hundreds of different
> encoders/lcd-drivers?

-- 
Regards,

Laurent Pinchart

