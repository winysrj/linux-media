Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1JNQOd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 12:14:33 -0400
Message-ID: <4E985FDF.6080203@redhat.com>
Date: Fri, 14 Oct 2011 13:14:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: =?UTF-8?B?U8O2bmtlIEJyYW5kdA==?= <SBrandt@pctvsystems.com>,
	Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org, Eddi De Pieri <eddi@depieri.net>
Subject: Re: PCTV 520e on Linux
References: <CAGa-wNOL_1ua0DQFRPFuLtHO0zTFhE0DaM+b6kujMEEL4dQbKg@mail.gmail.com> <CAGoCfizwYRpSsqobaHWJd5d0wq1N0KSXEQ1Un_ue01KuYGHaWA@mail.gmail.com> <4E970CA7.8020807@iki.fi> <CAGoCfiwSJ7EGXxAw7UgbFeECh+dg1EueXEC9iCHu7TaXia=-mQ@mail.gmail.com> <4E970F7A.5010304@iki.fi> <CAGoCfiyXiANjoB5bXgBpjwOAk8kpz8guxTGuGtVbtgc6+DNAag@mail.gmail.com> <4E976EF6.1030101@southpole.se> <CAGoCfixwp-iVFJysEG=UjN63-U_P4mdFWt+8hCwFW7fYeADvuw@mail.gmail.com> <4E9836E5.6040601@redhat.com> <CAGoCfizDdx=a=mR5TRXw_Dnj9cw2_1C9NuRH2LR2gXxEzyfW3w@mail.gmail.com> <101260B451BFC64699575BAC372B3DEE0138889E@mx1.pctvsystems.com> <CAGoCfiwPbGEqQgu-yjoFMz_7mk-u9gDEvwWSJ0uW1tCaGwzWgQ@mail.gmail.com>
In-Reply-To: <CAGoCfiwPbGEqQgu-yjoFMz_7mk-u9gDEvwWSJ0uW1tCaGwzWgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-10-2011 11:04, Devin Heitmueller escreveu:
> On Fri, Oct 14, 2011 at 10:01 AM, Sönke Brandt <SBrandt@pctvsystems.com> wrote:
>>  Just a quick note: The 520e does use the TDA18271 tuner, not an XC5000.

The tda18271-dd/drx-k/em28xx combination works fine, provided that the GPIO
initialization enables both tuner and demod during probe time. Currently, the
device I used to add support for it (a Terratec H5) has a hack to enable
the devices: it just replies whatever initialization the original driver does.

When I have some time, I'll fix that, but I'm not urging doing so, because it
just works ;)

In order to add support for PCTV 520e, it is probably a matter of just set the
GPIO's.

>>
>>  Soenke.
> 
> Wow, how the hell did I screw that up?  Of course Sönke is correct.  I
> momentarily got the 520e confused with the HVR-930c (I've done work on
> both in the past).
> 
> Regards,
> 
> Devin
> 

