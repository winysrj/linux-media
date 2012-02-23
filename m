Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60736 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2BWEmr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 23:42:47 -0500
Received: by pbcun15 with SMTP id un15so963733pbc.19
        for <linux-media@vger.kernel.org>; Wed, 22 Feb 2012 20:42:46 -0800 (PST)
Message-ID: <4F45C3C1.8030507@linaro.org>
Date: Thu, 23 Feb 2012 10:12:41 +0530
From: Tushar Behera <tushar.behera@linaro.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>
CC: Thomas Abraham <thomas.abraham@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: S5P-TV: Warning for regulator unbalanced disables
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

After implementing genpd framework for EXYNOS4, (Ref commit 91cfbd4
"ARM: EXYNOS: Hook up power domains to generic power domain
infrastructure" in Kukjin's for-next branch), we are getting following
warning from s5p-hdmi driver.

The test was done on Origen board with code based on 3.3-rc4 and
Kukjin's for-next branch. [1]

------------[ cut here ]------------
WARNING: at drivers/regulator/core.c:1503 _regulator_disable+0xf8/0x164()
unbalanced disables for VMIPI_1.1V
Modules linked in:
regulator_init_complete: VDD_G3D_1.1V: incomplete constraints, leaving on
[<c0014624>] (unwind_backtrace+0x0/0xf8) from [<c00232fc>]
(warn_slowpath_common+0x54/0x64)
[<c00232fc>] (warn_slowpath_common+0x54/0x64) from [<c00233a0>]
(warn_slowpath_fmt+0x30/0x40)
[<c00233a0>] (warn_slowpath_fmt+0x30/0x40) from [<c01ab9b8>]
(_regulator_disable+0xf8/0x164)
[<c01ab9b8>] (_regulator_disable+0xf8/0x164) from [<c01aba40>]
(regulator_disable+0x1c/0x48)
[<c01aba40>] (regulator_disable+0x1c/0x48) from [<c01abcf4>]
(regulator_bulk_disable+0x24/0x8c)
regulator_init_complete: VADC_3.3V: incomplete constraints, leaving on
[<c01abcf4>] (regulator_bulk_disable+0x24/0x8c) from [<c028d874>]
(hdmi_runtime_suspend+0x28/0x30)
[<c028d874>] (hdmi_runtime_suspend+0x28/0x30) from [<c01edac4>]
(pm_genpd_default_save_state+0x48/0x5c)
[<c01edac4>] (pm_genpd_default_save_state+0x48/0x5c) from [<c01eeed4>]
(pm_genpd_poweroff+0x224/0x3f0)
[<c01eeed4>] (pm_genpd_poweroff+0x224/0x3f0) from [<c01ef190>]
(genpd_power_off_work_fn+0x1c/0x28)
[<c01ef190>] (genpd_power_off_work_fn+0x1c/0x28) from [<c0036ac0>]
(process_one_work+0x118/0x3b0)
regulator_init_complete: VMIPI_1.8V: incomplete constraints, leaving on
[<c0036ac0>] (process_one_work+0x118/0x3b0) from [<c0039424>]
(worker_thread+0x18c/0x3a0)
[<c0039424>] (worker_thread+0x18c/0x3a0) from [<c003d734>]
(kthread+0x8c/0x90)
[<c003d734>] (kthread+0x8c/0x90) from [<c000f278>]
(kernel_thread_exit+0x0/0x8)
---[ end trace 9e20783f432f4c81 ]---

[1] git://git.linaro.org/people/tushar/linux-linaro-samsung.git
(test/hdmi-pd)

-- 
Tushar Behera
