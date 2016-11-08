Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35170 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751389AbcKHNzO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:14 -0500
Date: Tue, 8 Nov 2016 15:54:38 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 00/21] Make use of kref in media device, grab references as
 needed
Message-ID: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This is the third version of the RFC set to fix referencing in media
devices.

The lifetime of the media device (and media devnode) is now bound to that
of struct device embedded in it and its memory is only released once the
last reference is gone: unregistering is simply unregistering, it no
longer should release memory which could be further accessed.
                                                                                
A video node or a sub-device node also gets a reference to the media
device, i.e. the release function of the video device node will release
its reference to the media device. The same goes for file handles to the
media device.
                                                                                
As a side effect of this is that the media device, it is allocate together
with the media devnode. The driver may also rely its own resources to the
media device. Alternatively there's also a priv field to hold drivers
private pointer (for container_of() is an option in this case). We could
drop one of these options but currently both are possible.
                                                                                
I've tested this by manually unbinding the omap3isp platform device while
streaming. Driver changes are required for this to work; by not using
dynamic allocation (i.e. media_device_alloc()) the old behaviour is still
supported. This is still unlikely to be a grave problem as there are not
that many device drivers that support physically removable devices. We've
had this problem for other devices for many years without paying much
notice --- that doesn't mean I don't think at least drivers for removable
devices shouldn't be changed as part of the set later on, I'd just like to
get review comments on the approach first.
                                                                                
The three patches that originally partially resolved some of these issues
are reverted in the beginning of the set. I'm still posting this as an RFC
mainly since the testing is somewhat limited so far.

A sample of what happens if streaming is stopped while the device is being
removed during streaming without this set:

