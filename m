Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab0GCWRQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 18:17:16 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o63MHFWM009936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 18:17:15 -0400
Message-ID: <4C2FB6E8.5090001@redhat.com>
Date: Sat, 03 Jul 2010 19:17:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v3] IR/mceusb: kill pinnacle-device-specific nonsense
References: <20100616201046.GA10000@redhat.com> <20100703040227.GA31255@redhat.com>
In-Reply-To: <20100703040227.GA31255@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-07-2010 01:02, Jarod Wilson escreveu:
> I have pinnacle hardware now. None of this pinnacle-specific crap is at
> all necessary (in fact, some of it needed to be removed to actually make
> it work). The only thing unique about this device is that it often
> transfers inbound data w/a header of 0x90, meaning 16 bytes of IR data
> following it, so I had to make adjustments for that, and now its working
> perfectly fine.
> 
> v2: stillborn
> 
> v3: remove completely unnecessary usb_reset_device() call that only served
> to piss off the pinnacle device regularly and unify/simplify some of the
> generation-specific device initialization code.
> 
> post-mortem: it seems the pinnacle hardware actually still gets pissed off
> from time to time, but I can (try) to fix that later (if possible). The
> patch is still quite helpful from a code reduction standpoint.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

I've already applied a previous version of this patch:

http://git.linuxtv.org/v4l-dvb.git?a=commit;h=afd46362e573276e3fb0a44834ad320c97947233

Could you please rebase it against my tree?

> ---
>  Makefile                  |    2 +-
>  drivers/media/IR/mceusb.c |  110 +++++++++------------------------------------
>  2 files changed, 22 insertions(+), 90 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 6e39ec7..0417c74 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 35
> -EXTRAVERSION = -rc1
> +EXTRAVERSION = -rc1-ir

Please, don't patch the upstream Makefile ;)

Cheers,
Mauro.
