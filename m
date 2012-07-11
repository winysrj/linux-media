Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:33133 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab2GKL1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 07:27:44 -0400
Date: Wed, 11 Jul 2012 13:27:39 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: martin-eric.racine@iki.fi
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>, 677533@bugs.debian.org,
	linux-media@vger.kernel.org
Subject: Re: video: USB webcam fails since kernel 3.2
Message-ID: <20120711132739.6b527a27@armhf>
In-Reply-To: <CAPZXPQcvGqPjeyZh=vHtbSOoA91Htsg6DeyYyhYLeDgay8GSBg@mail.gmail.com>
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
	<CAPZXPQcvGqPjeyZh=vHtbSOoA91Htsg6DeyYyhYLeDgay8GSBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Jul 2012 14:14:24 +0300
Martin-Éric Racine <martin-eric.racine@iki.fi> wrote:

>   CC [M]  /home/perkelix/gspca-2.15.18/build/ov534_9.o
> /home/perkelix/gspca-2.15.18/build/ov534_9.c: In function ‘sd_init’:
> /home/perkelix/gspca-2.15.18/build/ov534_9.c:1353:3: error: implicit
> declaration of function ‘err’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[2]: *** [/home/perkelix/gspca-2.15.18/build/ov534_9.o] Virhe 1
> make[1]: *** [_module_/home/perkelix/gspca-2.15.18/build] Error 2
> make[1]: Leaving directory `/usr/src/linux-headers-3.5.0-rc6+'
> make: *** [modules] Error 2

Sorry, I did not compile yet with kernel >= 3.4.

So, please, edit the file build/ov534_9.c (and possibly other sources),
changing  the calls to 'err' to 'pr_err'.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
