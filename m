Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64032 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab2HNPH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:07:58 -0400
Received: by wibhr14 with SMTP id hr14so502977wib.1
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 08:07:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50293B36.4060109@redhat.com>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com>
	<201208131604.28675.hverkuil@xs4all.nl>
	<CALzAhNVFSH0+y9XU39EzzBhH4rAAC2RStZKA3hzTfexzCKBHRQ@mail.gmail.com>
	<201208131749.27701.hverkuil@xs4all.nl>
	<50293B36.4060109@redhat.com>
Date: Tue, 14 Aug 2012 11:07:55 -0400
Message-ID: <CALzAhNV2A_CWp=dg0S-B2Ts50u+SjuuE-o48OzuaynNw86v-Dw@mail.gmail.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
From: Steven Toth <stoth@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 13, 2012 at 1:36 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 13-08-2012 12:49, Hans Verkuil escreveu:
>> On Mon August 13 2012 16:46:45 Steven Toth wrote:
>>> Hans,
>>>
>>> Thanks for your feedback.
>>>
>>> Oh dear. I don't think you're going to like my response, but I think
>>> we know each other well enough to realize that neither of us are
>>> trying to antagonize or upset either other. We're simply stating our
>>> positions. Please read on.
>>
>> I didn't think you'd like my response either :-)
>
> You probably won't like my answer too, yet I'm also simply
> stating my positions.

Hans / Mauro, thank you for your comments and review, very good
feedback and technical discussion. Truly, thank you. :)

While I don't necessarily agree with Mauro that adoption of subdev is
"MANDATORY" (in the larger sense of the kernel driver development -
and common practices throughout the entire source base), I do hear and
value your comments and concerns from a peer review perspective.

1) A handful of simple improvements have been suggested, Eg.
ioctl_unlocked, double-checking v4l2-compliance, try_fmt, /proc
removal, firmware loading etc

Ack. I have no objections. Items like this are fairly trivial, easy to
address, I can absorb this and provide new patches quickly and easily.
I'll go back over the detailed comments this weekend and prepare
additional patches (and retest).

2) ... and some larger discussion items have been raised, Eg.
Absorbing more of the V4L2 kernel infrastructure into the vc8x0 driver
vs a fairly self-contained driver with very limited opportunities for
future breakage.

Are you really willing to say that all drivers, with unique and new
pieces of silicon, need to be split out into independent modules,
adopting a subdev type interfaces or mainline merge is refused? It's
not that I'm asking you to merge duplicate functionality, duplicate
driver code, replicating functionality for new hardware or for an
existing modules (tuner/demod/whatever). (Like has already happened in
the past - 18271 for example).

If the answer is Yes, then my second questions is:

Assuming the comments / issues mentioned in #1 are addressed, are you
really willing to stand up in front of the world-wide Kernel
development community and justify why a driver that passes user-facing
v4l2-compliance tests, is fairly clean, passes 99% of the reasonable
checkpatch rules, is fully operational, cannot be merged? Really? Is
this truly an illegal or inappropriate driver implementation that
would prohibit mainline merge?

The ViewCast 820 is a (circa) $1800 video capture card. It's not the
kind of hardware that everyone has laying around for regression
testing purposes. If I 1) split this up and people begin to absorb
ad7441 functionality into other designs, and start patching it and 2)
adopt the subdev framework for that matter... then nobody is able to
regression test the impact to the 820. That puts an incredible amount
of burden on me. I'm attempting to mitigate all of this risk, but also
provide a GPL driver so everyone can benefit - without creating a
future maintenance / regression problem, by relying on subsystems the
driver simply doesn't need.

As always, I do welcome and appreciate your comments and thoughts, no
flames from me. I do find the 'MANDATORY' comments worthy of
discussion, or perhaps I've miss-understood something.

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
