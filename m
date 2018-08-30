Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59980 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727782AbeH3Ne4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 09:34:56 -0400
Date: Thu, 30 Aug 2018 12:33:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philippe De Muyter <phdm@macq.eu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        linux-media@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] media: imx274: don't hard-code the subdev name to
 DRIVER_NAME
Message-ID: <20180830093339.4kquhqdi6knrd2kh@valkosipuli.retiisi.org.uk>
References: <20180824163525.12694-1-luca@lucaceresoli.net>
 <20180829112936.GA15244@frolo.macqel>
 <20180829113843.4v63cxf3clvbzbtd@valkosipuli.retiisi.org.uk>
 <1552922.PBQrL6RDxY@avalon>
 <20180830065813.GA18916@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180830065813.GA18916@frolo.macqel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 30, 2018 at 08:58:13AM +0200, Philippe De Muyter wrote:
> Hi.
> 
> On Thu, Aug 30, 2018 at 12:23:23AM +0300, Laurent Pinchart wrote:
> > Hello,
> > 
> > On Wednesday, 29 August 2018 14:38:43 EEST Sakari Ailus wrote:
> > > On Wed, Aug 29, 2018 at 01:29:36PM +0200, Philippe De Muyter wrote:
> > > > On Wed, Aug 29, 2018 at 02:07:21PM +0300, Sakari Ailus wrote:
> > > >> On Tue, Aug 28, 2018 at 06:02:55PM +0200, Philippe De Muyter wrote:
> > 
> > [snip]
> > 
> > > >>> Then we should probably also apply the following patch I submitted :
> > > >>> 
> > > >>> "media: v4l2-common: v4l2_spi_subdev_init : generate unique name"
> > > >>> 
> > > >>> 	https://patchwork.kernel.org/patch/10553035/
> > > >>> 
> > > >>> and perhaps
> > > >>> 
> > > >>> "media: v4l2-common: simplify v4l2_i2c_subdev_init name generation"
> > > >>> 
> > > >>> 	https://patchwork.kernel.org/patch/10553037/
> > > >> 
> > > >> The problem with this patch is that the existing naming scheme is very
> > > >> similar while the new one offers no tangible benefits apart from being
> > > >> in line with the rest of the kernel. That's still not a benefit for uAPI:
> > > >> changing the name is certain to break user space applications.
> > > > 
> > > > I agree with you on the patch for v4l2_i2c_subdev_init (I wrote
> > > > 'perhaps'), but you don't say anything on the one about
> > > > v4l2_spi_subdev_init :), which fixes an actual bug.  I have 2 identical
> > > > SPI-controlled sensors on the same board, and without my patch they get
> > > > the same subdev name.  Of course, I could fix that in the sensor driver
> > > > itself, but that's not what we want, or do we ?
> > > 
> > > Good point. I missed the naming of the SPI devices ignored any bus
> > > information there. I'm rather inclined towards taking the SPI patch. Hans,
> > > Mauro, Laurent; any opinion on that?
> > 
> > I agree that the SPI patch makes sense, I think we should take it.
> 
> Do I need to resend https://patchwork.kernel.org/patch/10553035/ "media:
> v4l2-common: v4l2_spi_subdev_init : generate unique name", adding Sakari's
> and Laurent's Acked-by ? or will that patch be taken automagically ?

No need to.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
