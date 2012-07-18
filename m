Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59144 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2GRN6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 09:58:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 0/9] Miscellaneous ov772x cleanups and fixes
Date: Wed, 18 Jul 2012 15:58:17 +0200
Message-Id: <1342619906-5820-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here's the second version of the ov772x cleanup and fixes patches. They apply
on top of my previous "Miscellaneous soc-camera patches" (v3) series.

Changes compared to v1:

- Dropped the "Reorganize the code in sections" patch.
- Use UINT_MAX instead of reinventing it (2/9)
- Add OV772X_DEFAULT_{WIDTH,HEIGHT} macros (8/9) instead of hardcoding values.

Laurent Pinchart (9):
  ov772x: Fix memory leak in probe error path
  ov772x: Select the default format at probe time
  ov772x: Don't fail in s_fmt if the requested format isn't supported
  ov772x: try_fmt must not default to the current format
  ov772x: Make to_ov772x convert from v4l2_subdev to ov772x_priv
  ov772x: Add ov772x_read() and ov772x_write() functions
  ov772x: Add support for SBGGR10 format
  ov772x: Compute window size registers at runtime
  ov772x: Stop sensor readout right after reset

 drivers/media/video/ov772x.c |  426 ++++++++++++++++++++----------------------
 1 files changed, 207 insertions(+), 219 deletions(-)

-- 
Regards,

Laurent Pinchart

