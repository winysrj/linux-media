Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48607 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754212AbcJNRrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 08/25] [media] tuner-core: don't break long lines
Date: Fri, 14 Oct 2016 14:45:46 -0300
Message-Id: <785432476f1043f783ca7142d726b1cff9860950.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/tuner-core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 731487be5baa..e2613ecb7605 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -503,8 +503,7 @@ static int tuner_s_type_addr(struct v4l2_subdev *sd,
 		set_type(c, tun_setup->type, tun_setup->mode_mask,
 			 tun_setup->config, tun_setup->tuner_callback);
 	} else
-		tuner_dbg("set addr discarded for type %i, mask %x. "
-			  "Asked to change tuner at addr 0x%02x, with mask %x\n",
+		tuner_dbg("set addr discarded for type %i, mask %x. Asked to change tuner at addr 0x%02x, with mask %x\n",
 			  t->type, t->mode_mask,
 			  tun_setup->addr, tun_setup->mode_mask);
 
@@ -809,8 +808,8 @@ static int set_mode(struct tuner *t, enum v4l2_tuner_type mode)
 
 	if (mode != t->mode) {
 		if (check_mode(t, mode) == -EINVAL) {
-			tuner_dbg("Tuner doesn't support mode %d. "
-				  "Putting tuner to sleep\n", mode);
+			tuner_dbg("Tuner doesn't support mode %d. Putting tuner to sleep\n",
+				  mode);
 			t->standby = true;
 			if (analog_ops->standby)
 				analog_ops->standby(&t->fe);
-- 
2.7.4


