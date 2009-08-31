Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:33759 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZHaQCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 12:02:33 -0400
Received: by fxm17 with SMTP id 17so2849881fxm.37
        for <linux-media@vger.kernel.org>; Mon, 31 Aug 2009 09:02:34 -0700 (PDT)
Message-ID: <4A9BF413.8050103@gmail.com>
Date: Mon, 31 Aug 2009 21:32:27 +0530
From: Sudipto Sarkar <xtremethegreat1@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Jean-Francois Moine <moinejf@free.fr>
Subject: HP VGA webcam details
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Moine,

I figured that you'd asked me to get the development version of the 
gspca v4l2 driver. I got it from your site, and compiled it.

When I plug in the cam, these are the kernel messages I get:


[ 1049.916023] usb 1-3: new high speed USB device using ehci_hcd and 
address 4
[ 1050.163204] usb 1-3: configuration #1 chosen from 1 choice
[ 1050.163900] gspca: probing 15b8:6002
[ 1050.164472] vc032x: check sensor header 20
[ 1050.261216] vc032x: Sensor ID 0209 (4)
[ 1050.261220] vc032x: Find Sensor HV7131R
[ 1050.262292] gspca: probe ok
[ 1050.262419] gspca: probing 15b8:6002
[ 1050.479000] gspca: hald-probe-vide open
[ 1050.479006] gspca: open done
[ 1050.482384] gspca: hald-probe-vide close
[ 1050.482389] gspca: close done

So, it seems that it is an HV7131R sensor. However, I get no image at 
all when I start svv. The window is just blank, and not even a black 
picture is obtained.

Then I do a echo 0x3f > /sys/module/gspca_main/parameters/debug, and get 
this:

root@k0r0pt:/home/xtreme/Desktop# ./svv
raw pixfmt: JPEG 640x480
pixfmt: RGB3 640x480
mmap method
VIDIOC_STREAMON error 12, Cannot allocate memory

These are the kernel messages generated:

