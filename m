Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3L17qnJ017729
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 21:07:53 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3L17bLi002115
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 21:07:38 -0400
Received: by fk-out-0910.google.com with SMTP id b27so2100693fka.3
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 18:07:37 -0700 (PDT)
Message-ID: <3a4a99ca0804201807r65151edm464b7943caa7767e@mail.gmail.com>
Date: Mon, 21 Apr 2008 11:07:36 +1000
From: stuart <stuart.partridge@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Connecting my working DVICO dual digi 4 to MythTV
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

I've managed to get the drivers working with my Ubuntu 2.6.22, using the
instructions laid out
(http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/<http://www.itee.uq.edu.au/%7Echrisp/Linux-DVB/DVICO/>).
It required using a version of the source from an earlier changeset (a whole
other adventure -> thanks again Ben), but finally dmesg tells me the card is
in a 'warm state' and I've got the required adapter0 + 1 folders, with
content in them. I've done some simple testing (mplayer -dumpstream), so I
know the system can see and talk to the card and I'm getting video.ts files
out of it. The final challenge is configuring the cards correctly in MythTV.

In the capture card config screen in MythTV, I've been using 'DVB DTV
capture card (v3.x)' and I'm getting the 'Zarlink', but no more joy from
that point on.
In 'Input connections' I get a lot of 'none'. I've tried all the other card
types, and putting direct refs into the /dev/dvb/adapter0 + 1 folders, but
I'm getting nothing.

Annoyingly, my Myth was working brilliantly before a major system upgrade a
few months back. Frustrating that it all seems so crapola now.

Any suggestions?

Regards,

Stuart
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
