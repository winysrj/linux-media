Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.pctvsystems.com ([213.252.189.134]:15544 "EHLO
	mx1.pctvsystems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1JNOG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 10:06:29 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: AW: PCTV 520e on Linux
Date: Fri, 14 Oct 2011 16:01:08 +0200
Message-ID: <101260B451BFC64699575BAC372B3DEE0138889E@mx1.pctvsystems.com>
In-Reply-To: <CAGoCfizDdx=a=mR5TRXw_Dnj9cw2_1C9NuRH2LR2gXxEzyfW3w@mail.gmail.com>
References: <CAGa-wNOL_1ua0DQFRPFuLtHO0zTFhE0DaM+b6kujMEEL4dQbKg@mail.gmail.com><CAGoCfizwYRpSsqobaHWJd5d0wq1N0KSXEQ1Un_ue01KuYGHaWA@mail.gmail.com><4E970CA7.8020807@iki.fi><CAGoCfiwSJ7EGXxAw7UgbFeECh+dg1EueXEC9iCHu7TaXia=-mQ@mail.gmail.com><4E970F7A.5010304@iki.fi><CAGoCfiyXiANjoB5bXgBpjwOAk8kpz8guxTGuGtVbtgc6+DNAag@mail.gmail.com><4E976EF6.1030101@southpole.se><CAGoCfixwp-iVFJysEG=UjN63-U_P4mdFWt+8hCwFW7fYeADvuw@mail.gmail.com><4E9836E5.6040601@redhat.com> <CAGoCfizDdx=a=mR5TRXw_Dnj9cw2_1C9NuRH2LR2gXxEzyfW3w@mail.gmail.com>
From: =?iso-8859-1?Q?S=F6nke_Brandt?= <SBrandt@pctvsystems.com>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Benjamin Larsson" <benjamin@southpole.se>,
	<linux-media@vger.kernel.org>, "Eddi De Pieri" <eddi@depieri.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Just a quick note: The 520e does use the TDA18271 tuner, not an XC5000.

 Soenke.

-----Ursprüngliche Nachricht-----
Von: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] Im Auftrag von Devin Heitmueller
Gesendet: Freitag, 14. Oktober 2011 15:28
An: Mauro Carvalho Chehab
Cc: Benjamin Larsson; linux-media@vger.kernel.org; Eddi De Pieri
Betreff: Re: PCTV 520e on Linux

On Fri, Oct 14, 2011 at 9:19 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>> While the basic chips used are different, they are completely
>> different hardware designs and likely have different GPIO
>> configurations as well as IF specs.
>
> The IF settings for xc5000 with DRX-K are solved with this patch:
>        http://patchwork.linuxtv.org/patch/7932/
>
> Basically, DRX-K will use whatever IF the tuner uses.

While I fundamentally disagree with this change, I'm not going to nack
it.  That said, this wasn't the issue I was concerned with.  My
suggestion was simply that you cannot assume that all devices that
happen to have a particular demod and tuner combo will always use the
same IF configuration.  The PCB layout can effect the optimal IF.

This is one of those things that (like many tuners in the LinuxTV
tree) will probably work good enough to get a signal lock for whoever
added the board profile, but will result in poor tuning performance
(and a failure to work in less-than-ideal reception conditions).

All that said, if somebody actually intends to hack on it, I can look
up what the correct IF is for the 520e.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
