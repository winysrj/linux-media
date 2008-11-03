Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout0.freenet.de ([195.4.92.90])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1Kx7Ni-0004xQ-Eo
	for linux-dvb@linuxtv.org; Mon, 03 Nov 2008 22:54:43 +0100
Message-ID: <490F732A.8060505@freenet.de>
Date: Mon, 03 Nov 2008 22:54:50 +0100
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: Tomas Drajsajtl <linux-dvb@drajsajtl.cz>
References: <001101c93ce7$23bcfdb0$7f79a8c0@tommy>
	<490E19B3.9090701@freenet.de>
	<001201c93d80$a9df4620$7f79a8c0@tommy>
In-Reply-To: <001201c93d80$a9df4620$7f79a8c0@tommy>
Content-Type: multipart/mixed; boundary="------------030900030504020600020506"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT DVB-C 2300 and CAM,
 Was: Any DVB-C tuner with working CAM?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------030900030504020600020506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dear Tomas

Attached you find part of my
/var/log/boot.msg

and

/var/log/messages

One hint: When switching from vdr 1.4.x to 1.5/1.6/1.7  the channel.conf
must be adapted with respect to decrypted channels.

Ciao Ruediger D.




--------------030900030504020600020506
Content-Type: text/plain;
 name="dvb-ttpci.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="dvb-ttpci.txt"

/*
* /var/log/boot.msg
*/

<4>ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
<6>ACPI: PCI Interrupt 0000:01:0a.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
<4>saa7146: found saa7146 @ mem f887e000 (revision 1, irq 18) (0x13c2,0x000a).
<7>ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c015112f7d8]
<6>DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-CA rev1.X)
<7>ieee1394: Host added: ID:BUS[1-00:1023]  GUID[00046100000905df]
<4>adapter has MAC addr = 00:d0:5c:04:45:e6
<4>dvb-ttpci: gpioirq unknown type=0 len=0
<4>dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 71010068, app 80002622
<4>dvb-ttpci: firmware @ card 0 supports CI link layer interface
<4>dvb-ttpci: DVB-C analog module @ card 0 detected, initializing MSP3415
<4>dvb_ttpci: saa7113 not accessible.
<4>saa7146_vv: saa7146 (0): registered device video0 [v4l2]
<4>saa7146_vv: saa7146 (0): registered device vbi0 [v4l2]
<4>DVB: registering frontend 0 (ST STV0297 DVB-C)...
<6>input: DVB on-card IR receiver as /devices/pci0000:00/0000:00:08.0/0000:01:0a.0/input/input5
<6>dvb-ttpci: found av7110-0.
<6>Adding 1052248k swap on /dev/sda2.  Priority:-1 extents:1 across:1052248k
<6>device-mapper: uevent: version 1.0.3
<6>device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
<6>loop: module loaded



/*
* /var/log/messages
*/

