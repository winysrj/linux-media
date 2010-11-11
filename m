Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52561 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab0KKANn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 19:13:43 -0500
Received: by yxk30 with SMTP id 30so83375yxk.19
        for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 16:13:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=v9Ev0BDXBTWZs=LcMVGXoxcA7we5bKaR_m+2Z@mail.gmail.com>
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>
 <AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
 <AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
 <20101110222418.6098a92a.ospite@studenti.unina.it> <AANLkTin+HtdoXO7+ObNCoix70knaL+Fi4725BOWVXuy9@mail.gmail.com>
 <AANLkTim4hzoTg4t-jHFUCrpQwQ9Pj2sbJAH=iuawrK7E@mail.gmail.com>
 <20101111002952.f5873ed4.ospite@studenti.unina.it> <AANLkTi=v9Ev0BDXBTWZs=LcMVGXoxcA7we5bKaR_m+2Z@mail.gmail.com>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Thu, 11 Nov 2010 01:13:21 +0100
Message-ID: <AANLkTi=Dcqk0ZFDr4U7Tiv2dZVWM8JZ-6v-JtcTvzSKx@mail.gmail.com>
Subject: Re: Bounty for the first Open Source driver for Kinect
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 11, 2010 at 12:36 AM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> I've seen alot projects failing due not having enough users
> If it should mainly remain a hacker only project then a kernel module
> should be fine.
sorry ?

> aside of that you can just debug userspace drivers with gdb, valgrind
> etc. if issues come up it will only affect your work not the entire
> system, kernel is seriously something critical.
So you think that most of actual drivers which are inside the kernel are bad ?

if it is inside the kernel it will be better maintained and fixed.
External dependencies will break many things and add exceptions.
You already got an answer for an issue similar to this from Linus
Torvalds and Andrew Morton
http://lkml.org/lkml/2007/10/10/244

Most of people want to download a kernel that just has all things
inside. not search for other dependencies somewhere. If it is inside
the kernel, many licensing problems will disappear.
What if I want to develop something based on that userspace GPL
library, should I search which license should I use (and there are
many MIT/BSD/LGPL/...)?

i
