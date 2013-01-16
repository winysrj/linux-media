Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:46805 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab3APS0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 13:26:48 -0500
Received: by mail-oa0-f53.google.com with SMTP id j6so1755849oag.12
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2013 10:26:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130116152151.5461221c@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<50F522AD.8000109@iki.fi>
	<20130115111041.6b78a935@redhat.com>
	<50F56C63.7010503@iki.fi>
	<50F57519.5060402@iki.fi>
	<20130115151203.7221b1db@redhat.com>
	<50F5BE14.9000705@iki.fi>
	<CAHFNz9L9Lg-uttCVOk90UghM_WVbge44Ascxv4qrag3GvWetnQ@mail.gmail.com>
	<20130116115605.0fea6d03@redhat.com>
	<CAHFNz9KniYSbfoDHOw+=x3aA0eWqpiQd9LxgQEt3fjm1RwUc7g@mail.gmail.com>
	<20130116152151.5461221c@redhat.com>
Date: Wed, 16 Jan 2013 23:56:48 +0530
Message-ID: <CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 16, 2013 at 10:51 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:

>> If you have sufficient documentation, you can scale your demodulator statistics
>> to fit in that window area. I had done something similarly with a MB86A16
>> demodulator. IIRC, some effort was done on the STV0900 and STV0903
>> demodulator support as well to fit into that convention.
>>
>> All you need to do is scale the output of your demodulator to fit into
>> that window.
>
> To what scale? dB? linear? 0% to 100%?


It is in a db scale, scaled to the window, IIRC. In an application, you can
convert that window area, you can convert it into a linear scale as well.


>
> As there's no way to tell what's the used scale, if some scale is required,
> _all_ demods are required to be converted to that scale, otherwise, userspace
> can't rely on the scale.
>
> Are you capable of doing such change on _all demods? If not, please stop
> arguing that the existing API can be fixable.
>
> Besides that, changing the existing stats to whatever scale breaks
> userspace compatibility.
>
> BREAKING USERSPACE IS A BIG NO.
>

Consider this simple situation:
Your new API is using get_frontend and is polling the hardware, Now an
existing application is also doing monitoring of the statistics. So, now all
the decision box calculations are screwed.
Now, WHO BROKE USERSPACE ?

The same situation will happen for any new API that's going to be built.

Scaling the output values of a demodulator, which doesn't behave in
accordance to the specifications is NOT BREAKING USERSPACE.


>> What you are stating are just excuses, that do not exist.
>>
>> The same issue will exist, even with a new API and newer drivers not complying
>> to that API. I don't understand, why you fail to accept that fact.
>
> Newer drivers that don't implement an API right (being the a new one or an
> existing one) need to be fixed before being merged.
>
> It is as simple as that.


Okay, so what happens when a device that doesn't fit into your QoS
API, or that the
outputs of it are broken because of your API ?
I don't think it is that simple.


>> >> What is eventually wanted is a 0-100% scale, a self rotating counter etc scaled
>> >> to a maxima minima, rather than adding in complexities. This already exists,
>> >> all it needs to do is add some more devices to be scaled to that convention.
>> >> And more importantly, one is not going to get that real professional
>> >> measurements
>> >>  from these *home segment* devices. One of the chipset manufacturers once told
>> >> me that the PC segment never was interested in any real world performance
>> >> oriented devices, it is all about cost and hence it is stuck with such
>> >> low devices.
>> >
>> > The DVB API should be able to fit on both home and professional segment.
>>
>>
>> I don't see any professional hardware drivers being written for the
>> Linux DVB API.
>
> From the feedbacks we're getting during the media mini-summits,
> there are vendors that seem to be working on it. Anyway, what I'm saying
> is that the API should not be bound to any specific market segment.
>
> If drivers will be submitted upstream for professional hardware or not
> is a separate issue.


You are the one who had been touting all along on many linux-media threads,
on linux-kernel threads and what not; that API changes should not be made
for hardware that is not submitted upstream. So, I don't buy your argument
at all. Why did you argue with nvidia people that they shouldn't use dma-buf,
unless their driver is upstream. The same should hold good for what you are
talking now as well.



>> >
>> > Anyway, the existing API will be kept. Userspace may opt to use the legacy
>> > API if they're not interested on a scaled value.
>>
>>
>> That is simply stating, that whatever other people like it or not, you
>> will whack
>> nonsense in.
>
> No. I'm simply stating that removing the existing API is not an option.
>
> Also, plese stop with fallacy: it is not me saying that the existing API
> is broken. I'm just the poor guy that is trying to fix the already known
> issue. Several users, userspace developers and kernelspace developers
> complain about the existing stats API. Even _you_ submitted a proposal
> years ago for a new stats API to try solving those issues.


I submitted a proposal to distinguish between the various statistics modes
used by different devices. But eventually it was found that it wasn't possible
to fit *all* devices that do exist into any convention. That was why I didn't
pursue that proposal further.

>From what I learned from that, such information provided should be the
simplest possible thing, if we were to generalize on a large set of devices.
When being generalized with a large set of devices, however clever you are
or whatever technical might you have, you will still have issues with some
devices or the other. The end thoughts gathered from many people was that
such a generalization is futile, unless it is made for a very specific usecase.
A home user targeted API gets too complex and unusable in such an
 approach, making it harder for everyone altogether. As some other
people (I guess Klaus did) said, even an idiot should be able to make out
what it is, rather than trying to figure out what is what.

In any case, a true atomic operation cannot be made, for the same reasons
associated with consumer equipment based, or the so called Home segment
as described earlier. In such a case, it makes no difference if the existing
statistics related calls are made in a serialized way (driver also has to
serialize anyway). Other than that serialization, most demods have
restrictions that some operations it won't do simultaneously. So it doesn't
make any difference in real life. By having such a bloated API, you can just
more jeer that you are the author of that bloatware and nothing more than
that.


>
> It is a common sense that the existing API is broken. If my proposal
> requires adjustments, please comment on each specific patchset, instead
> of filling this thread of destructive and useless complains.


No, the concept of such a generalization is broken, as each new device will
be different and trying to make more generalization is a waste of developer
time and effort. The simplest approach would be to do a coarse approach,
which is not a perfect world, but it will do some good results for all the
people who use Linux-DVB. Still, repeating myself we are not dealing with
high end professional devices. If we have such devices, then it makes sense
to start such a discussion. Anyway professional devices will need a lot of
other API extensions, so your arguments on the need for professional
devices that do not exist are pointless and not agreeable to.

Manu
