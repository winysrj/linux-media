Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m92Ck1CX008759
	for <video4linux-list@redhat.com>; Thu, 2 Oct 2008 08:46:01 -0400
Received: from unifiedpaging.messagenetsystems.com
	(mail.emergencycommunicationsystems.com [24.123.23.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m92CiZqQ015251
	for <video4linux-list@redhat.com>; Thu, 2 Oct 2008 08:44:36 -0400
Message-ID: <48E4C234.9000802@messagenetsystems.com>
Date: Thu, 02 Oct 2008 08:44:36 -0400
From: Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <48E3DE07.4000707@messagenetsystems.com>
	<mj5dr5-abk.ln1@CPE-124-182-251-164.sa.bigpond.net.au>
In-Reply-To: <mj5dr5-abk.ln1@CPE-124-182-251-164.sa.bigpond.net.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: geisj@messagenetsystems.com
Subject: Re: [Alsa-user] em28xx_alsa: disagrees about version of symbol xxx
 after upgrading CentOS 5.2 ALSA .14 for ALSA .17
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

Ladies & Gentleman:

Please read below:

Arthur Marsh wrote:
> Robert Vincent Krakora wrote, on 2008-10-02 06:01:
>   
>> Ladies & Gentlemen:
>>
>> After upgrading from ALSA .14 to .17 on my CentOS 5.2 machine, my HR950 
>> no longer yields audio.  Below is what a dump of dmesg reveals.
>> How can this be resolved?  It appears to be a kernel module versioning 
>> problem.  However, when I do a modprobe -f em28xx_alsa to force the 
>> module to load, and attempt to run mplayer (mplayer tv://59 -tv 
>> driver=v4l2:device=/dev/video0:chanlist=us-cable:alsa:adevice=hw.1,0:amode=1:audiorate=32000:forceaudio:volume=100:immediatemode=0:norm=NTSC) 
>> I see the information even further below on the terminal.  I built and 
>> installed ALSA driver, lib and util .17, installed them and rebooted.  I 
>> have seen this problem posted many times on different sites on the web 
>> and there were no resolutions.  What is up with this?  I even rebuilt 
>> v4l2 after installing ALSA .17 and I still see this.
>>
>> dmesg for em28xx:
>>
>> Linux video capture interface: v2.00
>> em28xx v4l2 driver version 0.1.0 loaded
>> em28xx new video device (2040:6513): interface 0, class 255
>> em28xx Doesn't have usb audio class
>> em28xx #0: Alternate settings: 8
>> em28xx #0: Alternate setting 0, max size= 0
>> em28xx #0: Alternate setting 1, max size= 0
>> em28xx #0: Alternate setting 2, max size= 1448
>> em28xx #0: Alternate setting 3, max size= 2048
>> em28xx #0: Alternate setting 4, max size= 2304
>> em28xx #0: Alternate setting 5, max size= 2580
>> em28xx #0: Alternate setting 6, max size= 2892
>> em28xx #0: Alternate setting 7, max size= 3072
>> em28xx #0: chip ID is em2882/em2883
>> nvidia: module license 'NVIDIA' taints kernel.
>> eth0: forcedeth.c: subsystem: 01458:e000 bound to 0000:00:08.0
>> i2c_adapter i2c-0: nForce2 SMBus adapter at 0x1c00
>> i2c_adapter i2c-1: nForce2 SMBus adapter at 0x1c80
>> ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
>> GSI 20 sharing vector 0xD9 and IRQ 20
>> ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC6] -> GSI 16 (level, 
>> low) -> IRQ 217
>> PCI: Setting latency timer of device 0000:02:00.0 to 64
>> NVRM: loading NVIDIA UNIX x86_64 Kernel Module  173.14.09  Wed Jun  4 
>> 23:40:50 PDT 2008
>> em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 13 65 d0 12 5c 03 82 1e 6a 18
>> em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
>> em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
>> em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 01 01 00 00 00 00
>> em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
>> em28xx #0: i2c eeprom 70: 32 00 38 00 35 00 33 00 34 00 37 00 37 00 37 00
>> em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
>> em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 38 00 30 00 00 00
>> em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
>> em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 f9 8f
>> em28xx #0: i2c eeprom c0: 1e f0 74 02 01 00 01 79 00 00 00 00 00 00 00 00
>> em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
>> em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 f9 8f
>> em28xx #0: i2c eeprom f0: 1e f0 74 02 01 00 01 79 00 00 00 00 00 00 00 00
>> EEPROM ID= 0x9567eb1a, hash = 0x97b124dd
>> Vendor/Product ID= 2040:6513
>> AC97 audio (5 sample rates)
>> 500mA max power
>> Table at 0x24, strings=0x1e82, 0x186a, 0x0000
>> tveeprom 2-0050: Hauppauge model 65201, rev A1C0, serial# 2002937
>> tveeprom 2-0050: tuner model is Xceive XC3028 (idx 120, type 71)
>> tveeprom 2-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB 
>> Digital (eeprom 0xd4)
>> tveeprom 2-0050: audio processor is None (idx 0)
>> tveeprom 2-0050: has radio
>> sr0: scsi3-mmc drive: 4x/48x cd/rw xa/form2 cdda tray
>> Uniform CD-ROM driver Revision: 3.20
>> sr 2:0:0:0: Attached scsi CD-ROM sr0
>> tuner' 2-0061: chip found @ 0xc2 (em28xx #0)
>> ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 21
>> ACPI: PCI Interrupt 0000:00:06.1[B] -> Link [AAZA] -> GSI 21 (level, 
>> low) -> IRQ 201
>> PCI: Setting latency timer of device 0000:00:06.1 to 64
>> xc2028 2-0061: creating new instance
>> xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
>> shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
>> xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: 
>> xc2028 firmware, ver 2.7
>> xc2028 2-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
>> xc2028 2-0061: Loading firmware for type=MTS (4), id 000000000000b700.
>> tvp5150 2-005c: tvp5150am1 detected.
>> em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
>> em28xx #0: Found Hauppauge WinTV HVR 950
>> usbcore: registered new driver em28xx
>> em28xx_alsa: disagrees about version of symbol snd_pcm_new
>> em28xx_alsa: Unknown symbol snd_pcm_new
>> em28xx_alsa: disagrees about version of symbol snd_card_register
>> em28xx_alsa: Unknown symbol snd_card_register
>> em28xx_alsa: disagrees about version of symbol snd_card_free
>> em28xx_alsa: Unknown symbol snd_card_free
>> em28xx_alsa: disagrees about version of symbol snd_card_new
>> em28xx_alsa: Unknown symbol snd_card_new
>> em28xx_alsa: disagrees about version of symbol snd_pcm_lib_ioctl
>> em28xx_alsa: Unknown symbol snd_pcm_lib_ioctl
>> em28xx_alsa: disagrees about version of symbol snd_pcm_set_ops
>> em28xx_alsa: Unknown symbol snd_pcm_set_ops
>> em28xx_alsa: disagrees about version of symbol snd_pcm_hw_constraint_integer
>> em28xx_alsa: Unknown symbol snd_pcm_hw_constraint_integer
>> em28xx_alsa: disagrees about version of symbol snd_pcm_period_elapsed
>> em28xx_alsa: Unknown symbol snd_pcm_period_elapsed
>> xc2028 2-0061: attaching existing instance
>> xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
>> em28xx #0/2: xc3028 attached
>> DVB: registering new adapter (em28xx #0)
>> DVB: registering frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
>> Successfully loaded em28xx-dvb
>> Em28xx: Initialized (Em28xx dvb Extension) extension
>>  
>> Running mplayer:
>>
>> [root@devkrakora silentm]# mplayer tv://59 -tv 
>> driver=v4l2:device=/dev/video0:chanlist=us-cable:alsa:adevice=hw.1,0:amode=1:audiorate=32000:forceaudio:volume=100:immediatemode=0:norm=NTSC
>> MPlayer 1.0rc1-4.1.2 (C) 2000-2006 MPlayer Team
>> CPU: AMD Phenom(tm) 9750 Quad-Core Processor (Family: 16, Model: 2, 
>> Stepping: 3)
>> CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 1 SSE: 1 SSE2: 1
>> Compiled for x86 CPU with extensions: MMX MMX2 3DNow 3DNowEx SSE SSE2
>> Can't open joystick device /dev/input/js0: No such file or directory
>> Can't init input joystick
>> mplayer: could not connect to socket
>> mplayer: No such file or directory
>> Failed to open LIRC support. You will not be able to use your remote 
>> control.
>>
>> Playing tv://59.
>> TV file format detected.
>> Selected driver: v4l2
>>  name: Video 4 Linux 2 input
>>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>>  comment: first try, more to come ;-)
>> Selected device: Hauppauge WinTV HVR 950
>>  Tuner cap:
>>  Tuner rxs:
>>  Capabilites:  video capture  tuner  audio  read/write  streaming
>>  supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4 
>> = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK; 10 = 
>> PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 = SECAM-B; 
>> 16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20 = SECAM-Lc;
>>  inputs: 0 = Television; 1 = Composite1; 2 = S-Video;
>>  Current input: 0
>>  Current format: YUYV
>> v4l2: current audio mode is : STEREO
>> Selected channel: 59 (freq: 433.250)
>> Broken configuration for this PCM: no configurations available.
>> Error opening audio: Device or resource busy
>> Error opening audio: Device or resource busy
>> v4l2: 0 frames successfully processed, 0 frames dropped.
>> v4l2: ioctl set mute failed: Bad file descriptor
>> v4l2: 0 frames successfully processed, 0 frames dropped.
>>
>>
>> Exiting... (End of file)
>>
>>
>> Best Regards,
>>
>>     
>
> Have you posted this to the video for linux mailing list?
>
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Alsa-user mailing list
> Alsa-user@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/alsa-user
>
>
>   
Best Regards,

-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
