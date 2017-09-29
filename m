Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51696 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752255AbdI2Vdp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 17:33:45 -0400
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH RFC] [media] v4l: async: don't bomb out on ->complete failure
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1dy2ue-0003JB-FG@rmk-PC.armlinux.org.uk>
Date: Fri, 29 Sep 2017 22:33:36 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a subdev is being registered via v4l2_async_register_subdev(), we
test to see if we have all the components, and if so, we call the
->complete() handler.

However, the error handling is broken - if notifier->complete() returns
an error, we propagate the error out of v4l2_async_register_subdev(),
but leaving the subdev bound and on the notifier's "done" list.

Drivers calling v4l2_async_register_subdev() assume that this means
that v4l2_async_register_subdev() failed, which causes probe failure
and the memory backing the subdev to be freed.

At this point, we now have a subdev on the notifier's done list which
has been freed.  If we then try to remove the notifier via
v4l2_async_notifier_unregister(), we walk the notifier's done list,
cleaning up the subdevs - and hit the freed subdev, causing a kernel
oops such as:

Unable to handle kernel paging request at virtual address 6e6f6994
pgd = d039c000
[6e6f6994] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in: mux_mmio caam_jr snd_soc_imx_sgtl5000 snd_soc_fsl_asoc_card
 snd_soc_imx_spdif imx_media_csi(C) ci_hdrc_imx snd_soc_imx_audmux
 imx6_mipi_csi2(C) imx219 snd_soc_sgtl5000 ci_hdrc usbmisc_imx udc_core
 caam video_mux mux_core imx_media_ic(C) imx_sdma imx_media_vdic(C)
 imx_media_capture(C) imx2_wdt snd_soc_fsl_ssi snd_soc_fsl_spdif
 imx_pcm_dma coda v4l2_mem2mem videobuf2_v4l2 imx_vdoa videobuf2_dma_contig
 videobuf2_core imx_thermal videobuf2_vmalloc videobuf2_memops imx_media(C-)
 imx_media_common(C) v4l2_fwnode nfsd rc_pinnacle_pctv_hd dw_hdmi_ahb_audio
 dw_hdmi_cec etnaviv
CPU: 1 PID: 8039 Comm: rmmod Tainted: G         C      4.14.0-rc1+ #2194
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
task: ee522700 task.stack: e5f68000
PC is at __lock_acquire+0x98/0x13f4
LR is at lock_acquire+0xd8/0x250
pc : [<c008cb00>]    lr : [<c008e828>]    psr: 200e0093
sp : e5f69d28  ip : e5f68000  fp : e5f69da4
r10: 00000000  r9 : 00000000  r8 : 6e6f6994
r7 : 00000000  r6 : c0aa4f64  r5 : ee522700  r4 : c13f4abc
r3 : 00000000  r2 : 00000001  r1 : 00000000  r0 : 6e6f6994
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 2039c04a  DAC: 00000051
Process rmmod (pid: 8039, stack limit = 0xe5f68210)
Backtrace:
[<c008ca68>] (__lock_acquire) from [<c008e828>] (lock_acquire+0xd8/0x250)
[<c008e750>] (lock_acquire) from [<c0749734>] (_raw_spin_lock+0x34/0x44)
[<c0749700>] (_raw_spin_lock) from [<c05155b4>] (v4l2_device_unregister_subdev+0x2c/0xb0)
[<c0515588>] (v4l2_device_unregister_subdev) from [<c051f4d0>] (v4l2_async_cleanup+0x14/0x40)
[<c051f4bc>] (v4l2_async_cleanup) from [<c051f6dc>] (v4l2_async_notifier_unregister+0xa8/0x1ec)
[<c051f634>] (v4l2_async_notifier_unregister) from [<bf05802c>] (imx_media_remove+0x2c/0x54 [imx_media])
[<bf058000>] (imx_media_remove [imx_media]) from [<c043d3a8>] (platform_drv_remove+0x2c/0x44)
[<c043d37c>] (platform_drv_remove) from [<c043b8d8>] (device_release_driver_internal+0x158/0x1f8)
[<c043b780>] (device_release_driver_internal) from [<c043b9d4>] (driver_detach+0x40/0x74)
[<c043b994>] (driver_detach) from [<c043aadc>] (bus_remove_driver+0x54/0x98)
[<c043aa88>] (bus_remove_driver) from [<c043c5c8>] (driver_unregister+0x30/0x50)
[<c043c598>] (driver_unregister) from [<c043d274>] (platform_driver_unregister+0x14/0x18)
[<c043d260>] (platform_driver_unregister) from [<bf059508>] (imx_media_pdrv_exit+0x14/0x1c [imx_media])
[<bf0594f4>] (imx_media_pdrv_exit [imx_media]) from [<c00d9218>] (SyS_delete_module+0x170/0x1c0)
[<c00d90a8>] (SyS_delete_module) from [<c00103c0>] (ret_fast_syscall+0x0/0x1c)
Code: 1a00000e e3a00000 e24bd028 e89daff0 (e5980000)
---[ end trace 97732329ac63e5ae ]---

Avoid this by reporting an error to the kernel message log about the
failure, rather than silently propagating the error from ->complete()
and causing this latent use-after-free oops.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/media/v4l2-core/v4l2-async.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index d741a8e0fdac..8d221f4a8a8d 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -122,8 +122,12 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 	/* Move from the global subdevice list to notifier's done */
 	list_move(&sd->async_list, &notifier->done);
 
-	if (list_empty(&notifier->waiting) && notifier->complete)
-		return notifier->complete(notifier);
+	if (list_empty(&notifier->waiting) && notifier->complete) {
+		int ret = notifier->complete(notifier);
+		if (ret)
+			dev_err(notifier->v4l2_dev->dev,
+				"complete notifier failed: %d\n", ret);
+	}
 
 	return 0;
 }
-- 
2.7.4
