Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42037 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbeH0Q6a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 12:58:30 -0400
Received: by mail-lf1-f67.google.com with SMTP id z11-v6so11875532lff.9
        for <linux-media@vger.kernel.org>; Mon, 27 Aug 2018 06:11:51 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 27 Aug 2018 15:11:47 +0200
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 00/30] v4l: add support for multiplexed streams
Message-ID: <20180827131147.GB15572@bigcity.dyn.berto.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
 <20180827115010.omows5z66phc55pv@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180827115010.omows5z66phc55pv@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej Sakari,

Thanks for your comments,

On 2018-08-27 14:50:10 +0300, Sakari Ailus wrote:
> Hejssan!
> 
> On Thu, Aug 23, 2018 at 03:25:14PM +0200, Niklas Söderlund wrote:
> > Hi all,
> > 
> > This series adds support for multiplexed streams within a media device 
> > link. The use-case addressed in this series covers CSI-2 Virtual 
> > Channels on the Renesas R-Car Gen3 platforms. The v4l2 changes have been 
> > a joint effort between Sakari and Laurent and floating around for some 
> > time [1].
> 
> Thanks for working on driver support for this.
> 
> How do you handle streaming on R-Car Gen2 CSI-2 receiver? Do you support
> multiple concurrent such streams?

s/Gen2/Gen3/ :-)

This series framework changes and driver changes to rcar-csi2
supports multiple concurrent streams. However the example implementation 
here uses the adv7482 as a video source which only provides one 
concurrent stream.

However there is another more complex use-case using GMSL and max9286 
deserializes and max9272 serializers which supports streaming on all 4 
CSI-2 virtual channels. There are prototype drivers which are posted 
publicly which demonstrates this but as they are less mature and much 
more complex then the adv7482 use-case they are not included in this 
series. It is however tested and works to stream 1-4 channels 
concurrently using the framework changes from this series.

> 
> > 
> > I have added driver support for the devices used on the Renesas Gen3 
> > platforms, a ADV7482 connected to the R-Car CSI-2 receiver. With these 
> > changes I can control which of the analog inputs of the ADV7482 the 
> > video source is captured from and on which CSI-2 virtual channel the 
> > video is transmitted on to the R-Car CSI-2 receiver.
> > 
> > The series adds two new subdev IOCTLs [GS]_ROUTING which allows 
> > user-space to get and set routes inside a subdevice. I have added RFC 
> > support for these to v4l-utils [2] which can be used to test this 
> > series, example:
> > 
> >     Check the internal routing of the adv748x csi-2 transmitter:
> >     v4l2-ctl -d /dev/v4l-subdev24 --get-routing
> >     0/0 -> 1/0 [ENABLED]
> >     0/0 -> 1/1 []
> >     0/0 -> 1/2 []
> >     0/0 -> 1/3 []
> > 
> > 
> >     Select that video should be outputed on VC 2 and check the result:
> >     $ v4l2-ctl -d /dev/v4l-subdev24 --set-routing '0/0 -> 1/2 [1]'
> 
> Do you have the v4l2-ctl changes for routing configuration? I do have
> similar changes for media-ctl (as well as libv4l2subdev) but I don't think
> I've posted them yet. This patchset doesn't depend on them though.

Yes the RFC changes I made to be able to use v4l2-ctl as show above are 
available at:

    git://git.ragnatech.se/v4l-utils routing

