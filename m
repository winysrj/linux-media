Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:60501 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0G3UZB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 16:25:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 0/2] Per-subdev, host-specific data
Date: Fri, 30 Jul 2010 22:24:53 +0200
Message-Id: <1280521495-19922-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Following up on the per-subdev, host-specific data RFC, here are two patches
that implement the feature.

The first patch fixes various subdev drivers not to access the v4l2_subdev::priv
field directly but use v4l2_get_subdevdata instead. As the function is a static
inline that just returns v4l2_subdev::priv, there shouldn't be any performance
or code size impact.

The second patch introduces the v4l2_subdev::host_priv field and renames the
existing priv field to dev_priv, as suggested by Hans Verkuil.

Host-specific per-subdev data will be needed by the OMAP3 ISP driver. Even if
the patches are not applied now, I'd like to get them reviewed and acked.

Laurent Pinchart (2):
  v4l: Use v4l2_get_subdevdata instead of accessing v4l2_subdev::priv
  v4l: Add a v4l2_subdev host private data field

 Documentation/video4linux/v4l2-framework.txt |    5 +++++
 drivers/media/video/mt9m001.c                |   26 +++++++++++++-------------
 drivers/media/video/mt9m111.c                |   20 ++++++++++----------
 drivers/media/video/mt9t031.c                |   24 ++++++++++++------------
 drivers/media/video/mt9t112.c                |   14 +++++++-------
 drivers/media/video/mt9v022.c                |   26 +++++++++++++-------------
 drivers/media/video/ov772x.c                 |   18 +++++++++---------
 drivers/media/video/ov9640.c                 |   12 ++++++------
 drivers/media/video/rj54n1cb0c.c             |   26 +++++++++++++-------------
 drivers/media/video/soc_camera.c             |    2 +-
 drivers/media/video/tw9910.c                 |   20 ++++++++++----------
 include/media/v4l2-subdev.h                  |   20 ++++++++++++++++----
 12 files changed, 115 insertions(+), 98 deletions(-)

-- 
Regards,

Laurent Pinchart

