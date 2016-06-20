Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52954 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836AbcFTTML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:12:11 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 16/24] v4l: vsp1: sru: Fix intensity control ID
Date: Mon, 20 Jun 2016 22:10:34 +0300
Message-Id: <1466449842-29502-17-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The intensity control reused the V4L2_CID_CONTRAST control ID by
mistake. Fix it by using an ID from the device-specific IDs range.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_sru.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 9dc7c77c74f8..1a01f9a43875 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -37,7 +37,7 @@ static inline void vsp1_sru_write(struct vsp1_sru *sru, struct vsp1_dl_list *dl,
  * Controls
  */
 
-#define V4L2_CID_VSP1_SRU_INTENSITY		(V4L2_CID_USER_BASE + 1)
+#define V4L2_CID_VSP1_SRU_INTENSITY		(V4L2_CID_USER_BASE | 0x1001)
 
 struct vsp1_sru_param {
 	u32 ctrl0;
-- 
Regards,

Laurent Pinchart

