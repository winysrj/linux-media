Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51037 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbbEGG0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2015 02:26:36 -0400
Message-ID: <554B058D.2040001@xs4all.nl>
Date: Thu, 07 May 2015 08:26:21 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Subject: [PATCH] rcar-vin: use monotonic timestamps
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Even though the rcar-vin driver tells userspace that it will give a monotonic
timestamp, it is actually using gettimeofday. Replace this with a proper
monotonic timestamp.

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 35deed8..b64dfea 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -894,7 +894,7 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
 
 		priv->queue_buf[slot]->v4l2_buf.field = priv->field;
 		priv->queue_buf[slot]->v4l2_buf.sequence = priv->sequence++;
-		do_gettimeofday(&priv->queue_buf[slot]->v4l2_buf.timestamp);
+		v4l2_get_timestamp(&priv->queue_buf[slot]->v4l2_buf.timestamp);
 		vb2_buffer_done(priv->queue_buf[slot], VB2_BUF_STATE_DONE);
 		priv->queue_buf[slot] = NULL;
 
