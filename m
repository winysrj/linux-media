Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:51039 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab2HXJKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 05:10:38 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: [PATCH 3/3] mt9v022: set y_skip_top field to zero
Date: Fri, 24 Aug 2012 11:10:31 +0200
Message-Id: <1345799431-29426-4-git-send-email-agust@denx.de>
In-Reply-To: <1345799431-29426-1-git-send-email-agust@denx.de>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set "y_skip_top" to zero and remove comment as I do not see this
line corruption on two different mt9v022 setups. The first read-out
line is perfectly fine.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/i2c/soc_camera/mt9v022.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index d26c071..e41d738 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -960,11 +960,7 @@ static int mt9v022_probe(struct i2c_client *client,
 
 	mt9v022->chip_control = MT9V022_CHIP_CONTROL_DEFAULT;
 
-	/*
-	 * MT9V022 _really_ corrupts the first read out line.
-	 * TODO: verify on i.MX31
-	 */
-	mt9v022->y_skip_top	= 1;
+	mt9v022->y_skip_top	= 0;
 	mt9v022->rect.left	= MT9V022_COLUMN_SKIP;
 	mt9v022->rect.top	= MT9V022_ROW_SKIP;
 	mt9v022->rect.width	= MT9V022_MAX_WIDTH;
-- 
1.7.1

