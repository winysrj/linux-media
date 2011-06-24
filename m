Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:49651 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752170Ab1FXTqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 15:46:01 -0400
Message-ID: <4E04E975.2060003@gmx.de>
Date: Fri, 24 Jun 2011 19:45:57 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Paul Mundt <lethal@linux-sh.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
References: <4DDAE63A.3070203@gmx.de>	<1308670579-15138-1-git-send-email-laurent.pinchart@ideasonboard.com>	<BANLkTim6wUaeZCya=9dMvU7iHj4W4E57Fg@mail.gmail.com>	<201106220031.57972.laurent.pinchart@ideasonboard.com>	<4E018189.3020305@gmx.de>	<BANLkTikMLE=F4OLTRhQ6LYR=d1x6xukJXA@mail.gmail.com>	<20110624061926.GA26504@linux-sh.org> <BANLkTi=RCx9Bifpw9BvqNAB0J+1ENkRK4A@mail.gmail.com>
In-Reply-To: <BANLkTi=RCx9Bifpw9BvqNAB0J+1ENkRK4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/24/2011 06:55 PM, Geert Uytterhoeven wrote:
> On Fri, Jun 24, 2011 at 08:19, Paul Mundt<lethal@linux-sh.org>  wrote:
>> On Thu, Jun 23, 2011 at 06:08:03PM +0200, Geert Uytterhoeven wrote:
>>> On Wed, Jun 22, 2011 at 07:45, Florian Tobias Schandinat
>>> <FlorianSchandinat@gmx.de>  wrote:
>>>> On 06/21/2011 10:31 PM, Laurent Pinchart wrote:
>>>>> On Tuesday 21 June 2011 22:49:14 Geert Uytterhoeven wrote:
>>>>>> As FOURCC values are always 4 ASCII characters (hence all 4 bytes must
>>>>>> be non-zero), I don't think there are any conflicts with existing values
>>>>>> of
>>>>>> nonstd. To make it even safer and easier to parse, you could set bit 31
>>>>>> of
>>>>>> nonstd as a FOURCC indicator.
>>>>>
>>>>> I would then create a union between nonstd and fourcc, and document nonstd
>>>>> as
>>>>> being used for the legacy API only. Most existing drivers use a couple of
>>>>> nonstd bits only. The driver that (ab)uses nonstd the most is pxafb and
>>>>> uses
>>>>> bits 22:0. Bits 31:24 are never used as far as I can tell, so nonstd&
>>>>> 0xff000000 != 0 could be used as a FOURCC mode test.
>>>>>
>>>>> This assumes that FOURCCs will never have their last character set to
>>>>> '\0'. Is
>>>>> that a safe assumption for the future ?
>>>>
>>>> Yes, I think. The information I found indicates that space should be used
>>>> for padding, so a \0 shouldn't exist.
>>>> I think using only the nonstd field and requiring applications to check the
>>>> capabilities would be possible, although not fool proof ;)
>>>
>>> So we can declare the 8 msb bits of nonstd reserved, and assume FOURCC if
>>> any of them is set.
>>>
>>> Nicely backwards compatible, as sane drivers should reject nonstd values they
>>> don't support (apps _will_ start filling in FOURCC values ignoring capabilities,
>>> won't they?).
>>>
>> That seems like a reasonable case, but if we're going to do that then
>> certainly the nonstd bit encoding needs to be documented and treated as a
>> hard ABI.
>>
>> I'm not so sure about the if any bit in the upper byte is set assume
>> FOURCC case though, there will presumably be other users in the future
>> that will want bits for themselves, too. What exactly was the issue with
>> having a FOURCC capability bit in the upper byte?
>
> That indeed gives less issues (as long as you don't stuff 8-bit ASCII
> in the MSB)
> and more bits for tradiditional nonstd users.

The only disadvantage I can see is that it requires adding this bit in the 
application and stripping it when interpreting it. But I think the 24 lower bits 
should be enough for driver specific behavior (as the current values really can 
only be interpreted per driver).

> BTW, after giving it some more thought: what does the FB_CAP_FOURCC buys
> us? It's not like all drivers will support whatever random FOURCC mode
> you give them,
> so you have to check whether it's supported by doing a set_var first.

Because any solution purely based on the nonstd field is insane. The abuse of 
that field is just too widespread. Drivers that use nonstd usually only check 
whether it is zero or nonzero and others will just interpret parts of nonstd and 
ignore the rest. They will happily accept FOURCC values in the nonstd and just 
doing the wrong thing. Even if we would fix those the problems applications will 
run into with older kernels will remain.


Greetings,

Florian Tobias Schandinat
