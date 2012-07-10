Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:57012 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab2GJOhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 10:37:51 -0400
Date: Tue, 10 Jul 2012 16:36:45 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: martin-eric.racine@iki.fi
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>, 677533@bugs.debian.org,
	linux-media@vger.kernel.org
Subject: Re: video: USB webcam fails since kernel 3.2
Message-ID: <20120710163645.04fb0af0@armhf>
In-Reply-To: <CAPZXPQcaEzW1zGXfGwp-JuOrfBu2xhoidaYjthD8jhYAFpWr7A@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Jul 2012 15:56:08 +0300
Martin-Éric Racine <martin-eric.racine@iki.fi> wrote:
	[snip]
> I hope that the above already provides some usable answers.

Not a lot :(

Well, I already saw these errors -71. One case was a cable problem.
An other one occurred with skype only, while vlc worked correctly.

So, it would be interesting to know if the (almost) last driver works.
Then, you may try the gspca-2.15.18.tar.gz from my web site:

	wget http://moinejf.free.fr/gspca-2.15.18.tar.gz
	tar -zxf gspca-2.15.18.tar.gz
	cd gspca-2.15.18
	make
	su
	make install
	reboot

You may then try cheese. For skype, don't forget to force the
use of the v4l library:

	export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so
	skype

If the problem is still there, I'd be glad to get some traces.
For that, as root, do:

	echo 0x1f > /sys/module/gspca_main/parameters/debug

then, unplug/replug the webcam, do some capture until the problem
occurs, and send us the last kernel messages starting from the webcam
probe.

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
