Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38760 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725783AbeKNIlU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 03:41:20 -0500
Date: Wed, 14 Nov 2018 00:41:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 4/4] SoC camera: Tidy the header
Message-ID: <20181113224100.hs6xtblwrd74cfmg@valkosipuli.retiisi.org.uk>
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
 <20181029230029.14630-5-sakari.ailus@linux.intel.com>
 <20181030090618.2a62d2d4@coco.lan>
 <20181031092945.csl5vifvstd5ds5g@paasikivi.fi.intel.com>
 <20181031064030.35cd5f8d@coco.lan>
 <b0ca8b6c-ca15-dc42-2425-fef60249c280@xs4all.nl>
 <20181031075421.027afb2a@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181031075421.027afb2a@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Mauro,

On Wed, Oct 31, 2018 at 07:54:21AM -0300, Mauro Carvalho Chehab wrote:
> Em Wed, 31 Oct 2018 11:00:22 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On 10/31/2018 10:40 AM, Mauro Carvalho Chehab wrote:
> > > Em Wed, 31 Oct 2018 11:29:45 +0200
> > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > >   
> > >> Hi Mauro,
> > >>
> > >> On Tue, Oct 30, 2018 at 09:06:18AM -0300, Mauro Carvalho Chehab wrote:  
> > >>> Em Tue, 30 Oct 2018 01:00:29 +0200
> > >>> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > >>>     
> > >>>> Clean up the SoC camera framework header. It only exists now to keep board
> > >>>> code compiling. The header can be removed once the board code dependencies
> > >>>> to it has been removed.
> > >>>>
> > >>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >>>> ---
> > >>>>  include/media/soc_camera.h | 335 ---------------------------------------------
> > >>>>  1 file changed, 335 deletions(-)
> > >>>>
> > >>>> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> > >>>> index b7e42a1b0910..14d19da6052a 100644
> > >>>> --- a/include/media/soc_camera.h
> > >>>> +++ b/include/media/soc_camera.h
> > >>>> @@ -22,172 +22,6 @@
> > >>>>  #include <media/v4l2-ctrls.h>
> > >>>>  #include <media/v4l2-device.h>    
> > >>>
> > >>> That doesn't make any sense. soc_camera.h should have the same fate
> > >>> as the entire soc_camera infrastructure: either be removed or moved
> > >>> to staging, and everything else that doesn't have the same fate
> > >>> should get rid of this header.    
> > >>
> > >> We can't just remove this; there is board code that depends on it.
> > >>
> > >> The intent is to remove the board code as well but presuming that the board
> > >> code would be merged through a different tree, it'd be less hassle to wait
> > >> a bit; hence the patch removing any unnecessary stuff here.  
> > > 
> > > Then we need *first* to remove board code, wait for those changes to be
> > > applied and *then* remove soc_camera (and not the opposite).  
> > 
> > Please note that the camera support for all the remaining boards using
> > soc_camera has been dead for years. The soc_camera drivers that they depended
> > on have been removed a long time ago.
> > 
> > So all they depend on are the header. We can safely remove soc_camera without
> > loss of functionality (and thus prevent others from basing new drivers on
> > soc_camera), while we work to update the board files so we can remove this last
> > header.
> > 
> > I have modified some board files here:
> > 
> > https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=rm-soc-camera&id=d7ae2fcf6e447022f0780bb86a2b63d5c7cf4d35
> 
> Good! the arch-specific mach-* changes should likely be on separate
> patches, though.
> 
> > Only arch/arm/mach-imx/mach-imx27_visstrim_m10.c hasn't been fixed yet in that
> > patch (ENOTIME).
> 
> So, the code we don't manage seems to be just 3 archs, right (mach-omap1,
> mach-pxa and mach-imx)?
> 
> Btw, the soc_camera dependent code at mach-imx27_visstrim_m10.c is:
> 
> 	static struct soc_camera_link iclink_tvp5150 = {
> 	        .bus_id         = 0,
>         	.board_info     = &visstrim_i2c_camera,
> 	        .i2c_adapter_id = 0,
> 	        .power = visstrim_camera_power,
> 	        .reset = visstrim_camera_reset,
> 	};
> 
> ...
>         platform_device_register_resndata(NULL, "soc-camera-pdrv", 0, NULL, 0,
>                                       &iclink_tvp5150, sizeof(iclink_tvp5150));
> 
> 
> As tvp5150 is not actually a soc_camera driver, I suspect that
> the conversion here would be to make it to use the tvp5150 driver
> directly, instead of doing it via soc_camera.

Using board files? The IMX27 SoC has plenty of dts files around which
suggests that it's just this particular board that has not been converted.
I don't think this is a good excuse to keep the board file stuff around.

If someone is willing to add dts files for the board, all the better. But
I'm not going to do that.

> 
> > The problem is just lack of time to clean this up and figure out who should
> > take these board patches.
> 
> No need to rush it.
> 
> > So I think it is a nice solution to just replace the header with a dummy version
> > so the board files still compile, and then we can delete the dead soc_camera
> > driver. It's probably easier as well to push through the board file changes once
> > soc_camera is removed since you can just point out that the framework it depended
> > on is gone.
> 
> I still think that reverting the order and rushing the removal is not the
> way to go.

I think no-one can blame us for rushing the removal of this: it's been
broken for years.

I propose removing the dead code with the least effort while minimising
collateral damage as well as additional maintenance work done to support
the to-be-removed code.

As far as I can see, that involves:

- Removing the SoC camera framework (as my set does; there'll be v2 to fix
  a few minor matters),

- Removing the board files (I can pick bits from Hans's patch for that if
  you like) and finally

- Remove the header left in place until the board files are gone.

The two could possibly make it to v4.21.

I'd say that having two of us have written patches to remove this code
independently is a clear sign code is ripe to go...

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
