Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxout1.masterlogin.de ([134.0.28.11]:54036 "EHLO
        mxout1.masterlogin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753443AbeBSTc4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 14:32:56 -0500
Received: from mxbox4.masterlogin.de (unknown [192.168.10.253])
        by mxout1.masterlogin.de (Postfix) with ESMTP id 38E6720143
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:32:53 +0100 (CET)
Received: from [192.168.6.100] (ip-178-200-236-179.hsi07.unitymediagroup.de [178.200.236.179])
        by mxbox4.masterlogin.de (Postfix) with ESMTPSA id AC8C17D
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:32:52 +0100 (CET)
To: linux-media@vger.kernel.org
From: Hauke <projects@webvoss.de>
Subject: Problems with WinTV Hauppauge dualHD and LibreELEC 9 on Le Potato
 S905X box
Message-ID: <c609a212-ba06-396c-abd8-6704ccafbc17@webvoss.de>
Date: Mon, 19 Feb 2018 20:32:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

I am using a Libre Computer Le Potato SBC (see here: 
https://libre.computer/products/boards/aml-s905x-cc/) with LibreELEC 8 
Leia from adamg (community build). Included there is a driver for em28xx 
based DVB cards, which in the log refers to the email address I am 
sending this to - so here's my problem: I've a WinTV Hauppauge dualHD 
DVB-T/T2/C USB card, and I set it up under Raspberry Pi/xbian/tvheadend 
successfully, could scan DVB-C and DVB-T2 and watch TV - i.e. card works 
in principle (only one tuner, but that's OK at the moment). Now I 
attached the same card to the Libre Computer Le Potato, and have only 
partial success. From dmesg I see that even both tuners are recognized, 
but they do not show up as devices in /dev - there isn't even a /dev/dvb 
folder! dmesg looks very similar to Raspberry/xbian, with three notable 
exceptions: First, the i2c-bus is not added on Le Potato. Second, 
potentially as a result of the first, the firmware file 
dvb-demod-si2168-b40-01.fw 
<https://github.com/OpenELEC/dvb-firmware/raw/master/firmware/dvb-demod-si2168-b40-01.fw>, 
although present, is not loaded. Third: There's a warning that this is a 
downport of the driver, which is originally created for kernel v4, not 
v3. Hauppauge itself claims support only for v4. Of course as a result 
of all this tvheadend does not see any tuner. Still, it looks like I'm 
almost there - anyone can help me do the final step?

Here's the dmesg output (Le Potato):

[ 14.416196@3] em28xx 1-1.1:1.0: EEPROM ID = 26 00 01 00, EEPROM hash = 
0x16e6c5c8
[ 14.416208@3] em28xx 1-1.1:1.0: EEPROM info:
[ 14.416213@3] em28xx 1-1.1:1.0: microcode start address = 0x0004, boot 
configuration = 0x01
[ 14.422833@0] em28xx 1-1.1:1.0: AC97 audio (5 sample rates)
[ 14.422846@0] em28xx 1-1.1:1.0: 500mA max power
[ 14.422852@0] em28xx 1-1.1:1.0: Table at offset 0x27, strings=0x0e6a, 
0x1888, 0x087e
[ 14.423650@3] em28xx 1-1.1:1.0: Identified as Hauppauge WinTV-dualHD 
DVB (card=99)
[ 14.426389@3] tveeprom: Hauppauge model 204109, rev B3I6, serial# 13886631
[ 14.426398@3] tveeprom: tuner model is SiLabs Si2157 (idx 186, type 4)
[ 14.426403@3] tveeprom: TV standards PAL(B/G) NTSC(M) PAL(I) 
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
[ 14.426407@3] tveeprom: audio processor is None (idx 0)
[ 14.426411@3] tveeprom: has no radio, has IR receiver, has no IR 
transmitter
[ 14.426422@3] em28xx 1-1.1:1.0: dvb set to isoc mode.
[ 14.426498@3] em28xx 1-1.1:1.0: chip ID is em28174
[ 14.826656@0] libphy: stmmac-0:08 - Link is Up - 100/Full
[ 15.626378@3] em28xx 1-1.1:1.0: EEPROM ID = 26 00 01 00, EEPROM hash = 
0x16e6c5c8
[ 15.626389@3] em28xx 1-1.1:1.0: EEPROM info:
[ 15.626395@3] em28xx 1-1.1:1.0: microcode start address = 0x0004, boot 
configuration = 0x01
[ 15.634435@3] em28xx 1-1.1:1.0: AC97 audio (5 sample rates)
[ 15.634450@3] em28xx 1-1.1:1.0: 500mA max power
[ 15.634457@3] em28xx 1-1.1:1.0: Table at offset 0x27, strings=0x0e6a, 
0x1888, 0x087e
[ 15.635644@3] em28xx 1-1.1:1.0: Identified as Hauppauge WinTV-dualHD 
DVB (card=99)
[ 15.642480@3] tveeprom: Hauppauge model 204109, rev B3I6, serial# 13886631
[ 15.642494@3] tveeprom: tuner model is SiLabs Si2157 (idx 186, type 4)
[ 15.642499@3] tveeprom: TV standards PAL(B/G) NTSC(M) PAL(I) 
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
[ 15.642503@3] tveeprom: audio processor is None (idx 0)
[ 15.642507@3] tveeprom: has no radio, has IR receiver, has no IR 
transmitter
[ 15.642518@3] em28xx 1-1.1:1.0: dvb ts2 set to isoc mode.
[ 15.843930@3] usbcore: registered new interface driver em28xx
[ 15.847501@2] WARNING: You are using an experimental version of the 
media stack.
[ 15.847501@2] As the driver is backported to an older kernel, it 
doesn't offer
[ 15.847501@2] enough quality for its usage in production.
[ 15.847501@2] Use it with care.
[ 15.847501@2] Latest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):
[ 15.847501@2] b32a2b42f76cdfd06b4b58a1ddf987ba329ae34e media: ddbridge: 
improve error handling logic on fe attach failures
[ 15.847501@2] 6738d3bbab999d7d9d77a185d62bd146d9a257f2 media: drivers: 
media: remove duplicate includes
[ 15.847501@2] 9ed785a926843ca5a954d3324082afa2b96f5824 media: platform: 
sti: Adopt SPDX identifier
[ 15.848721@2] em28xx 1-1.1:1.0: Binding DVB extension
[ 15.860406@2] em28xx 1-1.1:1.0: Binding DVB extension
[ 15.864730@3] em28xx: Registered (Em28xx dvb Extension) extension
[ 15.868624@0] em28xx 1-1.1:1.0: Registering input extension
[ 15.899572@0] Registered IR keymap rc-hauppauge
[ 15.899972@2] rc rc1: 1-1.1:1.0 IR as 
/devices/c9000000.dwc3/xhci-hcd.0.auto/usb1/1-1/1-1.1/1-1.1:1.0/rc/rc1
[ 15.900190@2] input: 1-1.1:1.0 IR as 
/devices/c9000000.dwc3/xhci-hcd.0.auto/usb1/1-1/1-1.1/1-1.1:1.0/rc/rc1/input3
[ 15.900445@2] em28xx 1-1.1:1.0: Input extension successfully initialized
[ 15.900459@2] em28xx 1-1.1:1.0: Remote control support is not available 
for this card.
[ 15.900463@2] em28xx: Registered (Em28xx Input Extension) extension

For comparison, here's dmesg from the xbian/Raspberry:

[ 14.844653] em28174 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x16e6c5c8
[ 14.844668] em28174 #0: EEPROM info:
[ 14.844679] em28174 #0: microcode start address = 0x0004, boot 
configuration = 0x01
[ 14.852600] em28174 #0: AC97 audio (5 sample rates)
[ 14.852615] em28174 #0: 500mA max power
[ 14.852632] em28174 #0: Table at offset 0x27, strings=0x0e6a, 0x1888, 
0x087e
[ 14.853068] em28174 #0: Identified as Hauppauge WinTV-dualHD DVB (card=99)
[ 14.860852] tveeprom 4-0050: Hauppauge model 204109, rev B3I6, serial# 
13886631
[ 14.860873] tveeprom 4-0050: tuner model is SiLabs Si2157 (idx 186, type 4)
[ 14.860887] tveeprom 4-0050: TV standards PAL(B/G) NTSC(M) PAL(I) 
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
[ 14.860900] tveeprom 4-0050: audio processor is None (idx 0)
[ 14.860912] tveeprom 4-0050: has no radio, has IR receiver, has no IR 
transmitter
[ 14.860924] em28174 #0: dvb set to isoc mode.
[ 14.861601] usbcore: registered new interface driver em28xx
[ 14.862760] snd-rpi-cirrus soc:sound: ASoC: CODEC DAI wm5102-aif1 not 
registered - will retry
[ 14.907896] em28174 #0: Binding DVB extension
[ 15.002024] i2c i2c-4: Added multiplexed i2c bus 5
[ 15.002057] si2168 4-0064: Silicon Labs Si2168-B40 successfully identified
[ 15.002076] si2168 4-0064: firmware version: B 4.0.2
[ 15.002639] snd-rpi-cirrus soc:sound: ASoC: CODEC DAI wm5102-aif1 not 
registered - will retry
[ 15.043260] si2157 5-0060: Silicon Labs Si2147/2148/2157/2158 
successfully attached
[ 15.043363] DVB: registering new adapter (em28174 #0)
[ 15.043404] usb 1-1.5: DVB: registering adapter 0 frontend 0 (Silicon 
Labs Si2168)...
[ 15.044164] snd-rpi-cirrus soc:sound: ASoC: CODEC DAI wm5102-aif1 not 
registered - will retry
[ 15.047208] em28174 #0: DVB extension successfully initialized
[ 15.047229] em28xx: Registered (Em28xx dvb Extension) extension
[ 15.095899] em28174 #0: Registering input extension
[ 15.253160] Registered IR keymap rc-hauppauge
[ 15.254164] input: em28xx IR (em28174 #0) as 
/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/rc/rc0/input0
[ 15.254765] rc rc0: em28xx IR (em28174 #0) as 
/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/rc/rc0
[ 15.262050] em28174 #0: Input extension successfully initalized
[ 15.262071] em28xx: Registered (Em28xx Input Extension) extension
[ 16.509324] si2168 4-0064: downloading firmware from file 
'dvb-demod-si2168-b40-01.fw'
[ 17.024833] si2168 4-0064: firmware version: B 4.0.11
[ 17.035803] si2157 5-0060: found a 'Silicon Labs Si2157-A30'
[ 17.087464] si2157 5-0060: firmware version: 3.0.5
[ 17.087617] usb 1-1.5: DVB: adapter 0 frontend 0 frequency 0 out of 
range (42000000..870000000)

Here's also lsmod from the Le Potato:

Module Size Used by
xt_nat 2015 1
xt_tcpudp 3293 3
veth 5005 0
ipt_MASQUERADE 2256 2
nf_conntrack_netlink 20028 0
nfnetlink 5227 2 nf_conntrack_netlink
iptable_nat 3308 1
nf_conntrack_ipv4 9101 2
nf_defrag_ipv4 1457 1 nf_conntrack_ipv4
nf_nat_ipv4 3582 1 iptable_nat
xt_addrtype 2899 2
iptable_filter 1478 1
ip_tables 17688 2 iptable_filter,iptable_nat
xt_conntrack 3247 1
x_tables 18411 7 
ip_tables,xt_tcpudp,ipt_MASQUERADE,xt_conntrack,xt_nat,iptable_filter,xt_addrtype
nf_nat 13203 4 ipt_MASQUERADE,nf_nat_ipv4,xt_nat,iptable_nat
nf_conntrack 60627 7 
ipt_MASQUERADE,nf_nat,nf_nat_ipv4,xt_conntrack,nf_conntrack_netlink,iptable_nat,nf_conntrack_ipv4
bridge 96995 0
stp 1680 1 bridge
llc 3773 2 stp,bridge
rc_hauppauge 2193 0
em28xx_rc 8362 0
em28xx_dvb 22440 0
dvb_core 103890 1 em28xx_dvb
8021q 19007 0
ir_rc6_decoder 3557 0
mali 192729 5
em28xx 71682 2 em28xx_dvb,em28xx_rc
tveeprom 13844 1 em28xx
v4l2_common 4001 1 em28xx
ir_nec_decoder 2429 0
ipheth 6743 0
wifi_dummy 806 0
ir_lirc_codec 4209 0
lirc_dev 7264 2 ir_lirc_codec
meson_ir 3997 0
rc_core 23955 9 
lirc_dev,meson_ir,ir_lirc_codec,rc_hauppauge,ir_nec_decoder,ir_rc6_decoder,em28xx_rc
amlvideodri 12674 0
videobuf_res 5378 1 amlvideodri
videobuf_core 16643 2 amlvideodri,videobuf_res
videodev 150841 2 amlvideodri,v4l2_common
media 25461 3 em28xx,videodev,dvb_core
dwc_otg 233217 0
fbcon 38031 0
bitblit 4468 1 fbcon
softcursor 1168 1 bitblit
font 7327 1 fbcon

Would be glad to get this up'n'running... Thanks for any help!


If you need something, let me know!


Hauke
