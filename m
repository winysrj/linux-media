Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60064 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab2GFOez (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 10:34:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 00/10] Miscellaneous ov772x cleanups and fixes
Date: Fri,  6 Jul 2012 16:34:51 +0200
Message-Id: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

The subject line says it all :-) These patches have been written while
preparing the ov772x driver for being used with a non soc-camera host.
They apply on top of my previous soc-camera patch series.

Laurent Pinchart (10):
  ov772x: Reorganize the code in sections
  ov772x: Fix memory leak in probe error path
  ov772x: Select the default format at probe time
  ov772x: Don't fail in s_fmt if the requested format isn't supported
  ov772x: try_fmt must not default to the current format
  ov772x: Make to_ov772x convert from v4l2_subdev to ov772x_priv
  ov772x: Add ov772x_read() and ov772x_write() functions
  ov772x: Add support for SBGGR10 format
  ov772x: Compute window size registers at runtime
  ov772x: Stop sensor readout right after reset

 drivers/media/video/ov772x.c |  801 +++++++++++++++++++++---------------------
 1 files changed, 398 insertions(+), 403 deletions(-)

-- 
Regards,

Laurent Pinchart

