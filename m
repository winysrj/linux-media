Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44085 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab1EEV6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 17:58:24 -0400
Received: by wwa36 with SMTP id 36so2829872wwa.1
        for <linux-media@vger.kernel.org>; Thu, 05 May 2011 14:58:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <16110382789.20110506010009@a-j.ru>
References: <1908281867.20110505213806@a-j.ru>
	<BANLkTimL7qhNpXr8xBBcU4MccZKAAFURYw@mail.gmail.com>
	<16110382789.20110506010009@a-j.ru>
Date: Thu, 5 May 2011 23:58:22 +0200
Message-ID: <BANLkTimGEL4YvXRJsFM10NfyHPOn-JsA_g@mail.gmail.com>
Subject: Re: [linux-dvb] TeVii S470 (cx23885 / ds3000) makes the machine unstable
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Andrew Junev <a-j@a-j.ru>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/5/5 Andrew Junev <a-j@a-j.ru>:
>
> Hello Josu,
>
> Thanks a lot for your response!
>
> What kernel version do you have?
> Do  you  see  your  card's  MAC  address in the /var/log/messages when
> the    driver   is  loading?  I'm not sure if it matters, but I see my
> old  TT S-1401 cards' MAC addresses in the logs, but I don't see the
> MAC of S470 anywhere... Maybe it just a specific of the driver...
>
>
> As Igor wrote earlier, I probably need to upgrade my kernel. Well, I'm
> not   really   looking  forward  to   do  that,  since it is likely to
> break  other things  for me. But if that's the only way - I guess I'll
> have to give it a try.
>
> Thanks again!
>
>

Hello again, sorry for my repeated posts.

I have 2.6.32-5-686 kernel and I have this output on dmesg:

[   11.459771] cx23885 driver version 0.0.2 loaded
[   11.460894] ACPI: PCI Interrupt Link [LN4A] enabled at IRQ 19
[   11.460914] cx23885 0000:05:00.0: PCI INT A -> Link[LN4A] -> GSI 19
(level, low) -> IRQ 19
[   11.461093] CORE cx23885[0]: subsystem: d470:9022, board: TeVii
S470 [card=15,autodetected]
[   11.587592] cx23885_dvb_register() allocating 1 frontend(s)
[   11.587600] cx23885[0]: cx23885 based dvb card
[   11.718813] DS3000 chip version: 0.192 attached.
[   11.718823] DVB: registering new adapter (cx23885[0])
[   11.718831] DVB: registering adapter 7 frontend 0 (Montage
Technology DS3000/TS2020)...
[   11.719476] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   11.719490] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 19,
latency: 0, mmio: 0xfea00000
[   11.719502] cx23885 0000:05:00.0: setting latency timer to 64

I complete the wiki page on linuxtv wiki, but I am not any expert and
english is not my best. Be careful with kernel upgrade, i had lots of
problem with 2.6.38 kernel.

Tell me how goes your progress.

Kind regards.

-- 
Josu Lazkano
