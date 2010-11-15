Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43650 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0KOJjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 04:39:14 -0500
Received: by ywc21 with SMTP id 21so1577050ywc.19
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 01:39:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CE05F77.3080703@gmail.com>
References: <AANLkTimOyNpAatcZb775PPK3uEOXDKXW6-J0kMGis41f@mail.gmail.com>
	<1289684029.2426.65.camel@localhost>
	<AANLkTim+OFLOH=dRERzkHOqtC9dLqJsR2Qy2nb+K9KHx@mail.gmail.com>
	<1289736763.2431.10.camel@localhost>
	<4CE05F77.3080703@gmail.com>
Date: Mon, 15 Nov 2010 20:39:14 +1100
Message-ID: <AANLkTinT=Rm1GgnTssGHnV-xqX4qvxORKEBzPP7fRDSb@mail.gmail.com>
Subject: Re: new_build on ubuntu (dvbdev.c)
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 11/15/10, Mauro Carvalho Chehab <maurochehab@gmail.com> wrote:
...
> I've added several patches for the new-build today, in order to make it
> compile
> against older kernels. I tested compilation here with both RHEL6 (2.6.32)
> and
> Fedora 14 (2.6.35) and compilation is working fine. Didn't test the drivers.
> I'm not sure if the remote controller will properly work with my quick
> backport.

Thanks  for those changes. The build completes now, with only three warnings.
I do have to say CONFIG_DVB_FIREDTV=n, it appears still to be a
problem on ubuntu.

>>> First dumb question - (I'll try to minimise these)
>>>
...
> The patches generally reverse-apply some upstream change. Andy's approach
> could be done via compat.h. I opted to just backport the upstream patch.
>
> Anyway, there were other problems on it, due to other API changes, and to
> the move of the rc-core from .../IR to .../rc directory.
>
> I opted to simplify the backports, avoiding to duplicate the same patch on
> several different directories.
>

I see that now, after some quality time in the backports directory. It
does look simpler.

I think my original problem was that somehow the patch in the
2.6.32_series to remove references to noop_llseek() was not applying
cleanly. No idea why, I flushed the logs I kept.

Thanks all, I'll give the new build a test run as soon as I get a chance.

Cheers
Vince
