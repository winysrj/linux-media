Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42989 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab3KFO1z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 09:27:55 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...),
	linux-kernel@vger.kernel.org (open list)
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] ths7303: Declare as static a private function
Date: Wed,  6 Nov 2013 15:27:48 +0100
Message-Id: <1383748068-22182-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

git grep shows that the function is only called from ths7303.c

Fix this build warning:

CC      drivers/media/i2c/ths7303.o
drivers/media/i2c/ths7303.c:86:5: warning: no previous prototype for  ‘ths7303_setval’ [-Wmissing-prototypes]
   int ths7303_setval(struct v4l2_subdev *sd, enum ths7303_filter_mode mode)
        ^

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/i2c/ths7303.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 42276d9..16da153 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -83,7 +83,8 @@ static int ths7303_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 }
 
 /* following function is used to set ths7303 */
-int ths7303_setval(struct v4l2_subdev *sd, enum ths7303_filter_mode mode)
+static int ths7303_setval(struct v4l2_subdev *sd,
+					enum ths7303_filter_mode mode)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ths7303_state *state = to_state(sd);
-- 
1.8.4.rc3

