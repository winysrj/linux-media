Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAFLCEQD001872
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 16:12:14 -0500
Received: from hel.is.scarlet.be (hel.is.scarlet.be [193.74.71.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAFLBxNH007312
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 16:12:00 -0500
Received: from www.mos6581.org (ip-83-134-79-45.dsl.scarlet.be [83.134.79.45])
	by hel.is.scarlet.be (8.14.2/8.14.2) with SMTP id mAFLBvMN023472
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 22:11:58 +0100
To: video4linux-list@redhat.com
Date: Sat, 15 Nov 2008 21:58:05 +0100
Message-ID: <fSNgwvr0.1226782685.9145640.brecht@mail.mos6581.org>
From: "Brecht Machiels" <brecht@mos6581.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Subject: WinTV HVR 1200 analog
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

Hello,

I cannot seem to find any recent information on whether the HVR
1200 analog tuner is supported by the cx23885 driver. I assume people on
this list will be able to shed some clarity.

In trying to getting it to work, I've copied the firmware from
http://steventoth.net/linux/hvr1200/ to /lib/firmware/ and
/lib/firmware/2.6.27-7-generic/, to no avail.

I'm using the standard Ubuntu 8.10 drivers. The card seems to be
detected fine:
[   13.515672] Linux video capture interface: v2.00
[   13.659902] cx23885 driver version 0.0.1 loaded
[   13.659960] cx23885 0000:02:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[   13.660089] CORE cx23885[0]: subsystem: 0070:71d1, board: Hauppauge
WinTV-HVR1200 [card=7,autodetected]
[   14.263765] cx23885[0]: i2c bus 0 registered
[   14.263803] cx23885[0]: i2c bus 1 registered
[   14.263837] cx23885[0]: i2c bus 2 registered
[   14.291373] tveeprom 0-0050: Hauppauge model 71959, rev H1E9, serial#
3018029
[   14.291376] tveeprom 0-0050: MAC address is 00-0D-FE-2E-0D-2D
[   14.291378] tveeprom 0-0050: tuner model is Philips 18271_8295 (idx
149, type 54)
[   14.291381] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L')
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[   14.291383] tveeprom 0-0050: audio processor is CX23885 (idx 39)
[   14.291385] tveeprom 0-0050: decoder processor is CX23885B (idx 41)
[   14.291387] tveeprom 0-0050: has no radio
[   14.291388] cx23885[0]: hauppauge eeprom: model=71959
[   14.291391] cx23885[0]: cx23885 based dvb card
[   14.458900] tda829x 1-0042: type set to tda8295
[   14.570102] tda18271 1-0060: creating new instance
[   14.604376] TDA18271HD/C1 detected @ 1-0060
[   14.993725] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   15.654129] DVB: registering new adapter (cx23885[0])
[   15.654135] DVB: registering frontend 0 (NXP TDA10048HN DVB-T)...
[   15.654707] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   15.654716] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfbc00000
[   15.654724] cx23885 0000:02:00.0: setting latency timer to 64

There is a /dev/dvb folder, but no /dev/video0 file.

Kind regards,
Brecht

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
