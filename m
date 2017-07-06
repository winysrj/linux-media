Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36166 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdGFQk5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 12:40:57 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: atomisp: mt9m114: constify acpi_device_id.
Date: Thu,  6 Jul 2017 22:10:45 +0530
Message-Id: <ef2b43a2ef03fc4a01bf08dcb5a3f3c40824f524.1499359214.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

acpi_device_id are not supposed to change at runtime. All functions
working with acpi_device_id provided by <acpi/acpi_bus.h> work with
const acpi_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  15148	   2640	      8	  17796	   4584
drivers/staging/media/atomisp/i2c/mt9m114.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  15244	   2512	      8	  17764	   4564
drivers/staging/media/atomisp/i2c/mt9m114.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/atomisp/i2c/mt9m114.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index ced175c..68980ab 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -1928,7 +1928,7 @@ static int mt9m114_probe(struct i2c_client *client,
 
 MODULE_DEVICE_TABLE(i2c, mt9m114_id);
 
-static struct acpi_device_id mt9m114_acpi_match[] = {
+static const struct acpi_device_id mt9m114_acpi_match[] = {
 	{ "INT33F0" },
 	{ "CRMT1040" },
 	{},
-- 
2.7.4
