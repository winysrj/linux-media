Return-path: <linux-media-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:22399 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015Ab0CAQR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 11:17:26 -0500
Message-ID: <4B8BE647.7070709@teksavvy.com>
Date: Mon, 01 Mar 2010 11:07:35 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, Andy Walls <awalls@radix.net>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org
Subject: cx18: Unable to find blank work order form to schedule incoming mailbox
 ...
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using MythTV-0.21-fixes (from svn) on top of Linux-2.6.33 (from kernel.org),
with an HVR-1600 tuner card.  This card usually works okay (with workarounds for
the known analog recording bugs) in both analog and digital modes.

Last night, for the first time ever, MythTV chose to record from both the analog
and digital sides of the HVR-1600 card at exactly the same times..

The kernel driver failed, and neither recording was successful.
The only message in /var/log/messages was:

Feb 28 19:59:45 duke kernel: cx18-0: Unable to find blank work order form to schedule incoming mailbox command processing

I strongly suspect some kind of conflict/race between the analog and digital sides,
as in this case both were trying to start a new recording at the same time.

Any ideas?

Log files follow..

The MythTV backend log file is a bit tricky to follow, because there are many other
tuners also present in the same system:

     2010-02-28 19:58:59.604 TVRec(42): ASK_RECORDING 42 29 0 0
     2010-02-28 19:58:59.923 TVRec(29): ASK_RECORDING 29 29 0 0
     2010-02-28 19:59:00.365 TVRec(41): ASK_RECORDING 41 29 0 0
     2010-02-28 19:59:29.463 TVRec(30): ASK_RECORDING 30 29 0 0
     2010-02-28 19:59:31.483 TVRec(41): Changing from None to RecordingOnly
     2010-02-28 19:59:31.486 TVRec(41): HW Tuner: 41->41
     2010-02-28 19:59:31.779 DVBSM(0), Warning: Can not measure Signal Strength
     			eno: Invalid argument (22)
     2010-02-28 19:59:31.781 DVBSM(0), Warning: Can not measure S/N
     			eno: Invalid argument (22)
     2010-02-28 19:59:31.801 AutoExpire: CalcParams(): Max required Free Space: 6.0 GB w/freq: 10 min
     2010-02-28 19:59:31.805 Started recording: XXI Winter Olympics "Closing Ceremony": channel 4271 on cardid 41, sourceid 4
     2010-02-28 19:59:31.827 TVRec(29): Changing from None to RecordingOnly
     2010-02-28 19:59:31.828 TVRec(29): HW Tuner: 29->29
     /usr/local/bin/diseqc_switcher[21502]: Selecting '2D'
     /usr/local/bin/diseqc_switcher[21502]: writing 0x0e [- - - - 1 1 1 -]
     /dev/video1: 211.250 MHz  (Signal Detected)
     2010-02-28 19:59:32.836 ret_pid(21499) child(21499) status(0x0)
     2010-02-28 19:59:32.838 External Tuning program exited with no error
     2010-02-28 19:59:32.885
     
     Not ivtv driver??
     
     
     2010-02-28 19:59:32.888 AutoExpire: CalcParams(): Max required Free Space: 6.0 GB w/freq: 8 min
     2010-02-28 19:59:32.891 Started recording: XXI Winter Olympics "Closing Ceremony": channel 1013 on cardid 29, sourceid 1
     2010-02-28 19:59:36.606 JobQueue: Commercial Flagging Starting for XXI Winter Olympics "Closing Ceremony" recorded from channel 1013 at Sun Feb 28 20:00:00 2010
     2010-02-28 19:59:36.749 Using runtime prefix = /usr
     2010-02-28 19:59:36.753 Empty LocalHostName.
     2010-02-28 19:59:36.755 Using localhost value of duke
     2010-02-28 19:59:36.766 New DB connection, total: 1
     2010-02-28 19:59:36.771 Connected to database 'mythconverg' at host: localhost
     2010-02-28 19:59:36.775 Closing DB connection named 'DBManager0'
     2010-02-28 19:59:36.777 Connected to database 'mythconverg' at host: localhost
     2010-02-28 19:59:36.782 New DB connection, total: 2
     2010-02-28 19:59:36.784 Connected to database 'mythconverg' at host: localhost
     2010-02-28 19:59:36.810 Connecting to backend server: 10.0.0.18:6543 (try 1 of 5)
     2010-02-28 19:59:36.814 Using protocol version 40
     2010-02-28 19:59:36.820 MainServer::HandleAnnounce Monitor
     2010-02-28 19:59:36.822 adding: duke as a client (events: 0)
     2010-02-28 19:59:36.826 MainServer::HandleAnnounce Monitor
     2010-02-28 19:59:36.828 adding: duke as a client (events: 1)
     2010-02-28 19:59:41.609 JobQueue: Commercial Flagging Starting for XXI Winter Olympics "Closing Ceremony" recorded from channel 4271 at Sun Feb 28 20:00:00 2010
     2010-02-28 19:59:41.695 Using runtime prefix = /usr
     2010-02-28 19:59:41.698 Empty LocalHostName.
     2010-02-28 19:59:41.704 Using localhost value of duke
     2010-02-28 19:59:41.712 New DB connection, total: 1
     2010-02-28 19:59:41.718 Connected to database 'mythconverg' at host: localhost
     2010-02-28 19:59:41.721 Closing DB connection named 'DBManager0'
     2010-02-28 19:59:41.724 Connected to database 'mythconverg' at host: localhost
     2010-02-28 19:59:41.730 New DB connection, total: 2
     2010-02-28 19:59:41.734 Connected to database 'mythconverg' at host: localhost
     2010-02-28 19:59:41.749 Connecting to backend server: 10.0.0.18:6543 (try 1 of 5)
     2010-02-28 19:59:41.751 Using protocol version 40
     2010-02-28 19:59:41.753 MainServer::HandleAnnounce Monitor
     2010-02-28 19:59:41.757 adding: duke as a client (events: 0)
     2010-02-28 19:59:41.760 MainServer::HandleAnnounce Monitor
     2010-02-28 19:59:41.762 adding: duke as a client (events: 1)
     2010-02-28 19:59:50.538 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 19:59:56.741 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:00:02.547 TVRec(30): Changing from RecordingOnly to None
     2010-02-28 20:00:02.552 Finished recording The Monarchy "King and Emperor": channel 1024
     2010-02-28 20:00:02.883 Finished recording The Monarchy "King and Emperor": channel 1024
     2010-02-28 20:00:02.908 TVRec(30): Changing from None to RecordingOnly
     2010-02-28 20:00:02.911 TVRec(30): HW Tuner: 30->30
     2010-02-28 20:00:02.943 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:00:02.963 Using runtime prefix = /usr
     2010-02-28 20:00:02.965 Empty LocalHostName.
     2010-02-28 20:00:02.967 Using localhost value of duke
     2010-02-28 20:00:02.977 New DB connection, total: 1
     2010-02-28 20:00:02.982 Connected to database 'mythconverg' at host: localhost
     2010-02-28 20:00:02.985 Closing DB connection named 'DBManager0'
     2010-02-28 20:00:02.987 Connected to database 'mythconverg' at host: localhost
     2010-02-28 20:00:02.992 New DB connection, total: 2
     2010-02-28 20:00:02.995 Connected to database 'mythconverg' at host: localhost
     2010-02-28 20:00:02.998 Current Schema Version: 1214
     /usr/local/bin/diseqc_switcher[21597]: Selecting '1B'
     /usr/local/bin/diseqc_switcher[21597]: writing 0x0d [- - - - 1 1 - 1]
     /dev/video0: 645.250 MHz  (Signal Detected)
     2010-02-28 20:00:03.925 ret_pid(21594) child(21594) status(0x0)
     2010-02-28 20:00:03.928 External Tuning program exited with no error
     2010-02-28 20:00:03.957 AutoExpire: CalcParams(): Max required Free Space: 6.0 GB w/freq: 8 min
     2010-02-28 20:00:03.960 Started recording: The Amazing Race 16 "Run Like Scalded Dogs!": channel 1043 on cardid 30, sourceid 1
      *********************** WARNING ***********************
      ivtv drivers prior to 0.10.0 can cause lockups when
      reading VBI. Drivers between 0.10.5 and 1.0.3+ do not
      properly capture VBI data on PVR-250 and PVR-350 cards.
     
     2010-02-28 20:00:05.005 Reschedule requested for id 0.
     2010-02-28 20:00:05.177 Scheduled 120 items in 0.2 = 0.00 match + 0.16 place
     2010-02-28 20:00:05.489 AFD: Opened codec 0x204a5d0, id(MPEG2VIDEO) type(Video)
     2010-02-28 20:00:05.492 AFD: codec MP2 has 2 channels
     2010-02-28 20:00:05.495 AFD: Opened codec 0x2053b20, id(MP2) type(Audio)
     2010-02-28 20:00:05.635 Preview: Grabbed preview '/var/lib/mythtv/recordings/1024_20100228190000.mpg' 720x480@180s
     2010-02-28 20:00:09.146 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:00:15.349 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:00:21.551 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:00:27.755 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:00:32.850 RingBuf(/var/lib/mythtv/recordings/4271_20100228200000.mpg): Waited 1.0 seconds for data to become available...
     2010-02-28 20:00:33.650 RingBuf(/var/lib/mythtv/recordings/1013_20100228200000.mpg): Waited 2.0 seconds for data to become available...
     2010-02-28 20:00:33.859 RingBuf(/var/lib/mythtv/recordings/4271_20100228200000.mpg): Waited 2.0 seconds for data to become available...
     2010-02-28 20:00:33.959 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:00:33.993 AFD: Opened codec 0xddbb70, id(MPEG2VIDEO) type(Video)
     2010-02-28 20:00:33.996 AFD: codec MP2 has 2 channels
     2010-02-28 20:00:33.998 AFD: Opened codec 0xde4850, id(MP2) type(Audio)
     2010-02-28 20:00:34.254 AFD: Opened codec 0x7fe7bc009230, id(MPEG2VIDEO) type(Video)
     2010-02-28 20:00:34.257 AFD: codec AC3 has 6 channels
     2010-02-28 20:00:34.260 AFD: Opened codec 0x7fe7bc0098b0, id(AC3) type(Audio)
     2010-02-28 20:00:34.264 AFD: codec AC3 has 1 channels
     2010-02-28 20:00:34.268 AFD: Opened codec 0x7fe7bc024520, id(AC3) type(Audio)
     2010-02-28 20:00:40.162 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:00:46.365 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:00:52.567 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:00:58.769 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:01:04.971 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:01:11.175 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:01:17.378 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:01:23.581 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:01:29.784 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:01:35.987 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding
     2010-02-28 20:01:42.190 MPEGRec(/dev/video1) Error: select timeout - ivtv driver has stopped responding

