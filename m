Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60555 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965140Ab2B1O5k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 09:57:40 -0500
Received: by obcva7 with SMTP id va7so6871442obc.19
        for <linux-media@vger.kernel.org>; Tue, 28 Feb 2012 06:57:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F4A01E0.7000701@sciolus.org>
References: <4F4A01E0.7000701@sciolus.org>
Date: Tue, 28 Feb 2012 11:57:39 -0300
Message-ID: <CALF0-+V7TvMCqZoWMsoC3iBzB3JzhSkebqDjH=pREfrQ1yphgQ@mail.gmail.com>
Subject: Re: easycap: reset()
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: "R.M. Thomas" <rmthomas@sciolus.org>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

On Sun, Feb 26, 2012 at 6:56 AM, R.M. Thomas <rmthomas@sciolus.org> wrote:
> Hi Ezequiel,
>
> As you probably know, I originally developed the driver on the Sourceforge
> site.  Before uploading any new version of the driver I carried out
> extensive automated testing using various scripts I had written for this
> purpose.  I attach the tarball for the final version of the Sourceforge
> driver in order to explain what I mean.  When you unpack the tarball you
> will find the script ./tools/checktestPAL.sh, and you will see that this
> runs the script ./testPAL.sh unattended for 36 test cases.
>
> Early versions of the driver did not have the extra reset() calls, and I
> found that when I carried out the automated testing with
> ./tools/checktestPAL.sh and similar scripts the EasyCAP would sometimes fail
> to initialize correctly.  In these cases no video stream was visible, with
> mplayer then displaying an unchanging green or black window.  On average, I
> would see this failure in 5-10% of the test cases, but the behavior was not
> reproducible:  failure would occur randomly on different test cases when I
> ran ./tools/checktestPAL.sh again.
>
> I never discovered what caused the failures.  I assumed (without any
> evidence) that one of the EasyCAP chips was prone to latch-up or some
> similar hardware problem, but I may have been wrong about this.  The
> practical workaround which I found was to forcibly reset the hardware
> registers whenever the driver detected problems at initialization.  This is
> the reason for the time-consuming repeated use of the function reset().
>
> It would certainly be desirable to remove the extra reset() calls if
> possible, and I hope you will be able to do so.  However, I suggest that
> driver modifications involving reset() should be subjected to automated
> testing, because any resulting problems may not be apparent if testing is
> limited to one or two cases.
>

I see. I'll pospone the reset() patch until further testing
shows it is stable enough.
Thanks a lot for the test scripts, they'll be of much help.

> On a more general point, I believe the easycap driver would benefit from
> some radical rewriting.  At present it is not integrated with the V4L2
> mainstream (for historical reasons), and this needs to be corrected:
>
> https://lkml.org/lkml/2010/11/29/376

That's true. However, the driver works fine and
I'm not sure a complete rewrite is a good option.

>
> Unfortunately I cannot contribute to this myself, not only because I am
> fully committed now to an entirely different project, but also because I
> know so little about the V4L2 infrastructure that I could not be of much
> use.  I do hope you will be able to make some progress with it.
>

I understand. I also hope we make some progress with it :)

If it is at all possible I would like to ask you to send me
any information about the driver you have,
I mean datasheets and that sort of stuff.

Thanks a lot for your feedback,
Ezequiel.
