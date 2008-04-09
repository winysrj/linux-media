Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m39Lvc7l009079
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 17:57:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m39LvALZ029765
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 17:57:10 -0400
Date: Wed, 9 Apr 2008 18:55:26 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Message-ID: <20080409185526.0feffa8a@areia>
In-Reply-To: <alpine.LFD.1.00.0804091559470.27560@localhost.localdomain>
References: <alpine.LFD.1.00.0804091559470.27560@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video for linux list <video4linux-list@redhat.com>
Subject: Re: [newbie alert] setting up hauppauge hvr 950 to watch OTA analog?
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

On Wed, 9 Apr 2008 16:03:32 -0400 (EDT)
"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> 
>   as my first foray into video, i'd like to set up my new hauppauge
> wintv-hvr 950 tv tuner to watch OTA analog TV on my fedora 8 system.
> i've poked around but haven't found a working recipe for this.  and
> i'd rather not go the full mythtv route since i want to start simple
> and build from there.
> 
>   at the moment, i have a fully-updated f8 system and, on the
> recommendation of a friend, have installed xawtv as the viewing app.
> so ... where from here?  i can certainly build a new kernel based on
> the latest git repository but, as i read it, that won't give me the
> module i want.
> 
>   in any event, what's next?  and other recommendations for a viewing
> client?  i'm not trying to get overly fancy, i just want to get this
> first step done, then i can take it from there.  thanks.

There are a few newer revisions of HVR-950. Maybe you'll need to add its PCI ID
to em28xx-cards.c. If this is not the case, you just need to get the latest
version of v4l/dvb tree, at:
	http://linuxtv.org/hg/v4l-dvb

And generate a firmware file. The tool for generating the firmware is available
at:
	linux/Documentation/video4linux/extract_xc3028.pl

The proceadure is written at the beginning of the perl script.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
