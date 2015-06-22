Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34684 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbbFVWgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 18:36:20 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: bp@suse.de, mchehab@osg.samsung.com, dledford@redhat.com
Cc: mingo@kernel.org, fengguang.wu@intel.com,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH 1/2] x86/mm/pat, drivers/infiniband/ipath: replace WARN() with pr_warn()
Date: Mon, 22 Jun 2015 15:31:57 -0700
Message-Id: <1435012318-381-2-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1435012318-381-1-git-send-email-mcgrof@do-not-panic.com>
References: <1435012318-381-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

On built-in kernels this will always splat. Fix that.

Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/infiniband/hw/ipath/ipath_driver.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 2d7e503..871dbe5 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -31,6 +31,8 @@
  * SOFTWARE.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/idr.h>
@@ -399,8 +401,8 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	u32 bar0 = 0, bar1 = 0;
 
 #ifdef CONFIG_X86_64
-	if (WARN(pat_enabled(),
-		 "ipath needs PAT disabled, boot with nopat kernel parameter\n")) {
+	if (pat_enabled()) {
+		pr_warn("ipath needs PAT disabled, boot with nopat kernel parameter\n");
 		ret = -ENODEV;
 		goto bail;
 	}
-- 
2.3.2.209.gd67f9d5.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
