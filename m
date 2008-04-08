Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <morgan.torvolt@gmail.com>) id 1JjKQu-0001xM-6j
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 22:28:45 +0200
Received: by wa-out-1112.google.com with SMTP id m28so1804420wag.13
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 13:28:36 -0700 (PDT)
Message-ID: <3cc3561f0804081328h526ad2d9j2d8c8dca2fac38ea@mail.gmail.com>
Date: Wed, 9 Apr 2008 00:28:36 +0400
From: "=?ISO-8859-1?Q?Morgan_T=F8rvolt?=" <morgan.torvolt@gmail.com>
To: "P. van Gaans" <w3ird_n3rd@gmx.net>
In-Reply-To: <47FA22ED.6060308@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <47F92310.4040500@gmx.net> <47FA22ED.6060308@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend common interfaces think my CAM is
	invalid
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> Knoppix didn't want to start (couldn't read the CD, not sure why, maybe
>  too old), but I found a Ubuntu 7.04 live/install CD. Started with that,
>  no difference. I did find something else: I've got three different
>  lenghts CI cables. One approx. 60cm, a few others approx. 40cm and some
>  approx. 4cm. With 60cm, both the offical Mediaguard CAM and Xcam won't
>  initialize. With 40cm, the Xcam still won't and the Mediaguard will init
>  about 50% of the time. With 4cm, both Xcam and Mediaguard will always
>  init. But it still doesn't work properly, even with the 4cm cable I
>  couldn't get a picture with the Mediaguard, and I had a picture for
>  about half a minute with the Xcam after which Kaffeine would freeze.

Not surprising. Many of the CAMs are really picky about timing and signalling.
The Conax 4.00 cam works every time for me. What I suggest is that you
try the patch I have linked to from
http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-budget_S-1500#CAM_tests
Which is this:
http://www.linuxtv.org/pipermail/linux-dvb/2007-July/019116.html

There is some manual labour to get this patch working, but once done,
all the CAMs I have initializes perfectly. I have no idea if the
cable-length affects the process less after the patching, but it sure
helps on initializing the CAMs I have.

>  I'm not sure if it's a driver problem, all I know is that this started
>  right after installing a new v4l-dvb a few weeks ago. The problem seems
>  to have no cause:
>
>  Not the DVB-card, as the S2-3200 had the same problem.
>  Not the CI cable, tried many different cables and I don't believe they
>  are all broken the same way.
>  Not the CI-daughterboard, I even bought new ones with no result.
>  Not the current v4l-dvb loaded, because a Ubuntu 7.04 live CD (kernel
>  2.6.20 iirc) has the same result now.
>  Not the computer, because the setup didn't work in another computer either.
>  Not the CAM, all CAMs work fine in a Vantage standalone.
>
>  And note I have used this setup, S-1500+CI+long cable+Xcam for months
>  without any problems.

You said you changed your powersupply. To a more powerful one? Some
PSUs does give away troublesome noise, especially when heavily loaded.
Also, some powerful PSUs have much of the power on wrong voltages, or
spread across different cables, so that you might actually be pushing
the PSU to it's limits on one circuit, while swapping some power
cables would solve the whole issue.

BTW, the CI daughterboard is very simple, like in _very_ simple. It is
very unlikely that this will break. If something is broken with CI, it
would probably be the cable or the tuner-card.

-Morgan-

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
