Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55187 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab2GKSIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 14:08:05 -0400
Received: by gglu4 with SMTP id u4so1528876ggl.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 11:08:04 -0700 (PDT)
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
In-Reply-To: <20120711191835.1be1c8ef@armhf>
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
	<20120711191835.1be1c8ef@armhf>
Date: Wed, 11 Jul 2012 21:08:03 +0300
Message-ID: <CAPZXPQeWC+pKJNLr12y_AybYCCKZr6ayBAa=EhaiyfN4iU8g5g@mail.gmail.com>
Subject: Re: video: USB webcam fails since kernel 3.2
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jonathan Nieder <jrnieder@gmail.com>, 677533@bugs.debian.org,
	linux-media@vger.kernel.org, debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/7/11 Jean-Francois Moine <moinejf@free.fr>:
> On Wed, 11 Jul 2012 16:43:47 +0300
> Martin-Éric Racine <martin-eric.racine@iki.fi> wrote:
>
>> > Jean-Francois, can you perhaps make a patch against my latest tree for
>> > the poXXXX / PO3130 changes in your tarbal?
>>
>> Noted.  Hopefully, the Debian kernel team can contribute to the
>> backporting part, since it's needed for the upcoming stable release.
>
> I had many problems with the vc032x driver, and the source code is very
> different from the code in the official kernels.
>
> As I have no webcam, Martin-Éric, may I ask you to test the backport
> I will do? It will be done only in the vc032x driver, so you could keep
> the working gspca_vc032x.ko file you have and restore it between the
> tests. I still lack the sensor type of your webcam. May you send me the
> result of:
>
>         dmesg | fgrep gspca

[   11.834852] gspca_main: v2.15.18 registered
[   11.844262] gspca_main: vc032x-2.15.18 probing 0ac8:0321
[   11.844682] gspca_vc032x: vc0321 check sensor header 2c
[   11.850304] gspca_vc032x: Sensor ID 3130 (0)
[   11.850309] gspca_vc032x: Find Sensor PO3130NC
[   11.851809] gspca_main: video0 created

Backport would be needed against 3.2.21 as this is what Debian will
(probably) release with.

Cheers!
Martin-Éric
