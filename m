Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1Jq8MT-0004XG-HV
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 17:00:17 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: "Eduard Huguet" <eduardhc@gmail.com>
Date: Sun, 27 Apr 2008 16:59:41 +0200
References: <617be8890804140209p3b79df8cm3f94de8f82b1faa5@mail.gmail.com>
	<200804270540.29590.zzam@gentoo.org>
	<617be8890804270442t5318e322g8904e6e698c70a15@mail.gmail.com>
In-Reply-To: <617be8890804270442t5318e322g8904e6e698c70a15@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804271659.41562.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] a700 support (was: [patch 5/5] mt312: add
	attach-time setting to invert lnb-voltage (Matthias Schwarzott))
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sonntag, 27. April 2008, Eduard Huguet wrote:
> Thank you very much, Matthias. I was going to try the patch right now,
> however I'm finding that it doesn't apply clean to the current HG tree.
> This is what I'm getting:
>
> patching file linux/drivers/media/dvb/frontends/Kconfig
> Hunk #1 FAILED at 368.
> 1 out of 1 hunk FAILED -- saving rejects to file
> linux/drivers/media/dvb/frontends/Kconfig.rej
> patching file linux/drivers/media/dvb/frontends/Makefile
> Hunk #1 succeeded at 23 (offset -2 lines).
> patching file linux/drivers/media/dvb/frontends/zl10036.c
> patching file linux/drivers/media/dvb/frontends/zl10036.h
> patching file linux/drivers/media/video/saa7134/Kconfig
> patching file linux/drivers/media/video/saa7134/saa7134-cards.c
> Hunk #3 succeeded at 5716 (offset 42 lines).
> patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
>
> I've tried to manually patch Kconfig by adding the rejected lines, but I
> suppose there must something I'm doing wrong: apparently it compiles fine,
> but saa7134-dvb is not loaded and the frontend is not being created for the
> card (although the card is detected and the video0 device for analog is
> there).
>
This reject is caused by the massive movement of the hybrid tuner drivers to 
another directory.
I solved the reject, and re-uploaded the patch.
Here it does still work.

Regards
Matthias

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
