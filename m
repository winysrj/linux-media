Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:50739 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab1DLMNR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 08:13:17 -0400
Message-ID: <4DA441D9.2000601@linuxtv.org>
Date: Tue, 12 Apr 2011 14:13:13 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Robby Workman <rworkman@slackware.com>
CC: linux-media@vger.kernel.org,
	Patrick Volkerding <volkerdi@slackware.com>
Subject: Re: [PATCHES] Misc. trivial fixes
References: <alpine.LNX.2.00.1104111908050.32072@connie.slackware.com>
In-Reply-To: <alpine.LNX.2.00.1104111908050.32072@connie.slackware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 04/12/2011 04:10 AM, Robby Workman wrote:
> --- a/Make.rules
> +++ b/Make.rules
> @@ -11,6 +11,7 @@ PREFIX = /usr/local
>  LIBDIR = $(PREFIX)/lib
>  # subdir below LIBDIR in which to install the libv4lx libc wrappers
>  LIBSUBDIR = libv4l
> +MANDIR = /usr/share/man

Why did you hardcode /usr instead of keeping $(PREFIX)/share/man?

Regards,
Andreas
