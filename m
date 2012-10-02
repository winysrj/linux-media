Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42421 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab2JBMWa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 08:22:30 -0400
Received: by lbon3 with SMTP id n3so5044063lbo.19
        for <linux-media@vger.kernel.org>; Tue, 02 Oct 2012 05:22:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121002080503.76869be7@redhat.com>
References: <1349139145-22113-1-git-send-email-crope@iki.fi>
	<CAGoCfiwfTkTs1DPa0cWHLOgGcgS0Df3h7zZ=4YW51dr_AS78nQ@mail.gmail.com>
	<CAOcJUbw+ToEAaqKPx1phWsKdWvPRXUOhtWwm7VaESwkW=fpqyg@mail.gmail.com>
	<506ABA2B.3070908@iki.fi>
	<20121002080503.76869be7@redhat.com>
Date: Tue, 2 Oct 2012 08:22:28 -0400
Message-ID: <CAOcJUbzpf=ZsUYxYJ+MHNtC-YaAGfE1Hegk12Vqk+mSYuQ8Qyw@mail.gmail.com>
Subject: Re: [PATCH RFC] em28xx: PCTV 520e switch tda18271 to tda18271c2dd
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 2, 2012 at 7:05 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Btw, why do you need to read 16 registers at once, instead of just reading
> the needed register? read_extended and write operations are even more evil:
> they read/write the full set of 39 registers on each operation. That seems
> to be overkill, especially on places like tda18271_get_id(), where
> all the driver is doing is to check for the ID register.

TDA18271 does not support subaddressing for read operations.  The only
way to read a register is by dumping full register contents.  16
registers in simple mode, 39 registers in extended mode.

> Worse than that, tda18271_get_id() doesn't even check if the read()
> operation failed: it assumes that it will always work, letting the
> switch(regs[R_ID]) to print a wrong message (device unknown) when
> what actually failed where the 16 registers dump.

That's a pretty standard operation to be able to read a chip's ID in
its driver attach function.  You even have some drivers that continue
trying to attach frontends and tuners as long as they continue to get
an error in the attach() function.  If we dont read the chip's ID
during attach() then how do we know we're attaching to the correct
chip?

I'll look at the fact that it doesn't check for a read error -- that
can be easily fixed.

> Whenever it should be at attach() or later is a good point for discussions.

The tda18271 driver supports running multiple tda18271 devices in
tandem with one another, including the ability to share xtal input and
rf loop thru.  In some cases, the order in which we initialize the
different tda18271's (when there are multiples) must be carefully
controlled, and we do this by attaching them to the bridge driver in
the order needed, such as in the saa7164 driver -- we need to be ABLE
to initialize the tuner during the attach, but being able to defer it
*as an option* is OK with me.

Regards,

Mike Krufky
