Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1RKpZ04014193
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 15:51:35 -0500
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1RKp4Yj011481
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 15:51:04 -0500
From: Tux <tux@schweikarts-vom-dach.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Date: Wed, 27 Feb 2008 21:51:19 +0100
References: <200801051252.18108.tux@schweikarts-vom-dach.de>
	<47B9F1C2.3050309@t-online.de>
In-Reply-To: <47B9F1C2.3050309@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802272151.19488.tux@schweikarts-vom-dach.de>
Cc: video4linux-list@redhat.com
Subject: Re: DVB-S on quad TV tuner card from Medion PC MD8800
Reply-To: tux@schweikarts-vom-dach.de
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

Hello Hartmut,

i have tried the new driver. You are completely right, one port is working
perfectly. But the other one not. What Information do you need to fix it ?


best regards

Tux
Am Montag, 18. Februar 2008 21:59:46 schrieb Hartmut Hackmann:
> Hi
>
> Tux schrieb:
> > Hello,
> >
> > what is the status of the DVB-S Part of the TV Card. Is it now possible
> > to select the frontend for this card with a kernel option ?
> > I have downloaded the actual version of the sources and have had look
> > into saa7134-dvb.c. There is only the DVB-T part supported. When do you
> > think it possible to watch TV with DVB-S with this card ?
> >
> > best regards
>
> One DVB-S section of the board should be working now.
> You need to get the most recent driver from
> http://www.linuxtv.org/hg/v4l-dvb To get DVB-S, you nned to load the
> saa7134-dvb module with the option use_frontend=1.
> You get the other section working, i need a tester who has the card in a pc
> it was sold with ( since it is NOT a regular PCI card)
>
> best regards
>   Hartmut


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
