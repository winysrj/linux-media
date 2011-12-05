Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:57543 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754998Ab1LEEp6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Dec 2011 23:45:58 -0500
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1RXQRB-0001Ro-8c
	for linux-media@vger.kernel.org; Sun, 04 Dec 2011 20:45:57 -0800
Message-ID: <4EDC4C84.2030904@seiner.com>
Date: Sun, 04 Dec 2011 20:45:56 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx231xx kernel oops
References: <4EDC25F1.4000909@seiner.com> <1323058527.12343.3.camel@palomino.walls.org>
In-Reply-To: <1323058527.12343.3.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sun, 2011-12-04 at 18:01 -0800, Yan Seiner wrote:
>   
>> I am experiencing a kernel oops when trying to use a Hauppage USB Live 2 
>> frame grabber.  The oops is below.
>>
>> The system is a SOC 260Mhz Broadcom BCM47XX access point running OpenWRT.
>>
>> root@anchor:/# uname -a
>> Linux anchor 3.0.3 #13 Sun Dec 4 08:04:41 PST 2011 mips GNU/Linux
>>
>> The OOPS could be due to the limited hardware or something else.  I'd 
>> appreciate any suggestions for making this work.  I was hoping with 
>> hardware compression I could make it work on this platform.  I am 
>> currently using a Hauppage USB Live (saa7115 based) with no problems but 
>> with limited resolution.
>>
>> cx231xx v4l2 driver loaded.
>> cx231xx #0: New device Hauppauge Hauppauge Device @ 480 Mbps (2040:c200) with 5 interfaces
>> cx231xx #0: registering interface 1
>> cx231xx #0: can't change interface 3 alt no. to 3: Max. Pkt size = 0
>> cx231xx #0: can't change interface 4 alt no. to 1: Max. Pkt size = 0
>> cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
>> cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
>> cx231xx #0: Changing the i2c master port to 3
>> cx231xx #0: cx25840 subdev registration failure
>>     
>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> The cx231xx driver requires the cx25840 module.  I'll wager you didn't
> install it on your router.
>
>   

I made sure the module was loaded; same thing.  :-(

Module                  Size  Used by    Tainted: G 
cx231xx               124608  0
cx2341x                13552  1 cx231xx
cx25840                35568  2
rc_core                12640  1 cx231xx
videobuf_vmalloc        3168  1 cx231xx
videobuf_core          12384  2 cx231xx,videobuf_vmalloc

I was not able to catch the first bit.

cx231xx #1: can't change interface 4 alt no. to 1: Max. Pkt size = 0
cx231xx #1: can't change interface 4 alt no. to 1 (err=-22)
cx231xx #1: Identified as Hauppauge USB Live 2 (card=9)
cx231xx #1: cx231xx_dif_set_standard: setStandard to ffffffff
cx231xx #1: can't change interface 5 alt no. to 0 (err=-22)
cx231xx #1: Changing the i2c master port to 3
cx25840 3-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #1)
cx25840 3-0044:  Firmware download size changed to 16 bytes max length
cx25840 3-0044: unable to open firmware v4l-cx231xx-avcore-01.fw
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
CPU 0 Unable to handle kernel paging request at virtual address 
00000000, epc == 80f84e5c, ra == 80f84e30
Oops[#1]:
Cpu 0
$ 0   : 00000000 1000fc00 80e2f860 80e2f800
$ 4   : 80f9ad58 00005095 ffffffff 00000000
$ 8   : 0000000a 00000001 00000001 0000000d
$12   : 000000ff ffffffe0 8103f760 00000000
$16   : 81e30000 80c9f800 80fa0000 00000000
$20   : 00000002 00000000 81e300f8 00000001
$24   : 00000002 801539e0                 
$28   : 80c74000 80c75a88 80fa0000 80f84e30
Hi    : 00000000
Lo    : 00000000
epc   : 80f84e5c 0x80f84e5c
    Not tainted
ra    : 80f84e30 0x80f84e30
Status: 1000fc03    KERNEL EXL IE
Cause : 00800008
BadVA : 00000000
PrId  : 00029006 (Broadcom BMIPS3300)
Modules linked in: cx231xx cx2341x cx25840 rc_core videobuf_vmalloc 
videobuf_core saa7115 usbvision pl2303 v4l2_common videodev usb_storage 
usbserial i2c_dev i2c_core ohci_hcd nf_nat_irc nf_conntrack_irc 
nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat 
xt_conntrack xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 
nf_defrag_ipv4 nf_conntrack ehci_hcd sd_mod ipt_REJECT xt_TCPMSS ipt_LOG 
xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable_filter 
ip_tables xt_tcpudp x_tables tun vfat fat ext4 jbd2 mbcache b43legacy 
b43 nls_iso8859_1 nls_cp437 mac80211 usbcore scsi_mod nls_base crc16 
cfg80211 compat input_core arc4 aes_generic crypto_algapi switch_robo 
switch_core diag
Process khubd (pid: 596, threadinfo=80c74000, task=81a2d1a8, tls=00000000)
Stack : 802c4084 81e30000 00000001 000002d8 00002040 0000c200 00000003 
8011fa58
        70756148 67756170 61482065 61707075 20656775 69766544 00206563 
00000000
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
        00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
        ...
Call Trace:[<8011fa58>] 0x8011fa58
[<80c8cd9c>] 0x80c8cd9c
[<8015db94>] 0x8015db94
[<8015df14>] 0x8015df14
[<8015e118>] 0x8015e118
[<8015e0e8>] 0x8015e0e8
[<8015cb28>] 0x8015cb28
[<801197ac>] 0x801197ac
[<8015dd14>] 0x8015dd14
[<8015b9e0>] 0x8015b9e0
[<80c89d54>] 0x80c89d54
[<80c8bf80>] 0x80c8bf80
[<800e15a8>] 0x800e15a8
[<80c92e58>] 0x80c92e58
[<8015df14>] 0x8015df14
[<8015e118>] 0x8015e118
[<8015e0e8>] 0x8015e0e8
[<8015cb28>] 0x8015cb28
[<801197ac>] 0x801197ac
[<8015dd14>] 0x8015dd14
[<8015b9e0>] 0x8015b9e0
[<80c83f2c>] 0x80c83f2c
[<80c84d1c>] 0x80c84d1c
[<80038150>] 0x80038150
[<80c83f90>] 0x80c83f90
[<80037a0c>] 0x80037a0c
[<800070f0>] 0x800070f0
[<8003798c>] 0x8003798c
[<800070e0>] 0x800070e0


Code: 00021080  00621021  8c550000 <8ea20000> 02002821  8c42000c  
0000a021  90460002  a6060c18
Disabling lock debugging due to kernel taint
cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
cx231xx #0: can't change interface 3 alt no. to 0 (err=-22)




-- 
Few people are capable of expressing with equanimity opinions which differ from the prejudices of their social environment. Most people are even incapable of forming such opinions.
    Albert Einstein

