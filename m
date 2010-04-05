Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:54390 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0DENfM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 09:35:12 -0400
Received: by fxm27 with SMTP id 27so995716fxm.28
        for <linux-media@vger.kernel.org>; Mon, 05 Apr 2010 06:35:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201004051521.25997.pboettcher@kernellabs.com>
References: <201004051521.25997.pboettcher@kernellabs.com>
Date: Mon, 5 Apr 2010 17:35:10 +0400
Message-ID: <y2m1a297b361004050635q47074f22l6f76adfa8883df44@mail.gmail.com>
Subject: Re: STV6110 vs STV6110x
From: Manu Abraham <abraham.manu@gmail.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

On Mon, Apr 5, 2010 at 5:21 PM, Patrick Boettcher
<pboettcher@kernellabs.com> wrote:
> Hi Igor,
> hi Manu,
>
> I'm currently adding support for a device based on STV0903+STV6110 frontend
> combination.
>
> Early investigation have shown that for both devices there is a driver - now
> looking in more detail because I'm doing the actual coding, I'm finding out
> that there is actually 2 drivers for STV6110.
>
> Which one I need to/can use for my hardware?
>
> From a first glance the actual code is identical (not the coding itself, but
> the things done).
>
> Please advise me what to do?


stv090x supports both the STV0900 and STV0903 demodulators.

TT S2-1600 (Budget card) uses STV0903 (stv090x)+STV6110A(stv6110x) with budget.c
Most likely, you can copy the configuration from budget.c as well for your card.

Regards,
Manu
