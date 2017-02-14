Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58825 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbdBNWFu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 17:05:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 07/13] v4l2: device_register_subdev_nodes: allow calling multiple times
Date: Wed, 15 Feb 2017 00:06:17 +0200
Message-ID: <2486504.jaU8nJZtu6@avalon>
In-Reply-To: <20170214220256.GN16975@valkosipuli.retiisi.org.uk>
References: <20170214134000.GA8550@amd> <20170214220256.GN16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 15 Feb 2017 00:02:57 Sakari Ailus wrote:
> On Tue, Feb 14, 2017 at 02:40:00PM +0100, Pavel Machek wrote:
> > From: Sebastian Reichel <sre@kernel.org>
> > 
> > Without this, exposure / gain controls do not work in the camera
> > application.:
> :-)
> :
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-device.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-device.c
> > b/drivers/media/v4l2-core/v4l2-device.c index f364cc1..b3afbe8 100644
> > --- a/drivers/media/v4l2-core/v4l2-device.c
> > +++ b/drivers/media/v4l2-core/v4l2-device.c
> > @@ -235,6 +235,9 @@ int v4l2_device_register_subdev_nodes(struct
> > v4l2_device *v4l2_dev)
> >  		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
> >  			continue;
> > 
> > +		if(sd->devnode)
> > +			continue;
> 
> This has been recognised as a problem but you're the first to submit a patch
> I believe. Please add an appropriate description. :-)
> 
> s/if\(/if (/
> 
> I think this one should go in before the rest.

But how can this happen ? Is v4l2_device_register_subdev_nodes() called 
multiple times ? Do we want to allow that ?

> > +
> >  		vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> >  		if (!vdev) {
> >  			err = -ENOMEM;

-- 
Regards,

Laurent Pinchart
