Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:38998 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab1LAWbv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 17:31:51 -0500
Message-ID: <4ED8004F.7060403@linuxtv.org>
Date: Thu, 01 Dec 2011 23:31:43 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Abylay Ospan <aospan@netup.ru>, linux-media@vger.kernel.org
Subject: Re: LinuxTV ported to Windows
References: <4ED65C46.20502@netup.ru> <CAGoCfiw16bAtPHfrtsDDOBL4BeFnH+zMqcz9wBitGGSq_RZtJA@mail.gmail.com> <4ED68AF0.8000903@linuxtv.org> <201112012042.57343.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201112012042.57343.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 01.12.2011 20:42, Laurent Pinchart wrote:
> Hi Andreas,
> 
> On Wednesday 30 November 2011 20:58:40 Andreas Oberritter wrote:
>> On 30.11.2011 20:33, Devin Heitmueller wrote:
>>> On Wed, Nov 30, 2011 at 1:02 PM, Andreas Oberritter wrote:
>>>>> Am I the only one who thinks this is a legally ambigious grey area?
>>>>> Seems like this could be a violation of the GPL as the driver code in
>>>>> question links against a proprietary kernel.
>>>>
>>>> Devin, please! Are you implying that the windows kernel becomes a
>>>> derived work of the driver, or that it's generally impossible to publish
>>>> windows drivers under the terms of the GPL?
>>>
>>> The simple answer is that "I don't know".  I'm not a lawyer (and as
>>> far as I know, neither are you).  Nor have I researched the topic to
>>> significant lengths.  That said though, whether it was the intention
>>> of either copyright holder it's entirely possible that the two
>>> software licenses are simply incompatible.  For example, while both
>>> the Apache group and the FSF never really intended to prevent each
>>> others' software from being linked against each other, the net effect
>>> is still that you cannot redistribute such software together since the
>>> Apache license is incompatible with the GPL.
>>
>> Neither is Abylay distributing Windows together with this driver, nor is
>> this driver a library Windows links against, i.e. Windows is able to run
>> with this driver removed.
> 
> But the driver can't run with Windows.

I guess you meant "can't run without Windows". It's probably safe to
assume that, but it's not relevant, unless you're questioning whether
Windows' licensing terms allow running free software or not.

> The important point to remember when discussing licenses is that the GPL 
> license mostly affects distribution of binaries. Distribution of the source 
> code isn't an issue in this case, as the code is clearly being redistributed 
> under the terms of the license. Binaries, however, are a different story.
> 
> The resulting Windows driver binary is linked to GPL-incompatible code (namely 
> the Windows kernel). I'm not, as most people here, a lawyer, but this can of 
> situation always triggers an alarm in my brain. It might not be allowed by the 
> GPL license, hence the comment about a *possible* GPL violation.

Do you also think it would violate the GPL to distribute binaries of
GPL'ed programs linked to android's libc or msvcrt, for example, because
they both have GPL incompatible licenses?

> The binary might also violate Microsoft terms of use. I haven't studied the 
> Windows DDK license, but I wouldn't be surprised if it forbade linking GPL 
> code to the Windows kernel one way or the other. I won't be personally upset 
> if someone violates the Windows DDK license, but it's worth a warning as well.

I'm used to SDK licenses that don't affect the license of the code
developed using it. Furthermore, only Abylay knows which rights his copy
of the DDK grants, so any public discussion about it is moot.

>>>>> I don't want to start a flame war, but I don't see how this is legal.
>>>>> And you could definitely question whether it goes against the
>>>>> intentions of the original authors to see their GPL driver code being
>>>>> used in non-free operating systems.
>>>>
>>>> The GPL doesn't cover such intentions.
>>>
>>> This isn't necessarily true.  Anybody who has written a library and
>>> released it under the GPL instead of the LGPL has made a conscious
>>> decision that the library is only to be used by software that is GPL
>>> compatible.  By their actions they have inherently forbidden it's use
>>> by non-free software.  You could certainly make the same argument
>>> about a driver -- that they authors intent was to ensure that it only
>>> be linked against other free software.
>>
>> That's something completely different than "being used in non-free
>> operating systems" and not necessarily comparable to a driver, which
>> implements a well-defined interface.
> 
> It doesn't matter much if the interface is well-defined or not. What matters 
> is the GPL license on one side, and the related Windows licenses on the other 
> side. Distributing a Windows binary driver made of GPL code needs to comply 
> with licenses on both sides.
> 
> Whether the original author intent was to forbid usage of the code in a 
> proprietary operating system isn't really relevant from a legal point of view. 
> Sure, it would be nice to take the original author opinion into consideration, 
> but there's at best (or at worst, depending on the point of view) only a moral 
> need to do so. When Google uses my kernel code in Android, with a proprietary 
> (yet open) userspace that in my opinion hurts Linux, I'm not the happiest 
> person in the world, but I live with it without complaining (OK, that's not 
> completely true, I complain about Android creating a lot of new kernel APIs 
> without any cooperation with the Linux community, but that's another story).

I'd go a step further and say that there's no moral need at all to do
anything not covered by the license. One cannot publish code under a
free software license and later expect people not to use that license
grant, because its use wouldn't make one of many original authors feel
good. Many people writing on this mailing list should think about that.

>> The point I'm trying to make: Someone made a presumably nice open source
>> port to a new platform and the first thing you're doing is to play the
>> GPL-has-been-violated-card, even though you're admitting that you don't
>> know whether any right is being violated or not. Please don't do that.
>> It's not very encouraging to someone who just announced free software.
> 
> Thanks for pointing this out. I would have reacted similarly to Devin, not to 
> discourage Abylay from working on this interesting project, but to warn him 
> that there might be legal issues (I think we would all prefer early 
> notifications from the community than late notifications from unfriendly 
> lawyers :-)).

I don't think it's applicable to this case, but a sentence like "I don't
see how this is legal" by Devin probably has potential to trigger more
unfriendly lawyers than a publication of source code together with
precompiled binaries. I mean, seriously, who's going to sue someone for
doing that - even if a license was violated - and what could be gained?
Last time I checked, the GPL was about freedom of source code and the
possibility to recreate (modified) binaries and not about which OS the
software may be used on.

Second, Abylay is cleary writing from a company email address, so
everybody could at least assume that a corporate law person acked the
publication. And if there was serious doubt about it, a friendly
copyright holder could have contacted him directly to resolve any issues
without needlessly involving the public.

Third, and this one upsets me most: Although we all seem to agree that
none of us knows much about international copyright laws and related
stuff in general, whenever LinuxTV code gets reused creatively, I hear
the same people calling for the GPL police. And those people seem to
think that their countries' law applies to every case in the world. And
if those people are unsure about something, their policy always defaults
to forbidden instead of allowed, as if they needed to protect "their"
GPL at any cost. But it's not possible to defend the GPL by mail. This
has to happen in courts. Sending seemingly random GPL-violation alert
emails to mailing lists just discredits the community and creates fear
among possible contributors.

> You understanding this as an attack shows that we need to be 
> more careful in the way we word our messages on license-related issues.

I'd prefer using no words at all and keep discussions at a technical level.

Regards,
Andreas
