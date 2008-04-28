Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3SENEKW026906
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 10:23:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3SEN38b032124
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 10:23:03 -0400
Date: Mon, 28 Apr 2008 11:21:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Message-ID: <20080428112150.1c5392f2@gaivota>
In-Reply-To: <4814ED8B.90503@t-online.de>
References: <20080425114526.434311ea@gaivota> <4811F391.1070207@linuxtv.org>
	<20080426085918.09e8bdc0@gaivota>
	<481326E4.2070909@pickworth.me.uk>
	<20080426110659.39fa836f@gaivota>
	<1209247821.15689.12.camel@pc10.localdom.local>
	<20080426201940.1507fb82@gaivota>
	<1209327322.2661.26.camel@pc10.localdom.local>
	<4814ED8B.90503@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb@linuxtv.org, video4linux-list@redhat.com, mkrufky@linuxtv.org,
	gert.vervoort@hccnet.nl
Subject: Re: [linux-dvb] Hauppauge WinTV regreession from 2.6.24 to 2.6.25
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

> > I notice some unwanted behavior when testing md7134 FMD1216ME hybrid
> > boards.
> >
> Aha! I modified my board that it no longer runs with the current driver. But i observed
> something similar
> 
> > Unchanged is that the tda9887 is not up for analog after boot.
> > Previously one did reload "tuner" just once and was done.
> > 
> <snip>
> Don't have the time today, but lets roll back history: Not absolutely sure but if
> i remember correcly, the initialization sequence can be critical with hybrid tuners /
> NIM modules. The tda9887 may only be visible on I2C after a certain bit in the MOPLL
> is set (in byte4?)

If this is the case, we need to initialize the bit at init1, otherwise, this won't work.

Another option is to migrate saa7134 to the newer i2c probing methods, and let
tuner be probed after init2.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
