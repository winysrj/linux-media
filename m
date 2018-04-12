Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36473 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753051AbeDLPYP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:15 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Aishwarya Pant <aishpant@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 08/17] atomisp: remove an impossible condition
Date: Thu, 12 Apr 2018 11:24:00 -0400
Message-Id: <c1ab246d84dcedb3adab90b9800cae30c9b6ec08.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset dc9f65cf9aea ("media: staging: atomisp: avoid a warning if 32
bits build") was meant to solve an impossible condition when building
with 32 bits. It turns that this impossible condition also happens wit
64 bits:
	drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:698 gmin_get_config_var() warn: impossible condition '(*out_len > (~0)) => (0-u64max > u64max)'

After a further analysis, this condition will always be false as, on
all architectures, size_t doesn't have more bits than unsigned long.

Also, the only two archs that really matter are x86 and x86_64, as this
driver doesn't build on other archs (as it depends on X86-specific UEFI
support).

So, just drop the useless code.

Fixes: dc9f65cf9aea ("media: staging: atomisp: avoid a warning if 32 bits build")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/atomisp/platform/intel-mid/atomisp_gmin_platform.c        | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 3283c1b05d6a..70c34de98707 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -693,12 +693,6 @@ static int gmin_get_config_var(struct device *dev, const char *var,
 	for (i = 0; i < sizeof(var8) && var8[i]; i++)
 		var16[i] = var8[i];
 
-#ifdef CONFIG_64BIT
-	/* To avoid owerflows when calling the efivar API */
-	if (*out_len > ULONG_MAX)
-		return -EINVAL;
-#endif
-
 	/* Not sure this API usage is kosher; efivar_entry_get()'s
 	 * implementation simply uses VariableName and VendorGuid from
 	 * the struct and ignores the rest, but it seems like there
-- 
2.14.3
