Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATEOD0T026696
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 09:24:13 -0500
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mATEO0p8014431
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 09:24:01 -0500
To: roel kluin <roel.kluin@gmail.com>
References: <49311628.7090308@gmail.com> <87tz9qra24.fsf@free.fr>
	<49313E77.3090209@gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 29 Nov 2008 15:23:57 +0100
In-Reply-To: <49313E77.3090209@gmail.com> (roel kluin's message of "Sat\,
	29 Nov 2008 08\:07\:03 -0500")
Message-ID: <87myfi391e.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	mchehab@infradead.org
Subject: Re: [PATCH v2] mt9m111: mt9m111_get_global_gain() - unsigned <= 0
	is always true
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

roel kluin <roel.kluin@gmail.com> writes:

>> You're right, your patch is good, but ... there is another mistake I made which
>> should be also fixed.
>> 
>> The real formula is :
>>   gain = (data & 0x2f) * (1 << ((data >> 10) & 1)) * (1 << ((data >> 9) & 1));
>> 
>> That is bits 9 and 10 give a 2x gain factor.
>
> unsigned <= 0 is always true and fix formula
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
