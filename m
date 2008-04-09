Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m39LwJgg009369
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 17:58:19 -0400
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m39LvpJi030063
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 17:57:51 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: John Drescher <drescherjm@gmail.com>, Anton Farygin <rider@altlinux.com>
In-Reply-To: <387ee2020804090829h62c29441i3ade07daef43c372@mail.gmail.com>
References: <47FCD8C6.1000407@anevia.com>
	<387ee2020804090829h62c29441i3ade07daef43c372@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 23:57:45 +0200
Message-Id: <1207778265.5554.35.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Analog card with Hardware MPEG2 Enc
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

Am Mittwoch, den 09.04.2008, 11:29 -0400 schrieb John Drescher:
> On Wed, Apr 9, 2008 at 10:55 AM, Frederic CAND <frederic.cand@anevia.com> wrote:
> > Hi all,
> >
> >  I'm looking for a good PCI card, supporting Analog input (Composite,
> >  S-Video, Pal/Secam Tuner) and providing MPEG2/TS.
> >
> >  We were using KNC1 TVStation DVR cards until now (w/ saa6752hs chip) on
> >  the servers we build but we have to change (card status is "end of
> >  life") and are looking for similar cards.
> >
> >  Does anybody have a hint if such a card exist or not ?
> >
> >  Hardware MPEG2 encoding (TS encapsulation) is an important matter for
> >  us, to avoid having Software MPEG2 encoding.
> >
> Hauppage PVR150
> 
> John
> 

Frederic, I remember you have contributed to saa7134 empress development
previously.

Currently, after lots of code changes without any testers, empress
devices have been always very rare, the support is broken and I try to
track down last working status.

Did some testing with an unsupported card recently, has also DVB-T, and
I get everything to work except the encoder.

What kernel version does still work for you?

There is also the Behold M6 Extra now.
http://www.ixbt.com/monitor/behold-m6-extra.shtml

But this one fails, reported by Anton, even on 2.6.18, which seems to me
the last kernel most likely still functional.

I have tried on a Creatix CTX946. (saa7134 card=12 works,except encoder)
http://www.creatix.de/produkte/multimedia/ctx946.htm

But I don't get a valid format setup, which very likely is caused by the
card is not hacked/correctly_configured yet.

Beside ivtv, the cx88 driver has also lots of cards with mpeg encoder,
so called blackbird design, but from what I hear the pvr150 and similar
are for sure well supported.

Thanks,
Hermann









--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
