Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61000 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1HNMOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 08:14:50 -0400
Received: by bke11 with SMTP id 11so2495087bke.19
        for <linux-media@vger.kernel.org>; Sun, 14 Aug 2011 05:14:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108141921.30627.declan.mullen@bigpond.com>
References: <201108141921.30627.declan.mullen@bigpond.com>
Date: Sun, 14 Aug 2011 08:14:48 -0400
Message-ID: <CAGoCfiywxPN0eQPFutZRJzuA5mbQZsHucqR7HkmV+5JUaNeavA@mail.gmail.com>
Subject: Re: How to git and build HVR-2200 drivers from Kernel labs ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Declan Mullen <declan.mullen@bigpond.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 14, 2011 at 5:21 AM, Declan Mullen
<declan.mullen@bigpond.com> wrote:
> Hi
>
> I've got a 8940 edition of a Hauppauge HVR-2200. The driver is called saa7164.
> The versions included in my OS (mythbuntu 10.10 x86 32bit, kernel 2.6.35-30)
> and from linuxtv.org are too old to recognise the 8940 edition. Posts #124 to
> #128 in the "Hauppauge HVR-2200 Tuner Install Guide" topic
> (http://www.pcmediacenter.com.au/forum/topic/37541-hauppauge-hvr-2200-tuner-
> install-guide/page__view__findpost__p__321195) document my efforts with those
> versions.
>
> So I wish to use the latest stable drivers from the driver maintainers, ie
> http://kernellabs.com/gitweb/?p=stoth/saa7164-stable.git;a=summary
>
> Problem is, I don't know git and I don't know how I'm suppose to git, build
> and install it.
>
> Taking a guess I've tried:
>  git clone git://kernellabs.com/stoth/saa7164-stable.git
>  cd saa7164-stable
>  make menuconfig
>  make
>
> However I suspect these are not the optimum steps, as it seems to have
> downloaded and built much more than just the saa7164 drivers. The git pulled
> down nearly 1GB (which seems a lot) and the resultant menuconfig produced a
> very big ".config".
>
> Am I doing the right steps or should I be doing something else to git, build
> and install  the latest drivers ?
>
> Thanks,
> Declan

Hello Declan,

Blame Mauro and the other LinuxTV developers for moving to Git.  When
we had HG you could do just the v4l-dvb stack and apply it to your
existing kernel.  Now you have to suck down the *entire* kernel, and
there's no easy way to separate out just the v4l-dvb stuff (like the
saa7164 driver).  The net effect is it's that much harder for
end-users to try out new drivers, and even harder still for developers
to maintain drivers out-of-tree.

All that said, Ubuntu 10.10 deviates very little in terms of the
saa7164 driver.  What you have is probably already identical to what's
in the kernellabs.com tree.

And yes, PAL support is broken even in the kernellabs tree, so if that
was your motivation then updating to the current KL stable tree won't
help you.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
