Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4699 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3LQNRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 08:17:10 -0500
Message-ID: <52B04E5B.6020907@xs4all.nl>
Date: Tue, 17 Dec 2013 14:15:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 17/15] adv7604: sync polarities from platform data
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl> <785a2a2445d00fa190ea7cea4671c43fb68e2da5.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <785a2a2445d00fa190ea7cea4671c43fb68e2da5.1386681716.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 5 +++--
 include/media/adv7604.h     | 4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index a1fa9a0..3f40616 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2126,9 +2126,10 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 					pdata->replicate_av_codes << 1 |
 					pdata->invert_cbcr << 0);
 
-	/* TODO from platform data */
 	cp_write(sd, 0x69, 0x30);   /* Enable CP CSC */
-	io_write(sd, 0x06, 0xa6);   /* positive VS and HS */
+
+	/* VS, HS polarities */
+	io_write(sd, 0x06, 0xa0 | pdata->inv_vs_pol << 2 | pdata->inv_hs_pol << 1);
 
 	/* Adjust drive strength */
 	io_write(sd, 0x14, 0x40 | pdata->dr_str << 4 |
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index 0162c31..053b13c 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -107,6 +107,10 @@ struct adv7604_platform_data {
 	unsigned replicate_av_codes:1;
 	unsigned invert_cbcr:1;
 
+	/* IO register 0x06 */
+	unsigned inv_vs_pol:1;
+	unsigned inv_hs_pol:1;
+
 	/* IO register 0x14 */
 	unsigned dr_str:2;
 	unsigned dr_str_clk:2;
-- 
1.8.4.rc3


