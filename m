Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46794 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbaCRMkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 08:40:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@karo-electronics.de>
Cc: Andrzej Hajda <a.hajda@samsung.com>, devel@driverdev.osuosl.org,
	Russell King <linux@arm.linux.org.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Denis Carikli <denis@eukrea.com>,
	Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 07/12] drm: drm_display_mode: add signal polarity flags
Date: Tue, 18 Mar 2014 13:41:54 +0100
Message-ID: <1434295.j7EcSL7GQo@avalon>
In-Reply-To: <20140318085030.66db84b7@ipc1.ka-ro>
References: <1394731053-6118-1-git-send-email-denis@eukrea.com> <2777667.XJdaUSpRsD@avalon> <20140318085030.66db84b7@ipc1.ka-ro>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lothar,

On Tuesday 18 March 2014 08:50:30 Lothar Waßmann wrote:
> Laurent Pinchart wrote:
> > On Monday 17 March 2014 16:14:36 Lothar Waßmann wrote:
> > > Laurent Pinchart wrote:
> > > > On Monday 17 March 2014 14:41:09 Andrzej Hajda wrote:
> > > > > On 03/13/2014 06:17 PM, Denis Carikli wrote:
> > > > > > We need a way to pass signal polarity informations
> > > > > > between DRM panels, and the display drivers.
> > > > > > 
> > > > > > To do that, a pol_flags field was added to drm_display_mode.
> > > > > > 
> > > > > > Signed-off-by: Denis Carikli <denis@eukrea.com>
> > > > > > ---
> > > > > > ChangeLog v10->v11:
> > > > > > - Since the imx-drm won't be able to retrive its regulators
> > > > > > 
> > > > > >   from the device tree when using display-timings nodes,
> > > > > >   and that I was told that the drm simple-panel driver
> > > > > >   already supported that, I then, instead, added what was
> > > > > >   lacking to make the eukrea displays work with the
> > > > > >   drm-simple-panel driver.
> > > > > >   
> > > > > >   That required a way to get back the display polarity
> > > > > >   informations from the imx-drm driver without affecting
> > > > > >   userspace.
> > > > > > 
> > > > > > ---
> > > > > > 
> > > > > >  include/drm/drm_crtc.h |    8 ++++++++
> > > > > >  1 file changed, 8 insertions(+)
> > > > > > 
> > > > > > diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
> > > > > > index f764654..61a4fe1 100644
> > > > > > --- a/include/drm/drm_crtc.h
> > > > > > +++ b/include/drm/drm_crtc.h
> > > > > > @@ -131,6 +131,13 @@ enum drm_mode_status {
> > > > > > 
> > > > > >  #define DRM_MODE_FLAG_3D_MAX	DRM_MODE_FLAG_3D_SIDE_BY_SIDE_HALF
> > > > > > 
> > > > > > +#define DRM_MODE_FLAG_POL_PIXDATA_NEGEDGE	BIT(1)
> > > > > > +#define DRM_MODE_FLAG_POL_PIXDATA_POSEDGE	BIT(2)
> > > > > > +#define DRM_MODE_FLAG_POL_PIXDATA_PRESERVE	BIT(3)
> > > > > > +#define DRM_MODE_FLAG_POL_DE_NEGEDGE		BIT(4)
> > > > > > +#define DRM_MODE_FLAG_POL_DE_POSEDGE		BIT(5)
> > > > > > +#define DRM_MODE_FLAG_POL_DE_PRESERVE		BIT(6)
> > > > > 
> > > > > Could you add some description to these flags.
> > > > > What are *_PRESERVE flags for?
> > > > > Are those flags 1:1 compatible with respective 'videomode:flags'?
> > > > > I guess DE flags should be rather DRM_MODE_FLAG_POL_DE_(LOW|HIGH),
> > > > > am I right?
> > > > 
> > > > Possibly nitpicking, I wouldn't call the clock edge on which data
> > > > signals are generated/sampled "data polarity". This is clock polarity
> > > > information.
> > > > 
> > > > Have you seen cases where pixel data and DE are geenrated or need to
> > > > be sampled on different edges ?
> > > 
> > > DE is not a clock signal, but an 'Enable' signal whose value (high or
> > > low) defines the window in which the pixel data is valid.
> > > The flag defines whether data is valid during the HIGH or LOW period of
> > > DE.
> > 
> > The DRM_MODE_FLAG_POL_DE_(LOW|HIGH) do, by my impression of the proposed
> > new DRM_MODE_FLAG_POL_DE_*EDGE flags is that they define sampling clock
> > edges, not active levels.
> 
> The current naming of the flags gives the impression that they describe
> the sampling edges of a clock signal. But the DE signal in fact is not
> a clock signal but a level sensitive gating signal.

That's not my point. I *know* that DE is a data gating signal with a polarity 
already defined by the DRM_MODE_FLAG_POL_DE_(LOW|HIGH) flags. Like all other 
signals it gets generated on a clock edge and is sampled on a clock edge. The 
DRM_MODE_FLAG_POL_DE_*EDGE flags proposed above describe seem to describe just 
that, *not* the signal polarity. I thus want to know whether there are systems 
where the data signals and the DE signal need to be sampled on different edges 
of the pixel clock.

-- 
Regards,

Laurent Pinchart

