Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:49285 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758966AbbLBRAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2015 12:00:19 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/5] [media] coda: hook up vidioc_prepare_buf
Date: Wed,  2 Dec 2015 17:58:52 +0100
Message-Id: <1449075534-8072-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1449075534-8072-1-git-send-email-p.zabel@pengutronix.de>
References: <1449075534-8072-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 03b46de..007f458 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -921,6 +921,7 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
 	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
 	.vidioc_create_bufs	= v4l2_m2m_ioctl_create_bufs,
+	.vidioc_prepare_buf	= v4l2_m2m_ioctl_prepare_buf,
 
 	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
-- 
2.6.2

