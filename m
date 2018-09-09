Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:42313 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbeIIU4g (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Sep 2018 16:56:36 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "Igor M. Liplianin" <liplianin@me.by>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] media: pci: cx23885: handle adding to list failure
Date: Sun,  9 Sep 2018 18:02:32 +0200
Message-Id: <1536508952-10788-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 altera_hw_filt_init() which calls append_internal() assumes
that the node was successfully linked in while in fact it can
silently fail. So the call-site needs to set return to -ENOMEM
on append_internal() returning NULL and exit through the err path.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Fixes: 349bcf02e361 ("[media] Altera FPGA based CI driver module")
---

Problem located with experimental coccinelle script

Patch was compile tested with: x86_64_defconfig + CONFIG_MEDIA_SUPPORT=y,
CONFIG_OF=y, CONFIG_MEDIA_ANALOG_TV_SUPPORT=y,
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y, CONFIG_MEDIA_PCI_SUPPORT=y,
CONFIG_DRM_SIL_SII8620=y, CONFIG_VIDEO_CX23885=y, CONFIG_MEDIA_ALTERA_CI=y

Patch is against 4.19-rc2 (localversion-next is next-20180907)

 drivers/media/pci/cx23885/altera-ci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/pci/cx23885/altera-ci.c b/drivers/media/pci/cx23885/altera-ci.c
index 62bc804..198c05e 100644
--- a/drivers/media/pci/cx23885/altera-ci.c
+++ b/drivers/media/pci/cx23885/altera-ci.c
@@ -665,6 +665,10 @@ static int altera_hw_filt_init(struct altera_ci_config *config, int hw_filt_nr)
 		}
 
 		temp_int = append_internal(inter);
+		if (!temp_int) {
+			ret = -ENOMEM;
+			goto err;
+		}
 		inter->filts_used = 1;
 		inter->dev = config->dev;
 		inter->fpga_rw = config->fpga_rw;
@@ -699,6 +703,7 @@ static int altera_hw_filt_init(struct altera_ci_config *config, int hw_filt_nr)
 		     __func__, ret);
 
 	kfree(pid_filt);
+	kfree(inter);
 
 	return ret;
 }
@@ -733,6 +738,10 @@ int altera_ci_init(struct altera_ci_config *config, int ci_nr)
 		}
 
 		temp_int = append_internal(inter);
+		if (!temp_int) {
+			ret = -ENOMEM;
+			goto err;
+		}
 		inter->cis_used = 1;
 		inter->dev = config->dev;
 		inter->fpga_rw = config->fpga_rw;
@@ -801,6 +810,7 @@ int altera_ci_init(struct altera_ci_config *config, int ci_nr)
 	ci_dbg_print("%s: Cannot initialize CI: Error %d.\n", __func__, ret);
 
 	kfree(state);
+	kfree(inter);
 
 	return ret;
 }
-- 
2.1.4
