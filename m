Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35355 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbbFVWic (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 18:38:32 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: bp@suse.de, mchehab@osg.samsung.com, dledford@redhat.com
Cc: mingo@kernel.org, fengguang.wu@intel.com,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH 2/2] x86/mm/pat, drivers/media/ivtv: replace WARN() with pr_warn()
Date: Mon, 22 Jun 2015 15:31:58 -0700
Message-Id: <1435012318-381-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1435012318-381-1-git-send-email-mcgrof@do-not-panic.com>
References: <1435012318-381-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

On built-in kernels this will always splat. Fix that.

Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/media/pci/ivtv/ivtvfb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 4cb365d..6f0c364 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -38,6 +38,8 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/fb.h>
@@ -1266,8 +1268,8 @@ static int __init ivtvfb_init(void)
 	int err;
 
 #ifdef CONFIG_X86_64
-	if (WARN(pat_enabled(),
-		 "ivtvfb needs PAT disabled, boot with nopat kernel parameter\n")) {
+	if (pat_enabled()) {
+		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
 		return -ENODEV;
 	}
 #endif
-- 
2.3.2.209.gd67f9d5.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
