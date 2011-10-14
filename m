Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977Ab1JNODN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 10:03:13 -0400
Message-ID: <4E98411A.6040809@redhat.com>
Date: Fri, 14 Oct 2011 11:03:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org, Eddi De Pieri <eddi@depieri.net>
Subject: Re: PCTV 520e on Linux
References: <CAGa-wNOL_1ua0DQFRPFuLtHO0zTFhE0DaM+b6kujMEEL4dQbKg@mail.gmail.com> <CAGoCfizwYRpSsqobaHWJd5d0wq1N0KSXEQ1Un_ue01KuYGHaWA@mail.gmail.com> <4E970CA7.8020807@iki.fi> <CAGoCfiwSJ7EGXxAw7UgbFeECh+dg1EueXEC9iCHu7TaXia=-mQ@mail.gmail.com> <4E970F7A.5010304@iki.fi> <CAGoCfiyXiANjoB5bXgBpjwOAk8kpz8guxTGuGtVbtgc6+DNAag@mail.gmail.com> <4E976EF6.1030101@southpole.se> <CAGoCfixwp-iVFJysEG=UjN63-U_P4mdFWt+8hCwFW7fYeADvuw@mail.gmail.com> <4E9836E5.6040601@redhat.com> <CAGoCfizDdx=a=mR5TRXw_Dnj9cw2_1C9NuRH2LR2gXxEzyfW3w@mail.gmail.com>
In-Reply-To: <CAGoCfizDdx=a=mR5TRXw_Dnj9cw2_1C9NuRH2LR2gXxEzyfW3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-10-2011 10:28, Devin Heitmueller escreveu:
> On Fri, Oct 14, 2011 at 9:19 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>>> While the basic chips used are different, they are completely
>>> different hardware designs and likely have different GPIO
>>> configurations as well as IF specs.
>>
>> The IF settings for xc5000 with DRX-K are solved with this patch:
>>        http://patchwork.linuxtv.org/patch/7932/
>>
>> Basically, DRX-K will use whatever IF the tuner uses.
> 
> While I fundamentally disagree with this change, I'm not going to nack
> it.  That said, this wasn't the issue I was concerned with.  My
> suggestion was simply that you cannot assume that all devices that
> happen to have a particular demod and tuner combo will always use the
> same IF configuration.  The PCB layout can effect the optimal IF.
> 
> This is one of those things that (like many tuners in the LinuxTV
> tree) will probably work good enough to get a signal lock for whoever
> added the board profile, but will result in poor tuning performance
> (and a failure to work in less-than-ideal reception conditions).

This patch doesn't prevent customizing the IF. It will just avoid the
need of setting the IF on both xc5000 and drx-k. Basically, (some) DRX-K
based boards use different IF's depending on the bandwidth and delivery
system type. Instead of adding a complex logic that would allow such
kind of IF adjustments on both, drx-k will simply inquire the tuner about
what IF is currently used.

> 
> All that said, if somebody actually intends to hack on it, I can look
> up what the correct IF is for the 520e.
> 
> Devin
> 

