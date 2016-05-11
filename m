Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49356 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbcEKNXD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 09:23:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Dave Airlie <airlied@linux.ie>
Subject: [GIT PULL FOR v4.7] Renesas VSP updates
Date: Wed, 11 May 2016 16:23:01 +0300
Message-ID: <146308505.rpggZ7d6pq@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit aff093d4bbca91f543e24cde2135f393b8130f4b:

  [media] exynos-gsc: avoid build warning without CONFIG_OF (2016-05-09 
18:38:33 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to 01986b08a08353a23bc89a588a14966cb0a09e0d:

  v4l: vsp1: Remove deprecated DRM API (2016-05-11 16:07:44 +0300)

Please note that the pull request includes two patches for the rcar-du-drm 
driver. They depend on previous patches for the vsp1 driver in the same 
series, and the last vsp1 patch depends on them. For this reason I'm 
submitting everything in a single pull request to you, with Dave's ack to get 
the rcar-du-drm patches merged through your tree. They shouldn't conflict with 
anything queued in Dave's tree for v4.7.

----------------------------------------------------------------
Laurent Pinchart (13):
      dt-bindings: Add Renesas R-Car FCP DT bindings
      v4l: Add Renesas R-Car FCP driver
      v4l: vsp1: Implement runtime PM support
      v4l: vsp1: Don't handle clocks manually
      v4l: vsp1: Add FCP support
      v4l: vsp1: Add output node value to routing table
      v4l: vsp1: Replace container_of() with dedicated macro
      v4l: vsp1: Make vsp1_entity_get_pad_compose() more generic
      v4l: vsp1: Move frame sequence number from video node to pipeline
      v4l: vsp1: Group DRM RPF parameters in a structure
      drm: rcar-du: Add alpha support for VSP planes
      drm: rcar-du: Add Z-order support for VSP planes
      v4l: vsp1: Remove deprecated DRM API

 Documentation/devicetree/bindings/media/renesas,fcp.txt |  32 +++++
 .../devicetree/bindings/media/renesas,vsp1.txt          |   5 +                        
 MAINTAINERS                                             |  10 ++                       
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c                   |  45 +++---                   
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h                   |   2 +                        
 drivers/media/platform/Kconfig                          |  14 ++                       
 drivers/media/platform/Makefile                         |   1 +                        
 drivers/media/platform/rcar-fcp.c                       | 181 +++++++++++++++ 
 drivers/media/platform/vsp1/vsp1.h                      |   6 +-                       
 drivers/media/platform/vsp1/vsp1_drm.c                  |  68 ++++-----                
 drivers/media/platform/vsp1/vsp1_drv.c                  | 120 +++++++--------         
 drivers/media/platform/vsp1/vsp1_entity.c               |  88 ++++++++----             
 drivers/media/platform/vsp1/vsp1_entity.h               |  12 +-                       
 drivers/media/platform/vsp1/vsp1_pipe.c                 |   4 +-                       
 drivers/media/platform/vsp1/vsp1_pipe.h                 |   2 +                        
 drivers/media/platform/vsp1/vsp1_rpf.c                  |   7 +-                       
 drivers/media/platform/vsp1/vsp1_video.c                |   4 +-                       
 drivers/media/platform/vsp1/vsp1_video.h                |   1 -                        
 include/media/rcar-fcp.h                                |  37 +++++                    
 include/media/vsp1.h                                    |  29 ++--
 20 files changed, 497 insertions(+), 171 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,fcp.txt
 create mode 100644 drivers/media/platform/rcar-fcp.c
 create mode 100644 include/media/rcar-fcp.h

-- 
Regards,

Laurent Pinchart

