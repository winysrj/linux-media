Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:47494 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0AaScU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 13:32:20 -0500
Date: Sun, 31 Jan 2010 12:54:34 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: V4L Mailing List <linux-media@vger.kernel.org>
cc: Matthias Huber <matthias.huber@wollishausen.de>
Subject: Re: solved // more debug from 979:280 (fwd)
Message-ID: <alpine.LNX.2.00.1001311250180.26120@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-561907752-1264964074=:26120"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-561907752-1264964074=:26120
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT


For further background see my previous message.

This message explains that the problem with device 0x0979:0x0280 which 
Matthias was having appears to be related to running the camera through 
his USB 2.0 hub (details below). I should also mention that I have a 
similar camera myself (same ID) and so does Andy Walls. I never had any 
such problems with my camera, but I do not even own any external USB hub.

Theodore Kilgore


---------- Forwarded message ----------
Date: Fri, 29 Jan 2010 17:49:39 +0100
From: Matthias Huber <matthias.huber@wollishausen.de>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Andy Walls <awalls@radix.net>
Subject: Re: solved // more debug from 979:280

29.01.2010 17:32,   Theodore Kilgore :
> 
> 
> Andy,
> 
> Matthias found the solution, but it seems to me that the problems involved 
> might possibly need more attention from some quarter, not necessarily from 
> linux-media, but possibly from linux-usb:
> 
> Briefly, Matthias is saying that the problem arises when he plugs the camera 
> in on his USB 2.0 port.
and now i can say that it is this special usb2.0 hub.
on the market the vendor calles itself "digitus", but i think this is a german 
vendor.

i tried another super-cheap hub of a cube with time, temperature, and changing 
colors and holder for pens,
and this hub works ok with the camera.

because of that it seems, that the problem is hub-specific.

the working hub calls:

Bus 003 Device 010: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x05e3 Genesys Logic, Inc.
  idProduct          0x0608 USB-2.0 4-Port HUB
  bcdDevice            9.01
  iManufacturer           0
  iProduct                1 USB2.0 Hub
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             4
  wHubCharacteristic 0x00e0
    Ganged power switching
    Ganged overcurrent protection
    Port indicators
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent    100 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0103 power enable connect
   Port 4: 0000.0100 power
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0001
  Self Powered

