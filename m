Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:53686 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3AaQbm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 11:31:42 -0500
Received: by mail-qa0-f45.google.com with SMTP id g10so2954232qah.4
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 08:31:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <510A9A1E.9090801@googlemail.com>
References: <510A9A1E.9090801@googlemail.com>
Date: Thu, 31 Jan 2013 11:31:41 -0500
Message-ID: <CAGoCfiwQNBv1r5KgCzYFf7X1hP--fyQpqvRHCDtKFcSxwbJWpA@mail.gmail.com>
Subject: Re: WinTV-HVR-1400: scandvb (and kaffeine) fails to find any channels
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 31, 2013 at 11:21 AM, Chris Clayton
<chris2553@googlemail.com> wrote:
> Hi.
>
> On linuxtv.org, the Hauppauge WinTV-HVR-1400 is listed as being supported.
> I've bought one, but I find that when I run the scan for dvb-t channels,
> none are found. I have tried kernels 2.6.11, 2.7.5 and 3.8.0-rc5+ (pulled
> from Linus' tree today)
>
> I know the aerial and cable are OK because, using the same cable, scanning
> with an internal PCI dvb-t card in a desktop computer finds 117 TV and radio
> channels. I know the HVR-1400 expresscard is OK because, again using the
> same cable, on Windows 7 the Hauppauge TV viewing application also finds all
> those channels.

Try the patch described in this email sent last week:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg57577.html

There's a very good chance you have the same problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
