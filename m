Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22029 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdCMMfY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 08:35:24 -0400
Date: Mon, 13 Mar 2017 15:34:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: alan@linux.intel.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] staging/atomisp: Add support for the Intel IPU v2
Message-ID: <20170313123445.GA9464@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Alan Cox,

The patch a49d25364dfb: "staging/atomisp: Add support for the Intel
IPU v2" from Feb 17, 2017, leads to the following static checker
warning:

	drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:676 gmin_get_config_var()
	warn: impossible condition '(*out_len > (~0)) => (0-u64max > u64max)'

drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
   620  /* Retrieves a device-specific configuration variable.  The dev
   621   * argument should be a device with an ACPI companion, as all
   622   * configuration is based on firmware ID. */
   623  int gmin_get_config_var(struct device *dev, const char *var, char *out, size_t *out_len)

out_len is a size_t which is always a ulong.

   624  {
   625          char var8[CFG_VAR_NAME_MAX];
   626          efi_char16_t var16[CFG_VAR_NAME_MAX];
   627          struct efivar_entry *ev;
   628          u32 efiattr_dummy;
   629          int i, j, ret;
   630          unsigned long efilen;
   631  
   632          if (dev && ACPI_COMPANION(dev))
   633                  dev = &ACPI_COMPANION(dev)->dev;
   634  
   635          if (dev)
   636                  ret = snprintf(var8, sizeof(var8), "%s_%s", dev_name(dev), var);
   637          else
   638                  ret = snprintf(var8, sizeof(var8), "gmin_%s", var);
   639  
   640          if (ret < 0 || ret >= sizeof(var8)-1)
   641                  return -EINVAL;
   642  
   643          /* First check a hard-coded list of board-specific variables.
   644           * Some device firmwares lack the ability to set EFI variables at
   645           * runtime. */
   646          for (i = 0; i < ARRAY_SIZE(hard_vars); i++) {
   647                  if (dmi_match(DMI_BOARD_NAME, hard_vars[i].dmi_board_name)) {
   648                          for (j = 0; hard_vars[i].vars[j].name; j++) {
   649                                  size_t vl;
   650                                  const struct gmin_cfg_var *gv;
   651  
   652                                  gv = &hard_vars[i].vars[j];
   653                                  vl = strlen(gv->val);
   654  
   655                                  if (strcmp(var8, gv->name))
   656                                          continue;
   657                                  if (vl > *out_len-1)
   658                                          return -ENOSPC;
   659  
   660                                  memcpy(out, gv->val, min(*out_len, vl+1));
   661                                  out[*out_len-1] = 0;
   662                                  *out_len = vl;
   663  
   664                                  return 0;
   665                          }
   666                  }
   667          }
   668  
   669          /* Our variable names are ASCII by construction, but EFI names
   670           * are wide chars.  Convert and zero-pad. */
   671          memset(var16, 0, sizeof(var16));
   672          for (i=0; var8[i] && i < sizeof(var8); i++)
   673                  var16[i] = var8[i];
   674  
   675          /* To avoid owerflows when calling the efivar API */
   676          if (*out_len > ULONG_MAX)
                    ^^^^^^^^^^^^^^^^^^^^
This is impossible.  Was UINT_MAX intended?

   677                  return -EINVAL;
   678  

regards,
dan carpenter
