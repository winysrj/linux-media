Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59492 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752084AbeCZVLC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:11:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Aishwarya Pant <aishpant@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 12/18] media: staging: atomisp: avoid a warning if 32 bits build
Date: Mon, 26 Mar 2018 17:10:45 -0400
Message-Id: <313cb7db7e3fc7c7c14d2e82e249ccebcbd51ff8.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checking if a size_t value is bigger than ULONG_INT only makes
sense if building on 64 bits, as warned by:
	drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:697 gmin_get_config_var() warn: impossible condition '(*out_len > (~0)) => (0-u32max > u32max)'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c    | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index be0c5e11e86b..3283c1b05d6a 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -693,9 +693,11 @@ static int gmin_get_config_var(struct device *dev, const char *var,
 	for (i = 0; i < sizeof(var8) && var8[i]; i++)
 		var16[i] = var8[i];
 
+#ifdef CONFIG_64BIT
 	/* To avoid owerflows when calling the efivar API */
 	if (*out_len > ULONG_MAX)
 		return -EINVAL;
+#endif
 
 	/* Not sure this API usage is kosher; efivar_entry_get()'s
 	 * implementation simply uses VariableName and VendorGuid from
-- 
2.14.3
