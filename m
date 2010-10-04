Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57791 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab0JDX7N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Oct 2010 19:59:13 -0400
Received: by eyb6 with SMTP id 6so2301143eyb.19
        for <linux-media@vger.kernel.org>; Mon, 04 Oct 2010 16:59:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286234505.3167.29.camel@pc07.localdom.local>
References: <25861669.1285195582100.JavaMail.ngmail@webmail18.arcor-online.net>
	<AANLkTimdpehorJb+YrDuRgL7vSbF9Bn5iQS_g5TqF35F@mail.gmail.com>
	<4CA9FCB0.40502@gmail.com>
	<1286234505.3167.29.camel@pc07.localdom.local>
Date: Mon, 4 Oct 2010 19:59:11 -0400
Message-ID: <AANLkTikOPqqkR+K1=JY44h9x506Qc8jY13sF6j_dQGhA@mail.gmail.com>
Subject: Re: [linux-dvb] Asus MyCinema P7131 Dual support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Giorgio <mywing81@gmail.com>,
	Dejan Rodiger <dejan.rodiger@gmail.com>,
	linux-media@vger.kernel.org, Dmitri Belimov <d.belimov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 4, 2010 at 7:21 PM, hermann pitton <hermann-pitton@arcor.de> wrote:
> thanks for the report and pointing to the details again.
>
> We can see, that my testings on four different machines and Dmitri's
> tests have not been enough. Mauro had the Dual card=78 version from me
> too at least for analog TV testing.
>
> And, that was on hg with most backward compat as possible.
>
> How good are our chances, to run in such and similar troubles in the
> future, in fact staying only on latest -rc, rc-git and in best case on
> -next stuff previously?
>
> It will all come down to the distros and such a bug fix might take just
> a year in the future regularly ...
>
> So, if the quality control was not even sufficient on hg, what will
> happen on latest -rc git stuff for that?
>
> Obviously zillions of people do much more prefer to crash around there
> than on hg ... ;)

I think it's been made pretty clear:  we don't give a crap about
whether users' PCs crash.  Getting the code into the bleeding edge
kernel is the most important thing.  Reducing maintainership overhead
is clearly more important than whether the code actually works.

Forget about the hg backport system.  We would rather get crap code
into the bleeding edge kernel where almost zero users will test it
than to put it into HG where there is actually a chance for users to
see the problems before it goes into the mainline kernel (except for
the 0.1% of users who are willing to install the latest bleeding edge
kernel and make it work with all their other hardware).

Yes, we should all be prepared for lots of regressions being
introduced, and nobody notices them until the code is already in the
distros and has reached the masses.  And then maybe if the users are
lucky the distro maintainers will backport fixes.

It's been made pretty clear that reducing merge overhead is more
important than delivering a quality product.

I'll stop hijacking the thread now.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
