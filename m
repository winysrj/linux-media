Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36184 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdGFQVJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 12:21:09 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: atomisp: gc0310: constify acpi_device_id.
Date: Thu,  6 Jul 2017 21:50:56 +0530
Message-Id: <7d7e1a0d6e7f90a9f8b4545fec2077ea3b351cb6.1499357881.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

acpi_device_id are not supposed to change at runtime. All functions
working with acpi_device_id provided by <acpi/acpi_bus.h> work with
const acpi_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  10297	   1888	      0	  12185	   2f99 drivers/staging/media/atomisp/i2c/gc0310.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  10361	   1824	      0	  12185	   2f99 drivers/staging/media/atomisp/i2c/gc0310.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc0310.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index 1ec616a..c8162bb 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -1453,7 +1453,7 @@ static int gc0310_probe(struct i2c_client *client,
 	return ret;
 }
 
-static struct acpi_device_id gc0310_acpi_match[] = {
+static const struct acpi_device_id gc0310_acpi_match[] = {
 	{"XXGC0310"},
 	{},
 };
-- 
2.7.4
