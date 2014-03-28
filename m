Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4635 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaC1KFp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 06:05:45 -0400
Message-ID: <53354925.6070603@xs4all.nl>
Date: Fri, 28 Mar 2014 11:04:21 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mikhail Domrachev <mihail.domrychev@comexp.ru>
CC: linux-media@vger.kernel.org,
	=?UTF-8?B?0JDQu9C10LrRgdC10Lkg0JjQs9C+0L0=?= =?UTF-8?B?0LjQvQ==?=
	<aleksey.igonin@comexp.ru>
Subject: Re: [PATCH] saa7134: automatic norm detection
References: <1395661349.2916.3.camel@localhost.localdomain>	 <533534D7.6010301@xs4all.nl> <1396000280.3518.24.camel@localhost.localdomain>
In-Reply-To: <1396000280.3518.24.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/28/2014 10:51 AM, Mikhail Domrachev wrote:
> Hi Hans,
> 
> Thank you for comments, I will rework the patch and document the new
> event type.
> 
> Let me explain why I created a new thread.
> My company is engaged in the monitoring of TV air. All TV channels are
> recorded 24/7 for further analysis. But some local TV channels change
> the standard over time (SECAM->PAL, PAL->SECAM). So the recording
> software must be notified about these changes to set a new standard and
> record the picture but not the noise.

OK, fair enough.

Once I receive the reworked version I'll review again. Expect that you probably
will need to make at least one other revision after that as I did not do an
in-depth review yet.

It might also be a good idea to look at this:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/saa7134

The patches in that tree convert the saa7134 driver to the videobuf2 framework.
This is a huge change that should make the driver a lot more stable and more
compliant to the v4l2 specification.

If your company is using this driver, then I would recommend that you test this.
A pull request was made for this for kernel 3.16 and I tested it quite extensively,
but if you can test it as well then that would be very useful.

Regards,

	Hans

> 
> Regards,
> Mikhail
> 
> On Fri, 2014-03-28 at 09:37 +0100, Hans Verkuil wrote:
>> Hi Mikhail,
>>
>> Thank you for the patch. However, it does need some work before I can accept it.
>>
>> First of all, run your patch through scripts/checkpatch.pl to ensure it complies
>> to the kernel coding style.
>>
>> Secondly, split up this single patch in smaller ones: in particular the addition
>> of the new event type needs to be in a patch of its own.
>>
>> Thirdly, you need to document the new event type in the DocBook documentation as
>> well. API additions are only accepted if the documentation is updated at the same
>> time.
>>
>> I also wonder why you need a thread to watch for signal changes. It's not wrong,
>> but in practice a TV input signal rarely if ever changes format. It can be different
>> between different countries or when testing with a signal generator, but the normal
>> case is that you are just interested in the current standard, and not how it might
>> change over time. That would simplify the code a lot. This is what other drivers
>> that implement querystd do.
>>
>> Regards,
>>
>> 	Hans

