Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39911 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab2EHSrf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 14:47:35 -0400
Received: by qadb17 with SMTP id b17so804880qad.19
        for <linux-media@vger.kernel.org>; Tue, 08 May 2012 11:47:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA964E8.8080209@iki.fi>
References: <4FA96365.3090705@yahoo.fr>
	<4FA964E8.8080209@iki.fi>
Date: Tue, 8 May 2012 14:47:34 -0400
Message-ID: <CAGoCfiy4qkVQwy+zPH+r8jMxMX7heJk6BLPnOMJxF73FnBms+A@mail.gmail.com>
Subject: Re: em28xx : can work on ARM beagleboard ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: CB <chrbruno@yahoo.fr>, linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 8, 2012 at 2:24 PM, Antti Palosaari <crope@iki.fi> wrote:
> It should work as I know one person ran PCTV NanoStick T2 290e using
> Pandaboard which is rather similar ARM hw.
> http://www.youtube.com/watch?v=Wuwyuw0y1Fo

I ran into a couple of issues related to em28xx analog on ARM.
Haven't had a chance to submit patches yet.  To answer the question
though:  yes, analog support for the em28xx is known to be broken on
ARM right now.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
