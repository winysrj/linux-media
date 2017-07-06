Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33029 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdGFP4w (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 11:56:52 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: atomisp: lm3554: constify acpi_device_id.
Date: Thu,  6 Jul 2017 21:26:29 +0530
Message-Id: <15b6753e80f3acae3a70f9042339a7e01a7070ce.1499356018.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

acpi_device_id are not supposed to change at runtime. All functions
working with acpi_device_id provided by <acpi/acpi_bus.h> work with
const acpi_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   5347	   1920	     24	   7291	   1c7b drivers/staging/media/atomisp/i2c/lm3554.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   5411	   1856	     24	   7291	   1c7b drivers/staging/media/atomisp/i2c/lm3554.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/atomisp/i2c/lm3554.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/lm3554.c b/drivers/staging/media/atomisp/i2c/lm3554.c
index dd9c9c3..9ba1037 100644
--- a/drivers/staging/media/atomisp/i2c/lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/lm3554.c
@@ -974,7 +974,7 @@ static const struct dev_pm_ops lm3554_pm_ops = {
 	.resume = lm3554_resume,
 };
 
-static struct acpi_device_id lm3554_acpi_match[] = {
+static const struct acpi_device_id lm3554_acpi_match[] = {
 	{ "INTCF1C" },
 	{},
 };
-- 
2.7.4
