Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3ONYep3010614
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 19:34:40 -0400
Received: from rv-out-0506.google.com (rv-out-0708.google.com [209.85.198.243])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3ONYRgh032044
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 19:34:27 -0400
Received: by rv-out-0506.google.com with SMTP id b17so1890354rvf.51
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 16:34:27 -0700 (PDT)
Message-ID: <e1872dfe0804241634o6f88e4b5v9460b9299b26b9b6@mail.gmail.com>
Date: Fri, 25 Apr 2008 02:34:26 +0300
From: "Evangelos Tsoukas" <tsoukase@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <e1872dfe0804241209h65b6bae1ucd9c5fbbb1ad4391@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <e1872dfe0804241209h65b6bae1ucd9c5fbbb1ad4391@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Subject: Freecom Hybrid TV USB - 3 trials - 3 problems
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi community,

 the goal is to use both the analog and digital functionality of
 Freecom DVB-T & Analog TV USB Stick (USB Id 14aa:0620)
 based on the Trident_tm6000 chip.

 My system
 Ubuntu 7.10
 Linux 2.6.22-14-generic #1 SMP Tue Feb 12 07:42:25 UTC 2008 i686 GNU/Linux
 gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)


 Trial 1
 instructions from
 http://www.linuxtv.org/v4lwiki/index.php/Trident_TM6000
 make

 CC [M]  /home/vangelis/v4l-dvb/v4l/tm6000.o
 /home/vangelis/v4l-dvb/v4l/tm6000.c: In function 'tm6000_poll_remote':
 /home/vangelis/v4l-dvb/v4l/tm6000.c:293: warning: passing argument 1
of 'schedul
 e_delayed_work' from incompatible pointer type
 /home/vangelis/v4l-dvb/v4l/tm6000.c: In function 'tm6000_start_stream':
 /home/vangelis/v4l-dvb/v4l/tm6000.c:297: warning: unused variable 'errCode'
 /home/vangelis/v4l-dvb/v4l/tm6000.c:297: warning: unused variable 'i'
 /home/vangelis/v4l-dvb/v4l/tm6000.c: In function 'tm6000_zl10353_i2c_xfer':
 /home/vangelis/v4l-dvb/v4l/tm6000.c:421: warning: unused variable 'k'
 /home/vangelis/v4l-dvb/v4l/tm6000.c: In function 'tm6000_xc3028_i2c_xfer':
 /home/vangelis/v4l-dvb/v4l/tm6000.c:504: warning: unused variable 'k'
 /home/vangelis/v4l-dvb/v4l/tm6000.c: In function 'tm6000_zl10353_pll':
 /home/vangelis/v4l-dvb/v4l/tm6000.c:644: warning: unused variable 'i'
 /home/vangelis/v4l-dvb/v4l/tm6000.c: In function 'zl10353_read_status':
 /home/vangelis/v4l-dvb/v4l/tm6000.c:1272: warning: unused variable 's8'
 /home/vangelis/v4l-dvb/v4l/tm6000.c:1272: warning: unused variable 's7'
 /home/vangelis/v4l-dvb/v4l/tm6000.c:1272: warning: unused variable 's6'
 /home/vangelis/v4l-dvb/v4l/tm6000.c: In function 'tm6000_read_signal_strength':
 /home/vangelis/v4l-dvb/v4l/tm6000.c:1304: warning: unused variable 'state'
 /home/vangelis/v4l-dvb/v4l/tm6000.c: In function 'tm6000_read_snr':
 /home/vangelis/v4l-dvb/v4l/tm6000.c:1313: warning: unused variable 'state'
 /home/vangelis/v4l-dvb/v4l/tm6000.c: In function 'probe':
 /home/vangelis/v4l-dvb/v4l/tm6000.c:2005: error: too few arguments to
function '
 dvb_register_adapter'
 /home/vangelis/v4l-dvb/v4l/tm6000.c:2059: warning: label 'err'
