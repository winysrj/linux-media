Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34588 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdGFQgu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 12:36:50 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: atomisp: ov5693: constify acpi_device_id.
Date: Thu,  6 Jul 2017 22:06:36 +0530
Message-Id: <bef48e3a4417dbccb82cc4974a4edbe397ac2a43.1499358838.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

acpi_device_id are not supposed to change at runtime. All functions
working with acpi_device_id provided by <acpi/acpi_bus.h> work with
const acpi_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  20729	   3264	      0	  23993	   5db9
drivers/staging/media/atomisp/i2c/ov5693/ov5693.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  20793	   3200	      0	  23993	   5db9
drivers/staging/media/atomisp/i2c/ov5693/ov5693.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index 5e9dafe..2c79678 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -2032,7 +2032,7 @@ static int ov5693_probe(struct i2c_client *client,
 
 MODULE_DEVICE_TABLE(i2c, ov5693_id);
 
-static struct acpi_device_id ov5693_acpi_match[] = {
+static const struct acpi_device_id ov5693_acpi_match[] = {
 	{"INT33BE"},
 	{},
 };
-- 
2.7.4
