Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2103VOU025444
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 19:03:31 -0500
Received: from mail.xenonserver.de (server1.xenonserver.de [79.133.63.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2102uU9018634
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 19:02:57 -0500
From: Jan Frey <linux@janfrey.de>
To: video4linux-list@redhat.com
Date: Sat, 1 Mar 2008 01:00:55 +0100
References: <34d8b2fe0801140822o5ad3ae40hc0a08fe15f479dc@mail.gmail.com>
	<34d8b2fe0801161243j1c9ba641k7c31175d4cce8140@mail.gmail.com>
	<1200522691.21509.32.camel@frolic>
In-Reply-To: <1200522691.21509.32.camel@frolic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803010100.55810.linux@janfrey.de>
Cc: 
Subject: Re: HVR-1300 mpg hw encoding - how to configure the board's
	firmware?
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

Hi Ricardo,

On Wednesday 16 January 2008, Ricardo Cerqueira wrote:
> Hi all;
>
> On Wed, 2008-01-16 at 21:43 +0100, Pirlouwi wrote:
> > But, if I don't follow this procedure, and if I simply do point 3.,
> > then I cannot change the frequency of the tuner, and blackbird keeps
> > recording on the old tv frequency.
> >
> >
> >
> > Anyone can help me understand this behavior?
>
> I think it's related to something I found yesterday. It seems the
> cx22702 reset by the blackbird is being a bit to broad and resetting
> more than it should.
>
> Try the following, and see if your behavior goes away:
>
> 1 - clone a clean copy of http://linuxtv.org/hg/~rmcc/blackbird/
> 2 - Comment line 1252 of linux/drivers/media/video/cx88/cx88-blackbird.c
> (cx22702 reset)
> 3 - compile, install, and retry.
>
> I'm still trying to figure this one out, but taking out that reset
> solved the channel-change issue for me.

This patch works fine for me in the context of the same problem.

Regards,
Jan

-- 
Jan Frey
linux [at] janfrey.de

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
