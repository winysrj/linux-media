Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62409 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2I0HYV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 03:24:21 -0400
Received: by weyt9 with SMTP id t9so437024wey.19
        for <linux-media@vger.kernel.org>; Thu, 27 Sep 2012 00:24:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120926105211.38d14bc4@lwn.net>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-5-git-send-email-javier.martin@vista-silicon.com>
	<20120926105211.38d14bc4@lwn.net>
Date: Thu, 27 Sep 2012 09:24:20 +0200
Message-ID: <CACKLOr2TrXmPZVYDQAFgdSK_qF=oSosP9iHWUpe-_6t-jYHOTg@mail.gmail.com>
Subject: Re: [PATCH 4/5] media: ov7670: add possibility to bypass pll for ov7675.
From: javier Martin <javier.martin@vista-silicon.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 September 2012 18:52, Jonathan Corbet <corbet@lwn.net> wrote:
> On Wed, 26 Sep 2012 11:47:56 +0200
> Javier Martin <javier.martin@vista-silicon.com> wrote:
>
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>
> This one needs a changelog - what does bypassing the PLL do and why might
> you want to do it?  Otherwise:

As I stated in a previous patch, frame rate depends on the pixclk. Moreover:

pixclk = xvclk / clkrc * PLLfactor

Bypassing the PLL means that the PLL gets out of the way so, in
practice, PLLfactor = 1

pixclk = xvclk / clkrc

For a frame rate of 30 fps a pixclk of 24MHz is needed. Since we have
a clean clock signal we want pixclk = xvclk.

If one applies the formula in ov7670_set_framerate() with PLLfactor =
1 and clock_speed = 24 MHz the resulting clkrc = 1 which means that:
pixclk = xvclk   which is what we want


> Acked-by: Jonathan Corbet <corbet@lwn.net>

Thank you.

I will add a changelog when I send v2 of the series.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
