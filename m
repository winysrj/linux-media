Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FLG9G6020266
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 16:16:09 -0500
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FLFZrb003666
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 16:15:35 -0500
Received: from mail-in-14-z2.arcor-online.net (mail-in-14-z2.arcor-online.net
	[151.189.8.31])
	by mail-in-10.arcor-online.net (Postfix) with ESMTP id 463EB1F527E
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 22:15:35 +0100 (CET)
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mail-in-14-z2.arcor-online.net (Postfix) with ESMTP id 3323B100B9
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 22:15:35 +0100 (CET)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-01.arcor-online.net (Postfix) with ESMTP id C53B0104703
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 22:15:34 +0100 (CET)
From: hermann pitton <hermann-pitton@arcor.de>
To: video4linux-list@redhat.com
In-Reply-To: <200802152321.03196.roginovicci@nm.ru>
References: <aedf12640802151146i1c02547ct7cc1671285fb95cf@mail.gmail.com>
	<200802152321.03196.roginovicci@nm.ru>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 22:10:31 +0100
Message-Id: <1203109831.7303.5.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: Encore ENLTV-FM (TV tuner Pro)
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

Hello,

Am Freitag, den 15.02.2008, 23:21 +0300 schrieb Eugene:
> Hola Alexandro!
> On Friday 15 February 2008 22:46:49 Alexandro Silva wrote:
> >. The only remaining problem is that
> > audio out is up even after close de screen, until I shutdown my machine and
> > when I start pc the tv sound gets up again during de boot process.
> >
> > I attached too the dmesg080215-ful.txt file with entire dmesg out and
> > dmesg080215.txt file with just saa grep.
> As far as I know SAA7130 based cards have no sound through pci functionality. 
> Thus I came into conclusion that there is a wipe connecting the tuner and 
> audio card. I think you should adjust the sound card through alsamixer and 
> alsactl ( with "store" option) to turnoff line input by default.
> 

the FlyVideo2000 cards have an external audio mux switched by gpio to
actively mute the routed sound.

So this card has either no mux or different switching.
On the saa7130 the default workaround is to switch to an unused input on
mute then. Should be amux LINE1 in that case.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
