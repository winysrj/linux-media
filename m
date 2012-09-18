Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35204 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2IRHnA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 03:43:00 -0400
Received: by pbbrr13 with SMTP id rr13so10518186pbb.19
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2012 00:43:00 -0700 (PDT)
Date: Tue, 18 Sep 2012 15:43:20 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org
Subject: Re: [PATCH 27/34] media: mx2_camera: use managed functions to clean
 up code
Message-ID: <20120918074315.GH1338@S2101-09.ap.freescale.net>
References: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org>
 <1347860103-4141-28-git-send-email-shawn.guo@linaro.org>
 <Pine.LNX.4.64.1209171110580.1689@axis700.grange>
 <CACKLOr1pa+kskDjFVJ6N++f4i5NMyEtjFELqrwqvaPR4ErXiNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr1pa+kskDjFVJ6N++f4i5NMyEtjFELqrwqvaPR4ErXiNA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2012 at 03:36:07PM +0200, javier Martin wrote:
> This patch breaks the driver:
> 
Javier,

Can you please apply the following change to see if it fixes the
problem?

Shawn

@@ -1783,6 +1783,8 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
                        goto exit;
        }

+       platform_set_drvdata(pdev, NULL);
+
        pcdev->soc_host.drv_name        = MX2_CAM_DRV_NAME,
        pcdev->soc_host.ops             = &mx2_soc_camera_host_ops,
        pcdev->soc_host.priv            = pcdev;

> soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
> Unable to handle kernel paging request at virtual address 656d6162
> pgd = c0004000
> [656d6162] *pgd=00000000
> Internal error: Oops: 80000005 [#1] PREEMPT ARM
> Modules linked in:
> CPU: 0    Not tainted  (3.6.0-rc5-01222-g3413fb1 #12)
> PC is at 0x656d6162
> LR is at soc_camera_host_register+0x230/0x81c
> pc : [<656d6162>]    lr : [<c01ff6a0>]    psr: 40000033
> sp : c3025e48  ip : 00000000  fp : 00000000
> r10: c03f236c  r9 : 00000000  r8 : 00000001
> r7 : 00000000  r6 : c317d414  r5 : c30431a0  r4 : c317d600
> r3 : 656d6163  r2 : c3025e18  r1 : 000c0000  r0 : c317d600
> Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment kernel
> Control: 0005317f  Table: a0004000  DAC: 00000017
> Process swapper (pid: 1, stack limit = 0xc3024270)
> Stack: (0xc3025e48 to 0xc3026000)
> 5e40:                   c3006460 00000000 c3192960 00000043 c317d638 c005d624
> 5e60: 00000043 c317d410 c317d478 c317d414 c02012f0 c317d410 00000000 00000043
> 5e80: c31a9800 c31a9820 00000000 c022ca74 c300ab20 00000000 c306e4a8 c306e4a0
> 5ea0: c30000c0 40000013 000080d0 c317d410 c317d410 c306e4a8 c306e4a0 00000001
> 5ec0: 00000000 c03f236c 00000000 c02c8d50 00000000 c03535ee c317d410 c02c8a44
> 5ee0: c306e4a8 c306e4a8 c03fc478 c03fc478 00000050 c03e0774 c03dc684 c0189d30
> 5f00: c306e4a8 c0188c3c c306e4a8 c306e4dc c03fc478 00000000 00000050 c0188db8
> 5f20: c03fc478 c3025f30 c0188d58 c0187610 c300760c c3079ad0 c03fc478 c03fc478
> 5f40: c318e680 c03f6458 00000000 c0187d24 c03535ee c03535ee c3025f58 c03fc478
> 5f60: 00000001 c04049c0 00000000 c01892c8 c03fc464 00000001 c04049c0 00000000
> 5f80: 00000050 c018a05c c03dc67c c03d4e84 c04049c0 c00087c8 00000006 00000006
> 5fa0: c03eeca0 c03dc67c 00000007 c03dc67c 00000007 c04049c0 c03c41a4 00000050
> 5fc0: c03e0774 c03c42f4 00000006 00000006 c03c41a4 00000000 00000000 c03c4214
> 5fe0: c0014900 00000013 00000000 00000000 00000000 c0014900 ffffffff ffffffff
> [<c01ff6a0>] (soc_camera_host_register+0x230/0x81c) from [<c02c8d50>]
> (mx2_camera_probe+0x30c/0x3ac)
> [<c02c8d50>] (mx2_camera_probe+0x30c/0x3ac) from [<c0189d30>]
> (platform_drv_probe+0x14/0x18)
> [<c0189d30>] (platform_drv_probe+0x14/0x18) from [<c0188c3c>]
> (driver_probe_device+0xb0/0x1cc)
> [<c0188c3c>] (driver_probe_device+0xb0/0x1cc) from [<c0188db8>]
> (__driver_attach+0x60/0x84)
> [<c0188db8>] (__driver_attach+0x60/0x84) from [<c0187610>]
> (bus_for_each_dev+0x48/0x84)
> [<c0187610>] (bus_for_each_dev+0x48/0x84) from [<c0187d24>]
> (bus_add_driver+0x9c/0x20c)
> [<c0187d24>] (bus_add_driver+0x9c/0x20c) from [<c01892c8>]
> (driver_register+0xa0/0x138)
> [<c01892c8>] (driver_register+0xa0/0x138) from [<c018a05c>]
> (platform_driver_probe+0x18/0x98)
> [<c018a05c>] (platform_driver_probe+0x18/0x98) from [<c00087c8>]
> (do_one_initcall+0x94/0x16c)
> [<c00087c8>] (do_one_initcall+0x94/0x16c) from [<c03c42f4>]
> (kernel_init+0xe0/0x1ac)
> [<c03c42f4>] (kernel_init+0xe0/0x1ac) from [<c0014900>]
> (kernel_thread_exit+0x0/0x8)
> Code: bad PC value
> ---[ end trace 7f259a1ce2e10b1a ]---
> Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> 
