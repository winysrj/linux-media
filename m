Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41678 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab2GKRSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 13:18:41 -0400
Date: Wed, 11 Jul 2012 19:18:35 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: martin-eric.racine@iki.fi
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jonathan Nieder <jrnieder@gmail.com>, 677533@bugs.debian.org,
	linux-media@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: video: USB webcam fails since kernel 3.2
Message-ID: <20120711191835.1be1c8ef@armhf>
In-Reply-To: <CAPZXPQfMrWySzx9=61WqoZ7zwzw19p69nN6_fuwAHjZVqGLDBw@mail.gmail.com>
References: <20120614162609.4613.22122.reportbug@henna.lan>
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
	<20120711132739.6b527a27@armhf>
	<CAPZXPQeDKLAu13Qs-MhhxJEBrF-5620HNZDmPiH+4NRmkxx3Ag@mail.gmail.com>
	<4FFD7F48.6060905@redhat.com>
	<CAPZXPQfMrWySzx9=61WqoZ7zwzw19p69nN6_fuwAHjZVqGLDBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Jul 2012 16:43:47 +0300
Martin-Éric Racine <martin-eric.racine@iki.fi> wrote:

> > Jean-Francois, can you perhaps make a patch against my latest tree for
> > the poXXXX / PO3130 changes in your tarbal?  
> 
> Noted.  Hopefully, the Debian kernel team can contribute to the
> backporting part, since it's needed for the upcoming stable release.

I had many problems with the vc032x driver, and the source code is very
different from the code in the official kernels.

As I have no webcam, Martin-Éric, may I ask you to test the backport
I will do? It will be done only in the vc032x driver, so you could keep
the working gspca_vc032x.ko file you have and restore it between the
tests. I still lack the sensor type of your webcam. May you send me the
result of:

	dmesg | fgrep gspca

I'll contact you directly (with copy to Hans de Goede) as soon as I
will have something to propose.

Thanks by advance.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
