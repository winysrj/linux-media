Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56554 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab1JNQlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 12:41:05 -0400
Received: by bkbzt19 with SMTP id zt19so200871bkb.19
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 09:41:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E985FDF.6080203@redhat.com>
References: <CAGa-wNOL_1ua0DQFRPFuLtHO0zTFhE0DaM+b6kujMEEL4dQbKg@mail.gmail.com>
	<CAGoCfizwYRpSsqobaHWJd5d0wq1N0KSXEQ1Un_ue01KuYGHaWA@mail.gmail.com>
	<4E970CA7.8020807@iki.fi>
	<CAGoCfiwSJ7EGXxAw7UgbFeECh+dg1EueXEC9iCHu7TaXia=-mQ@mail.gmail.com>
	<4E970F7A.5010304@iki.fi>
	<CAGoCfiyXiANjoB5bXgBpjwOAk8kpz8guxTGuGtVbtgc6+DNAag@mail.gmail.com>
	<4E976EF6.1030101@southpole.se>
	<CAGoCfixwp-iVFJysEG=UjN63-U_P4mdFWt+8hCwFW7fYeADvuw@mail.gmail.com>
	<4E9836E5.6040601@redhat.com>
	<CAGoCfizDdx=a=mR5TRXw_Dnj9cw2_1C9NuRH2LR2gXxEzyfW3w@mail.gmail.com>
	<101260B451BFC64699575BAC372B3DEE0138889E@mx1.pctvsystems.com>
	<CAGoCfiwPbGEqQgu-yjoFMz_7mk-u9gDEvwWSJ0uW1tCaGwzWgQ@mail.gmail.com>
	<4E985FDF.6080203@redhat.com>
Date: Fri, 14 Oct 2011 12:41:03 -0400
Message-ID: <CAGoCfiw6B1ZjmCRqurSfTmhPZ5W+GMy0bQfhbavahWSPLBhAdg@mail.gmail.com>
Subject: Re: PCTV 520e on Linux
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?ISO-8859-1?Q?S=F6nke_Brandt?= <SBrandt@pctvsystems.com>,
	Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org, Eddi De Pieri <eddi@depieri.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 14, 2011 at 12:14 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The tda18271-dd/drx-k/em28xx combination works fine, provided that the GPIO
> initialization enables both tuner and demod during probe time. Currently, the
> device I used to add support for it (a Terratec H5) has a hack to enable
> the devices: it just replies whatever initialization the original driver does.
>
> When I have some time, I'll fix that, but I'm not urging doing so, because it
> just works ;)
>
> In order to add support for PCTV 520e, it is probably a matter of just set the
> GPIO's.

Complements of our friends at PCTV:

520e:
GPIO02: Decoder Reset, active-low
GPIO04: Decoder Suspend, active-low
GPIO06: Demod Reset, active-low
GPIO07: LED on, active-high

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
