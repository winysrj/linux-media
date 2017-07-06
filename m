Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35187 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdGFQa7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 12:30:59 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: atomisp: ov2722: constify acpi_device_id.
Date: Thu,  6 Jul 2017 22:00:47 +0530
Message-Id: <ade471de35e2d7509e5a344b63133126a566dee0.1499358240.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

acpi_device_id are not supposed to change at runtime. All functions
working with acpi_device_id provided by <acpi/acpi_bus.h> work with
const acpi_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  14771	   1880	      0	  16651	   410b drivers/staging/media/atomisp/i2c/ov2722.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  14835	   1816	      0	  16651	   410b drivers/staging/media/atomisp/i2c/ov2722.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ov2722.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov2722.c b/drivers/staging/media/atomisp/i2c/ov2722.c
index b7afade..10094ac 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/ov2722.c
@@ -1337,7 +1337,7 @@ static int ov2722_probe(struct i2c_client *client,
 
 MODULE_DEVICE_TABLE(i2c, ov2722_id);
 
-static struct acpi_device_id ov2722_acpi_match[] = {
+static const struct acpi_device_id ov2722_acpi_match[] = {
 	{ "INT33FB" },
 	{},
 };
-- 
2.7.4
