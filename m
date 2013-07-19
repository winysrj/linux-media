Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60697 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760014Ab3GSMBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 08:01:38 -0400
Message-ID: <51E92A78.50706@iki.fi>
Date: Fri, 19 Jul 2013 15:00:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Taegert <jantaegert@gmx.net>
CC: linux-media@vger.kernel.org, thomas.mair86@googlemail.com
Subject: Re: PROBLEM: dvb-usb-rtl28xxu and Terratec Cinergy TStickRC (rev3)
 - no signal on some frequencies
References: <51E927EC.5030701@gmx.net>
In-Reply-To: <51E927EC.5030701@gmx.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
It is e4000 driver problem. Someone should take the look what there is 
wrong. Someone sent non-working stick for me, but I wasn't able to 
reproduce issue. I used modulator to generate signal with just same 
parameters he said non-working, but it worked for me. It looks like 
e4000 driver does not perform as well as it should.

Maybe I should take Windows XP and Linux, use modulator to find out 
signal condition where Windows works but Linux not, took sniffs and 
compare registers... But I am busy and help is more than welcome.

regards
Antti



On 07/19/2013 02:50 PM, Jan Taegert wrote:
> [1.] One line summary of the problem:
> Kernel 3.8.x and later - DVB-T-USB-Device with module dvb-usb-rtl28xxu -
> doesn't get signal on some frequencies
>
> [2.] Full description of the problem/report:
> I am using a Terratec CinergyTStickRC (rev3), it's a usb-dvbt-device
> with device-id: 0ccd:00d3.
> Usually I am looking TV with vlc and use a channels.conf with 12
> channels, of which each four use the same frequency: 538 MHz, 594 MHz
> and 618 MHz. I am able to switch to and between the 4 channels of the
> first frequency-set on 538 Mhz, but the other frequencies don't work.
>
> I tried the kernel-images 3.9 and 3.10 from the ubuntu mainline
> kernelpage, but found the same misbehaviour as described above.
> Maybe the signal of this channels is too weak. However, I can't
> remember, ever to have got a signal.
>
> Also, the device and all channels worked perfectly with the
> older 3.5-kernel which I've used before Ubuntu 13.04 switched to version
> 3.8, and a driver I found on [
> https://github.com/valtri/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0
> ]. I used the same hardware and software setup, the only difference was
> the kernel and the driver.
>
> So, as I hope, that it is a driver problem (and my antenna strong
> enough), maybe the reason for my problem can be found in the difference
> between the two driver sources.
>
> I gathered some information from userspace as I didn't know
> how to debug this problem otherwise:
> Under [8.] I attached
> - the channels.conf
> - the dmesg output
> - the usb device information,
> - the output of `tzap` switching to the 3 different frequencies and
> - the output of `dvbsnoop -s feinfo` while watching the channel and
> after plugging in the device,
> all sorted by kernelversion.
>
>
> Please give me some advice, if I can provide other informations which
> help.
>
> Thanks in advance,
>
> Jan Sieber-Taegert.
>
>
>
> [3.] Keywords (i.e., modules, networking, kernel):
> modules, dvb, usb
>
> [4.] Kernel version (from /proc/version):
> # 3.8 kernel (all other infos - if not named otherwise - belong to this
> version):
> Linux version 3.8.0-26-generic (buildd@lamiak) (gcc version 4.7.3
> (Ubuntu/Linaro 4.7.3-1ubuntu1) ) #38-Ubuntu SMP Mon Jun 17 21:46:08 UTC
> 2013
>
> # 3.5 kernel:
> Linux version 3.5.0-36-generic (buildd@batsu) (gcc version 4.7.2
> (Ubuntu/Linaro 4.7.2-2ubuntu1) ) #57-Ubuntu SMP Wed Jun 19 15:11:05 UTC
> 2013
>
> [5.] Output of Oops.. message (if applicable) with symbolic information
>       resolved (see Documentation/oops-tracing.txt)
> [6.] A small shell script or example program which triggers the
>       problem (if possible)
>
> [7.] Environment
> [7.1.] Software (add the output of the ver_linux script here)
> Linux t60 3.8.0-26-generic #38-Ubuntu SMP Mon Jun 17 21:46:08 UTC 2013
> i686 i686 i686 GNU/Linux
>
> Gnu C                  4.7
> Gnu make               3.81
> binutils               2.23.2
> util-linux             2.20.1
> mount                  support
> module-init-tools      9
> e2fsprogs              1.42.5
> pcmciautils            018
> PPP                    2.4.5
> Linux C Library        2.17
> Dynamic linker (ldd)   2.17
> Procps                 3.3.3
> Net-tools              1.60
> Kbd                    1.15.5
> Sh-utils               8.20
> wireless-tools         30
> Modules Loaded         e4000 rtl2832 dvb_usb_rtl28xxu rtl2830 dvb_usb_v2
> dvb_core rc_core parport_pc ppdev rfcomm bnep binfmt_misc btusb
> bluetooth arc4 snd_hda_codec_analog pcmcia snd_hda_intel snd_hda_codec
> iwldvm coretemp thinkpad_acpi snd_hwdep snd_pcm nvram snd_page_alloc
> snd_seq_midi snd_seq_midi_event mac80211 snd_rawmidi yenta_socket kvm
> snd_seq pcmcia_rsrc joydev snd_seq_device pcmcia_core hdaps
> input_polldev iwlwifi irda snd_timer lp crc_ccitt dm_multipath parport
> lpc_ich snd cfg80211 psmouse scsi_dh serio_raw microcode soundcore
> mac_hid radeon ahci libahci i2c_algo_bit ttm e1000e drm_kms_helper drm
> video
>
> [7.2.] Processor information (from /proc/cpuinfo):
>
> [7.3.] Module information (from /proc/modules):
> e4000 12862 1 - Live 0x00000000
> rtl2832 13312 1 - Live 0x00000000
> dvb_usb_rtl28xxu 18737 0 - Live 0x00000000
> rtl2830 13511 1 dvb_usb_rtl28xxu, Live 0x00000000
> dvb_usb_v2 22916 1 dvb_usb_rtl28xxu, Live 0x00000000
> dvb_core 90402 3 rtl2832,rtl2830,dvb_usb_v2, Live 0x00000000
> rc_core 21266 3 dvb_usb_rtl28xxu,dvb_usb_v2, Live 0x00000000
> parport_pc 27504 0 - Live 0x00000000 (F)
> ppdev 12817 0 - Live 0x00000000 (F)
> rfcomm 37420 0 - Live 0x00000000
> bnep 17669 2 - Live 0x00000000
> binfmt_misc 17260 1 - Live 0x00000000 (F)
> btusb 17986 0 - Live 0x00000000
> bluetooth 202069 11 rfcomm,bnep,btusb, Live 0x00000000
> arc4 12543 2 - Live 0x00000000 (F)
> snd_hda_codec_analog 75266 1 - Live 0x00000000
> pcmcia 39544 0 - Live 0x00000000
> snd_hda_intel 38307 2 - Live 0x00000000
> snd_hda_codec 117580 2 snd_hda_codec_analog,snd_hda_intel, Live 0x00000000
> iwldvm 220215 0 - Live 0x00000000
> coretemp 13131 0 - Live 0x00000000
> thinkpad_acpi 69384 0 - Live 0x00000000
> snd_hwdep 13272 1 snd_hda_codec, Live 0x00000000 (F)
> snd_pcm 80890 2 snd_hda_intel,snd_hda_codec, Live 0x00000000 (F)
> nvram 13986 1 thinkpad_acpi, Live 0x00000000 (F)
> snd_page_alloc 14230 2 snd_hda_intel,snd_pcm, Live 0x00000000 (F)
> snd_seq_midi 13132 0 - Live 0x00000000 (F)
> snd_seq_midi_event 14475 1 snd_seq_midi, Live 0x00000000 (F)
> mac80211 526519 1 iwldvm, Live 0x00000000
> snd_rawmidi 25114 1 snd_seq_midi, Live 0x00000000 (F)
> yenta_socket 27095 0 - Live 0x00000000
> kvm 376505 0 - Live 0x00000000
> snd_seq 51280 2 snd_seq_midi,snd_seq_midi_event, Live 0x00000000 (F)
> pcmcia_rsrc 18191 1 yenta_socket, Live 0x00000000
> joydev 17097 0 - Live 0x00000000 (F)
> snd_seq_device 14137 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x00000000
> (F)
> pcmcia_core 21505 3 pcmcia,yenta_socket,pcmcia_rsrc, Live 0x00000000
> hdaps 13735 0 - Live 0x00000000
> input_polldev 13648 1 hdaps, Live 0x00000000
> iwlwifi 155077 1 iwldvm, Live 0x00000000
> irda 107316 0 - Live 0x00000000 (F)
> snd_timer 24411 2 snd_pcm,snd_seq, Live 0x00000000 (F)
> lp 13299 0 - Live 0x00000000 (F)
> crc_ccitt 12627 1 irda, Live 0x00000000 (F)
> dm_multipath 22402 0 - Live 0x00000000 (F)
> parport 40753 3 parport_pc,ppdev,lp, Live 0x00000000 (F)
> lpc_ich 16925 0 - Live 0x00000000
> snd 56485 14
> snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,thinkpad_acpi,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
> Live 0x00000000 (F)
> cfg80211 436177 3 iwldvm,mac80211,iwlwifi, Live 0x00000000
> psmouse 81038 0 - Live 0x00000000 (F)
> scsi_dh 14427 1 dm_multipath, Live 0x00000000 (F)
> serio_raw 13031 0 - Live 0x00000000 (F)
> microcode 18286 0 - Live 0x00000000 (F)
> soundcore 12600 1 snd, Live 0x00000000 (F)
> mac_hid 13037 0 - Live 0x00000000
> radeon 875070 3 - Live 0x00000000
> ahci 25507 4 - Live 0x00000000 (F)
> libahci 26108 1 ahci, Live 0x00000000 (F)
> i2c_algo_bit 13197 1 radeon, Live 0x00000000
> ttm 71289 1 radeon, Live 0x00000000
> e1000e 174556 0 - Live 0x00000000 (F)
> drm_kms_helper 47545 1 radeon, Live 0x00000000
> drm 228489 5 radeon,ttm,drm_kms_helper, Live 0x00000000
> video 18894 0 - Live 0x00000000 (F)
>
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
> [7.5.] PCI information ('lspci -vvv' as root)
> [7.6.] SCSI information (from /proc/scsi/scsi)
> [7.7.] Other information that might be relevant to the problem
>         (please look in /proc and include all information that you
>         think to be relevant):
>
> [8.] Other notes, patches, fixes, workarounds:
> # channels.conf:
> MDR:538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1553:1554:97
>
> rbb:538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:2833:2834:177
>
> WDR:538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:4193:4194:262
>
> BR:538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:529:530:33
>
> ZDF:594000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:545:546:514
>
> 3sat:594000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:561:562:515
>
> ZDFinfo:594000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:577:578:516
>
> neo_und_KiKA:594000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:593:594:517
>
> ARD:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1537:1538:96
>
> Einsfestival:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:81:82:5
>
> arte:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:33:34:2
>
> PHOENIX:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:49:50:3
>
>
> # kernel 3.8.0-26-generic - dmesg output (after plugging in the device):
> [  522.836098] usb 1-2: new high-speed USB device number 4 using ehci-pci
> [  522.980188] usb 1-2: New USB device found, idVendor=0ccd, idProduct=00d3
> [  522.980198] usb 1-2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [  522.980205] usb 1-2: Product: RTL2838UHIDIR
> [  522.980211] usb 1-2: Manufacturer: Realtek
> [  522.980217] usb 1-2: SerialNumber: 00000001
> [  523.435002] usbcore: registered new interface driver dvb_usb_rtl28xxu
> [  523.435463] usb 1-2: dvb_usb_v2: found a 'TerraTec Cinergy T Stick RC
> (Rev. 3)' in warm state
> [  523.496664] usb 1-2: dvb_usb_v2: will pass the complete MPEG2
> transport stream to the software demuxer
> [  523.496697] DVB: registering new adapter (TerraTec Cinergy T Stick RC
> (Rev. 3))
> [  523.636436] usb 1-2: DVB: registering adapter 0 frontend 0 (Realtek
> RTL2832 (DVB-T))...
> [  523.688163] i2c i2c-7: e4000: Elonics E4000 successfully identified
> [  523.698920] Registered IR keymap rc-empty
> [  523.699033] input: TerraTec Cinergy T Stick RC (Rev. 3) as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-2/rc/rc0/input9
> [  523.699125] rc0: TerraTec Cinergy T Stick RC (Rev. 3) as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-2/rc/rc0
> [  523.699131] usb 1-2: dvb_usb_v2: schedule remote query interval to
> 400 msecs
> [  523.713531] usb 1-2: dvb_usb_v2: 'TerraTec Cinergy T Stick RC (Rev.
> 3)' successfully initialized and connected
>
> # kernel 3.5.0-36-generic - dmesg output (after plugging in the device):
> [  128.132094] usb 1-2: new high-speed USB device number 4 using ehci_hcd
> [  128.275950] usb 1-2: New USB device found, idVendor=0ccd, idProduct=00d3
> [  128.275957] usb 1-2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [  128.275961] usb 1-2: Product: RTL2838UHIDIR
> [  128.275964] usb 1-2: Manufacturer: Realtek
> [  128.275968] usb 1-2: SerialNumber: 00000001
> [  128.438775] dvb-usb: found a 'USB DVB-T Device' in warm state.
> [  128.438790] dvb-usb: will pass the complete MPEG2 transport stream to
> the software demuxer.
> [  128.440466] DVB: registering new adapter (USB DVB-T Device)
> [  128.456932] RTL2832U usb_init_bulk_setting : USB2.0 HIGH SPEED (480Mb/s)
> [  128.700151] RTL2832U check_tuner_type : E4000 tuner on board...
> [  129.265217] DVB: registering adapter 0 frontend 0 (Realtek DVB-T
> RTL2832)...
> [  129.265427] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-2/input/input10
> [  129.266729] dvb-usb: schedule remote query interval to 287 msecs.
> [  129.266735] dvb-usb: USB DVB-T Device successfully initialized and
> connected.
> [  129.266785] usbcore: registered new interface driver dvb_usb_rtl2832u
>
> # kernel 3.8.0-26-generic - USB information
> Bus 001 Device 004: ID 0ccd:00d3 TerraTec Electronic GmbH
> Couldn't open device, some information will be missing
> Device Descriptor:
>    bLength                18
>    bDescriptorType         1
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    idVendor           0x0ccd TerraTec Electronic GmbH
>    idProduct          0x00d3
>    bcdDevice            1.00
>    iManufacturer           1
>    iProduct                2
>    iSerial                 3
>    bNumConfigurations      1
>    Configuration Descriptor:
>      bLength                 9
>      bDescriptorType         2
>      wTotalLength           34
>      bNumInterfaces          2
>      bConfigurationValue     1
>      iConfiguration          4
>      bmAttributes         0x80
>        (Bus Powered)
>      MaxPower              500mA
>      Interface Descriptor:
>        bLength                 9
>        bDescriptorType         4
>        bInterfaceNumber        0
>        bAlternateSetting       0
>        bNumEndpoints           1
>        bInterfaceClass       255 Vendor Specific Class
>        bInterfaceSubClass    255 Vendor Specific Subclass
>        bInterfaceProtocol    255 Vendor Specific Protocol
>        iInterface              5
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x81  EP 1 IN
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
>      Interface Descriptor:
>        bLength                 9
>        bDescriptorType         4
>        bInterfaceNumber        1
>        bAlternateSetting       0
>        bNumEndpoints           0
>        bInterfaceClass       255 Vendor Specific Class
>        bInterfaceSubClass    255 Vendor Specific Subclass
>        bInterfaceProtocol    255 Vendor Specific Protocol
>        iInterface              5
>
> # kernel 3.5.0-36-generic - USB information
> Bus 001 Device 011: ID 0ccd:00d3 TerraTec Electronic GmbH
> Device Descriptor:
>    bLength                18
>    bDescriptorType         1
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    idVendor           0x0ccd TerraTec Electronic GmbH
>    idProduct          0x00d3
>    bcdDevice            1.00
>    iManufacturer           1 Realtek
>    iProduct                2 RTL2838UHIDIR
>    iSerial                 3 00000001
>    bNumConfigurations      1
>    Configuration Descriptor:
>      bLength                 9
>      bDescriptorType         2
>      wTotalLength           34
>      bNumInterfaces          2
>      bConfigurationValue     1
>      iConfiguration          4 USB2.0-Bulk&Iso
>      bmAttributes         0x80
>        (Bus Powered)
>      MaxPower              500mA
>      Interface Descriptor:
>        bLength                 9
>        bDescriptorType         4
>        bInterfaceNumber        0
>        bAlternateSetting       0
>        bNumEndpoints           1
>        bInterfaceClass       255 Vendor Specific Class
>        bInterfaceSubClass    255 Vendor Specific Subclass
>        bInterfaceProtocol    255 Vendor Specific Protocol
>        iInterface              5 Bulk-In, Interface
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x81  EP 1 IN
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
>      Interface Descriptor:
>        bLength                 9
>        bDescriptorType         4
>        bInterfaceNumber        1
>        bAlternateSetting       0
>        bNumEndpoints           0
>        bInterfaceClass       255 Vendor Specific Class
>        bInterfaceSubClass    255 Vendor Specific Subclass
>        bInterfaceProtocol    255 Vendor Specific Protocol
>        iInterface              5 Bulk-In, Interface
> Device Qualifier (for other device speed):
>    bLength                10
>    bDescriptorType         6
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    bNumConfigurations      2
> Device Status:     0x0000
>    (Bus Powered)
>
>
>
> # kernel 3.8.0-26-generic - output of: tzap -c channels.conf -t 10 MDR
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 538000000 Hz
> video pid 0x0611, audio pid 0x0612
> status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc b776ab48 |
> status 1f | signal bf9e | snr 0106 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal bf9e | snr 0101 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal bf9e | snr 00f8 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal bf9e | snr 00fa | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal bf9e | snr 00fc | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal bf9e | snr 00fb | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal bf9e | snr 00fe | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal bf9e | snr 00fa | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal bf9e | snr 00ee | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal bf9e | snr 00f5 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> reading channels from file 'channels.conf'
>
> # kernel 3.8.0-26-generic - output of: 'dvbsnoop -s feinfo' while
> watching MDR [shortened]
> Current parameters:
>      Frequency:  538000.000 kHz
>      Inversion:  OFF
>      Bandwidth:  8 MHz
>      Stream code rate (hi prio):  FEC 2/3
>      Stream code rate (lo prio):  FEC 1/2
>      Modulation:  QAM 64
>      Transmission mode:  8k mode
>      Guard interval:  1/4
>      Hierarchy:  none
>
> # kernel 3.5.0-36-generic - output of: tzap -c channels.conf -t 10 MDR
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 538000000 Hz
> video pid 0x0611, audio pid 0x0612
> status 1f | signal 3737 | snr dcaf | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr ee57 | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr f72b | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr ee57 | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr f72b | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr ee57 | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr f72b | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr f72b | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr f72b | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr ee57 | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> reading channels from file 'channels.conf'
>
> # kernel 3.5.0-36-generic - output of: 'dvbsnoop -s feinfo' while
> watching MDR [shortened]
> Current parameters:
>      Frequency:  538000.000 kHz
>      Inversion:  OFF
>      Bandwidth:  8 MHz
>      Stream code rate (hi prio):  FEC 2/3
>      Stream code rate (lo prio):  FEC AUTO
>      Modulation:  QAM 64
>      Transmission mode:  8k mode
>      Guard interval:  1/4
>      Hierarchy:  none
>
>
>
> # kernel 3.8.0-26-generic - output of: tzap -c channels.conf -t 10 ZDF
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 594000000 Hz
> video pid 0x0221, audio pid 0x0222
> status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc b76eab48 |
> status 00 | signal bf91 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bf91 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bf91 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bf91 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bf91 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bf91 | snr 0089 | ber 00004ca0 | unc 00000000 |
> status 00 | signal bf91 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bf91 | snr 005a | ber 00004ca0 | unc 00000000 |
> status 00 | signal bf91 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bf91 | snr 0000 | ber 0000ffff | unc 00000000 |
> reading channels from file 'channels.conf'
>
> # kernel 3.8.0-26-generic - output of: 'dvbsnoop -s feinfo' while
> watching ZDF [shortened]
> Current parameters:
>      Frequency:  594000.000 kHz
>      Inversion:  AUTO
>      Bandwidth:  8 MHz
>      Stream code rate (hi prio):  FEC 1/2
>      Stream code rate (lo prio):  FEC 1/2
>      Modulation:  QPSK
>      Transmission mode:  8k mode
>      Guard interval:  1/16
>      Hierarchy:  none
>
> # kernel 3.5.0-36-generic - output of: tzap -c channels.conf -t 10 ZDF
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 594000000 Hz
> video pid 0x0221, audio pid 0x0222
> status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 1f | signal 3737 | snr b13a | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr f626 | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr ec4d | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr f626 | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr ec4d | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr f626 | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr f626 | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr ec4d | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> reading channels from file 'channels.conf'
>
> # kernel 3.5.0-36-generic - output of: 'dvbsnoop -s feinfo' while
> watching ZDF [shortened]
> Current parameters:
>      Frequency:  594000.000 kHz
>      Inversion:  OFF
>      Bandwidth:  8 MHz
>      Stream code rate (hi prio):  FEC 2/3
>      Stream code rate (lo prio):  FEC AUTO
>      Modulation:  QAM 16
>      Transmission mode:  8k mode
>      Guard interval:  1/4
>      Hierarchy:  none
>
>
>
> # kernel 3.8.0-26-generic - output of: tzap -c channels.conf -t 10 ARD
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 618000000 Hz
> video pid 0x0601, audio pid 0x0602
> status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc b7722b48 |
> status 00 | signal bfa0 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bfa0 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bfa0 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bfa0 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bfa0 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bfa0 | snr 0082 | ber 00004ca0 | unc 00000000 |
> status 00 | signal bfa0 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bfa0 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bfa0 | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal bfa0 | snr 0000 | ber 0000ffff | unc 00000000 |
> reading channels from file 'channels.conf'
>
> # kernel 3.8.0-26-generic - output of: 'dvbsnoop -s feinfo' while
> watching ARD [shortened]
> Current parameters:
>      Frequency:  618000.000 kHz
>      Inversion:  AUTO
>      Bandwidth:  8 MHz
>      Stream code rate (hi prio):  FEC 1/2
>      Stream code rate (lo prio):  FEC 1/2
>      Modulation:  QPSK
>      Transmission mode:  8k mode
>      Guard interval:  1/16
>      Hierarchy:  none
>
> # kernel 3.5.0-36-generic - output of: tzap -c channels.conf -t 10 ARD
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 618000000 Hz
> video pid 0x0601, audio pid 0x0602
> status 00 | signal 0000 | snr 08d3 | ber 0000ffff | unc 00000000 |
> status 1f | signal 3737 | snr a7b8 | ber 0000252e | unc 0000000a |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr dcaf | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr e583 | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr e583 | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr d3db | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr d3db | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr dcaf | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr dcaf | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> status 1f | signal 3737 | snr dcaf | ber 00000000 | unc 00000064 |
> FE_HAS_LOCK
> reading channels from file 'channels.conf'
>
> # kernel 3.5.0-36-generic - output of: 'dvbsnoop -s feinfo' while
> watching ARD [shortened]
> Current parameters:
>      Frequency:  618000.000 kHz
>      Inversion:  OFF
>      Bandwidth:  8 MHz
>      Stream code rate (hi prio):  FEC 2/3
>      Stream code rate (lo prio):  FEC AUTO
>      Modulation:  QAM 64
>      Transmission mode:  8k mode
>      Guard interval:  1/4
>      Hierarchy:  none
>
>
>
> # kernel 3.8.0-26-generic - output of: 'dvbsnoop -s feinfo' after
> plugging in the device
> dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/
>
> ---------------------------------------------------------
> FrontEnd Info...
> ---------------------------------------------------------
>
> Device: /dev/dvb/adapter0/frontend0
>
> Basic capabilities:
>      Name: "Realtek RTL2832 (DVB-T)"
>      Frontend-type:       OFDM (DVB-T)
>      Frequency (min):     174000.000 kHz
>      Frequency (max):     862000.000 kHz
>      Frequency stepsiz:   166.667 kHz
>      Frequency tolerance: 0.000 kHz
>      Symbol rate (min):     0.000000 MSym/s
>      Symbol rate (max):     0.000000 MSym/s
>      Symbol rate tolerance: 0 ppm
>      Notifier delay: 0 ms
>      Frontend capabilities:
>          auto inversion
>          FEC 1/2
>          FEC 2/3
>          FEC 3/4
>          FEC 5/6
>          FEC 7/8
>          FEC AUTO
>          QPSK
>          QAM 16
>          QAM 64
>          QAM AUTO
>          auto transmission mode
>          auto guard interval
>          auto hierarchy
>
> Current parameters:
>      Frequency:  0.000 kHz
>      Inversion:  OFF
>      Bandwidth:  AUTO
>      Stream code rate (hi prio):  FEC AUTO
>      Stream code rate (lo prio):  FEC AUTO
>      Modulation:  QAM AUTO
>      Transmission mode:  auto
>      Guard interval:  auto
>      Hierarchy:  auto
>
> # kernel 3.5.0-36-generic - output of: 'dvbsnoop -s feinfo' after
> plugging in the device
> dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/
>
> ---------------------------------------------------------
> FrontEnd Info...
> ---------------------------------------------------------
>
> Device: /dev/dvb/adapter0/frontend0
>
> Basic capabilities:
>      Name: "Realtek DVB-T RTL2832"
>      Frontend-type:       OFDM (DVB-T)
>      Frequency (min):     50000.000 kHz
>      Frequency (max):     862000.000 kHz
>      Frequency stepsiz:   166.667 kHz
>      Frequency tolerance: 0.000 kHz
>      Symbol rate (min):     0.000000 MSym/s
>      Symbol rate (max):     0.000000 MSym/s
>      Symbol rate tolerance: 0 ppm
>      Notifier delay: 0 ms
>      Frontend capabilities:
>          auto inversion
>          FEC 1/2
>          FEC 2/3
>          FEC 3/4
>          FEC 5/6
>          FEC 7/8
>          FEC AUTO
>          QPSK
>          QAM 16
>          QAM 64
>          QAM AUTO
>          auto transmission mode
>          auto guard interval
>          auto hierarchy
>
> Current parameters:
>      Frequency:  0.000 kHz
>      Inversion:  OFF
>      Bandwidth:  AUTO
>      Stream code rate (hi prio):  FEC AUTO
>      Stream code rate (lo prio):  FEC AUTO
>      Modulation:  QAM AUTO
>      Transmission mode:  auto
>      Guard interval:  auto
>      Hierarchy:  auto
>


-- 
http://palosaari.fi/
