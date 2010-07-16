Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:59930 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935955Ab0GPIx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 04:53:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [RFC/PATCH 02/10] media: Media device
Date: Fri, 16 Jul 2010 10:53:20 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279114219-27389-3-git-send-email-laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE894456775DA5@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894456775DA5@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007161053.20737.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

Thanks for the review.

On Thursday 15 July 2010 16:16:44 Aguirre, Sergio wrote:
> > On Wednesday 14 July 2010 08:30:00 Laurent Pinchart wrote:

<snip>

> > diff --git a/include/media/media-device.h b/include/media/media-device.h
> > new file mode 100644
> > index 0000000..6c1fc4a
> > --- /dev/null
> > +++ b/include/media/media-device.h
> > @@ -0,0 +1,53 @@

[snip]

> > +#ifndef _MEDIA_DEVICE_H
> > +#define _MEDIA_DEVICE_H
> > +
> > +#include <linux/device.h>
> > +#include <linux/list.h>
> > +
> > +#include <media/media-devnode.h>
> > +
> > +/* Each instance of a media device should create the media_device struct,
> > + * either stand-alone or embedded in a larger struct.
> > + *
> > + * It allows easy access to sub-devices (see v4l2-subdev.h) and provides
> > + * basic media device-level support.
> > + */
> > +
> > +#define MEDIA_DEVICE_NAME_SIZE (20 + 16)
> 
> Where does above numbers come from ??

Copied from v4l2-device.h. It was originally BUS_ID_SIZE (the constant is now 
gone) + 16.

I can replace that by a hardcoded 32.

-- 
Regards,

Laurent Pinchart
