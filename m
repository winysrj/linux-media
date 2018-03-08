Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52104 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754781AbeCHAFh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 19:05:37 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v7 0/8] vsp1: TLB optimisation and DL caching
Date: Thu,  8 Mar 2018 00:05:23 +0000
Message-Id: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each display list currently allocates an area of DMA memory to store register
settings for the VSP1 to process. Each of these allocations adds pressure to
the IPMMU TLB entries.

We can reduce the pressure by pre-allocating larger areas and dividing the area
across multiple bodies represented as a pool.

With this reconfiguration of bodies, we can adapt the configuration code to
separate out constant hardware configuration and cache it for re-use.

The patches provided in this series can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git  tags/vsp1/tlb-optimise/v7

I hope that this series is at a stage where it could be integrated now.  It has
had some thorough testing and is already integrated in both renesas-drivers and
renesas-bsp. (except for the minor changes in v7 that is...)

Please note that checkpatch complains on patch 6/8 in this series:

v7-0006-media-vsp1-Refactor-display-list-configure-operations.patch
------------------------------------------------------------------------------------------------------
WARNING: function definition argument 'struct vsp1_entity *' should also have an identifier name
#290: FILE: drivers/media/platform/vsp1/vsp1_entity.h:82:
+       void (*configure_stream)(struct vsp1_entity *, struct vsp1_pipeline *,

However - this complaint is regarding pre-existing code. I have only renamed
the function pointers.  I do also disagree with checkpatch here - as there is
no need to provide an identifier name, and it does not improve readability in
this instance to state:
	...(vsp1_entity *entity, struct vsp1_pipeline *pipe)

Thus - I have ignored these warnings.


Changelog:
----------

v7:
 - Rebased on to linux-media/master (v4.16-rc4)
 - Clean up the formatting of the vsp1_dl_list_add_body()
 - Fix formatting and white space
 -  s/prepare/configure_stream/
 -  s/configure/configure_frame/

v6:
 - Rebased on to linux-media/master (v4.16-rc1)
 - Removed DRM/UIF (DISCOM/ColorKey) updates

v5:
 - Rebased on to renesas-drivers-2018-01-09-v4.15-rc7 to fix conflicts
   with DRM and UIF updates on VSP1 driver

v4:
 - Rebased to v4.14
 * v4l: vsp1: Use reference counting for bodies
   - Fix up reference handling comments

 * v4l: vsp1: Provide a body pool
   - Provide comment explaining extra allocation on body pool
     highlighting area for optimisation later.

 * v4l: vsp1: Refactor display list configure operations
   - Fix up comment to describe yuv_mode caching rather than format

 * vsp1: Adapt entities to configure into a body
   - Rename vsp1_dl_list_get_body() to vsp1_dl_list_get_body0()

 * v4l: vsp1: Move video configuration to a cached dlb
   - Adjust pipe configured flag to be reset on resume rather than suspend
   - rename dl_child, dl_next

Testing:
--------
The VSP unit tests have been run on this patch set with the following results:

--- Test loop 1 ---
- vsp-unit-test-0000.sh
Test Conditions:
  Platform          Renesas Salvator-X 2nd version board based on r8a7795 ES2.0+
  Kernel release    4.16.0-rc4-arm64-renesas-01067-g397eb3811ec0
  convert           /usr/bin/convert
  compare           /usr/bin/compare
  killall           /usr/bin/killall
  raw2rgbpnm        /usr/bin/raw2rgbpnm
  stress            /usr/bin/stress
  yavta             /usr/bin/yavta
- vsp-unit-test-0001.sh
Testing WPF packing in RGB332: pass
Testing WPF packing in ARGB555: pass
Testing WPF packing in XRGB555: pass
Testing WPF packing in RGB565: pass
Testing WPF packing in BGR24: pass
Testing WPF packing in RGB24: pass
Testing WPF packing in ABGR32: pass
Testing WPF packing in ARGB32: pass
Testing WPF packing in XBGR32: pass
Testing WPF packing in XRGB32: pass
- vsp-unit-test-0002.sh
Testing WPF packing in NV12M: pass
Testing WPF packing in NV16M: pass
Testing WPF packing in NV21M: pass
Testing WPF packing in NV61M: pass
Testing WPF packing in UYVY: pass
Testing WPF packing in VYUY: skip
Testing WPF packing in YUV420M: pass
Testing WPF packing in YUV422M: pass
Testing WPF packing in YUV444M: pass
Testing WPF packing in YVU420M: pass
Testing WPF packing in YVU422M: pass
Testing WPF packing in YVU444M: pass
Testing WPF packing in YUYV: pass
Testing WPF packing in YVYU: pass
- vsp-unit-test-0003.sh
Testing scaling from 640x640 to 640x480 in RGB24: pass
Testing scaling from 1024x768 to 640x480 in RGB24: pass
Testing scaling from 640x480 to 1024x768 in RGB24: pass
Testing scaling from 640x640 to 640x480 in YUV444M: pass
Testing scaling from 1024x768 to 640x480 in YUV444M: pass
Testing scaling from 640x480 to 1024x768 in YUV444M: pass
- vsp-unit-test-0004.sh
Testing histogram in RGB24: pass
Testing histogram in YUV444M: pass
- vsp-unit-test-0005.sh
Testing RPF.0: pass
Testing RPF.1: pass
Testing RPF.2: pass
Testing RPF.3: pass
Testing RPF.4: pass
- vsp-unit-test-0006.sh
Testing invalid pipeline with no RPF: pass
Testing invalid pipeline with no WPF: pass
- vsp-unit-test-0007.sh
Testing BRU in RGB24 with 1 inputs: pass
Testing BRU in RGB24 with 2 inputs: pass
Testing BRU in RGB24 with 3 inputs: pass
Testing BRU in RGB24 with 4 inputs: pass
Testing BRU in RGB24 with 5 inputs: pass
Testing BRU in YUV444M with 1 inputs: pass
Testing BRU in YUV444M with 2 inputs: pass
Testing BRU in YUV444M with 3 inputs: pass
Testing BRU in YUV444M with 4 inputs: pass
Testing BRU in YUV444M with 5 inputs: pass
- vsp-unit-test-0008.sh
Test requires unavailable feature set `bru rpf.0 uds wpf.0': skipped
- vsp-unit-test-0009.sh
Test requires unavailable feature set `rpf.0 wpf.0 wpf.1': skipped
- vsp-unit-test-0010.sh
Testing CLU in RGB24 with zero configuration: pass
Testing CLU in RGB24 with identity configuration: pass
Testing CLU in RGB24 with wave configuration: pass
Testing CLU in YUV444M with zero configuration: pass
Testing CLU in YUV444M with identity configuration: pass
Testing CLU in YUV444M with wave configuration: pass
Testing LUT in RGB24 with zero configuration: pass
Testing LUT in RGB24 with identity configuration: pass
Testing LUT in RGB24 with gamma configuration: pass
Testing LUT in YUV444M with zero configuration: pass
Testing LUT in YUV444M with identity configuration: pass
Testing LUT in YUV444M with gamma configuration: pass
- vsp-unit-test-0011.sh
Testing  hflip=0 vflip=0 rotate=0: pass
Testing  hflip=1 vflip=0 rotate=0: pass
Testing  hflip=0 vflip=1 rotate=0: pass
Testing  hflip=1 vflip=1 rotate=0: pass
Testing  hflip=0 vflip=0 rotate=90: pass
Testing  hflip=1 vflip=0 rotate=90: pass
Testing  hflip=0 vflip=1 rotate=90: pass
Testing  hflip=1 vflip=1 rotate=90: pass
- vsp-unit-test-0012.sh
Testing hflip: pass
Testing vflip: pass
- vsp-unit-test-0013.sh
Testing RPF unpacking in RGB332: pass
Testing RPF unpacking in ARGB555: pass
Testing RPF unpacking in XRGB555: pass
Testing RPF unpacking in RGB565: pass
Testing RPF unpacking in BGR24: pass
Testing RPF unpacking in RGB24: pass
Testing RPF unpacking in ABGR32: pass
Testing RPF unpacking in ARGB32: pass
Testing RPF unpacking in XBGR32: pass
Testing RPF unpacking in XRGB32: pass
- vsp-unit-test-0014.sh
Testing RPF unpacking in NV12M: pass
Testing RPF unpacking in NV16M: pass
Testing RPF unpacking in NV21M: pass
Testing RPF unpacking in NV61M: pass
Testing RPF unpacking in UYVY: pass
Testing RPF unpacking in VYUY: skip
Testing RPF unpacking in YUV420M: pass
Testing RPF unpacking in YUV422M: pass
Testing RPF unpacking in YUV444M: pass
Testing RPF unpacking in YVU420M: pass
Testing RPF unpacking in YVU422M: pass
Testing RPF unpacking in YVU444M: pass
Testing RPF unpacking in YUYV: pass
Testing RPF unpacking in YVYU: pass
- vsp-unit-test-0015.sh
Testing SRU scaling from 1024x768 to 1024x768 in RGB24: pass
Testing SRU scaling from 1024x768 to 2048x1536 in RGB24: pass
Testing SRU scaling from 1024x768 to 1024x768 in YUV444M: pass
Testing SRU scaling from 1024x768 to 2048x1536 in YUV444M: pass
- vsp-unit-test-0016.sh
Testing  hflip=0 vflip=0 rotate=0 640x480 -> 640x480: pass
Testing  hflip=0 vflip=0 rotate=0 640x480 -> 1024x768: pass
Testing  hflip=0 vflip=0 rotate=0 1024x768 -> 640x480: pass
Testing  hflip=1 vflip=0 rotate=0 640x480 -> 640x480: pass
Testing  hflip=1 vflip=0 rotate=0 640x480 -> 1024x768: pass
Testing  hflip=1 vflip=0 rotate=0 1024x768 -> 640x480: pass
Testing  hflip=0 vflip=1 rotate=0 640x480 -> 640x480: pass
Testing  hflip=0 vflip=1 rotate=0 640x480 -> 1024x768: pass
Testing  hflip=0 vflip=1 rotate=0 1024x768 -> 640x480: pass
Testing  hflip=1 vflip=1 rotate=0 640x480 -> 640x480: pass
Testing  hflip=1 vflip=1 rotate=0 640x480 -> 1024x768: pass
Testing  hflip=1 vflip=1 rotate=0 1024x768 -> 640x480: pass
Testing  hflip=0 vflip=0 rotate=90 640x480 -> 640x480: pass
Testing  hflip=0 vflip=0 rotate=90 640x480 -> 1024x768: pass
Testing  hflip=0 vflip=0 rotate=90 1024x768 -> 640x480: pass
Testing  hflip=1 vflip=0 rotate=90 640x480 -> 640x480: pass
Testing  hflip=1 vflip=0 rotate=90 640x480 -> 1024x768: pass
Testing  hflip=1 vflip=0 rotate=90 1024x768 -> 640x480: pass
Testing  hflip=0 vflip=1 rotate=90 640x480 -> 640x480: pass
Testing  hflip=0 vflip=1 rotate=90 640x480 -> 1024x768: pass
Testing  hflip=0 vflip=1 rotate=90 1024x768 -> 640x480: pass
Testing  hflip=1 vflip=1 rotate=90 640x480 -> 640x480: pass
Testing  hflip=1 vflip=1 rotate=90 640x480 -> 1024x768: pass
Testing  hflip=1 vflip=1 rotate=90 1024x768 -> 640x480: pass
- vsp-unit-test-0017.sh
- vsp-unit-test-0018.sh
Testing RPF crop from (0,0)/512x384: pass
Testing RPF crop from (32,32)/512x384: pass
Testing RPF crop from (32,64)/512x384: pass
Testing RPF crop from (64,32)/512x384: pass
- vsp-unit-test-0019.sh
- vsp-unit-test-0020.sh
- vsp-unit-test-0021.sh
Testing WPF packing in RGB332 during stress testing: pass
Testing WPF packing in ARGB555 during stress testing: pass
Testing WPF packing in XRGB555 during stress testing: pass
Testing WPF packing in RGB565 during stress testing: pass
Testing WPF packing in BGR24 during stress testing: pass
Testing WPF packing in RGB24 during stress testing: pass
Testing WPF packing in ABGR32 during stress testing: pass
Testing WPF packing in ARGB32 during stress testing: pass
Testing WPF packing in XBGR32 during stress testing: pass
Testing WPF packing in XRGB32 during stress testing: pass
./vsp-unit-test-0021.sh: line 34:  4489 Killed                  stress --cpu 8 --io 4 --vm 2 --vm-bytes 128M
- vsp-unit-test-0022.sh
Testing long duration pipelines under stress: pass
./vsp-unit-test-0022.sh: line 38:  6457 Killed                  stress --cpu 8 --io 4 --vm 2 --vm-bytes 128M
- vsp-unit-test-0023.sh
Testing histogram HGT with hue areas 0,255,255,255,255,255,255,255,255,255,255,255: pass
Testing histogram HGT with hue areas 0,40,40,80,80,120,120,160,160,200,200,255: pass
Testing histogram HGT with hue areas 220,40,40,80,80,120,120,160,160,200,200,220: pass
Testing histogram HGT with hue areas 0,10,50,60,100,110,150,160,200,210,250,255: pass
Testing histogram HGT with hue areas 10,20,50,60,100,110,150,160,200,210,230,240: pass
Testing histogram HGT with hue areas 240,20,60,80,100,120,140,160,180,200,210,220: pass
- vsp-unit-test-0024.sh
Test requires unavailable feature set `rpf.0 rpf.1 brs wpf.0': skipped
158 tests: 142 passed, 0 failed, 3 skipped

Kieran Bingham (8):
  media: vsp1: Reword uses of 'fragment' as 'body'
  media: vsp1: Protect bodies against overflow
  media: vsp1: Provide a body pool
  media: vsp1: Convert display lists to use new body pool
  media: vsp1: Use reference counting for bodies
  media: vsp1: Refactor display list configure operations
  media: vsp1: Adapt entities to configure into a body
  media: vsp1: Move video configuration to a cached dlb

 drivers/media/platform/vsp1/vsp1_bru.c    |  32 +--
 drivers/media/platform/vsp1/vsp1_clu.c    | 102 +++---
 drivers/media/platform/vsp1/vsp1_clu.h    |   1 +-
 drivers/media/platform/vsp1/vsp1_dl.c     | 393 +++++++++++++----------
 drivers/media/platform/vsp1/vsp1_dl.h     |  19 +-
 drivers/media/platform/vsp1/vsp1_drm.c    |  35 +--
 drivers/media/platform/vsp1/vsp1_entity.c |  26 +-
 drivers/media/platform/vsp1/vsp1_entity.h |  38 +-
 drivers/media/platform/vsp1/vsp1_hgo.c    |  26 +--
 drivers/media/platform/vsp1/vsp1_hgt.c    |  28 +--
 drivers/media/platform/vsp1/vsp1_hsit.c   |  20 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |  25 +-
 drivers/media/platform/vsp1/vsp1_lut.c    |  77 +++--
 drivers/media/platform/vsp1/vsp1_lut.h    |   1 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |  11 +-
 drivers/media/platform/vsp1/vsp1_pipe.h   |   7 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 183 +++++------
 drivers/media/platform/vsp1/vsp1_sru.c    |  24 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |  75 ++--
 drivers/media/platform/vsp1/vsp1_uds.h    |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c  |  82 ++---
 drivers/media/platform/vsp1/vsp1_video.h  |   2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    | 327 +++++++++----------
 23 files changed, 845 insertions(+), 691 deletions(-)

base-commit: 8514509ba5933f4e4ade0d5d81be117f18c1ebd2
-- 
git-series 0.9.1
