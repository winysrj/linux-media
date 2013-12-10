Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3263 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3LJPGH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/22] adv7842: set defaults spa-location.
Date: Tue, 10 Dec 2013 16:03:54 +0100
Message-Id: <6e7fe629da13cf8425ddde4f6ad46c05d7a0069d.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
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
index 59e7ef5..6335d9f 100644
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
1.8.4.rc3

