Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6P1BSgg000800
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 21:11:28 -0400
Received: from web62007.mail.re1.yahoo.com (web62007.mail.re1.yahoo.com
	[69.147.74.230])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6P1BExA027144
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 21:11:15 -0400
Date: Thu, 24 Jul 2008 18:11:08 -0700 (PDT)
From: Michael Papet <mpapet@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <160827.10154.qm@web62007.mail.re1.yahoo.com>
Subject: cx18 Newbie Question
Reply-To: mpapet@yahoo.com
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

Hi,

I've got a Hauppauge hvr-1600 tuner card.  It has an NTSC and an ATSC tuner. I am having an issue with the cx18 module that may be obvious to some, but not to me.

Depending on where I got the cx18 sources from mercurial, (http://www.linuxtv.org/hg/)  either the hdtv tuner works or the NTSC tuner works.  Both devices (/dev/video0 and /dev/dvb/xxyyzz) are created and there are no errors when tuning with the debug flag set.  

When using the functioning NTSC version, I have a fully functioning NTSC mythtv setup that cannot find any ATSC channels.  When using the ATSC I have a fully functioning ATSC mythtv setup with no NTSC channels detected on /dev/video0.

Is it the case that the driver simply isn't ready or is there a bug report I can submit?

Any advice is welcome.

Michael


      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
