Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:59208 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752449Ab1LECiN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Dec 2011 21:38:13 -0500
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1RXNru-0005nJ-E1
	for linux-media@vger.kernel.org; Sun, 04 Dec 2011 18:01:22 -0800
Message-ID: <4EDC25F1.4000909@seiner.com>
Date: Sun, 04 Dec 2011 18:01:21 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx231xx kernel oops
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am experiencing a kernel oops when trying to use a Hauppage USB Live 2 
frame grabber.  The oops is below.

The system is a SOC 260Mhz Broadcom BCM47XX access point running OpenWRT.

root@anchor:/# uname -a
Linux anchor 3.0.3 #13 Sun Dec 4 08:04:41 PST 2011 mips GNU/Linux

The OOPS could be due to the limited hardware or something else.  I'd 
appreciate any suggestions for making this work.  I was hoping with 
hardware compression I could make it work on this platform.  I am 
currently using a Hauppage USB Live (saa7115 based) with no problems but 
with limited resolution.

cx231xx v4l2 driver loaded.
cx231xx #0: New device Hauppauge Hauppauge Device @ 480 Mbps (2040:c200) with 5 interfaces
cx231xx #0: registering interface 1
cx231xx #0: can't change interface 3 alt no. to 3: Max. Pkt size = 0
cx231xx #0: can't change interface 4 alt no. to 1: Max. Pkt size = 0
cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
cx231xx #0: Changing the i2c master port to 3
cx231xx #0: cx25840 subdev registration failure
cx231xx #0: cx231xx #0: v4l2 driver version 0.0.1
cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
cx231xx #0: video_mux : 0
cx231xx #0: do_mode_ctrl_overrides : 0xb000
cx231xx #0: do_mode_ctrl_overrides NTSC
cx231xx #0: cx231xx #0/0: registered device video0 [v4l2]
cx231xx #0: cx231xx #0/0: registered device vbi0
cx231xx #0: V4L2 device registered as video0 and vbi0
cx231xx #0: EndPoint Addr 0x84, Alternate settings: 5
cx231xx #0: Alternate setting 0, max size= 512
cx231xx #0: Alternate setting 1, max size= 184
cx231xx #0: Alternate setting 2, max size= 728
cx231xx #0: Alternate setting 3, max size= 2892
cx231xx #0: Alternate setting 4, max size= 1800
cx231xx #0: EndPoint Addr 0x85, Alternate settings: 2
cx231xx #0: Alternate setting 0, max size= 512
cx231xx #0: Alternate setting 1, max size= 512
cx231xx #0: EndPoint Addr 0x86, Alternate settings: 2
cx231xx #0: Alternate setting 0, max size= 512
cx231xx #0: Alternate setting 1, max size= 576
usbcore: registered new interface driver cx231xx
wlan0: deauthenticating from ea:c7:b6:67:bd:1e by local choice (reason=3)
b43-phy0: Loading firmware version 508.1084 (2009-01-14 01:32:01)
wlan0: authenticate with ea:c7:b6:67:bd:1e (try 1)
wlan0: authenticated
wlan0: associate with ea:c7:b6:67:bd:1e (try 1)
wlan0: RX AssocResp from ea:c7:b6:67:bd:1e (capab=0x411 status=0 aid=3)
wlan0: associated
hrtimer: interrupt took 33795302 ns
cx231xx #0:  setPowerMode::mode = 48, No Change req.
cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
cx231xx #0: video_mux : 0
cx231xx #0: do_mode_ctrl_overrides : 0xb000
cx231xx #0: do_mode_ctrl_overrides NTSC
cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
cx231xx #0: cx231xx_initialize_stream_xfer: set video registers
cx231xx #0: cx231xx_start_stream():: ep_mask = 8
ehci_hcd 0000:00:02.2: fatal error
ehci_hcd 0000:00:02.2: HC died; cleaning up
ehci_hcd 0000:00:02.2: force halt; handshake c0350024 00004000 00004000 -> -145
ehci_hcd 0000:00:02.2: HC died; cleaning up
usb 1-1: USB disconnect, device number 3
usb 1-1.3: USB disconnect, device number 4
pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
pl2303 1-1.3:1.0: device disconnected
usb 1-2: USB disconnect, device number 2
usb 2-1: new full speed USB device number 2 using ohci_hcd
usb 2-1: not running at top speed; connect to a high speed hub
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 4 ports detected
usb 3-1: new full speed USB device number 2 using ohci_hcd
usb 3-1: not running at top speed; connect to a high speed hub
cx231xx #1: New device Hauppauge Hauppauge Device @ 12 Mbps (2040:c200) with 3 interfaces
cx231xx #1: registering interface 1
cx231xx #1: can't change interface 3 alt no. to 3: Max. Pkt size = 0
usb 3-1: selecting invalid altsetting 3
cx231xx #1: can't change interface 3 alt no. to 3 (err=-22)
cx231xx #1: can't change interface 4 alt no. to 1: Max. Pkt size = 0
cx231xx #1: can't change interface 4 alt no. to 1 (err=-22)
cx231xx #1: Identified as Hauppauge USB Live 2 (card=9)
cx231xx #1: cx231xx_dif_set_standard: setStandard to ffffffff
cx231xx #1: can't change interface 5 alt no. to 0 (err=-22)
cx231xx #1: Changing the i2c master port to 3
cx231xx #1: cx25840 subdev registration failure
cx231xx #1: cx231xx #1: v4l2 driver version 0.0.1
cx231xx #1: cx231xx_dif_set_standard: setStandard to ffffffff
cx231xx #1: video_mux : 0
cx231xx #1: do_mode_ctrl_overrides : 0xb000
cx231xx #1: do_mode_ctrl_overrides NTSC
cx231xx #1: cx231xx #1/0: registered device video1 [v4l2]
cx231xx #1: cx231xx #1/0: registered device vbi1
cx231xx #1: V4L2 device registered as video1 and vbi1
cx231xx #1: EndPoint Addr 0x84, Alternate settings: 2
cx231xx #1: Alternate setting 0, max size= 64
cx231xx #1: Alternate setting 1, max size= 728
CPU 0 Unable to handle kernel paging request at virtual address 00000000, epc == 80f64e5c, ra == 80f64e30
Oops[#1]:
Cpu 0
$ 0   : 00000000 1000fc00 81b97660 81b97600
$ 4   : 80f7ad58 00004bf8 ffffffff 00000000
$ 8   : 0000000a 00000001 00000001 0000000d
$12   : 000000ff ffffffe0 8103ef20 00000000
$16   : 80fdc000 80c57000 80f80000 00000000
$20   : 00000002 00000000 80fdc0f8 00000001
$24   : 00000002 801539e0                  
$28   : 80c06000 80c07a88 80f80000 80f64e30
Hi    : 00000000
Lo    : 00000000
epc   : 80f64e5c 0x80f64e5c
    Not tainted
ra    : 80f64e30 0x80f64e30
Status: 1000fc03    KERNEL EXL IE 
Cause : 00800008
BadVA : 00000000
PrId  : 00029006 (Broadcom BMIPS3300)
Modules linked in: cx231xx cx2341x rc_core videobuf_vmalloc videobuf_core saa7115 usbvision pl2303 v4l2_common videodev usb_storage usbserial i2c_dev i2c_core ohci_hcd nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat xt_conntrack xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ehci_hcd sd_mod ipt_REJECT xt_TCPMSS ipt_LOG xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables tun vfat fat ext4 jbd2 mbcache b43legacy b43 nls_iso8859_1 nls_cp437 mac80211 usbcore scsi_mod nls_base crc16 cfg80211 compat input_core arc4 aes_generic crypto_algapi switch_robo switch_core diag
Process khubd (pid: 598, threadinfo=80c06000, task=81a585b8, tls=00000000)
Stack : 81a585e8 80fdc000 00000001 000002d8 00002040 0000c200 00000003 8011fa58
        70756148 67756170 61482065 61707075 20656775 69766544 00206563 00000000
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
        ...
Call Trace:[<8011fa58>] 0x8011fa58
[<80c6cd9c>] 0x80c6cd9c
[<8015db94>] 0x8015db94
[<8015df14>] 0x8015df14
[<8015e118>] 0x8015e118
[<8015e0e8>] 0x8015e0e8
[<8015cb28>] 0x8015cb28
[<801197ac>] 0x801197ac
[<8015dd14>] 0x8015dd14
[<8015b9e0>] 0x8015b9e0
[<80c69d54>] 0x80c69d54
[<80c6bf80>] 0x80c6bf80
[<800e15a8>] 0x800e15a8
[<80c72e58>] 0x80c72e58
[<8015df14>] 0x8015df14
[<8015e118>] 0x8015e118
[<8015e0e8>] 0x8015e0e8
[<8015cb28>] 0x8015cb28
[<801197ac>] 0x801197ac
[<8015dd14>] 0x8015dd14
[<8015b9e0>] 0x8015b9e0
[<80c63f2c>] 0x80c63f2c
[<80c64d1c>] 0x80c64d1c
[<80038150>] 0x80038150
[<80c63f90>] 0x80c63f90
[<80037a0c>] 0x80037a0c
[<800070f0>] 0x800070f0
[<8003798c>] 0x8003798c
[<800070e0>] 0x800070e0


Code: 00021080  00621021  8c550000 <8ea20000> 02002821  8c42000c  0000a021  90460002  a6060c18 
Disabling lock debugging due to kernel taint
cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
cx231xx #0: can't change interface 3 alt no. to 0 (err=-22)


-- 
Few people are capable of expressing with equanimity opinions which differ from the prejudices of their social environment. Most people are even incapable of forming such opinions.
    Albert Einstein

