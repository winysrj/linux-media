Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2603 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbZBPIeA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 03:34:00 -0500
Message-ID: <59373.62.70.2.252.1234773218.squirrel@webmail.xs4all.nl>
Date: Mon, 16 Feb 2009 09:33:38 +0100 (CET)
Subject: Re: Adding a control for Sensor Orientation
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans de Goede" <hdegoede@redhat.com>
Cc: kilgota@banach.math.auburn.edu,
	"Trent Piepho" <xyzzy@speakeasy.org>,
	"Adam Baker" <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	"Olivier Lorin" <o.lorin@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
>
> kilgota@banach.math.auburn.edu wrote:
>>
>
> <huge snip>
>
>> Therefore,
>>
>> 1. Everyone seems to agree that the kernel module itself is not going to
>> do things like rotate or flip data even if a given supported device
>> always needs that done.
>>
>> However, this decision has a consequence:
>>
>> 2. Therefore, the module must send the information about what is needed
>> out of the module, to whatever place is going to deal with it.
>> Information which is known to the module but unknown anywere else must
>> be transmitted somehow.
>>
>> Now there is a further consequence:
>>
>> 3. In view of (1) and (2) there has to be a way agreed upon for the
>> module to pass the relevant information onward.
>>
>> It is precisely on item 3 that we are stuck right now. There is an
>> immediate need, not a theoretical need but an immediate need. However,
>> there is no agreed-upon method or convention for communication.
>>
>
> We are no longer stuck here, the general agreement is adding 2 new buffer
> flags, one to indicate the driver knows the data in the buffer is
> vflipped and one for hflip. Then we can handle v-flipped, h-flipped and
> 180
> degrees cameras
>
> This is agreed up on, Trent is arguing we may need more flags in the
> future,
> but that is something for the future, all we need know is these 2 flags
> and
> Hans Verkuil who AFAIK was the only one objecting to doing this with
> buffer
> flags has agreed this is the best solution.

Well, I just posted an alternative solution this morning (Hans probably
hadn't read it yet) which I want to see discussed first. I think it is a
better solution than this. Basically combining the best of two worlds
IMHO.

We are talking about a core change, so some careful thought should go into
this.

> So Adam, kilgota, please ignore the rest of this thread and move forward
> with
> the driver, just add the necessary buffer flags to videodev2.h as part of
> your
> patch (It is usually to submit new API stuff with the same patch which
> introduces the first users of this API.

Don't ignore it yet :-)

Regards,

       Hans

> I welcome libv4l patches to use these flags.
>
> Regards,
>
> Hans
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

