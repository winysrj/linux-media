Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab1IDOAh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Sep 2011 10:00:37 -0400
Message-ID: <4E63847F.1000706@redhat.com>
Date: Sun, 04 Sep 2011 11:00:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] DVB: dvb_frontend: convert semaphore to mutex
References: <1314207232-6031-1-git-send-email-obi@linuxtv.org>	<CAGoCfizk8Ni96yJJq7Q=MGhH_-EgLskYd3SDMJ4w9mAdEPg1mg@mail.gmail.com>	<4E553CBE.8010506@linuxtv.org>	<CAGoCfiwt6siLdT_bCgnBnpmUuwL-CK+r8rCUTviNHWko7=NKQA@mail.gmail.com>	<4E553E2E.2020803@linuxtv.org> <CAGoCfixD0QVvWKc-6w+OrckJo2wX6q6ndpzCg5aOV2W0pgVUvg@mail.gmail.com> <4E577117.7080104@linuxtv.org>
In-Reply-To: <4E577117.7080104@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-08-2011 07:10, Andreas Oberritter escreveu:
> On 24.08.2011 20:54, Devin Heitmueller wrote:
>> On Wed, Aug 24, 2011 at 2:08 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
>>> Instead of wasting your time with theory, you could have easily reviewed
>>> my patch. It's really *very* simple any anyone having used semphores or
>>> mutexes in the kernel should be able to see that.
>>
>> There's no need to resort to belittlement.  Both of us have a
>> non-trivial number of commits to the Linux kernel.
>>
>> My concern is that in the kernel a semaphore with a unit of one is
>> *not* necessarily the same as a mutex.  In particular you need to take
>> into account the calling context since mutexes do more enforcement of
>> certain conditions that may have been acceptable for a semaphore.
>>
>> From http://www.kernel.org/doc/Documentation/mutex-design.txt :
>>
>> ===
>>  - 'struct mutex' semantics are well-defined and are enforced if
>>    CONFIG_DEBUG_MUTEXES is turned on. Semaphores on the other hand have
>>    virtually no debugging code or instrumentation. The mutex subsystem
>>    checks and enforces the following rules:
>>
>>    * - only one task can hold the mutex at a time
>>    * - only the owner can unlock the mutex
>>    * - multiple unlocks are not permitted
>>    * - recursive locking is not permitted
>>    * - a mutex object must be initialized via the API
>>    * - a mutex object must not be initialized via memset or copying
>>    * - task may not exit with mutex held
>>    * - memory areas where held locks reside must not be freed
>>    * - held mutexes must not be reinitialized
>>    * - mutexes may not be used in hardware or software interrupt
>>    *   contexts such as tasklets and timers
>> ===
>>
>> and:
>>
>> ===
>> Disadvantages
>> -------------
>>
>> The stricter mutex API means you cannot use mutexes the same way you
>> can use semaphores: e.g. they cannot be used from an interrupt context,
>> nor can they be unlocked from a different context that which acquired
>> it. [ I'm not aware of any other (e.g. performance) disadvantages from
>> using mutexes at the moment, please let me know if you find any. ]
>> ===
>>
>> In short, you cannot just arbitrarily replace one with the other.  You
>> need to look at all the possible call paths and ensure that there
>> aren't any cases for example where the mutex is set in one but cleared
>> in the other.  Did you evaluate your change in the context of each of
>> the differences described in the list above?
> 
> You're right. There's one place where the semaphore is taken in user
> context and released by the frontend thread. I'm going to investigate
> whether this complicated locking is required. It might as well be
> possible to move the initialization steps from the beginning of the
> thread to dvb_frontend_start(), thus rendering this use of the semaphore
> unnecessary, and therefore making the code easier to understand and
> maintain.

Ok, I'm dropping this patch from my queue.

> Unfortunately, I couldn't find any pointers as to why unlocking a mutex
> in a different context is not allowed. The only drawback seems to be a
> warning (which doesn't show up if there was any previous warning...), if
> mutex debugging is enabled. Besides that, I didn't notice any problem
> during runtime tests (on mips with SMP enabled).

Maybe it affects only certain archs. I suggest you to look into the git history,
and see when the mutex calls were added and when  most semaphores were converted
into mutexes. Probably, the comments there at git will provide you enough
background.

> 
> Regards,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

