Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2CMl5gh008144
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 18:47:05 -0400
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2CMkW7x006507
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 18:46:32 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: itman <itman@fm.com.ua>
In-Reply-To: <003401c88469$af50f4d0$6401a8c0@LocalHost>
References: <47D6F12C.7040102@fm.com.ua>
	<1205269761.5927.77.camel@pc08.localdom.local>
	<BAY107-W53381D746959C109E3EF0097080@phx.gbl>
	<003401c88469$af50f4d0$6401a8c0@LocalHost>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 23:38:36 +0100
Message-Id: <1205361516.5924.20.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: S G <stive_z@hotmail.com>, video4linux-list@redhat.com, xyzzy@speakeasy.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	midimaker@yandex.ru, simon@kalmarkaglan.se
Subject: RE: Re: 2.6.24 kernel and MSI TV @nywheremaster MS-8606 status
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

Hi,

Am Mittwoch, den 12.03.2008, 19:51 +0200 schrieb itman:
> Hi, Steve.
>  
>  
> Unfortunately by default initialization for this tuner it does not go
> in right way. 
> So I use this sequence  (see full list of commands) to make it work:
>  
>  
>  
> rmmod cx88_alsa 
> rmmod cx8800
> rmmod cx88xx 
> rmmod tuner
> rmmod tda9887 
> modprobe cx88xx 
> modprobe tda9887 port1=0 port2=0 qss=1 
> modprobe tuner 
> modprobe cx8800
>  
>  
> Actually I do not dig deeply with this, but main goal of this is to
> initiate device with port1=0 port2=0 qss=1 option to get sound.
> Also v4l devices appears in /dev after cx8800 initialization (could be
> mistaken, because I am writing this by memory ;-) and, lol, from
> Windows PC).
>  
> Pls also see Hermann explanation.
>  

there is one thing I would like to mention again.
Don't suggest to use qss=1.

You don't need to set it, since it is the default.

The tda9887 config comes down from the module defaults over tuner
specific settings, then card specific settings and finally insmod
options.

The insmod options override all others, in this case here they also do
override the qss=0 for NTSC in the card's entry. Result is no sound for
NTSC-M system with forced qss=1.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
