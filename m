Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57494 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbeJaSiA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 14:38:00 -0400
Date: Wed, 31 Oct 2018 06:40:30 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl, mchehab@kernel.org
Subject: Re: [PATCH 4/4] SoC camera: Tidy the header
Message-ID: <20181031064030.35cd5f8d@coco.lan>
In-Reply-To: <20181031092945.csl5vifvstd5ds5g@paasikivi.fi.intel.com>
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
        <20181029230029.14630-5-sakari.ailus@linux.intel.com>
        <20181030090618.2a62d2d4@coco.lan>
        <20181031092945.csl5vifvstd5ds5g@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 31 Oct 2018 11:29:45 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
> 
> On Tue, Oct 30, 2018 at 09:06:18AM -0300, Mauro Carvalho Chehab wrote:
> > Em Tue, 30 Oct 2018 01:00:29 +0200
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >   
> > > Clean up the SoC camera framework header. It only exists now to keep board
> > > code compiling. The header can be removed once the board code dependencies
> > > to it has been removed.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > ---
> > >  include/media/soc_camera.h | 335 ---------------------------------------------
> > >  1 file changed, 335 deletions(-)
> > > 
> > > diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> > > index b7e42a1b0910..14d19da6052a 100644
> > > --- a/include/media/soc_camera.h
> > > +++ b/include/media/soc_camera.h
> > > @@ -22,172 +22,6 @@
> > >  #include <media/v4l2-ctrls.h>
> > >  #include <media/v4l2-device.h>  
> > 
> > That doesn't make any sense. soc_camera.h should have the same fate
> > as the entire soc_camera infrastructure: either be removed or moved
> > to staging, and everything else that doesn't have the same fate
> > should get rid of this header.  
> 
> We can't just remove this; there is board code that depends on it.
> 
> The intent is to remove the board code as well but presuming that the board
> code would be merged through a different tree, it'd be less hassle to wait
> a bit; hence the patch removing any unnecessary stuff here.

Then we need *first* to remove board code, wait for those changes to be
applied and *then* remove soc_camera (and not the opposite).

Thanks,
Mauro
