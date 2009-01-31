Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0VFJ25M026166
	for <video4linux-list@redhat.com>; Sat, 31 Jan 2009 10:19:02 -0500
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0VFHtBb015708
	for <video4linux-list@redhat.com>; Sat, 31 Jan 2009 10:17:55 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Nimesh linuxmail <linuxnimesh@gmail.com>
In-Reply-To: <f23d30d0901310551t91cca7n717a2259b532614e@mail.gmail.com>
References: <48d00727.2fe.4e96.811320937@uninet.com.br>
	<f23d30d0901310551t91cca7n717a2259b532614e@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 16:18:23 +0100
Message-Id: <1233415103.2688.5.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7134 controller
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

Am Samstag, den 31.01.2009, 19:21 +0530 schrieb Nimesh linuxmail:
> Hi All,
> 
> 
> In my board SAA7134 is directly interface to CCIR interface of IMX processor
> ..
> Can it work really ... Please give your valuable suggestions...
> This is for video in support for our board...
> 

some of them seem to have mpeg2/4 hardware encoders.

For what I know we don't have support for them yet.

I can't tell if they do have something internally for GNU/Linux support
at Freescale.

Depending on the board's setup you might be able to get uncompressed
video from the external inputs or tuner, if present.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
