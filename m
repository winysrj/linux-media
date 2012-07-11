Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48482 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2GKHC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 03:02:29 -0400
Received: by ghrr11 with SMTP id r11so890773ghr.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 00:02:29 -0700 (PDT)
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
In-Reply-To: <20120710163645.04fb0af0@armhf>
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
Date: Wed, 11 Jul 2012 10:02:27 +0300
Message-ID: <CAPZXPQehjGRDZ=rXWjGFPQvRqOMzRpeA2dpoSWc3XwuUkvvesg@mail.gmail.com>
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

2012/7/10 Jean-Francois Moine <moinejf@free.fr>:
> So, it would be interesting to know if the (almost) last driver works.
> Then, you may try the gspca-2.15.18.tar.gz from my web site:
>
>         wget http://moinejf.free.fr/gspca-2.15.18.tar.gz
>         tar -zxf gspca-2.15.18.tar.gz
>         cd gspca-2.15.18
>         make

$ LC_ALL=C make
make -C /lib/modules/3.5.0-rc6+/build
M=/home/perkelix/gspca-2.15.18/build modules
make: *** /lib/modules/3.5.0-rc6+/build: No such file or directory.  Stop.
make: *** [modules] Error 2

>         su
>         make install
>         reboot
>
> You may then try cheese. For skype, don't forget to force the
> use of the v4l library:
>
>         export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so
>         skype

I don't recall Skype having required this in a long time. As I already
said, until recently, the camera "just worked".

> If the problem is still there, I'd be glad to get some traces.
> For that, as root, do:
>
>         echo 0x1f > /sys/module/gspca_main/parameters/debug
>
> then, unplug/replug the webcam,

No can do; this is an internal webcam.

Martin-Éric
