Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:35732 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaBGUyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 15:54:04 -0500
Received: by mail-yh0-f42.google.com with SMTP id a41so3170614yho.1
        for <linux-media@vger.kernel.org>; Fri, 07 Feb 2014 12:54:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOEt8JJD9oiLu-AtjDt4G7440nrjzz8zAVW_LBp7neZySL=qCQ@mail.gmail.com>
References: <1391679907-17876-1-git-send-email-david.jedelsky@gmail.com>
	<CAHFNz9KKjjbuRFS=TZtB4e2FuC5-UMyVN-yTrAeRbVCqdmVkwg@mail.gmail.com>
	<CAOEt8JJD9oiLu-AtjDt4G7440nrjzz8zAVW_LBp7neZySL=qCQ@mail.gmail.com>
Date: Sat, 8 Feb 2014 02:24:02 +0530
Message-ID: <CAHFNz9KROonr3kfv_mYqHHC7diqqgEa1zuaXOG2QcbRO-_kKRQ@mail.gmail.com>
Subject: Re: [PATCH] [media] stb0899: Fix DVB-S2 support for TechniSat SkyStar
 2 HD CI USB ID 14f7:0002
From: Manu Abraham <abraham.manu@gmail.com>
To: David Jedelsky <david.jedelsky@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 8, 2014 at 1:19 AM, David Jedelsky <david.jedelsky@gmail.com> wrote:
>> That changes I2C functionality from STOP + START to repeated START.
>> Current functionality looks also very weird, as there is 5 messages sent,
>> all with STOP condition. I am not surprised if actually bug is still in
>> adapter... Somehow it should be first resolved how those messages are send,
>> with repeated START or STOP. And fix I2C client or adapter or both.
>>
>> regards
>> Antti
>
>
>
> Manu, Antti,
>
> Thank you for your response. I agree that the code is somewhat peculiar and
> it could be worthy to review it using documentation before I leave it as bug
> in my hw. Unfortunately I don't own appropriate documentation. If you can
> supply it I can look at it.

I can assure you that the STB0899 driver works well for S2 with most
USB bridges and PCI bridges, which brings me to the fact that the issue
does not exist with the STB0899 driver.

Regarding the documentation, I don't have any wrt to the USB bridge, but
only for the demodulator, tuner. But my hands are tied on that front, due to
NDA's and agreements.

Looking further in my hardware museum, I did find a
Technisat Skystar USB2 HD CI REV 2.0

The information on a white sticker on the PCB states:
Model AD-SB301, Project ID: 6027
DVB-S2, CI, USB Box (on-line update)
H/W Ver: A1, PID/VID: 14F7 / 0002

manufactured and sent to me by Azurewave.

It has a broken ferrite cored inductor on it, which appears to be on the
power line to the demodulator/tuner.

The PID/VID looks exactly the same as yours. If you have a firmware bug,
maybe it helps to update the firmware online ? (I guess the windows driver
uses some stock Cypress driver, from what I can imagine ?)

I had similar problems as you state, when I worked with a prototype version
of the Mantis PCI chipset where it had some issues regarding repeated
starts. I can't really remember the exact issue back then, but I do remember
the issue being tuner related as well, since the write to the tuner would reach
the very first tuner register alone. The communications to the tuner are
through a repeater on the demodulator.

This issue was addressed with an ECO Metal fix for the PCI bridge, but that
did eventually result in a newer chip though.

The problem could likely be similar with your USB bridge. Maybe it is a
driver bug too .. I haven't looked deeply at the az6027 driver.
