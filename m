Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:35356 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbdGQI6s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 04:58:48 -0400
Received: by mail-wr0-f175.google.com with SMTP id w4so18946989wrb.2
        for <linux-media@vger.kernel.org>; Mon, 17 Jul 2017 01:58:48 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Rob Clark <robdclark@gmail.com>
Subject: [PATCH 4/4] media: venus: hfi: fix error handling in hfi_sys_init_done()
Date: Mon, 17 Jul 2017 11:56:50 +0300
Message-Id: <20170717085650.12185-5-stanimir.varbanov@linaro.org>
In-Reply-To: <20170717085650.12185-1-stanimir.varbanov@linaro.org>
References: <20170717085650.12185-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Clark <robdclark@gmail.com>

Not entirely sure what triggers it, but with venus build as kernel
module and in initrd, we hit this crash:

  Unable to handle kernel paging request at virtual address ffff80003c039000
  pgd = ffff00000a14f000
  [ffff80003c039000] *pgd=00000000bd9f7003, *pud=00000000bd9f6003, *pmd=00000000bd9f0003, *pte=0000000000000000
  Internal error: Oops: 96000007 [#1] SMP
  Modules linked in: qcom_wcnss_pil(E+) crc32_ce(E) qcom_common(E) venus_core(E+) remoteproc(E) snd_soc_msm8916_digital(E) virtio_ring(E) cdc_ether(E) snd_soc_lpass_apq8016(E) snd_soc_lpass_cpu(E) snd_soc_apq8016_sbc(E) snd_soc_lpass_platform(E) v4l2_mem2mem(E) virtio(E) snd_soc_core(E) ac97_bus(E) snd_pcm_dmaengine(E) snd_seq(E) leds_gpio(E) videobuf2_v4l2(E) videobuf2_core(E) snd_seq_device(E) snd_pcm(E) videodev(E) media(E) nvmem_qfprom(E) msm(E) snd_timer(E) snd(E) soundcore(E) spi_qup(E) mdt_loader(E) qcom_tsens(E) qcom_spmi_temp_alarm(E) nvmem_core(E) msm_rng(E) uas(E) usb_storage(E) dm9601(E) usbnet(E) mii(E) mmc_block(E) adv7511(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) fb_sys_fops(E) qcom_spmi_vadc(E) qcom_vadc_common(PE) industrialio(E) pinctrl_spmi_mpp(E)
   pinctrl_spmi_gpio(E) rtc_pm8xxx(E) clk_smd_rpm(E) sdhci_msm(E) sdhci_pltfm(E) qcom_smd_regulator(E) drm(E) smd_rpm(E) qcom_spmi_pmic(E) regmap_spmi(E) ci_hdrc_msm(E) ci_hdrc(E) usb3503(E) extcon_usb_gpio(E) phy_msm_usb(E) udc_core(E) qcom_hwspinlock(E) extcon_core(E) ehci_msm(E) i2c_qup(E) sdhci(E) mmc_core(E) spmi_pmic_arb(E) spmi(E) qcom_smd(E) smsm(E) rpmsg_core(E) smp2p(E) smem(E) hwspinlock_core(E) gpio_keys(E)
  CPU: 2 PID: 551 Comm: irq/150-venus Tainted: P            E   4.12.0+ #1625
  Hardware name: qualcomm dragonboard410c/dragonboard410c, BIOS 2017.07-rc2-00144-ga97bdbdf72-dirty 07/08/2017
  task: ffff800037338000 task.stack: ffff800038e00000
  PC is at hfi_sys_init_done+0x64/0x140 [venus_core]
  LR is at hfi_process_msg_packet+0xcc/0x1e8 [venus_core]
  pc : [<ffff00000118b384>] lr : [<ffff00000118c11c>] pstate: 20400145
  sp : ffff800038e03c60
  x29: ffff800038e03c60 x28: 0000000000000000
  x27: 00000000000df018 x26: ffff00000118f4d0
  x25: 0000000000020003 x24: ffff80003a8d3010
  x23: ffff00000118f760 x22: ffff800037b40028
  x21: ffff8000382981f0 x20: ffff800037b40028
  x19: ffff80003c039000 x18: 0000000000000020
  x17: 0000000000000000 x16: ffff800037338000
  x15: ffffffffffffffff x14: 0000001000000014
  x13: 0000000100001007 x12: 0000000100000020
  x11: 0000100e00000000 x10: 0000000000000001
  x9 : 0000000200000000 x8 : 0000001400000001
  x7 : 0000000000001010 x6 : 0000000000000148
  x5 : 0000000000001009 x4 : ffff80003c039000
  x3 : 00000000cd770abb x2 : 0000000000000042
  x1 : 0000000000000788 x0 : 0000000000000002
  Process irq/150-venus (pid: 551, stack limit = 0xffff800038e00000)
  Call trace:
  [<ffff00000118b384>] hfi_sys_init_done+0x64/0x140 [venus_core]
  [<ffff00000118c11c>] hfi_process_msg_packet+0xcc/0x1e8 [venus_core]
  [<ffff00000118a2b4>] venus_isr_thread+0x1b4/0x208 [venus_core]
  [<ffff00000118e750>] hfi_isr_thread+0x28/0x38 [venus_core]
  [<ffff000008161550>] irq_thread_fn+0x30/0x70
  [<ffff0000081617fc>] irq_thread+0x14c/0x1c8
  [<ffff000008105e68>] kthread+0x138/0x140
  [<ffff000008083590>] ret_from_fork+0x10/0x40
  Code: 52820125 52820207 7a431820 54000249 (b9400263)
  ---[ end trace c963460f20a984b6 ]---

The problem is that in the error case, we've incremented the data ptr
but not decremented rem_bytes, and keep reading (presumably garbage)
until eventually we go beyond the end of the buffer.

Instead, on first error, we should probably just bail out.  Other
option is to increment read_bytes by sizeof(u32) before the switch,
rather than only accounting for the ptype header in the non-error
case.  Note that in this case it is HFI_ERR_SYS_INVALID_PARAMETER,
ie. an unrecognized/unsupported parameter, so interpreting the next
word as a property type would be bogus.  The other error cases are
due to truncated buffer, so there isn't likely to be anything valid
to interpret in the remainder of the buffer.  So just bailing seems
like a reasonable solution.

Signed-off-by: Rob Clark <robdclark@gmail.com>
Reviewed-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_msgs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_msgs.c b/drivers/media/platform/qcom/venus/hfi_msgs.c
index f8841713e417..a681ae5381d6 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -239,11 +239,12 @@ static void hfi_sys_init_done(struct venus_core *core, struct venus_inst *inst,
 			break;
 		}
 
-		if (!error) {
-			rem_bytes -= read_bytes;
-			data += read_bytes;
-			num_properties--;
-		}
+		if (error)
+			break;
+
+		rem_bytes -= read_bytes;
+		data += read_bytes;
+		num_properties--;
 	}
 
 err_no_prop:
-- 
2.11.0
