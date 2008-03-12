Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2CEEsI0015423
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 10:14:54 -0400
Received: from web31709.mail.mud.yahoo.com (web31709.mail.mud.yahoo.com
	[68.142.201.189])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2CEEEOJ008440
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 10:14:14 -0400
Date: Wed, 12 Mar 2008 07:14:07 -0700 (PDT)
From: "Matthew T. Gibbs" <mtgibbs@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <310915.92648.qm@web31709.mail.mud.yahoo.com>
Subject: Re: Help with PCTV HD Pro Stick and openSUSE 10.3
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

[Sorry for top-posting this mail client isn't that great for composing]

I think I got it sorted out...I had to copy netdevice.h to the directory where it was looking for sources.  The modules were then able to build.  I had to reboot to get them to work, otherwise I got some symbol mismatch error or something like that when the modules tried to load.  After rebooting the modules seem to load properly and I can watch analog TV.  I still have to figure out how to use the digital part as Kaffeine doesn't seem to be working and Xine only seems to get one station.  Will there be a tvtime for dvb any time soon?  I hope so.  Anyway, thank you to the devs who have even gotten it this far.

Matt

----- Original Message ----
From: Matthew T. Gibbs <mtgibbs@yahoo.com>
To: video4linux-list@redhat.com
Sent: Tuesday, March 11, 2008 9:43:17 PM
Subject: Help with PCTV HD Pro Stick and openSUSE 10.3

Hello all-

I tried to install my PCTV stick and I am getting an error that says "failed to open frontend" when I try to run dvbscan.  I tried to follow this howto

<http://mcentral.de/wiki/index.php5/Em2880> 

but I couldn't get the modules to compile.  I apparently have the right module, and the stick is recognised when I plug it in.  Where do I go from here?  I tried searching but I couldn't find any related information.

Thank you,

Matt

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
