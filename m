Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4Q1xxNR027281
	for <video4linux-list@redhat.com>; Sun, 25 May 2008 21:59:59 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4Q1xiHK028027
	for <video4linux-list@redhat.com>; Sun, 25 May 2008 21:59:45 -0400
Message-ID: <483A1989.2040704@linuxtv.org>
Date: Sun, 25 May 2008 21:59:37 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Jason Pontious <jpontious@gmail.com>
References: <f50b38640805251834x6894f13du22ea670ae99aa614@mail.gmail.com>
In-Reply-To: <f50b38640805251834x6894f13du22ea670ae99aa614@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Kworld 115 Analog Input Selection
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

Jason Pontious wrote:
> I have been attempting to understand how the rf input is selected for analog
> on the Kworld 115.  I'm currently using 2.6.24 kernel (Ubuntu 8.04). Mine is
> currently setup as follows
> 
> RF Input 1: ATSC/Analog
> RF Input 2: QAM
> 
> I would like to move the analog to the same input as the QAM.
> 
> Would it be possible for this to be configurable?  Not changeable on the fly
> but set up as an option passed into the module?
> 
> I have found this in tuner-simple.c which seems to show that there are 4
> possible inputs.  But where is this actually initialized to one or the
> other.  Is it just a simple switch somewhere I can change and recompile the
> module?
> 
> case TUNER_PHILIPS_TUV1236D
> <http://www.gelato.unsw.edu.au/lxr/ident?i=TUNER_PHILIPS_TUV1236D>:
>  <http://www.gelato.unsw.edu.au/lxr/source/drivers/media/video/tuner-simple.c#L259>
>              */* 0x40 -> ATSC antenna input 1 */*
>  <http://www.gelato.unsw.edu.au/lxr/source/drivers/media/video/tuner-simple.c#L260>
>              */* 0x48 -> ATSC antenna input 2 */*
>  <http://www.gelato.unsw.edu.au/lxr/source/drivers/media/video/tuner-simple.c#L261>
>              */* 0x00 -> NTSC antenna input 1 */*
>  <http://www.gelato.unsw.edu.au/lxr/source/drivers/media/video/tuner-simple.c#L262>
>              */* 0x08 -> NTSC antenna input 2 */*

There is a module option in tuner-simple that will let you do this, but that code is not in the 2.6.24 kernel.

You'll have to install v4l-dvb from linuxtv.org for the new feature.

modinfo tuner-simple for details.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
