Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59177 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbaJGR1K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Oct 2014 13:27:10 -0400
Received: from [192.168.1.21] ([79.215.164.222]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0MFMEG-1XNFBw0KOK-00EIwu for
 <linux-media@vger.kernel.org>; Tue, 07 Oct 2014 19:27:08 +0200
Message-ID: <5434226B.3010804@gmx.net>
Date: Tue, 07 Oct 2014 19:27:07 +0200
From: JPT <j-p-t@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: technisat-usb2: i2c-error
Content-Type: multipart/mixed;
 boundary="------------030702010305080706070205"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030702010305080706070205
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

my vdr crashed tonight during a recording.
The cause seems to be a problem with the recording device.

Hardware: ReadyNAS RN104, 512 MB RAM, Armada XP 370 (arm cpu)
DVB: Technisat SkyStar USB DVB-S2
Software: Debian Wheezy, selfbuilt kernel 3.16.3
technisat-usb2.c was modified to reduce buffer sizes:
framesperurb: reduced from 32 to 8

>From the log you can see:

00:30:00 recording starts

01:12:18 vdr finishes some EPG update (how if it currently is recording?)

01:14:30 vdr is killed by some watchdog
This is only 2 mins after the last entry in the syslog.
The CPU is very slow and VDR might be busy with something.
for comparison: Bringing up VDR-Admin takes 60 secs of CPU time
DVB device is shut down after vdr died. who does this? udev?

01:14:34 DVB device comes up again but fails because of
"technisat-usb2: i2c-error: in failed 53 = -110"

01:14:52 VDR fails to start because there is no recording device.


I was able to get things running by unloading the modules and loading
them again. After that I started VDR.

What exactly do the i2c-errors mean? Find attached a
"grep i2c-error syslog*"

Is there anything I could do to solve this problem?


thanks,

Jan

--------------030702010305080706070205
Content-Type: text/x-log;
 name="i2c-error.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="i2c-error.log"

Oct  2 11:25:04 NAS kernel: [    9.361314] technisat-usb2: i2c-error: 60 = 7
Oct  2 12:06:59 NAS kernel: [ 2526.872118] technisat-usb2: i2c-error: out failed 68 = -110
(last message repeats about 600 times)
Oct  2 12:25:34 NAS kernel: [ 3642.092133] technisat-usb2: i2c-error: out failed 68 = -110
Oct  6 15:01:45 NAS kernel: [    8.903217] technisat-usb2: i2c-error: 60 = 7
Oct  6 15:03:26 NAS kernel: [  112.690932] technisat-usb2: i2c-error: 60 = 7
Oct  6 16:03:03 NAS kernel: [ 3689.973270] technisat-usb2: i2c-error: 68 = 7
Oct  6 20:14:33 NAS kernel: [25361.311927] technisat-usb2: i2c-error: 68 = 7
Oct  6 23:09:03 NAS kernel: [35802.931257] technisat-usb2: i2c-error: 60 = 7
Oct  6 23:24:53 NAS kernel: [36749.793242] technisat-usb2: i2c-error: 68 = 7
Oct  7 00:30:20 NAS kernel: [40665.993697] technisat-usb2: i2c-error: 68 = 7
Oct  7 00:51:33 NAS kernel: [41935.932000] technisat-usb2: i2c-error: 68 = 7
Oct  7 01:14:35 NAS kernel: [43315.482001] technisat-usb2: i2c-error: in failed 53 = -110
Oct  7 01:14:36 NAS kernel: [43316.511949] technisat-usb2: i2c-error: in failed 68 = -110
Oct  7 18:14:34 NAS kernel: [104348.021889] technisat-usb2: i2c-error: in failed 53 = -110
Oct  7 18:14:35 NAS kernel: [104349.042024] technisat-usb2: i2c-error: in failed 68 = -110

--------------030702010305080706070205
Content-Type: text/x-log;
 name="vdr.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="vdr.log"

00:29:07 NAS vdr: [29981] switching device 1 to channel 68
00:29:51 NAS vdr: [29981] switching device 1 to channel 68
00:30:00 NAS vdr: [29981] switching device 1 to channel 68
00:30:00 NAS vdr: [29981] timer 1 (68 0030-0228 'Tatort Winternebel HD') start
00:30:00 NAS vdr: [29981] Title: 'Tatort: Winternebel' Subtitle: 'Fernsehfilm Deutschland 2014'
00:30:00 NAS vdr: [29981] executing '/usr/lib/vdr/vdr-recordingaction before "/var/lib/video.00/Tatort_Winternebel_HD/2014-10-07.00.30.68-0.rec"'
00:30:00 NAS recordingaction: executing /usr/share/vdr/recording-hooks/R90.custom before recording /var/lib/video.00/Tatort_Winternebel_HD/2014-10-07.00.30.68-0.rec as shell script
00:30:00 NAS vdr: [29981] record /var/lib/video.00/Tatort_Winternebel_HD/2014-10-07.00.30.68-0.rec
00:30:00 NAS vdr: [29981] creating directory /var/lib/video.00/Tatort_Winternebel_HD
00:30:00 NAS vdr: [29981] creating directory /var/lib/video.00/Tatort_Winternebel_HD/2014-10-07.00.30.68-0.rec
00:30:01 NAS vdr: [29981] recording to '/var/lib/video.00/Tatort_Winternebel_HD/2014-10-07.00.30.68-0.rec/00001.ts'
00:30:01 NAS vdr: [30459] recording thread started (pid=29981, tid=30459, prio=high)
00:30:01 NAS vdr: [30460] receiver on device 1 thread started (pid=29981, tid=30460, prio=high)
00:30:01 NAS vdr: [30461] TS buffer on device 1 thread started (pid=29981, tid=30461, prio=high)
00:30:20 NAS kernel: [40665.993697] technisat-usb2: i2c-error: 68 = 7


01:12:18 NAS vdr: [29990] EPGSearch: search timer update finished
01:13:29 NAS vdr: [29981] connect from 127.0.0.1, port 46920 - accepted
01:14:30 NAS vdr: [29981] PANIC: watchdog timer expired - exiting!
01:14:30 NAS vdr: [29989] fatal error, server exiting: Bad file descriptor
01:14:30 NAS vdr: [29989] streamdev server thread ended (pid=29981, tid=29989)
01:14:32 NAS runvdr: restarting VDR
01:14:32 NAS kernel: [43312.189196] usbcore: deregistering interface driver dvb_usb_technisat_usb2
01:14:32 NAS kernel: [43312.200786] evbug: Event. Dev: input12, Type: 0, Code: 0, Value: 1
01:14:32 NAS kernel: [43312.201235] evbug: Disconnected device: input12
01:14:32 NAS kernel: [43312.201490] evbug: Event. Dev: input11, Type: 0, Code: 0, Value: 1
01:14:32 NAS kernel: [43312.201593] evbug: Disconnected device: input11
01:14:32 NAS kernel: [43312.202697] dvb-usb: Technisat SkyStar USB HD (DVB-S/S2) successfully deinitialized and disconnected.
01:14:32 NAS systemd[1]: Stopping LSB: Starts LIRC daemon....
01:14:32 NAS systemd[1]: Stopped LSB: Starts LIRC daemon..
01:14:34 NAS kernel: [43314.440400] technisat-usb2: set alternate setting
01:14:34 NAS kernel: [43314.445729] technisat-usb2: firmware version: 17.63
01:14:34 NAS kernel: [43314.450649] dvb-usb: found a 'Technisat SkyStar USB HD (DVB-S/S2)' in warm state.
01:14:34 NAS kernel: [43314.460799] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
01:14:34 NAS kernel: [43314.475540] DVB: registering new adapter (Technisat SkyStar USB HD (DVB-S/S2))
01:14:35 NAS kernel: [43315.482001] technisat-usb2: i2c-error: in failed 53 = -110
01:14:35 NAS kernel: [43315.487506] dvb-usb: MAC address reading failed.
01:14:36 NAS kernel: [43316.511949] technisat-usb2: i2c-error: in failed 68 = -110
01:14:36 NAS kernel: [43316.518091] dvb-usb: no frontend was attached by 'Technisat SkyStar USB HD (DVB-S/S2)'
01:14:36 NAS kernel: [43316.526560] Registered IR keymap rc-technisat-usb2
01:14:36 NAS kernel: [43316.539433] input: IR-receiver inside an USB DVB receiver as 
/devices/soc/soc:pcie-controller/pci0000:00/0000:00:01.0/0000:01:00.0/usb2/2-1/rc/rc0/input13
01:14:36 NAS kernel: [43316.556872] evbug: Connected device: input13 (IR-receiver inside an USB DVB receiver at usb-0000:01:00.0-1/ir0)
01:14:36 NAS kernel: [43316.556893] rc0: IR-receiver inside an USB DVB receiver as 
/devices/soc/soc:pcie-controller/pci0000:00/0000:00:01.0/0000:01:00.0/usb2/2-1/rc/rc0
01:14:36 NAS kernel: [43316.574388] input: MCE IR Keyboard/Mouse (technisat-usb2) as /devices/virtual/input/input14
01:14:36 NAS kernel: [43316.588958] evbug: Connected device: input14 (MCE IR Keyboard/Mouse (technisat-usb2) at /input0)
01:14:36 NAS kernel: [43316.592443] rc rc0: lirc_dev: driver ir-lirc-codec (technisat-usb2) registered at minor = 0
01:14:36 NAS kernel: [43316.600845] dvb-usb: schedule remote query interval to 100 msecs.
01:14:36 NAS kernel: [43316.619452] dvb-usb: Technisat SkyStar USB HD (DVB-S/S2) successfully initialized and connected.
01:14:36 NAS kernel: [43316.646349] usbcore: registered new interface driver dvb_usb_technisat_usb2
01:14:36 NAS systemd[1]: Starting LSB: Starts LIRC daemon....
01:14:36 NAS lirc[31477]: No valid /etc/lirc/lircd.conf has been found..
01:14:36 NAS lirc[31477]: Remote control support has been disabled..
01:14:36 NAS lirc[31477]: Reconfigure LIRC or manually replace /etc/lirc/lircd.conf to enable..
01:14:36 NAS systemd[1]: Started LSB: Starts LIRC daemon..
01:14:51 NAS vdr: [31484] VDR version 2.0.3 started
01:14:51 NAS vdr: [31484] switched to user 'vdr'
01:14:51 NAS vdr: [31484] codeset is 'UTF-8' - known
01:14:51 NAS vdr: [31484] found 28 locales in /usr/share/locale
01:14:51 NAS vdr: [31484] loading plugin: /usr/lib/vdr/plugins/libvdr-live.so.2.0.0
01:14:52 NAS vdr: [31484] [live] INFO: validating server ip '0.0.0.0'
01:14:52 NAS vdr: [31484] loading plugin: /usr/lib/vdr/plugins/libvdr-streamdev-server.so.2.0.0
01:14:52 NAS vdr: [31484] loading plugin: /usr/lib/vdr/plugins/libvdr-epgsearch.so.2.0.0
01:14:52 NAS vdr: [31484] loading plugin: /usr/lib/vdr/plugins/libvdr-quickepgsearch.so.2.0.0
01:14:52 NAS vdr: [31484] loading plugin: /usr/lib/vdr/plugins/libvdr-epgsearchonly.so.2.0.0
01:14:52 NAS vdr: [31484] loading plugin: /usr/lib/vdr/plugins/libvdr-conflictcheckonly.so.2.0.0
01:14:52 NAS vdr: [31484] loading /var/lib/vdr/setup.conf
01:14:52 NAS vdr: [31484] loading /var/lib/vdr/sources.conf
01:14:52 NAS vdr: [31484] loading /var/lib/vdr/diseqc.conf
01:14:52 NAS vdr: [31484] loading /var/lib/vdr/scr.conf
01:14:52 NAS vdr: [31484] loading /var/lib/vdr/channels.conf
01:14:52 NAS vdr: [31484] loading /var/lib/vdr/timers.conf
01:14:52 NAS vdr: [31484] loading /var/lib/vdr/commands.conf
01:14:52 NAS vdr: [31484] loading /var/lib/vdr/reccmds.conf
01:14:52 NAS vdr: [31484] loading /var/lib/vdr/svdrphosts.conf
01:14:52 NAS vdr: [31484] loading /var/lib/vdr/keymacros.conf
01:14:52 NAS vdr: [31484] registered source parameters for 'A - ATSC'
01:14:52 NAS vdr: [31484] registered source parameters for 'C - DVB-C'
01:14:52 NAS vdr: [31484] registered source parameters for 'S - DVB-S'
01:14:52 NAS vdr: [31484] registered source parameters for 'T - DVB-T'
01:14:52 NAS vdr: [31484] no DVB device found
01:14:52 NAS vdr: [31484] initializing plugin: live (0.2.0): Live Interactive VDR Environment
01:14:52 NAS vdr: [31484] initializing plugin: streamdev-server (0.6.0-git): VDR Streaming Server
01:14:52 NAS vdr: [31484] initializing plugin: epgsearch (1.0.1.beta3): search the EPG for repeats and more
01:14:52 NAS vdr: [31484] initializing plugin: quickepgsearch (0.0.1): Quick search for broadcasts
01:14:52 NAS vdr: [31484] initializing plugin: epgsearchonly (0.0.1): Direct access to epgsearch's search menu
01:14:52 NAS vdr: [31484] initializing plugin: conflictcheckonly (0.0.1): Direct access to epgsearch's conflict check menu
01:14:52 NAS vdr: [31484] ERROR: invalid primary device number: 2
01:14:52 NAS vdr: [31484] ERROR: no primary device found - using first device!
01:14:52 NAS vdr: [31484] ERROR: invalid primary device number: 1
01:14:52 NAS vdr: [31484] deleting plugin: conflictcheckonly
01:14:52 NAS vdr: [31484] deleting plugin: epgsearchonly
01:14:52 NAS vdr: [31484] deleting plugin: quickepgsearch
01:14:52 NAS vdr: [31484] deleting plugin: epgsearch
01:14:52 NAS vdr: [31484] deleting plugin: streamdev-server
01:14:52 NAS vdr: [31484] deleting plugin: live
01:14:52 NAS vdr: [31486] video directory scanner thread started (pid=31484, tid=31486, prio=high)
01:14:52 NAS vdr: [31485] video directory scanner thread ended (pid=31484, tid=31485)
01:14:52 NAS runvdr: stopping after fatal fail (INFO: validating live server ip '0.0.0.0'#012vdr: no primary device found - using first device!)

--------------030702010305080706070205--