Nov  3 22:45:02 linux-nszr vdr: [1245] VDR version 1.4.2-2 started
Nov  3 22:45:02 linux-nszr vdr: [1245] loading /video/setup.conf
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: AntiAlias = 1
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: ChannelEntryTimeout = 1000
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: DisplaySubtitles = 0
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: EmergencyExit = 1
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: FontFix = Courier:Bold
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: FontFixSize = 20
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: FontOsd = Sans Serif:Bold
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: FontOsdSize = 22
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: FontSml = Sans Serif
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: FontSmlSize = 18
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: MenuKeyCloses = 0
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: NextWakeupTime = 0
Nov  3 22:45:02 linux-nszr vdr: [1245] ERROR: unknown config parameter: SortTimers = 1
Nov  3 22:45:03 linux-nszr vdr: [1245] ERROR: unknown config parameter: SubtitleBgTransparency = 0
Nov  3 22:45:03 linux-nszr vdr: [1245] ERROR: unknown config parameter: SubtitleFgTransparency = 0
Nov  3 22:45:03 linux-nszr vdr: [1245] ERROR: unknown config parameter: SubtitleLanguages = 
Nov  3 22:45:03 linux-nszr vdr: [1245] ERROR: unknown config parameter: SubtitleOffset = 0
Nov  3 22:45:03 linux-nszr vdr: [1245] loading /video/sources.conf
Nov  3 22:45:03 linux-nszr vdr: [1245] loading /video/diseqc.conf
Nov  3 22:45:03 linux-nszr vdr: [1245] loading /video/channels.conf
Nov  3 22:45:03 linux-nszr vdr: [1245] loading /video/timers.conf
Nov  3 22:45:03 linux-nszr vdr: [1245] loading /video/commands.conf
Nov  3 22:45:03 linux-nszr vdr: [1245] loading /video/svdrphosts.conf
Nov  3 22:45:03 linux-nszr vdr: [1245] loading /video/remote.conf
Nov  3 22:45:03 linux-nszr vdr: [1245] loading /video/keymacros.conf
Nov  3 22:45:03 linux-nszr vdr: [1246] video directory scanner thread started (pid=1245, tid=1246)
Nov  3 22:45:03 linux-nszr vdr: [1246] video directory scanner thread ended (pid=1245, tid=1246)
Nov  3 22:45:03 linux-nszr vdr: [1247] video directory scanner thread started (pid=1245, tid=1247)
Nov  3 22:45:03 linux-nszr vdr: [1247] video directory scanner thread ended (pid=1245, tid=1247)
Nov  3 22:45:03 linux-nszr vdr: [1245] reading EPG data from /video/epg.data
Nov  3 22:45:03 linux-nszr vdr: [1245] probing /dev/dvb/adapter0/frontend0
Nov  3 22:45:05 linux-nszr vdr: [1249] tuner on device 1 thread started (pid=1245, tid=1249)
Nov  3 22:45:05 linux-nszr vdr: [1250] section handler thread started (pid=1245, tid=1250)
Nov  3 22:45:05 linux-nszr vdr: [1245] found 1 video device
Nov  3 22:45:05 linux-nszr vdr: [1245] setting primary device to 1
Nov  3 22:45:05 linux-nszr vdr: [1245] SVDRP listening on port 2001
Nov  3 22:45:05 linux-nszr vdr: [1245] setting current skin to "sttng"
Nov  3 22:45:05 linux-nszr vdr: [1245] loading /video/themes/sttng-default.theme
Nov  3 22:45:05 linux-nszr vdr: [1245] ERROR: /dev/lircd: No such file or directory
Nov  3 22:45:05 linux-nszr vdr: [1251] KBD remote control thread started (pid=1245, tid=1251)
Nov  3 22:45:05 linux-nszr vdr: [1245] ERROR: remote control LIRC not ready!
Nov  3 22:45:05 linux-nszr vdr: [1245] remote control KBD - keys known
Nov  3 22:45:07 linux-nszr vdr: [1245] CAM: AlphaCrypt Light, 01, 4A20, 4A20
Nov  3 22:45:08 linux-nszr vdr: [1245] switching to channel 1
Nov  3 22:45:11 linux-nszr vdr: [1250] changing name of channel 24 from 'Bayerisches FS Süd,;ARD' to 'Bayerisches FS S#,;ARD'
Nov  3 22:45:11 linux-nszr vdr: [1250] changing name of channel 26 from 'WDR Köln,;ARD' to 'WDR K#n,;ARD'
Nov  3 22:45:13 linux-nszr vdr: [1245] switching to channel 34
Nov  3 22:45:16 linux-nszr vdr: [1250] creating new channel 'OraiaTV (engl),;Digital Free' on C transponder 330 with id 61441-10008-53119-0
Nov  3 22:45:16 linux-nszr vdr: [1250] changing name of channel 642 from 'Bayern Mobil,;ARD' to 'BAYERN plus,;ARD'
Nov  3 22:45:16 linux-nszr vdr: [1245] retuning due to modification of channel 34
Nov  3 22:45:16 linux-nszr vdr: [1245] switching to channel 34
Nov  3 22:45:18 linux-nszr vdr: [1250] changing pids of channel 676 from 0+0:0:0 to 941+941:942=deu:0
Nov  3 22:45:18 linux-nszr vdr: [1250] changing caids of channel 676 from 0 to 1801,1722,1834



--------------030900030504020600020506
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030900030504020600020506--
