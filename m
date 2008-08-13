Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7D1HnaL032260
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 21:17:49 -0400
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7D1Hbsc029419
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 21:17:38 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	video4linux-list@redhat.com, linux-dvb@linuxtv.org
In-Reply-To: <20080813090637.1def4bca@glory.loctelecom.ru>
References: <20080813090637.1def4bca@glory.loctelecom.ru>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 03:09:18 +0200
Message-Id: <1218589758.2672.3.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: format of data
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

Am Mittwoch, den 13.08.2008, 09:06 +1000 schrieb Dmitri Belimov:
> Hi Hermann
> 
> A few days a go I wrote message about lock /dev/video0 when /dev/video1 is busy.
> I discuss with our main programmer about this. His answer is:
> When TV card send RAW YUV data we can't read from MPEG device. But when TV
> card send data in YUY2, UYVY, RGB we can work with MPEG device.
> 
> Linux kernel's module of saa7134 can work with this type of data??
> How to I can control this? 
> We can rework saa7134 modules for set different types of data and lock MPEG device only for YUV format.
> 
> With my best regards, Dmitry.

just read some last mails before going to sleep,
but how to deal with it is likely more difficult than to wake up next
morning and have a solution.

I'm only a relict of all the initial attempts with Gerd Knorr to get all
such saa713x stuff on the run, mostly not even tortured on top by such
questions, but by undocumented tuners.

Hartmut did know about this limitation first. If the mpeg/TS interface
is in use, only packed formats can pass at once the dma engines for
analog, doesn't matter if from a second tuner or external video inputs.

How to control this in the current framework, given cards with up to six
mixed dvb/analog streams at once, which need proper usage, is not such a
simple question. Either can analog planar disallow mpeg, if first, or
should mpeg always have the priority, and if in use already, analog is
damned to have packed formats only.

There are simply no rules yet, where to start and what should have some
priority.

We could try to reach everyone we can think of, or simply post it to the
lists and hope from there something comes back.

Whatever you decide to further proceed is fine with me.

Cheers,
Hermann








--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
