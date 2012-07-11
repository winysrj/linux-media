Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41046 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2GKLOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 07:14:25 -0400
Received: by gglu4 with SMTP id u4so1062474ggl.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 04:14:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
In-Reply-To: <20120711124441.346a86b3@armhf>
References: <20120614162609.4613.22122.reportbug@henna.lan>
	<20120614215359.GF3537@burratino>
	<CAPZXPQd9gNCxn7xGyqj_xymPaF5OxvRtxRFkt+SsLs942te4og@mail.gmail.com>
	<20120616044137.GB4076@burratino>
	<1339932233.20497.14.camel@henna.lan>
	<CAPZXPQegp7RA5M0H9Ofq4rJ9aj-rEdg=Ly9_1c6vAKi3COw50g@mail.gmail.com>
	<4FF9CA30.9050105@redhat.com>
	<CAPZXPQd026xfKrAU0D7CLQGbdAs8U01u5vsHp+5-wbVofAwdqQ@mail.gmail.com>
	<4FFAD8D9.8070203@redhat.com>
	<20120709203929.GC17301@burratino>
	<CAPZXPQcaEzW1zGXfGwp-JuOrfBu2xhoidaYjthD8jhYAFpWr7A@mail.gmail.com>
	<20120710163645.04fb0af0@armhf>
	<CAPZXPQehjGRDZ=rXWjGFPQvRqOMzRpeA2dpoSWc3XwuUkvvesg@mail.gmail.com>
	<20120711100436.2305b098@armhf>
	<CAPZXPQdJC5yCYY6YRzuKj-ukFLzbY_yUzbogzbDx1S0bL1GrgQ@mail.gmail.com>
	<20120711124441.346a86b3@armhf>
Date: Wed, 11 Jul 2012 14:14:24 +0300
Message-ID: <CAPZXPQcvGqPjeyZh=vHtbSOoA91Htsg6DeyYyhYLeDgay8GSBg@mail.gmail.com>
Subject: Re: video: USB webcam fails since kernel 3.2
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>, 677533@bugs.debian.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/7/11 Jean-Francois Moine <moinejf@free.fr>:
> On Wed, 11 Jul 2012 13:21:55 +0300
> Martin-Éric Racine <martin-eric.racine@iki.fi> wrote:
>
>> I installed them. That still doesn't fix it:
>>
>> $ LC_ALL=C make
>> make -C /lib/modules/3.5.0-rc6+/build
>> M=/home/perkelix/gspca-2.15.18/build modules
>> make[1]: Entering directory `/usr/src/linux-headers-3.5.0-rc6+'
>> /usr/src/linux-headers-3.5.0-rc6+/arch/x86/Makefile:39:
>> /usr/src/linux-headers-3.5.0-rc6+/arch/x86/Makefile_32.cpu: No such
>> file or directory
>> make[1]: *** No rule to make target
>
> Strange. The file arch/x86/Makefile_32.cpu is in the linux 3.5.0 tree.
> It should have been forgotten in the Debian package. You may copy it
> from any other kernel source/header you have.

That would be a bug in upstream GIT's built-in support for producing
Debian packages then.

Anyhow, after copying the missing file, the build successfully
launches then breaks as follow:

  CC [M]  /home/perkelix/gspca-2.15.18/build/ov534_9.o
/home/perkelix/gspca-2.15.18/build/ov534_9.c: In function ‘sd_init’:
/home/perkelix/gspca-2.15.18/build/ov534_9.c:1353:3: error: implicit
declaration of function ‘err’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [/home/perkelix/gspca-2.15.18/build/ov534_9.o] Virhe 1
make[1]: *** [_module_/home/perkelix/gspca-2.15.18/build] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-3.5.0-rc6+'
make: *** [modules] Error 2

-- 
Martin-Éric
