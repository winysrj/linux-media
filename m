Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58005 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbZCTJIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 05:08:34 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Koen Kooi <k.kooi@student.utwente.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Fri, 20 Mar 2009 14:38:19 +0530
Subject: RE: [PATCH 3/3] V4L2 Driver for OMAP3/3 DSS.
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02FAF6EDB3@dbde02.ent.ti.com>
In-Reply-To: <6EDD6EAA-E1DC-4F71-BB6E-01574AC2D968@student.utwente.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Koen Kooi [mailto:k.kooi@student.utwente.nl]
> Sent: Friday, March 20, 2009 2:34 PM
> To: Shah, Hardik
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Jadav, Brijesh R;
> Hiremath, Vaibhav
> Subject: Re: [PATCH 3/3] V4L2 Driver for OMAP3/3 DSS.
> 
> 
> Op 20 mrt 2009, om 06:20 heeft Hardik Shah het volgende geschreven:
> >
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -711,6 +711,26 @@ config VIDEO_CAFE_CCIC
> > 	  CMOS camera controller.  This is the controller found on first-
> > 	  generation OLPC systems.
> >
> > +#config VIDEO_OMAP3
> > +#        tristate "OMAP 3 Camera support"
> > +#	select VIDEOBUF_GEN
> > +#	select VIDEOBUF_DMA_SG
> > +#	depends on VIDEO_V4L2 && ARCH_OMAP34XX
> > +#	---help---
> > +#	  Driver for an OMAP 3 camera controller.
> > +
> > +config VIDEO_OMAP3
> > +	bool "OMAP2/OMAP3 Camera and V4L2-DSS drivers"
> > +	select VIDEOBUF_GEN
> > +	select VIDEOBUF_DMA_SG
> > +	select OMAP2_DSS
> > +	depends on VIDEO_DEV && (ARCH_OMAP24XX || ARCH_OMAP34XX)
> > +	default y
> > +	---help---
> > +        V4L2 DSS and Camera driver support for OMAP2/3 based boards.
> 
> 
> Copy/paste error?
> 
> regards,
> 
> Koen
[Shah, Hardik] Yes,
I will correct it,  Its indeed copy paste error

Regards,
Hardik
