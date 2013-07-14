Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37684 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3GNNlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jul 2013 09:41:42 -0400
Received: by mail-wg0-f50.google.com with SMTP id k14so9512182wgh.29
        for <linux-media@vger.kernel.org>; Sun, 14 Jul 2013 06:41:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130714152321.2a9e1eb2@fls-nb.lan.streibelt.net>
References: <20130712182632.667842dc@fls-nb.lan.streibelt.net>
	<51E26E22.8050005@xs4all.nl>
	<20130714152321.2a9e1eb2@fls-nb.lan.streibelt.net>
Date: Sun, 14 Jul 2013 09:41:40 -0400
Message-ID: <CAGoCfiw2jL=uAUM-=s-RnH0=GX=pAO3nugzQ7iV2yN-irixHvQ@mail.gmail.com>
Subject: Re: CX23103 Video Grabber seems to be supported by cx231xx driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Florian Streibelt <florian@inet.tu-berlin.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 14, 2013 at 9:23 AM, Florian Streibelt
<florian@inet.tu-berlin.de> wrote:
>> Be aware that I consider this driver to be flaky, so I would not at all be
>> surprised if there are bugs lurking in the code.
>
>
> Hum. Because of code quality or due to the missing documentation from the vendor?

While this is all too common for vendors, it really isn't a reasonable
assertion in this case.  Conexant (the chip vendor) wrote the original
driver, and they have been very supportive in the past.  They provided
documentation (under NDA) and reference designs at no cost.  They've
also answered questions I've had in the past regarding the chip and
you'll also note that the email address of the maintainer was a
Conexant engineer until he left the company.

Regarding the flakiness, there indeed have been some reliability
problems - some of them were in the original driver sources, a couple
I introduced doing the cleanup work to get it upstream (and long ago
fixed), and some were regressions introduced after the driver went
upstream.  It's tough maintaining a driver on an ongoing basis that
supports many different cards from different vendors, in particular
since individuals making changes to the driver to make it work with
some new device, don't have all of the other products to test with (to
ensure regressions aren't introduced).

These drivers also tend to suffer from bitrot.  If they aren't
actively being used by many people and if there isn't a developer who
actively maintains the driver, then regressions sneak in there and go
unnoticed for months/years.

> If you have any documents on the chip I would be happy.

I don't think there are any documents that aren't under NDA.  That
said, you don't need the register docs to debug a system hang.  If you
don't have the time to jam a few printk() statements into the source,
then there's no point in going through the effort to get you docs.

Your best bet at this point is probably to wait [indefinitely] for
some developer who has a need for the device to work to stumble across
the problem and debug it.  You get what you pay for.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