> 
> > 
> >     $ v4l2-ctl -d /dev/v4l-subdev24 --get-routing
> >     0/0 -> 1/0 []
> >     0/0 -> 1/1 []
> >     0/0 -> 1/2 [ENABLED]
> >     0/0 -> 1/3 []
> > 
> > This series is tested on R-Car M3-N and for your testing needs this 
> > series is available at
> > 
> >     git://git.ragnatech.se/linux v4l2/mux
> > 
> > Thanks.
> > 
> > 1. git://linuxtv.org/sailus/media_tree.git vc
> > 2. git://git.ragnatech.se/v4l-utils routing
> > 
> > 
> > Laurent Pinchart (4):
> >   media: entity: Add has_route entity operation
> >   media: entity: Add media_has_route() function
> >   media: entity: Use routing information during graph traversal
> >   v4l: subdev: Add [GS]_ROUTING subdev ioctls and operations
> > 
> > Niklas Söderlund (7):
> >   adv748x: csi2: add translation from pixelcode to CSI-2 datatype
> >   adv748x: csi2: only allow formats on sink pads
> >   adv748x: csi2: describe the multiplexed stream
> >   adv748x: csi2: add internal routing configuration
> >   adv748x: afe: add routing support
> >   rcar-csi2: use frame description information to configure CSI-2 bus
> >   rcar-csi2: expose the subdevice internal routing
> > 
> > Sakari Ailus (19):
> >   media: entity: Use pad as a starting point for graph walk
> >   media: entity: Use pads instead of entities in the media graph walk
> >     stack
> >   media: entity: Walk the graph based on pads
> >   v4l: mc: Start walk from a specific pad in use count calculation
> >   media: entity: Move the pipeline from entity to pads
> >   media: entity: Use pad as the starting point for a pipeline
> >   media: entity: Swap pads if route is checked from source to sink
> >   media: entity: Skip link validation for pads to which there is no
> >     route to
> >   media: entity: Add an iterator helper for connected pads
> >   media: entity: Add only connected pads to the pipeline
> >   media: entity: Add debug information in graph walk route check
> >   media: entity: Look for indirect routes
> >   v4l: subdev: compat: Implement handling for VIDIOC_SUBDEV_[GS]_ROUTING
> >   v4l: subdev: Take routing information into account in link validation
> >   v4l: subdev: Improve link format validation debug messages
> >   v4l: mc: Add an S_ROUTING helper function for power state changes
> >   v4l: Add bus type to frame descriptors
> >   v4l: Add CSI-2 bus configuration to frame descriptors
> >   v4l: Add stream to frame descriptor
> > 
> >  Documentation/media/kapi/mc-core.rst          |  15 +-
> >  drivers/media/i2c/adv748x/adv748x-afe.c       |  65 ++++
> >  drivers/media/i2c/adv748x/adv748x-csi2.c      | 124 +++++++-
> >  drivers/media/i2c/adv748x/adv748x.h           |   1 +
> >  drivers/media/media-entity.c                  | 252 ++++++++++------
> >  drivers/media/pci/intel/ipu3/ipu3-cio2.c      |   6 +-
> >  .../media/platform/exynos4-is/fimc-capture.c  |   8 +-
> >  .../platform/exynos4-is/fimc-isp-video.c      |   8 +-
> >  drivers/media/platform/exynos4-is/fimc-isp.c  |   2 +-
> >  drivers/media/platform/exynos4-is/fimc-lite.c |  10 +-
> >  drivers/media/platform/exynos4-is/media-dev.c |  20 +-
> >  drivers/media/platform/omap3isp/isp.c         |   2 +-
> >  drivers/media/platform/omap3isp/ispvideo.c    |  25 +-
> >  drivers/media/platform/omap3isp/ispvideo.h    |   2 +-
> >  .../media/platform/qcom/camss/camss-video.c   |   6 +-
> >  drivers/media/platform/rcar-vin/rcar-csi2.c   | 188 +++++++++---
> >  drivers/media/platform/rcar-vin/rcar-dma.c    |   8 +-
> >  .../media/platform/s3c-camif/camif-capture.c  |   6 +-
> >  drivers/media/platform/vimc/vimc-capture.c    |   6 +-
> >  drivers/media/platform/vsp1/vsp1_video.c      |  18 +-
> >  drivers/media/platform/xilinx/xilinx-dma.c    |  20 +-
> >  drivers/media/platform/xilinx/xilinx-dma.h    |   2 +-
> >  drivers/media/usb/au0828/au0828-core.c        |   4 +-
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  75 +++++
> >  drivers/media/v4l2-core/v4l2-ioctl.c          |  20 +-
> >  drivers/media/v4l2-core/v4l2-mc.c             |  76 +++--
> >  drivers/media/v4l2-core/v4l2-subdev.c         | 285 ++++++++++++++++--
> >  .../staging/media/davinci_vpfe/vpfe_video.c   |  47 +--
> >  drivers/staging/media/imx/imx-media-utils.c   |   8 +-
> >  drivers/staging/media/omap4iss/iss.c          |   2 +-
> >  drivers/staging/media/omap4iss/iss_video.c    |  38 +--
> >  drivers/staging/media/omap4iss/iss_video.h    |   2 +-
> >  include/media/media-entity.h                  | 122 +++++---
> >  include/media/v4l2-mc.h                       |  22 ++
> >  include/media/v4l2-subdev.h                   |  34 +++
> >  include/uapi/linux/v4l2-subdev.h              |  40 +++
> >  36 files changed, 1239 insertions(+), 330 deletions(-)
> > 
> 
> -- 
> Trevliga hälsningar,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

-- 
Regards,
Niklas Söderlund
