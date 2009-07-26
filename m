Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6QKi8VF028573
	for <video4linux-list@redhat.com>; Sun, 26 Jul 2009 16:44:08 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6QKhr4b002570
	for <video4linux-list@redhat.com>; Sun, 26 Jul 2009 16:43:53 -0400
Received: from webmail.xs4all.nl (dovemail8.xs4all.nl [194.109.26.10])
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id n6QKhqvw066331
	for <video4linux-list@redhat.com>;
	Sun, 26 Jul 2009 22:43:53 +0200 (CEST)
	(envelope-from kweelist@xs4all.nl)
Message-ID: <60449.82.95.124.251.1248641033.squirrel@webmail.xs4all.nl>
Date: Sun, 26 Jul 2009 22:43:53 +0200 (CEST)
From: kweelist@xs4all.nl
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: how to remove black bars in letterboxed tv on widescreen monitor
Reply-To: kweelist@xsall.nl.redhat.com
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

My V4L based television works pretty fine, but some small problems still
give me headaches.

I use a modest size 15 inch 4:3 lcd monitor but with an extension cable
place it close to the couch. Much better than an expensive big screen at
the other side of the room.

Most of the nice movies on television are letterboxed. On the regular
4:3 tv or monitor screen, black bars are shown above and below the
actual picture. Now I bought myself an 18.1 inch widescreen monitor,
same height as the old one, but wider. (1366x768). The fun part is that
the aspect ratio is 16:9, even wider than the regular widescreen of
16:10, and the price was only 59 euro. The problem is that now I have
black bars at all four sides of the picture which is still the same size
as on the old monitor.

For television watching I use TVTIME, which works really fine, but seems
to insist on displaying the black bars above and below the picture as
transmitted by the tv program, resulting in a 4:3 picture, which then
needs black bars left and right of the widescreen monitor to reduce it
to my old 4:3 monitor.

TVTIME does have a "widescreen" option, but this only stretches the 4:3
picture including the black bars above and below to fill the widescreen
tft, distorted.

My current setup includes:
- Ubuntu 9.04
- Intel 865 chipset
- 'intel' driver in xorg
- screen resolution 1366x768 (formerly 1024x768)
- tv card output resolution 720x568 (if I remember correctly) including
black bars
- application tvtime which scales the tv picture to fullscreen (using
xorg module glx)

What should I do?
- Can I tweak TVTIME to crop the tv picture to get rid of the black bars
above and below?
- Should I get another tv application?
- Should I tweek /etc/X11/xorg.conf to fool tvtime to make it think the
(virtual) screen is 1366x1024?
- Can I tweak something in the V4L setup?

So far I did not succeed in any of these experiments. Any help is
appreciated.




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
