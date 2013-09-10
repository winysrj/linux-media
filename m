Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:63402 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3IJGIW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Sep 2013 02:08:22 -0400
Received: by mail-oa0-f51.google.com with SMTP id h1so7483349oag.10
        for <linux-media@vger.kernel.org>; Mon, 09 Sep 2013 23:08:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMJoypa9GuqARtQKNMc5S3cK9wpw3GdpDXSjbXgwf7M8+6pJ+A@mail.gmail.com>
References: <CAMJoypa9GuqARtQKNMc5S3cK9wpw3GdpDXSjbXgwf7M8+6pJ+A@mail.gmail.com>
Date: Tue, 10 Sep 2013 08:08:21 +0200
Message-ID: <CAMJoypZpQT8+vqcOcdSCGy2kPAqbv=z_2jhVa5kQPxOt_+6Y1w@mail.gmail.com>
Subject: Fwd: Strange USB transfer problems with Delock 61959
From: Matthias Gruenewald <matthias.gruenewald@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello linux media developers,

I have recently bought a Delock 61959 DVB-C USB stick. It's working
fine under Windows. All SD and HD channels can be found and watched
fine. But under Linux, I get a really strange behaviour. If I connect
the stick to a USB 3.0 port, it is somehow working. HD channels work
fine, but some SD channels like "Pro Sieben" (Germany) have
occasionally dropouts in the stream. It looks like a channel with poor
signal strength, but VDR's signal strength indicator is 100%. Now if I
connect the same stick to a USB 2.0 port, it get's even worse. All
channels have dropouts, I can sometimes even not tune to a channel.
The kernel log does not indicate any USB transfer problems. VDR
sometimes complains that it can not tune to a channel. And there are
some error messages on get_lock_status. Here is a log from an example
session on a USB 2.0 port (I enabled core_debug in the em28xx driver):

