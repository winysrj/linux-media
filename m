Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.karo-electronics.de ([81.173.242.67]:49418 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452AbaCQPSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 11:18:01 -0400
Date: Mon, 17 Mar 2014 16:14:36 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, devel@driverdev.osuosl.org,
	Russell King <linux@arm.linux.org.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Denis Carikli <denis@eukrea.com>,
	Eric =?UTF-8?B?QsOpbmFyZA==?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 07/12] drm: drm_display_mode: add signal polarity flags
Message-ID: <20140317161436.06169b33@ipc1.ka-ro>
In-Reply-To: <2166863.3Fn4k2rvaz@avalon>
References: <1394731053-6118-1-git-send-email-denis@eukrea.com>
	<1394731053-6118-7-git-send-email-denis@eukrea.com>
	<5326FB75.1050605@samsung.com>
	<2166863.3Fn4k2rvaz@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Laurent Pinchart wrote:
> Hello,
> 
> On Monday 17 March 2014 14:41:09 Andrzej Hajda wrote:
> > On 03/13/2014 06:17 PM, Denis Carikli wrote:
> > > We need a way to pass signal polarity informations
> > > between DRM panels, and the display drivers.
> > > 
> > > To do that, a pol_flags field was added to drm_display_mode.
> > > 
> > > Signed-off-by: Denis Carikli <denis@eukrea.com>
> > > ---
> > > ChangeLog v10->v11:
> > > - Since the imx-drm won't be able to retrive its regulators
> > > 
> > >   from the device tree when using display-timings nodes,
> > >   and that I was told that the drm simple-panel driver
> > >   already supported that, I then, instead, added what was
> > >   lacking to make the eukrea displays work with the
> > >   drm-simple-panel driver.
> > >   
> > >   That required a way to get back the display polarity
> > >   informations from the imx-drm driver without affecting
> > >   userspace.
> > > 
> > > ---
> > > 
> > >  include/drm/drm_crtc.h |    8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
> > > index f764654..61a4fe1 100644
> > > --- a/include/drm/drm_crtc.h
> > > +++ b/include/drm/drm_crtc.h
> > > @@ -131,6 +131,13 @@ enum drm_mode_status {
> > > 
> > >  #define DRM_MODE_FLAG_3D_MAX	DRM_MODE_FLAG_3D_SIDE_BY_SIDE_HALF
> > > 
> > > +#define DRM_MODE_FLAG_POL_PIXDATA_NEGEDGE	BIT(1)
> > > +#define DRM_MODE_FLAG_POL_PIXDATA_POSEDGE	BIT(2)
> > > +#define DRM_MODE_FLAG_POL_PIXDATA_PRESERVE	BIT(3)
> > > +#define DRM_MODE_FLAG_POL_DE_NEGEDGE		BIT(4)
> > > +#define DRM_MODE_FLAG_POL_DE_POSEDGE		BIT(5)
> > > +#define DRM_MODE_FLAG_POL_DE_PRESERVE		BIT(6)
> > 
> > Could you add some description to these flags.
> > What are *_PRESERVE flags for?
> > Are those flags 1:1 compatible with respective 'videomode:flags'?
> > I guess DE flags should be rather DRM_MODE_FLAG_POL_DE_(LOW|HIGH), am I
> > right?
> 
> Possibly nitpicking, I wouldn't call the clock edge on which data signals are 
> generated/sampled "data polarity". This is clock polarity information.
> 
> Have you seen cases where pixel data and DE are geenrated or need to be 
> sampled on different edges ?
> 
DE is not a clock signal, but an 'Enable' signal whose value (high or
low) defines the window in which the pixel data is valid.
The flag defines whether data is valid during the HIGH or LOW period of
DE.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
