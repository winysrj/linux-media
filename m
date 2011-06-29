Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30330 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab1F2MwA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 08:52:00 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNJ009BTYEGZV@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:53 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNJ0017SYEF0G@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:51 +0100 (BST)
Date: Wed, 29 Jun 2011 14:51:14 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 5/8] v4l: fix v4l_fill_dv_preset_info function
In-reply-to: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <1309351877-32444-6-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The function fills struct v4l2_dv_enum_preset with appropriate
preset parameters but it forgets to zero field named reserved.
This patch fixes this bug.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/video/v4l2-common.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 003e648..e7c02e9 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -592,6 +592,8 @@ int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
 	info->width = dv_presets[preset].width;
 	info->height = dv_presets[preset].height;
 	strlcpy(info->name, dv_presets[preset].name, sizeof(info->name));
+	/* assure that reserved fields are zeroed */
+	memset(info->reserved, 0, sizeof(info->reserved));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
-- 
1.7.5.4

