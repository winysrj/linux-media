Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:48500 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0AZBZs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 20:25:48 -0500
Subject: Re: Problems with cx18
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <829197381001250747h7bc977c7hc27b4d45be5820cd@mail.gmail.com>
References: <4B5DB387.70707@redhat.com>
	 <829197381001250747h7bc977c7hc27b4d45be5820cd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 20:24:07 -0500
Message-Id: <1264469047.3973.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-01-25 at 10:47 -0500, Devin Heitmueller wrote:
> On Mon, Jan 25, 2010 at 10:06 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Hi Devin/Andy/Jean,
> >
> > The cx88-alsa and cx18-drivers are broken: the driver depend of request_modules that doesn't exist
> > when !CONFIG_MODULES, and has some wrong __init annotations.
> >
> > The sq905c has a warning.
> >
> > I'm compiling it with:
> >        make ARCH=i386 allmodconfig drivers/media/|grep -v "^  CC" |grep -v "^  LD"
> >
> > Those are the errors found:
> >
> > drivers/media/video/cx18/cx18-driver.c:252: warning: ‘request_modules’ used but never defined
> > WARNING: drivers/media/video/cx18/cx18-alsa.o(.text+0x4de): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
> > The function cx18_alsa_load() references
> > the function __init snd_cx18_init().
> > This is often because cx18_alsa_load lacks a __init
> > annotation or the annotation of snd_cx18_init is wrong.
> >
> > WARNING: drivers/media/video/cx18/built-in.o(.text+0x1c022): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
> > The function cx18_alsa_load() references
> > the function __init snd_cx18_init().
> > This is often because cx18_alsa_load lacks a __init
> > annotation or the annotation of snd_cx18_init is wrong.
> >
> > drivers/media/video/gspca/sq905c.c: In function ‘sd_config’:
> > drivers/media/video/gspca/sq905c.c:207: warning: unused variable ‘i’
> > WARNING: drivers/media/video/built-in.o(.text+0x28d24e): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
> > The function cx18_alsa_load() references
> > the function __init snd_cx18_init().
> > This is often because cx18_alsa_load lacks a __init
> > annotation or the annotation of snd_cx18_init is wrong.
> >
> > WARNING: drivers/media/built-in.o(.text+0x2d2a2a): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
> > The function cx18_alsa_load() references
> > the function __init snd_cx18_init().
> > This is often because cx18_alsa_load lacks a __init
> > annotation or the annotation of snd_cx18_init is wrong.
> 
> This looks like breakage I probably introduced with the cx18 alsa
> support.  I will dig into this tonight.

Devin,

If it's easiest to not treat the cx18-alsa stuff as a module and just
always have the cx18 ALSA device interface available, that's OK by me.
Your call.

Regards,
Andy


> Devin
> 

