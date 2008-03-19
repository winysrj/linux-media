Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2JLoiEB002216
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 17:50:44 -0400
Received: from mailout08.sul.t-online.de (mailout08.sul.t-online.de
	[194.25.134.20])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2JLoAEQ015823
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 17:50:11 -0400
Message-ID: <47E18A81.3050504@t-online.de>
Date: Wed, 19 Mar 2008 22:49:53 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <47E060EB.5040207@t-online.de>	<37219a840803181754n5935b4e8g37dc77dd605b3095@mail.gmail.com>	<47E06D5C.3070109@t-online.de>
	<47E094A6.8030205@linuxtv.org>
In-Reply-To: <47E094A6.8030205@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	LInux DVB <linux-dvb@linuxtv.org>
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

Hi, Michael

Michael Krufky schrieb:
> Hello Hartmut,
> 
> Hartmut Hackmann wrote:
>> Michael Krufky schrieb:
>>> I have an HVR1110, and I have a QAM64 generator that I use to test it.
>>>  Obviously, it is a hot signal.  Is it possible for me to test the LNA
>>> under these circumstances?  ...or do we need somebody "out in the
>>> field" to do that sort of test?  (I live in ATSC-land ;-) )
>>>
>> You should be able to. You need to have the debug option for the tuner on
>> and you need to be aware that the decicion LNA on / off is taken only once
>> while tuning. When you modify the RF level you should notice that increasing
>> the amplitude results in a lower AGC2 value. When it reaches the value 2, the
>> driver should report that it turns the LNA to low gain. You will also need to
>> monitor the AGC value of the channel decoder to see the effect.
> 
> I'll give this a try when I have some time, and send you the logs.
> 
By the way: I once heard that Hauppauge has cards with LNA, but uses a different
configuration. Did you ever notice "strange" effects in analog mode like
a small moving horizontal bar while locking?

>>> You mentioned a possible kernel OOPS.  Have you actually experienced
>>> an OOPS with the current tree?  I apologize if this feature being
>>> broken is the result of my tuner refactoring.  I appreciate your
>>> taking the time to fix it.
>>>
>> Yes. The first parameter to the tuner callback was wrong and cause a reference
>> to a NULL pointer.
> 
> Ah, I believe this may have been caused by a very recent changeset:
> 
> http://linuxtv.org/hg/v4l-dvb/rev/ad6fb7fe6240
> 
> I tested all of my changes thoroughly, and had received positive test results from other users with various hardware.
> The regression was not part of my tuner refactoring changes, and I do not think that this is upstream in 2.6.25-rc.
> 
> Can you confirm whether or not the above is the problem changeset?
> 
> Regards,
> 
> Mike
> 
Yes, that one caused the problem (from static analysis). This patch has some
inconsistencies that were grinded out later but this was the starting point.

If this code is not in 2.6.25-rc: good!! It leaves us time for testing and
discussion.
Do you think we need further discussion on my tuner config pointer change?

Best regards
  Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