2013-09-10T07:57:26.733489+02:00 server kernel: [ 3997.846473] drxk:
frontend initialized.
2013-09-10T07:57:28.217491+02:00 server kernel: [ 3999.330104] em2874
#0: MaxMedia UB425-TC/Delock 61959: only DVB-C supported by that
driver version
2013-09-10T07:57:28.217517+02:00 server kernel: [ 3999.330111] DVB:
registering new adapter (em2874 #0)
2013-09-10T07:57:28.217519+02:00 server kernel: [ 3999.330118] usb
2-1.4: DVB: registering adapter 0 frontend 0 (DRXK DVB-C DVB-T)...
2013-09-10T07:57:28.217521+02:00 server kernel: [ 3999.330533] em2874
#0: Successfully loaded em28xx-dvb
2013-09-10T07:57:28.217522+02:00 server kernel: [ 3999.330536] Em28xx:
Initialized (Em28xx dvb Extension) extension
2013-09-10T07:57:28.223490+02:00 server kernel: [ 3999.335953]
Registered IR keymap rc-delock-61959
2013-09-10T07:57:28.223509+02:00 server kernel: [ 3999.336075] input:
em28xx IR (em2874 #0) as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/rc/rc10/input29
2013-09-10T07:57:28.223511+02:00 server kernel: [ 3999.336168] rc10:
em28xx IR (em2874 #0) as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/rc/rc10
2013-09-10T07:57:28.223513+02:00 server kernel: [ 3999.336571] Em28xx:
Initialized (Em28xx Input Extension) extension
2013-09-10T07:57:50.483486+02:00 server kernel: [ 4021.597678] Em28xx:
Removed (Em28xx dvb Extension) extension
2013-09-10T07:57:50.501696+02:00 server kernel: [ 4021.615023] Em28xx:
Removed (Em28xx Input Extension) extension
2013-09-10T07:57:50.501716+02:00 server kernel: [ 4021.615383]
usbcore: deregistering interface driver em28xx
2013-09-10T07:57:50.501719+02:00 server kernel: [ 4021.615400] em2874
#0: disconnecting em2874 #0 video
2013-09-10T07:57:50.501721+02:00 server kernel: [ 4021.615403] em2874
#0: V4L2 device video0 deregistered
2013-09-10T07:57:52.086487+02:00 server kernel: [ 4023.200624] em28xx:
New device  USB 2875 Device @ 480 Mbps (1b80:e1cc, interface 0, class
0)
2013-09-10T07:57:52.086510+02:00 server kernel: [ 4023.200629] em28xx:
DVB interface 0 found: isoc
2013-09-10T07:57:52.086512+02:00 server kernel: [ 4023.200710] em28xx:
chip ID is em2874
2013-09-10T07:57:52.347501+02:00 server kernel: [ 4023.461484] em2874
#0: i2c eeprom 0000: 26 00 01 00 02 08 c8 e5 f5 64 01 60 09 e5 f5 64
2013-09-10T07:57:52.347525+02:00 server kernel: [ 4023.461494] em2874
#0: i2c eeprom 0010: 09 60 03 c2 c6 22 e5 f7 b4 03 13 e5 f6 b4 87 03
2013-09-10T07:57:52.347527+02:00 server kernel: [ 4023.461500] em2874
#0: i2c eeprom 0020: 02 08 63 e5 f6 b4 93 03 02 06 f7 c2 c6 22 c2 c6
2013-09-10T07:57:52.347528+02:00 server kernel: [ 4023.461506] em2874
#0: i2c eeprom 0030: 22 00 60 00 90 00 60 12 06 29 7b 95 7a 67 79 eb
2013-09-10T07:57:52.347529+02:00 server kernel: [ 4023.461512] em2874
#0: i2c eeprom 0040: 78 1a c3 12 06 18 70 03 d3 80 01 c3 92 02 90 78
2013-09-10T07:57:52.347530+02:00 server kernel: [ 4023.461518] em2874
#0: i2c eeprom 0050: 0b 74 96 f0 74 82 f0 90 78 5d 74 05 f0 a3 f0 22
2013-09-10T07:57:52.347531+02:00 server kernel: [ 4023.461524] em2874
#0: i2c eeprom 0060: 00 00 00 00 1a eb 67 95 80 1b cc e1 f0 93 6b 00
2013-09-10T07:57:52.347532+02:00 server kernel: [ 4023.461529] em2874
#0: i2c eeprom 0070: 6a 20 00 00 00 00 04 57 4e 07 09 00 00 00 00 00
2013-09-10T07:57:52.347533+02:00 server kernel: [ 4023.461535] em2874
#0: i2c eeprom 0080: 00 00 00 00 4e 00 12 00 f0 10 44 89 88 00 00 00
2013-09-10T07:57:52.347534+02:00 server kernel: [ 4023.461541] em2874
#0: i2c eeprom 0090: 5b 81 c0 00 00 00 20 40 20 80 02 20 01 01 00 00
2013-09-10T07:57:52.347535+02:00 server kernel: [ 4023.461547] em2874
#0: i2c eeprom 00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
2013-09-10T07:57:52.347536+02:00 server kernel: [ 4023.461553] em2874
#0: i2c eeprom 00b0: c6 40 00 00 00 00 87 00 00 00 00 00 00 40 00 00
2013-09-10T07:57:52.347537+02:00 server kernel: [ 4023.461558] em2874
#0: i2c eeprom 00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 20 03
2013-09-10T07:57:52.347538+02:00 server kernel: [ 4023.461564] em2874
#0: i2c eeprom 00d0: 55 00 53 00 42 00 20 00 32 00 38 00 37 00 35 00
2013-09-10T07:57:52.347539+02:00 server kernel: [ 4023.461570] em2874
#0: i2c eeprom 00e0: 20 00 44 00 65 00 76 00 69 00 63 00 65 00 04 03
2013-09-10T07:57:52.347540+02:00 server kernel: [ 4023.461576] em2874
#0: i2c eeprom 00f0: 31 00 00 00 33 00 34 00 35 00 36 00 37 00 38 00
2013-09-10T07:57:52.347541+02:00 server kernel: [ 4023.461582] em2874
#0: i2c eeprom 0100: ... (skipped)
2013-09-10T07:57:52.347543+02:00 server kernel: [ 4023.461585] em2874
#0: EEPROM ID = 26 00 01 00, EEPROM hash = 0xde1f879b
2013-09-10T07:57:52.347544+02:00 server kernel: [ 4023.461586] em2874
#0: EEPROM info:
2013-09-10T07:57:52.347544+02:00 server kernel: [ 4023.461588] em2874
#0:     microcode start address = 0x0004, boot configuration = 0x01
2013-09-10T07:57:52.355517+02:00 server kernel: [ 4023.468985] em2874
#0:     I2S audio, 3 sample rates
2013-09-10T07:57:52.355537+02:00 server kernel: [ 4023.468991] em2874
#0:     500mA max power
2013-09-10T07:57:52.355539+02:00 server kernel: [ 4023.468993] em2874
#0:     Table at offset 0x04, strings=0x206a, 0x0000, 0x0000
2013-09-10T07:57:52.355540+02:00 server kernel: [ 4023.469086] em2874
#0: Identified as Delock 61959 (card=89)
2013-09-10T07:57:52.355542+02:00 server kernel: [ 4023.469092] em2874
#0: v4l2 driver version 0.2.0
2013-09-10T07:57:52.355543+02:00 server kernel: [ 4023.469458] em2874
#0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,143)
2013-09-10T07:57:52.356504+02:00 server kernel: [ 4023.470219] em2874
#0 em28xx_capture_area_set :capture area set to (0,0): 720x576
2013-09-10T07:57:52.360662+02:00 server kernel: [ 4023.474580] em2874
#0: V4L2 video device registered as video0
2013-09-10T07:57:52.360682+02:00 server kernel: [ 4023.474585] em2874
#0: dvb set to isoc mode.
2013-09-10T07:57:52.360684+02:00 server kernel: [ 4023.474588] em2874
#0 em28xx_alloc_urbs :em28xx: called em28xx_alloc_isoc in mode 2
2013-09-10T07:57:52.360686+02:00 server kernel: [ 4023.474590] em2874
#0 em28xx_uninit_usb_xfer :em28xx: called em28xx_uninit_usb_xfer in
mode 2
2013-09-10T07:57:52.360687+02:00 server kernel: [ 4023.474955]
usbcore: registered new interface driver em28xx
2013-09-10T07:57:52.364484+02:00 server kernel: [ 4023.478081] em2874
#0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,143)
2013-09-10T07:57:52.364511+02:00 server kernel: [ 4023.478607] em2874
#0 em28xx_capture_area_set :capture area set to (0,0): 720x576
2013-09-10T07:57:52.376514+02:00 server kernel: [ 4023.490330] drxk:
status = 0x639130d9
2013-09-10T07:57:52.376535+02:00 server kernel: [ 4023.490337] drxk:
detected a drx-3913k, spin A3, xtal 20.250 MHz
2013-09-10T07:57:52.433516+02:00 server kernel: [ 4023.547233] drxk:
DRXK driver version 0.9.4300
2013-09-10T07:57:52.447513+02:00 server kernel: [ 4023.561729] drxk:
frontend initialized.
2013-09-10T07:57:53.928765+02:00 server kernel: [ 4025.042553] em2874
#0: MaxMedia UB425-TC/Delock 61959: only DVB-C supported by that
driver version
2013-09-10T07:57:53.928790+02:00 server kernel: [ 4025.042561] DVB:
registering new adapter (em2874 #0)
2013-09-10T07:57:53.928792+02:00 server kernel: [ 4025.042570] usb
2-1.4: DVB: registering adapter 0 frontend 0 (DRXK DVB-C DVB-T)...
2013-09-10T07:57:53.928793+02:00 server kernel: [ 4025.042981] em2874
#0: Successfully loaded em28xx-dvb
2013-09-10T07:57:53.928794+02:00 server kernel: [ 4025.043002] Em28xx:
Initialized (Em28xx dvb Extension) extension
2013-09-10T07:57:53.938570+02:00 server kernel: [ 4025.052930]
Registered IR keymap rc-delock-61959
2013-09-10T07:57:53.938591+02:00 server kernel: [ 4025.053054] input:
em28xx IR (em2874 #0) as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/rc/rc11/input30
2013-09-10T07:57:53.939591+02:00 server kernel: [ 4025.053466] rc11:
em28xx IR (em2874 #0) as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/rc/rc11
2013-09-10T07:57:53.939605+02:00 server kernel: [ 4025.053927] Em28xx:
Initialized (Em28xx Input Extension) extension
2013-09-10T07:57:56.779569+02:00 server vdr: [21283] VDR version 2.0.3 started
2013-09-10T07:57:56.780138+02:00 server vdr: [21283] codeset is 'UTF-8' - known
2013-09-10T07:57:56.780578+02:00 server vdr: [21283] found 28 locales
in /usr/local/share/locale
2013-09-10T07:57:56.781507+02:00 server vdr: [21283] loading plugin:
/usr/local/lib64/vdr/libvdr-xineliboutput.so.2.0.0
2013-09-10T07:57:56.782151+02:00 server vdr: [21283] loading /etc/vdr/setup.conf
2013-09-10T07:57:56.782626+02:00 server vdr: [21283] loading
/etc/vdr/sources.conf
2013-09-10T07:57:56.783130+02:00 server vdr: [21283] loading
/etc/vdr/diseqc.conf
2013-09-10T07:57:56.783693+02:00 server vdr: [21283] loading
/etc/vdr/channels.conf
2013-09-10T07:57:56.786436+02:00 server vdr: [21283] loading
/etc/vdr/commands.conf
2013-09-10T07:57:56.787186+02:00 server vdr: [21283] loading
/etc/vdr/svdrphosts.conf
2013-09-10T07:57:56.787702+02:00 server vdr: [21283] loading
/etc/vdr/remote.conf
2013-09-10T07:57:56.788257+02:00 server vdr: [21283] loading
/etc/vdr/keymacros.conf
2013-09-10T07:57:56.788816+02:00 server vdr: [21283] ERROR: unknown
plugin 'yaepghd'
2013-09-10T07:57:56.789412+02:00 server vdr: [21283] ERROR: empty key macro
2013-09-10T07:57:56.800490+02:00 server vdr: [21284] video directory
scanner thread started (pid=21283, tid=21284, prio=high)
2013-09-10T07:57:56.802015+02:00 server vdr: [21283] registered source
parameters for 'A - ATSC'
2013-09-10T07:57:56.802536+02:00 server vdr: [21283] registered source
parameters for 'C - DVB-C'
2013-09-10T07:57:56.803021+02:00 server vdr: [21283] registered source
parameters for 'S - DVB-S'
2013-09-10T07:57:56.803511+02:00 server vdr: [21284] video directory
scanner thread ended (pid=21283, tid=21284)
2013-09-10T07:57:56.804039+02:00 server vdr: [21283] registered source
parameters for 'T - DVB-T'
2013-09-10T07:57:56.804529+02:00 server vdr: [21283] probing
/dev/dvb/adapter0/frontend0
2013-09-10T07:57:56.805012+02:00 server vdr: [21283] creating cDvbDevice
2013-09-10T07:57:56.805500+02:00 server vdr: [21283] new device number 1
2013-09-10T07:57:56.806001+02:00 server vdr: [21286] epg data reader
thread started (pid=21283, tid=21286, prio=high)
2013-09-10T07:57:56.806649+02:00 server vdr: [21286] reading EPG data
from /var/cache/vdr/epg.data
2013-09-10T07:57:56.808253+02:00 server vdr: [21283] DVB API version
is 0x050A (VDR was built with 0x0509)
2013-09-10T07:57:56.808958+02:00 server vdr: [21283] frontend 0/0
provides DVB-C,(null),DVB-T with QAM16,QAM32,QAM64,QAM128,QAM256
("DRXK DVB-C DVB-T")
2013-09-10T07:57:56.809509+02:00 server vdr: [21283] found 1 DVB device
2013-09-10T07:57:56.810030+02:00 server vdr: [21283] initializing
plugin: xineliboutput (2.0.0-cvs): X11/xine-lib Ausgabe-Plugin
2013-09-10T07:57:56.810611+02:00 server vdr: [21283] new device number 9
2013-09-10T07:57:56.811185+02:00 server vdr: [21283] [xine..put]
cTimePts: clock_gettime(CLOCK_MONOTONIC): clock resolution 0 us
2013-09-10T07:57:56.811722+02:00 server vdr: [21283] [xine..put]
cTimePts: using monotonic clock
2013-09-10T07:57:56.812289+02:00 server vdr: [21283] [xine..put] RTP
SSRC: 0x1011efa6
2013-09-10T07:57:56.812793+02:00 server vdr: [21285] video directory
scanner thread started (pid=21283, tid=21285, prio=high)
2013-09-10T07:57:56.813328+02:00 server vdr: [21285] video directory
scanner thread ended (pid=21283, tid=21285)
2013-09-10T07:57:56.814538+02:00 server vdr: [21283] setting primary device to 2
2013-09-10T07:57:56.814556+02:00 server vdr: [21289] section handler
thread started (pid=21283, tid=21289, prio=low)
2013-09-10T07:57:56.817685+02:00 server vdr: [21283] assuming manual
start of VDR
2013-09-10T07:57:56.817711+02:00 server vdr: [21283] SVDRP listening
on port 2001
2013-09-10T07:57:56.817716+02:00 server vdr: [21283] setting current
skin to "lcars"
2013-09-10T07:57:56.817719+02:00 server vdr: [21283] loading
/etc/vdr/themes/lcars-default.theme
2013-09-10T07:57:56.817721+02:00 server vdr: [21288] tuner on frontend
0/0 thread started (pid=21283, tid=21288, prio=high)
2013-09-10T07:57:56.817724+02:00 server vdr: [21283] starting plugin:
xineliboutput
2013-09-10T07:57:56.817726+02:00 server vdr: [21290] [xine..put] Have
CAP_SYS_NICE capability
2013-09-10T07:57:56.818359+02:00 server vdr: [21288] cTimeMs: using
monotonic clock (resolution is 1 ns)
2013-09-10T07:57:56.819803+02:00 server vdr: [21291] Remote
decoder/display server (cXinelibServer) thread started (pid=21283,
tid=21291, prio=high)
2013-09-10T07:57:56.820427+02:00 server vdr: [21291] [xine..put] Have
CAP_SYS_NICE capability
2013-09-10T07:57:56.821002+02:00 server vdr: [21291] [xine..put]
cXinelibServer priority set successful SCHED_RR 2 [1,99]
2013-09-10T07:57:56.821500+02:00 server vdr: [21291] [xine..put]
Listening on port 37890
2013-09-10T07:57:56.822189+02:00 server vdr: [21291] [xine..put]
Listening for UDP broadcasts on port 37890
2013-09-10T07:57:56.822698+02:00 server vdr: [21286] epg data reader
thread ended (pid=21283, tid=21286)
2013-09-10T07:57:56.824500+02:00 server kernel: [ 4027.938209] drxk:
Error -22 on get_lock_status
2013-09-10T07:57:56.913390+02:00 server vdr: [21283] [xine..put]
cXinelibDevice::StartDevice(): Device started
2013-09-10T07:57:56.913876+02:00 server vdr: [21283] remote control
KBD - keys known
2013-09-10T07:57:56.914239+02:00 server vdr: [21292] KBD remote
control thread started (pid=21283, tid=21292, prio=high)
2013-09-10T07:57:56.914706+02:00 server kernel: [ 4028.028450] em2874
#0 em28xx_init_usb_xfer :em28xx: called em28xx_init_usb_xfer in mode 2
2013-09-10T07:57:56.914727+02:00 server vdr: [21283] switching to channel 18
2013-09-10T07:57:56.915107+02:00 server vdr: [21293] receiver on
device 1 thread started (pid=21283, tid=21293, prio=high)
2013-09-10T07:57:56.915511+02:00 server vdr: [21294] TS buffer on
device 1 thread started (pid=21283, tid=21294, prio=high)
2013-09-10T07:57:56.924496+02:00 server kernel: [ 4028.038438] drxk:
Error -22 on get_lock_status
2013-09-10T07:57:56.931058+02:00 server vdr: [21283] OSD size changed
to 720x576 @ 1,42222
2013-09-10T07:57:56.944282+02:00 server vdr: [21283] [xine..put]
cXinelibOsd::CanHandleAreas(): Device does not support ARGB
2013-09-10T07:57:57.109489+02:00 server kernel: [ 4028.223758] drxk:
SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
2013-09-10T07:57:57.109512+02:00 server kernel: [ 4028.223764] drxk:
Warning -22 on qam_demodulator_command
2013-09-10T07:57:57.716014+02:00 server vdr: [21293] [xine..put]
Detected video size 720x576
2013-09-10T07:57:58.302362+02:00 server vdr: [21289] creating new
channel 'Detskij Mir,;Unitymedia' on C transponder 402 with id
9999-221-22102-0
2013-09-10T07:57:58.302937+02:00 server vdr: [21289] changing name of
channel 12 from 'Channel One Russia ,;Unitymedia' to 'Channel One
Russia,;Unitymedia'
2013-09-10T07:58:00.190179+02:00 server vdr: [21289] changing
transponder data of channel 3 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.190790+02:00 server vdr: [21289] changing
transponder data of channel 4 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.191954+02:00 server vdr: [21289] changing
transponder data of channel 5 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.191971+02:00 server vdr: [21289] changing
transponder data of channel 6 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.192105+02:00 server vdr: [21289] changing
transponder data of channel 7 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.192503+02:00 server vdr: [21289] changing
transponder data of channel 8 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.192942+02:00 server vdr: [21289] changing
transponder data of channel 9 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.193313+02:00 server vdr: [21289] changing
transponder data of channel 10 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.193696+02:00 server vdr: [21289] changing
transponder data of channel 11 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.194081+02:00 server vdr: [21289] changing
transponder data of channel 12 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.194651+02:00 server vdr: [21289] changing
transponder data of channel 13 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.195041+02:00 server vdr: [21289] changing
transponder data of channel 14 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.195472+02:00 server vdr: [21289] changing
transponder data of channel 15 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.195864+02:00 server vdr: [21289] changing
transponder data of channel 16 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.196228+02:00 server vdr: [21289] changing
transponder data of channel 17 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.196631+02:00 server vdr: [21289] changing
transponder data of channel 18 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.197054+02:00 server vdr: [21289] changing
transponder data of channel 19 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.197543+02:00 server vdr: [21289] changing
transponder data of channel 20 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.198032+02:00 server vdr: [21289] changing
transponder data of channel 21 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.198434+02:00 server vdr: [21289] changing
transponder data of channel 22 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.198833+02:00 server vdr: [21289] changing
transponder data of channel 23 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.199273+02:00 server vdr: [21289] changing
transponder data of channel 24 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.199838+02:00 server vdr: [21289] changing
transponder data of channel 363 from 402000:M256:C:6900 to
402000:C0M256:C:6900
2013-09-10T07:58:00.200302+02:00 server vdr: [21283] retuning due to
modification of channel 18
2013-09-10T07:58:00.200770+02:00 server vdr: [21283] switching to channel 18
2013-09-10T07:58:00.238141+02:00 server vdr: [21294] TS buffer on
device 1 thread ended (pid=21283, tid=21294)
2013-09-10T07:58:00.240854+02:00 server vdr: [21293] buffer stats:
62416 (1%) used
2013-09-10T07:58:00.241471+02:00 server vdr: [21293] receiver on
device 1 thread ended (pid=21283, tid=21293)
2013-09-10T07:58:00.257804+02:00 server vdr: [21358] receiver on
device 1 thread started (pid=21283, tid=21358, prio=high)
2013-09-10T07:58:00.258369+02:00 server vdr: [21359] TS buffer on
device 1 thread started (pid=21283, tid=21359, prio=high)
2013-09-10T07:58:00.558682+02:00 server vdr: [21358] [xine..put]
Detected video size 720x576
2013-09-10T07:58:01.782168+02:00 server vdr: [21289] changing pids of
channel 363 from 0+0=0:0:0:0 to 523+523=2:524=rus@4:0:0
2013-09-10T07:58:01.782791+02:00 server vdr: [21289] changing caids of
channel 363 from 0 to 1831,1722,1850,1838,1835
2013-09-10T07:58:04.413919+02:00 server vdr: [21289] changing pids of
channel 7 from 573+573=2:574=ita@4:0:575 to
573+573=2:574=ita@4,696=eng@4:0:575
2013-09-10T07:58:06.813754+02:00 server vdr: [21289] changing pids of
channel 12 from 623+623=2:624=@4:0:0 to 623+623=2:624=@3:0:0
2013-09-10T07:58:07.317887+02:00 server vdr: [21289] changing pids of
channel 13 from
633+633=2:634=spa@3,2241=ukr@4,2242=gre@4,2243=hun@4:0:635 to
633+633=2:634=esl@3,2241=ukr@3,2242=ell@3,2243=hun@3:0:635
2013-09-10T07:58:07.789712+02:00 server vdr: [21289] changing pids of
channel 14 from
633+633=2:644=fra@3,2241=ukr@4,2242=gre@4,2243=hun@4:0:635 to
633+633=2:644=fra@3,2241=ukr@3,2242=ell@3,2243=hun@3:0:635
2013-09-10T07:58:08.270818+02:00 server vdr: [21289] changing pids of
channel 15 from
633+633=2:654=eng@3,2241=ukr@4,2242=gre@4,2243=hun@4:0:635 to
633+633=2:654=eng@3,2241=ukr@3,2242=ell@3,2243=hun@3:0:635
2013-09-10T07:58:08.741670+02:00 server vdr: [21289] changing pids of
channel 16 from
633+633=2:664=ita@3,2241=ukr@4,2242=gre@4,2243=hun@4:0:635 to
633+633=2:664=ita@3,2241=ukr@3,2242=ell@3,2243=hun@3:0:635
2013-09-10T07:58:09.135830+02:00 server vdr: [21291] [xine..put]
Client 0 connected: 127.0.0.1:46271
2013-09-10T07:58:09.135856+02:00 server vdr: [21291] loading
/etc/vdr/plugins/xineliboutput/allowed_hosts.conf
2013-09-10T07:58:09.136519+02:00 server vdr: [21291] [xine..put]
cxSocket: setsockopt(SO_SNDBUF): got 262144 bytes
2013-09-10T07:58:09.136758+02:00 server vdr: [21291] [xine..put]
Trying PIPE connection ...
2013-09-10T07:58:09.137106+02:00 server vdr: [21291] creating
directory /etc/vdr/plugins/xineliboutput/pipes.21283
2013-09-10T07:58:09.137485+02:00 server vdr: [21291] removing
/etc/vdr/plugins/xineliboutput/pipes.21283
2013-09-10T07:58:09.137854+02:00 server vdr: [21291] [xine..put]
cBackgroundWriterI initialized (buffer 2048 kb)
2013-09-10T07:58:09.138209+02:00 server vdr: [21291] [xine..put]
cTcpWriter initialized (buffer 2048 kb)
2013-09-10T07:58:09.138630+02:00 server vdr: [21291] [xine..put] Pipe open
2013-09-10T07:58:09.213729+02:00 server vdr: [21289] changing pids of
channel 17 from
633+633=2:674=por@3,2241=ukr@4,2242=gre@4,2243=hun@4:0:635 to
633+633=2:674=por@3,2241=ukr@3,2242=ell@3,2243=hun@3:0:635
2013-09-10T07:58:09.717561+02:00 server vdr: [21289] changing pids of
channel 18 from
633+633=2:684=rus@3,2241=ukr@4,2242=gre@4,2243=hun@4:0:635 to
633+633=2:684=rus@3,2241=ukr@3,2242=ell@3,2243=hun@3:0:635
2013-09-10T07:58:10.189534+02:00 server vdr: [21289] changing pids of
channel 19 from
633+633=2:694=deu@3,2241=ukr@4,2242=gre@4,2243=hun@4:0:635 to
633+633=2:694=deu@3,2241=ukr@3,2242=ell@3,2243=hun@3:0:635
2013-09-10T07:58:10.209285+02:00 server vdr: [21283] OSD size changed
to 1920x1080 @ 1
2013-09-10T07:58:10.209871+02:00 server vdr: [21283] retuning due to
modification of channel 18
2013-09-10T07:58:10.210145+02:00 server vdr: [21283] switching to channel 18
2013-09-10T07:58:10.277877+02:00 server vdr: [21359] TS buffer on
device 1 thread ended (pid=21283, tid=21359)
2013-09-10T07:58:10.286061+02:00 server vdr: [21358] buffer stats:
66928 (1%) used
2013-09-10T07:58:10.286589+02:00 server vdr: [21358] receiver on
device 1 thread ended (pid=21283, tid=21358)
2013-09-10T07:58:10.300499+02:00 server vdr: [21552] receiver on
device 1 thread started (pid=21283, tid=21552, prio=high)
2013-09-10T07:58:10.300927+02:00 server vdr: [21553] TS buffer on
device 1 thread started (pid=21283, tid=21553, prio=high)
2013-09-10T07:58:11.302360+02:00 server vdr: [21552] [xine..put]
Detected video size 720x576
2013-09-10T07:58:19.574051+02:00 server vdr: [21283] [xine..put] OSD
bandwidth: 1238109 bytes/s (9672 kbit/s)
2013-09-10T07:58:19.692889+02:00 server vdr: [21289] changing pids of
channel 21 from 723+723=2:724=rus@4:0:0 to 0+0=0:0:0:0
2013-09-10T07:58:19.693437+02:00 server vdr: [21289] changing caids of
channel 21 from 1831,1722,1850,1838,1835 to 1831,1722,1838,1835
2013-09-10T07:58:20.172853+02:00 server vdr: [21289] changing pids of
channel 22 from
633+633=2:734=ara@3,2241=ukr@4,2242=gre@4,2243=hun@4:0:635 to
633+633=2:734=ara@3,2241=ukr@3,2242=ell@3,2243=hun@3:0:635
2013-09-10T07:58:20.583236+02:00 server vdr: [21283] [xine..put] OSD
bandwidth: 2260186 bytes/s (17657 kbit/s)
2013-09-10T07:58:20.583340+02:00 server vdr: [21283] switching to channel 1
2013-09-10T07:58:20.680981+02:00 server vdr: [21553] TS buffer on
device 1 thread ended (pid=21283, tid=21553)
2013-09-10T07:58:20.681926+02:00 server vdr: [21552] buffer stats:
82720 (1%) used
2013-09-10T07:58:20.682340+02:00 server vdr: [21552] receiver on
device 1 thread ended (pid=21283, tid=21552)
2013-09-10T07:58:20.703846+02:00 server vdr: [21707] receiver on
device 1 thread started (pid=21283, tid=21707, prio=high)
2013-09-10T07:58:20.704294+02:00 server vdr: [21708] TS buffer on
device 1 thread started (pid=21283, tid=21708, prio=high)
2013-09-10T07:58:21.031182+02:00 server vdr: [21288] frontend 0/0 lost
lock on channel 1, tp 610
2013-09-10T07:58:21.053516+02:00 server vdr: [21288] frontend 0/0
regained lock on channel 1, tp 610
2013-09-10T07:58:21.305275+02:00 server vdr: [21707] [xine..put]
Detected video size 720x576
2013-09-10T07:58:22.039544+02:00 server vdr: [21283] [xine..put] OSD
bandwidth: 2403888 bytes/s (18780 kbit/s)
2013-09-10T07:58:28.320468+02:00 server vdr: [21288] frontend 0/0 lost
lock on channel 1, tp 610
2013-09-10T07:58:28.342324+02:00 server vdr: [21288] frontend 0/0
regained lock on channel 1, tp 610
2013-09-10T07:58:34.024685+02:00 server vdr: [21291] [xine..put]
Closing connection 0
2013-09-10T07:58:40.547154+02:00 server vdr: [21283] stopping plugin:
xineliboutput
2013-09-10T07:58:40.547833+02:00 server vdr: [21283] [xine..put]
cXinelibDevice::StopDevice(): Stopping device ...
2013-09-10T07:58:40.639949+02:00 server vdr: [21708] TS buffer on
device 1 thread ended (pid=21283, tid=21708)
2013-09-10T07:58:40.647509+02:00 server vdr: [21707] buffer stats:
119568 (2%) used
2013-09-10T07:58:40.647795+02:00 server vdr: [21707] receiver on
device 1 thread ended (pid=21283, tid=21707)
2013-09-10T07:58:41.025023+02:00 server vdr: [21291] Remote
decoder/display server (cXinelibServer) thread ended (pid=21283,
tid=21291)
2013-09-10T07:58:41.041742+02:00 server vdr: [21283] [xine..put]
cXinelibOsdProvider: shutting down !
2013-09-10T07:58:41.042382+02:00 server vdr: [21292] KBD remote
control thread ended (pid=21283, tid=21292)
2013-09-10T07:58:41.096512+02:00 server vdr: [21283] saved setup to
/etc/vdr/setup.conf
2013-09-10T07:58:41.123524+02:00 server kernel: [ 4072.240289] em2874
#0 em28xx_stop_urbs :em28xx: called em28xx_stop_urbs
2013-09-10T07:58:41.195632+02:00 server vdr: [21289] section handler
thread ended (pid=21283, tid=21289)
2013-09-10T07:58:41.197859+02:00 server vdr: [21288] tuner on frontend
0/0 thread ended (pid=21283, tid=21288)
2013-09-10T07:58:41.208594+02:00 server vdr: [21283] [xine..put]
cXinelibDevice::StopDevice(): Stopping device ...
2013-09-10T07:58:41.209196+02:00 server vdr: [21283] deleting plugin:
xineliboutput
2013-09-10T07:58:41.287411+02:00 server vdr: [21283] caught signal 2
2013-09-10T07:58:41.287928+02:00 server vdr: [21283] exiting, exit code 0

Do you have any idea what's going wrong? Kernel version is 3.11.0. I'm
somehow experienced with kernel module development, so if there is
anything that I can debug, please let me know. Thanks!

Bye

Matthias
