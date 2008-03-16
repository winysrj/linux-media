Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GBtAUH032661
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 07:55:10 -0400
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GBsdcQ000938
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 07:54:39 -0400
From: Peter Missel <peter.missel@onlinehome.de>
To: video4linux-list@redhat.com
Date: Sun, 16 Mar 2008 12:54:27 +0100
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<pan.2008.03.16.07.45.13.220467@gimpelevich.san-francisco.ca.us>
In-Reply-To: <pan.2008.03.16.07.45.13.220467@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161254.28025.peter.missel@onlinehome.de>
Cc: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: LifeVideo To-Go Cardbus, tuner problems
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

Greetings!

> > Has anyone been able to get the TV tuning on the LifeVideo To-Go
> > Cardbus adapter to work?
> >
> Yes, I am indeed replying to a message from nineteen months ago. I have
> just now examined the behavior of the Windows driver for this card with
> RegSpy, and the correct module option for it is "card=39" and not
> "card=55" as above. Also, you MUST set the sampling rate to 32000 for
> saa7134-alsa. The card works perfectly and correctly then. Somebody,
> please add this info to the wiki.

I'd rather add autodetection for this card into the code.

Can you please give us the usual details - card name as shown on the box, card 
connectivity (please list connectors, dongles, adapters and accessories that 
came with it), card ID details as shown from the saa7134 driver loading 
and/or an lspci -vx command?

Thanks!

regards,
Peter

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
