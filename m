Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39713 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674AbZKKR0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 12:26:14 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?iso-8859-1?Q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	"talvala@stanford.edu" <talvala@stanford.edu>,
	"Aguirre, Sergio" <saaguirre@ti.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Stan Varbanov <svarbanov@mm-sol.com>,
	Valeri Ivanov <vivanov@mm-sol.com>,
	Atanas Filipov <afilipov@mm-sol.com>
Date: Wed, 11 Nov 2009 22:55:56 +0530
Subject: RE: OMAP 3 ISP and N900 sensor driver update
Message-ID: <19F8576C6E063C45BE387C64729E73940436F94663@dbde02.ent.ti.com>
References: <4AF41BDE.4040908@maxwell.research.nokia.com>
 <A69FA2915331DC488A831521EAE36FE401558AB44B@dlee06.ent.ti.com>
 <200911091506.27980.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200911091506.27980.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Monday, November 09, 2009 7:36 PM
> To: Karicheri, Muralidharan
> Cc: Sakari Ailus; linux-media@vger.kernel.org; Hans Verkuil; Cohen
> David Abraham; Koskipää Antti Jussi Petteri; Toivonen Tuukka Olli
> Artturi; Zutshi Vimarsh (Nokia-D-MSW/Helsinki);
> talvala@stanford.edu; Aguirre, Sergio; Ivan Ivanov; Stan Varbanov;
> Valeri Ivanov; Atanas Filipov
> Subject: Re: OMAP 3 ISP and N900 sensor driver update
> 
> Hi Murali,
> 
> On Friday 06 November 2009 16:25:01 Karicheri, Muralidharan wrote:
> > Sakari,
> >
> > Thanks for the update...
> >
> > Who is working on the CCDC driver for OMAP35xx?
> 
> Just for the sake of correctness, we're working on an OMAP34xx, not
> an
> OMAP35xx. I don't think that makes a big difference though.
> 
[Hiremath, Vaibhav] OMAP3430 and OMAP3530 are exactly same devices.

> As far as I know nobody on our side is currently working on the CCDC
> driver.
> We're focusing on the previewer and resizer first.
> 
[Hiremath, Vaibhav] I believe I should be able to see the current development activity on sakari's repo, right?

Thanks,
Vaibhav
> > After a week or so, I need to start migrating the CCDC driver to
> sub device
> > interface so that application can directly configure the
> parameters with out
> > having to go through video node. Ultimately it is expected that
> ccdc will
> > have a device node that will allow application to open the device
> and
> > configure the parameters (in the context of Media controller). But
> to begin
> > with I intend to port the existing CCDC driver for DM6446 and
> DM355 to sub
> > device interface. Since the VPFE IPs are common across DM6446 &
> OMAP 35xx,
> > we could use a common sub device across both platforms.
> 
> Coordinating our efforts on that front would indeed be very nice.
> 
> > So I this context, could you please update me on the CCDC
> development
> > on OMAP platform that you work?
> 
> I haven't checked the Davinci VPFE drivers recently. I suppose they
> already
> use the v4l2_subdev interface for their I2C sensors and tuners. If
> not, that
> would be the first step.
> 
> On the OMAP34xx platform, the ISP driver is already somehow
> separated from the
> omap34xxcam driver, although not nicely. In a nutshell, here's the
> current
> plan. Parts 1 and 2 are already implemented and code is available in
> Sakari's
> linux-omap tree.
> 
> 1. Board code registers an omap34xxcam platform device. The platform
> data
> contains an array of v4l2_subdev_i2c_board_info structures filled
> with
> information about all I2C sub-devices (sensor, flash controller,
> lens
> controller, ...).
> 
> 2. The omap34xxcam driver is loaded. Its probe function is called
> with a
> pointer to the platform device. The driver registers a v4l2_device
> and creates
> I2C subdevices using the data supplied through platform data.
> 
> 3. The omap34xxcam driver calls the ISP core with a pointer to the
> v4l2_device
> structure to register all ISP subdevices. The ISP core maintains
> pointers to
> the ISP subdevices.
> 
> As ISP submodules (CCDC, previewer, resizer) are not truly
> independent, we
> were not planning to split them into separate kernel modules. The
> ISP core
> needs to call explicitly into the submodules for instance to
> dispatch
> interrupts.
> 
> It should be possible to use a single CCDC code base across multiple
> platforms. The ISP core module would depend on the CCDC module
> directly. I'm
> not sure how the CCDC module should be called though. An omap prefix
> won't
> work, as it's used on Davinci as well, and an ISP prefix is too
> generic. Do
> you have any internal code name for the ISP device used on Davinci
> and OMAP
> platforms ?
> 
> The code will be pushed to linux-omap when available, but I can't
> commit to
> any deadline. If you start working on the Davinci driver before we
> post
> anything, could you please post patches and/or RFCs on the linux-
> media mailing
> list (and CC'ing us) ? Confronting our ideas as soon as possible
> will
> (hopefully) avoid diverging too much in our implementations.
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

