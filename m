Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:57390 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZBWGlP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 01:41:15 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2350842wfa.4
        for <linux-media@vger.kernel.org>; Sun, 22 Feb 2009 22:41:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
References: <200902221115.01464.hverkuil@xs4all.nl>
Date: Mon, 23 Feb 2009 17:11:13 +1030
Message-ID: <ae5231870902222241i3ea4cd10j4dfa6d6a2fed14e5@mail.gmail.com>
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
From: Robert Golding <robert.golding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/2/22 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi all,
>
> There are lot's of discussions, but it can be hard sometimes to actually
> determine someone's opinion.
>
> So here is a quick poll, please reply either to the list or directly to me
> with your yes/no answer and (optional but welcome) a short explanation to
> your standpoint. It doesn't matter if you are a user or developer, I'd like
> to see your opinion regardless.
>
> Please DO NOT reply to the replies, I'll summarize the results in a week's
> time and then we can discuss it further.
>
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>

 ** Yes **


> _: No
>
> Optional question:
>
> Why: (from a non-coder, I have failed miserably to learn how to code in anything other than shell scripting)

I think the development of later drivers suffers because of the work
needed for backwards kernel compatibility.

In any case, I think most home users (like me) will usually be very up
to date with their kernels (we so like to tinker where we can) so the
drivers for older kernels would only be of any use to those using
enterprise kernels, and I think those should be addressed by the
people being paid!  Isn't that what they're being paid for?

>
> Thanks,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards,	Robert

..... Some people can tell what time it is by looking at the sun, but
I have never been able to make out the numbers.
---
Errata: Spelling mistakes are not intentional, however, I don't use
spell checkers because it's too easy to allow the spell checker to
make the decisions and use words that are out of context for that
being written, i.e. their/there, your/you're, threw/through and even
accept/except, not to mention foreign (I'm Australian) English
spelling, i.e. colour/color, socks/sox, etc,.
