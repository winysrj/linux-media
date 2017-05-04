Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:38562 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdEDKxk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 06:53:40 -0400
From: agheorghe <Alexandru_Gheorghe@mentor.com>
To: <Alexandru_Gheorghe@mentor.com>,
        <laurent.pinchart@ideasonboard.com>,
        <linux-renesas-soc@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] rcar-du, vsp1: rcar-gen3: Add support for colorkey alpha blending
Date: Thu, 4 May 2017 13:53:31 +0300
Message-ID: <1493895213-12573-1-git-send-email-Alexandru_Gheorghe@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, rcar-du supports colorkeying  only for rcar-gen2 and it uses 
some hw capability of the display unit(DU) which is not available on gen3.
In order to implement colorkeying for gen3 we need to use the colorkey
capability of the VSPD, hence the need to change both drivers rcar-du and
vsp1.

This patchset had been developed and tested on top of v4.9/rcar-3.5.1 from
git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas-bsp.git

agheorghe (2):
  v4l: vsp1: Add support for colorkey alpha blending
  drm: rcar-du: Add support for colorkey alpha blending

 drivers/gpu/drm/rcar-du/rcar_du_drv.h   |  1 +
 drivers/gpu/drm/rcar-du/rcar_du_kms.c   |  8 ++++++++
 drivers/gpu/drm/rcar-du/rcar_du_plane.c |  3 ---
 drivers/gpu/drm/rcar-du/rcar_du_plane.h |  6 ++++++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c   | 22 ++++++++++++++++++++++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h   |  5 +++++
 drivers/media/platform/vsp1/vsp1_drm.c  |  3 +++
 drivers/media/platform/vsp1/vsp1_rpf.c  | 10 ++++++++--
 drivers/media/platform/vsp1/vsp1_rwpf.h |  3 +++
 include/media/vsp1.h                    |  3 +++
 10 files changed, 59 insertions(+), 5 deletions(-)

-- 
1.9.1
