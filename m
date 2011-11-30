Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33752 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1K3Tdq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 14:33:46 -0500
Received: by ggnr5 with SMTP id r5so975692ggn.19
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 11:33:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED66FBC.5090504@linuxtv.org>
References: <4ED65C46.20502@netup.ru>
	<CAGoCfiwShvPSgAPHKaxj=sMG-Fs9RdH0_3mLHYWuY96Z33AOag@mail.gmail.com>
	<4ED66FBC.5090504@linuxtv.org>
Date: Wed, 30 Nov 2011 14:33:46 -0500
Message-ID: <CAGoCfiw16bAtPHfrtsDDOBL4BeFnH+zMqcz9wBitGGSq_RZtJA@mail.gmail.com>
Subject: Re: LinuxTV ported to Windows
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Abylay Ospan <aospan@netup.ru>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 30, 2011 at 1:02 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
>> Am I the only one who thinks this is a legally ambigious grey area?
>> Seems like this could be a violation of the GPL as the driver code in
>> question links against a proprietary kernel.
>
> Devin, please! Are you implying that the windows kernel becomes a
> derived work of the driver, or that it's generally impossible to publish
> windows drivers under the terms of the GPL?

The simple answer is that "I don't know".  I'm not a lawyer (and as
far as I know, neither are you).  Nor have I researched the topic to
significant lengths.  That said though, whether it was the intention
of either copyright holder it's entirely possible that the two
software licenses are simply incompatible.  For example, while both
the Apache group and the FSF never really intended to prevent each
others' software from being linked against each other, the net effect
is still that you cannot redistribute such software together since the
Apache license is incompatible with the GPL.

>> I don't want to start a flame war, but I don't see how this is legal.
>> And you could definitely question whether it goes against the
>> intentions of the original authors to see their GPL driver code being
>> used in non-free operating systems.
>
> The GPL doesn't cover such intentions.

This isn't necessarily true.  Anybody who has written a library and
released it under the GPL instead of the LGPL has made a conscious
decision that the library is only to be used by software that is GPL
compatible.  By their actions they have inherently forbidden it's use
by non-free software.  You could certainly make the same argument
about a driver -- that they authors intent was to ensure that it only
be linked against other free software.

All this said, I don't really have a position one way or the other
(I'm not a copyright holder on the drivers in question).  But this
issue doesn't seem as obvious as you would make it sound.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
