Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2763 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZBWOKB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 09:10:01 -0500
Message-ID: <48380.62.70.2.252.1235398197.squirrel@webmail.xs4all.nl>
Date: Mon, 23 Feb 2009 15:09:57 +0100 (CET)
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Trent Piepho" <xyzzy@speakeasy.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Trent,

> On Mon, 23 Feb 2009, Jean Delvare wrote:
>> > There are lot's of discussions, but it can be hard sometimes to
>> actually
>> > determine someone's opinion.
>> >
>> > So here is a quick poll, please reply either to the list or directly
>> to me
>> > with your yes/no answer and (optional but welcome) a short explanation
>> to
>> > your standpoint. It doesn't matter if you are a user or developer, I'd
>> like
>> > to see your opinion regardless.
>> >
>> > Please DO NOT reply to the replies, I'll summarize the results in a
>> week's
>> > time and then we can discuss it further.
>> >
>> > Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>
> Does this mean keep our current system and move the backward compatibility
> point to 2.6.22?
>
> Or not have any backward compatibilty at all?

It was a bit imprecise, perhaps. With 'drop support' I mean in practice
that we:

1) do a one time effort to make everything compile from 2.6.16 onwards
(there are several compile issues right now with older kernels).

2) when it's OK, make a copy of the master repository, call it v4l-dvb-old
or whatever, and people who are still on old kernels can use that to at
least have the possibility to get something newer. We might even do the
occasional update if some important bug is found.

3) strip our master repository from any compatibility code needed to
support the pre-2.6.22 kernels and continue development based on that
code.

We still need to support kernels from 2.6.22 onwards. Although I think the
minimum supported kernel is something that needs a regular sanity check,
right now there are no technical reasons that I am aware of to go to
something newer than 2.6.22.

Whether we keep our current system or not is a separate discussion:
whatever development system you choose there will be work involved in
keeping up the backwards compatibility.

Hope this explains it,

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

