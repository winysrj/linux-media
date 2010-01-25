Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:41593 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0AYPrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 10:47:08 -0500
Received: by fxm7 with SMTP id 7so155301fxm.28
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 07:47:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B5DB387.70707@redhat.com>
References: <4B5DB387.70707@redhat.com>
Date: Mon, 25 Jan 2010 10:47:06 -0500
Message-ID: <829197381001250747h7bc977c7hc27b4d45be5820cd@mail.gmail.com>
Subject: Re: Problems with cx18
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@radix.net>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 25, 2010 at 10:06 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Devin/Andy/Jean,
>
> The cx88-alsa and cx18-drivers are broken: the driver depend of request_modules that doesn't exist
> when !CONFIG_MODULES, and has some wrong __init annotations.
>
> The sq905c has a warning.
>
> I'm compiling it with:
>        make ARCH=i386 allmodconfig drivers/media/|grep -v "^  CC" |grep -v "^  LD"
>
> Those are the errors found:
>
> drivers/media/video/cx18/cx18-driver.c:252: warning: ‘request_modules’ used but never defined
> WARNING: drivers/media/video/cx18/cx18-alsa.o(.text+0x4de): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
> The function cx18_alsa_load() references
> the function __init snd_cx18_init().
> This is often because cx18_alsa_load lacks a __init
> annotation or the annotation of snd_cx18_init is wrong.
>
> WARNING: drivers/media/video/cx18/built-in.o(.text+0x1c022): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
> The function cx18_alsa_load() references
> the function __init snd_cx18_init().
> This is often because cx18_alsa_load lacks a __init
> annotation or the annotation of snd_cx18_init is wrong.
>
> drivers/media/video/gspca/sq905c.c: In function ‘sd_config’:
> drivers/media/video/gspca/sq905c.c:207: warning: unused variable ‘i’
> WARNING: drivers/media/video/built-in.o(.text+0x28d24e): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
> The function cx18_alsa_load() references
> the function __init snd_cx18_init().
> This is often because cx18_alsa_load lacks a __init
> annotation or the annotation of snd_cx18_init is wrong.
>
> WARNING: drivers/media/built-in.o(.text+0x2d2a2a): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
> The function cx18_alsa_load() references
> the function __init snd_cx18_init().
> This is often because cx18_alsa_load lacks a __init
> annotation or the annotation of snd_cx18_init is wrong.

This looks like breakage I probably introduced with the cx18 alsa
support.  I will dig into this tonight.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
