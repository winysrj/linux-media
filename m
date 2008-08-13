Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7E026OX021953
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 20:02:06 -0400
Received: from mail-in-08.arcor-online.net (mail-in-08.arcor-online.net
	[151.189.21.48])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7E01sls008050
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 20:01:54 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
In-Reply-To: <20080813135255.5af83623@glory.loctelecom.ru>
References: <20080813135255.5af83623@glory.loctelecom.ru>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 01:53:31 +0200
Message-Id: <1218671611.2696.30.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, gert.vervoort@hccnet.nl,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: TS packet??
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

Am Mittwoch, den 13.08.2008, 13:52 +1000 schrieb Dmitri Belimov:
> Hi All
> 
> After long time plaing with MPEG encoder I read test data. See attachment.
> Is it correct TS packet??

all known apps dealing with .ts streams say no.

As I at the very beginning tried to point to, after realizing a total
mess happened, Frederic has some last known spot working and can also
report about how far he can come with the recent attempts.

I'm still without any such hardware even close to be functional for the
empress encoder.

But at least others have/had stuff proved once to be functional, like
Frederic and Gert and Mans previously and Hans is around too.

Looks like you have by default the mpeg encoder more or less active and
I can only say, that I don't have the slightest problems for analog
TV ;), to get the tda9887 sharp early enough is likely still something
very simple, and DVB-T and on radio only the well known minor, what to
say, fuzz for autoscanning ;)

How to switch from DVB-T to the mpeg encoder, I don't know ...

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
