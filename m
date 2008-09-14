Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8EDhDZI017006
	for <video4linux-list@redhat.com>; Sun, 14 Sep 2008 09:43:13 -0400
Received: from flanders.hackvalue.nl (flanders.hackvalue.nl [82.94.238.226])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8EDg1uP022770
	for <video4linux-list@redhat.com>; Sun, 14 Sep 2008 09:42:02 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by flanders.hackvalue.nl (Postfix) with ESMTP id AB9769781BE
	for <video4linux-list@redhat.com>;
	Sun, 14 Sep 2008 15:42:03 +0200 (CEST)
Received: from flanders.hackvalue.nl ([127.0.0.1])
	by localhost (flanders.hackvalue.nl [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id JysYkt1FVPSE for <video4linux-list@redhat.com>;
	Sun, 14 Sep 2008 15:42:02 +0200 (CEST)
Received: from [127.0.0.1] (localhost.localdomain [127.0.0.1])
	by flanders.hackvalue.nl (Postfix) with ESMTP id 9AD779781AD
	for <video4linux-list@redhat.com>;
	Sun, 14 Sep 2008 15:42:02 +0200 (CEST)
From: Armijn Hemel <armijn@uulug.nl>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Sun, 14 Sep 2008 15:42:00 +0200
Message-Id: <1221399720.3870.8.camel@cletus.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Conceptronic CHVIDEOCR
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

hi,

I have a Conceptronic CHVIDEOCR
(http://www.conceptronic.net/site/desktopdefault.aspx?tabindex=0&tabid=200&Cat=20&grp=2010&ar=360&Prod_ID=1020&Prod=CHVIDEOCR).
I plugged it in on my Fedora 9 system and the kernel said the following:

Sep 14 15:32:40 localhost kernel: em28xx #0: em28xx chip ID = 18
Sep 14 15:32:40 localhost kernel: saa7115' 1-0025: saa7113 found
(1f7113d0e100000) @ 0x4a (em28xx #0)
Sep 14 15:32:41 localhost kernel: em28xx #0: found i2c device @ 0x4a
[saa7113h]
Sep 14 15:32:41 localhost kernel: em28xx #0: Your board has no unique
USB ID and thus need a hint to be detected.
Sep 14 15:32:41 localhost kernel: em28xx #0: You may try to use card=<n>
insmod option to workaround that.
Sep 14 15:32:41 localhost kernel: em28xx #0: Please send an email with
this log to:
Sep 14 15:32:41 localhost kernel: em28xx #0:    V4L Mailing List
<video4linux-list@redhat.com>
Sep 14 15:32:41 localhost kernel: em28xx #0: Board eeprom hash is
0x00000000
Sep 14 15:32:41 localhost kernel: em28xx #0: Board i2c devicelist hash
is 0x1ba50080
Sep 14 15:32:41 localhost kernel: em28xx #0: Here is a list of valid
choices for the card=<n> insmod option:
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=0 -> Unknown
EM2800 video grabber
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=1 -> Unknown
EM2750/28xx video grabber
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=2 -> Terratec
Cinergy 250 USB
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=3 -> Pinnacle PCTV
USB 2
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=4 -> Hauppauge
WinTV USB 2
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=5 -> MSI VOX USB
2.0
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=6 -> Terratec
Cinergy 200 USB
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=7 -> Leadtek
Winfast USB II
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=8 -> Kworld
USB2800
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=9 -> Pinnacle
Dazzle DVC 90/DVC 100
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=10 -> Hauppauge
WinTV HVR 900
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=11 -> Terratec
Hybrid XS
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=12 -> Kworld PVR
TV 2800 RF
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=13 -> Terratec
Prodigy XS
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=14 -> Pixelview
Prolink PlayTV USB 2.0
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=15 -> V-Gear
PocketTV
Sep 14 15:32:41 localhost kernel: em28xx #0:     card=16 -> Hauppauge
WinTV HVR 950
Sep 14 15:32:41 localhost kernel: em28xx #0: V4L2 device registered
as /dev/video0 and /dev/vbi0
Sep 14 15:32:41 localhost kernel: em28xx #0: Found Unknown EM2750/28xx
video grabber

When I load it with card configuration 9 (Pinnacle Dazzle) it works like
a charm. Where exactly should I add it to the driver? Is that in
em28xx-cards.c in the em28xx_i2c_hash struct?

thanks in advance,

armijn

-- 
-------------------------------------------------------------------------
armijn@uulug.nl | http://www.uulug.nl/ | UULug: Utrecht Linux Users Group
-------------------------------------------------------------------------

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
