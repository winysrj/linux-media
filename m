Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49135 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab2GKIEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 04:04:44 -0400
Date: Wed, 11 Jul 2012 10:04:36 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: martin-eric.racine@iki.fi
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>, 677533@bugs.debian.org,
	linux-media@vger.kernel.org
Subject: Re: video: USB webcam fails since kernel 3.2
Message-ID: <20120711100436.2305b098@armhf>
In-Reply-To: <CAPZXPQehjGRDZ=rXWjGFPQvRqOMzRpeA2dpoSWc3XwuUkvvesg@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Jul 2012 10:02:27 +0300
Martin-Éric Racine <martin-eric.racine@iki.fi> wrote:
	[snip]
> >         wget http://moinejf.free.fr/gspca-2.15.18.tar.gz
> >         tar -zxf gspca-2.15.18.tar.gz
> >         cd gspca-2.15.18
> >         make
> 
> $ LC_ALL=C make
> make -C /lib/modules/3.5.0-rc6+/build
> M=/home/perkelix/gspca-2.15.18/build modules
> make: *** /lib/modules/3.5.0-rc6+/build: No such file or directory.  Stop.
> make: *** [modules] Error 2

You need the linux headers of your running kernel to compile the tarball.

	[snip]
> I don't recall Skype having required this in a long time. As I already
> said, until recently, the camera "just worked".

Good news!

	[snip]
> >         echo 0x1f > /sys/module/gspca_main/parameters/debug
> >
> > then, unplug/replug the webcam,
> 
> No can do; this is an internal webcam.

No problem. As I want to know the sensor type, instead of cutting the
kernel messages starting from the webcam probe, please, filter them by
something like:

	dmesg | fgrep gspca > gspca.txt

Thanks.
