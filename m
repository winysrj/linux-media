Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38049 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdHSIYN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 04:24:13 -0400
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
Subject: [PATCH 04/15] [media] rc: make device_type const
Date: Sat, 19 Aug 2017 13:52:15 +0530
Message-Id: <1503130946-2854-5-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only stored in the type field of a device
structure, which is const.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/rc/rc-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index a9eba00..ea3da3e 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1532,7 +1532,7 @@ static RC_FILTER_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
 	.attrs	= rc_dev_wakeup_filter_attrs,
 };
 
-static struct device_type rc_dev_type = {
+static const struct device_type rc_dev_type = {
 	.release	= rc_dev_release,
 	.uevent		= rc_dev_uevent,
 };
-- 
1.9.1
