Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2R5ZGJR027132
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 01:35:16 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2R5Z43U020052
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 01:35:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JeklS-00048a-Ac
	for video4linux-list@redhat.com; Thu, 27 Mar 2008 05:35:02 +0000
Received: from rider.balabanovo.ru ([195.112.97.85])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 05:35:02 +0000
Received: from rider by rider.balabanovo.ru with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 05:35:02 +0000
To: video4linux-list@redhat.com
From: Anton Farygin <rider@altlinux.com>
Date: Thu, 27 Mar 2008 08:18:01 +0300
Message-ID: <fsfals$3vh$1@ger.gmane.org>
References: <fsecqi$f8k$1@ger.gmane.org>
	<1206572344.3912.35.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <1206572344.3912.35.camel@pc08.localdom.local>
Subject: Re: [linux-dvb] saa7134 oops
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

hermann pitton пишет:
> Hi,
> 
> Am Mittwoch, den 26.03.2008, 23:48 +0300 schrieb Anton Farygin:
>> Hello.
>>
>> on v4l-dvb snapshot 9a2af878cbd5 i received this oops with xawtv. Can 
>> anyone to help me ?
>>
>>
>> Card:Beholder TV M6 Extra.
>> 01:09.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 
>> Video Broadcast Decoder (rev d1)
>>          Subsystem: Unknown device 5ace:6193
>>
>>
>>
<skip>
> 
> some time back I tried on a not yet supported saa7134 empress-card.
> 
> I confirm this oops with whenever empress_querycap is called on current
> code. However, others with older supported cards reported them still
> working at least on 2.6.18, went even back to 2.6.12, mine fails even
> there with vidio get/set standard.
> 
> Since this might be card specific, there is already another one which
> needs special measures to establish valid output, I called for recent
> status reports, since the problem seems to exist since long, to find a
> starting point, but nothing came in so far.
> 
> On your card it might not be much better, we have no debug output from
> it that shows the mpeg encoder really functional.
> 
> For now, please continue on the video4linux-list, it is really OT here,
> mine has at least working DVB-T and analog, but debugging the encoder
> problems is still not for the dvb ML. If you can, maybe Knoppix or
> something, try on 2.6.18 and 2.6.12.


Thanks for suggestion, Hermann.

Beholder M6 Extra works on 2.6.18 and old v4l snapshot, but without 
empress encoder.

What need from me for debugging?

Rgds,
Anton

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
