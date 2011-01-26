Return-path: <mchehab@pedra>
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:36692 "EHLO
	homiemail-a21.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753941Ab1AZTdY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 14:33:24 -0500
Received: from homiemail-a21.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a21.g.dreamhost.com (Postfix) with ESMTP id BD57C300074
	for <linux-media@vger.kernel.org>; Wed, 26 Jan 2011 11:33:23 -0800 (PST)
Received: from [10.0.1.35] (s64-180-61-141.bc.hsia.telus.net [64.180.61.141])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: neil@gumstix.com)
	by homiemail-a21.g.dreamhost.com (Postfix) with ESMTPSA id 8B232300059
	for <linux-media@vger.kernel.org>; Wed, 26 Jan 2011 11:33:23 -0800 (PST)
Message-ID: <4D4076C3.4080201@gumstix.com>
Date: Wed, 26 Jan 2011 11:32:19 -0800
From: Neil MacMunn <neil@gumstix.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: omap3-isp segfault
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

When I modprobe omap3-isp I get a segfault. I'm attempting to use a 
Gumstix Overo with Micron MT9V032.

    root@overo:~# modprobe omap3-isp
    Linux media interface: v0.10
    Linux video capture interface: v2.00
    omap3isp omap3isp: Revision 2.0 found
    Unable to handle kernel NULL pointer dereference at virtual address
    00000004
    pgd = cd4b0000
    [00000004] *pgd=8e77b031, *pte=00000000, *ppte=00000000
    Internal error: Oops: 17 [#1]
    last sysfs file: /sys/devices/virtual/net/lo/type
    Modules linked in: omap3_isp(+) v4l2_common videodev v4l1_compat
    media iovmm ipv6 libertas_sdio libertas lib80211 option usb_wwan
    ads7846 usbserial iommu
    CPU: 0    Not tainted  (2.6.36+ #9)
    PC is at iommu_get+0x74/0x108 [iommu]
    LR is at iommu_get+0x78/0x108 [iommu]
    pc : [<bf0009fc>]    lr : [<bf000a00>]    psr: 20000013
    sp : ced33db0  ip : 22222222  fp : bf100bb8
    r10: cdf48000  r9 : c0580938  r8 : 00000001
    r7 : 000003ff  r6 : ce78f218  r5 : 00000000  r4 : ce78f200
    r3 : 00000000  r2 : ffffffd0  r1 : 22222222  r0 : ce78f200
    Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
    Control: 10c5387d  Table: 8d4b0019  DAC: 00000015
    Process modprobe (pid: 1327, stack limit = 0xced322f0)
    Stack: (0xced33db0 to 0xced34000)
    3da0:                                     0000000e 00000000 cdf48000
    bf0f46a4
    3dc0: 00000001 c01096c4 ce54e848 c0580940 00000000 ce6347c0 cec54a58
    00000000
    3de0: bf102adc c0580940 c0580940 bf102adc bf102adc c05a10d0 ced33f64
    00000000
    3e00: ced32000 c023d49c bf102adc c023c4dc ced33f64 c0580940 c0580974
    bf102adc
    3e20: ced33e38 c023c624 00000000 c023c5c4 bf102adc c023bcdc cec21cf8
    cec4f5f0
    3e40: c05a10d0 00000000 bf102adc bf102adc ce6347c0 c023b5b4 bf101bdb
    cec02b88
    3e60: cec02b80 00000000 00000018 bf102adc bf104974 bf10c000 00000000
    c023c944
    3e80: 00000000 00000018 00000000 bf104974 bf10c000 c00353c0 00000198
    d12c0000
    3ea0: 00000000 00000018 00000000 00000000 00000018 00000000 bf104974
    00000000
    3ec0: ced33f7c c0085860 00000000 00000000 cdc95c9c ced33f70 01a960e8
    bf104980
    3ee0: 000003dd d13fa11c d12c0000 00197522 d13f98fc d13f96e0 d1454c9c
    cdd08000
    3f00: 00011abc 00014b2c 00000000 00000000 00000034 00000035 0000001a
    0000001e
    3f20: 00000011 00000000 6e72656b 00006c65 00000000 00000000 00000000
    00000000
    3f40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
    00000000
    3f60: 00000000 00000000 00000000 bf102174 00000003 00000000 00000000
    c053b028
    3f80: 00000073 00009720 00000000 00000000 00000080 c0036044 ced32000
    01a96090
    3fa0: 00000000 c0035ec0 00009720 00000000 40296000 00197522 01a960e8
    01a960e8
    3fc0: 00009720 00000000 00000000 00000080 00000000 01a9609c 01a96090
    00000000
    3fe0: 01a96120 beb95924 0000b180 40232084 60000010 40296000 00000000
    00000000
    [<bf0009fc>] (iommu_get+0x74/0x108 [iommu]) from [<bf0f46a4>]
    (isp_probe+0x258/0x9f0 [omap3_isp])
    [<bf0f46a4>] (isp_probe+0x258/0x9f0 [omap3_isp]) from [<c023d49c>]
    (platform_drv_probe+0x1c/0x24)
    [<c023d49c>] (platform_drv_probe+0x1c/0x24) from [<c023c4dc>]
    (driver_probe_device+0xcc/0x1b4)
    [<c023c4dc>] (driver_probe_device+0xcc/0x1b4) from [<c023c624>]
    (__driver_attach+0x60/0x84)
    [<c023c624>] (__driver_attach+0x60/0x84) from [<c023bcdc>]
    (bus_for_each_dev+0x4c/0x8c)
    [<c023bcdc>] (bus_for_each_dev+0x4c/0x8c) from [<c023b5b4>]
    (bus_add_driver+0xa0/0x21c)
    [<c023b5b4>] (bus_add_driver+0xa0/0x21c) from [<c023c944>]
    (driver_register+0xbc/0x148)
    [<c023c944>] (driver_register+0xbc/0x148) from [<c00353c0>]
    (do_one_initcall+0xc8/0x194)
    [<c00353c0>] (do_one_initcall+0xc8/0x194) from [<c0085860>]
    (sys_init_module+0x13f8/0x15bc)
    [<c0085860>] (sys_init_module+0x13f8/0x15bc) from [<c0035ec0>]
    (ret_fast_syscall+0x0/0x30)
    Code: e59f3098 e1a00004 e5933000 e1a0e00f (e593f004)
    ---[ end trace 7243c66244fbd250 ]---
      overo Internal error: Oops: 17 [#1]
      overo last sysfs file: /sys/devices/virtual/net/lo/type
      overo Process modprobe (pid: 1327, stack limit = 0xced322f0)
      overo Stack: (0xced33db0 to 0xced34000)
      overo 3da0:                                     0000000e 00000000
    cdf48000 bf0f46a4
      overo 3dc0: 00000001 c01096c4 ce54e848 c0580940 00000000 ce6347c0
    cec54a58 00000000
      overo 3de0: bf102adc c0580940 c0580940 bf102adc bf102adc c05a10d0
    ced33f64 00000000
      overo 3e00: ced32000 c023d49c bf102adc c023c4dc ced33f64 c0580940
    c0580974 bf102adc
      overo 3e20: ced33e38 c023c624 00000000 c023c5c4 bf102adc c023bcdc
    cec21cf8 cec4f5f0
      overo 3e40: c05a10d0 00000000 bf102adc bf102adc ce6347c0 c023b5b4
    bf101bdb cec02b88
      overo 3e60: cec02b80 00000000 00000018 bf102adc bf104974 bf10c000
    00000000 c023c944
      overo 3e80: 00000000 00000018 00000000 bf104974 bf10c000 c00353c0
    00000198 d12c0000
      overo 3ea0: 00000000 00000018 00000000 00000000 00000018 00000000
    bf104974 00000000
      overo 3ec0: ced33f7c c0085860 00000000 00000000 cdc95c9c ced33f70
    01a960e8 bf104980
      overo 3ee0: 000003dd d13fa11c d12c0000 00197522 d13f98fc d13f96e0
    d1454c9c cdd08000
      overo 3f00: 00011abc 00014b2c 00000000 00000000 00000034 00000035
    0000001a 0000001e
      overo 3f20: 00000011 00000000 6e72656b 00006c65 00000000 00000000
    00000000 00000000
      overo 3f40: 00000000 00000000 00000000 00000000 00000000 00000000
    00000000 00000000
      overo 3f60: 00000000 00000000 00000000 bf102174 00000003 00000000
    00000000 c053b028
      overo 3f80: 00000073 00009720 00000000 00000000 00000080 c0036044
    ced32000 01a96090
      overo 3fa0: 00000000 c0035ec0 00009720 00000000 40296000 00197522
    01a960e8 01a960e8
      overo 3fc0: 00009720 00000000 00000000 00000080 00000000 01a9609c
    01a96090 00000000
      overo 3fe0: 01a96120 beb95924 0000b180 40232084 60000010 40296000
    00000000 00000000
      overo Code: e59f3098 e1a00004 e5933000 e1a0e00f (e593f004)
    Segmentation fault


My ISP and MT9V032 code come from 
http://git.linuxtv.org/pinchartl/media.git?a=shortlog;h=refs/heads/media-0006-sensors 
and my board-overo.c (based on board-rx51.c) contains:

    ...
    static int __init overo_i2c_init(void)
    {
         omap_register_i2c_bus(1, 2600, overo_i2c_boardinfo,
                 ARRAY_SIZE(overo_i2c_boardinfo));
         /* i2c2 pins are used for gpio */
         omap_register_i2c_bus(3, 400, NULL, 0);
         return 0;
    }
    ... 

    #include <media/mt9v032.h>
    #include "devices.h"
    #include "../../../drivers/media/video/isp/isp.h"
    #include "../../../drivers/media/video/isp/ispreg.h"

    #define MT9V032_I2C_BUS_NUM        (0x03)
    #define MT9V032_I2C_ADDR        (0x5C)
    #define MT9V032_XCLK            (0x00)

    static void mt9v032_set_clock(struct v4l2_subdev *subdev, unsigned
    int rate)
    {
         struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);

         isp->platform_cb.set_xclk(isp, rate, MT9V032_XCLK);
    }

    static struct mt9v032_platform_data mt9v032_platform_data = {
         .clk_pol = 0,
         .set_clock = mt9v032_set_clock,
    };

    static struct i2c_board_info mt9v032_i2c_board_info[] = {
         {
             I2C_BOARD_INFO("mt9v032", MT9V032_I2C_ADDR),
             .platform_data    = &mt9v032_platform_data,
         },
    };

    static struct isp_subdev_i2c_board_info pixhawk_camera_subdevs[] = {
         {
             .board_info = &mt9v032_i2c_board_info[0],
             .i2c_adapter_id = MT9V032_I2C_BUS_NUM,
         },
         { NULL, 0, },
    };

    static struct isp_v4l2_subdevs_group pixhawk_camera_subdevs_group[] = {
             {
             .subdevs = pixhawk_camera_subdevs,
             .interface = ISP_INTERFACE_PARALLEL,
             .bus = { .parallel = {
                     .data_lane_shift        = 0,
                     .clk_pol                = 1,
                     .bridge                 = ISPCTRL_PAR_BRIDGE_DISABLE,
              } },
         },
         { NULL, 0, },
    };

    static struct isp_platform_data isp_platform_data = {
         .subdevs = pixhawk_camera_subdevs_group,
    };

    static void __init overo_init(void)
    {
         overo_i2c_init();
         if (omap3_init_camera(&isp_platform_data) < 0)
             printk(KERN_WARNING "%s: Unable to register camera platform "
                    "device\n", __func__);
    ...


I've had this hardware working with older kernels but I'm trying to make 
the conversion to the subdev api and a better driver (thanks Laurent!). 
Anyone know what might be going on? This is my first linux-media post so 
if I've commited any faux pas please let me know. Thanks!

Neil
