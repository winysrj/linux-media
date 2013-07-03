Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47610 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3GCKwY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jul 2013 06:52:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/2] V4L2 OF fixes
Date: Wed,  3 Jul 2013 12:52:47 +0200
Message-Id: <1372848769-6390-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here are two small fixes for the V4L2 OF parsing code. The patches should be
self-explanatory.

Laurent Pinchart (2):
  v4l: of: Use of_get_child_by_name()
  v4l: of: Drop acquired reference to node when getting next endpoint

 drivers/media/v4l2-core/v4l2-of.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

-- 
Regards,

Laurent Pinchart

