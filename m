Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2879 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbZCPNEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 09:04:33 -0400
Message-ID: <45192.62.70.2.252.1237208659.squirrel@webmail.xs4all.nl>
Date: Mon, 16 Mar 2009 14:04:19 +0100 (CET)
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Trent Piepho" <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> > Based on this principle, IMO, the probing function should, by default,
>> > probe
>> > for tvaudio, if it doesn't find another audio device. You may
>> eventually
>> > ask
>> > for people to report, to warn us that the board entry is broken, but
>> we
>> > shouln't intentionally break a device that we're almost sure that
>> requires
>> > tvaudio or tda7432.
>>
>> OK. In other words it would be better to probe for:
>>
>> 1) msp3400
>> 2) msp3400_alt
>> 3) tda7432
>> 4) tvaudio
>>
>> and return as soon as we find a chip. So tvaudio is probed
>> unconditionally, effectively ignoring the needs_tvaudio flag and only
>> honoring the tvaudio module option (although I'm not sure whether that
>> is
>> still needed in that case).
>
> IMO, we should handle the needs_tvaudio with a different behaviour: using
> such kind of
> glue only when we're sure about the tv audio chips used for a certain
> board. If
> unsure, use the auto probing. Otherwise, we'll probe just that know
> chip(s) range.

I have to admit that I've no idea what you mean. My patch replicates the
original behavior of 'modprobe tvaudio' where all i2c addresses are probed
that tvaudio supports (from the normal_i2c array in tvaudio.c). We cannot
do a subset of this since it was never administrated which chip in
particular is on the board, just that it is one of the chips supported by
tvaudio.

If you want to be able to select particular devices, then you need to
administrate that in the card definitions. That's out of scope of this
patch IMHO.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

