Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46565 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760488Ab3GaPvl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 11:51:41 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v4 6/7] vsp1: Fix lack of the sink entity registration for enabled links
Date: Wed, 31 Jul 2013 17:52:33 +0200
Message-Id: <1375285954-32153-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375285954-32153-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1375285954-32153-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Katsuya Matsubara <matsu@igel.co.jp>

Each source entity maintains a pointer to the counterpart sink
entity while an enabled link connects them. It should be managed by
the setup_link callback in the media controller framework at runtime.
However, enabled links which connect RPFs and WPFs that have an
equivalent index number are created during initialization.
This registers the pointer to a sink entity from the source entity
when an enabled link is created.

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index b05aee1..4d338ce 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -101,6 +101,9 @@ static int vsp1_create_links(struct vsp1_device *vsp1, struct vsp1_entity *sink)
 						       entity, pad, flags);
 			if (ret < 0)
 				return ret;
+
+			if (flags & MEDIA_LNK_FL_ENABLED)
+				source->sink = entity;
 		}
 	}
 
-- 
1.8.1.5

