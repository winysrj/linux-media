Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:57916 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab1K3T6o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 14:58:44 -0500
Message-ID: <4ED68AF0.8000903@linuxtv.org>
Date: Wed, 30 Nov 2011 20:58:40 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Abylay Ospan <aospan@netup.ru>, linux-media@vger.kernel.org
Subject: Re: LinuxTV ported to Windows
References: <4ED65C46.20502@netup.ru> <CAGoCfiwShvPSgAPHKaxj=sMG-Fs9RdH0_3mLHYWuY96Z33AOag@mail.gmail.com> <4ED66FBC.5090504@linuxtv.org> <CAGoCfiw16bAtPHfrtsDDOBL4BeFnH+zMqcz9wBitGGSq_RZtJA@mail.gmail.com>
In-Reply-To: <CAGoCfiw16bAtPHfrtsDDOBL4BeFnH+zMqcz9wBitGGSq_RZtJA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30.11.2011 20:33, Devin Heitmueller wrote:
> On Wed, Nov 30, 2011 at 1:02 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
>>> Am I the only one who thinks this is a legally ambigious grey area?
>>> Seems like this could be a violation of the GPL as the driver code in
>>> question links against a proprietary kernel.
>>
>> Devin, please! Are you implying that the windows kernel becomes a
>> derived work of the driver, or that it's generally impossible to publish
>> windows drivers under the terms of the GPL?
> 
> The simple answer is that "I don't know".  I'm not a lawyer (and as
> far as I know, neither are you).  Nor have I researched the topic to
> significant lengths.  That said though, whether it was the intention
> of either copyright holder it's entirely possible that the two
> software licenses are simply incompatible.  For example, while both
> the Apache group and the FSF never really intended to prevent each
> others' software from being linked against each other, the net effect
> is still that you cannot redistribute such software together since the
> Apache license is incompatible with the GPL.

Neither is Abylay distributing Windows together with this driver, nor is
this driver a library Windows links against, i.e. Windows is able to run
with this driver removed.

>>> I don't want to start a flame war, but I don't see how this is legal.
>>> And you could definitely question whether it goes against the
>>> intentions of the original authors to see their GPL driver code being
>>> used in non-free operating systems.
>>
>> The GPL doesn't cover such intentions.
> 
> This isn't necessarily true.  Anybody who has written a library and
> released it under the GPL instead of the LGPL has made a conscious
> decision that the library is only to be used by software that is GPL
> compatible.  By their actions they have inherently forbidden it's use
> by non-free software.  You could certainly make the same argument
> about a driver -- that they authors intent was to ensure that it only
> be linked against other free software.

That's something completely different than "being used in non-free
operating systems" and not necessarily comparable to a driver, which
implements a well-defined interface.

The point I'm trying to make: Someone made a presumably nice open source
port to a new platform and the first thing you're doing is to play the
GPL-has-been-violated-card, even though you're admitting that you don't
know whether any right is being violated or not. Please don't do that.
It's not very encouraging to someone who just announced free software.

Regards,
Andreas