> 
> My impression is that, at least in theory, there is not supposed to be any 
> problem, even so.
> 
> Of course, the problem could be one which was present in 2.6.28 and has been 
> fixed now that we have 2.6.32.
> 
> What do you think?
> 
> Theodore Kilgore
> 
> On Fri, 29 Jan 2010, Matthias Huber wrote:
> 
>> Good Morning (?) Theodore,
>> 
>> today i made some tries again with the camera:
>> 
>> the first resulted in a big crash (system hung). i tried magic sysrq, but 
>> only with partial success.
>> 
>> the error on the first try was: it created video0, which is my dvb-card
>> 
>> in the second try, one sees the misunderstanding between jeilinj and 
>> gspca_main about the buffer size.
>> 
>> another successful try shows correct parameters for frame size.
>> 
>> 
>> and the solution was: (i remembered from our last communicaiton about the 
>> camera)
>>
>>   *** not to use my usb-2.0 hub, which seems to work buggy.
>>          or at least the camera on it works buggy. (maybe a timing problem 
>> ?)
>> 
>> 
>> this hub often has the problem, that after some connects / disconnects,
>> one has to power off and on for enumerating again plugged devices on it.
>> 
>> so i don't know, if this is a general problem in gspca-timing or not.
>> 
>> the usb-hub with the problem is:
>> 
>> matz@linux:~$ lsusb -v
>> 
>> Bus 001 Device 007: ID 04b4:6560 Cypress Semiconductor Corp. CY7C65640 
>> USB-2.0 "TetraHub"
>> Device Descriptor:
>> bLength                18
>> bDescriptorType         1
>> bcdUSB               2.00
>> bDeviceClass            9 Hub
>> bDeviceSubClass         0 Unused
>> bDeviceProtocol         2 TT per port
>> bMaxPacketSize0        64
>> idVendor           0x04b4 Cypress Semiconductor Corp.
>> idProduct          0x6560 CY7C65640 USB-2.0 "TetraHub"
>> bcdDevice            0.08
>> iManufacturer           0
>> iProduct                0
>> iSerial                 0
>> bNumConfigurations      1
>> Configuration Descriptor:
>>   bLength                 9
>>   bDescriptorType         2
>>   wTotalLength           41
>>   bNumInterfaces          1
>>   bConfigurationValue     1
>>   iConfiguration          0
>>   bmAttributes         0xe0
>>     Self Powered
>>     Remote Wakeup
>>   MaxPower              100mA
>>   Interface Descriptor:
>>     bLength                 9
>>     bDescriptorType         4
>>     bInterfaceNumber        0
>>     bAlternateSetting       0
>>     bNumEndpoints           1
>>     bInterfaceClass         9 Hub
>>     bInterfaceSubClass      0 Unused
>>     bInterfaceProtocol      1 Single TT
>>     iInterface              0
>>     Endpoint Descriptor:
>>       bLength                 7
>>       bDescriptorType         5
>>       bEndpointAddress     0x81  EP 1 IN
>>       bmAttributes            3
>>         Transfer Type            Interrupt
>>         Synch Type               None
>>         Usage Type               Data
>>       wMaxPacketSize     0x0001  1x 1 bytes
>>       bInterval              12
>>   Interface Descriptor:
>>     bLength                 9
>>     bDescriptorType         4
>>     bInterfaceNumber        0
>>     bAlternateSetting       1
>>     bNumEndpoints           1
>>     bInterfaceClass         9 Hub
>>     bInterfaceSubClass      0 Unused
>>     bInterfaceProtocol      2 TT per port
>>     iInterface              0
>>     Endpoint Descriptor:
>>       bLength                 7
>>       bDescriptorType         5
>>       bEndpointAddress     0x81  EP 1 IN
>>       bmAttributes            3
>>         Transfer Type            Interrupt
>>         Synch Type               None
>>         Usage Type               Data
>>       wMaxPacketSize     0x0001  1x 1 bytes
>>       bInterval              12
>> Hub Descriptor:
>> bLength               9
>> bDescriptorType      41
>> nNbrPorts             4
>> wHubCharacteristic 0x0089
>>   Per-port power switching
>>   Per-port overcurrent protection
>>   TT think time 8 FS bits
>>   Port indicators
>> bPwrOn2PwrGood       50 * 2 milli seconds
>> bHubContrCurrent    100 milli Ampere
>> DeviceRemovable    0x00
>> PortPwrCtrlMask    0xff
>> Hub Port Status:
>>  Port 1: 0000.0100 power
>>  Port 2: 0000.0100 power
>>  Port 3: 0000.0100 power
>>  Port 4: 0000.0100 power
>> Device Qualifier (for other device speed):
>> bLength                10
>> bDescriptorType         6
>> bcdUSB               2.00
>> bDeviceClass            9 Hub
>> bDeviceSubClass         0 Unused
>> bDeviceProtocol         0 Full speed (or root) hub
>> bMaxPacketSize0        64
>> bNumConfigurations      1
>> Device Status:     0x0001
>> Self Powered
>> 
>> 
>> 
>> 
>> 
>> 
>> 
>> nearby my logging:
>> 
>> *** first try *********************************
>> Jan 29 10:18:59 linux kernel: [11903.872081] usb 1-1.4: new full speed USB 
>> device using ehci_hcd and address 5
>> Jan 29 10:19:00 linux kernel: [11905.216358] usb 1-1.4: configuration #1 
>> chosen from 1 choice
>> Jan 29 10:19:00 linux kernel: [11905.216547] gspca: probing 0979:0280
>> Jan 29 10:19:00 linux kernel: [11905.216552] jeilinj: JEILINJ camera 
>> detected (vid/pid 0x0979:0x0280)
>> Jan 29 10:19:00 linux kernel: [11905.216633] gspca: video0 created
>> Jan 29 10:19:30 linux kernel: [11934.582841] Dumping ftrace buffer:
>> Jan 29 10:19:30 linux kernel: [11934.582844]    (ftrace buffer empty)
>> Jan 29 10:19:30 linux kernel: [11934.582846] Modules linked in: nls_utf8 
>> nls_cp437 cifs binfmt_misc r128 drm bridge stp bnep vboxnetflt vboxdrv ivtv 
>> i2c_algo_bit cx2341x v4l2_common tveeprom lirc_dev tun video output 
>> input_polldev iptable_nat ipt_MASQUERADE ipt_REJECT ipt_LOG xt_limit 
>> xt_tcpudp xt_state ipt_addrtype ip6table_filter ip6_tables nf_nat_irc 
>> nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
>> nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables reiserfs 
>> capi capifs lp stv0299 ves1x93 snd_intel8x0 snd_ac97_codec ac97_bus 
>> snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi 
>> snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device dvb_ttpci 
>> dvb_core saa7146_vv fcpci(P) saa7146 ppdev psmouse snd kernelcapi 
>> videobuf_dma_sg videobuf_core ttpci_eeprom pcspkr serio_raw soundcore 
>> nvidia_agp shpchp gspca_jeilinj snd_page_alloc i2c_nforce2 agpgart 
>> parport_pc gspca_main parport videodev v4l1_compat usblp forcedeth floppy 
>> fbcon tileblit font bitblit softcurs
>> Jan 29 10:19:30 linux kernel: r
>> Jan 29 10:19:30 linux kernel: [11934.582908]
>> Jan 29 10:19:30 linux kernel: [11934.582912] Pid: 18827, comm: svv Tainted: 
>> P (2.6.28-17-generic #58-Ubuntu) A7N8X-X
>> Jan 29 10:19:30 linux kernel: [11934.582916] EIP: 0060:[<c05007db>] EFLAGS: 
>> 00010286 CPU: 0
>> Jan 29 10:19:30 linux kernel: [11934.582924] EIP is at 
>> unlock_kernel+0x2b/0x2f
>> Jan 29 10:19:30 linux kernel: [11934.582926] EAX: ffffffff EBX: f6804018 
>> ECX: c5f06908 EDX: c2843ed0
>> Jan 29 10:19:30 linux kernel: [11934.582929] ESI: c5f06908 EDI: f6804018 
>> EBP: f4b09db0 ESP: f4b09db0
>> Jan 29 10:19:30 linux kernel: [11934.582932]  DS: 007b ES: 007b FS: 00d8 GS: 
>> 0033 SS: 0068
>> Jan 29 10:19:30 linux kernel: [11934.582939]  f4b09dc0 c0200350 c0200392 
>> f4b09f04 f4b09dd4 c01fb43c c0514120 fffffff4
>> Jan 29 10:19:30 linux kernel: [11934.583075] ---[ end trace c703c7e8ba3ab205 
>> ]---
>> 
>> 
>> 
>> *** second try: unsuccsessful ***************
>> Jan 29 10:33:07 linux kernel: [  697.102939] gspca: main v2.8.0 registered
>> Jan 29 10:34:16 linux kernel: [  765.696163] usb 1-1.4: new full speed USB 
>> device using ehci_hcd and address 4
>> Jan 29 10:34:17 linux kernel: [  767.045995] usb 1-1.4: configuration #1 
>> chosen from 1 choice
>> Jan 29 10:34:17 linux kernel: [  767.074695] gspca: probing 0979:0280
>> Jan 29 10:34:17 linux kernel: [  767.074702] jeilinj: JEILINJ camera 
>> detected (vid/pid 0x0979:0x0280)
>> Jan 29 10:34:17 linux kernel: [  767.074791] gspca: video1 created
>> Jan 29 10:34:17 linux kernel: [  767.074808] usbcore: registered new 
>> interface driver jeilinj
>> Jan 29 10:34:17 linux kernel: [  767.074812] jeilinj: registered
>> Jan 29 10:34:17 linux kernel: [  767.127978] gspca: [hald-probe-vide] open
>> Jan 29 10:34:17 linux kernel: [  767.127985] gspca: open done
>> Jan 29 10:34:17 linux kernel: [  767.129617] gspca: [hald-probe-vide] close
>> Jan 29 10:34:17 linux kernel: [  767.129624] gspca: close done
>> Jan 29 10:35:03 linux kernel: [  813.122390] gspca: [svv] open
>> Jan 29 10:35:03 linux kernel: [  813.122395] gspca: open done
>> Jan 29 10:35:03 linux kernel: [  813.122471] gspca: try fmt cap JPEG 640x480
>> Jan 29 10:35:03 linux kernel: [  813.122477] gspca: try fmt cap JPEG 320x240
>> Jan 29 10:35:03 linux kernel: [  813.122540] gspca: frame alloc frsz: 76800
>> Jan 29 10:35:03 linux kernel: [  813.122675] gspca: reqbufs st:0 c:4
>> Jan 29 10:35:03 linux kernel: [  813.122687] gspca: mmap start:b800a000 
>> size:77824
>> Jan 29 10:35:03 linux kernel: [  813.122706] gspca: mmap start:b7359000 
>> size:77824
>> Jan 29 10:35:03 linux kernel: [  813.122719] gspca: mmap start:b7346000 
>> size:77824
>> Jan 29 10:35:03 linux kernel: [  813.122732] gspca: mmap start:b7333000 
>> size:77824
>> Jan 29 10:35:03 linux kernel: [  813.122755] gspca: qbuf 0
>> Jan 29 10:35:03 linux kernel: [  813.122757] gspca: qbuf q:1 i:0 o:0
>> Jan 29 10:35:03 linux kernel: [  813.122759] gspca: qbuf 1
>> Jan 29 10:35:03 linux kernel: [  813.122761] gspca: qbuf q:2 i:0 o:0
>> Jan 29 10:35:03 linux kernel: [  813.122763] gspca: qbuf 2
>> Jan 29 10:35:03 linux kernel: [  813.122764] gspca: qbuf q:3 i:0 o:0
>> Jan 29 10:35:03 linux kernel: [  813.122766] gspca: qbuf 3
>> Jan 29 10:35:03 linux kernel: [  813.122768] gspca: qbuf q:0 i:0 o:0
>> Jan 29 10:35:03 linux kernel: [  813.122773] gspca: use alt 0 ep 0x01
>> Jan 29 10:35:03 linux kernel: [  813.122774] gspca: init transfer alt 0
>> Jan 29 10:35:03 linux kernel: [  813.122776] gspca: bulk bsize:32
>> Jan 29 10:35:03 linux kernel: [  813.122941] jeilinj: Start streaming at 
>> 320x240
>> Jan 29 10:35:03 linux kernel: [  813.130026] jeilinj: jlj_start retval is 0
>> Jan 29 10:35:03 linux kernel: [  813.130131] gspca: stream on OK JPEG 
>> 320x240
>> Jan 29 10:35:03 linux kernel: [  813.161530] gspca: poll
>> ...
>> Jan 29 10:35:04 linux kernel: [  814.152151] jeilinj: Got 0 bytes out of 512 
>> for Block 0
>> Jan 29 10:35:05 linux kernel: [  814.910882] gspca: poll
>> ...
>> Jan 29 10:35:09 linux kernel: [  818.470778] gspca: kill transfer
>> Jan 29 10:35:09 linux kernel: [  818.470822] gspca: stream off OK
>> Jan 29 10:35:09 linux kernel: [  818.470884] gspca: [svv] close
>> Jan 29 10:35:09 linux kernel: [  818.470887] gspca: frame free
>> Jan 29 10:35:09 linux kernel: [  818.470923] gspca: close done
>> 
>> 
>> *** successful try ***********************************
>> Jan 29 10:52:17 linux kernel: [ 1847.317518] gspca: probing 0979:0280
>> Jan 29 10:52:17 linux kernel: [ 1847.317526] jeilinj: JEILINJ camera 
>> detected (vid/pid 0x0979:0x0280)
>> Jan 29 10:52:17 linux kernel: [ 1847.317613] gspca: video1 created
>> Jan 29 10:52:17 linux kernel: [ 1847.317630] usbcore: registered new 
>> interface driver jeilinj
>> Jan 29 10:52:17 linux kernel: [ 1847.317634] jeilinj: registered
>> Jan 29 10:52:17 linux kernel: [ 1847.382078] gspca: [hald-probe-vide] open
>> Jan 29 10:52:17 linux kernel: [ 1847.382086] gspca: open done
>> Jan 29 10:52:17 linux kernel: [ 1847.383164] gspca: [hald-probe-vide] close
>> Jan 29 10:52:17 linux kernel: [ 1847.383169] gspca: close done
>> Jan 29 10:52:20 linux kernel: [ 1849.717763] gspca: [svv] open
>> Jan 29 10:52:20 linux kernel: [ 1849.717768] gspca: open done
>> Jan 29 10:52:20 linux kernel: [ 1849.717909] gspca: try fmt cap JPEG 640x480
>> Jan 29 10:52:20 linux kernel: [ 1849.717915] gspca: try fmt cap JPEG 320x240
>> Jan 29 10:52:20 linux kernel: [ 1849.718103] gspca: frame alloc frsz: 76800
>> Jan 29 10:52:20 linux kernel: [ 1849.718334] gspca: reqbufs st:0 c:4
>> Jan 29 10:52:20 linux kernel: [ 1849.718358] gspca: mmap start:b8064000 
>> size:77824
>> Jan 29 10:52:20 linux kernel: [ 1849.718379] gspca: mmap start:b73b3000 
>> size:77824
>> Jan 29 10:52:20 linux kernel: [ 1849.718391] gspca: mmap start:b73a0000 
>> size:77824
>> Jan 29 10:52:20 linux kernel: [ 1849.718404] gspca: mmap start:b738d000 
>> size:77824
>> Jan 29 10:52:20 linux kernel: [ 1849.718477] gspca: qbuf 0
>> Jan 29 10:52:20 linux kernel: [ 1849.718480] gspca: qbuf q:1 i:0 o:0
>> Jan 29 10:52:20 linux kernel: [ 1849.718482] gspca: qbuf 1
>> Jan 29 10:52:20 linux kernel: [ 1849.718484] gspca: qbuf q:2 i:0 o:0
>> Jan 29 10:52:20 linux kernel: [ 1849.718486] gspca: qbuf 2
>> Jan 29 10:52:20 linux kernel: [ 1849.718488] gspca: qbuf q:3 i:0 o:0
>> Jan 29 10:52:20 linux kernel: [ 1849.718490] gspca: qbuf 3
>> Jan 29 10:52:20 linux kernel: [ 1849.718491] gspca: qbuf q:0 i:0 o:0
>> Jan 29 10:52:20 linux kernel: [ 1849.718496] gspca: use alt 0 ep 0x01
>> Jan 29 10:52:20 linux kernel: [ 1849.718547] gspca: init transfer alt 0
>> Jan 29 10:52:20 linux kernel: [ 1849.718549] gspca: bulk bsize:32
>> Jan 29 10:52:20 linux kernel: [ 1849.718687] jeilinj: Start streaming at 
>> 320x240
>> Jan 29 10:52:20 linux kernel: [ 1849.726018] jeilinj: jlj_start retval is 0
>> Jan 29 10:52:20 linux kernel: [ 1849.726080] gspca: stream on OK JPEG 
>> 320x240
>> 
>


-- 
Mit freundlichen Grüssen
Matthias Huber Kohlstattstr. 14
86459 Wollishausen
Tel: 08238-7998
LPI000181125
---863829203-561907752-1264964074=:26120--
