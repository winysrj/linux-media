Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7F02doe025794
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 20:02:39 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7F02RY3007827
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 20:02:28 -0400
Date: Fri, 15 Aug 2008 02:02:05 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Nakarin Lamangthong <lnakarin@gmail.com>
Message-ID: <20080815000205.GA1359@daniel.bse>
References: <443ddfb30808141632l30b6fbefgda1bb2a1f6bbe028@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <443ddfb30808141632l30b6fbefgda1bb2a1f6bbe028@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Commell MP-878D first time error
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

On Fri, Aug 15, 2008 at 06:32:21AM +0700, Nakarin Lamangthong wrote:
> I'm newbie for LinuxTV, I have a Capture Mini-pci Card form Commell MP-878D

> bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]

As your card can't be detected, you need to load the bttv module
with pll=28 to be able to decode PAL signals.

> How do i fix this error?
> 
> bt878_probe: card id=[0x0], Unknown card.
> Exiting..
> bt878: probe of 0000:00:0e.1 failed with error -22

Ignore this error.
It tells you that your card is none of the bt878 cards known to use the
audio part to transport DVB data.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
