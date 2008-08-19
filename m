Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7J2Hj2Y026041
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 22:17:45 -0400
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7J2HWhH024662
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 22:17:32 -0400
Received: from mail-in-07-z2.arcor-online.net (mail-in-07-z2.arcor-online.net
	[151.189.8.19])
	by mail-in-04.arcor-online.net (Postfix) with ESMTP id 2A67917F46E
	for <video4linux-list@redhat.com>;
	Tue, 19 Aug 2008 04:17:31 +0200 (CEST)
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mail-in-07-z2.arcor-online.net (Postfix) with ESMTP id 161ED2C6BAC
	for <video4linux-list@redhat.com>;
	Tue, 19 Aug 2008 04:17:31 +0200 (CEST)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-17.arcor-online.net (Postfix) with ESMTP id 71F6D2BD308
	for <video4linux-list@redhat.com>;
	Tue, 19 Aug 2008 04:17:30 +0200 (CEST)
From: hermann pitton <hermann-pitton@arcor.de>
To: video4linux-list@redhat.com
In-Reply-To: <2df568dc0808181516g49377e0fj73c104696d8616d4@mail.gmail.com>
References: <2df568dc0808181516g49377e0fj73c104696d8616d4@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 04:16:30 +0200
Message-Id: <1219112190.4107.5.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: saa7134_empress hang on close()
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

Hi Gordon,

Am Montag, den 18.08.2008, 16:16 -0600 schrieb Gordon Smith:
> Hello -
> 
> I have a saa7134 based video capture card running in kernel
> 2.6.24.4(gentoo). I can view raw and compressed video on both channels
> of the card
> using xawtv and mplayer.
> 
> However, any program reading a compressed stream that attempts to exit,
> hangs and is unkillable. This includes cat, mplayer, and the example V4L2
> program capture.c.
> 
> I removed capture code from capture.c (because, unlike mplayer, it doesn't
> capture) and left only open() and close() and found that it hangs on
> close().
> 
> Any thoughts on how I might solve this problem?
> 

you might have seen the ongoing debugging and improvements to get the
saa7134-empress back and better.

Are you using a known card, which is assumed to be supported and which
tuner is on it?

Did you try the recent v4l-dvb and maybe use qv4l2 to control the
devices?

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
