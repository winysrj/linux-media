Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37552 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbGPQZE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 12:25:04 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>,
	Ian Molton <imolton@ad-holdings.co.uk>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 0/5] i.MX5/6 mem2mem scaler
Date: Thu, 16 Jul 2015 18:24:38 +0200
Message-Id: <1437063883-23981-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this series uses the IPU IC post-processing task to implement
a mem2mem device for scaling and colorspace conversion. This
version addresses a few review commends, and includes some
further cleanup.

Changes since v2:
 - Limit downscaling to 4:1
 - Disabled USERPTR memory
 - Set icc pointer to NULL on error
 - Dropped currently unused IDMAC channels
 - Fixed scaler module description
 - Embedded struct video_device

If it is acceptable, I'd like to merge this through drm-next via imx-drm.
Mauro reportedly would be ok with that, and currently the potential for
conflicts is limited to drivers/media/{Kconfig,Makefile}. If not, I'll
postpone the two [media] patches for a release.

regards
Philipp

Philipp Zabel (3):
  gpu: ipu-v3: Add missing IDMAC channel names
  gpu: ipu-v3: Add mem2mem image conversion support to IC
  gpu: ipu-v3: Register scaler platform device

Sascha Hauer (2):
  [media] imx-ipu: Add ipu media common code
  [media] imx-ipu: Add i.MX IPUv3 scaler driver

 drivers/gpu/ipu-v3/ipu-common.c             |   2 +
 drivers/gpu/ipu-v3/ipu-ic.c                 | 754 +++++++++++++++++++++++-
 drivers/media/platform/Kconfig              |   2 +
 drivers/media/platform/Makefile             |   1 +
 drivers/media/platform/imx/Kconfig          |  11 +
 drivers/media/platform/imx/Makefile         |   2 +
 drivers/media/platform/imx/imx-ipu-scaler.c | 859 ++++++++++++++++++++++++++++
 drivers/media/platform/imx/imx-ipu.c        | 313 ++++++++++
 drivers/media/platform/imx/imx-ipu.h        |  36 ++
 include/video/imx-ipu-v3.h                  |  49 +-
 10 files changed, 2012 insertions(+), 17 deletions(-)
 create mode 100644 drivers/media/platform/imx/Kconfig
 create mode 100644 drivers/media/platform/imx/Makefile
 create mode 100644 drivers/media/platform/imx/imx-ipu-scaler.c
 create mode 100644 drivers/media/platform/imx/imx-ipu.c
 create mode 100644 drivers/media/platform/imx/imx-ipu.h

-- 
2.1.4

