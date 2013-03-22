Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933852Ab3CVQQK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 12:16:10 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2MGG9gj023559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 22 Mar 2013 12:16:10 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/3] [media] m5602_ov7660: return error at ov7660_init()
Date: Fri, 22 Mar 2013 13:16:03 -0300
Message-Id: <1363968963-7841-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363968963-7841-1-git-send-email-mchehab@redhat.com>
References: <1363968963-7841-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It used to be a code that returns arror at ov7660_init.
However, this was removed by changeset c84e412f:

@@ -231,33 +116,40 @@ int ov7660_init(struct sd *sd)
        if (dump_sensor)
                ov7660_dump_registers(sd);

-   err = ov7660_set_gain(&sd->gspca_dev, sensor_settings[GAIN_IDX]);
-   if (err < 0)
-           return err;
+ return 0;
+}

-   err = ov7660_set_auto_white_balance(&sd->gspca_dev,
-           sensor_settings[AUTO_WHITE_BALANCE_IDX]);
-   if (err < 0)
-           return err;

As complained by gcc:
	drivers/media/usb/gspca/m5602/m5602_ov7660.c: In function 'ov7660_init':
	drivers/media/usb/gspca/m5602/m5602_ov7660.c:99:9: warning: variable 'err' set but not used [-Wunused-but-set-variable]

It should be noticed that the original error code was crappy, as it wasn't
returning any error if sensor init fails.

Fix it by returning an error if the sensor can't be initialized.

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/gspca/m5602/m5602_ov7660.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_ov7660.c b/drivers/media/usb/gspca/m5602/m5602_ov7660.c
index 4ac7889..64b3b03 100644
--- a/drivers/media/usb/gspca/m5602/m5602_ov7660.c
+++ b/drivers/media/usb/gspca/m5602/m5602_ov7660.c
@@ -96,7 +96,7 @@ sensor_found:
 
 int ov7660_init(struct sd *sd)
 {
-	int i, err = 0;
+	int i, err;
 
 	/* Init the sensor */
 	for (i = 0; i < ARRAY_SIZE(init_ov7660); i++) {
@@ -111,6 +111,8 @@ int ov7660_init(struct sd *sd)
 			err = m5602_write_sensor(sd,
 				init_ov7660[i][1], data, 1);
 		}
+		if (err < 0)
+			return err;
 	}
 
 	if (dump_sensor)
-- 
1.8.1.4

