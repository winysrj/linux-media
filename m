Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdE1McB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 08:32:01 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 5/7] staging: atomisp: Add OVTI2680 ACPI id to ov2680 driver
Date: Sun, 28 May 2017 14:31:51 +0200
Message-Id: <20170528123153.18613-5-hdegoede@redhat.com>
In-Reply-To: <20170528123153.18613-1-hdegoede@redhat.com>
References: <20170528123153.18613-1-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/staging/media/atomisp/i2c/ov2680.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index 566091035c64..449aa2aa276f 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -1521,6 +1521,7 @@ static int ov2680_probe(struct i2c_client *client,
 
 static struct acpi_device_id ov2680_acpi_match[] = {
 	{"XXOV2680"},
+	{"OVTI2680"},
 	{},
 };
 MODULE_DEVICE_TABLE(acpi, ov2680_acpi_match);
-- 
2.13.0
