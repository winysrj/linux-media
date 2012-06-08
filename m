Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36269 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933882Ab2FHIsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 04:48:07 -0400
Date: Fri, 8 Jun 2012 10:48:02 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, kernel@pengutronix.de,
	Fabio Estevam <festevam@gmail.com>,
	linux-media@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
	Dirk Behme <dirk.behme@googlemail.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] Support for H.264/MPEG4 encoder (VPU) in i.MX27.
Message-ID: <20120608084802.GS30400@pengutronix.de>
References: <CACKLOr2jQMnBPTaTFOcfLN_9J1n39tLx-ffDcVGuZ4ZB-odYfg@mail.gmail.com>
 <20120608072601.GD30137@pengutronix.de>
 <CACKLOr1OShoEnLxs8BP6q2TyZrOH0oCnpbKZJqyAo-yXKck9Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr1OShoEnLxs8BP6q2TyZrOH0oCnpbKZJqyAo-yXKck9Zw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 08, 2012 at 09:39:15AM +0200, javier Martin wrote:
> Hi Robert,
> 
> On 8 June 2012 09:26, Robert Schwebel <r.schwebel@pengutronix.de> wrote:
> > Hi Javier,
> >
> > On Fri, Jun 08, 2012 at 09:21:13AM +0200, javier Martin wrote:
> >> If you refer to driver in [1] I have some concerns: i.MX27 VPU should
> >> be implemented as a V4L2 mem2mem device since it gets raw pictures
> >> from memory and outputs encoded frames to memory (some discussion
> >> about the subject can be fond here [2]), as Exynos driver from Samsung
> >> does. However, this driver you've mentioned doesn't do that: it just
> >> creates several mapping regions so that the actual functionality is
> >> implemented in user space by a library provided by Freescale, which
> >> regarding i.MX27 it is also GPL.
> >>
> >> What we are trying to do is implementing all the functionality in
> >> kernel space using mem2mem V4L2 framework so that it can be accepted
> >> in mainline.
> >
> > We will work on the VPU driver and it's migration towards a proper
> > mem2mem device very soon, mainly on MX53, but of course MX27 should be
> > taken care of by the same driver.
> >
> > So I'd suggest that we coordinate that work somehow.
> 
> Do you plan to provide both encoding and decoding support or just one of them?

We have both encoding and decoding. It works on i.MX51/53, but was
originally written for i.MX27 aswell. I haven't tested i.MX27 for longer
now, so it might or might not work. Find the source here:

git://git.pengutronix.de/git/imx/gst-plugins-fsl-vpu.git

The main difference from the FSL code is that the whole VPU
functionality is in a kernel module which talks (mostly) v4l2. Our next
taks is to convert this into a real mem2mem device, right now it only
works with the included gstreamer plugin. You'll need a small kernel
patch to register the device and to add the clocks.

The gstreamer plugin is in a horrible state, but with the conversion to
mem2mem we hope to get rid of this entirely.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
