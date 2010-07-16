Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39423 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965654Ab0GPOUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 10:20:39 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Fri, 16 Jul 2010 09:20:30 -0500
Subject: RE: [RFC/PATCH 02/10] media: Media device
Message-ID: <A24693684029E5489D1D202277BE8944568141B1@dlee02.ent.ti.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1279114219-27389-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <A24693684029E5489D1D202277BE894456775DB7@dlee02.ent.ti.com>
 <201007161056.22036.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007161056.22036.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Friday, July 16, 2010 3:56 AM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org; sakari.ailus@maxwell.research.nokia.com
> Subject: Re: [RFC/PATCH 02/10] media: Media device
> 
> Hi Sergio,
> 
> On Thursday 15 July 2010 16:22:06 Aguirre, Sergio wrote:
> > > On Wednesday 14 July 2010 08:30:00 Laurent Pinchart wrote:
> 
> <snip>
> 
> > > diff --git a/drivers/media/media-device.c b/drivers/media/media-
> device.c
> > > new file mode 100644
> > > index 0000000..a4d3db5
> > > --- /dev/null
> > > +++ b/drivers/media/media-device.c
> > > @@ -0,0 +1,77 @@
> 
> <snip>
> 
> > > +/**
> > > + * media_device_register - register a media device
> > > + * @mdev:	The media device
> > > + *
> > > + * The caller is responsible for initializing the media device before
> > > + * registration. The following fields must be set:
> > > + *
> > > + * - dev should point to the parent device. The field can be NULL
> when no
> > > + *   parent device is available (for instance with ISA devices).
> > > + * - name should be set to the device name. If the name is empty a
> parent
> > > + *   device must be set. In that case the name will be set to the
> parent
> > > + *   device driver name followed by a space and the parent device
> name.
> > > + */
> > > +int __must_check media_device_register(struct media_device *mdev)
> > > +{
> > > +	/* If dev == NULL, then name must be filled in by the caller */
> > > +	if (mdev->dev == NULL && WARN_ON(!mdev->name[0]))
> >
> > If mdev == NULL, you'll have a kernel panic here.
> 
> That's why drivers must not call media_device_register with a NULL pointer
> :-)
> It's not a valid use case, unlike kfree(NULL) for instance.

Right. I know.

I guess I was thinking more in terms of not compromising the system because
of a buggy driver, and exit gracefully instead... But I guess it's also ok,
as a driver developer is usually updating the full kernel anyways.

Regards,
Sergio

> 
> --
> Regards,
> 
> Laurent Pinchart
