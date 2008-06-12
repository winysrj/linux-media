Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5CFq1j1027842
	for <video4linux-list@redhat.com>; Thu, 12 Jun 2008 11:52:01 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id m5CFpSaG015794
	for <video4linux-list@redhat.com>; Thu, 12 Jun 2008 11:51:29 -0400
Date: Thu, 12 Jun 2008 17:51:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
In-Reply-To: <48512E08.6020608@teltonika.lt>
Message-ID: <Pine.LNX.4.64.0806121748070.18017@axis700.grange>
References: <48512E08.6020608@teltonika.lt>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Greg KH <greg@kroah.com>, video4linux-list@redhat.com,
	g.liakhovetski@pengutronix.de
Subject: Re: SoC camera crashes when host is not module
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, 12 Jun 2008, Paulius Zaleckas wrote:

> I am writing driver for i.MX CSI interface... And while I was loading my
> driver with insmod everything was OK, but when I compiled it into the
> kernel it crashed. I believe that it is a bug in the soc_camera. Seems
> like device_register is being used without kref initialization.

The problem is, I shouldn't put a device on a bus and assign it to a 
class. I don't understand, why it worked modular, and only crashed 
compiled in, Greg, I know you can explain this:-)

Paulius, please try the patch below. If it works for you, I'll get it 
upstream for 2.6.26.

BTW, I'd love to see at least one of those i.MX CSI drivers I only get to 
hear about and never to see one...

Thanks
Guennadi

