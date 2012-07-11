Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39728 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2GKKqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 06:46:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	g.liakhovetski@gmx.de, mchehab@infradead.org
Subject: Re: [PATCH v5] media: mx2_camera: Fix mbus format handling
Date: Wed, 11 Jul 2012 12:46:20 +0200
Message-ID: <5285988.i3IejHlJ2h@avalon>
In-Reply-To: <CACKLOr1Dyt2f1zR6YzXndgDWRFfNRrsRvQVUX2TLzX933rcO8A@mail.gmail.com>
References: <1341993409-20870-1-git-send-email-javier.martin@vista-silicon.com> <9798139.lz26YdKuPN@avalon> <CACKLOr1Dyt2f1zR6YzXndgDWRFfNRrsRvQVUX2TLzX933rcO8A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Wednesday 11 July 2012 12:37:05 javier Martin wrote:
> On 11 July 2012 12:08, Laurent Pinchart wrote:
> > On Wednesday 11 July 2012 09:56:49 Javier Martin wrote:
> >> Remove MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MSB flags
> >> so that the driver can negotiate with the attached sensor
> >> whether the mbus format needs convertion from UYUV to YUYV
> >> or not.
> > 
> > The commit message doesn't really match the content of the patch anymore,
> > as you don't remove the MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MSB
> > flags but just stop using them.
> > 
> > Could you please fix the commit message, and submit a patch that removes
> > the flag from arch/arm/plat-mxc/include/mach/mx2_cam.h for v3.6 ?
> > 
> > Please don't forget to add your SoB line.
> 
> Ok.
> 
> >> ---
> >> 
> >>  drivers/media/video/mx2_camera.c |   28 +++++++++++++++++++++++-----
> >>  1 file changed, 23 insertions(+), 5 deletions(-)
> >> 
> >> diff --git a/drivers/media/video/mx2_camera.c
> >> b/drivers/media/video/mx2_camera.c index 11a9353..0f01e7b 100644
> >> --- a/drivers/media/video/mx2_camera.c
> >> +++ b/drivers/media/video/mx2_camera.c

[snip]

> >> @@ -1018,14 +1037,14 @@ static int mx2_camera_set_bus_param(struct
> >> soc_camera_device *icd) return ret;
> >> 
> >>       }
> >> 
> >> +     csicr1 = (csicr1 & ~CSICR1_FMT_MASK) | pcdev->emma_prp->cfg.csicr1;
> >> +
> >> 
> >>       if (common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> >>               csicr1 |= CSICR1_REDGE;
> >>       if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> >>               csicr1 |= CSICR1_SOF_POL;
> >>       if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> >>               csicr1 |= CSICR1_HSYNC_POL;
> > 
> > This is a completely different issue (and thus v3.6 material, if needed),
> > but can common_flags change between invocations ? If so you should clear
> > the CSICR1_* flags before conditionally setting them.
> 
> No, this is precisely the aim of this patch. The problem is that these
> flags have to be set according to the format that is being used and
> not according to the platform code.
> So, this chunk is needed.

I haven't expressed myself clearly enough, sorry. The "completely" different 
issue refers to the REDGE, SOF_POL and HSYNC_POL flags.

> 'common_flags' cannot change between invocations since it depends on
> the platform code which is static.

Then the code that computes the csicr1 flags that only depend on static 
platform data should probably be moved to a different function, called at 
initialization time, to avoid recomputing them at each 
mx2_camera_set_bus_param() invocation. This would be v3.6 material.

> >> -     if (pcdev->platform_flags & MX2_CAMERA_SWAP16)
> >> -             csicr1 |= CSICR1_SWAP16_EN;
> >>       if (pcdev->platform_flags & MX2_CAMERA_EXT_VSYNC)
> >>               csicr1 |= CSICR1_EXT_VSYNC;
> >>       if (pcdev->platform_flags & MX2_CAMERA_CCIR)

-- 
Regards,

Laurent Pinchart

