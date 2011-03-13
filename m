Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54973 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab1CMN35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2011 09:29:57 -0400
Received: by wwa36 with SMTP id 36so4764397wwa.1
        for <linux-media@vger.kernel.org>; Sun, 13 Mar 2011 06:29:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D7C8216.8060504@gmail.com>
References: <4D7C8216.8060504@gmail.com>
Date: Sun, 13 Mar 2011 15:29:54 +0200
Message-ID: <AANLkTikinH_RtAHrU2aRDmwe8N6W_yQH8g80oBRmSRk8@mail.gmail.com>
Subject: Re: em28xx based analog tv tuner USB KWorld PVR-TV 305U (eb1a:e305):
 no sound
From: tosiara <tosiara@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Also tried latest openSUSE 11.4

> uname -a
Linux linux-tecd.site 2.6.37.1-1.2-desktop #1 SMP PREEMPT 2011-02-21
10:34:10 +0100 i686 athlon i386 GNU/Linux

alsa 1.0.24.1-3.1

Still the same issue, "Error reading audio: Input/output error"



On Sun, Mar 13, 2011 at 10:36, tosiara <tosiara@gmail.com> wrote:
>
> Hello
>
> I've made tests with my *KWorld* usb tuner:
>
>  *Model*: USB KWorld PVR-TV 305U
>  *Vendor/Product id*: [eb1a:e305].
>
>  *Tests made*:
>
>     - Analog video [Worked]
>     - Analog audio [not working, details attached below]
>
>
> Hardware and system details:
>
> # lsusb -s 002:003
>
> Bus 002 Device 003: ID eb1a:e305 eMPIA Technology, Inc.
>
> # uname -a
> Linux vista.linuks.lan 2.6.34.7-0.7-desktop #1 SMP PREEMPT 2010-12-13 11:13:53 +0100 i686 athlon i386 GNU/Linux
>
> # cat /etc/issue
> Welcome to openSUSE 11.3 "Teal" - Kernel \r (\l).
>
> ALSA version: 1.0.24.1-72.1
>
>
> Build latest dvb drivers from linuxtv.org:
>
> # lsmod
> Module                  Size  Used by
> aes_i586                7396  1
> aes_generic            27151  1 aes_i586
> fuse                   65789  3
> ip6t_LOG                5150  11
> xt_tcpudp               2107  25
> xt_pkttype               912  4
> xt_physdev              1539  2
> ipt_LOG                 5119  11
> xt_limit                1705  22
> rfcomm                 69557  4
> vboxnetadp              7018  0
> vboxnetflt             16967  0
> sco                    16711  2
> af_packet              19512  4
> bridge                 71700  1
> stp                     1719  1 bridge
> llc                     5093  2 bridge,stp
> bnep                   14764  2
> vboxdrv               204362  2 vboxnetadp,vboxnetflt
> l2cap                  53658  16 rfcomm,bnep
> snd_pcm_oss            47613  0
> snd_mixer_oss          16751  1 snd_pcm_oss
> snd_seq                57343  0
> snd_seq_device          6598  1 snd_seq
> edd                     8720  0
> vmnet                  46129  13
> ppdev                   8444  0
> parport_pc             33475  0
> parport                34052  2 ppdev,parport_pc
> vmblock                11886  1
> vsock                  41336  0
> vmci                   59117  1 vsock
> vmmon                  76038  0
> ip6t_REJECT             4311  3
> nf_conntrack_ipv6      18225  4
> ip6table_raw            1187  1
> xt_NOTRACK               816  4
> ipt_REJECT              2152  3
> xt_state                1162  8
> iptable_raw             1246  1
> iptable_filter          1418  1
> ip6table_mangle         1588  0
> nf_conntrack_netbios_ns     1382  0
> nf_conntrack_ipv4       8691  4
> nf_conntrack           75628  5 nf_conntrack_ipv6,xt_NOTRACK,xt_state,nf_conntrack_netbios_ns,nf_conntrack_ipv4
> nf_defrag_ipv4          1201  1 nf_conntrack_ipv4
> ip_tables              12172  2 iptable_raw,iptable_filter
> ip6table_filter         1359  1
> cpufreq_conservative    10064  0
> cpufreq_userspace       2583  0
> cpufreq_powersave        914  0
> ip6_tables             13508  4 ip6t_LOG,ip6table_raw,ip6table_mangle,ip6table_filter
> x_tables               17098  17 ip6t_LOG,xt_tcpudp,xt_pkttype,xt_physdev,ipt_LOG,xt_limit,ip6t_REJECT,ip6table_raw,xt_NOTRACK,ipt_REJECT,xt_state,iptable_raw,iptable_filter,ip6table_mangle,ip_tables,ip6table_filter,ip6_tables
> powernow_k8            18707  0
> mperf                   1255  1 powernow_k8
> loop                   14694  0
> dm_mod                 73457  0
> em28xx_alsa             6316  0
> arc4                    1281  2
> tuner_xc2028           20652  1
> ecb                     1967  2
> tuner                  18636  1
> snd_hda_codec_atihdmi     2591  1
> ir_lirc_codec           4075  0
> lirc_dev               15476  1 ir_lirc_codec
> tvp5150                15288  1
> ir_sony_decoder         2005  0
> snd_hda_codec_idt      58593  1
> ir_jvc_decoder          2098  0
> ir_rc6_decoder          2450  0
> firewire_ohci          23817  0
> firewire_core          52354  1 firewire_ohci
> crc_itu_t               1435  1 firewire_core
> snd_hda_intel          24950  3
> rc_rc6_mce              1230  0
> snd_hda_codec          98635  3 snd_hda_codec_atihdmi,snd_hda_codec_idt,snd_hda_intel
> snd_hwdep               6164  1 snd_hda_codec
> em28xx                 89777  1 em28xx_alsa
> snd_pcm                87882  4 snd_pcm_oss,em28xx_alsa,snd_hda_intel,snd_hda_codec
> ir_rc5_decoder          1970  0
> ath5k                 135497  0
> mac80211              248390  1 ath5k
> ath                     8743  1 ath5k
> ohci1394               30324  0
> snd_timer              21669  2 snd_seq,snd_pcm
> ene_ir                 14962  0
> snd                    65788  17 snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,em28xx_alsa,snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
> ir_nec_decoder          2386  0
> hp_wmi                  5882  0
> cfg80211              156087  3 ath5k,mac80211,ath
> v4l2_common            10269  3 tuner,tvp5150,em28xx
> videobuf_vmalloc        4868  1 em28xx
> videobuf_core          18232  2 em28xx,videobuf_vmalloc
> jmb38x_ms              12491  0
> sdhci_pci               7110  0
> sdhci                  20020  1 sdhci_pci
> hp_accel               12712  0
> lis3lv02d               7908  1 hp_accel
> uvcvideo               60566  0
> soundcore               7379  1 snd
> snd_page_alloc          8041  2 snd_hda_intel,snd_pcm
> video                  21205  0
> btusb                  15667  2
> bluetooth              96350  9 rfcomm,sco,bnep,l2cap,btusb
> rfkill                 17298  4 hp_wmi,cfg80211,bluetooth
> sg                     27872  0
> wmi                     7467  1 hp_wmi
> rc_core                18319  10 ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,rc_rc6_mce,em28xx,ir_rc5_decoder,ene_ir,ir_nec_decoder
> r8169                  38911  0
> mmc_core               72345  1 sdhci
> sr_mod                 14671  0
> tveeprom               11421  1 em28xx
> memstick                9710  1 jmb38x_ms
> ieee1394               88668  1 ohci1394
> battery                 9730  0
> input_polldev           3799  1 lis3lv02d
> pcspkr                  1614  0
> joydev                  9354  0
> ac                      3083  0
> videodev               75386  5 tuner,tvp5150,em28xx,v4l2_common,uvcvideo
> cdrom                  38085  1 sr_mod
> button                  5449  0
> i2c_piix4              11574  0
> k10temp                 2723  0
> ext4                  365656  1
> jbd2                   83102  1 ext4
> crc16                   1403  2 l2cap,ext4
> fglrx                2410654  325
> fan                     3539  0
> processor              40761  1 powernow_k8
> ata_generic             2743  0
> pata_atiixp             3564  0
> thermal                17357  0
> thermal_sys            14678  4 video,fan,processor,thermal
>
>
> Plugging tuner in, dmesg:
>
> [ 1875.180265] usb 2-4: new high speed USB device using ehci_hcd and address 4
> [ 1875.298100] usb 2-4: New USB device found, idVendor=eb1a, idProduct=e305
> [ 1875.298117] usb 2-4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
>
> [ 1875.298152] usb 2-4: Product: USB 2861 Device
> [ 1875.300292] em28xx: New device USB 2861 Device @ 480 Mbps (eb1a:e305, interface 0, class 0)
> [ 1875.300580] em28xx #0: chip ID is em2860
> [ 1875.487692] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 05 e3 d0 00 5c 00 6a 22 00 00
>
> [ 1875.487730] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 03 00 00 00 00 00 00 00 00 00 00
> [ 1875.487764] em28xx #0: i2c eeprom 20: 06 00 01 00 f0 10 01 00 00 00 00 00 5b 00 00 00
> [ 1875.487796] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
>
> [ 1875.487828] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1875.487858] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1875.487888] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
>
> [ 1875.487919] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 36 00 31 00 20 00 44 00
> [ 1875.487950] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
> [ 1875.487981] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> [ 1875.488011] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1875.488042] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1875.488072] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> [ 1875.488103] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1875.488201] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1875.488304] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> [ 1875.488424] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x28a51142
> [ 1875.488436] em28xx #0: EEPROM info:
> [ 1875.488447] em28xx #0:       AC97 audio (5 sample rates)
> [ 1875.488458] em28xx #0:       500mA max power
>
> [ 1875.488472] em28xx #0:       Table at 0x04, strings=0x226a, 0x0000, 0x0000
> [ 1875.490941] em28xx #0: Identified as KWorld DVB-T 305U (card=47)
> [ 1875.490954] em28xx #0:
> [ 1875.490959]
> [ 1875.490965] em28xx #0: The support for this board weren't valid yet.
>
> [ 1875.490974] em28xx #0: Please send a report of having this working
> [ 1875.490982] em28xx #0: not to V4L mailing list (and/or to other addresses)
> [ 1875.490987]
> [ 1875.498585] tvp5150 0-005c: chip found @ 0xb8 (em28xx #0)
>
> [ 1875.570814] tvp5150 0-005c: tvp5150am1 detected.
> [ 1875.612698] tuner 0-0061: Tuner -1 found with type(s) Radio TV.
> [ 1875.612837] xc2028 0-0061: creating new instance
> [ 1875.612840] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
>
> [ 1875.612848] usb 2-4: firmware: requesting xc3028-v27.fw
> [ 1875.619760] xc2028 0-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> [ 1875.672106] xc2028 0-0061: Loading firmware for type=BASE (1), id 0000000000000000.
>
> [ 1883.005108] xc2028 0-0061: Loading firmware for type=(0), id 000000000000b700.
> [ 1883.154107] SCODE (20000000), id 000000000000b700:
> [ 1883.154156] xc2028 0-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
>
> [ 1883.319239] em28xx #0: Config register raw data: 0xd0
> [ 1883.332960] em28xx #0: AC97 vendor ID = 0xffffffff
> [ 1883.339834] em28xx #0: AC97 features = 0x6a90
> [ 1883.339843] em28xx #0: Empia 202 AC97 audio processor detected
>
> [ 1884.746060] em28xx #0: v4l2 driver version 0.1.2
> [ 1885.414516] em28xx #0: V4L2 video device registered as video1
> [ 1885.414530] em28xx #0: V4L2 VBI device registered as vbi0
> [ 1885.414541] em28xx-audio.c: probing for em28x1 non standard usbaudio
>
> [ 1885.414550] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> [ 1885.423686] em28xx video device (eb1a:e305): interface 1, class 255 found.
> [ 1885.423696] em28xx This is an anciliary interface not used by the driver
>
>
> Appears new ALSA capture device:
>
> # arecord -l
> **** List of CAPTURE Hardware Devices ****
> card 0: SB [HDA ATI SB], device 0: STAC92xx Analog [STAC92xx Analog]
>  Subdevices: 2/2
>  Subdevice #0: subdevice #0
>  Subdevice #1: subdevice #1
>
> card 2: Em28xxAudio [Em28xx Audio], device 0: Em28xx Audio [Empia 28xx Capture]
>  Subdevices: 1/1
>  Subdevice #0: subdevice #0
>
>
>
> I can see video only using MPlayer:
>
> mplayer tv:// -tv driver=v4l2:norm=PAL-DK:device=/dev/video1:freq=59.25
>
> Picture is of acceptable quality
>
>
> If I try to capture video and audio I get audio input/output error:
>
> > mencoder tv:// -tv device=/dev/video1:driver=v4l2:width=320:height=240:norm=PAL-DK:freq=59.25:alsa:immediatemode=0:adevice=hw.2,0 -oac mp3lame -lameopts cbr:br=128 -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=2000 -o test.avi
> MPlayer dev-SVN-r31930-4.5-openSUSE Linux 11.3 (i686)-Packman (C) 2000-2010 MPlayer Teamsuccess: format: 9  data: 0x0 - 0x0
> TV file format detected.
> Selected driver: v4l2
>  name: Video 4 Linux 2 input
>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>  comment: first try, more to come ;-)
> Selected device: KWorld DVB-T 305U
>  Tuner cap:
>  Tuner rxs:
>  Capabilities:  video capture  VBI capture device  tuner  audio  read/write  streaming
>  supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4 = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK; 10 = PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 = SECAM-B; 16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20 = SECAM-Lc;
>  inputs: 0 = Television; 1 = Composite1; 2 = S-Video;
>  Current input: 0
>  Current format: YUYV
> v4l2: current audio mode is : MONO
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set format failed: Invalid argument
> Channel count not available - reverting to default: 2
> Channel count not available - reverting to default: 2
> [V] filefmt:9  fourcc:0x32595559  size:320x240  fps:25.000  ftime:=0.0400
> ==========================================================================
> Opening audio decoder: [pcm] Uncompressed PCM audio decoder
> AUDIO: 48000 Hz, 2 ch, s16le, 1536.0 kbit/100.00% (ratio: 192000->192000)
> Selected audio codec: [pcm] afm: pcm (Uncompressed PCM)
> ==========================================================================
> Opening video filter: [expand osd=1]
> Expand: -1 x -1, -1 ; -1, osd: 1, aspect: 0.000000, round: 1
> ==========================================================================
> Opening video decoder: [raw] RAW Uncompressed Video
> Could not find matching colorspace - retrying with -vf scale...
> Opening video filter: [scale]
> Movie-Aspect is undefined - no prescaling applied.
> [swscaler @ 0x8f20170] using unscaled yuyv422 -> yuv420p special converter
> videocodec: libavcodec (320x240 fourcc=34504d46 [FMP4])
> Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
> ==========================================================================
> MP3 audio selected.
> Forcing audio preload to 0, max pts correction to 0.
>
> 3 duplicate frame(s)!
> Pos:   0.2s      1f ( 0%)  0.00fps Trem:   0min   0mb  A-V:0.000 [0:0]
>
> Error reading audio: Input/output error
>
> Error reading audio: Input/output error
>
> Error reading audio: Input/output error
>
> Error reading audio: Input/output error
>
> Error reading audio: Input/output error
>
>
> video buffer full - dropping frame
>
> video buffer full - dropping frame
>
> video buffer full - dropping frame
>
> video buffer full - dropping frame
>
> video buffer full - dropping frame
>
> video buffer full - dropping frame
>
>
>
> If I try to capture sound only using audacity - it does not record anything: audio recording progress bar stays at 00:00:00 and nothing is recorded.
>
>
> And sometimes this message appears in dmesg:
>
> [ 5663.100194] ALSA pcm_lib.c:1752: capture write error (DMA or IRQ trouble?)
>
>
> When using tvtime there is no sound too.
> I followed instructions on tvtime WIKI:
>
>
> > sox -r 32000 -t ossdsp /dev/dsp2 -t ossdsp /dev/dsp
>
> /dev/dsp2: (ossdsp)
>
>  Encoding: Signed PCM
>  Channels: 2 @ 16-bit
> Samplerate: 32000Hz
> Replaygain: off
>  Duration: unknown
>
> In:0.00%
>  00:00:00.00 [00:00:00.00] Out:0     [      |      ]        Clip:0
>
> sox FAIL sox: `/dev/dsp2' lsx_readbuf: Input/output error
> In:0.00% 00:00:00.00 [00:00:00.00] Out:0     [      |      ]        Clip:0
> Done.
>
>
> The above command fails in apprx. 4 seconds
>
> Windows driver contains these files:
>
> # ls x86/ -l
> total 780
> -rw------- 1 tos users     48 2011-03-06 18:01 .directory
> -r-xr-xr-x 1 tos users   5062 2007-01-19 14:15 EMAUDIO.INF
> -r-xr-xr-x 1 tos users  22912 2007-01-12 10:55 emAudio.sys
>
> -r-xr-xr-x 1 tos users  34335 2007-01-19 14:15 EMBDA.INF
> -r-xr-xr-x 1 tos users 380416 2007-01-12 10:55 emBDA.sys
> -r-xr-xr-x 1 tos users  61440 2006-12-15 09:54 emmon.exe
> -r-xr-xr-x 1 tos users  30208 2006-12-21 06:12 emOEM.sys
>
> -r-xr-xr-x 1 tos users 106496 2007-01-12 10:53 emPRP.ax
> -r-xr-xr-x 1 tos users  49152 2007-03-21 06:00 emunist.exe
> -r-xr-xr-x 1 tos users  15548 2007-01-24 03:27 emwhql.cat <http://emwhql.cat>
> drwxr-xr-x 2 tos users   4096 1970-01-01 03:00 Language
>
> -r-xr-xr-x 1 tos users  16382 2006-11-09 06:50 merlinC.rom
> -r-xr-xr-x 1 tos users  53248 2007-03-21 05:58 SetupDrv.exe
> -r-xr-xr-x 1 tos users   2068 2006-12-11 15:20 TVEpaDrv.ini
>
>
>
> I would like to ask, if this is driver, firmware or ALSA issue? Maybe I need to extract firmware from OEM drivers but how can I do that? Maybe try other kernel/ALSA?
> Or maybe this device is not supported yet?
>
> Can anybody provide feedback on this issue?
>
> Thank you
>
