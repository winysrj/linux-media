Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6PHWSvM005232
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 13:32:28 -0400
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6PHW33G029845
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 13:32:04 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
In-Reply-To: <20080725223700.03d532cf@glory.loctelecom.ru>
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<20080415122524.3455e060@gaivota>
	<20080422175422.3d7e4448@glory.loctelecom.ru>
	<20080422130644.7bfe3b2d@gaivota>
	<20080423124157.1a8eda0a@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804222254350.20809@bombadil.infradead.org>
	<20080423160505.36064bf7@glory.loctelecom.ru>
	<20080423113739.7f314663@gaivota>
	<20080424093259.7880795b@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804232237450.31358@bombadil.infradead.org>
	<20080512201114.3bd41ee5@glory.loctelecom.ru>
	<1210719122.26311.37.camel@pc10.localdom.local>
	<20080520152426.5540ee7f@glory.loctelecom.ru>
	<1211331167.4235.26.camel@pc10.localdom.local>
	<20080612194426.0e33d92c@glory.loctelecom.ru>
	<2a93ca18e1d9bc5726b7f1fd60da1852.squirrel@webmail.hccnet.nl>
	<20080613180516.211a27a9@glory.loctelecom.ru>
	<1213388868.2758.78.camel@pc10.localdom.local>
	<20080618091650.0bd7e2ae@glory.loctelecom.ru>
	<1213842219.2554.16.camel@pc10.localdom.local>
	<20080725223700.03d532cf@glory.loctelecom.ru>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 19:25:33 +0200
Message-Id: <1217006733.3393.14.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, gert.vervoort@hccnet.nl,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Beholder card M6 with MPEG2 coder
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

Am Freitag, den 25.07.2008, 22:37 +1000 schrieb Dmitri Belimov:
> Hi All
> 
> I discover next problem with saa7134 module.
> When the saa7134 send planar data in YUV format it capture 3 DMA slice. The DMA slice 5 captured too.
> The MPEG stream use the DMA slice 5 for send data to host. At the same time we can`t use planar data in YUV and MPEG stream.
> 
> When I start cat /dev/video0 > raw.dat and cat /dev/video1 > mpeg.dat
> In the mpeg.dat I have raw V channel of YUV.
> 
> I think more correct when read /dev/video0 lock /dev/video1
> When read /dev/video1 lock /dev/video0
> 
> With my best regards, Dmitry.
> 

yes, that is a very well known restriction.

If mpeg is in use, either for DVB or an encoder, only packed formats can
pass at once too.

Hartmut was once thinking about to disallow planar formats,
but best solution would be only to disallow them, when the mpeg/TS
interface is in use.

Not implemented yet, so the user must take care.

I will be mostly out of houses next time, summer else is soon gone
again. Responses might be delayed.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
