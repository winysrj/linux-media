Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44710 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdB1PJJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 10:09:09 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 0/3] Renesas R-Car VSP1 rotation support
Date: Tue, 28 Feb 2017 17:03:17 +0200
Message-Id: <20170228150320.10104-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everybody,

This patch series implement support for rotation in the VSP1 driver. It
contains an update of the rotation support part of the "[PATCH 00/13]
Renesas R-Car VSP: Scaling and rotation support on Gen3" series.

Patch 1/3 starts by fixing the multi-line comment style through the whole
driver to avoid adding new offenders in patch 3/3.

Patch 2/3 is to biggest addition since v1. It clarifies interactions between
formats, controls and buffers in the V4L2 API documentation. The proposal is
based on an IRC meeting held on 2016-09-15 in the #v4l channel on freenode
which I have tried to translate as accurately as possible into documentation.

Patch 3/3 implements rotation support in the vsp1 driver. Beside being rebased
on top of the current vsp1/next branch, it has mostly been kept unchanged
compared to v1.

For your convenience the code is available at

	git://linuxtv.org/pinchartl/media.git vsp1-rotation-v2-20170228

Laurent Pinchart (3):
  v4l: vsp1: Fix multi-line comment style
  v4l: Clearly document interactions between formats, controls and
    buffers
  v4l: vsp1: wpf: Implement rotation support

 Documentation/media/uapi/v4l/buffer.rst   |  88 ++++++++++++
 drivers/media/platform/vsp1/vsp1_bru.c    |  27 ++--
 drivers/media/platform/vsp1/vsp1_dl.c     |  27 ++--
 drivers/media/platform/vsp1/vsp1_drm.c    |  21 ++-
 drivers/media/platform/vsp1/vsp1_drv.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_entity.c |   9 +-
 drivers/media/platform/vsp1/vsp1_hsit.c   |   3 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |   9 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    |  11 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c   |  11 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h   |   3 +-
 drivers/media/platform/vsp1/vsp1_sru.c    |   3 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |   3 +-
 drivers/media/platform/vsp1/vsp1_video.c  |  45 +++++--
 drivers/media/platform/vsp1/vsp1_wpf.c    | 215 +++++++++++++++++++++++-------
 16 files changed, 382 insertions(+), 111 deletions(-)

-- 
Regards,

Laurent Pinchart
