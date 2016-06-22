Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:37583 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601AbcFVAWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 20:22:33 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, shuah@kernel.org
Subject: [PATCH] media: s5p-mfc fix null pointer deference in clk_core_enable()
Date: Tue, 21 Jun 2016 18:22:29 -0600
Message-Id: <1466554949-12018-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix null pointer deference in clk_core_enable() when driver unbind is run
when there is an application has an active pipeline playing. At this point,
system hangs and needs to be power cycled.

s5p_mfc_release() gets called after s5p_mfc_final_pm() disables and does
clk_put() and s5p_mfc_release() attempts to enable clock and runs into
null pointer deference accessing invalid pointer. With this fix, null
pointer dereference is fixed and there is no hang.

Run unbind while the following pipeline is playing:
gst-launch-1.0 filesrc location=/home/odroid/GH3_MOV_HD.mp4 ! qtdemux !
    h264parse ! v4l2video4dec ! videoconvert ! autovideosink

[ 4869.434709] Unable to handle kernel NULL pointer dereference at virtual addr0
[ 4869.441312] pgd = e91ac000
[ 4869.443996] [00000010] *pgd=ba4f7835
[ 4869.447552] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[ 4869.452921] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_ca
[ 4869.471728] CPU: 4 PID: 2965 Comm: lt-gst-launch-1 Not tainted 4.7.0-rc2-nex0
[ 4869.481778] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 4869.487844] task: e91f1e00 ti: ed650000 task.ti: ed650000
[ 4869.493227] PC is at clk_core_enable+0x4c/0x98
[ 4869.497637] LR is at clk_core_enable+0x40/0x98
[ 4869.502056] pc : [<c0559714>]    lr : [<c0559708>]    psr: 60060093
[ 4869.502056] sp : ed651f18  ip : 00000000  fp : 002641b4
[ 4869.513493] r10: e9088c08  r9 : 00000008  r8 : ed676d68
[ 4869.518692] r7 : ee3ac000  r6 : bf16b3c0  r5 : a0060013  r4 : ee37a8c0
[ 4869.525191] r3 : 00000000  r2 : 00000001  r1 : 00000004  r0 : 00000000
[ 4869.531692] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment noe
[ 4869.538883] Control: 10c5387d  Table: 691ac06a  DAC: 00000051
[ 4869.544603] Process lt-gst-launch-1 (pid: 2965, stack limit = 0xed650210)
[ 4869.551361] Stack: (0xed651f18 to 0xed652000)
[ 4869.555694] 1f00:                                                       ee373
[ 4869.563841] 1f20: bf16b3c0 c055a0e0 ee3ac004 ed676c10 bf16b3c0 bf1558e0 e9080
[ 4869.571986] 1f40: 00000000 ee98a510 ee502e40 bf047344 e9088c00 ee986938 00004
[ 4869.580132] 1f60: 00000000 00000000 e91f2204 00000000 c0b4658c e91f1e00 c0100
[ 4869.588277] 1f80: 00000000 c0135c58 ed650000 c0107904 ed651fb0 00000006 c0104
[ 4869.596423] 1fa0: 00229500 b6581000 b6f7b544 c0107794 00000000 00000002 b6f90
[ 4869.604568] 1fc0: 00229500 b6581000 b6f7b544 00000006 0017b600 0002c038 00264
[ 4869.612714] 1fe0: 00000000 bee56ef0 00000000 b6d49612 00060030 00000006 00000
[ 4869.620865] [<c0559714>] (clk_core_enable) from [<c055a0e0>] (clk_enable+0x2)
[ 4869.628509] [<c055a0e0>] (clk_enable) from [<bf1558e0>] (s5p_mfc_release+0x3)
[ 4869.637111] [<bf1558e0>] (s5p_mfc_release [s5p_mfc]) from [<bf047344>] (v4l2)
[ 4869.646706] [<bf047344>] (v4l2_release [videodev]) from [<c01e4274>] (__fput)
[ 4869.654745] [<c01e4274>] (__fput) from [<c0135c58>] (task_work_run+0x94/0xc8)
[ 4869.661852] [<c0135c58>] (task_work_run) from [<c010a9d4>] (do_work_pending+)
[ 4869.669735] [<c010a9d4>] (do_work_pending) from [<c0107794>] (slow_work_pend)
[ 4869.677878] Code: ebffffef e3500000 18bd8070 e5943004 (e5933010)

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index d011f30..d88f1ba 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -76,8 +76,10 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 
 err_s_clk:
 	clk_put(pm->clock);
+	pm->clock = NULL;
 err_p_ip_clk:
 	clk_put(pm->clock_gate);
+	pm->clock_gate = NULL;
 err_g_ip_clk:
 	return ret;
 }
@@ -88,9 +90,11 @@ void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
 	    !IS_ERR_OR_NULL(pm->clock)) {
 		clk_disable_unprepare(pm->clock);
 		clk_put(pm->clock);
+		pm->clock = NULL;
 	}
 	clk_unprepare(pm->clock_gate);
 	clk_put(pm->clock_gate);
+	pm->clock_gate = NULL;
 #ifdef CONFIG_PM
 	pm_runtime_disable(pm->device);
 #endif
@@ -98,12 +102,13 @@ void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
 
 int s5p_mfc_clock_on(void)
 {
-	int ret;
+	int ret = 0;
 #ifdef CLK_DEBUG
 	atomic_inc(&clk_ref);
 	mfc_debug(3, "+ %d\n", atomic_read(&clk_ref));
 #endif
-	ret = clk_enable(pm->clock_gate);
+	if (!IS_ERR_OR_NULL(pm->clock_gate))
+		ret = clk_enable(pm->clock_gate);
 	return ret;
 }
 
@@ -113,7 +118,8 @@ void s5p_mfc_clock_off(void)
 	atomic_dec(&clk_ref);
 	mfc_debug(3, "- %d\n", atomic_read(&clk_ref));
 #endif
-	clk_disable(pm->clock_gate);
+	if (!IS_ERR_OR_NULL(pm->clock_gate))
+		clk_disable(pm->clock_gate);
 }
 
 int s5p_mfc_power_on(void)
-- 
2.7.4

