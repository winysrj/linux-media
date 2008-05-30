Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4VG2XOa015186
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 12:02:33 -0400
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.123])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4VG1WTl006959
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 12:01:42 -0400
Received: from opus ([76.184.165.27]) by cdptpa-omta02.mail.rr.com with ESMTP
	id <20080531160127.IPYI23887.cdptpa-omta02.mail.rr.com@opus>
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 16:01:27 +0000
Received: from david by opus with local (Exim 4.69)
	(envelope-from <david@opus.istwok.net>) id 1K2TWJ-00034o-3L
	for video4linux-list@redhat.com; Sat, 31 May 2008 11:01:27 -0500
Resent-Message-ID: <20080531160127.GA11803@opus.istwok.net>
Date: Fri, 30 May 2008 09:58:30 -0500
From: David Engel <david@istwok.net>
To: Jason Pontious <jpontious@gmail.com>
Message-ID: <20080530145830.GA7177@opus.istwok.net>
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Kworld 115-No Analog Channels
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

On Thu, May 29, 2008 at 06:57:03PM -0400, Jason Pontious wrote:
> After getting upgraded to the latest v4l-dvb repository I am no longer able
> to get any analog channels from my Kworld 115. (I finally broke down and
> installed 2.6.25 kernel in Ubuntu).

Which drivers are you really using, 2.6.25 or latest v4l-dvb from
Mercurial?

> Before I was getting analog channels via the top rf input.  Now I get no
> channels regardless if i set atv_input tuner_simple module setting.  Digital
> channels are not affected just analog in this.  I get no errors from dmesg.
> 
> Any Ideas?

I ran into a similar (probably the same) problem last week.  My search
of the list archives revealed a known tuner detection regression in
2.6.25.  It's supposed to be fixed in Mercurial but I didn't test it
because it was simpler to just go back to 2.6.24.x.  I don't know why
the fix hasn't made it into 2.6.25.x yet.

David
-- 
David Engel
david@istwok.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
