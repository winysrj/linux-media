Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45892 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2LXM73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 07:59:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: Jesse Barker <jesse.barker@linaro.org>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-fbdev@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	dri-devel@lists.freedesktop.org, Rob Clark <rob.clark@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	linux-media@vger.kernel.org, sunil joshi <joshi@samsung.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 24 Dec 2012 14:00:52 +0100
Message-ID: <21195616.A64r85Hc5F@avalon>
In-Reply-To: <CAD025yQoCiNaKvaCwvUWhk_jV70CPhV35UzV9MR6HtE+1baCxg@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <3133576.BkqAl7V01U@avalon> <CAD025yQoCiNaKvaCwvUWhk_jV70CPhV35UzV9MR6HtE+1baCxg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikas,

On Tuesday 18 December 2012 08:31:30 Vikas Sajjan wrote:
> On 17 December 2012 20:55, Laurent Pinchart wrote:
> > Hi Vikas,
> > 
> > Sorry for the late reply. I now have more time to work on CDF, so delays
> > should be much shorter.
> > 
> > On Thursday 06 December 2012 10:51:15 Vikas Sajjan wrote:
> > > Hi Laurent,
> > > 
> > > I was thinking of porting CDF to samsung EXYNOS 5250 platform, what I
> > > found is that, the exynos display controller is MIPI DSI based
> > > controller.
> > > 
> > > But if I look at CDF patches, it has only support for MIPI DBI based
> > > Display controller.
> > > 
> > > So my question is, do we have any generic framework for MIPI DSI based
> > > display controller? basically I wanted to know, how to go about porting
> > > CDF for such kind of display controller.
> > 
> > MIPI DSI support is not available yet. The only reason for that is that I
> > don't have any MIPI DSI hardware to write and test the code with :-)
> > 
> > The common display framework should definitely support MIPI DSI. I think
> > the existing MIPI DBI code could be used as a base, so the implementation
> > shouldn't be too high.
> > 
> > Yeah, i was also thinking in similar lines, below is my though for MIPI
> > DSI support in CDF.
> 
> o MIPI DSI support as part of CDF framework will expose
>   § mipi_dsi_register_device(mpi_device) (will be called mach-xxx-dt.c
>     file)
>   § mipi_dsi_register_driver(mipi_driver, bus ops) (will be called from
>     platform specific init driver call )
>     · bus ops will be
>       o read data
>       o write data
>       o write command
>  § MIPI DSI will be registered as bus_register()
> 
> When MIPI DSI probe is called, it (e.g., Exynos or OMAP MIPI DSI) will
> initialize the MIPI DSI HW IP.
> 
> This probe will also parse the DT file for MIPI DSI based panel, add
> the panel device (device_add() ) to kernel and register the display
> entity with its control and  video ops with CDF.

After discussing the DBI/DSI busses with Tomi Valkeinen we concluded that 
creating a real bus for DBI and DSI, although possible, wasn't required. DSI 
operations should thus be provided through display entity video source 
operations. You can find a proposed implementation in Tomi's patch set.

> > I can give this a try. Does the existing Exynos 5250 driver support MIPI
> > DSI ? Is the device documentation publicly available ? Can you point me to
> > a MIPI DSI panel with public documentation (preferably with an existing
> > mainline driver if possible) ?
>
> yeah, existing Exynos 5250 driver support MIPI DSI ass well as eDP.
> 
>  i think device documentation is NOT available publicly.

-- 
Regards,

Laurent Pinchart

