Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3450 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab3LTJcR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 32/50] adv7842: set defaults spa-location.
Date: Fri, 20 Dec 2013 10:31:25 +0100
Message-Id: <1387531903-20496-33-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

For edid with no Source Physical Address (spa), set
spa-location to default and use correct values from edid.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Cc: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 23f3c1f..8d0edd4 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -716,15 +716,15 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 		}
 		rep_write(sd, 0x76, spa_loc);
 	} else {
-		/* default register values for SPA */
+		/* Edid values for SPA location */
 		if (port == 0) {
-			/* port A SPA */
-			rep_write(sd, 0x72, 0);
-			rep_write(sd, 0x73, 0);
+			/* port A */
+			rep_write(sd, 0x72, val[0xc0]);
+			rep_write(sd, 0x73, val[0xc1]);
 		} else {
-			/* port B SPA */
-			rep_write(sd, 0x74, 0);
-			rep_write(sd, 0x75, 0);
+			/* port B */
+			rep_write(sd, 0x74, val[0xc0]);
+			rep_write(sd, 0x75, val[0xc1]);
 		}
 		rep_write(sd, 0x76, 0xc0);
 	}
-- 
1.8.4.4

