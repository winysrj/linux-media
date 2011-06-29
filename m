Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:14594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab1F2NGP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 09:06:15 -0400
Message-ID: <4E0B2382.4090409@redhat.com>
Date: Wed, 29 Jun 2011 15:07:14 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: RFC: poll behavior
References: <201106291326.47527.hansverk@cisco.com> <4E0B1644.5030809@redhat.com> <201106291442.30210.hansverk@cisco.com>
In-Reply-To: <201106291442.30210.hansverk@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/29/2011 02:42 PM, Hans Verkuil wrote:
> On Wednesday, June 29, 2011 14:10:44 Hans de Goede wrote:
>> Hi,
>>
>> On 06/29/2011 01:26 PM, Hans Verkuil wrote:

<Snip>

>>> 4) Proposal to change the poll behavior
>>>
>>> For the short term I propose that condition c is handled as follows:
>>>
>>> If for the filehandle passed to poll() no events have been subscribed, then
>>> keep the old behavior (i.e. start streaming). If events have been subscribed,
>>> however, then implement the new behavior (return POLLERR).
>>>
>>
>> If events have been subscribed and no events are pending then the right
>> behavior would be to return 0, not POLLERR, otherwise a waiting app
>> will return from the poll immediately, or am I missing something?
>
> Yes and no. For select() POLLERR is ignored if you are only waiting for POLLPRI.
>
> But I see that that does not happen for the poll(2) API (see do_pollfd() in
> fs/select.c). This means that POLLERR is indeed not a suitable event it
> return. It will have to be POLLIN or POLLOUT instead.
>
> This is actually a real problem with poll(2): if there is no streaming in progress
> and the driver does not support r/w, and you want to poll for just POLLPRI, then
> POLLERR will be set, and poll(2) will always return. But select(2) will work fine.
>
> In other words, poll(2) and select(2) handle POLLPRI differently with respect to
> POLLERR. What a mess. You can't really return POLLERR and support POLLPRI at the
> same time.
>

Ok, yet more reason to go with my proposal, but then simplified to:

When streaming has not started return POLLIN or POLLOUT (or-ed with
POLLPRI if events are pending).


>>> Since events are new I think this is a safe change that will not affect
>>> existing applications.
>>>
>>> In the long term I propose that we put this in the feature-removal-schedule
>>> for v3.3 or so and stop poll from starting streaming altogether.
>>
>> Alternative suggestion:
>>
>> In scenario c + there are no events subscribed simply return POLL_IN /
>> POLL_OUT, iow signal the app, sure you're free to do a read / write to
>> start streaming, no need to wait with that :)
>>
>> Advantages
>> -we stop starting the stream from poll *now*
>> -for select we only set an fd in read or write fds, depending
>>    on the devices capabilities + file rights, rather then both
>
> Nobody ever sets both, why would you do that?
>

True, still the fact that POLLERR would result in the fd getting
set in both sets if the fd is specified in both also pleas against
using POLLERR

>> -for poll we don't return POLLERR, potentially breaking apps
>>    (I highly doubt broken apps will be fixed as quickly as you
>>     want, skype has yet to move to libv4l ...)
>
> I'm happy with that, but Mauro isn't.

I thought Mauro was against returning POLLERR when not streaming,
since this may break apps, if we return POLLIN or POLLOUT, the app
will call read() or write() and we can do the starting of the
stream there (and then wait or return -EAGAIN).

This way apps who don't like POLLERR won't break, AFAIK that was
Mauro's main point that POLLERR might break apps, but I could be
wrong there, Mauro ?

Regards,

Hans
