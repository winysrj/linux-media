Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3H6XtD0006342
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 02:33:55 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3H6XfHJ012059
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 02:33:41 -0400
Received: by fk-out-0910.google.com with SMTP id b27so3348667fka.3
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 23:33:40 -0700 (PDT)
Message-ID: <3a4a99ca0804162333p1d08e308ufea59a2cd40edd19@mail.gmail.com>
Date: Thu, 17 Apr 2008 16:33:40 +1000
From: stuart <stuart.partridge@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Fusion/DVICO HDTV Dual 4 not working and crashing lsusb
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

I've had a look around the archives and can't see anything that matches my
sitch.

I'm running Ubuntu 7.10 / 2.6.22-generic with a Myth media centre set-up.
Got nvidia working just fine.

I used the instructions at
https://help.ubuntu.com/community/DViCO_Dual_Digital_4 and managed to get
the drivers + firmware installed, and dmesg tells me it can see the card in
a 'warm state', and I get good results from lsmod, but that's as far as I
get.
When I run lsusb, it utterly crashes and won't come back, so I know
something not quite right. I can undo the installation and have tried a few
other 'how-tos', but I'm not getting very far.

Not getting any teev signal, and a 'mplayer dvb://ABC -dumpstream -dumpfile'
doesn't give me anything.

Am tapped for ideas - I'm a n00b, don't you know - so any
direction/suggestions would be greatly appreciated.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
