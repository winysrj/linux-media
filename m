Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3ACtFaq030590
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 08:55:15 -0400
Received: from vds19s01.yellis.net (ns1019.yellis.net [213.246.41.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3ACstcT008144
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 08:54:55 -0400
Message-ID: <47FE0E1C.1070605@anevia.com>
Date: Thu, 10 Apr 2008 14:54:52 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <47FCD8C6.1000407@anevia.com>	
	<387ee2020804090829h62c29441i3ade07daef43c372@mail.gmail.com>
	<1207778265.5554.35.camel@pc08.localdom.local>
In-Reply-To: <1207778265.5554.35.camel@pc08.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: John Drescher <drescherjm@gmail.com>, linux-dvb@linuxtv.org,
	video4linux-list@redhat.com, Anton Farygin <rider@altlinux.com>
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

hermann pitton a écrit :
> Hi,
> 
> Am Mittwoch, den 09.04.2008, 11:29 -0400 schrieb John Drescher:
>> On Wed, Apr 9, 2008 at 10:55 AM, Frederic CAND <frederic.cand@anevia.com> wrote:
>>> Hi all,
>>>
>>>  I'm looking for a good PCI card, supporting Analog input (Composite,
>>>  S-Video, Pal/Secam Tuner) and providing MPEG2/TS.
>>>
>>>  We were using KNC1 TVStation DVR cards until now (w/ saa6752hs chip) on
>>>  the servers we build but we have to change (card status is "end of
>>>  life") and are looking for similar cards.
>>>
>>>  Does anybody have a hint if such a card exist or not ?
>>>
>>>  Hardware MPEG2 encoding (TS encapsulation) is an important matter for
>>>  us, to avoid having Software MPEG2 encoding.
>>>
>> Hauppage PVR150
>>
>> John
>>
> 
> Frederic, I remember you have contributed to saa7134 empress development
> previously.
> 
> Currently, after lots of code changes without any testers, empress
> devices have been always very rare, the support is broken and I try to
> track down last working status.
> 
> Did some testing with an unsupported card recently, has also DVB-T, and
> I get everything to work except the encoder.
> 
> What kernel version does still work for you?


Actually, since recently we were still using kernel 2.6.9, with an old 
v4l snapshot (20050426).

But, due to some changes, we had to change kernel version, and use 
2.6.16.29. Still, to avoid too many changes to occur at the same time, 
we wanted to use the same snapshot. We did some minor adaptations for it 
to compile against 2.6.16.29.
However, it's working with our same old (but fastly running to its end 
of life) KNC1 TV Station DVR  based on saa7134, saa6752hs and tda9887.


> 
> There is also the Behold M6 Extra now.
> http://www.ixbt.com/monitor/behold-m6-extra.shtml
> 
> But this one fails, reported by Anton, even on 2.6.18, which seems to me
> the last kernel most likely still functional.
> 
> I have tried on a Creatix CTX946. (saa7134 card=12 works,except encoder)
> http://www.creatix.de/produkte/multimedia/ctx946.htm
> 
> But I don't get a valid format setup, which very likely is caused by the
> card is not hacked/correctly_configured yet.

Thanks for these links. Do you know if the chipsets used are running to 
their end of life or not ?

> 
> Beside ivtv, the cx88 driver has also lots of cards with mpeg encoder,
> so called blackbird design, but from what I hear the pvr150 and similar
> are for sure well supported.

Yeah, but our requirements are not just MPEG2 Hardware encoding, but 
MPEG2/TS Hardware encoding (MPEG2/PS would be painful for us). How can 
we know this prior to buying cards and check ?
We'll be trying the HVR 1300 soon, however.

> 
> Thanks,
> Hermann
> 
> 

Thanks a lot.

-- 
CAND Frederic
Product Manager
ANEVIA

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
