Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62570 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbZL0WUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2009 17:20:04 -0500
Received: by fxm25 with SMTP id 25so4255680fxm.21
        for <linux-media@vger.kernel.org>; Sun, 27 Dec 2009 14:20:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091227163736.CC9C03F6D6@gemini.denx.de>
References: <20091227163736.CC9C03F6D6@gemini.denx.de>
Date: Mon, 28 Dec 2009 02:20:00 +0400
Message-ID: <1a297b360912271420g154e34a4gab4382de3a3169a0@mail.gmail.com>
Subject: Re: Mantis driver on TechniSat "CableStar HD 2"
From: Manu Abraham <abraham.manu@gmail.com>
To: Wolfgang Denk <wd@denx.de>
Cc: linux-media@vger.kernel.org, Manu Abraham <manu@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Wolfgang,

On Sun, Dec 27, 2009 at 8:37 PM, Wolfgang Denk <wd@denx.de> wrote:
> I have problems getting a TechniSat "CableStar HD 2" DVB-C card
> running with the latest Mantis driver on a Fedora 12 system (using
> their current standard 2.6.31.9-174.fc12.i686.PAE kernel in
> combination with the drivers from the http://linuxtv.org/hg/v4l-dvb
> repository). Tests have been done on two different mainboards.
>
> I can run a channel scan (using kaffeine) perfectly fine, also tuning
> to channels appears to work. I see a load of some 1,300 interrupts per
> sec when I have kaffeine running and tuned, and it seems there is data
> transferred between the card and the application.


>From what i understand without much deeper look is that you have a
successful LOCK and hence the transfer.

>
> The problem is: there is no video nor sound.


The generic budget DVB cards do not have an onboard hardware decoder
and what we have is a DVR device from which the Transport stream is
being read out. A Software decoder is used to process the TS.


> I have bought this card second-hand on, so I am not really sure if it
> is a software issue, or if eventually the hardware is broken.
>
>
> Can anybody recommend a way how to verify the driver or the hardware?
> Or can you recommend a specific kernel version the Mantis driver has
> been tested against?


If you can successfully tune and get a valid TS from the DVR device,
you can rule out issues with the card and the driver.
You can verify the functionality of the hardware and driver with the
command line applications from the dvb-apps repository.

Regards,
Manu
