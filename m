Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33053 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbbFJS4w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 14:56:52 -0400
Received: by iebgx4 with SMTP id gx4so40623240ieb.0
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2015 11:56:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5578728A.4020106@gmail.com>
References: <5578728A.4020106@gmail.com>
Date: Wed, 10 Jun 2015 20:56:51 +0200
Message-ID: <CAAZRmGyXwFQL4_R8bknr=NH=t2enLTS1eYOsbtfZBNQ7OV12cA@mail.gmail.com>
Subject: Re: Hauppauge 2250 on Ubuntu 15.04
From: Olli Salonen <olli.salonen@iki.fi>
To: Jeff Allen <worthspending@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jeff,

Based on the PCI subsystem ID I think your card is actually HVR-2255
and not the older HVR-2250. Check what it says on the card. Some
people have reported buying a HVR-2250, but receiving actually a
HVR-2255.

Anyway, HVR-2255 is supported by the media_tree these days, but you
need to build the driver yourself before kernel 4.2 is out. Follow the
steps here to do that:
http://git.linuxtv.org/cgit.cgi/media_build.git/about/

Cheers,
-olli

On 10 June 2015 at 19:23, Jeff Allen <worthspending@gmail.com> wrote:
> I am trying to get the firmware to load on a fresh install of Ubuntu 15.04
> desktop 64-bit on a new system.
>
> uname -a
> Linux 3.19.0-15-generic #15-Ubuntu SMP Thu Apr 16 23:32:37 UTC 2015 x86_64
> x86_64 x86_64 GNU/Linux
>
> lshw
>     description: Computer
>     width: 64 bits
>     capabilities: smbios-2.7 vsyscall32
>   *-core
>        description: Motherboard
>        physical id: 0
>      *-memory
>           description: System memory
>           physical id: 0
>           size: 7884MiB
>      *-cpu
>           product: AMD FX(tm)-8320 Eight-Core Processor
>           vendor: Advanced Micro Devices [AMD]
>           physical id: 1
>           bus info: cpu@0
>           size: 1400MHz
>           capacity: 3500MHz
>           width: 64 bits
>           capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8
> apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx
> mmxext fxsr_opt pdpe1gb rdtscp x86-64 constant_tsc rep_good nopl nonstop_tsc
> extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2
> popcnt aes xsave avx f16c lahf_lm cmp_legacy svm extapic cr8_legacy abm
> sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce
> nodeid_msr tbm topoext perfctr_core perfctr_nb arat cpb hw_pstate npt lbrv
> svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists
> pausefilter pfthreshold vmmcall bmi1 cpufreq
>
> I have tried for a few hours now.  Many combinations / suggestions from the
> documentation, forum posts, etc.  The most recent attempts were made with
> another fresh install of Ubuntu 15.04 and following the instructions at the
> following link:
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2250
>
> Here is what I did on my last attempt after the fresh install.
>
> sudo lshw -C multimedia
>   *-multimedia
>        description: Multimedia controller
>        product: SAA7164
>        vendor: Philips Semiconductors
>        physical id: 0
>        bus info: pci@0000:05:00.0
>        version: 81
>        width: 64 bits
>        clock: 33MHz
>        capabilities: msi pciexpress pm bus_master cap_list
>        configuration: driver=saa7164 latency=0
>        resources: irq:47 memory:fe000000-fe3fffff memory:fdc00000-fdffffff
>
> dmesg | grep 7164
>
> [    0.000000] On node 0 totalpages: 2071641
> [    0.530288] pci 0000:05:00.0: [1131:7164] type 00 class 0x048000
> [    5.977865] saa7164 driver loaded
> [    5.977973] saa7164[0]: Your board isn't known (yet) to the driver.
> saa7164[0]: Try to pick one of the existing card configs via
> saa7164[0]: card=<n> insmod option.  Updating to the latest
> saa7164[0]: version might help as well.
> [    5.977976] saa7164[0]: Here are valid choices for the card=<n> insmod
> option:
> [    5.977977] saa7164[0]:    card=0 -> Unknown
> [    5.977978] saa7164[0]:    card=1 -> Generic Rev2
> [    5.977979] saa7164[0]:    card=2 -> Generic Rev3
> [    5.977981] saa7164[0]:    card=3 -> Hauppauge WinTV-HVR2250
> [    5.977981] saa7164[0]:    card=4 -> Hauppauge WinTV-HVR2200
> [    5.977982] saa7164[0]:    card=5 -> Hauppauge WinTV-HVR2200
> [    5.977983] saa7164[0]:    card=6 -> Hauppauge WinTV-HVR2200
> [    5.977984] saa7164[0]:    card=7 -> Hauppauge WinTV-HVR2250
> [    5.977985] saa7164[0]:    card=8 -> Hauppauge WinTV-HVR2250
> [    5.977986] saa7164[0]:    card=9 -> Hauppauge WinTV-HVR2200
> [    5.977987] saa7164[0]:    card=10 -> Hauppauge WinTV-HVR2200
> [    5.978018] CORE saa7164[0]: subsystem: 0070:f111, board: Unknown
> [card=0,autodetected]
> [    5.978021] saa7164[0]/0: found at 0000:05:00.0, rev: 129, irq: 47,
> latency: 0, mmio: 0xfe000000
> [    5.978037] saa7164_initdev() Unsupported board detected, registering
> without firmware
>
>
> - created a file at: /etc/modprobe.d/saa7164.conf with the following
> contents
>
>   options saa7164 card=8
>
> - downloaded the firmware and copied it to /lib/firmware
>
>   wget
> http://www.steventoth.net/linux/hvr22xx/firmwares/4019072/NXP7164-2010-03-10.1.fw
>   cp *.fw /lib/firmware
>
> -  reboot
>
> - after reboot
>
> dmesg | grep 7164
>
> [    0.000000] On node 0 totalpages: 2071641
> [    0.530265] pci 0000:05:00.0: [1131:7164] type 00 class 0x048000
> [    1.571643] device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised:
> dm-devel@redhat.com
> [    6.584365] saa7164 driver loaded
> [    6.584503] CORE saa7164[0]: subsystem: 0070:f111, board: Hauppauge
> WinTV-HVR2250 [card=8,insmod option]
> [    6.584506] saa7164[0]/0: found at 0000:05:00.0, rev: 129, irq: 47,
> latency: 0, mmio: 0xfe000000
> [    6.758475] saa7164_downloadfirmware() no first image
> [    6.758483] saa7164_downloadfirmware() Waiting for firmware upload
> (NXP7164-2010-03-10.1.fw)
> [    6.836305] saa7164 0000:05:00.0: Direct firmware load for
> NXP7164-2010-03-10.1.fw failed with error -2
> [    6.836309] saa7164_downloadfirmware() Upload failed. (file not found?)
> [    0.000000] On node 0 totalpages: 2071641
> [    0.530263] pci 0000:05:00.0: [1131:7164] type 00 class 0x048000
> [    6.372707] saa7164 driver loaded
> [    6.372835] CORE saa7164[0]: subsystem: 0070:f111, board: Hauppauge
> WinTV-HVR2250 [card=8,insmod option]
> [    6.372838] saa7164[0]/0: found at 0000:05:00.0, rev: 129, irq: 47,
> latency: 0, mmio: 0xfe000000
> [    6.530496] saa7164_downloadfirmware() no first image
> [    6.530505] saa7164_downloadfirmware() Waiting for firmware upload
> (NXP7164-2010-03-10.1.fw)
> [    6.899014] saa7164_downloadfirmware() firmware read 4019072 bytes.
> [    6.899017] saa7164_downloadfirmware() firmware loaded.
> [    6.899022] saa7164_downloadfirmware() SecBootLoader.FileSize = 4019072
> [    6.899027] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
> [    6.899028] saa7164_downloadfirmware() BSLSize = 0x0
> [    6.899029] saa7164_downloadfirmware() Reserved = 0x0
> [    6.899030] saa7164_downloadfirmware() Version = 0x1661c00
> [   13.650943] saa7164_downloadimage() Image downloaded, booting...
> [   13.754950] saa7164_downloadimage() Image booted successfully.
> [   16.395094] saa7164_downloadimage() Image downloaded, booting...
> [   18.267203] saa7164_downloadimage() Image booted successfully.
> [   18.316076] saa7164[0]: Warning: Unknown Hauppauge model #0
> [   18.316078] saa7164[0]: Hauppauge eeprom: model=0
> [   18.380192] saa7164_dvb_register() Frontend initialization failed
> [   18.380195] saa7164_initdev() Failed to register dvb adapters on porta
> [   18.383340] saa7164_api_i2c_read() error, ret(2) = 0x9
> [   18.383347] saa7164_dvb_register() Frontend initialization failed
> [   18.383348] saa7164_initdev() Failed to register dvb adapters on portb
> [   18.383411] saa7164[0]: registered device video0 [mpeg]
> [   18.618462] saa7164[0]: registered device video1 [mpeg]
> [   18.834041] saa7164[0]: registered device vbi0 [vbi]
> [   18.834087] saa7164[0]: registered device vbi1 [vbi]
> [   18.848471] Modules linked in: s5h1411 amdkfd amd_iommu_v2 kvm_amd
> snd_hda_codec_realtek kvm radeon snd_hda_codec_gen
> eric crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel ttm
> drm_kms_helper snd_hda_codec_hdmi aes_x86_64 drm
> snd_hda_intel snd_hda_controller saa7164 i2c_algo_bit snd_hda_codec
> eeepc_wmi lrw gf128mul tveeprom asus_wmi glue_helper
>  dvb_core sparse_keymap snd_hwdep v4l2_common video snd_pcm mxm_wmi
> snd_seq_midi snd_seq_midi_event ablk_helper snd_rawm
> idi videodev snd_seq snd_seq_device media snd_timer wmi snd serio_raw
> soundcore shpchp 8250_fintek cryptd fam15h_power k
> 10temp edac_core i2c_piix4 tpm_infineon
>
>
> - edited /etc/modprobe.d/saa7164.conf
> changed card=8 to card=7
>
> - rebooted again
>
> dmesg | grep 7164
>
> [    0.000000] On node 0 totalpages: 2071641
> [    0.530051] pci 0000:05:00.0: [1131:7164] type 00 class 0x048000
> [    7.009868] saa7164 driver loaded
> [    7.010007] CORE saa7164[0]: subsystem: 0070:f111, board: Hauppauge
> WinTV-HVR2250 [card=7,insmod option]
> [    7.010010] saa7164[0]/0: found at 0000:05:00.0, rev: 129, irq: 47,
> latency: 0, mmio: 0xfe000000
> [    7.178353] saa7164_downloadfirmware() no first image
> [    7.178365] saa7164_downloadfirmware() Waiting for firmware upload
> (NXP7164-2010-03-10.1.fw)
> [    7.561231] saa7164_downloadfirmware() firmware read 4019072 bytes.
> [    7.561237] saa7164_downloadfirmware() firmware loaded.
> [    7.561251] saa7164_downloadfirmware() SecBootLoader.FileSize = 4019072
> [    7.561258] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
> [    7.561260] saa7164_downloadfirmware() BSLSize = 0x0
> [    7.561262] saa7164_downloadfirmware() Reserved = 0x0
> [    7.561264] saa7164_downloadfirmware() Version = 0x1661c00
> [   14.310760] saa7164_downloadimage() Image downloaded, booting...
> [   14.414757] saa7164_downloadimage() Image booted successfully.
> [   17.054898] saa7164_downloadimage() Image downloaded, booting...
> [   18.927006] saa7164_downloadimage() Image booted successfully.
> [   18.971706] tveeprom 10-0000: audio processor is SAA7164 (idx 43)
> [   18.971707] tveeprom 10-0000: decoder processor is SAA7164 (idx 40)
> [   18.971709] saa7164[0]: Warning: Unknown Hauppauge model #151061
> [   18.971711] saa7164[0]: Hauppauge eeprom: model=151061
> [   19.025745] saa7164_dvb_register() Frontend initialization failed
> [   19.025748] saa7164_initdev() Failed to register dvb adapters on porta
> [   19.028551] saa7164_dvb_register() Frontend initialization failed
> [   19.028554] saa7164_initdev() Failed to register dvb adapters on portb
> [   19.028614] saa7164[0]: registered device video0 [mpeg]
> [   19.263763] saa7164[0]: registered device video1 [mpeg]
> [   19.476734] saa7164[0]: registered device vbi0 [vbi]
> [   19.476775] saa7164[0]: registered device vbi1 [vbi]
> [   19.485472] Modules linked in: s5h1411 amdkfd amd_iommu_v2 radeon ttm
> snd_hda_codec_realtek snd_hda_codec_generic drm
> _kms_helper snd_hda_codec_hdmi snd_hda_intel drm snd_hda_controller
> snd_hda_codec saa7164 snd_hwdep kvm_amd snd_pcm kvm
> tveeprom dvb_core snd_seq_midi v4l2_common snd_seq_midi_event snd_rawmidi
> eeepc_wmi crct10dif_pclmul crc32_pclmul asus_w
> mi ghash_clmulni_intel snd_seq videodev sparse_keymap media snd_seq_device
> i2c_algo_bit aesni_intel snd_timer snd video
> aes_x86_64 mxm_wmi lrw gf128mul glue_helper ablk_helper wmi soundcore
> k10temp cryptd edac_core shpchp tpm_infineon 8250_
> fintek serio_raw i2c_piix4 fam15h_power edac_mce_amd mac_hid parport_pc
> ppdev lp parport autofs4 hid_generic usbhid hid
> firewire_ohci psmouse firewire_core ahci crc_itu_t r8169 libahci mii
>
>
> Any help would be deeply appreciated.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
