Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f217.google.com ([209.85.219.217])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <maik.masling@googlemail.com>) id 1N78tp-0000cH-6T
	for linux-dvb@linuxtv.org; Sun, 08 Nov 2009 15:37:50 +0100
Received: by ewy17 with SMTP id 17so289290ewy.17
	for <linux-dvb@linuxtv.org>; Sun, 08 Nov 2009 06:37:15 -0800 (PST)
Message-ID: <4AF6D799.7020004@googlemail.com>
Date: Sun, 08 Nov 2009 15:37:13 +0100
From: Maik Masling <maik.masling@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] MSI Digivox mini II V3.0 (rtl2832u) with Me-tv
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Ok, installing the driver of this chip wasn't that easy but following =

several "finnish"-howtos i managed to succesfully build v4l-dvb driver =

for the rtl2832u-chiped MSI Digivox mini II V3.0.

lsusb:
Bus 001 Device 005: ID 1d19:1101

dmesg (regarded on stick-plugin):
[ 95.620012] usb 1-1: new high speed USB device using ehci_hcd and address 5
[ 95.782039] usb 1-1: configuration #1 chosen from 1 choice
[ 95.788734] dvb-usb: found a 'DK DVBT DONGLE' in warm state.
[ 95.788738] dvb-usb: will pass the complete MPEG2 transport stream to =

the software demuxer.
[ 95.790373] DVB: registering new adapter (DK DVBT DONGLE)
[ 95.790607] DVB: registering adapter 0 frontend 0 (Realtek RTL2832 =

DVB-T)...
[ 95.790629] dvb-usb: DK DVBT DONGLE successfully initialized and connected.
[ 95.792426] dvb-usb: found a 'DK DVBT DONGLE' in warm state.
[ 95.792430] dvb-usb: will pass the complete MPEG2 transport stream to =

the software demuxer.
[ 95.794467] DVB: registering new adapter (DK DVBT DONGLE)
[ 95.794684] DVB: registering adapter 1 frontend 0 (Realtek RTL2832 =

DVB-T)...
[ 95.794707] dvb-usb: DK DVBT DONGLE successfully initialized and connected.

scan /usr/share/dvb/dvb-t/de-Nordrhein-Westfalen delivers all channels =

that i know off.
example output:

 >>> tune to: =

538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSI=
ON_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
0x0000 0x4015: pmt_pid 0x0150 RTL World -- RTL Television (running)
0x0000 0x4016: pmt_pid 0x0160 RTL World -- RTL2 (running)
0x0000 0x401b: pmt_pid 0x01b0 RTL World -- Super RTL (running)
0x0000 0x4022: pmt_pid 0x0220 RTL World -- VOX (running)

kaffeine scans all channels properly too and i can watch everything =

probably if i tune my antenna up to 18db, but kaffeine is kde based and =

i would like to have gnome/gtk based me-tv.

Me-TV cannot find ANY channels (0) when i use internal scan:
example output:

08.11.2009 15:15:43: Tuning to transponder at 538000000 Hz
08.11.2009 15:15:43: Auf Signalsperre warten =85 (translation: waiting for =

signal lock)
08.11.2009 15:15:55: Poking screensaver
08.11.2009 15:15:58: Status: 0
08.11.2009 15:15:58: Currently tuned to freq 538000000, symbol rate 0, =

inner fec 2
08.11.2009 15:15:58: Exception: Sperren des Kanals fehlgeschlagen =

(translation: failed to lock channel)
08.11.2009 15:15:58: Failed to tune to transponder at 538000000 Hz

So i tried to import the channels.conf-output that i generated with scan.
Me-Tv seems to work, adds all channels, but stucks heavily and cannot =

show tv properly due to weak signal...

The signal truely is high enough, because even increasing to 40db keeps =

signal on 0%, so something must be wrong.

To shoot out errors i got the same stick with afatech-9015-chip, that =

100% works nice with me-tv.

So the Rtl2832U nearly works with any application except of me-tv.

i really like me-tv and kaffeine is crashing all the time. Any ideas on =

how to fix that?


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
