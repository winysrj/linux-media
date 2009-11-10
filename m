Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51657 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909AbZKJXNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 18:13:51 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
	Atanas Filipov <afilipov@mm-sol.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Tue, 10 Nov 2009 17:13:42 -0600
Subject: RE: OMAP 3 ISP and N900 sensor driver update
Message-ID: <A69FA2915331DC488A831521EAE36FE401559364D6@dlee06.ent.ti.com>
References: <4AF41BDE.4040908@maxwell.research.nokia.com>
 <A69FA2915331DC488A831521EAE36FE401558AB44B@dlee06.ent.ti.com>
 <200911091506.27980.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200911091506.27980.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I have also copied Vaibhav from TI in this email since this is 
of interesting to his area of work as well.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>>
>> Who is working on the CCDC driver for OMAP35xx?
>
>Just for the sake of correctness, we're working on an OMAP34xx, not an
>OMAP35xx. I don't think that makes a big difference though.
>

That is right!

>As far as I know nobody on our side is currently working on the CCDC driver.
>We're focusing on the previewer and resizer first.
>
>> After a week or so, I need to start migrating the CCDC driver to sub
>device
>> interface so that application can directly configure the parameters with
>out
>> having to go through video node. Ultimately it is expected that ccdc will
>> have a device node that will allow application to open the device and
>> configure the parameters (in the context of Media controller). But to
>begin
>> with I intend to port the existing CCDC driver for DM6446 and DM355 to
>sub
>> device interface. Since the VPFE IPs are common across DM6446 & OMAP 35xx,
>> we could use a common sub device across both platforms.
>
>Coordinating our efforts on that front would indeed be very nice.
>

Ok.

>> So I this context, could you please update me on the CCDC development
>> on OMAP platform that you work?
>
>I haven't checked the Davinci VPFE drivers recently. I suppose they already
>use the v4l2_subdev interface for their I2C sensors and tuners. If not,
>that
>would be the first step.



Yes.

The vpfe drivers defines all sub device configuration data in the platform
specific code and use that information to load up sub devices. Example
tvp514x is loaded by vpfe capture driver and also mt9t031.


>
>On the OMAP34xx platform, the ISP driver is already somehow separated from
>the
>omap34xxcam driver, although not nicely. In a nutshell, here's the current
>plan. Parts 1 and 2 are already implemented and code is available in
>Sakari's
>linux-omap tree.
>


I will check this out some time next week as I am currently tied up with
internal release deadline.


>1. Board code registers an omap34xxcam platform device. The platform data
>contains an array of v4l2_subdev_i2c_board_info structures filled with
>information about all I2C sub-devices (sensor, flash controller, lens
>controller, ...).
>

vpfe capture does similar things.


>2. The omap34xxcam driver is loaded. Its probe function is called with a
>pointer to the platform device. The driver registers a v4l2_device and
>creates
>I2C subdevices using the data supplied through platform data.
>

vpfe capture does similar things.. The vpfe capture is already part of the
v4l2 sub system. You can find the code under /drivers/media/video/davinci

>3. The omap34xxcam driver calls the ISP core with a pointer to the
>v4l2_device
>structure to register all ISP subdevices. The ISP core maintains pointers
>to
>the ISP subdevices.


I was thinking in similar lines. We could define configuration for the ISP sub devices in the platform code. For example, register IO space for each IP (Preview Engine, Resizer, H3A etc) can be configured at platform level. But how is the sub device operations invoked from the camera driver? Are there wrapper functions in ISP core for each of the operations? 

>
>As ISP submodules (CCDC, previewer, resizer) are not truly independent, we
>were not planning to split them into separate kernel modules. The ISP core
>needs to call explicitly into the submodules for instance to dispatch
>interrupts.
>

IMO, to re-use, we need to define common operations across all of the
ISP sub modules (ccdc ops, resizer ops, preview-ops etc) since at hight
level hardware provide similar functions . I am assuming ISP core is a glue layer that load up all of the ISP sub devices and provide function calls to set format, get format, etc, right? Currently vpfe capture is interfaced
to ccdc modules through an interface (ccdc_hw_if.h). I am planning to
convert it to a sub device. In that case, ccdc along with other sub modules
will be loaded up by a vpfe core similar to ISP core. So by standardizing on
common operations, we could re-use the IP (sub device) across VPFE and OMAP. 
I will investigate the OMAP tree that Sakari maintains before starting my
development. Also the Resizer and Preview Engine will have to be used for
memory to memory operation as well. So re-use from that perspective is needed as well. There was an RFC for this from Samsung recently. Did you
have a chance to review this?

>It should be possible to use a single CCDC code base across multiple
>platforms. The ISP core module would depend on the CCDC module directly.
>I'm
>not sure how the CCDC module should be called though. An omap prefix won't
>work, as it's used on Davinci as well, and an ISP prefix is too generic. Do
>you have any internal code name for the ISP device used on Davinci and OMAP
>platforms ?

The ISP is called VPFE in DaVinci. In our internal release, we call it imp
(short for image pipeline). We use the name dm6446_ccdc and dm355_ccdc for
vpfe capture drivers. Different hardware name for the same IP has put us into this trouble :). omap34xx_dm644x_ccdc.c is a big name to consider. Or simply choose one name omap_34xx.c or dm644x_ccdc.c and document the IP's supported in the KConfig config variable description as well driver file header.

>
>The code will be pushed to linux-omap when available, but I can't commit to
>any deadline. If you start working on the Davinci driver before we post
>anything, could you please post patches and/or RFCs on the linux-media
>mailing
>list (and CC'ing us) ? Confronting our ideas as soon as possible will
>(hopefully) avoid diverging too much in our implementations.

Yes. will do.

>
>--
>Regards,
>
>Laurent Pinchart

