Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55733 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965664Ab0GPOWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 10:22:55 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Fri, 16 Jul 2010 09:22:46 -0500
Subject: RE: [RFC/PATCH 02/10] media: Media device
Message-ID: <A24693684029E5489D1D202277BE8944568141BA@dlee02.ent.ti.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1279114219-27389-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <A24693684029E5489D1D202277BE894456775DA5@dlee02.ent.ti.com>
 <201007161053.20737.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007161053.20737.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Friday, July 16, 2010 3:53 AM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org; sakari.ailus@maxwell.research.nokia.com
> Subject: Re: [RFC/PATCH 02/10] media: Media device
> 
> Hi Sergio,
> 
> Thanks for the review.
> 
> On Thursday 15 July 2010 16:16:44 Aguirre, Sergio wrote:
> > > On Wednesday 14 July 2010 08:30:00 Laurent Pinchart wrote:
> 
> <snip>
> 
> > > diff --git a/include/media/media-device.h b/include/media/media-
> device.h
> > > new file mode 100644
> > > index 0000000..6c1fc4a
> > > --- /dev/null
> > > +++ b/include/media/media-device.h
> > > @@ -0,0 +1,53 @@
> 
> [snip]
> 
> > > +#ifndef _MEDIA_DEVICE_H
> > > +#define _MEDIA_DEVICE_H
> > > +
> > > +#include <linux/device.h>
> > > +#include <linux/list.h>
> > > +
> > > +#include <media/media-devnode.h>
> > > +
> > > +/* Each instance of a media device should create the media_device
> struct,
> > > + * either stand-alone or embedded in a larger struct.
> > > + *
> > > + * It allows easy access to sub-devices (see v4l2-subdev.h) and
> provides
> > > + * basic media device-level support.
> > > + */
> > > +
> > > +#define MEDIA_DEVICE_NAME_SIZE (20 + 16)
> >
> > Where does above numbers come from ??
> 
> Copied from v4l2-device.h. It was originally BUS_ID_SIZE (the constant is
> now
> gone) + 16.
> 
> I can replace that by a hardcoded 32.

Ok.

Regards,
Sergio
> 
> --
> Regards,
> 
> Laurent Pinchart
