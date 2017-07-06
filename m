Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34536 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdGFQHW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 12:07:22 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com, arnd@arndb.de
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: atomisp: ov2680: constify acpi_device_id.
Date: Thu,  6 Jul 2017 21:37:08 +0530
Message-Id: <07863716c1b563e4bff9c82721b50973843b9059.1499356911.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

acpi_device_id are not supposed to change at runtime. All functions
working with acpi_device_id provided by <acpi/acpi_bus.h> work with
const acpi_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  12466	   3120	      8	  15594	   3cea drivers/staging/media/atomisp/i2c/ov2680.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  12530	   3056	      8	  15594	   3cea drivers/staging/media/atomisp/i2c/ov2680.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ov2680.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index 5660910..9671876 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -1519,7 +1519,7 @@ static int ov2680_probe(struct i2c_client *client,
 	return ret;
 }
 
-static struct acpi_device_id ov2680_acpi_match[] = {
+static const struct acpi_device_id ov2680_acpi_match[] = {
 	{"XXOV2680"},
 	{},
 };
-- 
2.7.4
