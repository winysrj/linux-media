Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34121 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754846AbdLTPVA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 10:21:00 -0500
Received: by mail-lf0-f65.google.com with SMTP id y78so18797643lfd.1
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 07:20:59 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Wed, 20 Dec 2017 16:20:55 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 07/28] rcar-vin: change name of video device
Message-ID: <20171220152055.GB32148@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
 <2107363.OzArtd56sx@avalon>
 <20171214142500.lhp3v6lrd7kovx7b@valkosipuli.retiisi.org.uk>
 <3340556.KXTJ26DsAn@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3340556.KXTJ26DsAn@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Sakari,

Thanks for your comments.

On 2017-12-14 17:50:24 +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Thursday, 14 December 2017 16:25:00 EET Sakari Ailus wrote:
> > On Fri, Dec 08, 2017 at 10:17:36AM +0200, Laurent Pinchart wrote:
> > > On Friday, 8 December 2017 03:08:21 EET Niklas Söderlund wrote:
> > > > The rcar-vin driver needs to be part of a media controller to support
> > > > Gen3. Give each VIN instance a unique name so it can be referenced from
> > > > userspace.
> > > > 
> > > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > > Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > > > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > > ---
> > > > 
> > > >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > > > 59ec6d3d119590aa..19de99133f048960 100644
> > > > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > > @@ -876,7 +876,8 @@ int rvin_v4l2_register(struct rvin_dev *vin)
> > > > 
> > > >  	vdev->fops = &rvin_fops;
> > > >  	vdev->v4l2_dev = &vin->v4l2_dev;
> > > >  	vdev->queue = &vin->queue;
> > > > 
> > > > -	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> > > > +	snprintf(vdev->name, sizeof(vdev->name), "%s %s", KBUILD_MODNAME,
> > > > +		 dev_name(vin->dev));
> > > 
> > > Do we need the module name here ? How about calling them "%s output",
> > > dev_name(vin->dev) to emphasize the fact that this is a video node and not
> > > a VIN subdev ? This is what the omap3isp and vsp1 drivers do.
> > > 
> > > We're suffering a bit from the fact that V4L2 has never standardized a
> > > naming scheme for the devices. It wouldn't be fair to ask you to fix that
> > > as a prerequisite to get the VIN driver merged, but we clearly have to
> > > work on that at some point.
> > 
> > Agreed, this needs to be stable and I think aligning to what omap3isp or
> > vsp1 do would be a good fix here.
> 
> Even omap3isp and vsp1 are not fully aligned, so I think we need to design a 
> naming policy and document it.

I agree that align this is a good idea. And for this reason I chosen to 
update this patch as such:

"%s output", dev_name(vin->dev)

I hope this is a step in the correct direction. If not please let me 
know as soon as possible so I can minimize the trouble for the other 
developers doing stuff on-top of this series and there test scripts :-)

> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
