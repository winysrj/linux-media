Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43990 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbbCKILE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 04:11:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 20/21] marvell-ccic: drop bayer format
Date: Wed, 11 Mar 2015 09:10:27 +0100
Message-Id: <1426061428-47019-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426061428-47019-1-git-send-email-hverkuil@xs4all.nl>
References: <1426061428-47019-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This format has clearly never been tested. This driver never programmed
the chip for this format and instead just reports that it is an unknown
format. Drop it from the list of formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 17f5931..c522c75 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -165,13 +165,6 @@ static struct mcam_format_struct {
 		.bpp		= 2,
 		.planar		= false,
 	},
-	{
-		.desc		= "Raw RGB Bayer",
-		.pixelformat	= V4L2_PIX_FMT_SBGGR8,
-		.mbus_code	= MEDIA_BUS_FMT_SBGGR8_1X8,
-		.bpp		= 1,
-		.planar		= false,
-	},
 };
 #define N_MCAM_FMTS ARRAY_SIZE(mcam_formats)
 
-- 
2.1.4

