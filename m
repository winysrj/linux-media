Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51240 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbcBJUzH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2016 15:55:07 -0500
Received: from avalon.localnet (85-23-193-79.bb.dnainternet.fi [85.23.193.79])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 7BEB6203A8
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2016 21:53:24 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.6] VSP1 patches
Date: Wed, 10 Feb 2016 22:55:27 +0200
Message-ID: <4317918.v13nm0kyWH@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 85e91f80cfc6c626f9afe1a4ca66447b8fd74315:

  Merge tag 'v4.5-rc3' into patchwork (2016-02-09 08:56:42 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to 94889923211c7d2fa9d46762c7636f43820a1692:

  v4l: vsp1: Configure device based on IP version (2016-02-10 15:38:11 +0200)

Could you please merge this in a stable branch that will be sent to Linus as-
is for v4.6 ? I have a series of DRM/KMS driver patches that depend on this 
patch set and want to get them merged in v4.6 as well.

All patches have been previously sent to the linux-media mailing list, and 
most included in the same pull request you've rejected for v4.5 as it 
conflicted with your work-in-progress media controller changes.

----------------------------------------------------------------
Laurent Pinchart (35):
      v4l: Add YUV 4:2:2 and YUV 4:4:4 tri-planar non-contiguous formats
      v4l: vsp1: Add tri-planar memory formats support
      v4l: vsp1: Group all link creation code in a single file
      v4l: vsp1: Change the type of the rwpf field in struct vsp1_video
      v4l: vsp1: Store the memory format in struct vsp1_rwpf
      v4l: vsp1: Move video operations to vsp1_rwpf
      v4l: vsp1: Rename vsp1_video_buffer to vsp1_vb2_buffer
      v4l: vsp1: Move video device out of struct vsp1_rwpf
      v4l: vsp1: Make rwpf operations independent of video device
      v4l: vsp1: Support VSP1 instances without any UDS
      v4l: vsp1: Move vsp1_video pointer from vsp1_entity to vsp1_rwpf
      v4l: vsp1: Remove struct vsp1_pipeline num_video field
      v4l: vsp1: Decouple pipeline end of frame processing from vsp1_video
      v4l: vsp1: Split pipeline management code from vsp1_video.c
      v4l: vsp1: Rename video pipeline functions to use vsp1_video prefix
      v4l: vsp1: Extract pipeline initialization code into a function
      v4l: vsp1: Reuse local variable instead of recomputing it
      v4l: vsp1: Extract link creation to separate function
      v4l: vsp1: Document the vsp1_pipeline structure
      v4l: vsp1: Fix typo in VI6_DISP_IRQ_STA_DST register bit name
      v4l: vsp1: Set the SRU CTRL0 register when starting the stream
      v4l: vsp1: Remove unused module read functions
      v4l: vsp1: Move entity route setup function to vsp1_entity.c
      v4l: vsp1: Make number of BRU inputs configurable
      v4l: vsp1: Make the BRU optional
      v4l: vsp1: Move format info to vsp1_pipe.c
      v4l: vsp1: Make the userspace API optional
      v4l: vsp1: Make pipeline inputs array index by RPF index
      v4l: vsp1: Set the alpha value manually in RPF and WPF s_stream handlers
      v4l: vsp1: Don't validate links when the userspace API is disabled
      v4l: vsp1: Add VSP+DU support
      v4l: vsp1: Disconnect unused RPFs from the DRM pipeline
      v4l: vsp1: Implement atomic update for the DRM driver
      v4l: vsp1: Add support for the R-Car Gen3 VSP2
      v4l: vsp1: Configure device based on IP version

Takashi Saito (1):
      v4l: vsp1: Add display list support

 Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml      | 166 +++++++
 Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml      | 177 +++++++
 Documentation/DocBook/media/v4l/pixfmt.xml              |   2 +
 .../devicetree/bindings/media/renesas,vsp1.txt          |  34 +-
 drivers/media/platform/vsp1/Makefile                    |   3 +-
 drivers/media/platform/vsp1/vsp1.h                      |  29 +-
 drivers/media/platform/vsp1/vsp1_bru.c                  |  33 +-
 drivers/media/platform/vsp1/vsp1_bru.h                  |   3 +-
 drivers/media/platform/vsp1/vsp1_dl.c                   | 305 ++++++++++++
 drivers/media/platform/vsp1/vsp1_dl.h                   |  42 ++
 drivers/media/platform/vsp1/vsp1_drm.c                  | 597 +++++++++++++++
 drivers/media/platform/vsp1/vsp1_drm.h                  |  38 ++
 drivers/media/platform/vsp1/vsp1_drv.c                  | 382 ++++++++++-----
 drivers/media/platform/vsp1/vsp1_entity.c               |  31 +-
 drivers/media/platform/vsp1/vsp1_entity.h               |  14 +-
 drivers/media/platform/vsp1/vsp1_hsit.c                 |   2 +-
 drivers/media/platform/vsp1/vsp1_lif.c                  |  11 +-
 drivers/media/platform/vsp1/vsp1_lut.c                  |   7 +-
 drivers/media/platform/vsp1/vsp1_pipe.c                 | 426 +++++++++++++++
 drivers/media/platform/vsp1/vsp1_pipe.h                 | 134 ++++++
 drivers/media/platform/vsp1/vsp1_regs.h                 |  32 +-
 drivers/media/platform/vsp1/vsp1_rpf.c                  |  88 ++--
 drivers/media/platform/vsp1/vsp1_rwpf.h                 |  29 +-
 drivers/media/platform/vsp1/vsp1_sru.c                  |   9 +-
 drivers/media/platform/vsp1/vsp1_uds.c                  |   8 +-
 drivers/media/platform/vsp1/vsp1_video.c                | 518 +++------------
 drivers/media/platform/vsp1/vsp1_video.h                | 111 +----
 drivers/media/platform/vsp1/vsp1_wpf.c                  |  98 ++--
 drivers/media/v4l2-core/v4l2-ioctl.c                    |   4 +
 include/media/vsp1.h                                    |  33 ++
 include/uapi/linux/videodev2.h                          |   4 +
 31 files changed, 2517 insertions(+), 853 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml
 create mode 100644 drivers/media/platform/vsp1/vsp1_dl.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_dl.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_drm.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_drm.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_pipe.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_pipe.h
 create mode 100644 include/media/vsp1.h

-- 
Regards,

Laurent Pinchart

