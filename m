Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2JLxqFv007811
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 17:59:52 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2JLxJw4021711
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 17:59:19 -0400
Message-ID: <47E18CA8.50208@linuxtv.org>
From: mkrufky@linuxtv.org
To: hartmut.hackmann@t-online.de
Date: Wed, 19 Mar 2008 16:59:04 -0500
MIME-Version: 1.0
in-reply-to: <47E18A81.3050504@t-online.de>
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org, mchehab@infradead.org
Subject: Re: [linux-dvb] [RFC] TDA8290 / TDA827X with LNA: testers wanted
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

Hartmut Hackmann wrote:
> Hi, Michael
>
> Michael Krufky schrieb:
>   
>> Hello Hartmut,
>>
>> Hartmut Hackmann wrote:
>>     
>>> Michael Krufky schrieb:
>>>       
>>>> I have an HVR1110, and I have a QAM64 generator that I use to test it.
>>>>  Obviously, it is a hot signal.  Is it possible for me to test the LNA
>>>> under these circumstances?  ...or do we need somebody "out in the
>>>> field" to do that sort of test?  (I live in ATSC-land ;-) )
>>>>
>>>>         
>>> You should be able to. You need to have the debug option for the tuner
on
>>> and you need to be aware that the decicion LNA on / off is taken only
once
>>> while tuning. When you modify the RF level you should notice that
increasing
>>> the amplitude results in a lower AGC2 value. When it reaches the value
2, the
>>> driver should report that it turns the LNA to low gain. You will also
need to
>>> monitor the AGC value of the channel decoder to see the effect.
>>>       
>> I'll give this a try when I have some time, and send you the logs.
>>
>>     
> By the way: I once heard that Hauppauge has cards with LNA, but uses a
different
> configuration. Did you ever notice "strange" effects in analog mode like
> a small moving horizontal bar while locking?
>
>   
>>>> You mentioned a possible kernel OOPS.  Have you actually experienced
>>>> an OOPS with the current tree?  I apologize if this feature being
>>>> broken is the result of my tuner refactoring.  I appreciate your
>>>> taking the time to fix it.
>>>>
>>>>         
>>> Yes. The first parameter to the tuner callback was wrong and cause a
reference
>>> to a NULL pointer.
>>>       
>> Ah, I believe this may have been caused by a very recent changeset:
>>
>> http://linuxtv.org/hg/v4l-dvb/rev/ad6fb7fe6240
>>
>> I tested all of my changes thoroughly, and had received positive test
results from other users with various hardware.
>> The regression was not part of my tuner refactoring changes, and I do not
think that this is upstream in 2.6.25-rc.
>>
>> Can you confirm whether or not the above is the problem changeset?
>>
>> Regards,
>>
>> Mike
>>
>>     
> Yes, that one caused the problem (from static analysis). This patch has
some
> inconsistencies that were grinded out later but this was the starting
point.
>
> If this code is not in 2.6.25-rc: good!! It leaves us time for testing and
> discussion.
> Do you think we need further discussion on my tuner config pointer change?
>
> Best regards
>   Hartmut
>   
Hartmut,

I don't think we need further discussion -- When I did the refactoring, 
I was only trying to preserve your functionality while adding new 
functionality for the new silicon.

I trust you as the authority on how the LNA should work, and I think 
that we should merge your changes into the master branch as soon as 
possible.

I'm glad to hear you confirm that Mauro's recent patch is the one that 
broke the driver.  This patch of his is not in 2.6.25-rc, but is planned 
for 2.6.26 -- for this reason, we should merge in your changes now and 
establish a known point of functionality.

As far as the HVR1110, I do not see such issues in the analog video.  I 
will not have time to conduct the LNA test until next week, the earliest.

Please ask Mauro to merge it asap.  Let him know that this is *not* 
urgent for 2.6.25, because the offending changeset is not yet upstream, 
but we do need this in master now for the sake of testing and good 
housekeeping.

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
