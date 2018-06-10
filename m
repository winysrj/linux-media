Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:38800 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753462AbeFJPmP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Jun 2018 11:42:15 -0400
Received: by mail-pf0-f195.google.com with SMTP id b74-v6so8944569pfl.5
        for <linux-media@vger.kernel.org>; Sun, 10 Jun 2018 08:42:15 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] media: s3c-camif: ignore -ENOIOCTLCMD from v4l2_subdev_call for s_power
Date: Mon, 11 Jun 2018 00:42:01 +0900
Message-Id: <1528645321-19020-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the subdevice doesn't provide s_power core ops callback, the
v4l2_subdev_call for s_power returns -ENOIOCTLCMD.  If the subdevice
doesn't have the special handling for its power saving mode, the s_power
isn't required.  So -ENOIOCTLCMD from the v4l2_subdev_call should be
ignored.

Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/platform/s3c-camif/camif-capture.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 9ab8e7e..b1d9f38 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -117,6 +117,8 @@ static int sensor_set_power(struct camif_dev *camif, int on)
 
 	if (camif->sensor.power_count == !on)
 		err = v4l2_subdev_call(sensor->sd, core, s_power, on);
+	if (err == -ENOIOCTLCMD)
+		err = 0;
 	if (!err)
 		sensor->power_count += on ? 1 : -1;
 
-- 
2.7.4
