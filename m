Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61029 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab0JSV2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 17:28:51 -0400
Received: by eyx24 with SMTP id 24so331244eyx.19
        for <linux-media@vger.kernel.org>; Tue, 19 Oct 2010 14:28:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010192227.39364.hverkuil@xs4all.nl>
References: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com>
	<AANLkTim+QfU5hJwi_DkdpnAvUWSOLdEM5kXoTDK5+tsy@mail.gmail.com>
	<201010192227.39364.hverkuil@xs4all.nl>
Date: Tue, 19 Oct 2010 17:28:49 -0400
Message-ID: <AANLkTimk9kP5pb4yy+L0Zu0Om0siLnsDUzDZ2AmZkHMd@mail.gmail.com>
Subject: Re: rtl2832u support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Damjan Marion <damjan.marion@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Oct 19, 2010 at 4:27 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Bullshit.

Not exactly the level of mutual respect for your peers that I would
expect of you, Hans.

> First of all these rules are those of the kernel community
> as a whole and *not* linuxtv as such, and secondly you can upstream such
> drivers in the staging tree. If you want to move it out of staging, then
> it will take indeed more work since the quality requirements are higher
> there.

You are correct - while I indeed say it was the position of the
LinuxTV developers, I didn't intend to single them out from the rest
of the Linux kernel community.  The problem I described is systemic to
working with the Linux kernel community in general.

> Them's the rules for kernel development.
>
> I've done my share of coding style cleanups. I never understand why people
> dislike doing that. In my experience it always greatly improves the code
> (i.e. I can actually understand it) and it tends to highlight the remaining
> problematic areas in the driver.

Because it's additional work.  I agree that *sometimes* it can be
useful.  And yet many times it's a bunch of changes that provide
little actual value and only make it harder to keep the Linux driver
in sync with the upstream source (in many cases, the GPL driver is
derived from some Windows driver or other source).

Alex makes a point that I think it's worth expanding on a bit:

The Linux kernel developers' goals are different than those of the
product/chipset vendor.  The product/chipset vendor typically wants
consistency across operating systems.  This usually involves some sort
of OS portability layer to abstract out the OS specific parts (which
is usually done as a combination of OS specific header files and C
macros).  This reduces the maintenance cost for the author as it makes
it easier to be confident that changes to the core will basically
"just work" on other operating systems.

The Linux kernel developer wants consistency across Linux drivers
regardless of who wrote them.  This makes sense for the Linux kernel
community in that it makes it easier to work on drivers that you
didn't necessarily write.  However it also means that all of the
portability code and macros are seen as "crap which has to be stripped
out".  The net effect is a driver that looks little like the original
platform independent driver, making it easier for the Linux kernel
community to maintain but harder for the original author to provide
updates to.

I can appreciate why the Linux development community chose this route,
but let's not pretend that it doesn't come at a significant cost.
Kind of like how the Git move has resulted in developers who want to
build drivers on a known-stable kernel (as opposed to the bleeding
edge) being treated as second class citizens.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
