Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43884 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaGZOel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 10:34:41 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so2327299wib.2
        for <linux-media@vger.kernel.org>; Sat, 26 Jul 2014 07:34:40 -0700 (PDT)
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 2/3] [media] coda: fix coda_g_selection
Date: Sat, 26 Jul 2014 16:34:31 +0200
Message-Id: <1406385272-425-2-git-send-email-philipp.zabel@gmail.com>
In-Reply-To: <1406385272-425-1-git-send-email-philipp.zabel@gmail.com>
References: <1406385272-425-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Crop targets are valid on the capture side and compose targets are valid
on the output side, not the other way around.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/platform/coda/coda-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 95d0b04..b542340 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -600,7 +600,7 @@ static int coda_g_selection(struct file *file, void *fh,
 		rsel = &r;
 		/* fallthrough */
 	case V4L2_SEL_TGT_CROP:
-		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 			return -EINVAL;
 		break;
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
@@ -609,7 +609,7 @@ static int coda_g_selection(struct file *file, void *fh,
 		/* fallthrough */
 	case V4L2_SEL_TGT_COMPOSE:
 	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
-		if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 			return -EINVAL;
 		break;
 	default:
-- 
2.0.1

