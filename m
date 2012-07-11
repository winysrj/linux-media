Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60704 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2GKKV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 06:21:56 -0400
Received: by ghrr11 with SMTP id r11so1018180ghr.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 03:21:55 -0700 (PDT)
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
In-Reply-To: <20120711100436.2305b098@armhf>
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
Date: Wed, 11 Jul 2012 13:21:55 +0300
Message-ID: <CAPZXPQdJC5yCYY6YRzuKj-ukFLzbY_yUzbogzbDx1S0bL1GrgQ@mail.gmail.com>
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
> On Wed, 11 Jul 2012 10:02:27 +0300
> Martin-Éric Racine <martin-eric.racine@iki.fi> wrote:
>         [snip]
>> >         wget http://moinejf.free.fr/gspca-2.15.18.tar.gz
>> >         tar -zxf gspca-2.15.18.tar.gz
>> >         cd gspca-2.15.18
>> >         make
>>
>> $ LC_ALL=C make
>> make -C /lib/modules/3.5.0-rc6+/build
>> M=/home/perkelix/gspca-2.15.18/build modules
>> make: *** /lib/modules/3.5.0-rc6+/build: No such file or directory.  Stop.
>> make: *** [modules] Error 2
>
> You need the linux headers of your running kernel to compile the tarball.

I installed them. That still doesn't fix it:

$ LC_ALL=C make
make -C /lib/modules/3.5.0-rc6+/build
M=/home/perkelix/gspca-2.15.18/build modules
make[1]: Entering directory `/usr/src/linux-headers-3.5.0-rc6+'
/usr/src/linux-headers-3.5.0-rc6+/arch/x86/Makefile:39:
/usr/src/linux-headers-3.5.0-rc6+/arch/x86/Makefile_32.cpu: No such
file or directory
make[1]: *** No rule to make target
`/usr/src/linux-headers-3.5.0-rc6+/arch/x86/Makefile_32.cpu'.  Stop.
make[1]: Leaving directory `/usr/src/linux-headers-3.5.0-rc6+'
make: *** [modules] Error 2

-- 
Martin-Éric
