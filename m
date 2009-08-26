Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7Q08wSO018871
	for <video4linux-list@redhat.com>; Tue, 25 Aug 2009 20:08:58 -0400
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7Q08fWv030993
	for <video4linux-list@redhat.com>; Tue, 25 Aug 2009 20:08:44 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
In-Reply-To: <20090825154352.030299ba@glory.loctelecom.ru>
References: <20090825154352.030299ba@glory.loctelecom.ru>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 02:02:05 +0200
Message-Id: <1251244925.3332.7.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: saa7134 and xc5000
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

Hi Dmitry,

Am Dienstag, den 25.08.2009, 15:43 +1000 schrieb Dmitri Belimov:
> Hi All
> 
> Our company release new TV card based on the saa7134 and xc5000.
> I write some code and now I can watch analog TV, video and audio is good.
> 
> For analog FM radio need switch input saa7134 to SIF and set SIF to 10.7MHz.
> 
> How to I can do it??
> 
> With my best regards, Dmitry.

try to dig out the two old patches from Hartmut in 2006, when he first
added radio IF support to saa7133/35/31e devices for the Philips silicon
tuners and later also for stereo detection, to make the apps happy for
auto scanning.

This should give you some guidance.

Let me know, if you should have problems to find them. I'll point you
then.

Cheers,
Hermann





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
