Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3301 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3CRQig (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 12:38:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Frank Schaefer <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/6] v4l2-common: remove obsolete check for ' at the end of a driver name.
Date: Mon, 18 Mar 2013 17:38:15 +0100
Message-Id: <1363624700-29270-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
References: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

During the transition to sub-devices several years ago non-subdev drivers
had a ' at the end of their driver name to tell them apart from already
converted drivers. This check was a left-over from that time and can be
removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-common.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index aa044f4..46d2b9b 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -251,9 +251,6 @@ int v4l2_chip_match_i2c_client(struct i2c_client *c, const struct v4l2_dbg_match
 		if (c->driver == NULL || c->driver->driver.name == NULL)
 			return 0;
 		len = strlen(c->driver->driver.name);
-		/* legacy drivers have a ' suffix, don't try to match that */
-		if (len && c->driver->driver.name[len - 1] == '\'')
-			len--;
 		return len && !strncmp(c->driver->driver.name, match->name, len);
 	case V4L2_CHIP_MATCH_I2C_ADDR:
 		return c->addr == match->addr;
-- 
1.7.10.4

