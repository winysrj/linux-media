Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:46747 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718AbZKRJcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 04:32:47 -0500
Received: by fxm21 with SMTP id 21so929704fxm.21
        for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 01:32:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B032973.60002@infradead.org>
References: <20091022211330.6e84c6e7@hyperion.delvare>
	 <20091023051025.597c05f4@caramujo.chehab.org>
	 <1a297b360910221329o4b832f4ewaee08872120bfea0@mail.gmail.com>
	 <4B02FDA4.5030508@infradead.org>
	 <829197380911171155j36ba858ejfca9e4c36689ab62@mail.gmail.com>
	 <4B032973.60002@infradead.org>
Date: Wed, 18 Nov 2009 04:32:50 -0500
Message-ID: <829197380911180132j619a5a02gead3f3f91e68f524@mail.gmail.com>
Subject: Re: Details about DVB frontend API
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 17, 2009 at 5:53 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> We shouldn't write API's thinking on some specific use case or aplication.
> If there's a problem with zap, the fix should be there, not at the kernel.

Your response suggests I must have poorly described the problem.  Zap
is just one example where having an "inconsistent" view of the various
performance counters is easily visible.  If you're trying to write
something like an application to control antenna orientation, the fact
that you cannot ask for a single view of all counters can be a real
problem.  Having to make separate ioctl calls for each field can cause
real problems here.

I disagree strongly with your assertion that we should not considering
specific use cases when writing an API.  That's *EXACTLY* what you
want to do - when designing an API, you should be asking yourself what
use cases is it actually going to be used for, and strive to build an
API that accommodates all the use cases.  In this case, Manu's
approach provides the ability to get a single consistent view of all
the counters (for those drivers which can support it), which solves a
specific use case that cannot be accomplished with the existing API.
Building abstract APIs without considering all use cases is how we end
up with APIs that nobody uses because they don't actually work in the
real world.

The fact that the existing SNR and strength counters never had their
format explicitly defined is a really good example of how nobody must
have considered how applications would be expected to actually use the
API and represent the information to users in a useful manner.

On the other hand, this issue has been beaten to death so badly and
the existing API has been broken/useless for so long that I have
lowered my expectations to the point where I would accept just about
*any* proposal that actually provides a uniform representation of SNR
across drivers.

(/rant mode off)

> Also, the above mentioned problem can happen even if there's just one API
> call from userspace to kernel or if the driver needs to do separate,
> serialized calls to firmware (or a serialized calculus) to get the
> three measures.

True, the accuracy in which a given driver can provide accurate data
is tied to the quality of the hardware implementation.  However, for
well engineered hardware, Manu's proposed API affords the ability to
accurately report a consistent view of the information.  The existing
implementation restricts all drivers to working as well as the
worst-case hardware implementation.

>> For what it's worth, we have solved this problem in hwmon driver the
>> following way: we cache related values (read from the same register or
>> set of registers) for ~1 second. When user-space requests the
>> information, if the cache is fresh it is used, otherwise the cache is
>> first refreshed. That way we ensure that data returned to nearby
>> user-space calls are taken from the same original register value. One
>> advantage is that we thus did not have to map the API to the hardware
>> register constraints and thus have the guarantee that all hardware
>> designs fit.
>>
>> I don't know if a similar logic would help for DVB.
>
> This could be an alternative, if implemented at the right way. However,
> I suspect that it would be better to do such things at libdvb.
>
> For example, caching measures for 1 second may be too much, if userspace is
> doing a scan, while, when streaming, this timeout can be fine.

Jean's caching approach for hwmon is fine for something like the
chassis temperature, which doesn't change that rapidly.  However, it's
probably not appropriate for things like SNR and strength counters,
where near real-time feedback can be useful in things like controlling
a rotor.

One more point worth noting - the approach of returning all the
counters in one ioctl can actually be cheaper in terms of the number
of register read operations.  I've seen a number of drivers where we
hit the same register three or four times, since all of various fields
are based on the same register.  Having a single call actually allows
all the duplicate register reads to be eliminated in those cases, the
driver reads the register once and then populates all the fields in
one shot based on the result.

I was actually against Manu's proposal the last time it was put out
there, as I felt just normalizing the existing API would be *good
enough* for the vast majority of applications.  However, if we have
decided to give up on the existing API entirely and write a whole new
API, we might as well do it right this time and build an API that
satisfies all the people who plan to make use of it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
