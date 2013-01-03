Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35710 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3ACQjo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 11:39:44 -0500
Received: by mail-pb0-f52.google.com with SMTP id ro2so8662082pbb.39
        for <linux-media@vger.kernel.org>; Thu, 03 Jan 2013 08:39:43 -0800 (PST)
Date: Thu, 3 Jan 2013 08:39:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 133/493] remove use of __devexit_p
Message-ID: <20130103163950.GA2350@kroah.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
 <Pine.LNX.4.64.1301031235370.17494@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1301031235370.17494@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 03, 2013 at 12:43:10PM +0100, Guennadi Liakhovetski wrote:
> Hi Bill
> 
> On Mon, 19 Nov 2012, Bill Pemberton wrote:
> 
> > CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
> > needed.
> 
> Doesn't this also make the use of __refdata in many locations like this
> 
> [snip]
> 
> > diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> > index 0528650..0d0344a 100644
> > --- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> > +++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> > @@ -382,7 +382,7 @@ static __devexit int sh_csi2_remove(struct platform_device *pdev)
> >  }
> >  
> >  static struct platform_driver __refdata sh_csi2_pdrv = {
> > -	.remove	= __devexit_p(sh_csi2_remove),
> > +	.remove	= sh_csi2_remove,
> >  	.probe	= sh_csi2_probe,
> >  	.driver	= {
> >  		.name	= "sh-mobile-csi2",
> 
> superfluous? If so, I'm sure you'd be happy to make a couple more patches 
> to continue this series ;-)

Yes, it does make it superfluous.  I'm still working on getting most of
the original patches into Linus's tree, so let's wait for that to happen
first before cleaning up the reset of these :)

thanks,

greg k-h
