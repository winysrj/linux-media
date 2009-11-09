Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:40794 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbZKIOFz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 09:05:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: OMAP 3 ISP and N900 sensor driver update
Date: Mon, 9 Nov 2009 15:06:27 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	=?iso-8859-1?q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	"talvala@stanford.edu" <talvala@stanford.edu>,
	"Aguirre, Sergio" <saaguirre@ti.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Stan Varbanov <svarbanov@mm-sol.com>,
	Valeri Ivanov <vivanov@mm-sol.com>,
	Atanas Filipov <afilipov@mm-sol.com>
References: <4AF41BDE.4040908@maxwell.research.nokia.com> <A69FA2915331DC488A831521EAE36FE401558AB44B@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401558AB44B@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091506.27980.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Murali,

On Friday 06 November 2009 16:25:01 Karicheri, Muralidharan wrote:
> Sakari,
> 
> Thanks for the update...
> 
> Who is working on the CCDC driver for OMAP35xx?

Just for the sake of correctness, we're working on an OMAP34xx, not an 
OMAP35xx. I don't think that makes a big difference though.

As far as I know nobody on our side is currently working on the CCDC driver. 
We're focusing on the previewer and resizer first.

> After a week or so, I need to start migrating the CCDC driver to sub device
> interface so that application can directly configure the parameters with out
> having to go through video node. Ultimately it is expected that ccdc will
> have a device node that will allow application to open the device and
> configure the parameters (in the context of Media controller). But to begin
> with I intend to port the existing CCDC driver for DM6446 and DM355 to sub
> device interface. Since the VPFE IPs are common across DM6446 & OMAP 35xx,
> we could use a common sub device across both platforms.

Coordinating our efforts on that front would indeed be very nice.

> So I this context, could you please update me on the CCDC development
> on OMAP platform that you work?

I haven't checked the Davinci VPFE drivers recently. I suppose they already 
use the v4l2_subdev interface for their I2C sensors and tuners. If not, that 
would be the first step.

On the OMAP34xx platform, the ISP driver is already somehow separated from the 
omap34xxcam driver, although not nicely. In a nutshell, here's the current 
plan. Parts 1 and 2 are already implemented and code is available in Sakari's 
linux-omap tree.

1. Board code registers an omap34xxcam platform device. The platform data 
contains an array of v4l2_subdev_i2c_board_info structures filled with 
information about all I2C sub-devices (sensor, flash controller, lens 
controller, ...).

2. The omap34xxcam driver is loaded. Its probe function is called with a 
pointer to the platform device. The driver registers a v4l2_device and creates 
I2C subdevices using the data supplied through platform data.

3. The omap34xxcam driver calls the ISP core with a pointer to the v4l2_device 
structure to register all ISP subdevices. The ISP core maintains pointers to 
the ISP subdevices.

As ISP submodules (CCDC, previewer, resizer) are not truly independent, we 
were not planning to split them into separate kernel modules. The ISP core 
needs to call explicitly into the submodules for instance to dispatch 
interrupts.

It should be possible to use a single CCDC code base across multiple 
platforms. The ISP core module would depend on the CCDC module directly. I'm 
not sure how the CCDC module should be called though. An omap prefix won't 
work, as it's used on Davinci as well, and an ISP prefix is too generic. Do 
you have any internal code name for the ISP device used on Davinci and OMAP 
platforms ?

The code will be pushed to linux-omap when available, but I can't commit to 
any deadline. If you start working on the Davinci driver before we post 
anything, could you please post patches and/or RFCs on the linux-media mailing 
list (and CC'ing us) ? Confronting our ideas as soon as possible will 
(hopefully) avoid diverging too much in our implementations.

-- 
Regards,

Laurent Pinchart
