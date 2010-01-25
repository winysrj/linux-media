Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0AYPGz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 10:06:55 -0500
Message-ID: <4B5DB387.70707@redhat.com>
Date: Mon, 25 Jan 2010 13:06:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Walls <awalls@radix.net>,
	Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Problems with cx18
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin/Andy/Jean,

The cx88-alsa and cx18-drivers are broken: the driver depend of request_modules that doesn't exist
when !CONFIG_MODULES, and has some wrong __init annotations.

The sq905c has a warning.

I'm compiling it with:
	make ARCH=i386 allmodconfig drivers/media/|grep -v "^  CC" |grep -v "^  LD"

Those are the errors found:

drivers/media/video/cx18/cx18-driver.c:252: warning: ‘request_modules’ used but never defined
WARNING: drivers/media/video/cx18/cx18-alsa.o(.text+0x4de): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
The function cx18_alsa_load() references
the function __init snd_cx18_init().
This is often because cx18_alsa_load lacks a __init 
annotation or the annotation of snd_cx18_init is wrong.

WARNING: drivers/media/video/cx18/built-in.o(.text+0x1c022): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
The function cx18_alsa_load() references
the function __init snd_cx18_init().
This is often because cx18_alsa_load lacks a __init 
annotation or the annotation of snd_cx18_init is wrong.

drivers/media/video/gspca/sq905c.c: In function ‘sd_config’:
drivers/media/video/gspca/sq905c.c:207: warning: unused variable ‘i’
WARNING: drivers/media/video/built-in.o(.text+0x28d24e): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
The function cx18_alsa_load() references
the function __init snd_cx18_init().
This is often because cx18_alsa_load lacks a __init 
annotation or the annotation of snd_cx18_init is wrong.

WARNING: drivers/media/built-in.o(.text+0x2d2a2a): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_init()
The function cx18_alsa_load() references
the function __init snd_cx18_init().
This is often because cx18_alsa_load lacks a __init 
annotation or the annotation of snd_cx18_init is wrong.

Please fix.

Cheers,
Mauro.