> 
> [42949374.020000] WARNING: at lib/kref.c:43 kref_get+0x48/0x50()
> [42949374.020000] Modules linked in:
> [42949374.030000] [<c001c908>] (dump_stack+0x0/0x14) from [<c002d90c>]
> (warn_on_slowpath+0x4c/0x68)
> [42949374.040000] [<c002d8c0>] (warn_on_slowpath+0x0/0x68) from [<c00c5134>]
> (kref_get+0x48/0x50)
> [42949374.050000]  r6:c01ce6dc r5:c01ce55c r4:c01ce6e0
> [42949374.050000] [<c00c50ec>] (kref_get+0x0/0x50) from [<c00c4870>]
> (kobject_get+0x18/0x20)
> [42949374.060000]  r4:c01ce6dc
> [42949374.060000] [<c00c4858>] (kobject_get+0x0/0x20) from [<c00c4950>]
> (kobject_add_internal+0x64/0x1f8)
> [42949374.070000]  r4:c01ce55c
> [42949374.070000] [<c00c48ec>] (kobject_add_internal+0x0/0x1f8) from
> [<c00c4b94>] (kobject_add_varg+0x44/0x54)
> [42949374.080000]  r8:c01ce4f4 r7:00000000 r6:c01ce6dc r5:c01ce55c r4:00000000
> [42949374.090000] [<c00c4b50>] (kobject_add_varg+0x0/0x54) from [<c00c4eac>]
> (kobject_add+0x40/0x68)
> [42949374.100000]  r6:c01ce580 r5:c01c8aec r4:c01ce4f4
> [42949374.110000] [<c00c4e6c>] (kobject_add+0x0/0x68) from [<c00e292c>]
> (device_add+0x7c/0x4f4)
> [42949374.110000]  r3:c01ce580 r2:c019f4dc
> [42949374.120000] [<c00e28b0>] (device_add+0x0/0x4f4) from [<c00e2dc0>]
> (device_register+0x1c/0x20)
> [42949374.130000] [<c00e2da4>] (device_register+0x0/0x20) from [<c00f74f0>]
> (soc_camera_host_register+0xc0/0x19c)
> [42949374.140000]  r4:c01ce4ec
> [42949374.140000] [<c00f7430>] (soc_camera_host_register+0x0/0x19c) from
> [<c0014054>] (imx_camera_probe+0x260/0x380)
> [42949374.150000]  r8:00000006 r7:00000000 r6:c01c8778 r5:c01c8aec r4:c3c96cfc
> [42949374.160000] [<c0013df4>] (imx_camera_probe+0x0/0x380) from [<c00e573c>]
> (platform_drv_probe+0x20/0x24)
> [42949374.170000] [<c00e571c>] (platform_drv_probe+0x0/0x24) from [<c00e4a2c>]
> (driver_probe_device+0xb0/0x1b4)
> [42949374.180000] [<c00e497c>] (driver_probe_device+0x0/0x1b4) from
> [<c00e4b98>] (__driver_attach+0x68/0x6c)
> [42949374.190000]  r8:c01cdea4 r7:c00e4b30 r6:c01ce4b0 r5:c01c8828 r4:c01c8780
> [42949374.200000] [<c00e4b30>] (__driver_attach+0x0/0x6c) from [<c00e4124>]
> (bus_for_each_dev+0x5c/0x88)
> [42949374.200000]  r6:c01ce4b0 r5:c3c0ded0 r4:00000000
> [42949374.210000] [<c00e40c8>] (bus_for_each_dev+0x0/0x88) from [<c00e488c>]
> (driver_attach+0x20/0x28)
> [42949374.220000]  r7:c0011874 r6:c01ce4b0 r5:c01ce4b0 r4:c3c96be8
> [42949374.230000] [<c00e486c>] (driver_attach+0x0/0x28) from [<c00e4568>]
> (bus_add_driver+0xa8/0x1dc)
> [42949374.230000] [<c00e44c0>] (bus_add_driver+0x0/0x1dc) from [<c00e4d34>]
> (driver_register+0x54/0x130)
> [42949374.240000] [<c00e4ce0>] (driver_register+0x0/0x130) from [<c00e59c4>]
> (platform_driver_register+0x6c/0x88)
> [42949374.250000]  r8:c3c0c000 r7:c0011874 r6:00000000 r5:00000000 r4:c0016404
> [42949374.260000] [<c00e5958>] (platform_driver_register+0x0/0x88) from
> [<c0011888>] (imx_camera_init+0x14/0x1c)
> [42949374.270000] [<c0011874>] (imx_camera_init+0x0/0x1c) from [<c00087ac>]
> (kernel_init+0x78/0x290)
> [42949374.280000] [<c0008734>] (kernel_init+0x0/0x290) from [<c0030dfc>]
> (do_exit+0x0/0x614)
> [42949374.290000] ---[ end trace 362b35ef15250fa4 ]---
> [42949374.290000] kobject: 'camera_host0' (c01ce55c): kobject_add_internal:
> parent: '<NULL>', set: 'devices'
> [42949374.300000] Unable to handle kernel NULL pointer dereference at virtual
> address 00000020
> [42949374.310000] pgd = c0004000
> [42949374.320000] [00000020] *pgd=00000000
> [42949374.320000] Internal error: Oops: 5 [#1]
> [42949374.320000] Modules linked in:
> [42949374.320000] CPU: 0    Tainted: G        W  (2.6.26-rc4 #24)
> [42949374.320000] PC is at sysfs_addrm_start+0x34/0x9c
> [42949374.320000] LR is at sysfs_addrm_start+0x28/0x9c
> [42949374.320000] pc : [<c00a4ffc>]    lr : [<c00a4ff0>]    psr: 60000013
> [42949374.320000] sp : c3c0dcd8  ip : c3c0dcd8  fp : c3c0dcec
> [42949374.320000] r10: c01c8780  r9 : c01ce55c  r8 : c3c0dd24
> [42949374.320000] r7 : 00000000  r6 : c01ce55c  r5 : c3c0dcf0  r4 : 00000000
> [42949374.320000] r3 : 00000000  r2 : c01d4220  r1 : ffffffd0  r0 : c3c03004
> [42949374.320000] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM Segment
> kernel
> [42949374.320000] Control: 0000317f  Table: 08004000  DAC: 00000017
> [42949374.320000] Process swapper (pid: 1, stack limit = 0xc3c0c260)
> [42949374.320000] Stack: (0xc3c0dcd8 to 0xc3c0e000)
> [42949374.320000] dcc0:       c3c0dcf0 c3c96d94
> [42949374.320000] dce0: c3c0dd20 c3c0dcf0 c00a5580 c00a4fd8 00000000 00000000
> 00000000 00000000
> [42949374.320000] dd00: c01ce55c c01ce55c c01ce6dc 00000000 c01ce6dc c3c0dd38
> c3c0dd24 c00a561c
> [42949374.320000] dd20: c00a5544 c00c49cc c01ce55c c3c0dd64 c3c0dd3c c00c49e0
> c00a55f4 00000000
> [42949374.320000] dd40: c3c07394 00000000 c01ce55c c01ce6dc 00000000 c01ce4f4
> c3c0dd80 c3c0dd68
> [42949374.320000] dd60: c00c4b94 c00c48fc c01ce4f4 c01c8aec c01ce580 c3c0dd94
> c3c0dd84 c00c4eac
> [42949374.320000] dd80: c00c4b60 c3c0dd9c c3c0ddd0 c3c0dda0 c00e292c c00c4e80
> c019f4dc c01ce580
> [42949374.320000] dda0: c01c8780 c3c0ddd0 c01ce4f4 c01c8aec c01c8778 00000000
> c01ce4f4 c4850000
> [42949374.320000] ddc0: c01c8780 c3c0dde4 c3c0ddd4 c00e2dc0 c00e28c0 c01ce4ec
> c3c0de08 c3c0dde8
> [42949374.320000] dde0: c00f74f0 c00e2db4 c3c96cfc c01c8aec c01c8778 00000000
> 00000006 c3c0de7c
> [42949374.320000] de00: c3c0de0c c0014054 c00f7440 c00c79e4 c3c0de44 c3c96ccc
> c3c0de40 c3c0de28
> [42949374.320000] de20: c3c0de44 00000000 c3c96ccc c3c23418 e000928c c4850000
> c4850008 c00a5fbc
> [42949374.320000] de40: c00a5254 c3c23418 00000000 00000000 00000001 c01c8780
> c01ce4b0 c01ce4b0
> [42949374.320000] de60: c00e4b30 c01d6350 00000000 00000000 c3c0de8c c3c0de80
> c00e573c c0013e04
> [42949374.320000] de80: c3c0deb0 c3c0de90 c00e4a2c c00e572c c01c8780 c01c8828
> c01ce4b0 c00e4b30
> [42949374.320000] dea0: c01cdea4 c3c0decc c3c0deb4 c00e4b98 c00e498c 00000000
> c3c0ded0 c01ce4b0
> [42949374.320000] dec0: c3c0def8 c3c0ded0 c00e4124 c00e4b40 c3c07818 c3c07818
> c01c87c8 c3c96be8
> [42949374.320000] dee0: c01ce4b0 c01ce4b0 c0011874 c3c0df08 c3c0defc c00e488c
> c00e40d8 c3c0df34
> [42949374.320000] df00: c3c0df0c c00e4568 c00e487c c01a179c c0016404 c01ce4b0
> 00000000 c0011874
> [42949374.320000] df20: c3c0c000 c0015168 c3c0df58 c3c0df38 c00e4d34 c00e44d0
> c0016404 00000000
> [42949374.320000] df40: 00000000 c0011874 c3c0c000 c3c0df68 c3c0df5c c00e59c4
> c00e4cf0 c3c0df78
> [42949374.320000] df60: c3c0df6c c0011888 c00e5968 c3c0dff4 c3c0df7c c00087ac
> c0011884 bee40f34
> [42949374.320000] df80: c3c0dfa4 c3c0c000 00000000 c3c0df00 c3c0df9c c002af78
> c002ac3c 00000000
> [42949374.320000] dfa0: 00000000 c3c0dfb0 c0018aa4 c002af68 00000000 00000000
> c0008734 c0030dfc
> [42949374.320000] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
> [42949374.320000] dfe0: 00000000 00000000 00000000 c3c0dff8 c0030dfc c0008744
> 00000000 02000000
> [42949374.320000] Backtrace:
> [42949374.320000] [<c00a4fc8>] (sysfs_addrm_start+0x0/0x9c) from [<c00a5580>]
> (create_dir+0x4c/0xb0)
> [42949374.320000]  r5:c3c96d94 r4:c3c0dcf0
> [42949374.320000] [<c00a5534>] (create_dir+0x0/0xb0) from [<c00a561c>]
> (sysfs_create_dir+0x38/0x4c)
> [42949374.320000]  r8:c01ce6dc r7:00000000 r6:c01ce6dc r5:c01ce55c r4:c01ce55c
> [42949374.320000] [<c00a55e4>] (sysfs_create_dir+0x0/0x4c) from [<c00c49e0>]
> (kobject_add_internal+0xf4/0x1f8)
> [42949374.320000]  r4:c01ce55c
> [42949374.320000] [<c00c48ec>] (kobject_add_internal+0x0/0x1f8) from
> [<c00c4b94>] (kobject_add_varg+0x44/0x54)
> [42949374.320000]  r8:c01ce4f4 r7:00000000 r6:c01ce6dc r5:c01ce55c r4:00000000
> [42949374.320000] [<c00c4b50>] (kobject_add_varg+0x0/0x54) from [<c00c4eac>]
> (kobject_add+0x40/0x68)
> [42949374.320000]  r6:c01ce580 r5:c01c8aec r4:c01ce4f4
> [42949374.320000] [<c00c4e6c>] (kobject_add+0x0/0x68) from [<c00e292c>]
> (device_add+0x7c/0x4f4)
> [42949374.320000]  r3:c01ce580 r2:c019f4dc
> [42949374.320000] [<c00e28b0>] (device_add+0x0/0x4f4) from [<c00e2dc0>]
> (device_register+0x1c/0x20)
> [42949374.320000] [<c00e2da4>] (device_register+0x0/0x20) from [<c00f74f0>]
> (soc_camera_host_register+0xc0/0x19c)
> [42949374.320000]  r4:c01ce4ec
> [42949374.320000] [<c00f7430>] (soc_camera_host_register+0x0/0x19c) from
> [<c0014054>] (imx_camera_probe+0x260/0x380)
> [42949374.320000]  r8:00000006 r7:00000000 r6:c01c8778 r5:c01c8aec r4:c3c96cfc
> [42949374.320000] [<c0013df4>] (imx_camera_probe+0x0/0x380) from [<c00e573c>]
> (platform_drv_probe+0x20/0x24)
> [42949374.320000] [<c00e571c>] (platform_drv_probe+0x0/0x24) from [<c00e4a2c>]
> (driver_probe_device+0xb0/0x1b4)
> [42949374.320000] [<c00e497c>] (driver_probe_device+0x0/0x1b4) from
> [<c00e4b98>] (__driver_attach+0x68/0x6c)
> [42949374.320000]  r8:c01cdea4 r7:c00e4b30 r6:c01ce4b0 r5:c01c8828 r4:c01c8780
> [42949374.320000] [<c00e4b30>] (__driver_attach+0x0/0x6c) from [<c00e4124>]
> (bus_for_each_dev+0x5c/0x88)
> [42949374.320000]  r6:c01ce4b0 r5:c3c0ded0 r4:00000000
> [42949374.320000] [<c00e40c8>] (bus_for_each_dev+0x0/0x88) from [<c00e488c>]
> (driver_attach+0x20/0x28)
> [42949374.320000]  r7:c0011874 r6:c01ce4b0 r5:c01ce4b0 r4:c3c96be8
> [42949374.320000] [<c00e486c>] (driver_attach+0x0/0x28) from [<c00e4568>]
> (bus_add_driver+0xa8/0x1dc)
> [42949374.320000] [<c00e44c0>] (bus_add_driver+0x0/0x1dc) from [<c00e4d34>]
> (driver_register+0x54/0x130)
> [42949374.320000] [<c00e4ce0>] (driver_register+0x0/0x130) from [<c00e59c4>]
> (platform_driver_register+0x6c/0x88)
> [42949374.320000]  r8:c3c0c000 r7:c0011874 r6:00000000 r5:00000000 r4:c0016404
> [42949374.320000] [<c00e5958>] (platform_driver_register+0x0/0x88) from
> [<c0011888>] (imx_camera_init+0x14/0x1c)
> [42949374.320000] [<c0011874>] (imx_camera_init+0x0/0x1c) from [<c00087ac>]
> (kernel_init+0x78/0x290)
> [42949374.320000] [<c0008734>] (kernel_init+0x0/0x290) from [<c0030dfc>]
> (do_exit+0x0/0x614)
> [42949374.320000] Code: eb030471 e59f2064 e1a03004 e5920000 (e5941020)
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index a1b9244..d015bfe 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -763,15 +763,6 @@ static struct device_driver ic_drv = {
 	.owner	= THIS_MODULE,
 };
 
-/*
- * Image capture host - this is a host device, not a bus device, so,
- * no bus reference, no probing.
- */
-static struct class soc_camera_host_class = {
-	.owner		= THIS_MODULE,
-	.name		= "camera_host",
-};
-
 static void dummy_release(struct device *dev)
 {
 }
@@ -801,7 +792,6 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 
 	/* Number might be equal to the platform device ID */
 	sprintf(ici->dev.bus_id, "camera_host%d", ici->nr);
-	ici->dev.class = &soc_camera_host_class;
 
 	mutex_lock(&list_lock);
 	list_for_each_entry(ix, &hosts, list) {
@@ -1003,14 +993,9 @@ static int __init soc_camera_init(void)
 	ret = driver_register(&ic_drv);
 	if (ret)
 		goto edrvr;
-	ret = class_register(&soc_camera_host_class);
-	if (ret)
-		goto eclr;
 
 	return 0;
 
-eclr:
-	driver_unregister(&ic_drv);
 edrvr:
 	bus_unregister(&soc_camera_bus_type);
 	return ret;
@@ -1018,7 +1003,6 @@ edrvr:
 
 static void __exit soc_camera_exit(void)
 {
-	class_unregister(&soc_camera_host_class);
 	driver_unregister(&ic_drv);
 	bus_unregister(&soc_camera_bus_type);
 }

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
