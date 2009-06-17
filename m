Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3020 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZFQLTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 07:19:00 -0400
Message-ID: <15768.62.70.2.252.1245237542.squirrel@webmail.xs4all.nl>
Date: Wed, 17 Jun 2009 13:19:02 +0200 (CEST)
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Magnus Damm" <magnus.damm@gmail.com>,
	"Muralidharan Karicheri" <m-karicheri2@ti.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Robert Jarzmik" <robert.jarzmik@free.fr>,
	"Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>,
	"Darius Augulis" <augulis.darius@gmail.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Wed, 17 Jun 2009, Hans Verkuil wrote:
>
>> It is my strong opinion that while autonegotiation is easy to use, it is
>> not a wise choice to make. Filling in a single struct with the bus
>> settings to use for each board-subdev combination (usually there is only
>> one) is simple, straight-forward and unambiguous. And I really don't see
>> why that should take much time at all. And I consider it a very good
>> point
>> that the programmer is forced to think about this for a bit.
>
> Ok, my opinion is, that we should keep autonegotiation, but if you like,
> we can print a BIG-FAT-WARNING if both polarities are supported and no
> platform preference is set.

I'd rather see a message stating which bus settings were chosen. That way
if something fails in the future you can compare which bus settings were
chosen in the past with the new bus settings and see if something changed
there.

> I think, we've heard all opinions, unless someone would like to add
> something? Would it be fair to ask Mauro to make a decision? Or we can
> just count votes (which I would obviously prefer),

Obviously :-) Since the only non-soc driver that needs this right now is
tvp514x I'm pretty sure you'll get the most votes :-)

But this is something that should be decided on technical merits, and not
on what is easier for converting soc-camera. I'm not saying that is your
only or main reason for wanting to keep autonegotiation, but it no doubt
plays a role (perfectly understandable, BTW).

Just note that it is exactly my experiences with dm646x and with closely
working with the hardware team that made me realize the dangers of
autonegotiation. A year ago I would have agreed with you, but now I feel
very strongly that it is the wrong approach. Usually I would accept this
code, even if I thought it was not the optimal solution, in the interest
of finishing the conversion quickly. But I fear that if this goes in, then
it will be next to impossible to change in the future.

It simply boils down to this for me: I want to see unambiguous and
explicit bus settings in the code so the reader can safely assume that the
hardware was verified and/or certified for those settings. Even if you
just picked some settings because you didn't have access to the preferred
bus settings that the hardware manufacturer did his verification or
certification with, then that will still show which settings you used to
do your own testing. That's very important information to have in the
code.

Assuming that any autonegotiation code will always return the same result
is in my opinion wishful thinking. Look at the problems we have in
removing autoprobing from i2c: I'm pretty sure someone at the time also
thought that autoprobing would never cause a problem.

> but I'll accept Mauro's
> decision too.

That's fine by me as well.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

