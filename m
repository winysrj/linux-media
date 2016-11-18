Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:42904 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753708AbcKRXVY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:24 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 28/35] media: ti-vpe: vpe: Enable DMABUF export
Date: Fri, 18 Nov 2016 17:20:38 -0600
Message-ID: <20161118232045.24665-29-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow VPE to be able to export DMA buffer.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 608d11344147..1d780ac7ff82 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1944,6 +1944,7 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
 	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
 	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
 	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
+	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
 	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 
-- 
2.9.0

