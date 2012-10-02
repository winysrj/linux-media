Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41245 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2JBDRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 23:17:10 -0400
Received: by lbon3 with SMTP id n3so4727020lbo.19
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 20:17:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiwfTkTs1DPa0cWHLOgGcgS0Df3h7zZ=4YW51dr_AS78nQ@mail.gmail.com>
References: <1349139145-22113-1-git-send-email-crope@iki.fi>
	<CAGoCfiwfTkTs1DPa0cWHLOgGcgS0Df3h7zZ=4YW51dr_AS78nQ@mail.gmail.com>
Date: Mon, 1 Oct 2012 23:17:08 -0400
Message-ID: <CAOcJUbw+ToEAaqKPx1phWsKdWvPRXUOhtWwm7VaESwkW=fpqyg@mail.gmail.com>
Subject: Re: [PATCH RFC] em28xx: PCTV 520e switch tda18271 to tda18271c2dd
From: Michael Krufky <mkrufky@linuxtv.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 1, 2012 at 9:58 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Mon, Oct 1, 2012 at 8:52 PM, Antti Palosaari <crope@iki.fi> wrote:
>> New drxk firmware download does not work with tda18271. Actual
>> reason is more drxk driver than tda18271. Anyhow, tda18271c2dd
>> will work as it does not do as much I/O during attach than tda18271.
>>
>> Root of cause is tuner I/O during drx-k asynchronous firmware
>> download. request_firmware_nowait()... :-/
>
> This seems like it's just changing the timing of the initialization
> process, which isn't really any better than the "msleep(2000)".  It's
> just dumb luck that it happens to work on the developer's system.
>
> Don't get me wrong, I agree with Michael that this whole situation is
> ridiculous, but I don't see why swapping out the entire driver is a
> reasonable fix.

I just send out a patch entitled, "tda18271: prevent register access
during attach() if delay_cal is set"   Antti, could you set
tda18271_config.delay_cal = 1 with this patch applied and see if it
solves your problem?

Again, although this may solve the problem for this particular device,
the *real* problem is this asynchronous firmware download in the demod
driver.

Nonetheless, Antti has been asking for this feature, to not allow
register access during attach, I was against it and I have my reasons,
but I believe that this patch is a fair compromise.

After somebody can test it, I think we should merge this -- any comments?

http://patchwork.linuxtv.org/patch/14799/

Regards,

Mike Krufky
