Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51722 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765602AbdAKQZf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 11:25:35 -0500
From: Colin King <colin.king@canonical.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] gspca_stv06xx: remove redundant check for err < 0
Date: Wed, 11 Jan 2017 16:24:33 +0000
Message-Id: <20170111162433.21208-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The comparison of err < 0 is redundant as err has been previously
been assigned to 0 and has not changed.  Remove the redundant check.

Fixes CoverityScan CID#703363 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
index f86cec0..7f1cc56 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
@@ -120,9 +120,6 @@ static int vv6410_init(struct sd *sd)
 	for (i = 0; i < ARRAY_SIZE(stv_bridge_init); i++)
 		stv06xx_write_bridge(sd, stv_bridge_init[i].addr, stv_bridge_init[i].data);
 
-	if (err < 0)
-		return err;
-
 	err = stv06xx_write_sensor_bytes(sd, (u8 *) vv6410_sensor_init,
 					 ARRAY_SIZE(vv6410_sensor_init));
 	return (err < 0) ? err : 0;
-- 
2.10.2

