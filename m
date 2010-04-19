Return-path: <linux-media-owner@vger.kernel.org>
Received: from 161.n26.ham.bsws.de ([80.86.183.161]:54864 "EHLO
	mail.tinderbox-art.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0DSRfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Apr 2010 13:35:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.tinderbox-art.com (Postfix) with ESMTP id A73A512006DF3
	for <linux-media@vger.kernel.org>; Mon, 19 Apr 2010 19:35:37 +0200 (CEST)
Received: from mail.tinderbox-art.com ([127.0.0.1])
	by localhost (wurstwasser.tinderbox-art.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 30861-03 for <linux-media@vger.kernel.org>;
	Mon, 19 Apr 2010 19:35:36 +0200 (CEST)
Received: from [127.0.0.1] (wurstwasser.tinderbox-art.com [80.86.183.161])
	by mail.tinderbox-art.com (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Mon, 19 Apr 2010 19:35:36 +0200 (CEST)
Message-ID: <4BCC9467.6090805@tinderbox-art.com>
Date: Mon, 19 Apr 2010 19:35:35 +0200
From: Jens Bruckmann <jens@tinderbox-art.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Terratec S7 USB: Scanning doesn't reliably work on Astra 19.2E
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm trying to get a Terratec S7 to work. The driver, just cloned 
v4l-dvb, compiles and loads fine but when I try to scan Astra 19.2E only 
a few stations get scanned. In most cases I get a tuning error. Under 
Win7 the box works perfectly, so it's not a hardware defect or antenna 
specific issue.
Any help would be very appreciated.

Information about my system:
- Core i5 661 running on Gigabyte board

# uname -a
Linux mmedia 2.6.33-020633-generic #020633 SMP Thu Feb 25 10:10:03 UTC 
2010 x86_64 GNU/Linux

# lsusb -v -s 002:004

Bus 002 Device 004: ID 0ccd:10ac TerraTec Electronic GmbH
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0ccd TerraTec Electronic GmbH
   idProduct          0x10ac
   bcdDevice            0.03
   iManufacturer           1
   iProduct                2
   iSerial                 3
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           32
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xc0
       Self Powered
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval             100
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
can't get device qualifier: Operation not permitted
can't get debug descriptor: Operation not permitted
cannot read device status, Operation not permitted (1)

# lsmod
lsmod
Module                  Size  Used by
dvb_usb_az6027         16534  1
stb6100                 6772  1 dvb_usb_az6027
stb0899                34318  1 dvb_usb_az6027
dvb_usb                19392  1 dvb_usb_az6027
dvb_core              101054  2 dvb_usb_az6027,dvb_usb
binfmt_misc             7901  1
ppdev                   6503  0
bridge                 50766  0
stp                     2059  1 bridge
bnep                   11733  2
snd_hda_codec_intelhdmi    18424  1
snd_hda_codec_realtek   285848  1
snd_hda_intel          27340  1
snd_hda_codec          87794  3 
snd_hda_codec_intelhdmi,snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               6686  1 snd_hda_codec
snd_pcm_oss            42660  0
snd_mixer_oss          17285  1 snd_pcm_oss
snd_pcm                87952  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_seq_dummy           1836  0
snd_seq_oss            30234  0
snd_seq_midi            5722  0
snd_rawmidi            22532  1 snd_seq_midi
snd_seq_midi_event      6867  2 snd_seq_oss,snd_seq_midi
snd_seq                55304  6 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              23536  2 snd_pcm,snd_seq
snd_seq_device          6520  5 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
k8temp                  4056  0
iptable_filter          2743  0
snd                    69404  15 
snd_hda_codec_intelhdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device 

it87                   24835  0
soundcore               7945  1 snd
ip_tables              18228  1 iptable_filter
snd_page_alloc          8476  2 snd_hda_intel,snd_pcm
x_tables               21305  1 ip_tables
hwmon_vid               3083  1 it87
lp                     10024  0
btusb                  12784  2
serio_raw               4893  0
parport                38004  2 ppdev,lp
xfs                   927033  10
exportfs                4243  1 xfs
fbcon                  39731  72
tileblit                2311  1 fbcon
font                    8005  1 fbcon
bitblit                 5213  1 fbcon
softcursor              1485  1 bitblit
i915                  315226  2
drm_kms_helper         30180  1 i915
pata_it8213             3970  0
r8169                  41344  0
mii                     4933  1 r8169
drm                   195147  3 i915,drm_kms_helper
i2c_algo_bit            5830  1 i915
video                  22073  1 i915
intel_agp              28717  1
output                  2391  1 video

# dmesg

[  514.230862] usb 2-5: new high speed USB device using ehci_hcd and 
address 4
[  514.636137] dvb-usb: found a 'TERRATEC S7 MKII' in cold state, will 
try to load a firmware
[  514.636142] usb 2-5: firmware: requesting dvb-usb-az6027-03.fw
[  514.671231] dvb-usb: downloading firmware from file 
'dvb-usb-az6027-03.fw'
[  514.745683] dvb-usb: found a 'TERRATEC S7 MKII' in warm state.
[  514.745740] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[  514.963579] DVB: registering new adapter (TERRATEC S7 MKII)
[  516.942119] stb0899_attach: Attaching STB0899
[  516.942126] stb6100_attach: Attaching STB6100
[  516.942606] DVB: registering adapter 0 frontend 0 (STB0899 
Multistandard)...
[  516.942737] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-5/input/input4
[  516.942788] dvb-usb: schedule remote query interval to 400 msecs.
[  516.942794] dvb-usb: TERRATEC S7 MKII successfully initialized and 
connected.
[  516.942844] usbcore: registered new interface driver dvb_usb_az6027

Here some output from w_scan during scan. With scan-s2 it's the same, I 
always get "tuning failed".

Thank you for any assistance in advance and best regards,

     Jens

