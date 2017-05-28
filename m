Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdE1McA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 08:32:00 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 4/7] staging: atomisp: Add INT0310 ACPI id to gc0310 driver
Date: Sun, 28 May 2017 14:31:50 +0200
Message-Id: <20170528123153.18613-4-hdegoede@redhat.com>
In-Reply-To: <20170528123153.18613-1-hdegoede@redhat.com>
References: <20170528123153.18613-1-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/staging/media/atomisp/i2c/gc0310.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index 1ec616a15086..350fd7fd5b86 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -1455,6 +1455,7 @@ static int gc0310_probe(struct i2c_client *client,
 
 static struct acpi_device_id gc0310_acpi_match[] = {
 	{"XXGC0310"},
+	{"INT0310"},
 	{},
 };
 
-- 
2.13.0
