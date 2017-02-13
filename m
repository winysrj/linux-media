Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34102
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751482AbdBMKFM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 05:05:12 -0500
Date: Mon, 13 Feb 2017 08:04:48 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Marcel Heinz <quisquilia@gmx.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Bug#854100: libdvbv5-0: fails to tune / scan
Message-ID: <20170213080448.11f49304@vento.lan>
In-Reply-To: <458abbd2-a98b-243b-bf2f-48d5e5a8060b@googlemail.com>
References: <148617570740.6827.6324247760769667383.reportbug@ixtlilton.netz.invalid>
        <0db3f8d1-0461-5d82-a92d-ecc3cfcfec71@googlemail.com>
        <8792984d-54c9-01a8-0f84-7a1f0312a12f@gmx.de>
        <CAJxGH0-ewWzxSJ1vE+n4FMkqv+pnmT9G0uAZS5oUYkhxWm+=5A@mail.gmail.com>
        <ba755934-7946-59ea-e900-fe76d4ea2f0a@gmx.de>
        <458abbd2-a98b-243b-bf2f-48d5e5a8060b@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 10 Feb 2017 22:02:01 +0100
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello Mauro & DVB-S maintainers,
> 
> could you please have a look at the bug report below? Marcel was so kind
> to bisect the problem to the following commit:
> 
> https://git.linuxtv.org/v4l-utils.git/commit/?id=d982b0d03b1f929269104bb716c9d4b50c945125

Sorry for not handling it earlier. I took vacations on Jan, and had a pile
of patches to handle after my return. I had to priorize them, as we're
close to a Kernel merge window.

Now that Linus postponed the merge window, I had some time to dig into
it.

> 
> Bug report against libdvbv5 is here:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=854100

There was a bug at the logic that was checking if the frequency was
at the range of the local oscillators. This patch should be addressing
it:
	https://git.linuxtv.org/v4l-utils.git/commit/?id=5380ad44de416a41b4972e8a9c147ce42b0e3ba0

With that, the logic now seems to be working fine:

$ ./utils/dvb/dvbv5-scan ~/Intelsat-34 --lnbf universal -vv
Using LNBf UNIVERSAL
	Universal, Europe
	10800 to 11800 MHz, LO: 9750 MHz
	11600 to 12700 MHz, LO: 10600 MHz
...
Seeking for LO for 12.17 MHz frequency
LO setting 0: 10.80 MHz to 11.80 MHz
LO setting 1: 11.60 MHz to 12.70 MHz
Multi-LO LNBf. using LO setting 1 at 10600.00 MHz
frequency: 12170.00 MHz, high_band: 1
L-Band frequency: 1570.00 MHz (offset = 10600.00 MHz)

I can't really test it here, as my satellite dish uses a different
type of LNBf, but, from the above logs, the bug should be fixed.

Marcel,

Could you please test? The patch is already upstream.
I added a debug patch after it, in order to help LNBf issues
(enabled by using "-vv" command line parameters).

Thanks!
Mauro
