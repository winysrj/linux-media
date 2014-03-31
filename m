Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3081 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaCaL3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 07:29:22 -0400
Message-ID: <53395144.2050100@xs4all.nl>
Date: Mon, 31 Mar 2014 13:28:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mikhail Domrachev <mihail.domrychev@comexp.ru>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?B?0JDQu9C10LrRgdC10Lkg0JjQs9C+0L3QuNC9?=
	<aleksey.igonin@comexp.ru>
Subject: Re: [PATCH] saa7134: automatic norm detection
References: <1395661349.2916.3.camel@localhost.localdomain>	<533534D7.6010301@xs4all.nl>	<1396000280.3518.24.camel@localhost.localdomain>	<53354925.6070603@xs4all.nl> <CAGoCfiwN6Z9Whof-ZfWPxPfu+HztHTQewkXLicJkT7si_Jg9uw@mail.gmail.com>
In-Reply-To: <CAGoCfiwN6Z9Whof-ZfWPxPfu+HztHTQewkXLicJkT7si_Jg9uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

On 03/28/2014 02:16 PM, Devin Heitmueller wrote:
>>> Let me explain why I created a new thread.
>>> My company is engaged in the monitoring of TV air. All TV channels are
>>> recorded 24/7 for further analysis. But some local TV channels change
>>> the standard over time (SECAM->PAL, PAL->SECAM). So the recording
>>> software must be notified about these changes to set a new standard and
>>> record the picture but not the noise.
>>
>> OK, fair enough.
> 
> This is a perfectly reasonable use case, but since we don't do this
> with any other devices we probably need to decide whether this really
> should be the responsibility of the kernel at all, or whether it
> really should be done in userland.  Doing it in userland would be
> trivial (even just a script which periodically runs QUERYSTD in a loop
> would accomplish the same thing), and the extra complexity of having a
> thread combined with the inconsistent behavior with all the other
> drivers might make it more worthwhile to do it in userland.
> 
> If it were hooked to an interrupt line on the video decoder, I could
> certainly see doing it in kernel, but for something like this the loop
> that checks the standard could just as easily be done in userland.

I agree with Devin here. None of the existing SDTV receivers do this, and
nobody ever used interrupts to check for this. Such interrupts are rarely
available, and if they exists they are never hooked up. This is quite
different for HDTV receivers where such an event is pretty much required
(even though it still isn't officially added to the kernel, but that's
another story).

Is there any reason why your application cannot periodically call QUERYSTD?

The problem you have is not specific to the saa7134, so moving it to the
application is actually a more generic solution since it will work with
any driver that implements querystd.

Adding querystd support to saa7134 in the first place is a good idea
regardless, and I'll test your patch today or Friday.

Regards,

	Hans
