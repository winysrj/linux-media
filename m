Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03GY5wC020100
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 11:34:05 -0500
Received: from web55907.mail.re3.yahoo.com (web55907.mail.re3.yahoo.com
	[216.252.110.68])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n03GXpFb012180
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 11:33:51 -0500
Date: Sat, 3 Jan 2009 08:33:49 -0800 (PST)
From: Brian Empson <brian_empson@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <49875.5941.qm@web55907.mail.re3.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Sabrent TV-FM Tuner issue
Reply-To: brian_empson@yahoo.com
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

I have recently installed two Sabrent PCI TVFM tuners into my computer alon=
g with a Sabrent 5 channel sound card.=A0 By changing the card=3D0 option t=
o card=3D42 I was able to get the composite working perfectly and the tv tu=
ner to display static.=A0 However, I cannot receiver any channels at all wi=
th tvtime or mythtv or mplayer.=A0 I cycled through all the tuner=3DXX numb=
ers and nothing seemed to make a difference.=A0 I did a tvtime-sanner scan =
and it picked up a ton of channels, but when I went to view them in tvtime =
all I got was static.=A0 The dmesg output:

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7130[0]: found at 0000:02:01.0, rev: 1, irq: 22, latency: 32, mmio: 0xff=
9ffc00
saa7130[0]: subsystem: 1131:0000, board: Sabrent SBT-TVFM (saa7130) [card=
=3D42,insmod option]
saa7130[0]: board init: gpio is c04000
saa7130[0]: Huh, no eeprom present (err=3D-5)?
saa7130[0]: i2c scan: found device @ 0x86=A0 [tda9887]
saa7130[0]: i2c scan: found device @ 0xc0=A0 [tuner (analog)]
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
saa7130[0]: registered device radio0
saa7130[1]: found at 0000:02:02.0, rev: 1, irq: 17, latency: 32, mmio: 0xff=
9ff800
saa7134:=A0=A0 card=3D10 -> Kworld/KuroutoShikou SAA7130-TVPCI
saa7134:=A0=A0 card=3D42 -> Sabrent SBT-TVFM (saa7130)
saa7130[1]: subsystem: 1131:0000, board: UNKNOWN/GENERIC [card=3D0,autodete=
cted]
saa7130[1]: board init: gpio is c04000
saa7130[1]: Huh, no eeprom present (err=3D-5)?
saa7130[1]: i2c scan: found device @ 0x86=A0 [tda9887]
saa7130[1]: i2c scan: found device @ 0xc0=A0 [tuner (analog)]
saa7130[1]: registered device video1 [v4l2]
saa7130[1]: registered device vbi1

I passed i2c_scan=3D1 and card=3D42 as options to get the first card to be =
recognized.=A0 The second card is autodetected for some reason.=A0 I do not=
 know why it doesn't set it to 42 like the first card.=A0 Anyway, the chann=
els are all static, even though the scan program can pick up signals, the t=
vtime program cannot seem to display any sort of picture.=A0 The composite,=
 on the other hand, works perfectly.=A0 I have tried using mplayer to try d=
ifferent cable frequency plans and there was no difference.=A0 This is real=
ly mind boogling to me because it should display SOMETHING, right?=A0 There=
 is a cable line attached to the first card's tuner port, the other card do=
esn't have anything connected.

Any help would be greatly appreciated, because at this point I do not know =
what to do...

-Brian
=0A=0A=0A      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
