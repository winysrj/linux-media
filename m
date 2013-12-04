Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50019 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab3LDT3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 14:29:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/3] V4L2 OF fixes
Date: Wed,  4 Dec 2013 20:29:05 +0100
Message-Id: <1386185348-2655-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here are three small fixes for the V4L2 OF parsing code. The patches should be
self-explanatory.

Laurent Pinchart (3):
  v4l: of: Return an int in v4l2_of_parse_endpoint()
  v4l: of: Remove struct v4l2_of_endpoint remote field
  v4l: of: Drop endpoint node reference in v4l2_of_get_remote_port()

 drivers/media/v4l2-core/v4l2-of.c | 10 +++++++---
 include/media/v4l2-of.h           |  6 ++----
 2 files changed, 9 insertions(+), 7 deletions(-)

-- 
Regards,

Laurent Pinchart

