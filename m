Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56460 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbcESXkb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 19:40:31 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v4 0/6] R-Car VSP: Add and set media entities functions
Date: Fri, 20 May 2016 02:40:26 +0300
Message-Id: <1463701232-22008-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series adds new media entities functions for video processing and
video statistics computation, and updates the VSP driver to use the new
functions.

Patches 1/6 and 2/6 define and document the new functions. They have been
submitted previously in the "[PATCH v2 00/54] R-Car VSP improvements for v4.7"
patch series, this version takes feedback received over e-mail and IRC into
account.

Patches 3/6 to 5/6 prepare the VSP driver to report the correct entity
functions. They make sure that the LIF will never be exposed to userspace as
no function currently exists for that block, and it isn't clear at the moment
what new function should be added. As the LIF is only needed when the VSP is
controlled directly from the DU driver without being exposed to userspace, a
function isn't needed for the LIF anyway.

Patch 6/6 finally sets functions for all the VSP entities.

The code is based on top of the "[PATCH/RFC v2 0/4] Meta-data video device
type" patch series, although it doesn't strictly depend on it. For convenience
I've pushed all patches to

	git://linuxtv.org/pinchartl/media.git vsp1/functions

Laurent Pinchart (6):
  media: Add video processing entity functions
  media: Add video statistics computation functions
  v4l: vsp1: Base link creation on availability of entities
  v4l: vsp1: Don't register media device when userspace API is disabled
  v4l: vsp1: Don't create LIF entity when the userspace API is enabled
  v4l: vsp1: Set entities functions

 Documentation/DocBook/media/v4l/media-types.xml | 64 +++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_bru.c          |  3 +-
 drivers/media/platform/vsp1/vsp1_drv.c          | 36 +++++++-------
 drivers/media/platform/vsp1/vsp1_entity.c       |  3 +-
 drivers/media/platform/vsp1/vsp1_entity.h       |  2 +-
 drivers/media/platform/vsp1/vsp1_hgo.c          |  3 +-
 drivers/media/platform/vsp1/vsp1_hsit.c         |  5 +-
 drivers/media/platform/vsp1/vsp1_lif.c          |  7 ++-
 drivers/media/platform/vsp1/vsp1_lut.c          |  3 +-
 drivers/media/platform/vsp1/vsp1_rpf.c          |  3 +-
 drivers/media/platform/vsp1/vsp1_sru.c          |  3 +-
 drivers/media/platform/vsp1/vsp1_uds.c          |  3 +-
 drivers/media/platform/vsp1/vsp1_wpf.c          |  3 +-
 include/uapi/linux/media.h                      | 10 ++++
 14 files changed, 119 insertions(+), 29 deletions(-)

-- 
Regards,

Laurent Pinchart

