Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750791AbdE1Mbz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 08:31:55 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/7] staging: atomisp: Fix calling efivar_entry_get() with unaligned arguments
Date: Sun, 28 May 2017 14:31:47 +0200
Message-Id: <20170528123153.18613-1-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

efivar_entry_get has certain alignment requirements and the atomisp
platform code was not honoring these, causing an oops by triggering the
WARN_ON in arch/x86/platform/efi/efi_64.c: virt_to_phys_or_null_size().

This commit fixes this by using the members of the efivar struct embedded
in the efivar_entry struct we kzalloc as arguments to efivar_entry_get(),
which is how all the other callers of efivar_entry_get() do this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../atomisp/platform/intel-mid/atomisp_gmin_platform.c  | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 5b4506a71126..104fea2f8697 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -623,9 +623,7 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *
 	char var8[CFG_VAR_NAME_MAX];
 	efi_char16_t var16[CFG_VAR_NAME_MAX];
 	struct efivar_entry *ev;
-	u32 efiattr_dummy;
 	int i, j, ret;
-	unsigned long efilen;
 
         if (dev && ACPI_COMPANION(dev))
                 dev = &ACPI_COMPANION(dev)->dev;
@@ -684,15 +682,18 @@ int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *
 		return -ENOMEM;
 	memcpy(&ev->var.VariableName, var16, sizeof(var16));
 	ev->var.VendorGuid = GMIN_CFG_VAR_EFI_GUID;
+	ev->var.DataSize = *out_len;
 
-	efilen = *out_len;
-	ret = efivar_entry_get(ev, &efiattr_dummy, &efilen, out);
+	ret = efivar_entry_get(ev, &ev->var.Attributes,
+			       &ev->var.DataSize, ev->var.Data);
+	if (ret == 0) {
+		memcpy(out, ev->var.Data, ev->var.DataSize);
+		*out_len = ev->var.DataSize;
+	} else {
+		dev_warn(dev, "Failed to find gmin variable %s\n", var8);
+	}
 
 	kfree(ev);
-	*out_len = efilen;
-
-	if (ret)
- 		dev_warn(dev, "Failed to find gmin variable %s\n", var8);
 
 	return ret;
 }
-- 
2.13.0
