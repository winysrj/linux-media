Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51149 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267Ab1LFN4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 08:56:17 -0500
Received: by yenm1 with SMTP id m1so2915781yen.19
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2011 05:56:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EDE1C0C.2060701@redhat.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
	<1321800978-27912-2-git-send-email-mchehab@redhat.com>
	<1321800978-27912-3-git-send-email-mchehab@redhat.com>
	<1321800978-27912-4-git-send-email-mchehab@redhat.com>
	<1321800978-27912-5-git-send-email-mchehab@redhat.com>
	<CAGoCfiwv1MWnJc+3HL+9-E=o+HG09jjdGYOfpoXSoPd+wW3oHg@mail.gmail.com>
	<4EDD0F01.7040808@redhat.com>
	<CAGoCfizRuBEgBhfnzyrE=aJD-WMXCz9OmkoEqQCDpqmYXU2=zA@mail.gmail.com>
	<CAGoCfiywqY+U0+t9tget1X09=apDm46GpGCa-_QiGp+JhyLXxQ@mail.gmail.com>
	<CAKdnbx7Ayg6AGS-u=z9Pg6pHV6UN_ZiB-kQ1rv78zG9nm+U9TA@mail.gmail.com>
	<CAGoCfiwwt898OwmNNwrboT7q5v-sNQuTP6TxCdtY-fFauAyHrA@mail.gmail.com>
	<4EDE0FD7.4020603@teksavvy.com>
	<4EDE1C0C.2060701@redhat.com>
Date: Tue, 6 Dec 2011 08:56:16 -0500
Message-ID: <CAGoCfizuMQMz3_ihh1AB2uRUn5-1DkCVju1VFMzOnUkqA+tJJQ@mail.gmail.com>
Subject: Re: [PATCH 5/8] [media] em28xx: initial support for HAUPPAUGE
 HVR-930C again
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mark Lord <kernel@teksavvy.com>, Eddi De Pieri <eddi@depieri.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 6, 2011 at 8:43 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The driver who binds everything is the bridge driver. In your case, it is
> the au0828 driver.
>
> What you're experiencing seems to be some race issue inside it, and not at
> xc5000.
>
> On a quick look on it, I'm noticing that there's no lock at
> au0828_usb_probe().
>
> Also, it uses a separate lock for analog and for digital:
>
>        mutex_init(&dev->mutex);
>        mutex_init(&dev->dvb.lock);
>
> Probably, the right thing to do would be to use just one lock for both
> rising
> it at usb_probe, lowering it just before return 0. This will avoid any open
> operations while the device is not fully initialized. Btw, newer udev's open
> the analog part of the driver just after V4L register, in order to get the
> device capabilities. This is known to cause race conditions, if the locking
> schema is not working properly.

Just to be clear, we're now talking about a completely different race
condition that has nothing to do with the subject at hand, and this
discussion should probably be moved to a new thread.

That said, yes, there is definitely a race (if not two) in there to be
tracked down.  I know of a couple of users who upgraded to more recent
kernels and started experiencing breakage on module load where there
was none before.  This could obviously be dumb luck in that perhaps
the timing changed slightly, or it could be some change in the core
code which created a new race.  I haven't had the time/energy to dig
into the issue (compounded by the fact that these sorts of issues are
notoriously difficult to debug when it cannot be reproduced locally by
the developer).

The notion that this is something that has been there for over a year
is something I only learned of in the last couple of days.  All the
complaints I had seen thus far were from existing users who were
perfectly happy until they upgraded their kernel a couple of months
ago and then started seeing the problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
