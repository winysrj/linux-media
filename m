Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6P2NWFl028900
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 22:23:32 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6P2NJQJ024957
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 22:23:19 -0400
From: Andy Walls <awalls@radix.net>
To: mpapet@yahoo.com
In-Reply-To: <160827.10154.qm@web62007.mail.re1.yahoo.com>
References: <160827.10154.qm@web62007.mail.re1.yahoo.com>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 22:22:17 -0400
Message-Id: <1216952537.2710.43.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: cx18 Newbie Question
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

On Thu, 2008-07-24 at 18:11 -0700, Michael Papet wrote:
> Hi,
> 
> I've got a Hauppauge hvr-1600 tuner card.  It has an NTSC and an ATSC
> tuner. I am having an issue with the cx18 module that may be obvious
> to some, but not to me.
> 
> Depending on where I got the cx18 sources from mercurial,
> (http://www.linuxtv.org/hg/)  either the hdtv tuner works or the NTSC
> tuner works. 

You should really only pull from the 

http://www.linuxtv.org/hg/v4l-dvb

repo for the cx18 driver.  All other repos will be historical or changed
in some way for testing specific problems or changes.  Unless a dev has
asked you specifically to use some other repo, it's sanest for everyone
involved to report bugs against the v4l-dvb repo. 


>  Both devices (/dev/video0 and /dev/dvb/xxyyzz) are created and there
> are no errors when tuning with the debug flag set.  
> 
> When using the functioning NTSC version, I have a fully functioning
> NTSC mythtv setup that cannot find any ATSC channels.  When using the
> ATSC I have a fully functioning ATSC mythtv setup with no NTSC
> channels detected on /dev/video0.

What versions are these?

Users have reported that since the cx18 driver started using the
mxl5005s module instead of the mxl500x module, scanning ATSC QAM
channels doesn't work well.  ATSC 8-VSB scanning or tuning doesn't seem
to be a problem, nor is actually tuning to known ATSC QAM channels.

If you are experiencing this DVB tuning problem, please report to the
linux-dvb list.  Steve Toth did the port of the mxl5005s code to linux,
and I have no data or QAM channels to help debug the problem.


> Is it the case that the driver simply isn't ready or is there a bug
> report I can submit?

If you have bugs with DVB report to the linux-dvb list.  If you have
problems with analog capture, report to video4linux-list.  You can also
report to the ivtv-users or ivtv-devel lists.  A lot of cx18 specific
posts end up on the ivtv list since it has its origins from that driver.

Regards,
Andy

> Any advice is welcome.
> 
> Michael


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
