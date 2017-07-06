Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35058 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdGFQoC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 12:44:02 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: atomisp: gc2235: constify acpi_device_id.
Date: Thu,  6 Jul 2017 22:13:52 +0530
Message-Id: <def7a0a12e4f6097dea03e3e4e0e0998f9aa27c6.1499359412.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

acpi_device_id are not supposed to change at runtime. All functions
working with acpi_device_id provided by <acpi/acpi_bus.h> work with
const acpi_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  10754	   1360	      4	  12118	   2f56
drivers/staging/media/atomisp/i2c/gc2235.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  10818	   1296	      4	  12118	   2f56
drivers/staging/media/atomisp/i2c/gc2235.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 50f4317..48ca23b 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -1183,7 +1183,7 @@ static int gc2235_probe(struct i2c_client *client,
 	return ret;
 }
 
-static struct acpi_device_id gc2235_acpi_match[] = {
+static const struct acpi_device_id gc2235_acpi_match[] = {
 	{ "INT33F8" },
 	{},
 };
-- 
2.7.4
