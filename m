Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58339 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab0CQPEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 11:04:54 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 17 Mar 2010 10:04:47 -0500
Subject: RE: [omap3camera] Camera bring-up on Zoom3 (OMAP3630)
Message-ID: <A24693684029E5489D1D202277BE894454137189@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE894453CC5C3F@dlee02.ent.ti.com>
 <201003162330.17454.laurent.pinchart@ideasonboard.com>
 <A24693684029E5489D1D202277BE894454137054@dlee02.ent.ti.com>
 <201003171514.27538.laurent.pinchart@ideasonboard.com>
 <4BA0E434.1040402@maxwell.research.nokia.com>
 <A24693684029E5489D1D202277BE8944541370C5@dlee02.ent.ti.com>
 <4BA0EE24.7030309@maxwell.research.nokia.com>
In-Reply-To: <4BA0EE24.7030309@maxwell.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@maxwell.research.nokia.com]
> Sent: Wednesday, March 17, 2010 9:59 AM
> To: Aguirre, Sergio
> Cc: Laurent Pinchart; linux-media@vger.kernel.org
> Subject: Re: [omap3camera] Camera bring-up on Zoom3 (OMAP3630)
> 
> Aguirre, Sergio wrote:
> >
> >
> >> -----Original Message-----
> >> From: Sakari Ailus [mailto:sakari.ailus@maxwell.research.nokia.com]
> >> Sent: Wednesday, March 17, 2010 9:16 AM
> >> To: Laurent Pinchart
> >> Cc: Aguirre, Sergio; linux-media@vger.kernel.org
> >> Subject: Re: [omap3camera] Camera bring-up on Zoom3 (OMAP3630)
> >>
> >> Laurent Pinchart wrote:
> >>>>>> I'm trying to get latest Sakari's tree (gitorious.org/omap3camera)
> >>>>>> 'devel' branch running on my Zoom3 HW (which has an OMAP3630, and a
> >>>>>> Sony IMX046 8MP sensor).
> >>>>>>
> >>>>>> I had first one NULL pointer dereference while the driver was
> >>>>>> registering devices and creating entities, which I resolved with
> >>>>>> the attached patch. (Is this patch acceptable, or maybe I am
> missing
> >>>>>> something...)
> >>>>>
> >>>>> Either that, or make OMAP34XXCAM_VIDEODEVS dynamic (the value would
> be
> >>>>> passed through platform data). The code will be removed (hopefully
> >> soon)
> >>>>> anyway when the legacy video nodes will disappear.
> >>>>
> >>>> Ok, so should I keep this patch only to myself until this code is
> >> removed?
> >>>
> >>> I'll let Sakari answer that, but I think they can still go in in the
> >> meantime.
> >>
> >> Is there a need for the patch? The other possible device is just left
> >> unused, right?
> >
> > There is need for it _if_ I don't change OMAP34XXCAM_VIDEODEVS in
> > drivers/media/video/omap34xxcam.h, and if I have less devices listed
> > in the platform data passed from the boardfile.
> >
> > In this case, OMAP34XXCAM_VIDEODEVS is hardcoded to N900 case, which is
> 2,
> > and I only have 1 sensor in my Zoom3.
> >
> > I guess the patch is just protecting for potential pointer
> dereferencing, unless we get rid of current OMAP34XXCAM_VIDEODEVS
> hardcoded value.
> 
> What exactly does not work?

Ok, let me explain:

In my boardfile, I have:

static struct omap34xxcam_platform_data zoom_camera_pdata = {
	.isp			= &omap3isp_device,
	.subdevs[0] = zoom_camera_primary_subdevs,
	.sensors[0] = {
		.capture_mem = IMX046_BIGGEST_FRAME_BYTE_SIZE * 2,
		.ival_default	= { 1, 10 },
	},
};

As I only have 1 sensor.

However, when omap34xxcam_probe runs, it loops through pdata->subdevs[i], in which 'i' goes from 0 to OMAP34XXCAM_VIDEODEVS - 1.

And this is what generates an "oops" message in the driver.

Regards,
Sergio

> 
> The video devices are registered dynamically based on the number of
> sensors available so in this case the second video device is not even
> registered.
> 
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
