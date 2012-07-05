Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64496 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab2GEO4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 10:56:46 -0400
Received: by ghrr11 with SMTP id r11so7470715ghr.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 07:56:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40487954c2e06f48950f89ac2156778a@hardeman.nu>
References: <20120702115800.1275f944@kryten>
	<20120702115937.623d3b41@kryten>
	<20120703202825.GC29839@hardeman.nu>
	<20120705203035.196e238e@kryten>
	<9c21e63d50aba0e550a69a691dd12860@hardeman.nu>
	<CAF0Ff2nMFzW+M8wJG_Fx8Ah4_eyE7J9-YPWu-vt0wvC-Yo4BzQ@mail.gmail.com>
	<40487954c2e06f48950f89ac2156778a@hardeman.nu>
Date: Thu, 5 Jul 2012 17:56:45 +0300
Message-ID: <CAF0Ff2nKi33FUoa76S7-cssKDKJjFh5G9r0yvqSQJYC4Nzm34Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] winbond-cir: Adjust sample frequency to
 improve reliability
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Anton Blanchard <anton@samba.org>, mchehab@infradead.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David, i see your point - as i mentioned i have no any knowledge of IR
receiver part you're discussing and/or its Linux drivers and don't
want just to spam, but my simple thinking is that if the Logitech
Harmony universal remote control is with wrongly configured firmware
it can emit something that is so messed up that makes the IR receiver
part behaves in completely unpredictable way. anyway, at least Anton
have some ideas to try...

On Thu, Jul 5, 2012 at 5:45 PM, David Härdeman <david@hardeman.nu> wrote:
> On Thu, 5 Jul 2012 17:39:18 +0300, Konstantin Dimitrov
> <kosio.dimitrov@gmail.com> wrote:
>> excuse me for my ignorance, but don't you think adjusting the IR
>> receiver to universal remote control is fundamentally wrong, while the
>> whole point of universal remote control like Logitech Harmony is to be
>> adjusted to the IR receiver and be able to be adjusted to any IR
>> receiver and not the other way around. so, that being said, my point
>> is maybe the whole discussion here is just wild goose chase until
>> those settings i mentioned in Logitech control software are not tried
>> and there is no evidence that has already being done based on the
>> information provided by Anton. we don't know what exactly those
>> settings applied to Logitech Harmony firmware via Logitech control
>> software do and it could be default pulse timings that are set trough
>> them are just out of specification for RC6 and need to be manually
>> refined using the Harmony firmware settings in question - once again
>> after all universal remote control is supposed to be able to fit any
>> IR receiver and any type of pulses and that's why provides series of
>> different settings in order to do that - the issue seems more like
>> misconfiguration of the universal remote control than Linux drivers
>> problem. i'm just trying to save you time chasing not existing
>> problems and don't mean anything else - i didn't even look at the
>> source code you're discussing - i just have practical experience with
>> Logitech Harmony 890 and thus i know keymaps and protocols are
>> independently set from the proper pulse timings with Logitech control
>> software.
>
> Konstantin,
>
> thanks for your concern, but some of the byte sequences that Anton showed
> are "incorrect" in the sense that the receiver hardware should never
> generate them no matter what the (Logitech) remote is sending (unless I've
> misunderstood something of course).
>
> "0xdc 0xff 0xde" is a sequence which shouldn't happen.
>
> So even if the Logitech can be tweaked (and I'm sure Anton is grateful for
> the information), there is something wrong here and I'd like to get to the
> bottom of what it is.
>
> Kind regards,
> David
>
