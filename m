Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34628 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbbFXR3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 13:29:55 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: bp@suse.de, andy@silverblocksystems.net, mchehab@osg.samsung.com,
	dledford@redhat.com
Cc: mingo@kernel.org, fengguang.wu@intel.com,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 2/2] x86/mm/pat, drivers/media/ivtv: move pat warn and replace WARN() with pr_warn()
Date: Wed, 24 Jun 2015 10:23:20 -0700
Message-Id: <1435166600-11956-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
References: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

On built-in kernels this warning will always splat as this is part
of the module init. Fix that by shifting the PAT requirement check
out under the code that does the "quasi-probe" for the device. This
device driver relies on an existing driver to find its own devices,
it looks for that device driver and its own found devices, then
uses driver_for_each_device() to try to see if it can probe each of
those devices as a frambuffer device with ivtvfb_init_card(). We
tuck the PAT requiremenet check then on the ivtvfb_init_card()
call making the check at least require an ivtv device present
before complaining.

Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/media/pci/ivtv/ivtvfb.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 4cb365d..8b95eef 100644
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
@@ -1171,6 +1173,13 @@ static int ivtvfb_init_card(struct ivtv *itv)
 {
 	int rc;
 
+#ifdef CONFIG_X86_64
+	if (pat_enabled()) {
+		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
+		return -ENODEV;
+	}
+#endif
+
 	if (itv->osd_info) {
 		IVTVFB_ERR("Card %d already initialised\n", ivtvfb_card_id);
 		return -EBUSY;
@@ -1265,12 +1274,6 @@ static int __init ivtvfb_init(void)
 	int registered = 0;
 	int err;
 
-#ifdef CONFIG_X86_64
-	if (WARN(pat_enabled(),
-		 "ivtvfb needs PAT disabled, boot with nopat kernel parameter\n")) {
-		return -ENODEV;
-	}
-#endif
 
 	if (ivtvfb_card_id < -1 || ivtvfb_card_id >= IVTV_MAX_CARDS) {
 		printk(KERN_ERR "ivtvfb:  ivtvfb_card_id parameter is out of range (valid range: -1 - %d)\n",
-- 
2.3.2.209.gd67f9d5.dirty

