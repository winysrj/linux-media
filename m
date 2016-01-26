Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbcAZJQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 04:16:02 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] Revert "[media] tvp5150: Fix breakage for serial usage"
Date: Tue, 26 Jan 2016 07:14:56 -0200
Message-Id: <841502d731f1708aae907d5bdf1659e8a372fc9a.1453799688.git.mchehab@osg.samsung.com>
In-Reply-To: <13d52fe40f1f7bbad49128e8ee6a2fe5e13dd18d.1453799688.git.mchehab@osg.samsung.com>
References: <13d52fe40f1f7bbad49128e8ee6a2fe5e13dd18d.1453799688.git.mchehab@osg.samsung.com>
In-Reply-To: <13d52fe40f1f7bbad49128e8ee6a2fe5e13dd18d.1453799688.git.mchehab@osg.samsung.com>
References: <13d52fe40f1f7bbad49128e8ee6a2fe5e13dd18d.1453799688.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch were a workaround for a regression at tvp5150, but
it causes troubles on devices with omap3+tvp5151 when working
in non-parallel bus mode.

Now that em28xx was fixed, we can get rid of that.

This reverts commit 47de9bf8931e6bf9c92fdba9867925d1ce482ab1.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/i2c/tvp5150.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 779c6f453cc9..437f1a7ecb96 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -975,18 +975,19 @@ static int tvp5150_g_mbus_config(struct v4l2_subdev *sd,
 static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
+	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
+	int val = 0x09;
 
 	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
-	if (decoder->mbus_type != V4L2_MBUS_PARALLEL)
-		return 0;
+	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
+		val = 0x0d;
 
 	/* Initializes TVP5150 to its default values */
 	/* # set PCLK (27MHz) */
 	tvp5150_write(sd, TVP5150_CONF_SHARED_PIN, 0x00);
 
-	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
 	if (enable)
-		tvp5150_write(sd, TVP5150_MISC_CTL, 0x09);
+		tvp5150_write(sd, TVP5150_MISC_CTL, val);
 	else
 		tvp5150_write(sd, TVP5150_MISC_CTL, 0x00);
 
-- 
2.5.0

