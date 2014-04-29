Return-path: <linux-media-owner@vger.kernel.org>
Received: from beta.phas.ubc.ca ([142.103.236.75]:56622 "EHLO beta.phas.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934077AbaD2Tz5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Apr 2014 15:55:57 -0400
Received: from spider.phas.ubc.ca (spider.phas.ubc.ca [142.103.235.177])
	(authenticated bits=0)
	by beta.phas.ubc.ca (8.13.1/8.13.1) with ESMTP id s3TJorou029799
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 29 Apr 2014 12:50:53 -0700
Date: Tue, 29 Apr 2014 12:50:52 -0700 (PDT)
From: Carl Michal <michal@physics.ubc.ca>
To: linux-media@vger.kernel.org
Subject: au0828 (950Q)  kernel OOPS 3.10.30 imx6
Message-ID: <alpine.LNX.2.00.1404291241000.26512@spider.phas.ubc.ca>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1737404907-1693507706-1398801053=:26512"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1737404907-1693507706-1398801053=:26512
Content-Type: TEXT/PLAIN; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hello,

I'm trying to use a Hauppage HVR-950Q ATSC tv stick with a Cubox-i running 
geexbox.

It works great, until it doesn't. After its been up and running for a few 
hours (sometimes minutes), I start to get kernel OOPs, example pasted in 
below. The 950Q generally doesn't work afterwards.

This is a 3.10.30 kernel, that I believe the Cubox is somewhat tied to for 
other driver reasons.

I haven't seen any such problems if the HVR-950Q is unplugged.

Any advice on tracking this down would be appreciated.

Carl


————[ cut here ]————
WARNING: at mm/vmalloc.c:126 vmap_page_range_noflush+0×178/0x1c4()
Modules linked in: au8522_dig tuner au8522_decoder au8522_common 
mxc_v4l2_capture au0828 ipu_bg_overlay_sdc snd_usb_audio ipu_still 
ipu_prp_enc snd_usbmidi_lib ipu_csi_enc tveeprom snd_rawmidi 
ipu_fg_overlay_sdc videobuf_vmalloc snd_hwdep brcmutil ir_lirc_codec 
lirc_dev ir_rc5_sz_decoder ir_sanyo_decoder ir_mce_kbd_decoder 
ir_sony_decoder ir_nec_decoder ir_jvc_decoder ir_rc6_decoder 
ir_rc5_decoder uinput
CPU: 0 PID: 700 Comm: xbmc.bin Not tainted 3.10.30 #1
[<8001444c>] (unwind_backtrace) from [<800114ac>] (show_stack+0×10/0×14)
[<800114ac>] (show_stack) from [<80025fd0>]  (warn_slowpath_common+0x4c/0x6c)
[<80025fd0>] (warn_slowpath_common) from [<8002600c>] (warn_slowpath_null+0x1c/0×24)
[<8002600c>] (warn_slowpath_null) from [<800af188>] (vmap_page_range_noflush+0×178/0x1c4)
[<800af188>] (vmap_page_range_noflush) from [<800b0228>] (map_vm_area+0x2c/0x7c)
[<800b0228>] (map_vm_area) from [<800b0dd0>] (__vmalloc_node_range+0xfc/0x1dc)
[<800b0dd0>] (__vmalloc_node_range) from [<800b0eec>] (__vmalloc_node+0x3c/0×44)
[<800b0eec>] (__vmalloc_node) from [<800b0f24>] (vmalloc+0×30/0×38)
[<800b0f24>] (vmalloc) from [<80438778>] (gckOS_AllocateMemory+0×40/0×54)
[<80438778>] (gckOS_AllocateMemory) from [<804387c0>] (gckOS_Allocate+0×34/0×44)
[<804387c0>] (gckOS_Allocate) from [<8043d694>] (gckKERNEL_AllocateIntegerId+0xe4/0×160)
[<8043d694>] (gckKERNEL_AllocateIntegerId) from [<8043d82c>] (gckKERNEL_AllocateNameFromPointer+0×18/0x2c)
[<8043d82c>] (gckKERNEL_AllocateNameFromPointer) from [<8043e510>] (gckKERNEL_Dispatch+0xc84/0x12ac)
[<8043e510>] (gckKERNEL_Dispatch) from [<8043753c>] (drv_ioctl+0×118/0×234)
[<8043753c>] (drv_ioctl) from [<800cd33c>] (do_vfs_ioctl+0×80/0x5a0)
[<800cd33c>] (do_vfs_ioctl) from [<800cd894>] (SyS_ioctl+0×38/0×60)
[<800cd894>] (SyS_ioctl) from [<8000e080>] (ret_fast_syscall+0×0/0×30)
—[ end trace 318ff254bf545f80 ]—
vmalloc: allocation failure, allocated 479232 of 483328 bytes
xbmc.bin: page allocation failure: order:0, mode:0xd2
CPU: 0 PID: 700 Comm: xbmc.bin Tainted: G W 3.10.30 #1
[<8001444c>] (unwind_backtrace) from [<800114ac>] (show_stack+0×10/0×14)
[<800114ac>] (show_stack) from [<8008be94>] (warn_alloc_failed+0xd0/0×110)
[<8008be94>] (warn_alloc_failed) from [<800b0e70>] (__vmalloc_node_range+0x19c/0x1dc)
[<800b0e70>] (__vmalloc_node_range) from [<800b0eec>] (__vmalloc_node+0x3c/0×44)
[<800b0eec>] (__vmalloc_node) from [<800b0f24>] (vmalloc+0×30/0×38)
[<800b0f24>] (vmalloc) from [<80438778>] (gckOS_AllocateMemory+0×40/0×54)
[<80438778>] (gckOS_AllocateMemory) from [<804387c0>] (gckOS_Allocate+0×34/0×44)
[<804387c0>] (gckOS_Allocate) from [<8043d694>] (gckKERNEL_AllocateIntegerId+0xe4/0×160)
[<8043d694>] (gckKERNEL_AllocateIntegerId) from [<8043d82c>] (gckKERNEL_AllocateNameFromPointer+0×18/0x2c)
[<8043d82c>] (gckKERNEL_AllocateNameFromPointer) from [<8043e510>] (gckKERNEL_Dispatch+0xc84/0x12ac)
[<8043e510>] (gckKERNEL_Dispatch) from [<8043753c>] (drv_ioctl+0×118/0×234)
[<8043753c>] (drv_ioctl) from [<800cd33c>] (do_vfs_ioctl+0×80/0x5a0)
[<800cd33c>] (do_vfs_ioctl) from [<800cd894>] (SyS_ioctl+0×38/0×60)
[<800cd894>] (SyS_ioctl) from [<8000e080>] (ret_fast_syscall+0×0/0×30)
Mem-info:
DMA per-cpu:
CPU 0: hi: 186, btch: 31 usd: 71
CPU 1: hi: 186, btch: 31 usd: 51
CPU 2: hi: 186, btch: 31 usd: 161
CPU 3: hi: 186, btch: 31 usd: 30
active_anon:32634 inactive_anon:458 isolated_anon:0
active_file:75360 inactive_file:275422 isolated_file:0
unevictable:33 dirty:2011 writeback:0 unstable:0
free:9091 slab_reclaimable:7864 slab_unreclaimable:6195
mapped:7616 shmem:635 pagetables:496 bounce:0
free_cma:7336
DMA free:36364kB min:4960kB low:6200kB high:7440kB active_anon:130536kB 
inactive_anon:1832kB active_file:301440kB inactive_file:1101688kB 
unevictable:132kB isolated(anon):0kB isolated(file):0kB present:1826816kB 
managed:1539272kB mlocked:132kB dirty:8044kB writeback:0kB mapped:30464kB 
shmem:2540kB slab_reclaimable:31456kB slab_unreclaimable:24780kB 
kernel_stack:1208kB pagetables:1984kB unstable:0kB bounce:0kB 
free_cma:29344kB writeback_tmp:0kB pages_scanned:3 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 1704*4kB (EMRC) 1160*8kB (UEMRC) 947*16kB (UMRC) 15*32kB (MR) 1*64kB 
(R) 1*128kB (R) 4*256kB (R) 5*512kB (R) 1*1024kB (R) 0*2048kB 0*4096kB 
0*8192kB 0*16384kB 0*32768kB = 36528kB
351490 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap = 0kB
Total swap = 0kB
456704 pages of RAM
9697 free pages
6289 reserved pages
11851 slab pages
780535 pages shared
0 pages swap cached

tvheadend: page allocation failure: order:4, mode:0x10c0d0
CPU: 1 PID: 687 Comm: tvheadend Tainted: G W 3.10.30 #1
[<8001444c>] (unwind_backtrace) from [<800114ac>] (show_stack+0×10/0×14)
[<800114ac>] (show_stack) from [<8008be94>] (warn_alloc_failed+0xd0/0×110)
[<8008be94>] (warn_alloc_failed) from [<8008eb18>] (__alloc_pages_nodemask+0x5a4/0x8b4)
[<8008eb18>] (__alloc_pages_nodemask) from [<8008ee38>] (__get_free_pages+0×10/0x4c)
[<8008ee38>] (__get_free_pages) from [<7f140430>] (urb_completion+0×164/0×280 [au0828])
[<7f140430>] (urb_completion [au0828]) from [<7f140604>] (au0828_dvb_start_feed+0xb8/0xe4 [au0828])
[<7f140604>] (au0828_dvb_start_feed [au0828]) from [<803fa4f0>] (dmx_section_feed_start_filtering+0xc8/0x16c)
[<803fa4f0>] (dmx_section_feed_start_filtering) from [<803f8c44>] (dvb_dmxdev_filter_start+0×228/0x3e0)
[<803f8c44>] (dvb_dmxdev_filter_start) from [<803f91a8>] (dvb_demux_do_ioctl+0x3ac/0×618)
[<803f91a8>] (dvb_demux_do_ioctl) from [<803f7528>] (dvb_usercopy+0×38/0×158)
[<803f7528>] (dvb_usercopy) from [<800cd33c>] (do_vfs_ioctl+0×80/0x5a0)
[<800cd33c>] (do_vfs_ioctl) from [<800cd894>] (SyS_ioctl+0×38/0×60)
[<800cd894>] (SyS_ioctl) from [<8000e080>] (ret_fast_syscall+0×0/0×30)
--1737404907-1693507706-1398801053=:26512--
