Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45315 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab0JOMGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 08:06:45 -0400
Received: by gxk6 with SMTP id 6so296614gxk.19
        for <linux-media@vger.kernel.org>; Fri, 15 Oct 2010 05:06:44 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Oct 2010 13:59:24 +0200
Message-ID: <AANLkTikq8pmOpGn1N4xbiB2nmsNzrC4wzcD0_HUJpZ1J@mail.gmail.com>
Subject: OMAP 3530 ISP driver segfaults
From: Bastian Hecht <hechtb@googlemail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello ISP driver developers,

after the lastest pull of branch 'devel' of
git://gitorious.org/maemo-multimedia/omap3isp-rx51 I get a segfault
when I register my ISP_device.
The segfault happens in isp.c in line
     isp->iommu = iommu_get("isp");

I noticed that with the new kernel the module iommu is loaded
automatically after booting while it wasn't in before my pull (my old
pull is about 3 days old).
Tell me what kind of further info you need. Btw, I run an Igepv2.

Thank you,

 Bastian



Here is the dmesg output since init:

[   62.589965] Freeing init memory: 128K
[   71.526092] omap-iommu omap-iommu.0: isp registered
[  106.695953] net eth0: SMSC911x/921x identified at 0xe0808000, IRQ: 336
[  148.803588] Linux media interface: v0.10
[  149.751892] Linux video capture interface: v2.00
[  155.912719] address of isp_platform_data in boardconfig: bf058074
[  155.919219] address of isp_platform_data bf058074
[  155.932434] omap3isp omap3isp: Revision 2.0 found
[  155.940673] Unable to handle kernel NULL pointer dereference at
virtual address 00000004
[  155.948852] pgd = dedb8000
[  155.951599] [00000004] *pgd=9fffa031, *pte=00000000, *ppte=00000000
[  155.957977] Internal error: Oops: 17 [#1]
[  155.962036] last sysfs file: /sys/module/iommu/initstate
[  155.967407] Modules linked in: board_bastix(+) omap3_isp
v4l2_common videodev media iovmm iommu
[  155.976257] CPU: 0    Not tainted  (2.6.35+ #4)
[  155.980834] PC is at iommu_get+0x70/0x108 [iommu]
[  155.985595] LR is at clk_enable+0x38/0x4c
[  155.989654] pc : [<bf000bf8>]    lr : [<c0037920>]    psr: 20000013
[  155.989654] sp : deeefe68  ip : 22222222  fp : 00000000
[  156.001220] r10: decf8014  r9 : c03d3760  r8 : 00000000
[  156.006500] r7 : 000007ff  r6 : dfe6be18  r5 : c03d3758  r4 : dfe6be00
[  156.013092] r3 : 00000000  r2 : 22222222  r1 : c03d8b64  r0 : dfe6be00
[  156.019683] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  156.026855] Control: 10c5387d  Table: 9edb8019  DAC: 00000015
[  156.032653] Process insmod (pid: 1877, stack limit = 0xdeeee2f0)
[  156.038726] Stack: (0xdeeefe68 to 0xdeef0000)
[  156.043121] fe60:                   decf8000 c03d3758 0000000f
bf0333dc 00000000 00000001
[  156.051391] fe80: 00000000 00000000 dee13ba8 00000000 c03d3768
c03d3760 c03d3760 00000000
[  156.059631] fea0: bf045314 c0028fc4 00000000 00000000 00000000
c019bd50 c019bd3c c019af30
[  156.067901] fec0: c019bdec c03d3760 c019b064 00000000 00000000
c019a548 dfc04b08 dfcf2774
[  156.076141] fee0: c03d3794 c03d3760 c03f7770 c019b118 00000001
c03d3760 c03d3768 c019a3b8
[  156.084411] ff00: c03d3760 c0198ff0 deeeff40 c03d3768 c03d3768
00000000 00000000 c015e050
[  156.092651] ff20: c03d3758 c03d3758 00000010 000001c0 00014154
c0028fc4 deeee000 00013008
[  156.100921] ff40: 00000000 c019c15c 00000000 bf05b000 00000000
00000000 00014154 c0028330
[  156.109161] ff60: bf0580c4 00000000 00013008 00014154 c0028fc4
bf0580c4 00000000 00013008
[  156.117431] ff80: 00014154 c006c948 00013018 00014154 00013008
4000e93c 00020000 00000003
[  156.125701] ffa0: 00000080 c0028e40 4000e93c 00020000 00013018
00014154 00013008 00000001
[  156.133941] ffc0: 4000e93c 00020000 00000003 00000080 be989a2b
00000000 00013008 00000000
[  156.142211] ffe0: 00013018 be9897ac 000090d8 400fa194 20000010
00013018 c00c0000 3300000c
[  156.150543] [<bf000bf8>] (iommu_get+0x70/0x108 [iommu]) from
[<bf0333dc>] (isp_probe+0x2e8/0xbe4 [omap3_isp])
[  156.160583] [<bf0333dc>] (isp_probe+0x2e8/0xbe4 [omap3_isp]) from
[<c019bd50>] (platform_drv_probe+0x14/0x18)
[  156.170623] [<c019bd50>] (platform_drv_probe+0x14/0x18) from
[<c019af30>] (driver_probe_device+0xa8/0x158)
[  156.180358] [<c019af30>] (driver_probe_device+0xa8/0x158) from
[<c019a548>] (bus_for_each_drv+0x48/0x80)
[  156.189941] [<c019a548>] (bus_for_each_drv+0x48/0x80) from
[<c019b118>] (device_attach+0x50/0x68)
[  156.198913] [<c019b118>] (device_attach+0x50/0x68) from
[<c019a3b8>] (bus_probe_device+0x24/0x40)
[  156.207855] [<c019a3b8>] (bus_probe_device+0x24/0x40) from
[<c0198ff0>] (device_add+0x308/0x46c)
[  156.216735] [<c0198ff0>] (device_add+0x308/0x46c) from [<c019c15c>]
(platform_device_add+0x104/0x160)
[  156.226043] [<c019c15c>] (platform_device_add+0x104/0x160) from
[<c0028330>] (do_one_initcall+0x58/0x1b4)
[  156.235717] [<c0028330>] (do_one_initcall+0x58/0x1b4) from
[<c006c948>] (sys_init_module+0x90/0x1a4)
[  156.244964] [<c006c948>] (sys_init_module+0x90/0x1a4) from
[<c0028e40>] (ret_fast_syscall+0x0/0x30)




My board specific code:

//  IGEP CAM BUS NUM
#define BASTIX_CAM_I2C_BUS_NUM          2

static int __init cam_init(void)
{
        return 0;
}

static struct mt9t001_platform_data bastix_mt9p031_platform_data = {
        .clk_pol        = 0,
};


static struct i2c_board_info bastix_camera_i2c_devices[] = {
        {
                I2C_BOARD_INFO(MT9P031_NAME, MT9P031_I2C_ADDR),
                .platform_data = &bastix_mt9p031_platform_data,
        },
};

static struct v4l2_subdev_i2c_board_info bastix_camera_mt9p031[] = {
        {
                .board_info = &bastix_camera_i2c_devices[0],
                .i2c_adapter_id = BASTIX_CAM_I2C_BUS_NUM,
        },
        { NULL, 0, },
};

static struct isp_v4l2_subdevs_group bastix_camera_subdevs[] = {
        {
                .subdevs = bastix_camera_mt9p031,
                .interface = ISP_INTERFACE_PARALLEL,
                .bus = { .parallel = {
                       .data_lane_shift        = 1,
                       .clk_pol                = 1,
                       .bridge                 = ISPCTRL_PAR_BRIDGE_DISABLE,
                } },
        },
        { NULL, 0, },
};

static struct isp_platform_data bastix_isp_platform_data = {
        .subdevs = bastix_camera_subdevs,
};

static int __init bastix_camera_init(void)
{
        int err;

        printk(KERN_ALERT "address of isp_platform_data in
boardconfig: %x\n", &bastix_isp_platform_data);
        err = cam_init();
        if (err)
                return err;
        omap3isp_device.dev.platform_data = &bastix_isp_platform_data;

        return platform_device_register(&omap3isp_device);
}

static void __exit bastix_camera_exit(void)
{
        platform_device_unregister(&omap3isp_device);
}

module_init(bastix_camera_init);
module_exit(bastix_camera_exit);

MODULE_LICENSE("GPL");
