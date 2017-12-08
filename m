Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:37405 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753303AbdLHNJZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 08:09:25 -0500
Received: by mail-lf0-f68.google.com with SMTP id a12so11830409lfe.4
        for <linux-media@vger.kernel.org>; Fri, 08 Dec 2017 05:09:24 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 8 Dec 2017 14:09:21 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 03/28] rcar-vin: unregister video device on driver
 removal
Message-ID: <20171208130921.GN31989@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
 <20171208010842.20047-4-niklas.soderlund+renesas@ragnatech.se>
 <1762416.X4GW5MWmCZ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1762416.X4GW5MWmCZ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your comments.

On 2017-12-08 09:54:31 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 8 December 2017 03:08:17 EET Niklas Söderlund wrote:
> > If the video device was registered by the complete() callback it should
> > be unregistered when the driver is removed.
> 
> The .remove() operation indicates device removal, not driver removal (or, the 
> be more precise, it indicates that the device is unbound from the driver). I'd 
> update the commit message accordingly.

I'm not sure I fully understand this comment.

My take is that .remove() indicates that the device is removed and not 
the driver itself, as the driver might be used by multiple devices and 
the .remove() function is therefor not an indication that the driver is 
being unloaded.

So if I understood you correctly the following would be a better to go 
in the commit message:

"If the video device was registered by the complete() callback it should 
be unregistered when a device is unbound from the driver."

> 
> > Protect from printing an uninitialized video device node name by adding a
> > check in rvin_v4l2_unregister() to identify that the video device is
> > registered.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 +++
> >  2 files changed, 5 insertions(+)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> > b/drivers/media/platform/rcar-vin/rcar-core.c index
> > f7a4c21909da6923..6d99542ec74b49a7 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -272,6 +272,8 @@ static int rcar_vin_remove(struct platform_device *pdev)
> > 
> >  	pm_runtime_disable(&pdev->dev);
> > 
> > +	rvin_v4l2_unregister(vin);
> 
> Unless I'm mistaken, you're unregistering the video device both here and in 
> the unbound() function. That's messy, but it's not really your fault, the V4L2 
> core is very messy in the first place, and registering video devices in the 
> complete() handler is a bad idea. As that can't be fixed for now,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Big thanks for this :-)

> 
> Hans, I still would like to hear your opinion on how this should be solved. 
> You've voiced a few weeks ago that register video devices at probe() time 
> isn't a good idea but you've never explained how we should fix the problem. I 
> still firmly believe that video devices should be registered at probe time, 
> and we need to reach an agreement on a technical solution to this problem.
> 
> >  	v4l2_async_notifier_unregister(&vin->notifier);
> >  	v4l2_async_notifier_cleanup(&vin->notifier);
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > 178aecc94962abe2..32a658214f48fa49 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -841,6 +841,9 @@ static const struct v4l2_file_operations rvin_fops = {
> > 
> >  void rvin_v4l2_unregister(struct rvin_dev *vin)
> >  {
> > +	if (!video_is_registered(&vin->vdev))
> > +		return;
> > +
> >  	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
> >  		  video_device_node_name(&vin->vdev));
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
