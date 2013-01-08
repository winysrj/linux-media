Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56069 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab3AHIQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 03:16:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: dri-devel@lists.freedesktop.org,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-fbdev@vger.kernel.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Clark <rob.clark@linaro.org>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	sunil joshi <joshi@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Tue, 08 Jan 2013 09:18:35 +0100
Message-ID: <3584709.mPLC5exzRY@avalon>
In-Reply-To: <2529718.glQX8guWfJ@amdc1227>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <3445117.L94DmxEvrl@avalon> <2529718.glQX8guWfJ@amdc1227>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thursday 27 December 2012 15:43:34 Tomasz Figa wrote:
> On Monday 24 of December 2012 15:12:28 Laurent Pinchart wrote:
> > On Friday 21 December 2012 11:00:52 Tomasz Figa wrote:
> > > On Tuesday 18 of December 2012 08:31:30 Vikas Sajjan wrote:
> > > > On 17 December 2012 20:55, Laurent Pinchart wrote:
> > > > > Hi Vikas,
> > > > > 
> > > > > Sorry for the late reply. I now have more time to work on CDF, so
> > > > > delays should be much shorter.
> > > > > 
> > > > > On Thursday 06 December 2012 10:51:15 Vikas Sajjan wrote:
> > > > > > Hi Laurent,
> > > > > > 
> > > > > > I was thinking of porting CDF to samsung EXYNOS 5250 platform,
> > > > > > what I found is that, the exynos display controller is MIPI DSI
> > > > > > based controller.
> > > > > > 
> > > > > > But if I look at CDF patches, it has only support for MIPI DBI
> > > > > > based Display controller.
> > > > > > 
> > > > > > So my question is, do we have any generic framework for MIPI DSI
> > > > > > based display controller? basically I wanted to know, how to go
> > > > > > about porting CDF for such kind of display controller.
> > > > > 
> > > > > MIPI DSI support is not available yet. The only reason for that is
> > > > > that I don't have any MIPI DSI hardware to write and test the code
> > > > > with :-)
> > > > > 
> > > > > The common display framework should definitely support MIPI DSI. I
> > > > > think the existing MIPI DBI code could be used as a base, so the
> > > > > implementation shouldn't be too high.
> > > > > 
> > > > > Yeah, i was also thinking in similar lines, below is my though for
> > > > > MIPI DSI support in CDF.
> > > > 
> > > > o   MIPI DSI support as part of CDF framework will expose
> > > > �  mipi_dsi_register_device(mpi_device) (will be called mach-xxx-dt.c
> > > > file )
> > > > �  mipi_dsi_register_driver(mipi_driver, bus ops) (will be called
> > > > from platform specific init driver call )
> > > > �    bus ops will be
> > > > o   read data
> > > > o   write data
> > > > o   write command
> > > > �  MIPI DSI will be registered as bus_register()
> > > > 
> > > > When MIPI DSI probe is called, it (e.g., Exynos or OMAP MIPI DSI)
> > > > will initialize the MIPI DSI HW IP.
> > > > 
> > > > This probe will also parse the DT file for MIPI DSI based panel, add
> > > > the panel device (device_add() ) to kernel and register the display
> > > > entity with its control and  video ops with CDF.
> > > > 
> > > > I can give this a try.
> > > 
> > > I am currently in progress of reworking Exynos MIPI DSIM code and
> > > s6e8ax0 LCD driver to use the v2 RFC of Common Display Framework. I
> > > have most of the work done, I have just to solve several remaining
> > > problems.
> > 
> > Do you already have code that you can publish ? I'm particularly
> > interested (and I think Tomi Valkeinen would be as well) in looking at
> > the DSI operations you expose to DSI sinks (panels, transceivers, ...).
> 
> Well, I'm afraid this might be little below your expectations, but here's
> an initial RFC of the part defining just the DSI bus. I need a bit more
> time for patches for Exynos MIPI DSI master and s6e8ax0 LCD.

No worries. I was particularly interested in the DSI operations you needed to 
export, they seem pretty simple. Thank you for sharing the code.

> The implementation is very simple and heavily based on your MIPI DBI
> support and existing Exynos MIPI DSIM framework. Provided operation set is
> based on operation set used by Exynos s6e8ax0 LCD driver. Unfortunately
> this is my only source of information about MIPI DSI.

-- 
Regards,

Laurent Pinchart