-----------------8<----------------------
[  288.911560] omap3isp 480bc000.isp: media_gobj_destroy id 98: interface link id 97 ==> id 8
[  288.920349] omap3isp 480bc000.isp: media_gobj_destroy id 52: data link id 10 ==> id 12
[  288.928741] omap3isp 480bc000.isp: media_gobj_destroy id 51: data link id 10 ==> id 12
[  288.937103] omap3isp 480bc000.isp: media_gobj_destroy id 66: data link id 10 ==> id 16
[  288.945465] omap3isp 480bc000.isp: media_gobj_destroy id 65: data link id 10 ==> id 16
[  288.953796] omap3isp 480bc000.isp: media_gobj_destroy id 9: sink pad 'OMAP3 ISP CSI2a':0
[  288.962341] omap3isp 480bc000.isp: media_gobj_destroy id 10: source pad 'OMAP3 ISP CSI2a':1
[  288.971160] omap3isp 480bc000.isp: media_gobj_destroy id 8: entity 'OMAP3 ISP CSI2a'
[  289.117187] omap3isp 480bc000.isp: media_gobj_destroy id 97: intf_devnode v4l-subdev - major: 81, minor: 8
[  289.159820] omap3isp 480bc000.isp: media_gobj_destroy id 96: interface link id 95 ==> id 1
[  289.168640] omap3isp 480bc000.isp: media_gobj_destroy id 53: data link id 5 ==> id 2
[  289.176849] omap3isp 480bc000.isp: media_gobj_destroy id 54: data link id 5 ==> id 2
[  289.185058] omap3isp 480bc000.isp: media_gobj_destroy id 68: data link id 3 ==> id 16
[  289.193298] omap3isp 480bc000.isp: media_gobj_destroy id 67: data link id 3 ==> id 16
[  289.201568] omap3isp 480bc000.isp: media_gobj_destroy id 2: sink pad 'OMAP3 ISP CCP2':0
[  289.210021] omap3isp 480bc000.isp: media_gobj_destroy id 3: source pad 'OMAP3 ISP CCP2':1
[  289.218658] omap3isp 480bc000.isp: media_gobj_destroy id 1: entity 'OMAP3 ISP CCP2'
[  289.402587] omap3isp 480bc000.isp: media_gobj_destroy id 95: intf_devnode v4l-subdev - major: 81, minor: 7
[  289.448974] omap3isp 480bc000.isp: media_gobj_destroy id 7: interface link id 6 ==> id 4
[  289.457641] omap3isp 480bc000.isp: media_gobj_destroy id 6: intf_devnode v4l-video - major: 81, minor: 0
[  289.467773] omap3isp 480bc000.isp: media_gobj_destroy id 5: source pad 'OMAP3 ISP CCP2 input':0
[  289.476959] omap3isp 480bc000.isp: media_gobj_destroy id 4: entity 'OMAP3 ISP CCP2 input'
[  289.485595] omap3isp 480bc000.isp: media_gobj_destroy id 100: interface link id 99 ==> id 15
[  289.494537] omap3isp 480bc000.isp: media_gobj_destroy id 56: data link id 17 ==> id 20
[  289.502868] omap3isp 480bc000.isp: media_gobj_destroy id 55: data link id 17 ==> id 20
[  289.511230] omap3isp 480bc000.isp: media_gobj_destroy id 70: data link id 18 ==> id 24
[  289.519592] omap3isp 480bc000.isp: media_gobj_destroy id 69: data link id 18 ==> id 24
[  289.527954] omap3isp 480bc000.isp: media_gobj_destroy id 72: data link id 17 ==> id 35
[  289.536315] omap3isp 480bc000.isp: media_gobj_destroy id 71: data link id 17 ==> id 35
[  289.544738] omap3isp 480bc000.isp: media_gobj_destroy id 76: data link id 18 ==> id 46
[  289.553070] omap3isp 480bc000.isp: media_gobj_destroy id 75: data link id 18 ==> id 46
[  289.561462] omap3isp 480bc000.isp: media_gobj_destroy id 78: data link id 18 ==> id 48
[  289.569824] omap3isp 480bc000.isp: media_gobj_destroy id 77: data link id 18 ==> id 48
[  289.578186] omap3isp 480bc000.isp: media_gobj_destroy id 80: data link id 18 ==> id 50
[  289.586578] omap3isp 480bc000.isp: media_gobj_destroy id 79: data link id 18 ==> id 50
[  289.594940] omap3isp 480bc000.isp: media_gobj_destroy id 16: sink pad 'OMAP3 ISP CCDC':0
[  289.603454] omap3isp 480bc000.isp: media_gobj_destroy id 17: source pad 'OMAP3 ISP CCDC':1
[  289.612182] omap3isp 480bc000.isp: media_gobj_destroy id 18: source pad 'OMAP3 ISP CCDC':2
[  289.620910] omap3isp 480bc000.isp: media_gobj_destroy id 15: entity 'OMAP3 ISP CCDC'
[  289.979309] omap3isp 480bc000.isp: media_gobj_destroy id 99: intf_devnode v4l-subdev - major: 81, minor: 9
[  290.023925] omap3isp 480bc000.isp: media_gobj_destroy id 22: interface link id 21 ==> id 19
[  290.032867] omap3isp 480bc000.isp: media_gobj_destroy id 21: intf_devnode v4l-video - major: 81, minor: 2
[  290.042968] omap3isp 480bc000.isp: media_gobj_destroy id 20: sink pad 'OMAP3 ISP CCDC output':0
[  290.052154] omap3isp 480bc000.isp: media_gobj_destroy id 19: entity 'OMAP3 ISP CCDC output'
[  290.061004] omap3isp 480bc000.isp: media_gobj_destroy id 102: interface link id 101 ==> id 23
[  290.070007] omap3isp 480bc000.isp: media_gobj_destroy id 57: data link id 27 ==> id 24
[  290.078399] omap3isp 480bc000.isp: media_gobj_destroy id 58: data link id 27 ==> id 24
[  290.086761] omap3isp 480bc000.isp: media_gobj_destroy id 60: data link id 25 ==> id 31
[  290.095123] omap3isp 480bc000.isp: media_gobj_destroy id 59: data link id 25 ==> id 31
[  290.103454] omap3isp 480bc000.isp: media_gobj_destroy id 74: data link id 25 ==> id 35
[  290.111816] omap3isp 480bc000.isp: media_gobj_destroy id 73: data link id 25 ==> id 35
[  290.120208] omap3isp 480bc000.isp: media_gobj_destroy id 24: sink pad 'OMAP3 ISP preview':0
[  290.128997] omap3isp 480bc000.isp: media_gobj_destroy id 25: source pad 'OMAP3 ISP preview':1
[  290.138000] omap3isp 480bc000.isp: media_gobj_destroy id 23: entity 'OMAP3 ISP preview'
[  290.394989] omap3isp 480bc000.isp: media_gobj_destroy id 101: intf_devnode v4l-subdev - major: 81, minor: 10
[  290.440246] omap3isp 480bc000.isp: media_gobj_destroy id 29: interface link id 28 ==> id 26
[  290.449157] omap3isp 480bc000.isp: media_gobj_destroy id 28: intf_devnode v4l-video - major: 81, minor: 3
[  290.459320] omap3isp 480bc000.isp: media_gobj_destroy id 27: source pad 'OMAP3 ISP preview input':0
[  290.468841] omap3isp 480bc000.isp: media_gobj_destroy id 26: entity 'OMAP3 ISP preview input'
[  290.571075] omap3isp 480bc000.isp: media_gobj_destroy id 33: interface link id 32 ==> id 30
[  290.580017] omap3isp 480bc000.isp: media_gobj_destroy id 32: intf_devnode v4l-video - major: 81, minor: 4
[  290.590148] omap3isp 480bc000.isp: media_gobj_destroy id 31: sink pad 'OMAP3 ISP preview output':0
[  290.599578] omap3isp 480bc000.isp: media_gobj_destroy id 30: entity 'OMAP3 ISP preview output'
[  290.608703] omap3isp 480bc000.isp: media_gobj_destroy id 104: interface link id 103 ==> id 34
[  290.617706] omap3isp 480bc000.isp: media_gobj_destroy id 61: data link id 38 ==> id 35
[  290.626068] omap3isp 480bc000.isp: media_gobj_destroy id 62: data link id 38 ==> id 35
[  290.634460] omap3isp 480bc000.isp: media_gobj_destroy id 64: data link id 36 ==> id 42
[  290.642791] omap3isp 480bc000.isp: media_gobj_destroy id 63: data link id 36 ==> id 42
[  290.651153] omap3isp 480bc000.isp: media_gobj_destroy id 35: sink pad 'OMAP3 ISP resizer':0
[  290.659973] omap3isp 480bc000.isp: media_gobj_destroy id 36: source pad 'OMAP3 ISP resizer':1
[  290.668945] omap3isp 480bc000.isp: media_gobj_destroy id 34: entity 'OMAP3 ISP resizer'
[  290.907714] omap3isp 480bc000.isp: media_gobj_destroy id 103: intf_devnode v4l-subdev - major: 81, minor: 11
[  290.952911] omap3isp 480bc000.isp: media_gobj_destroy id 40: interface link id 39 ==> id 37
[  290.961883] omap3isp 480bc000.isp: media_gobj_destroy id 39: intf_devnode v4l-video - major: 81, minor: 5
[  290.972015] omap3isp 480bc000.isp: media_gobj_destroy id 38: source pad 'OMAP3 ISP resizer input':0
[  290.981567] omap3isp 480bc000.isp: media_gobj_destroy id 37: entity 'OMAP3 ISP resizer input'
[  291.085205] omap3isp 480bc000.isp: media_gobj_destroy id 44: interface link id 43 ==> id 41
[  291.094024] omap3isp 480bc000.isp: media_gobj_destroy id 43: intf_devnode v4l-video - major: 81, minor: 6
[  291.104187] omap3isp 480bc000.isp: media_gobj_destroy id 42: sink pad 'OMAP3 ISP resizer output':0
[  291.113616] omap3isp 480bc000.isp: media_gobj_destroy id 41: entity 'OMAP3 ISP resizer output'
[  291.122711] omap3isp 480bc000.isp: media_gobj_destroy id 106: interface link id 105 ==> id 45
[  291.131805] omap3isp 480bc000.isp: media_gobj_destroy id 46: sink pad 'OMAP3 ISP AEWB':0
[  291.140350] omap3isp 480bc000.isp: media_gobj_destroy id 45: entity 'OMAP3 ISP AEWB'
[  291.311187] omap3isp 480bc000.isp: media_gobj_destroy id 105: intf_devnode v4l-subdev - major: 81, minor: 12
[  291.321655] omap3isp 480bc000.isp: media_gobj_destroy id 108: interface link id 107 ==> id 47
[  291.330688] omap3isp 480bc000.isp: media_gobj_destroy id 48: sink pad 'OMAP3 ISP AF':0
[  291.339050] omap3isp 480bc000.isp: media_gobj_destroy id 47: entity 'OMAP3 ISP AF'
[  291.423278] omap3isp 480bc000.isp: media_gobj_destroy id 107: intf_devnode v4l-subdev - major: 81, minor: 13
[  291.433746] omap3isp 480bc000.isp: media_gobj_destroy id 110: interface link id 109 ==> id 49
[  291.442779] omap3isp 480bc000.isp: media_gobj_destroy id 50: sink pad 'OMAP3 ISP histogram':0
[  291.451782] omap3isp 480bc000.isp: media_gobj_destroy id 49: entity 'OMAP3 ISP histogram'
[  291.560607] omap3isp 480bc000.isp: media_gobj_destroy id 109: intf_devnode v4l-subdev - major: 81, minor: 14
[  291.571197] omap3isp 480bc000.isp: media_gobj_destroy id 14: interface link id 13 ==> id 11
[  291.580047] omap3isp 480bc000.isp: media_gobj_destroy id 12: sink pad 'OMAP3 ISP CSI2a output':0
[  291.589324] omap3isp 480bc000.isp: media_gobj_destroy id 11: entity 'OMAP3 ISP CSI2a output'
[  291.598236] omap3isp 480bc000.isp: media_gobj_destroy id 13: intf_devnode v4l-video - major: 81, minor: 1
[  291.608306] omap3isp 480bc000.isp: Media device unregistered
[  291.742919] omap3isp 480bc000.isp: Media device released
[  291.748687] media: media_devnode_release: Media Devnode Deallocated
[  291.755432] omap3isp 480bc000.isp: OMAP3 ISP AEWB: all buffers were freed.
[  291.762756] omap3isp 480bc000.isp: OMAP3 ISP AF: all buffers were freed.
[  291.769897] omap3isp 480bc000.isp: OMAP3 ISP histogram: all buffers were freed.
[  291.863433] clk_unregister: unregistering prepared clock: cam_xclka
[  291.880340] iommu: Removing device 480bc000.isp from group 0
[  294.156921] Unable to handle kernel paging request at virtual address 6b6b6b7b
[  294.164703] pgd = ed9f8000
[  294.167572] [6b6b6b7b] *pgd=00000000
[  294.171386] Internal error: Oops: 5 [#1] ARM
[  294.175933] Modules linked in: smiapp smiapp_pll omap3_isp videobuf2_dma_contig videobuf2_memops videobuf2_v4l2 videobuf2_core v4l2_common videodev media
[  294.190582] CPU: 0 PID: 2264 Comm: yavta Not tainted 4.9.0-rc1-00219-gbd676c0-dirty #734
[  294.199157] Hardware name: Generic OMAP36xx (Flattened Device Tree)
[  294.205810] task: ed820d40 task.stack: ed8bc000
[  294.210845] PC is at v4l2_ioctl+0x2c/0xac [videodev]
[  294.216125] LR is at vfs_ioctl+0x18/0x30
[  294.220306] pc : [<bf00f508>]    lr : [<c01e2684>]    psr: a0000013
               sp : ed8bdef0  ip : 0000545e  fp : be980d94
[  294.232452] r10: 00000000  r9 : ed8bc000  r8 : c044560f
[  294.237976] r7 : be980d94  r6 : ed97a8a8  r5 : ed90d040  r4 : be980d94
[  294.244873] r3 : 6b6b6b6b  r2 : bf027d00  r1 : c044560f  r0 : ed90d040
[  294.251800] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  294.259338] Control: 10c5387d  Table: ad9f8019  DAC: 00000051
[  294.265441] Process yavta (pid: 2264, stack limit = 0xed8bc208)
[  294.271697] Stack: (0xed8bdef0 to 0xed8be000)
[  294.276336] dee0:                                     be980d94 ed90d040 00000003 c044560f
[  294.285003] df00: 00000003 c01e2684 be980d94 c01e31dc 00000000 00000000 c01f3484 ee367418
[  294.293670] df20: 00000008 ffffffff ffffffff ed88c580 ee369ae0 ee367418 00000008 c01d30f4
[  294.302368] df40: 00000000 00000000 00000000 ed88c678 ee858750 ed821150 ed820d40 00000000
[  294.311035] df60: ed8bdf7c ed8bdf84 ed90d040 ed90d040 be980d94 c044560f 00000003 ed8bc000
[  294.319732] df80: 00000000 c01e3294 00000001 be981368 be98136c 00000036 c0107bc4 ed8bc000
[  294.328399] dfa0: 00000000 c0107a20 00000001 be981368 00000003 c044560f be980d94 00000001
[  294.337066] dfc0: 00000001 be981368 be98136c 00000036 00000000 00000000 00000000 be980d94
[  294.345733] dfe0: 0001716c be980bac 00009a70 b6eaaa5c 60000010 00000003 00000000 00000000
[  294.354553] [<bf00f508>] (v4l2_ioctl [videodev]) from [<c01e2684>] (vfs_ioctl+0x18/0x30)
[  294.363159] [<c01e2684>] (vfs_ioctl) from [<c01e31dc>] (do_vfs_ioctl+0x8c0/0x928)
[  294.371093] [<c01e31dc>] (do_vfs_ioctl) from [<c01e3294>] (SyS_ioctl+0x50/0x6c)
[  294.378845] [<c01e3294>] (SyS_ioctl) from [<c0107a20>] (ret_fast_syscall+0x0/0x1c)
[  294.386901] Code: e3c334ff e3c3360f e7926103 e59630e4 (e5933010) 
[  294.393432] ---[ end trace c1adb47143f9f62b ]---
[  294.499237] Unable to handle kernel paging request at virtual address 6b6b6b8b
[  294.507324] pgd = c0004000
[  294.510223] [6b6b6b8b] *pgd=00000000
[  294.514038] Internal error: Oops: 5 [#2] ARM
[  294.518554] Modules linked in: smiapp smiapp_pll omap3_isp videobuf2_dma_contig videobuf2_memops videobuf2_v4l2 videobuf2_core v4l2_common videodev media
[  294.533203] CPU: 0 PID: 2264 Comm: yavta Tainted: G      D         4.9.0-rc1-00219-gbd676c0-dirty #734
[  294.543060] Hardware name: Generic OMAP36xx (Flattened Device Tree)
[  294.549713] task: ed820d40 task.stack: ed8bc000
[  294.554748] PC is at v4l2_release+0x20/0x70 [videodev]
[  294.560211] LR is at __fput+0xe0/0x1b8
[  294.564178] pc : [<bf00f3b4>]    lr : [<c01d302c>]    psr: a0000013
               sp : ed8bdc50  ip : ed8bc000  fp : ee84f110
[  294.576324] r10: ed85f130  r9 : 00000000  r8 : ed90d048
[  294.581878] r7 : 00000008  r6 : ee342c78  r5 : ed85f130  r4 : ed97a8a8
[  294.588775] r3 : 6b6b6b6b  r2 : bf027d00  r1 : ed90d040  r0 : ed85f130
[  294.595703] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  294.603240] Control: 10c5387d  Table: ad984019  DAC: 00000051
[  294.609344] Process yavta (pid: 2264, stack limit = 0xed8bc208)
[  294.615600] Stack: (0xed8bdc50 to 0xed8be000)
[  294.620239] dc40:                                     ed90d040 ed85f130 ee342c78 c01d302c
[  294.628906] dc60: 00000000 00000000 00000001 ed90d138 00000000 ed821150 ed820d40 ed90d2c0
[  294.637573] dc80: ed8bdc9c ed8bdca4 00000000 c061262c 00000008 c0145a60 ed821160 00000001
[  294.646240] dca0: 00000001 ed90d040 ed820d40 ed821160 ed8a0480 00000001 ed8a04d4 c012d41c
[  294.654937] dcc0: 00000008 60000113 00000000 00000002 c082f0e4 c0ff2b90 0000230e 00000015
[  294.663604] dce0: 00000000 00000000 00000000 00000001 00000001 00000000 c0165274 ed8bdd1c
[  294.672302] dd00: 43f9f62b c082f0e4 c061d27a 0000000b c0806b78 00000001 00000000 bf00f50c
[  294.680969] dd20: 00000000 c061262c 00000008 c010b7a0 ed8bc208 0000000b bf000000 60000113
[  294.689636] dd40: 00000000 00000000 66663433 63336520 30363333 37652066 31363239 65203330
[  294.698303] dd60: 33363935 20346530 39356528 31303333 00202930 c016711c c061355a ed8bdd9c
[  294.707000] dd80: ed8bdd8c 6b6b6b7b ed8bdea0 00000000 00000005 ed8a0480 ed8a04d4 ed8a0480
[  294.715667] dda0: 00010000 c0111580 ed8bdea0 6b6b6b7b ed820d40 00000014 00000005 c01117f8
[  294.724334] ddc0: 00000000 c085e8dc c0834a78 00000000 00000007 00000000 eeb7f9c0 00000005
[  294.733001] dde0: 6b6b6b7b c0806e1c ed8bdea0 c044560f ed8bc000 00000000 be980d94 c010136c
[  294.741668] de00: 0000007c 00000000 00000001 c015db90 ed820d40 ed821218 00000001 00000000
[  294.750366] de20: 0000021b 00000000 00000001 c015db90 0000007c 00000000 bfc3755a 748d35fb
[  294.759033] de40: c0c5b8ac 00000001 582cb09f 89c973bb ed820d40 ed8211f8 00000000 00000000
[  294.767700] de60: 00000050 00000000 00000000 c015db90 ee36748c 00000001 1db89764 17cc08f3
[  294.776397] de80: ed821218 eeb1c390 ed820d60 bf00f508 a0000013 ffffffff ed8bded4 c010bcbc
[  294.785064] dea0: ed90d040 c044560f bf027d00 6b6b6b6b be980d94 ed90d040 ed97a8a8 be980d94
[  294.793731] dec0: c044560f ed8bc000 00000000 be980d94 0000545e ed8bdef0 c01e2684 bf00f508
[  294.802398] dee0: a0000013 ffffffff 00000051 bf000000 be980d94 ed90d040 00000003 c044560f
[  294.811096] df00: 00000003 c01e2684 be980d94 c01e31dc 00000000 00000000 c01f3484 ee367418
[  294.819763] df20: 00000008 ffffffff ffffffff ed88c580 ee369ae0 ee367418 00000008 c01d30f4
[  294.828430] df40: 00000000 00000000 00000000 ed88c678 ee858750 ed821150 ed820d40 00000000
[  294.837127] df60: ed8bdf7c ed8bdf84 ed90d040 ed90d040 be980d94 c044560f 00000003 ed8bc000
[  294.845794] df80: 00000000 c01e3294 00000001 be981368 be98136c 00000036 c0107bc4 ed8bc000
[  294.854461] dfa0: 00000000 c0107a20 00000001 be981368 00000003 c044560f be980d94 00000001
[  294.863159] dfc0: 00000001 be981368 be98136c 00000036 00000000 00000000 00000000 be980d94
[  294.871826] dfe0: 0001716c be980bac 00009a70 b6eaaa5c 60000010 00000003 00000000 00000000
[  294.880645] [<bf00f3b4>] (v4l2_release [videodev]) from [<c01d302c>] (__fput+0xe0/0x1b8)
[  294.889251] [<c01d302c>] (__fput) from [<c0145a60>] (task_work_run+0xa4/0xbc)
[  294.896789] [<c0145a60>] (task_work_run) from [<c012d41c>] (do_exit+0x468/0x558)
[  294.904663] [<c012d41c>] (do_exit) from [<c010b7a0>] (die+0x38c/0x3e0)
[  294.911590] [<c010b7a0>] (die) from [<c0111580>] (__do_kernel_fault+0x64/0x84)
[  294.919281] [<c0111580>] (__do_kernel_fault) from [<c01117f8>] (do_page_fault+0x258/0x270)
[  294.928039] [<c01117f8>] (do_page_fault) from [<c010136c>] (do_DataAbort+0x34/0xb0)
[  294.936157] [<c010136c>] (do_DataAbort) from [<c010bcbc>] (__dabt_svc+0x5c/0xa0)
[  294.944000] Exception stack(0xed8bdea0 to 0xed8bdee8)
[  294.949371] dea0: ed90d040 c044560f bf027d00 6b6b6b6b be980d94 ed90d040 ed97a8a8 be980d94
[  294.958038] dec0: c044560f ed8bc000 00000000 be980d94 0000545e ed8bdef0 c01e2684 bf00f508
[  294.966735] dee0: a0000013 ffffffff
[  294.970550] [<c010bcbc>] (__dabt_svc) from [<bf00f508>] (v4l2_ioctl+0x2c/0xac [videodev])
[  294.979339] [<bf00f508>] (v4l2_ioctl [videodev]) from [<c01e2684>] (vfs_ioctl+0x18/0x30)
[  294.987915] [<c01e2684>] (vfs_ioctl) from [<c01e31dc>] (do_vfs_ioctl+0x8c0/0x928)
[  294.995880] [<c01e31dc>] (do_vfs_ioctl) from [<c01e3294>] (SyS_ioctl+0x50/0x6c)
[  295.003631] [<c01e3294>] (SyS_ioctl) from [<c0107a20>] (ret_fast_syscall+0x0/0x1c)
[  295.011657] Code: e3c334ff e3c3360f e7924103 e59430e4 (e5935020) 
[  295.018402] ---[ end trace c1adb47143f9f62c ]---
[  295.023284] Fixing recursive fault but reboot is needed!
-----------------8<----------------------

changes since v3:

- Rebased on top of current media-tree.git master.

changes since v2:

- Rework the set in order to make the changes more consistent, easier to
  understand and better ordered.

- Properly change referencing media_dev->dev (patch "media device: Get the
  media device driver's device" added).

- Only set the release() callback to media device if the new
  media_device_alloc() API is used. (The callback just printed a debug
  message before this series.)

- Call cdev_del() before removing the device (patch 7).

- Document media_device_init() and media_device_cleanup() as deprecated.

- Spelling fixes.

The to-do list includes changes to drivers that can be physically removed.
Drivers not using the new API can mostly ignore these changes, albeit
media_device_init() now grabs a reference to struct device of the media
device which must be released.

-- 
Kind regards,
Sakari
