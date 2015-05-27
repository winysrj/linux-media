Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-205.synserver.de ([212.40.185.205]:1133 "EHLO
	smtp-out-205.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbbE0LWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 07:22:23 -0400
Message-ID: <5565A740.2050502@metafoo.de>
Date: Wed, 27 May 2015 13:15:12 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Dylan Reid <dgreid@chromium.org>, Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	Takashi Iwai <tiwai@suse.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Xing Zheng <zhengxing@rock-chips.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC 0/5] Add a gpio jack device
References: <1432332563-15447-1-git-send-email-dgreid@chromium.org> <55633CED.2090600@metafoo.de> <20150525171501.GC21577@sirena.org.uk> <5564BED6.3070604@metafoo.de> <20150526201426.GA21577@sirena.org.uk> <CAEUnVG4FT-U_iwB573VchtQqe9p8jnMYYSptFoYHmzSiwOiG7A@mail.gmail.com>
In-Reply-To: <CAEUnVG4FT-U_iwB573VchtQqe9p8jnMYYSptFoYHmzSiwOiG7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/2015 06:22 AM, Dylan Reid wrote:
> On Tue, May 26, 2015 at 1:14 PM, Mark Brown <broonie@kernel.org> wrote:
>> On Tue, May 26, 2015 at 08:43:34PM +0200, Lars-Peter Clausen wrote:
>>> On 05/25/2015 07:15 PM, Mark Brown wrote:
>>
>>>> I think it solves the 90% case well enough for simple-card (which is to
>>>> the main target user here) and the situation with jack detection is
>>>> already fragmented enough that we're not likely to make things
>>>> that much worse.  Though now I think about it just taking the gpio out
>>>> of the device name would help with binding reuse for other users.
>>
>>> Yea, but 90% of those 90% are already covered by the existing bindings. The
>>
>> I'm not sure what this thing with "yea" is (I've seen some other people
>> use it too) but the normal word is "yes"...
>>
>>> existing simple-card bindings and driver support GPIO based jack detection,
>>> albeit not as flexible as this. But we don't actually gain that much with
>>
>> Huh, so they do.  Ugh.
>>
>>>> Yes, this is the complete solution - and it's not an audio specific
>>>> thing either, there's a reasonable case to be made for saying that that
>>>> this should be resolved in extcon rather than in any one consumer
>>>> subsystem.
>>
>>> If the bindings are good it doesn't really matter which framework eventually
>>> picks them up, but in this case the bindings are awfully ASoC specific and
>>> leak a lot of the shortcomings of the current implementation.
>>
>> Could you expand on the abstraction problems you see please?  It looks
>> like a fairly direct mapping of GPIOs to a jack to me (like I say I
>> don't see having GPIOs directly on the jack object as a problem - having
>> to create a separate node to put the GPIOs in doesn't seem to solve
>> anything) and we're not likely to have enough GPIOs to make the usual
>> problems with lists of values too severe.
>>
>> The only things that concerned me particularly were the name (which I
>> did agree on once you mentioned it) and the use of a bitmask to describe
>> what's being reported but it's hard to think of anything much better
>> than that.
>
> Is just "audio-jack" too generic?  There are a lot of audio jacks that
> wouldn't be described by this binding, such as those reported by the
> 227e or 5650.  The original goal here was to describe a jack that has
> one or more gpios, each representing a particular type of device being
> attached.  This doesn't overlap with the binding for a jack that is
> handled by a headset detect chip.  Does this seem like the right goal,
> or is there a benefit to having an "audio-jack" binding that tries to
> cover all different types of jacks?

Ideally we'd have a binding which is generic enough to cover not only audio 
jacks but be a bit more generic. I think Laurent already has some thoughts 
on how such a binding should look like.

- Lars

