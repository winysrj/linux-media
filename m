Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46437 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab3I3NfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 09:35:08 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 03/10] [media] coda: add compressed flag to format enumeration output
Date: Mon, 30 Sep 2013 15:34:46 +0200
Message-Id: <1380548093-22313-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
References: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correctly flag compressed formats in the ENUM_FMT ioctl output.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 945c539..53539c1 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -457,6 +457,8 @@ static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
 		fmt = &formats[i];
 		strlcpy(f->description, fmt->name, sizeof(f->description));
 		f->pixelformat = fmt->fourcc;
+		if (!coda_format_is_yuv(fmt->fourcc))
+			f->flags |= V4L2_FMT_FLAG_COMPRESSED;
 		return 0;
 	}
 
-- 
1.8.4.rc3