defined but not u
 sed
 make[3]: *** [/home/vangelis/v4l-dvb/v4l/tm6000.o] Error 1
 make[2]: *** [_module_/home/vangelis/v4l-dvb/v4l] Error 2
 make[2]: Leaving directory `/usr/src/linux-headers-2.6.22-14-generic'
 make[1]: *** [default] Error 2
 make[1]: Leaving directory `/home/vangelis/v4l-dvb/v4l'
 make: *** [all] Error 2



 Trial 2
 hg clone http://linuxtv.org/hg/~mchehab/tm6010/
 make

 CC [M]  /home/vangelis/tm6010/v4l/tm6000-core.o
 /home/vangelis/tm6010/v4l/tm6000-core.c: In function 'tm6000_init_analog_mode':
 /home/vangelis/tm6010/v4l/tm6000-core.c:214: warning: ISO C90 forbids
 mixed declarations and code
  CC [M]  /home/vangelis/tm6010/v4l/tm6000-i2c.o
  CC [M]  /home/vangelis/tm6010/v4l/tm6000-video.o
  CC [M]  /home/vangelis/tm6010/v4l/tm6000-stds.o
  CC [M]  /home/vangelis/tm6010/v4l/tm6000-dvb.o
 /home/vangelis/tm6010/v4l/tm6000-dvb.c: In function 'tm6000_dvb_register':
 /home/vangelis/tm6010/v4l/tm6000-dvb.c:232: error: too few arguments
 to function 'dvb_register_adapter'
 make[3]: *** [/home/vangelis/tm6010/v4l/tm6000-dvb.o] Error 1
 make[2]: *** [_module_/home/vangelis/tm6010/v4l] Error 2
 make[2]: Leaving directory `/usr/src/linux-headers-2.6.22-14-generic'
 make[1]: *** [default] Error 2
 make[1]: Leaving directory `/home/vangelis/tm6010/v4l'
 make: *** [all] Error 2


 Trial 3
 hg clone http://linuxtv.org/hg/~mchehab/tm6000/
 make
 make install

 modprobe tm6000
 dmesg
  ................
 [  445.088000] Trident TVMaster TM5600/TM6000 USB2 board (Load status: 0)
 [  446.260000] Hack: enabling device at addr 0xc2
 [  446.260000] tuner' 1-0061: chip found @ 0xc2 (tm6000 #0)
 [  446.264000] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
 [  446.264000] Setting firmware parameters for xc2028
 [  446.304000] xc2028 1-0061: Error: firmware tm6000-xc3028.fw not found.
 [  446.368000] xc2028 1-0061: Error: firmware tm6000-xc3028.fw not found.
 [  446.424000] DVB: registering new adapter (Trident TVMaster 6000 DVB-T)
 [  446.424000] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
 [  446.424000] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
 [  446.424000] tm6000: XC2028/3028 asked to be attached to frontend!
 [  446.424000] usbcore: registered new interface driver tm6000

 I found the tridvid.sys file:

 perl get_firmware.pl
 cp tm6000_xc2028_firmware1.fw /lib/firmware/tm6000-xc3028.fw

 modprobe tm6000
 Segmentation fault
 dmesg
 [  577.284000]   ................
 [  577.284000] Trident TVMaster TM5600/TM6000 USB2 board (Load status: 0)
 [  577.292000] Setting firmware parameters for xc2028
 *ø, ver 37.125 xc2028 1-0061: Loading 17803 firmware images from
 tm6000-xc3028.fw, type: tm6000/xcv v1
 [  577.304000] ------------[ cut here ]------------
 [  577.304000] kernel BUG at
 /build/buildd/linux-source-2.6.22-2.6.22/mm/slub.c:2204!
 [  577.304000] invalid opcode: 0000 [#1]
 [  577.304000] SMP
 [  577.304000] Modules linked in: tm6000 zl10353 tuner tea5767 tda8290
 tda18271 tda827x tuner_xc2028 tda9887 tuner_simple mt20xx tea5761
 dvb_core videodev v4l1_compat videobuf_vmalloc videobuf_core
 v4l2_common af_packet radeon drm binfmt_misc ipv6 sbs button battery
 dock video container ac lm90 speedstep_centrino cpufreq_userspace
 cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table
 cpufreq_conservative lp loop joydev snd_ali5451 snd_ac97_codec
 ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy usbhid hid
 snd_seq_oss i2c_ali15x3 wlan_scan_sta snd_seq_midi pcmcia
 ath_rate_sample i2c_ali1535 pcspkr psmouse serio_raw i2c_core
 parport_pc parport snd_rawmidi ath_pci wlan snd_seq_midi_event snd_seq
 snd_timer snd_seq_device yenta_socket rsrc_nonstatic pcmcia_core
 ath_hal(P) snd soundcore shpchp snd_page_alloc pci_hotplug ati_agp
 agpgart evdev ext3 jbd mbcache ide_disk tg3 ehci_hcd ohci_hcd usbcore
 alim15x3 ide_core ata_generic libata scsi_mod thermal processor fan
 fuse apparmor commoncap
 [  577.304000] CPU:    0
 [  577.304000] EIP:    0060:[<c017ced3>]    Tainted: P       VLI
 [  577.304000] EFLAGS: 00210206   (2.6.22-14-generic #1)
 [  577.304000] EIP is at get_slab+0x1c3/0x1d0
 [  577.304000] eax: 00000000   ebx: c1a00000   ecx: 45c606eb   edx: 000000d0
 [  577.304000] esi: 000000d0   edi: 000000d0   ebp: dcd2744c   esp: c2f5db20
 [  577.304000] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
 [  577.304000] Process modprobe (pid: 8313, ti=c2f5c000 task=da4f94c0
 task.ti=c2f5c000)
 [  577.304000] Stack: ffffffff 000000d0 c03da410 00000010 c1a00000
 45c606eb 000000d0 dcd2744c
 [  577.304000]        c017e30c dcd272da 00000000 c1a00000 45c606eb
 c2f5dc0c d58b0c80 c0168bb9
 [  577.304000]        c1a00000 dcd52034 c2f5dc0c dcd2744c dcd28290
 dcd27da6 00000001 00000061


 AFAIK this is the most extensive report for this card.
 For any other info, of course I am at your disposal.
 Need help!
 Thank you.

 Evangelos

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
