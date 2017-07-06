Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33355 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbdGFQOs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 12:14:48 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: atomisp: ov8858: constify acpi_device_id.
Date: Thu,  6 Jul 2017 21:44:36 +0530
Message-Id: <df00971f50ee87bd0ce0fb9ee23c00e3846e5265.1499357476.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

acpi_device_id are not supposed to change at runtime. All functions
working with acpi_device_id provided by <acpi/acpi_bus.h> work with
const acpi_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  23804	   8448	      0	  32252	   7dfc drivers/staging/media/atomisp/i2c/ov8858.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  23868	   8384	      0	  32252	   7dfc drivers/staging/media/atomisp/i2c/ov8858.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ov8858.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov8858.c b/drivers/staging/media/atomisp/i2c/ov8858.c
index 9574bc4..43e1638 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.c
+++ b/drivers/staging/media/atomisp/i2c/ov8858.c
@@ -2189,7 +2189,7 @@ static const struct i2c_device_id ov8858_id[] = {
 
 MODULE_DEVICE_TABLE(i2c, ov8858_id);
 
-static struct acpi_device_id ov8858_acpi_match[] = {
+static const struct acpi_device_id ov8858_acpi_match[] = {
 	{"INT3477"},
 	{},
 };
-- 
2.7.4