[  788.048292] gspca: svv open
[  788.048296] gspca: open done
[  788.048381] gspca: try fmt cap JPEG 640x480
[  788.048385] gspca: try fmt cap JPEG 640x480
[  788.048468] gspca: frame alloc frsz: 115790
[  788.048560] gspca: reqbufs st:0 c:4
[  788.048574] gspca: mmap start:b7340000 size:118784
[  788.048586] gspca: mmap start:b7323000 size:118784
[  788.048596] gspca: mmap start:b7306000 size:118784
[  788.048605] gspca: mmap start:b72e9000 size:118784
[  788.048627] gspca: qbuf 0
[  788.048629] gspca: qbuf q:1 i:0 o:0
[  788.048631] gspca: qbuf 1
[  788.048633] gspca: qbuf q:2 i:0 o:0
[  788.048635] gspca: qbuf 2
[  788.048636] gspca: qbuf q:3 i:0 o:0
[  788.048638] gspca: qbuf 3
[  788.048640] gspca: qbuf q:0 i:0 o:0
[  788.048644] gspca: use alt 7 ep 0x82
[  788.051144] gspca: init transfer alt 7
[  788.051148] gspca: isoc 64 pkts size 3072 = bsize:196608
[  788.051340] svv: page allocation failure. order:6, mode:0x8000
[  788.051344] Pid: 8417, comm: svv Not tainted 2.6.28-15-generic #49-Ubuntu
[  788.051346] Call Trace:
[  788.051356]  [<c04fdfc6>] ? printk+0x18/0x1a
[  788.051361]  [<c0194507>] __alloc_pages_internal+0x387/0x490
[  788.051366]  [<c01087d3>] dma_generic_alloc_coherent+0x73/0xe0
[  788.051370]  [<c0108760>] ? dma_generic_alloc_coherent+0x0/0xe0
[  788.051376]  [<c03beb40>] hcd_buffer_alloc+0xc0/0x120
[  788.051380]  [<c03b257a>] usb_buffer_alloc+0x2a/0x30
[  788.051388]  [<e021f65a>] gspca_init_transfer+0x13a/0x460 [gspca_main]
[  788.051393]  [<e021fa66>] vidioc_streamon+0xa6/0xc0 [gspca_main]
[  788.051411]  [<e021f9c0>] ? vidioc_streamon+0x0/0xc0 [gspca_main]
[  788.051417]  [<e00f4921>] __video_do_ioctl+0x15a1/0x33b0 [videodev]
[  788.051422]  [<c0331f3b>] ? n_tty_receive_buf+0x43b/0x4b0
[  788.051426]  [<c01a20e9>] ? handle_mm_fault+0x119/0x380
[  788.051430]  [<c0502774>] ? do_page_fault+0x254/0x790
[  788.051433]  [<c01a1117>] ? insert_page+0xd7/0xe0
[  788.051437]  [<c02cde25>] ? copy_from_user+0x35/0x130
[  788.051442]  [<e00f680a>] video_ioctl2+0xda/0x550 [videodev]
[  788.051447]  [<c012a5b0>] ? __wake_up+0x40/0x50
[  788.051450]  [<c03338c5>] ? tty_ldisc_deref+0x55/0x70
[  788.051455]  [<e00f6730>] ? video_ioctl2+0x0/0x550 [videodev]
[  788.051459]  [<e00f21f6>] v4l2_unlocked_ioctl+0x36/0x50 [videodev]
[  788.051464]  [<e00f21c0>] ? v4l2_unlocked_ioctl+0x0/0x50 [videodev]
[  788.051468]  [<c01ca4b8>] vfs_ioctl+0x28/0x90
[  788.051472]  [<c01ca99e>] do_vfs_ioctl+0x5e/0x200
[  788.051476]  [<c032d670>] ? tty_write+0x0/0x210
[  788.051479]  [<c01caba3>] sys_ioctl+0x63/0x70
[  788.051482]  [<c0103f6b>] sysenter_do_call+0x12/0x2f
[  788.051484] Mem-Info:
[  788.051486] DMA per-cpu:
[  788.051489] CPU    0: hi:    0, btch:   1 usd:   0
[  788.051490] Normal per-cpu:
[  788.051492] CPU    0: hi:  186, btch:  31 usd:  76
[  788.051497] Active_anon:34095 active_file:11982 inactive_anon:34485
[  788.051498]  inactive_file:22233 unevictable:2 dirty:13 writeback:0 
unstable:0
[  788.051499]  free:4254 slab:6031 mapped:16596 pagetables:933 bounce:0
[  788.051504] DMA free:2032kB min:88kB low:108kB high:132kB 
active_anon:148kB inactive_anon:248kB active_file:712kB 
inactive_file:4200kB unevictable:0kB present:15764kB pages_scanned:0 
all_unreclaimable? no
[  788.051508] lowmem_reserve[]: 0 482 482 482
[  788.051514] Normal free:14984kB min:2764kB low:3452kB high:4144kB 
active_anon:136232kB inactive_anon:137692kB active_file:47216kB 
inactive_file:84732kB unevictable:8kB present:494220kB pages_scanned:0 
all_unreclaimable? no
[  788.051518] lowmem_reserve[]: 0 0 0 0
[  788.051522] DMA: 10*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 
1*512kB 1*1024kB 0*2048kB 0*4096kB = 2032kB
[  788.051531] Normal: 3442*4kB 20*8kB 6*16kB 0*32kB 1*64kB 1*128kB 
1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 14984kB
[  788.051540] 51877 total pagecache pages
[  788.051542] 1773 pages in swap cache
[  788.051544] Swap cache stats: add 5922, delete 4149, find 2774/2946
[  788.051546] Free swap  = 1981588kB
[  788.051548] Total swap = 2000084kB
[  788.054193] 128624 pages RAM
[  788.054195] 0 pages HighMem
[  788.054197] 3796 pages reserved
[  788.054198] 112772 pages shared
[  788.054200] 74655 pages non-shared
[  788.054204] gspca: usb_buffer_urb failed
[  788.054207] gspca: kill transfer
[  788.060089] gspca: svv close
[  788.060094] gspca: frame free
[  788.060142] gspca: close done
[ 1043.859358] usb 1-3: USB disconnect, address 3
[ 1043.860990] gspca: device released
[ 1043.860993] gspca: disconnect complete
[ 1049.916023] usb 1-3: new high speed USB device using ehci_hcd and 
address 4
[ 1050.163204] usb 1-3: configuration #1 chosen from 1 choice
[ 1050.163900] gspca: probing 15b8:6002
[ 1050.164472] vc032x: check sensor header 20
[ 1050.261216] vc032x: Sensor ID 0209 (4)
[ 1050.261220] vc032x: Find Sensor HV7131R
[ 1050.262292] gspca: probe ok
[ 1050.262419] gspca: probing 15b8:6002
[ 1050.479000] gspca: hald-probe-vide open
[ 1050.479006] gspca: open done
[ 1050.482384] gspca: hald-probe-vide close
[ 1050.482389] gspca: close done

Please however, guide me to make the driver.
:)

-Sudipto
