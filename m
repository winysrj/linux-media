Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750897AbdE1Mb5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 08:31:57 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/7] staging: atomisp: Do not call dev_warn with a NULL device
Date: Sun, 28 May 2017 14:31:48 +0200
Message-Id: <20170528123153.18613-2-hdegoede@redhat.com>
In-Reply-To: <20170528123153.18613-1-hdegoede@redhat.com>
References: <20170528123153.18613-1-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not call dev_warn with a NULL device, this silence the following 2
warnings:

[   14.392194] (NULL device *): Failed to find gmin variable gmin_V2P8GPIO
[   14.392257] (NULL device *): Failed to find gmin variable gmin_V1P8GPIO

We could switch to using pr_warn for dev == NULL instead, but as comments
in the source indicate, the check for these 2 special gmin variables with
a NULL device is a workaround for 2 specific evaluation boards, so
completely silencing the missing warning for these actually is a good
thing.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 104fea2f8697..3fea81ea5dbd 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -689,7 +689,7 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *
 	if (ret == 0) {
 		memcpy(out, ev->var.Data, ev->var.DataSize);
 		*out_len = ev->var.DataSize;
-	} else {
+	} else if (dev) {
 		dev_warn(dev, "Failed to find gmin variable %s\n", var8);
 	}
 
-- 
2.13.0
