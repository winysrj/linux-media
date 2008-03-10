Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2AIh7gw020260
	for <video4linux-list@redhat.com>; Mon, 10 Mar 2008 14:43:07 -0400
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2AIgXQM015644
	for <video4linux-list@redhat.com>; Mon, 10 Mar 2008 14:42:33 -0400
From: Tux <tux@schweikarts-vom-dach.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Date: Mon, 10 Mar 2008 19:42:39 +0100
References: <200801051252.18108.tux@schweikarts-vom-dach.de>
	<200802272151.19488.tux@schweikarts-vom-dach.de>
	<47CC8094.8000106@t-online.de>
In-Reply-To: <47CC8094.8000106@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200803101942.40158.tux@schweikarts-vom-dach.de>
Content-Transfer-Encoding: 8bit
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

sorry that it has taken so long time to test it. I have tried it with option 
use_frontend=1,1 and now it is posible to watch TV on the other
port.

best regards

Tux

Am Montag, 3. März 2008 23:49:56 schrieben Sie:
> Hi
>
> Tux schrieb:
> > Hello Hartmut,
> >
> > i have tried the new driver. You are completely right, one port is
> > working perfectly. But the other one not. What Information do you need to
> > fix it ?
> >
> >
> > best regards
>
> <snip>
>
> in my personal repository: http://linuxtv.org/hg/~hhackmann/v4l-dvb/
> i tried to make the 2nd section work too. I don't know which gpo is
> the right one to control the LNB supply, i need you to find out whether
> switching the polarization works.
> There are remaining restrictions:
> - the 2nd DVB-S section only works if the first is configured for DVB-S
> too. so "options saa7134-dvb use_frontend=0,1" won't work, but
> use_frontend=1,0 and use_frontend=1,1 should.
> - currently it is not possible to choose the higher LNB voltage (14v
> instead of 13v) - it is not possible to power down the 2nd LNB supply
> independently. These are due to the fact that it is not possible to access
> the LNB supply chip via the i2c bus fron the second section of the card.
>
> Happy testing
>   Hartmut
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
