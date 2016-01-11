Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54852 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759914AbcAKMLm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 07:11:42 -0500
Date: Mon, 11 Jan 2016 10:11:37 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.5] Renesas VSP1 improvements and fixes
Message-ID: <20160111101137.30d31746@recife.lan>
In-Reply-To: <7908253.mS4kyImJeJ@avalon>
References: <3880424.K6feHa190s@avalon>
	<7908253.mS4kyImJeJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 06 Jan 2016 12:05:34 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> I think this one slipped through the cracks, or possibly got buried under the 
> winter holidays snowstorm :-) Could you tell me what your plans are ?

Actually, I got vacations just after holidays. I'm still on vacations, but
I'm doing a short break on my vacations today to handle a few things.

Unfortunately, it is too late to review this for the 4.5 merge window.
So, it should be postponed.

Regards,
Mauro

> 
> On Wednesday 16 December 2015 10:41:16 Laurent Pinchart wrote:
> > Hi Mauro,
> > 
> > The following changes since commit 52d60eb7e6d6429a766ea1b8f67e01c3b2dcd3c5:
> > 
> >   Revert "[media] UVC: Add support for ds4 depth camera" (2015-12-12
> > 08:10:40 -0200)
> > 
> > are available in the git repository at:
> > 
> >   git://linuxtv.org/pinchartl/media.git vsp1/next
> > 
> > for you to fetch changes up to 41db244b5b484f3f2afc1834552d6771f05c2ebe:
> > 
> >   v4l: vsp1: Add display list support (2015-12-16 10:37:47 +0200)
> > 
> > ----------------------------------------------------------------
> > Laurent Pinchart (31):
> >       v4l: vsp1: Change the type of the rwpf field in struct vsp1_video
> >       v4l: vsp1: Store the memory format in struct vsp1_rwpf
> >       v4l: vsp1: Move video operations to vsp1_rwpf
> >       v4l: vsp1: Rename vsp1_video_buffer to vsp1_vb2_buffer
> >       v4l: vsp1: Move video device out of struct vsp1_rwpf
> >       v4l: vsp1: Make rwpf operations independent of video device
> >       v4l: vsp1: Support VSP1 instances without any UDS
> >       v4l: vsp1: Move vsp1_video pointer from vsp1_entity to vsp1_rwpf
> >       v4l: vsp1: Remove struct vsp1_pipeline num_video field
> >       v4l: vsp1: Decouple pipeline end of frame processing from vsp1_video
> >       v4l: vsp1: Split pipeline management code from vsp1_video.c
> >       v4l: vsp1: Rename video pipeline functions to use vsp1_video prefix
> >       v4l: vsp1: Extract pipeline initialization code into a function
> >       v4l: vsp1: Reuse local variable instead of recomputing it
> >       v4l: vsp1: Extract link creation to separate function
> >       v4l: vsp1: Document the vsp1_pipeline structure
> >       v4l: vsp1: Fix typo in VI6_DISP_IRQ_STA_DST register bit name
> >       v4l: vsp1: Set the SRU CTRL0 register when starting the stream
> >       v4l: vsp1: Remove unused module read functions
> >       v4l: vsp1: Move entity route setup function to vsp1_entity.c
> >       v4l: vsp1: Make number of BRU inputs configurable
> >       v4l: vsp1: Make the BRU optional
> >       v4l: vsp1: Move format info to vsp1_pipe.c
> >       v4l: vsp1: Make the userspace API optional
> >       v4l: vsp1: Make pipeline inputs array index by RPF index
> >       v4l: vsp1: Set the alpha value manually in RPF and WPF s_stream
> > handlers v4l: vsp1: Don't validate links when the userspace API is disabled
> > v4l: vsp1: Add VSP+DU support
> >       v4l: vsp1: Disconnect unused RPFs from the DRM pipeline
> >       v4l: vsp1: Implement atomic update for the DRM driver
> >       v4l: vsp1: Add support for the R-Car Gen3 VSP2
> > 
> > Takashi Saito (1):
> >       v4l: vsp1: Add display list support
> > 
> >  .../devicetree/bindings/media/renesas,vsp1.txt          |  21 +-
> >  drivers/media/platform/vsp1/Makefile                    |   3 +-
> >  drivers/media/platform/vsp1/vsp1.h                      |  24 +
> >  drivers/media/platform/vsp1/vsp1_bru.c                  |  33 +-
> >  drivers/media/platform/vsp1/vsp1_bru.h                  |   3 +-
> >  drivers/media/platform/vsp1/vsp1_dl.c                   | 304 ++++++++++++
> >  drivers/media/platform/vsp1/vsp1_dl.h                   |  42 ++
> >  drivers/media/platform/vsp1/vsp1_drm.c                  | 597 +++++++++++++
> >  drivers/media/platform/vsp1/vsp1_drm.h                  |  38 ++
> >  drivers/media/platform/vsp1/vsp1_drv.c                  | 254 ++++++++--
> >  drivers/media/platform/vsp1/vsp1_entity.c               |  31 +-
> >  drivers/media/platform/vsp1/vsp1_entity.h               |  14 +-
> >  drivers/media/platform/vsp1/vsp1_hsit.c                 |   2 +-
> >  drivers/media/platform/vsp1/vsp1_lif.c                  |  11 +-
> >  drivers/media/platform/vsp1/vsp1_lut.c                  |   7 +-
> >  drivers/media/platform/vsp1/vsp1_pipe.c                 | 405 +++++++++++++
> >  drivers/media/platform/vsp1/vsp1_pipe.h                 | 134 ++++++
> >  drivers/media/platform/vsp1/vsp1_regs.h                 |  32 +-
> >  drivers/media/platform/vsp1/vsp1_rpf.c                  |  77 ++-
> >  drivers/media/platform/vsp1/vsp1_rwpf.h                 |  24 +-
> >  drivers/media/platform/vsp1/vsp1_sru.c                  |   9 +-
> >  drivers/media/platform/vsp1/vsp1_uds.c                  |   8 +-
> >  drivers/media/platform/vsp1/vsp1_video.c                | 516 ++----------
> >  drivers/media/platform/vsp1/vsp1_video.h                | 111 +----
> >  drivers/media/platform/vsp1/vsp1_wpf.c                  |  88 ++--
> >  include/media/vsp1.h                                    |  33 ++
> >  26 files changed, 2071 insertions(+), 750 deletions(-)
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_dl.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_dl.h
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_drm.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_drm.h
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_pipe.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_pipe.h
> 
