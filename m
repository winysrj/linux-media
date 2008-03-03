Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m23MoLhs006519
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 17:50:22 -0500
Received: from mailout03.sul.t-online.com (mailout03.sul.t-online.de
	[194.25.134.81])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m23MnmoB029494
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 17:49:48 -0500
Message-ID: <47CC8094.8000106@t-online.de>
Date: Mon, 03 Mar 2008 23:49:56 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: tux@schweikarts-vom-dach.de
References: <200801051252.18108.tux@schweikarts-vom-dach.de>
	<47B9F1C2.3050309@t-online.de>
	<200802272151.19488.tux@schweikarts-vom-dach.de>
In-Reply-To: <200802272151.19488.tux@schweikarts-vom-dach.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: DVB-S on quad TV tuner card from Medion PC MD8800
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

Hi

Tux schrieb:
> Hello Hartmut,
> 
> i have tried the new driver. You are completely right, one port is working
> perfectly. But the other one not. What Information do you need to fix it ?
> 
> 
> best regards
> 
<snip>

in my personal repository: http://linuxtv.org/hg/~hhackmann/v4l-dvb/
i tried to make the 2nd section work too. I don't know which gpo is
the right one to control the LNB supply, i need you to find out whether
switching the polarization works.
There are remaining restrictions:
- the 2nd DVB-S section only works if the first is configured for DVB-S too.
  so "options saa7134-dvb use_frontend=0,1" won't work, but use_frontend=1,0
  and use_frontend=1,1 should.
- currently it is not possible to choose the higher LNB voltage (14v instead of 13v)
- it is not possible to power down the 2nd LNB supply independently.
These are due to the fact that it is not possible to access the LNB supply chip
via the i2c bus fron the second section of the card.

Happy testing
  Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
