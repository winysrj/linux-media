Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5TC4f3g026641
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 08:04:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5TC4Uh9017638
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 08:04:30 -0400
Date: Sun, 29 Jun 2008 09:04:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: edubezval@gmail.com
Message-ID: <20080629090421.7c6073ad@gaivota>
In-Reply-To: <4848066B.4020908@linuxtv.org>
References: <a0580c510806050824k34e0d965yb871dfe18e9b07c1@mail.gmail.com>
	<4848066B.4020908@linuxtv.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tony@atomide.com, eduardo.valentin@indt.org.br, video4linux-list@redhat.com,
	mkrufky@linuxtv.org, sakari.ailus@nokia.com
Subject: Re: [PATCH 0/1] Add support for TEA5761 (from linux-omap)
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

On Thu, 5 Jun 2008 11:29:47 -0400 
mkrufky@linuxtv.org wrote:

> Eduardo Valentin wrote:
> > Hi guys,
> >
> > About this Tuner API, what is the best way to [s,g]et mute state?
> >
> > cheers,
> >   
> You would usually have the bridge driver handle mute / unmute 
> operation.  The tuner driver handles the operations of the tuner chip, 
> itself.  Mute is not normally controlled within the tuner silicon.
> 
> For cases where mute IS controlled by the tuner, we tend to call sleep 
> to mute the tuner, and we re-tune to unmute and ensure that we're on the 
> correct channel.
> 
> -Mike

Eduardo,

Any news about this subject?

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
