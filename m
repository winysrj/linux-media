Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38619 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932405Ab1LEPSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Dec 2011 10:18:11 -0500
References: <4EDC25F1.4000909@seiner.com> <1323058527.12343.3.camel@palomino.walls.org> <4EDC4C84.2030904@seiner.com> <4EDC4E9B.40301@seiner.com> <4EDCB6D1.1060508@seiner.com>
In-Reply-To: <4EDCB6D1.1060508@seiner.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: cx231xx kernel oops
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 05 Dec 2011 10:18:11 -0500
To: Yan Seiner <yan@seiner.com>, linux-media@vger.kernel.org
Message-ID: <1098bb19-5241-4be4-a916-657c0b599efd@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yan Seiner <yan@seiner.com> wrote:

>I'm still seeing a kernel oops on use.
>
>Module                  Size  Used by    Not tainted
>cx231xx               124608  0             
>cx2341x                13552  1 cx231xx
>cx25840                35568  1
>rc_core                12640  1 cx231xx
>videobuf_vmalloc        3168  1 cx231xx
>videobuf_core          12384  2 cx231xx,videobuf_vmalloc
>
>
>When the modules are loaded:
>
>cx231xx v4l2 driver loaded.
>cx231xx #0: New device Hauppauge Hauppauge Device @ 480 Mbps
>(2040:c200) 
>with 5 interfaces
>cx231xx #0: registering interface 1
>cx231xx #0: can't change interface 3 alt no. to 3: Max. Pkt size = 0
>cx231xx #0: can't change interface 4 alt no. to 1: Max. Pkt size = 0
>cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
>cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
>cx231xx #0: Changing the i2c master port to 3
>cx25840 0-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0)
>cx25840 0-0044:  Firmware download size changed to 16 bytes max length
>cx25840 0-0044: loaded v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
>cx231xx #0: cx231xx #0: v4l2 driver version 0.0.1
>cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
>cx231xx #0: video_mux : 0
>cx231xx #0: do_mode_ctrl_overrides : 0xb000
>cx231xx #0: do_mode_ctrl_overrides NTSC
>cx231xx #0: cx231xx #0/0: registered device video0 [v4l2]
>cx231xx #0: cx231xx #0/0: registered device vbi0
>cx231xx #0: V4L2 device registered as video0 and vbi0
>cx231xx #0: EndPoint Addr 0x84, Alternate settings: 5
>cx231xx #0: Alternate setting 0, max size= 512
>cx231xx #0: Alternate setting 1, max size= 184
>cx231xx #0: Alternate setting 2, max size= 728
>cx231xx #0: Alternate setting 3, max size= 2892
>cx231xx #0: Alternate setting 4, max size= 1800
>cx231xx #0: EndPoint Addr 0x85, Alternate settings: 2
>cx231xx #0: Alternate setting 0, max size= 512
>cx231xx #0: Alternate setting 1, max size= 512
>cx231xx #0: EndPoint Addr 0x86, Alternate settings: 2
>cx231xx #0: Alternate setting 0, max size= 512
>cx231xx #0: Alternate setting 1, max size= 576
>
>And when I try to use it:
>
>root@anchor:/# fswebcam -c /etc/fswebcam
>--- Opening /dev/video0...
>Trying source module v4l2...
>/dev/video0 opened.
>Adjusting resolution from 768x576 to 720x480.
>Delaying 1 seconds.
>--- Capturing frame...
>Skipping frame...
>Timed out waiting for frame!
>Capturing 1 frames...
>Timed out waiting for frame!
>No frames captured.
>
>dmesg shows:
>
>cx231xx #0:  setPowerMode::mode = 48, No Change req.
>cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
>cx231xx #0: video_mux : 0
>cx231xx #0: do_mode_ctrl_overrides : 0xb000
>cx231xx #0: do_mode_ctrl_overrides NTSC
>cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
>cx231xx #0: cx231xx_initialize_stream_xfer: set video registers
>cx231xx #0: cx231xx_start_stream():: ep_mask = 8
>ehci_hcd 0000:00:02.2: fatal error
>ehci_hcd 0000:00:02.2: HC died; cleaning up
>ehci_hcd 0000:00:02.2: force halt; handshake c0350024 00004000 00004000
>
>-> -145
>ehci_hcd 0000:00:02.2: HC died; cleaning up
>usb 1-1: USB disconnect, device number 3
>usb 1-1.1: USB disconnect, device number 4
>cx231xx #0: UsbInterface::sendCommand, failed with status --19
>cx231xx #0: UsbInterface::sendCommand, failed with status --19
>usb 1-1.2: USB disconnect, device number 5
>pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
>pl2303 1-1.2:1.0: device disconnected
>usb 1-2: USB disconnect, device number 2
>usb 2-1: new full speed USB device number 2 using ohci_hcd
>usb 2-1: not running at top speed; connect to a high speed hub
>hub 2-1:1.0: USB hub found
>hub 2-1:1.0: 4 ports detected
>usb 3-1: new full speed USB device number 2 using ohci_hcd
>usb 3-1: not running at top speed; connect to a high speed hub
>cx231xx #1: New device Hauppauge Hauppauge Device @ 12 Mbps (2040:c200)
>
>with 3 interfaces
>cx231xx #1: registering interface 1
>cx231xx #1: can't change interface 3 alt no. to 3: Max. Pkt size = 0
>usb 3-1: selecting invalid altsetting 3
>cx231xx #1: can't change interface 3 alt no. to 3 (err=-22)
>cx231xx #1: can't change interface 4 alt no. to 1: Max. Pkt size = 0
>cx231xx #1: can't change interface 4 alt no. to 1 (err=-22)
>cx231xx #1: Identified as Hauppauge USB Live 2 (card=9)
>cx231xx #1: cx231xx_dif_set_standard: setStandard to ffffffff
>cx231xx #1: can't change interface 5 alt no. to 0 (err=-22)
>cx231xx #1: Changing the i2c master port to 3
>cx25840 3-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #1)
>cx25840 3-0044:  Firmware download size changed to 16 bytes max length
>cx25840 3-0044: loaded v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
>cx231xx #1: cx231xx #1: v4l2 driver version 0.0.1
>cx231xx #1: cx231xx_dif_set_standard: setStandard to ffffffff
>cx231xx #1: video_mux : 0
>cx231xx #1: do_mode_ctrl_overrides : 0xb000
>cx231xx #1: do_mode_ctrl_overrides NTSC
>cx231xx #1: cx231xx #1/0: registered device video1 [v4l2]
>cx231xx #1: cx231xx #1/0: registered device vbi1
>cx231xx #1: V4L2 device registered as video1 and vbi1
>cx231xx #1: EndPoint Addr 0x84, Alternate settings: 2
>cx231xx #1: Alternate setting 0, max size= 64
>cx231xx #1: Alternate setting 1, max size= 728
>CPU 0 Unable to handle kernel paging request at virtual address 
>00000000, epc == 80f84e5c, ra == 80f84e30
>Oops[#1]:
>Cpu 0
>$ 0   : 00000000 1000fc00 81b9f660 81b9f600
>$ 4   : 80f9ad58 000050a1 ffffffff 00000000
>$ 8   : 0000000a 00000001 00000001 0000000d
>$12   : 000000ff 80e2dbd4 00000030 00000000
>$16   : 80dfc000 80c93000 80fa0000 00000000
>$20   : 00000002 00000000 80dfc0f8 00000001
>$24   : 00000002 801539e0                 
>$28   : 80c52000 80c53a88 80fa0000 80f84e30
>Hi    : 00000000
>Lo    : 00000000
>epc   : 80f84e5c 0x80f84e5c
>    Not tainted
>ra    : 80f84e30 0x80f84e30
>Status: 1000fc03    KERNEL EXL IE
>Cause : 00800008
>BadVA : 00000000
>PrId  : 00029006 (Broadcom BMIPS3300)
>Modules linked in: cx231xx cx2341x cx25840 rc_core videobuf_vmalloc 
>videobuf_core saa7115 usbvision pl2303 v4l2_common videodev usb_storage
>
>usbserial i2c_dev i2c_core ohci_hcd nf_nat_irc nf_conntrack_irc 
>nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat 
>xt_conntrack xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 
>nf_defrag_ipv4 nf_conntrack ehci_hcd sd_mod ipt_REJECT xt_TCPMSS
>ipt_LOG 
>xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable_filter 
>ip_tables xt_tcpudp x_tables tun vfat fat ext4 jbd2 mbcache b43legacy 
>b43 nls_iso8859_1 nls_cp437 mac80211 usbcore scsi_mod nls_base crc16 
>cfg80211 compat input_core arc4 aes_generic crypto_algapi switch_robo 
>switch_core diag
>Process khubd (pid: 601, threadinfo=80c52000, task=81bdf208,
>tls=00000000)
>Stack : 81bdf238 80dfc000 00000001 000002d8 00002040 0000c200 00000003 
>8011fa58
>        70756148 67756170 61482065 61707075 20656775 69766544 00206563 
>00000000
>        00000000 00000000 00000000 00000000 00000000 00000000 00000000 
>00000000
>        00000000 00000000 00000000 00000000 00000000 00000000 00000000 
>00000000
>        00000000 00000000 00000000 00000000 00000000 00000000 00000000 
>00000000
>        ...
>Call Trace:[<8011fa58>] 0x8011fa58
>[<80c6cd9c>] 0x80c6cd9c
>[<8015db94>] 0x8015db94
>[<8015df14>] 0x8015df14
>[<8015e118>] 0x8015e118
>[<8015e0e8>] 0x8015e0e8
>[<8015cb28>] 0x8015cb28
>[<801197ac>] 0x801197ac
>[<8015dd14>] 0x8015dd14
>[<8015b9e0>] 0x8015b9e0
>[<80c69d54>] 0x80c69d54
>[<80c6bf80>] 0x80c6bf80
>[<800e15a8>] 0x800e15a8
>[<80c72e58>] 0x80c72e58
>[<8015df14>] 0x8015df14
>[<8015e118>] 0x8015e118
>[<8015e0e8>] 0x8015e0e8
>[<8015cb28>] 0x8015cb28
>[<801197ac>] 0x801197ac
>[<8015dd14>] 0x8015dd14
>[<8015b9e0>] 0x8015b9e0
>[<80c63f2c>] 0x80c63f2c
>[<80c64d1c>] 0x80c64d1c
>[<80038150>] 0x80038150
>[<80c63f90>] 0x80c63f90
>[<80037a0c>] 0x80037a0c
>[<800070f0>] 0x800070f0
>[<8003798c>] 0x8003798c
>[<800070e0>] 0x800070e0
>
>
>Code: 00021080  00621021  8c550000 <8ea20000> 02002821  8c42000c  
>0000a021  90460002  a6060c18
>Disabling lock debugging due to kernel taint
>cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
>cx231xx #0: can't change interface 3 alt no. to 0 (err=-22)
>
>hardware is a 260MHz access point running OpenWRT.
>
>root@anchor:/# uname -a
>Linux anchor 3.0.3 #13 Sun Dec 4 08:04:41 PST 2011 mips GNU/Linux
>
>
>-- 
>Few people are capable of expressing with equanimity opinions which
>differ from the prejudices of their social environment. Most people are
>even incapable of forming such opinions.
>    Albert Einstein
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Well, you probably have figured out you have a USB stack problem.  I'm not sure why a Host Controller would die and (hopefully) clean up properly, but that needs investigation.

Looking at the oops probably won't yield useful results in terms of finding cx231xx bugs as it happens after the first host controller has bombed out.

You should consider having /boot/System.map and the real klogd installed on your system, so the oops backtrace has meaningful symbol names as opposed to addresses (which are meaningless to anyone without a copy of your built kernel).

Regards,
Andy
