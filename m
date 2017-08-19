Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34373 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdHSIXd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 04:23:33 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, bp@alien8.de, mchehab@kernel.org,
        daniel.vetter@intel.com, jani.nikula@linux.intel.com,
        seanpaul@chromium.org, airlied@linux.ie, g.liakhovetski@gmx.de,
        tomas.winkler@intel.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, boris.brezillon@free-electrons.com,
        marek.vasut@gmail.com, richard@nod.at, cyrille.pitchen@wedev4u.fr,
        peda@axentia.se, kishon@ti.com, bhelgaas@google.com,
        thierry.reding@gmail.com, jonathanh@nvidia.com,
        dvhart@infradead.org, andy@infradead.org, ohad@wizery.com,
        bjorn.andersson@linaro.org, freude@de.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jth@kernel.org,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        lduncan@suse.com, cleech@redhat.com, johan@kernel.org,
        elder@kernel.org, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, greybus-dev@lists.linaro.org,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 02/15] drm: make device_type const
Date: Sat, 19 Aug 2017 13:52:13 +0530
Message-Id: <1503130946-2854-3-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only stored in the type field of a device
structure, which is const.
Done using Coccinelle.
---
 drivers/gpu/drm/drm_sysfs.c      | 2 +-
 drivers/gpu/drm/ttm/ttm_module.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 1c5b5ce..84e4ebe 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -39,7 +39,7 @@
  * drm_connector_unregister().
  */
 
-static struct device_type drm_sysfs_device_minor = {
+static const struct device_type drm_sysfs_device_minor = {
 	.name = "drm_minor"
 };
 
diff --git a/drivers/gpu/drm/ttm/ttm_module.c b/drivers/gpu/drm/ttm/ttm_module.c
index 66fc639..e6604e0 100644
--- a/drivers/gpu/drm/ttm/ttm_module.c
+++ b/drivers/gpu/drm/ttm/ttm_module.c
@@ -37,7 +37,7 @@
 static DECLARE_WAIT_QUEUE_HEAD(exit_q);
 static atomic_t device_released;
 
-static struct device_type ttm_drm_class_type = {
+static const struct device_type ttm_drm_class_type = {
 	.name = "ttm",
 	/**
 	 * Add pm ops here.
-- 
1.9.1
