Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f42.google.com ([209.85.212.42]:41529 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaBGW3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 17:29:38 -0500
MIME-Version: 1.0
In-Reply-To: <20140207145053.GF25314@e106331-lin.cambridge.arm.com>
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
	<1389967140-20704-7-git-send-email-james.hogan@imgtec.com>
	<CAL_Jsq+wk6_9Da5Xj3Ys-MZYPTpu6V3pAEpGFv44148BodmmrQ@mail.gmail.com>
	<52F39F30.70104@imgtec.com>
	<CAL_JsqLL6MbwajCUAm+NJk=ofL5OHq8b0zwO3LFb-TKY6UtVMQ@mail.gmail.com>
	<20140207145053.GF25314@e106331-lin.cambridge.arm.com>
Date: Fri, 7 Feb 2014 16:29:36 -0600
Message-ID: <CAL_JsqLRt71vhvjBofYC9WzgA+jco2q5PY=+7bnbkihWDcG0pQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/15] dt: binding: add binding for ImgTec IR block
From: Rob Herring <robherring2@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: James Hogan <james.hogan@imgtec.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Rob Landley <rob@landley.net>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 7, 2014 at 8:50 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi Rob,
>
> On Fri, Feb 07, 2014 at 02:33:27PM +0000, Rob Herring wrote:
>> On Thu, Feb 6, 2014 at 8:41 AM, James Hogan <james.hogan@imgtec.com> wrote:
>> > Hi Rob,
>> >
>> > On 06/02/14 14:33, Rob Herring wrote:
>> >> On Fri, Jan 17, 2014 at 7:58 AM, James Hogan <james.hogan@imgtec.com> wrote:
>> >>> +Required properties:
>> >>> +- compatible:          Should be "img,ir1"
>> >>
>> >> Kind of short for a name. I don't have anything much better, but how
>> >> about img,ir-rev1.
>> >
>> > Okay, that sounds reasonable.
>> >
>> >>> +Optional properties:
>> >>> +- clocks:              List of clock specifiers as described in standard
>> >>> +                       clock bindings.
>> >>> +- clock-names:         List of clock names corresponding to the clocks
>> >>> +                       specified in the clocks property.
>> >>> +                       Accepted clock names are:
>> >>> +                       "core": Core clock (defaults to 32.768KHz if omitted).
>> >>> +                       "sys":  System side (fast) clock.
>> >>> +                       "mod":  Power modulation clock.
>> >>
>> >> You need to define the order of clocks including how they are
>> >> interpreted with different number of clocks (not relying on the name).
>> >
>> > Would it be sufficient to specify that "clock-names" is required if
>> > "clocks" is provided (i.e. unnamed clocks aren't used), or is there some
>> > other reason that clock-names shouldn't be relied upon?
>>
>> irq-names, reg-names, clock-names, etc. are considered optional to
>> their associated property and the order is supposed to be defined.
>> clock-names is a bit different in that clk_get needs a name, so it
>> effectively is required by Linux when there is more than 1 clock.
>> Really, we should fix Linux.
>
> If they're optional then you can't handle optional entries (i.e.  when
> nothing's wired to an input), and this is counter to the style I've been
> recommending to people (defining clocks in terms of clock-names).
>
> I really don't see the point in any *-names property if they don't
> define the list and allow for optional / reordered lists. Why does the
> order have to be fixed rather than using the -names properties? It's
> already a de-facto standard.

Maybe for clocks, but I don't think we should treat clocks differently
from other properties. We've already got enough variation in binding
styles, I'd like to be consistent across interrupts, reg, clocks, etc.

>> Regardless, my other point is still valid. A given h/w block has a
>> fixed number of clocks. You may have them all connected to the same
>> source in some cases, but that does not change the number of inputs.
>> Defining what are the valid combinations needs to be done. Seems like
>> this could be:
>>
>> <none> - default to 32KHz
>> <core> - only a "baud" clock
>> <core>, <sys>, <mod> - all clocks
>
> For more complex IP blocks you might have more inputs than you actually
> have clocks wired to.
>
> How do you handle an unwired input in the middle of the list, or a new
> revision of the IP block that got rid of the first clock input from the
> list but is otherwise compatible?

fixed-clock with freq of 0 for unwired (really wired to gnd) inputs?

With a new compatible string if it is a new block.

Rob
