Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49210 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbcKVVr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 16:47:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Nadim Almas <nadim.902@gmail.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:media:davinci_vpfe: used devm_kzalloc in place of kzalloc
Date: Tue, 22 Nov 2016 23:45:55 +0200
Message-ID: <1830660.9a0KUsozFq@avalon>
In-Reply-To: <alpine.DEB.2.20.1611020720250.2081@hadrien>
References: <20161102061300.GA4157@gmail.com> <alpine.DEB.2.20.1611020720250.2081@hadrien>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia,

On Wednesday 02 Nov 2016 07:24:29 Julia Lawall wrote:
> On Wed, 2 Nov 2016, Nadim Almas wrote:
> > Switch to resource-managed function devm_kzalloc instead
> > of kzolloc and remove unneeded kzfree
> > 
> > Also, remove kzfree in probe function and  remove
> > function,vpfe_remove as it is now has nothing to do.
> > The Coccinelle semantic patch used to make this change is as follows:
> > /<smpl>
> > @platform@
> > identifier p, probefn, removefn;
> > @@
> > struct platform_driver p = {
> > .probe = probefn,
> > .remove = removefn,
> > };
> > 
> > @prb@
> > identifier platform.probefn, pdev;
> > expression e, e1, e2;
> > @@
> > probefn(struct platform_device *pdev, ...) {
> > <+...
> > - e = kzalloc(e1, e2)
> > + e = devm_kzalloc(&pdev->dev, e1, e2)
> > ...
> > ?-kzfree(e);
> > ...+>
> > }
> > @rem depends on prb@
> > identifier platform.removefn;
> > expression prb.e;
> > @@
> > removefn(...) {
> > <...
> > - kzfree(e);
> > ...>
> > }
> > //</smpl>
> > 
> > Signed-off-by: Nadim Almas <nadim.902@gmail.com>
> > ---
> > 
> >  drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> > b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c index
> > bf077f8..cd44f0f 100644
> > --- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> > +++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> > @@ -579,7 +579,7 @@ static int vpfe_probe(struct platform_device *pdev)
> >  	struct resource *res1;
> >  	int ret = -ENOMEM;
> > 
> > -	vpfe_dev = kzalloc(sizeof(*vpfe_dev), GFP_KERNEL);
> > +	vpfe_dev = devm_kzalloc(&pdev->dev, sizeof(*vpfe_dev), GFP_KERNEL);
> >  	if (!vpfe_dev)
> >  		return ret;
> > 
> > @@ -681,7 +681,6 @@ static int vpfe_probe(struct platform_device *pdev)
> >  probe_disable_clock:
> >  	vpfe_disable_clock(vpfe_dev);
> >  probe_free_dev_mem:
> > -	kzfree(vpfe_dev);
> 
> Kzfree zeroes the data before freeing it.  Devm_kzalloc only causes a
> kfree to happen, not a kzfree.  If the kzfree is needed, then a memset 0
> would need to replace the calls to kzfree.

I don't think kzfree() is needed in this case.

> There are some other minor issues with the patch.  In the subject line,
> there is normally a space after each :.  There is a spelling mistake in
> the commit message.  In the commit message there should be one space
> betwee words within a sentence, and there should be a space after a comma,
> or other puctuation.

Beside, I don't think devm_kzalloc() is a good idea. The vpfe_device structure 
embeds data accessible from userspace through ioctls, and thus potentially 
needs to survive unbinding the driver from the device. This isn't currently 
implemented now, but devm_kzalloc() just goes in the wrong direction.

> >  	return ret;
> >  }
> > 
> > @@ -702,7 +701,6 @@ static int vpfe_remove(struct platform_device *pdev)
> >  	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
> >  	media_device_unregister(&vpfe_dev->media_dev);
> >  	vpfe_disable_clock(vpfe_dev);
> > -	kzfree(vpfe_dev);
> >  	return 0;
> >  }
> > 

-- 
Regards,

Laurent Pinchart