And here's /var/log/messages from boot up to/after the failure:

     Feb 28 12:55:56 duke syslogd 1.5.0#2ubuntu6: restart.
     Feb 28 12:55:58 duke ntpdate[3184]: step time server 10.0.0.2 offset 2.330536 sec
     Feb 28 12:55:58 duke ntpd[3556]: ntpd 4.2.4p4@1.1520-o Fri Dec  4 19:14:37 UTC 2009 (1)
     Feb 28 12:55:58 duke ntpd[3564]: precision = 1.000 usec
     Feb 28 12:55:58 duke ntpd[3564]: Listening on interface #0 wildcard, 0.0.0.0#123 Disabled
     Feb 28 12:55:58 duke ntpd[3564]: Listening on interface #1 lo, 127.0.0.1#123 Enabled
     Feb 28 12:55:58 duke ntpd[3564]: Listening on interface #2 eth0, 10.0.0.18#123 Enabled
     Feb 28 12:55:58 duke ntpd[3564]: Listening on interface #3 eth1, 169.254.4.100#123 Enabled
     Feb 28 12:55:58 duke ntpd[3564]: kernel time sync status 0040
     Feb 28 12:55:58 duke ntpd[3564]: frequency initialized 8.502 PPM from /var/lib/ntp/ntp.drift
     Feb 28 12:55:58 duke kernel: Inspecting /boot/System.map-2.6.33
     Feb 28 12:55:58 duke kernel: Inspecting /boot/System.map
     Feb 28 12:55:58 duke kernel: Inspecting /usr/src/linux/System.map
     Feb 28 12:55:59 duke kernel: Cannot find map file.
     Feb 28 12:55:59 duke kernel: Loaded 43513 symbols from 75 modules.
     Feb 28 12:55:59 duke kernel: orted from D0 D3hot D3cold
     Feb 28 12:55:59 duke kernel: pci 0000:00:1b.0: PME# disabled
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0: PME# disabled
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2: PME# disabled
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3: PME# disabled
     Feb 28 12:55:59 duke kernel: pci 0000:00:1d.0: reg 20: [io  0xf400-0xf41f]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1d.1: reg 20: [io  0xf000-0xf01f]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1d.2: reg 20: [io  0xec00-0xec1f]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1d.7: reg 10: [mem 0xfdffe000-0xfdffe3ff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
     Feb 28 12:55:59 duke kernel: pci 0000:00:1d.7: PME# disabled
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 003f)
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 003f)
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.2: reg 10: [io  0xe800-0xe807]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.2: reg 14: [io  0xe400-0xe403]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.2: reg 18: [io  0xe000-0xe007]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.2: reg 1c: [io  0xdc00-0xdc03]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.2: reg 20: [io  0xd800-0xd81f]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.2: reg 24: [mem 0xfdffd000-0xfdffd7ff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.2: PME# supported from D3hot
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.2: PME# disabled
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.3: reg 10: [mem 0xfdffc000-0xfdffc0ff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.3: reg 20: [io  0x0500-0x051f]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1f.6: reg 10: [mem 0xfdffb000-0xfdffbfff 64bit]
     Feb 28 12:55:59 duke kernel: pci 0000:01:00.0: reg 10: [mem 0xfb000000-0xfbffffff]
     Feb 28 12:55:59 duke kernel: pci 0000:01:00.0: reg 14: [mem 0xb0000000-0xbfffffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci 0000:01:00.0: reg 1c: [mem 0xce000000-0xcfffffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci 0000:01:00.0: reg 24: [io  0x5c00-0x5c7f]
     Feb 28 12:55:59 duke kernel: pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
     Feb 28 12:55:59 duke kernel: pci 0000:01:00.1: reg 10: [mem 0xfcffc000-0xfcffffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:01.0: PCI bridge to [bus 01-01]
     Feb 28 12:55:59 duke kernel: pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:01.0:   bridge window [mem 0xfb000000-0xfcffffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:01.0:   bridge window [mem 0xb0000000-0xcfffffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0: PCI bridge to [bus 02-02]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0:   bridge window [io  0xa000-0xafff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci 0000:03:00.0: reg 24: [mem 0xfdafe000-0xfdafffff]
     Feb 28 12:55:59 duke kernel: pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
     Feb 28 12:55:59 duke kernel: pci 0000:03:00.0: PME# supported from D3hot
     Feb 28 12:55:59 duke kernel: pci 0000:03:00.0: PME# disabled
     Feb 28 12:55:59 duke kernel: pci 0000:03:00.1: reg 10: [io  0x9c00-0x9c07]
     Feb 28 12:55:59 duke kernel: pci 0000:03:00.1: reg 14: [io  0x9800-0x9803]
     Feb 28 12:55:59 duke kernel: pci 0000:03:00.1: reg 18: [io  0x9400-0x9407]
     Feb 28 12:55:59 duke kernel: pci 0000:03:00.1: reg 1c: [io  0x9000-0x9003]
     Feb 28 12:55:59 duke kernel: pci 0000:03:00.1: reg 20: [io  0x8c00-0x8c0f]
     Feb 28 12:55:59 duke syslogd: /dev/console: Resource temporarily unavailable
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2: PCI bridge to [bus 03-03]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2:   bridge window [io  0x8000-0x9fff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2:   bridge window [mem 0xfda00000-0xfdafffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci 0000:04:00.0: reg 10: [mem 0xfdefc000-0xfdefffff 64bit]
     Feb 28 12:55:59 duke kernel: pci 0000:04:00.0: reg 18: [io  0x6c00-0x6cff]
     Feb 28 12:55:59 duke kernel: pci 0000:04:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
     Feb 28 12:55:59 duke kernel: pci 0000:04:00.0: supports D1 D2
     Feb 28 12:55:59 duke kernel: pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
     Feb 28 12:55:59 duke kernel: pci 0000:04:00.0: PME# disabled
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3: PCI bridge to [bus 04-04]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3:   bridge window [io  0x6000-0x6fff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3:   bridge window [mem 0xfde00000-0xfdefffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3:   bridge window [mem 0xfdd00000-0xfddfffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci 0000:05:00.0: reg 10: [mem 0xdbfff000-0xdbfff7ff]
     Feb 28 12:55:59 duke kernel: pci 0000:05:00.0: reg 14: [io  0x7c00-0x7c7f]
     Feb 28 12:55:59 duke kernel: pci 0000:05:00.0: supports D2
     Feb 28 12:55:59 duke kernel: pci 0000:05:00.0: PME# supported from D2 D3hot D3cold
     Feb 28 12:55:59 duke kernel: pci 0000:05:00.0: PME# disabled
     Feb 28 12:55:59 duke kernel: pci 0000:05:02.0: reg 10: [mem 0xf4000000-0xf7ffffff pref]
     Feb 28 12:55:59 duke kernel: pci 0000:05:03.0: reg 10: [mem 0xd4000000-0xd7ffffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
     Feb 28 12:55:59 duke kernel: pci 0000:00:1e.0:   bridge window [io  0x7000-0x7fff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1e.0:   bridge window [mem 0xd4000000-0xdbffffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xf7ffffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:00: on NUMA node 0
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 5 9 10 11 12 *14 15)
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 5 9 10 11 12 14 *15)
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 5 9 10 *11 12 14 15)
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 5 9 *10 11 12 14 15)
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 5 9 10 11 12 14 15) *0, disabled.
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 5 *9 10 11 12 14 15)
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Link [LNK0] (IRQs *5 9 10 11 12 14 15)
     Feb 28 12:55:59 duke kernel: ACPI: PCI Interrupt Link [LNK1] (IRQs 5 9 10 11 12 14 *15)
     Feb 28 12:55:59 duke kernel: vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
     Feb 28 12:55:59 duke kernel: vgaarb: loaded
     Feb 28 12:55:59 duke kernel: SCSI subsystem initialized
     Feb 28 12:55:59 duke kernel: libata version 3.00 loaded.
     Feb 28 12:55:59 duke kernel: PCI: Using ACPI for IRQ routing
     Feb 28 12:55:59 duke kernel: PCI: pci_cache_line_size set to 64 bytes
     Feb 28 12:55:59 duke kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
     Feb 28 12:55:59 duke kernel: hpet0: 3 comparators, 64-bit 14.318180 MHz counter
     Feb 28 12:55:59 duke kernel: Switching to clocksource tsc
     Feb 28 12:55:59 duke kernel: pnp: PnP ACPI init
     Feb 28 12:55:59 duke kernel: ACPI: bus type pnp registered
     Feb 28 12:55:59 duke kernel: pnp: PnP ACPI: found 14 devices
     Feb 28 12:55:59 duke kernel: ACPI: ACPI bus type pnp unregistered
     Feb 28 12:55:59 duke kernel: system 00:01: [io  0x04d0-0x04d1] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:01: [io  0x0290-0x029f] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:01: [io  0x0800-0x087f] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:01: [io  0x0880-0x088f] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:0a: [io  0x0400-0x04bf] could not be reserved
     Feb 28 12:55:59 duke kernel: system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0x000d6000-0x000d7fff] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0x000f0000-0x000f7fff] could not be reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0x000f8000-0x000fbfff] could not be reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0x000fc000-0x000fffff] could not be reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0x7ff00000-0x7fffffff] could not be reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0xfed00000-0xfed000ff] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0x7fee0000-0x7fefffff] could not be reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0x00100000-0x7fedffff] could not be reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0xfed13000-0xfed1ffff] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0xfed20000-0xfed9ffff] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0xffb00000-0xffb7ffff] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0xfff00000-0xffffffff] has been reserved
     Feb 28 12:55:59 duke kernel: system 00:0d: [mem 0x000e0000-0x000effff] has been reserved
     Feb 28 12:55:59 duke kernel: pci 0000:01:00.0: BAR 6: assigned [mem 0xc0000000-0xc007ffff pref]
     Feb 28 12:55:59 duke kernel: pci 0000:00:01.0: PCI bridge to [bus 01-01]
     Feb 28 12:55:59 duke kernel: pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:01.0:   bridge window [mem 0xfb000000-0xfcffffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:01.0:   bridge window [mem 0xb0000000-0xcfffffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0: PCI bridge to [bus 02-02]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0:   bridge window [io  0xa000-0xafff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci 0000:03:00.0: BAR 6: assigned [mem 0xfd900000-0xfd90ffff pref]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2: PCI bridge to [bus 03-03]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2:   bridge window [io  0x8000-0x9fff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2:   bridge window [mem 0xfda00000-0xfdafffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci 0000:04:00.0: BAR 6: assigned [mem 0xfdd00000-0xfdd1ffff pref]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3: PCI bridge to [bus 04-04]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3:   bridge window [io  0x6000-0x6fff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3:   bridge window [mem 0xfde00000-0xfdefffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3:   bridge window [mem 0xfdd00000-0xfddfffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1e.0: PCI bridge to [bus 05-05]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1e.0:   bridge window [io  0x7000-0x7fff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1e.0:   bridge window [mem 0xd4000000-0xdbffffff]
     Feb 28 12:55:59 duke kernel: pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xf7ffffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
     Feb 28 12:55:59 duke kernel: pci 0000:00:01.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.2: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
     Feb 28 12:55:59 duke kernel: pci 0000:00:1c.3: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: pci 0000:00:1e.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:01: resource 1 [mem 0xfb000000-0xfcffffff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:01: resource 2 [mem 0xb0000000-0xcfffffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:02: resource 1 [mem 0xfdc00000-0xfdcfffff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:02: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:03: resource 0 [io  0x8000-0x9fff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:03: resource 1 [mem 0xfda00000-0xfdafffff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:03: resource 2 [mem 0xfd900000-0xfd9fffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:04: resource 0 [io  0x6000-0x6fff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:04: resource 1 [mem 0xfde00000-0xfdefffff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:04: resource 2 [mem 0xfdd00000-0xfddfffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:05: resource 0 [io  0x7000-0x7fff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:05: resource 1 [mem 0xd4000000-0xdbffffff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:05: resource 2 [mem 0xf4000000-0xf7ffffff 64bit pref]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:05: resource 3 [io  0x0000-0xffff]
     Feb 28 12:55:59 duke kernel: pci_bus 0000:05: resource 4 [mem 0x00000000-0xffffffffffffffff]
     Feb 28 12:55:59 duke kernel: NET: Registered protocol family 2
     Feb 28 12:55:59 duke kernel: IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
     Feb 28 12:55:59 duke kernel: TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
     Feb 28 12:55:59 duke kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
     Feb 28 12:55:59 duke kernel: TCP: Hash tables configured (established 262144 bind 65536)
     Feb 28 12:55:59 duke kernel: TCP reno registered
     Feb 28 12:55:59 duke kernel: UDP hash table entries: 1024 (order: 3, 32768 bytes)
     Feb 28 12:55:59 duke kernel: UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
     Feb 28 12:55:59 duke kernel: NET: Registered protocol family 1
     Feb 28 12:55:59 duke kernel: pci 0000:01:00.0: Boot video device
     Feb 28 12:55:59 duke kernel: PCI: CLS 64 bytes, default 64
     Feb 28 12:55:59 duke kernel: Scanning for low memory corruption every 60 seconds
     Feb 28 12:55:59 duke kernel: HugeTLB registered 2 MB page size, pre-allocated 0 pages
     Feb 28 12:55:59 duke kernel: SGI XFS with security attributes, realtime, large block/inode numbers, no debug enabled
     Feb 28 12:55:59 duke kernel: msgmni has been set to 4019
     Feb 28 12:55:59 duke kernel: alg: No test for stdrng (krng)
     Feb 28 12:55:59 duke kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
     Feb 28 12:55:59 duke kernel: io scheduler noop registered
     Feb 28 12:55:59 duke kernel: io scheduler cfq registered (default)
     Feb 28 12:55:59 duke kernel: pcieport 0000:00:01.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: pcieport 0000:00:1c.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: pcieport 0000:00:1c.2: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: pcieport 0000:00:1c.3: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: lp: driver loaded but no devices found
     Feb 28 12:55:59 duke kernel: Generic RTC Driver v1.07
     Feb 28 12:55:59 duke kernel: Non-volatile memory driver v1.3
     Feb 28 12:55:59 duke kernel: Linux agpgart interface v0.103
     Feb 28 12:55:59 duke kernel: [drm] Initialized drm 1.1.0 20060810
     Feb 28 12:55:59 duke kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
     Feb 28 12:55:59 duke kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
     Feb 28 12:55:59 duke kernel: 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
     Feb 28 12:55:59 duke kernel: parport_pc 00:08: reported by Plug and Play ACPI
     Feb 28 12:55:59 duke kernel: parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
     Feb 28 12:55:59 duke kernel: lp0: using parport0 (interrupt-driven).
     Feb 28 12:55:59 duke kernel: loop: module loaded
     Feb 28 12:55:59 duke kernel: ahci 0000:00:1f.2: version 3.0
     Feb 28 12:55:59 duke kernel: ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
     Feb 28 12:55:59 duke kernel: ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
     Feb 28 12:55:59 duke kernel: ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ccc ems
     Feb 28 12:55:59 duke kernel: ahci 0000:00:1f.2: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: scsi0 : ahci
     Feb 28 12:55:59 duke kernel: scsi1 : ahci
     Feb 28 12:55:59 duke kernel: scsi2 : ahci
     Feb 28 12:55:59 duke kernel: scsi3 : ahci
     Feb 28 12:55:59 duke kernel: scsi4 : ahci
     Feb 28 12:55:59 duke kernel: scsi5 : ahci
     Feb 28 12:55:59 duke kernel: ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 17
     Feb 28 12:55:59 duke kernel: ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 17
     Feb 28 12:55:59 duke kernel: ata3: DUMMY
     Feb 28 12:55:59 duke kernel: ata4: DUMMY
     Feb 28 12:55:59 duke kernel: ata5: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 17
     Feb 28 12:55:59 duke kernel: ata6: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd380 irq 17
     Feb 28 12:55:59 duke kernel: ahci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
     Feb 28 12:55:59 duke kernel: ahci 0000:03:00.0: JMB361 has only one port, port_map 0x3 -> 0x1
     Feb 28 12:55:59 duke kernel: ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x1 impl SATA mode
     Feb 28 12:55:59 duke kernel: ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part
     Feb 28 12:55:59 duke kernel: ahci 0000:03:00.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: scsi6 : ahci
     Feb 28 12:55:59 duke kernel: scsi7 : ahci
     Feb 28 12:55:59 duke kernel: ata7: SATA max UDMA/133 abar m8192@0xfdafe000 port 0xfdafe100 irq 18
     Feb 28 12:55:59 duke kernel: ata8: DUMMY
     Feb 28 12:55:59 duke kernel: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
     Feb 28 12:55:59 duke kernel: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
     Feb 28 12:55:59 duke kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
     Feb 28 12:55:59 duke kernel: mice: PS/2 mouse device common for all mice
     Feb 28 12:55:59 duke kernel: md: raid0 personality registered for level 0
     Feb 28 12:55:59 duke kernel: cpuidle: using governor ladder
     Feb 28 12:55:59 duke kernel: ioatdma: Intel(R) QuickData Technology Driver 4.00
     Feb 28 12:55:59 duke kernel: TCP cubic registered
     Feb 28 12:55:59 duke kernel: NET: Registered protocol family 17
     Feb 28 12:55:59 duke kernel: ata7: SATA link down (SStatus 0 SControl 300)
     Feb 28 12:55:59 duke kernel: ata6: SATA link down (SStatus 0 SControl 300)
     Feb 28 12:55:59 duke kernel: ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
     Feb 28 12:55:59 duke kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
     Feb 28 12:55:59 duke kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
     Feb 28 12:55:59 duke kernel: ata1.00: ATA-8: OCZ-VERTEX, 1.5, max UDMA/133
     Feb 28 12:55:59 duke kernel: ata1.00: 125045424 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
     Feb 28 12:55:59 duke kernel: ata1.00: configured for UDMA/133
     Feb 28 12:55:59 duke kernel: scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX       1.5  PQ: 0 ANSI: 5
     Feb 28 12:55:59 duke kernel: sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
     Feb 28 12:55:59 duke kernel: sd 0:0:0:0: [sda] Write Protect is off
     Feb 28 12:55:59 duke kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
     Feb 28 12:55:59 duke kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
     Feb 28 12:55:59 duke kernel:  sda: sda1 sda2
     Feb 28 12:55:59 duke kernel: ata2.00: ATA-7: ST3750640NS, 3.BAF, max UDMA/133
     Feb 28 12:55:59 duke kernel: ata2.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
     Feb 28 12:55:59 duke kernel: sd 0:0:0:0: [sda] Attached SCSI disk
     Feb 28 12:55:59 duke kernel: ata2.00: configured for UDMA/133
     Feb 28 12:55:59 duke kernel: ata5.00: ATA-7: ST3750640NS, 3.BAF, max UDMA/133
     Feb 28 12:55:59 duke kernel: scsi 1:0:0:0: Direct-Access     ATA      ST3750640NS      3.BA PQ: 0 ANSI: 5
     Feb 28 12:55:59 duke kernel: sd 1:0:0:0: [sdb] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
     Feb 28 12:55:59 duke kernel: sd 1:0:0:0: [sdb] Write Protect is off
     Feb 28 12:55:59 duke kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
     Feb 28 12:55:59 duke kernel: sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
     Feb 28 12:55:59 duke kernel:  sdb: sdb1 sdb2
     Feb 28 12:55:59 duke kernel: ata5.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
     Feb 28 12:55:59 duke kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
     Feb 28 12:55:59 duke kernel: ata5.00: configured for UDMA/133
     Feb 28 12:55:59 duke kernel: scsi 4:0:0:0: Direct-Access     ATA      ST3750640NS      3.BA PQ: 0 ANSI: 5
     Feb 28 12:55:59 duke kernel: sd 4:0:0:0: [sdc] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
     Feb 28 12:55:59 duke kernel: sd 4:0:0:0: [sdc] Write Protect is off
     Feb 28 12:55:59 duke kernel: sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
     Feb 28 12:55:59 duke kernel: sd 4:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
     Feb 28 12:55:59 duke kernel:  sdc: sdc1 sdc2
     Feb 28 12:55:59 duke kernel: sd 4:0:0:0: [sdc] Attached SCSI disk
     Feb 28 12:55:59 duke kernel: md: Waiting for all devices to be available before autodetect
     Feb 28 12:55:59 duke kernel: md: If you don't use raid, use raid=noautodetect
     Feb 28 12:55:59 duke kernel: md: Autodetecting RAID arrays.
     Feb 28 12:55:59 duke kernel: md: Scanned 2 and added 2 devices.
     Feb 28 12:55:59 duke kernel: md: autorun ...
     Feb 28 12:55:59 duke kernel: md: considering sdc2 ...
     Feb 28 12:55:59 duke kernel: md:  adding sdc2 ...
     Feb 28 12:55:59 duke kernel: md:  adding sdb2 ...
     Feb 28 12:55:59 duke kernel: md: created md0
     Feb 28 12:55:59 duke kernel: md: bind<sdb2>
     Feb 28 12:55:59 duke kernel: md: bind<sdc2>
     Feb 28 12:55:59 duke kernel: md: running: <sdc2><sdb2>
     Feb 28 12:55:59 duke kernel: raid0: looking at sdc2
     Feb 28 12:55:59 duke kernel: raid0:   comparing sdc2(1433013760)
     Feb 28 12:55:59 duke kernel:  with sdc2(1433013760)
     Feb 28 12:55:59 duke kernel: raid0:   END
     Feb 28 12:55:59 duke kernel: raid0:   ==> UNIQUE
     Feb 28 12:55:59 duke kernel: raid0: 1 zones
     Feb 28 12:55:59 duke kernel: raid0: looking at sdb2
     Feb 28 12:55:59 duke kernel: raid0:   comparing sdb2(1433013760)
     Feb 28 12:55:59 duke kernel:  with sdc2(1433013760)
     Feb 28 12:55:59 duke kernel: raid0:   EQUAL
     Feb 28 12:55:59 duke kernel: raid0: FINAL 1 zones
     Feb 28 12:55:59 duke kernel: raid0: done.
     Feb 28 12:55:59 duke kernel: raid0 : md_size is 2866027520 sectors.
     Feb 28 12:55:59 duke kernel: ******* md0 configuration *********
     Feb 28 12:55:59 duke kernel: zone0=[sdb2/sdc2/]
     Feb 28 12:55:59 duke kernel:         zone offset=0kb device offset=0kb size=1433013760kb
     Feb 28 12:55:59 duke kernel: **********************************
     Feb 28 12:55:59 duke kernel:
     Feb 28 12:55:59 duke kernel: md0: detected capacity change from 0 to 1467406090240
     Feb 28 12:55:59 duke kernel: md: ... autorun DONE.
     Feb 28 12:55:59 duke kernel: EXT3-fs (sda2): error: couldn't mount because of unsupported optional features (240)
     Feb 28 12:55:59 duke kernel: EXT4-fs (sda2): mounted filesystem with ordered data mode
     Feb 28 12:55:59 duke kernel: VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
     Feb 28 12:55:59 duke kernel: Freeing unused kernel memory: 408k freed
     Feb 28 12:55:59 duke kernel: fuse init (API version 7.13)
     Feb 28 12:55:59 duke kernel: HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
     Feb 28 12:55:59 duke kernel: HDA Intel 0000:00:1b.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: hda_codec: ALC883: BIOS auto-probing.
     Feb 28 12:55:59 duke kernel: HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
     Feb 28 12:55:59 duke kernel: HDA Intel 0000:01:00.1: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: Linux video capture interface: v2.00
     Feb 28 12:55:59 duke kernel: ivtv: Start initialization, version 1.4.1
     Feb 28 12:55:59 duke kernel: ivtv0: Initializing card 0
     Feb 28 12:55:59 duke kernel: ivtv0: Autodetected Hauppauge card (cx23416 based)
     Feb 28 12:55:59 duke kernel: ivtv 0000:05:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
     Feb 28 12:55:59 duke kernel: tveeprom 0-0050: Hauppauge model 32062, rev B185, serial# 2842715
     Feb 28 12:55:59 duke kernel: tveeprom 0-0050: tuner model is TCL 2002N 6A (idx 85, type 50)
     Feb 28 12:55:59 duke kernel: tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
     Feb 28 12:55:59 duke kernel: tveeprom 0-0050: audio processor is MSP3445 (idx 12)
     Feb 28 12:55:59 duke kernel: tveeprom 0-0050: decoder processor is SAA7115 (idx 19)
     Feb 28 12:55:59 duke kernel: tveeprom 0-0050: has no radio, has IR receiver, has no IR transmitter
     Feb 28 12:55:59 duke kernel: ivtv0: Autodetected Hauppauge WinTV PVR-250
     Feb 28 12:55:59 duke kernel: saa7115 0-0021: saa7115 found (1f7115d0e100000) @ 0x42 (ivtv i2c driver #0)
     Feb 28 12:55:59 duke kernel: msp3400 0-0040: MSP3445G-B8 found @ 0x80 (ivtv i2c driver #0)
     Feb 28 12:55:59 duke kernel: msp3400 0-0040: msp3400 supports radio, mode is autodetect and autoselect
     Feb 28 12:55:59 duke kernel: tuner 0-0061: chip found @ 0xc2 (ivtv i2c driver #0)
     Feb 28 12:55:59 duke kernel: tuner-simple 0-0061: creating new instance
     Feb 28 12:55:59 duke kernel: tuner-simple 0-0061: type set to 50 (TCL 2002N)
     Feb 28 12:55:59 duke kernel: IRQ 17/ivtv0: IRQF_DISABLED is not guaranteed on shared IRQs
     Feb 28 12:55:59 duke kernel: ivtv0: Registered device video0 for encoder MPG (4096 kB)
     Feb 28 12:55:59 duke kernel: ivtv0: Registered device video32 for encoder YUV (2048 kB)
     Feb 28 12:55:59 duke kernel: ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
     Feb 28 12:55:59 duke kernel: ivtv0: Registered device video24 for encoder PCM (320 kB)
     Feb 28 12:55:59 duke kernel: ivtv0: Initialized card: Hauppauge WinTV PVR-250
     Feb 28 12:55:59 duke kernel: ivtv: End initialization
     Feb 28 12:55:59 duke kernel:  md0: unknown partition table
     Feb 28 12:55:59 duke kernel: thermal LNXTHERM:01: registered as thermal_zone0
     Feb 28 12:55:59 duke kernel: ACPI: Invalid PBLK length [0]
     Feb 28 12:55:59 duke kernel: input: Power Button as /class/input/input0
     Feb 28 12:55:59 duke kernel: ACPI: Power Button [PWRB]
     Feb 28 12:55:59 duke kernel: ACPI Error (psparse-0537):
     Feb 28 12:55:59 duke kernel: ACPI: Thermal Zone [THRM] (30 C)
     Feb 28 12:55:59 duke kernel: usbcore: registered new interface driver usbfs
     Feb 28 12:55:59 duke kernel: Method parse/execution failed
     Feb 28 12:55:59 duke kernel: usbcore: registered new interface driver hub
     Feb 28 12:55:59 duke kernel: [\_PR_.CPU0._PDC] (Node ffff88007f858490), AE_ALREADY_EXISTS
     Feb 28 12:55:59 duke kernel: ACPI:
     Feb 28 12:55:59 duke kernel: usbcore: registered new device driver usb
     Feb 28 12:55:59 duke kernel: Marking method _PDC as Serialized because of AE_ALREADY_EXISTS error
     Feb 28 12:55:59 duke kernel: input: Power Button as /class/input/input1
     Feb 28 12:55:59 duke kernel: ACPI: Power Button [PWRF]
     Feb 28 12:55:59 duke kernel: ACPI: Invalid PBLK length [0]
     Feb 28 12:55:59 duke kernel: ACPI: SSDT 000000007fee8750 000CE (v01  PmRef  Cpu1Ist 00003000 INTL 20041203)
     Feb 28 12:55:59 duke kernel: nvidia: module license 'NVIDIA' taints kernel.
     Feb 28 12:55:59 duke kernel:
     Feb 28 12:55:59 duke kernel: firewire_ohci 0000:05:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
     Feb 28 12:55:59 duke kernel: firewire_ohci 0000:05:00.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: cx18:  Start initialization, version 1.3.0
     Feb 28 12:55:59 duke kernel: sky2 driver version 1.26
     Feb 28 12:55:59 duke kernel: sky2 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
     Feb 28 12:55:59 duke kernel: pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
     Feb 28 12:55:59 duke kernel: pata_jmicron 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
     Feb 28 12:55:59 duke kernel: pata_jmicron 0000:03:00.1: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
     Feb 28 12:55:59 duke kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
     Feb 28 12:55:59 duke kernel: sd 4:0:0:0: Attached scsi generic sg2 type 0
     Feb 28 12:55:59 duke kernel: scsi8 : pata_jmicron
     Feb 28 12:55:59 duke kernel: scsi9 : pata_jmicron
     Feb 28 12:55:59 duke kernel: ata9: PATA max UDMA/100 cmd 0x9c00 ctl 0x9800 bmdma 0x8c00 irq 19
     Feb 28 12:55:59 duke kernel: ata10: PATA max UDMA/100 cmd 0x9400 ctl 0x9000 bmdma 0x8c08 irq 19
     Feb 28 12:55:59 duke kernel: ACPI: Fan [FAN] (on)
     Feb 28 12:55:59 duke kernel: uhci_hcd: USB Universal Host Controller Interface driver
     Feb 28 12:55:59 duke kernel: firewire_ohci: Added fw-ohci device 0000:05:00.0, OHCI version 1.10
     Feb 28 12:55:59 duke kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1a.7: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1a.7: EHCI Host Controller
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdfff000
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
     Feb 28 12:55:59 duke kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
     Feb 28 12:55:59 duke kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
     Feb 28 12:55:59 duke kernel: cx18-0: Initializing card 0
     Feb 28 12:55:59 duke kernel: cx18-0: Autodetected Hauppauge card
     Feb 28 12:55:59 duke kernel: sky2 0000:04:00.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 2
     Feb 28 12:55:59 duke kernel: sky2 eth0: addr 00:15:58:8a:ae:e5
     Feb 28 12:55:59 duke kernel: usb usb1: Product: EHCI Host Controller
     Feb 28 12:55:59 duke kernel: usb usb1: Manufacturer: Linux 2.6.33 ehci_hcd
     Feb 28 12:55:59 duke kernel: usb usb1: SerialNumber: 0000:00:1a.7
     Feb 28 12:55:59 duke kernel: hub 1-0:1.0: USB hub found
     Feb 28 12:55:59 duke kernel: hub 1-0:1.0: 4 ports detected
     Feb 28 12:55:59 duke kernel: cx18 0000:05:03.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1a.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1a.0: UHCI Host Controller
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000fc00
     Feb 28 12:55:59 duke kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
     Feb 28 12:55:59 duke kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
     Feb 28 12:55:59 duke kernel: usb usb2: Product: UHCI Host Controller
     Feb 28 12:55:59 duke kernel: usb usb2: Manufacturer: Linux 2.6.33 uhci_hcd
     Feb 28 12:55:59 duke kernel: usb usb2: SerialNumber: 0000:00:1a.0
     Feb 28 12:55:59 duke kernel: hub 2-0:1.0: USB hub found
     Feb 28 12:55:59 duke kernel: hub 2-0:1.0: 2 ports detected
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1a.1: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1a.1: UHCI Host Controller
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000f800
     Feb 28 12:55:59 duke kernel: usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
     Feb 28 12:55:59 duke kernel: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
     Feb 28 12:55:59 duke kernel: usb usb3: Product: UHCI Host Controller
     Feb 28 12:55:59 duke kernel: usb usb3: Manufacturer: Linux 2.6.33 uhci_hcd
     Feb 28 12:55:59 duke kernel: usb usb3: SerialNumber: 0000:00:1a.1
     Feb 28 12:55:59 duke kernel: hub 3-0:1.0: USB hub found
     Feb 28 12:55:59 duke kernel: hub 3-0:1.0: 2 ports detected
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f400
     Feb 28 12:55:59 duke kernel: usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
     Feb 28 12:55:59 duke kernel: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
     Feb 28 12:55:59 duke kernel: usb usb4: Product: UHCI Host Controller
     Feb 28 12:55:59 duke kernel: usb usb4: Manufacturer: Linux 2.6.33 uhci_hcd
     Feb 28 12:55:59 duke kernel: usb usb4: SerialNumber: 0000:00:1d.0
     Feb 28 12:55:59 duke kernel: hub 4-0:1.0: USB hub found
     Feb 28 12:55:59 duke kernel: hub 4-0:1.0: 2 ports detected
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.1: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f000
     Feb 28 12:55:59 duke kernel: usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
     Feb 28 12:55:59 duke kernel: usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
     Feb 28 12:55:59 duke kernel: usb usb5: Product: UHCI Host Controller
     Feb 28 12:55:59 duke kernel: usb usb5: Manufacturer: Linux 2.6.33 uhci_hcd
     Feb 28 12:55:59 duke kernel: usb usb5: SerialNumber: 0000:00:1d.1
     Feb 28 12:55:59 duke kernel: hub 5-0:1.0: USB hub found
     Feb 28 12:55:59 duke kernel: hub 5-0:1.0: 2 ports detected
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.2: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
     Feb 28 12:55:59 duke kernel: uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ec00
     Feb 28 12:55:59 duke kernel: usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
     Feb 28 12:55:59 duke kernel: usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
     Feb 28 12:55:59 duke kernel: usb usb6: Product: UHCI Host Controller
     Feb 28 12:55:59 duke kernel: usb usb6: Manufacturer: Linux 2.6.33 uhci_hcd
     Feb 28 12:55:59 duke kernel: usb usb6: SerialNumber: 0000:00:1d.2
     Feb 28 12:55:59 duke kernel: hub 6-0:1.0: USB hub found
     Feb 28 12:55:59 duke kernel: hub 6-0:1.0: 2 ports detected
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1d.7: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffe000
     Feb 28 12:55:59 duke kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
     Feb 28 12:55:59 duke kernel: usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
     Feb 28 12:55:59 duke kernel: usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
     Feb 28 12:55:59 duke kernel: usb usb7: Product: EHCI Host Controller
     Feb 28 12:55:59 duke kernel: usb usb7: Manufacturer: Linux 2.6.33 ehci_hcd
     Feb 28 12:55:59 duke kernel: usb usb7: SerialNumber: 0000:00:1d.7
     Feb 28 12:55:59 duke kernel: hub 7-0:1.0: USB hub found
     Feb 28 12:55:59 duke kernel: hub 7-0:1.0: 6 ports detected
     Feb 28 12:55:59 duke kernel: ata9.00: ATAPI: PIONEER DVD-RW  DVR-118L, 1.00, max UDMA/100
     Feb 28 12:55:59 duke kernel: ata9.00: configured for UDMA/100
     Feb 28 12:55:59 duke kernel: scsi 8:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-118L 1.00 PQ: 0 ANSI: 5
     Feb 28 12:55:59 duke kernel: sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
     Feb 28 12:55:59 duke kernel: Uniform CD-ROM driver Revision: 3.20
     Feb 28 12:55:59 duke kernel: sr 8:0:0:0: Attached scsi CD-ROM sr0
     Feb 28 12:55:59 duke kernel: sr 8:0:0:0: Attached scsi generic sg3 type 5
     Feb 28 12:55:59 duke kernel: nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
     Feb 28 12:55:59 duke kernel: nvidia 0000:01:00.0: setting latency timer to 64
     Feb 28 12:55:59 duke kernel: vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
     Feb 28 12:55:59 duke kernel: NVRM: loading NVIDIA UNIX x86_64 Kernel Module  195.36.03  Mon Feb  1 18:33:51 PST 2010
     Feb 28 12:55:59 duke kernel: cx18-0: Unreasonably low latency timer, setting to 64 (was 2)
     Feb 28 12:55:59 duke kernel: cx18-0: cx23418 revision 01010000 (B)
     Feb 28 12:55:59 duke kernel: firewire_core: created device fw0: GUID 00016c200022ce9e, S400
     Feb 28 12:55:59 duke kernel: tveeprom 1-0050: Hauppauge model 74551, rev C1A3, serial# 1752579
     Feb 28 12:55:59 duke kernel: tveeprom 1-0050: MAC address is 00-0D-FE-1A-BE-03
     Feb 28 12:55:59 duke kernel: tveeprom 1-0050: tuner model is TCL MFNM05-4 (idx 103, type 43)
     Feb 28 12:55:59 duke kernel: tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
     Feb 28 12:55:59 duke kernel: tveeprom 1-0050: audio processor is CX23418 (idx 38)
     Feb 28 12:55:59 duke kernel: tveeprom 1-0050: decoder processor is CX23418 (idx 31)
     Feb 28 12:55:59 duke kernel: tveeprom 1-0050: has radio
     Feb 28 12:55:59 duke kernel: cx18-0: Autodetected Hauppauge HVR-1600
     Feb 28 12:55:59 duke kernel: cx18-0: Simultaneous Digital and Analog TV capture supported
     Feb 28 12:55:59 duke kernel: usb 7-6: new high speed USB device using ehci_hcd and address 4
     Feb 28 12:55:59 duke kernel: IRQ 18/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs
     Feb 28 12:55:59 duke kernel: tuner 2-0043: chip found @ 0x86 (cx18 i2c driver #0-1)
     Feb 28 12:55:59 duke kernel: tda9887 2-0043: creating new instance
     Feb 28 12:55:59 duke kernel: tda9887 2-0043: tda988[5/6/7] found
     Feb 28 12:55:59 duke kernel: tuner 2-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
     Feb 28 12:55:59 duke kernel: cs5345 1-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
     Feb 28 12:55:59 duke kernel: tuner-simple 2-0061: creating new instance
     Feb 28 12:55:59 duke kernel: tuner-simple 2-0061: type set to 43 (Philips NTSC MK3 (FM1236MK3 or FM1236/F))
     Feb 28 12:55:59 duke kernel: cx18-0: Registered device video1 for encoder MPEG (64 x 32.00 kB)
     Feb 28 12:55:59 duke kernel: DVB: registering new adapter (cx18)
     Feb 28 12:55:59 duke kernel: usb 7-6: New USB device found, idVendor=0b95, idProduct=7720
     Feb 28 12:55:59 duke kernel: usb 7-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
     Feb 28 12:55:59 duke kernel: usb 7-6: Product: AX88772
     Feb 28 12:55:59 duke kernel: usb 7-6: Manufacturer: ASIX Elec. Corp.
     Feb 28 12:55:59 duke kernel: usb 7-6: SerialNumber: 000001
     Feb 28 12:55:59 duke kernel: MXL5005S: Attached at address 0x63
     Feb 28 12:55:59 duke kernel: DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
     Feb 28 12:55:59 duke kernel: cx18-0: DVB Frontend registered
     Feb 28 12:55:59 duke kernel: cx18-0: Registered DVB adapter0 for TS (32 x 32.00 kB)
     Feb 28 12:55:59 duke kernel: cx18-0: Registered device video33 for encoder YUV (20 x 101.25 kB)
     Feb 28 12:55:59 duke kernel: cx18-0: Registered device vbi1 for encoder VBI (20 x 51984 bytes)
     Feb 28 12:55:59 duke kernel: cx18-0: Registered device video25 for encoder PCM audio (256 x 4.00 kB)
     Feb 28 12:55:59 duke kernel: cx18-0: Registered device radio1 for encoder radio
     Feb 28 12:55:59 duke kernel: cx18-0: Initialized card: Hauppauge HVR-1600
     Feb 28 12:55:59 duke kernel: cx18:  End initialization
     Feb 28 12:55:59 duke kernel: usb 3-2: new low speed USB device using uhci_hcd and address 2
     Feb 28 12:55:59 duke kernel: usb 3-2: New USB device found, idVendor=15c2, idProduct=ffdc
     Feb 28 12:55:59 duke kernel: usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
     Feb 28 12:55:59 duke kernel: usb 4-2: new low speed USB device using uhci_hcd and address 2
     Feb 28 12:55:59 duke kernel: usb 4-2: New USB device found, idVendor=046d, idProduct=c51e
     Feb 28 12:55:59 duke kernel: usb 4-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
     Feb 28 12:55:59 duke kernel: usbcore: registered new interface driver hiddev
     Feb 28 12:55:59 duke kernel: input: HID 046d:c51e as /class/input/input2
     Feb 28 12:55:59 duke kernel: generic-usb 0003:046D:C51E.0001: input: USB HID v1.11 Keyboard [HID 046d:c51e] on usb-0000:00:1d.0-2/input0
     Feb 28 12:55:59 duke kernel: eth1: register 'asix' at usb-0000:00:1d.7-6, ASIX AX88772 USB 2.0 Ethernet, 00:50:5b:04:a2:4b
     Feb 28 12:55:59 duke kernel: usbcore: registered new interface driver asix
     Feb 28 12:55:59 duke kernel: input: HID 046d:c51e as /class/input/input3
     Feb 28 12:55:59 duke kernel: generic-usb 0003:046D:C51E.0002: input,hiddev0: USB HID v1.11 Mouse [HID 046d:c51e] on usb-0000:00:1d.0-2/input1
     Feb 28 12:55:59 duke kernel: usbcore: registered new interface driver usbhid
     Feb 28 12:55:59 duke kernel: usbhid: USB HID core driver
     Feb 28 12:55:59 duke kernel: usb 5-2: new full speed USB device using uhci_hcd and address 2
     Feb 28 12:55:59 duke kernel: usb 5-2: New USB device found, idVendor=0403, idProduct=6001
     Feb 28 12:55:59 duke kernel: usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
     Feb 28 12:55:59 duke kernel: usb 5-2: Product: Triple Relay Controller
     Feb 28 12:55:59 duke kernel: usb 5-2: Manufacturer: RTR
     Feb 28 12:55:59 duke kernel: usb 5-2: SerialNumber: A4SI153I
     Feb 28 12:55:59 duke kernel: Adding 16064960k swap on /dev/sdc1.  Priority:-1 extents:1 across:16064960k
     Feb 28 12:55:59 duke kernel: usb 1-3: new high speed USB device using ehci_hcd and address 3
     Feb 28 12:55:59 duke kernel: usb 1-3: New USB device found, idVendor=05e3, idProduct=0608
     Feb 28 12:55:59 duke kernel: usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
     Feb 28 12:55:59 duke kernel: usb 1-3: Product: USB2.0 Hub
     Feb 28 12:55:59 duke kernel: hub 1-3:1.0: USB hub found
     Feb 28 12:55:59 duke kernel: hub 1-3:1.0: 4 ports detected
     Feb 28 12:55:59 duke kernel: usb 1-3.1: new full speed USB device using ehci_hcd and address 4
     Feb 28 12:55:59 duke kernel: usb 1-3.1: New USB device found, idVendor=0c76, idProduct=1607
     Feb 28 12:55:59 duke kernel: usb 1-3.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
     Feb 28 12:55:59 duke kernel: usb 1-3.1: Product: USB Headphone Set
     Feb 28 12:55:59 duke kernel: input: USB Headphone Set as /class/input/input4
     Feb 28 12:55:59 duke kernel: generic-usb 0003:0C76:1607.0003: input: USB HID v1.00 Device [USB Headphone Set] on usb-0000:00:1a.7-3.1/input3
     Feb 28 12:55:59 duke kernel: usbcore: registered new interface driver snd-usb-audio
     Feb 28 12:55:59 duke kernel: usb 1-3.2: new high speed USB device using ehci_hcd and address 5
     Feb 28 12:55:59 duke kernel: usb 1-3.2: New USB device found, idVendor=2040, idProduct=7200
     Feb 28 12:55:59 duke kernel: usb 1-3.2: New USB device strings: Mfr=1, Product=2, SerialNumber=10
     Feb 28 12:55:59 duke kernel: usb 1-3.2: Product: WinTV HVR-950
     Feb 28 12:55:59 duke kernel: usb 1-3.2: Manufacturer: Hauppauge
     Feb 28 12:55:59 duke kernel: usb 1-3.2: SerialNumber: 4031688744
     Feb 28 12:55:59 duke kernel: au0828 driver loaded
     Feb 28 12:55:59 duke kernel: usb 1-3.3: new full speed USB device using ehci_hcd and address 6
     Feb 28 12:55:59 duke kernel: usb 1-3.3: New USB device found, idVendor=0403, idProduct=6001
     Feb 28 12:55:59 duke kernel: usb 1-3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
     Feb 28 12:55:59 duke kernel: usb 1-3.3: Product: Frankenswitch v3 4x4:1 matrix
     Feb 28 12:55:59 duke kernel: usb 1-3.3: Manufacturer: RTR
     Feb 28 12:55:59 duke kernel: usb 1-3.3: SerialNumber: A8S59W9K
     Feb 28 12:55:59 duke kernel: usb 1-3.4: new low speed USB device using ehci_hcd and address 7
     Feb 28 12:55:59 duke kernel: au0828: i2c bus registered
     Feb 28 12:55:59 duke kernel: usb 1-3.4: New USB device found, idVendor=051d, idProduct=0002
     Feb 28 12:55:59 duke kernel: usb 1-3.4: New USB device strings: Mfr=3, Product=1, SerialNumber=2
     Feb 28 12:55:59 duke kernel: usb 1-3.4: Product: Back-UPS XS 1300 LCD FW:836.H8 .D USB FW:H8
     Feb 28 12:55:59 duke kernel: usb 1-3.4: Manufacturer: American Power Conversion
     Feb 28 12:55:59 duke kernel: usb 1-3.4: SerialNumber: BB0820009163
     Feb 28 12:55:59 duke kernel: tveeprom 3-0050: Hauppauge model 72001, rev B3F0, serial# 5156904
     Feb 28 12:55:59 duke kernel: tveeprom 3-0050: MAC address is 00-0D-FE-4E-B0-28
     Feb 28 12:55:59 duke kernel: tveeprom 3-0050: tuner model is Xceive XC5000 (idx 150, type 76)
     Feb 28 12:55:59 duke kernel: tveeprom 3-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
     Feb 28 12:55:59 duke kernel: tveeprom 3-0050: audio processor is AU8522 (idx 44)
     Feb 28 12:55:59 duke kernel: tveeprom 3-0050: decoder processor is AU8522 (idx 42)
     Feb 28 12:55:59 duke kernel: tveeprom 3-0050: has no radio, has IR receiver, has no IR transmitter
     Feb 28 12:55:59 duke kernel: hauppauge_eeprom: hauppauge eeprom: model=72001
     Feb 28 12:55:59 duke kernel: au8522 3-0047: creating new instance
     Feb 28 12:55:59 duke kernel: au8522_decoder creating new instance...
     Feb 28 12:55:59 duke kernel: tuner 3-0061: chip found @ 0xc2 (au0828)
     Feb 28 12:55:59 duke kernel: xc5000 3-0061: creating new instance
     Feb 28 12:55:59 duke kernel: xc5000: Successfully identified at address 0x61
     Feb 28 12:55:59 duke kernel: xc5000: Firmware has not been loaded previously
     Feb 28 12:55:59 duke kernel: au8522 3-0047: attaching existing instance
     Feb 28 12:55:59 duke kernel: xc5000 3-0061: attaching existing instance
     Feb 28 12:55:59 duke kernel: xc5000: Successfully identified at address 0x61
     Feb 28 12:55:59 duke kernel: xc5000: Firmware has not been loaded previously
     Feb 28 12:55:59 duke kernel: DVB: registering new adapter (au0828)
     Feb 28 12:55:59 duke kernel: DVB: registering adapter 1 frontend 0 (Auvitek AU8522 QAM/8VSB Frontend)...
     Feb 28 12:55:59 duke kernel: Registered device AU0828 [Hauppauge HVR950Q]
     Feb 28 12:55:59 duke kernel: usbcore: registered new interface driver au0828
     Feb 28 12:55:59 duke kernel: generic-usb 0003:051D:0002.0004: hiddev1: USB HID v1.10 Device [American Power Conversion Back-UPS XS 1300 LCD FW:836.H8 .D USB FW:H8 ] on usb-0000:00:1a.7-3.4/input0
     Feb 28 12:55:59 duke kernel: kjournald starting.  Commit interval 5 seconds
     Feb 28 12:55:59 duke kernel: EXT3-fs (sda1): using internal journal
     Feb 28 12:55:59 duke kernel: EXT3-fs (sda1): mounted filesystem with writeback data mode
     Feb 28 12:55:59 duke kernel: XFS mounting filesystem md0
     Feb 28 12:55:59 duke kernel: Ending clean XFS mount for filesystem: md0
     Feb 28 12:55:59 duke kernel: sky2 eth0: enabling interface
     Feb 28 12:55:59 duke kernel: eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
     Feb 28 12:55:59 duke kernel: eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
     Feb 28 12:55:59 duke kernel: sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
     Feb 28 12:55:59 duke kernel: warning: `ntpd' uses 32-bit capabilities (legacy support in use)
     Feb 28 12:55:59 duke logger: /etc/rc2.d/S13local start
     Feb 28 12:55:59 duke kernel: ata1.00: configured for UDMA/133
     Feb 28 12:55:59 duke kernel: ata1: EH complete
     Feb 28 12:55:59 duke kernel: ata2.00: configured for UDMA/133
     Feb 28 12:55:59 duke kernel: ata2: EH complete
     Feb 28 12:55:59 duke kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
     Feb 28 12:55:59 duke sshd[3674]: Server listening on 0.0.0.0 port 22.
     Feb 28 12:55:59 duke /usr/sbin/gpm[3694]: *** info [daemon/startup.c(131)]:
     Feb 28 12:55:59 duke /usr/sbin/gpm[3694]: Started gpm successfully. Entered daemon mode.
     Feb 28 12:55:59 duke mysqld_safe[3773]: started
     Feb 28 12:55:59 duke mysqld[3776]: 100228 12:55:59 [Warning] option 'net_buffer_length': unsigned value 8388608 adjusted to 1048576
     Feb 28 12:55:59 duke mysqld[3776]: 100228 12:55:59  InnoDB: Started; log sequence number 0 2439644
     Feb 28 12:55:59 duke mysqld[3776]: 100228 12:55:59 [Note] /usr/sbin/mysqld: ready for connections.
     Feb 28 12:55:59 duke mysqld[3776]: Version: '5.0.67-0ubuntu6.1'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  (Ubuntu)
     Feb 28 12:56:00 duke /etc/mysql/debian-start[3815]: Upgrading MySQL tables if necessary.
     Feb 28 12:56:00 duke /etc/mysql/debian-start[3819]: Looking for 'mysql' in: /usr/bin/mysql
     Feb 28 12:56:00 duke /etc/mysql/debian-start[3819]: Looking for 'mysqlcheck' in: /usr/bin/mysqlcheck
     Feb 28 12:56:00 duke /etc/mysql/debian-start[3819]: This installation of MySQL is already upgraded to 5.0.67, use --force if you still need to run mysql_upgrade
     Feb 28 12:56:00 duke /etc/mysql/debian-start[3831]: Checking for insecure root accounts.
     Feb 28 12:56:00 duke /etc/mysql/debian-start[3835]: WARNING: mysql.user contains 3 root accounts without password!
     Feb 28 12:56:00 duke /etc/mysql/debian-start[3836]: Triggering myisam-recover for all MyISAM tables
     Feb 28 12:56:01 duke ntpd[3564]: ntpd exiting on signal 15
     Feb 28 12:56:01 duke ntpdate[3943]: step time server 10.0.0.2 offset 0.647632 sec
     Feb 28 12:56:02 duke ntpd[4089]: ntpd 4.2.4p4@1.1520-o Fri Dec  4 19:14:37 UTC 2009 (1)
     Feb 28 12:56:02 duke ntpd[4090]: precision = 1.000 usec
     Feb 28 12:56:02 duke ntpd[4090]: Listening on interface #0 wildcard, 0.0.0.0#123 Disabled
     Feb 28 12:56:02 duke ntpd[4090]: Listening on interface #1 lo, 127.0.0.1#123 Enabled
     Feb 28 12:56:02 duke ntpd[4090]: Listening on interface #2 eth0, 10.0.0.18#123 Enabled
     Feb 28 12:56:02 duke ntpd[4090]: Listening on interface #3 eth1, 169.254.4.100#123 Enabled
     Feb 28 12:56:02 duke ntpd[4090]: kernel time sync status 0040
     Feb 28 12:56:02 duke ntpd[4090]: frequency initialized 8.502 PPM from /var/lib/ntp/ntp.drift
     Feb 28 12:56:02 duke acpid: client connected from 4129[113:122]
     Feb 28 12:56:02 duke kernel: cx18 0000:05:03.0: firmware: requesting v4l-cx23418-cpu.fw
     Feb 28 12:56:02 duke kernel: cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
     Feb 28 12:56:02 duke kernel: cx18 0000:05:03.0: firmware: requesting v4l-cx23418-apu.fw
     Feb 28 12:56:02 duke kernel: cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
     Feb 28 12:56:02 duke kernel: cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
     Feb 28 12:56:02 duke kernel: cx18 0000:05:03.0: firmware: requesting v4l-cx23418-cpu.fw
     Feb 28 12:56:02 duke kernel: cx18 0000:05:03.0: firmware: requesting v4l-cx23418-apu.fw
     Feb 28 12:56:03 duke kernel: cx18 0000:05:03.0: firmware: requesting v4l-cx23418-dig.fw
     Feb 28 12:56:03 duke kernel: cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
     Feb 28 12:56:03 duke kernel: cx18-0 843: verified load of v4l-cx23418-dig.fw firmware (16382 bytes)
     Feb 28 12:56:04 duke kernel: ivtv 0000:05:02.0: firmware: requesting v4l-cx2341x-enc.fw
     Feb 28 12:56:04 duke kernel: ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
     Feb 28 12:56:04 duke kernel: ivtv0: Encoder revision: 0x02060039
     Feb 28 12:56:04 duke logger: /etc/rc2.d/S25mythtv-backend: creating symlink for /dev/cdrom
     Feb 28 12:56:04 duke logger: /etc/rc2.d/S25mythtv-backend: creating symlink for /dev/dvd
     Feb 28 12:56:04 duke kernel: ata1.00: configured for UDMA/133
     Feb 28 12:56:04 duke kernel: ata1: EH complete
     Feb 28 12:56:04 duke logger: Pre-initializing /dev/video1
     Feb 28 12:56:05 duke kernel: ata5.00: configured for UDMA/133
     Feb 28 12:56:05 duke kernel: ata2.00: configured for UDMA/133
     Feb 28 12:56:05 duke kernel: ata2: EH complete
     Feb 28 12:56:05 duke kernel: ata5: EH complete
     Feb 28 12:56:05 duke kernel: sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
     Feb 28 12:56:07 duke nanny.mythbackend[4274]: mythbackend[4277] started
     Feb 28 12:56:07 duke logger: /usr/local/bin/enable_hauppauge_remote.sh: reconfiguring driver
     Feb 28 12:56:07 duke kernel: input: i2c IR (Hauppauge) as /class/input/input5
     Feb 28 12:56:07 duke kernel: ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [ivtv i2c driver #0]
     Feb 28 12:56:07 duke logger: /usr/local/bin/enable_hauppauge_remote.sh: waiting for device(s)
     Feb 28 12:56:07 duke gdm[4335]: WARNING: Didn't understand `' (expected true or false)
     Feb 28 12:56:07 duke acpid: client connected from 4351[0:0]
     Feb 28 12:56:08 duke /usr/sbin/cron[4404]: (CRON) INFO (pidfile fd = 3)
     Feb 28 12:56:08 duke /usr/sbin/cron[4405]: (CRON) STARTUP (fork ok)
     Feb 28 12:56:08 duke /usr/sbin/cron[4405]: (CRON) INFO (Running @reboot jobs)
     Feb 28 12:56:08 duke logger[4415]: /usr/bin/input-kbd -f /usr/local/bin/hauppauge_remote.conf 5
     Feb 28 12:56:08 duke rpc.statd[4454]: Version 1.1.2 Starting
     Feb 28 12:56:08 duke kernel: RPC: Registered udp transport module.
     Feb 28 12:56:08 duke kernel: RPC: Registered tcp transport module.
     Feb 28 12:56:08 duke kernel: RPC: Registered tcp NFSv4.1 backchannel transport module.
     Feb 28 12:56:08 duke acpid: client connected from 4351[0:0]
     Feb 28 12:56:08 duke kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
     Feb 28 12:56:08 duke kernel: NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
     Feb 28 12:56:08 duke kernel: NFSD: starting 90-second grace period
     Feb 28 12:56:09 duke logger: /etc/rc2.d/S98local start
     Feb 28 12:56:09 duke kernel: ata1.00: configured for UDMA/133
     Feb 28 12:56:09 duke kernel: ata1: EH complete
     Feb 28 12:56:09 duke kernel: ata2.00: configured for UDMA/133
     Feb 28 12:56:09 duke kernel: ata2: EH complete
     Feb 28 12:56:09 duke gdm[4342]: pam_unix(gdm-autologin:session): session opened for user mlord by (uid=0)
     Feb 28 12:56:09 duke gdm[4342]: pam_ck_connector(gdm-autologin:session): nox11 mode, ignoring PAM_TTY :0
     Feb 28 12:56:09 duke apcupsd[4379]: NIS server startup succeeded
     Feb 28 12:56:09 duke apcupsd[4379]: apcupsd 3.14.4 (18 May 2008) debian startup succeeded
     Feb 28 12:56:10 duke nanny.vfd_updater[4825]: vfd_updater[4826] started
     Feb 28 12:56:10 duke vfd_updater[4826]: connect(): Connection refused
     Feb 28 12:56:15 duke kernel: xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
     Feb 28 12:56:15 duke kernel: usb 1-3.2: firmware: requesting dvb-fe-xc5000-1.6.114.fw
     Feb 28 12:56:15 duke kernel: xc5000: firmware read 12401 bytes.
     Feb 28 12:56:15 duke kernel: xc5000: firmware uploading...
     Feb 28 12:56:22 duke kernel: xc5000: firmware upload complete...
     Feb 28 12:56:23 duke /usr/local/bin/diseqc_switcher[4876]: Selecting '2B'
     Feb 28 12:56:23 duke /usr/local/bin/diseqc_switcher[4876]: writing 0x04 [- - - - - 1 - -]
     Feb 28 12:56:24 duke /usr/local/bin/diseqc_switcher[4882]: Selecting '1D'
     Feb 28 12:56:24 duke /usr/local/bin/diseqc_switcher[4882]: writing 0x07 [- - - - - 1 1 1]
     Feb 28 12:56:29 duke logger: /usr/local/bin/set_wakeup_alarm.sh: mythbackend started by 'auto'
     Feb 28 12:56:29 duke vfd_updater[4826]: mythbackend: ACCEPT, MYTH_PROTOCOL_VERSION 40
     Feb 28 12:56:30 duke logger: /usr/local/bin/set_wakeup_alarm.sh: setting wakeup alarm the old fashioned way
     Feb 28 12:56:30 duke logger: /usr/local/bin/set_wakeup_alarm.sh: setting wakeup alarm to (1267444589) UTC '2010-03-01 11:56:29' (local '2010-03-01 06:56:29')
     Feb 28 12:56:30 duke logger: /usr/local/bin/set_wakeup_alarm.sh: echo 2010-03-01 11:56:29 > /proc/acpi/alarm
     Feb 28 12:56:30 duke logger: /usr/local/bin/set_wakeup_alarm.sh: RTC alarm readback: 2010-03-01 11:56:29
     Feb 28 12:56:30 duke logger: /usr/local/bin/set_wakeup_alarm.sh:       UTC time now: 2010-02-28 17:56:30
     Feb 28 12:56:30 duke logger: /usr/local/bin/set_wakeup_alarm.sh: next wakeup: 2010-03-01 06:56:29
     Feb 28 12:58:31 duke /usr/local/bin/diseqc_switcher[5469]: Selecting '1D'
     Feb 28 12:58:31 duke /usr/local/bin/diseqc_switcher[5469]: writing 0x07 [- - - - - 1 1 1]
     Feb 28 13:00:23 duke ntpd[4090]: synchronized to 10.0.0.2, stratum 3
     Feb 28 13:00:24 duke ntpd[4090]: time reset +0.338051 s
     Feb 28 13:00:24 duke ntpd[4090]: kernel time sync status change 0001
     Feb 28 13:05:41 duke ntpd[4090]: synchronized to 10.0.0.2, stratum 3
     Feb 28 13:15:58 duke -- MARK --
     Feb 28 13:17:01 duke CRON[7427]: pam_unix(cron:session): session opened for user root by (uid=0)
     Feb 28 13:17:01 duke /USR/SBIN/CRON[7433]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
     Feb 28 13:17:01 duke CRON[7427]: pam_unix(cron:session): session closed for user root
     Feb 28 13:35:58 duke -- MARK --
     Feb 28 13:55:58 duke -- MARK --
     Feb 28 14:15:58 duke -- MARK --
     Feb 28 14:17:01 duke CRON[13871]: pam_unix(cron:session): session opened for user root by (uid=0)
     Feb 28 14:17:01 duke /USR/SBIN/CRON[13878]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
     Feb 28 14:17:01 duke CRON[13871]: pam_unix(cron:session): session closed for user root
     Feb 28 14:35:58 duke -- MARK --
     Feb 28 14:55:58 duke -- MARK --
     Feb 28 15:15:58 duke -- MARK --
     Feb 28 15:17:01 duke CRON[20310]: pam_unix(cron:session): session opened for user root by (uid=0)
     Feb 28 15:17:01 duke /USR/SBIN/CRON[20317]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
     Feb 28 15:17:01 duke CRON[20310]: pam_unix(cron:session): session closed for user root
     Feb 28 15:34:32 duke /usr/local/bin/diseqc_switcher[22382]: Selecting '2D'
     Feb 28 15:34:32 duke /usr/local/bin/diseqc_switcher[22382]: writing 0x0f [- - - - 1 1 1 1]
     Feb 28 15:50:22 duke kernel: hrtimer: interrupt took 5076 ns
     Feb 28 15:50:31 duke /usr/local/bin/diseqc_switcher[24128]: Selecting '2D'
     Feb 28 15:50:31 duke /usr/local/bin/diseqc_switcher[24128]: writing 0x0f [- - - - 1 1 1 1]
     Feb 28 15:57:35 duke diseqc_switcher[24931]: open(diseqc_switcher): No such file or directory
     Feb 28 15:57:45 duke /ulb/diseqc_switcher[24951]: Selecting '1b'
     Feb 28 15:57:45 duke /ulb/diseqc_switcher[24951]: writing 0x0d [- - - - 1 1 - 1]
     Feb 28 15:57:53 duke /ulb/diseqc_switcher[24968]: Selecting '1d'
     Feb 28 15:57:53 duke /ulb/diseqc_switcher[24968]: writing 0x0f [- - - - 1 1 1 1]
     Feb 28 15:58:03 duke /ulb/diseqc_switcher[24985]: Selecting '1c'
     Feb 28 15:58:03 duke /ulb/diseqc_switcher[24985]: writing 0x0e [- - - - 1 1 1 -]
     Feb 28 15:58:11 duke /ulb/diseqc_switcher[24997]: Selecting '1a'
     Feb 28 15:58:11 duke /ulb/diseqc_switcher[24997]: writing 0x0c [- - - - 1 1 - -]
     Feb 28 15:58:17 duke /ulb/diseqc_switcher[25016]: Selecting '1d'
     Feb 28 15:58:17 duke /ulb/diseqc_switcher[25016]: writing 0x0f [- - - - 1 1 1 1]
     Feb 28 16:15:58 duke -- MARK --
     Feb 28 16:17:01 duke CRON[27448]: pam_unix(cron:session): session opened for user root by (uid=0)
     Feb 28 16:17:01 duke /USR/SBIN/CRON[27455]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
     Feb 28 16:17:01 duke CRON[27448]: pam_unix(cron:session): session closed for user root
     Feb 28 16:21:31 duke /usr/local/bin/diseqc_switcher[28112]: Selecting '2C'
     Feb 28 16:21:31 duke /usr/local/bin/diseqc_switcher[28112]: writing 0x0b [- - - - 1 - 1 1]
     Feb 28 16:35:58 duke -- MARK --
     Feb 28 16:55:58 duke -- MARK --
     Feb 28 17:15:58 duke -- MARK --
     Feb 28 17:17:01 duke CRON[1744]: pam_unix(cron:session): session opened for user root by (uid=0)
     Feb 28 17:17:01 duke /USR/SBIN/CRON[1750]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
     Feb 28 17:17:01 duke CRON[1744]: pam_unix(cron:session): session closed for user root
     Feb 28 17:35:58 duke -- MARK --
     Feb 28 17:55:58 duke -- MARK --
     Feb 28 18:15:58 duke -- MARK --
     Feb 28 18:17:01 duke CRON[8585]: pam_unix(cron:session): session opened for user root by (uid=0)
     Feb 28 18:17:01 duke /USR/SBIN/CRON[8591]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
     Feb 28 18:17:01 duke CRON[8585]: pam_unix(cron:session): session closed for user root
     Feb 28 18:35:58 duke -- MARK --
     Feb 28 18:55:58 duke -- MARK --
     Feb 28 18:59:31 duke /usr/local/bin/diseqc_switcher[14920]: Selecting '1C'
     Feb 28 18:59:31 duke /usr/local/bin/diseqc_switcher[14920]: writing 0x0a [- - - - 1 - 1 -]
     Feb 28 19:15:58 duke -- MARK --
     Feb 28 19:17:01 duke CRON[16800]: pam_unix(cron:session): session opened for user root by (uid=0)
     Feb 28 19:17:01 duke /USR/SBIN/CRON[16807]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
     Feb 28 19:17:01 duke CRON[16800]: pam_unix(cron:session): session closed for user root
     Feb 28 19:35:58 duke -- MARK --
     Feb 28 19:55:58 duke -- MARK --
     Feb 28 19:59:31 duke /usr/local/bin/diseqc_switcher[21502]: Selecting '2D'
     Feb 28 19:59:31 duke /usr/local/bin/diseqc_switcher[21502]: writing 0x0e [- - - - 1 1 1 -]
     Feb 28 19:59:45 duke kernel: cx18-0: Unable to find blank work order form to schedule incoming mailbox command processing
     Feb 28 20:00:03 duke /usr/local/bin/diseqc_switcher[21597]: Selecting '1B'
     Feb 28 20:00:03 duke /usr/local/bin/diseqc_switcher[21597]: writing 0x0d [- - - - 1 1 - 1]
     Feb 28 20:15:58 duke -- MARK --
