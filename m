Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40085 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZKIEGB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 23:06:01 -0500
Received: by bwz27 with SMTP id 27so3047439bwz.21
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 20:06:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cd9524450911081958v57b77d27iae3ab37ffef1ee8d@mail.gmail.com>
References: <cd9524450911081743y92a616amfcb8c6c069112240@mail.gmail.com>
	 <829197380911081752x707d9e2bs99f4dc044544d66f@mail.gmail.com>
	 <cd9524450911081801i5e8d97f4nd5864d46a66c676e@mail.gmail.com>
	 <829197380911081834v445d36c1yd931c5af69a21505@mail.gmail.com>
	 <cd9524450911081958v57b77d27iae3ab37ffef1ee8d@mail.gmail.com>
Date: Sun, 8 Nov 2009 23:06:05 -0500
Message-ID: <829197380911082006s5a575789rd1e2881e874177cd@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Barry Williams <bazzawill@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 8, 2009 at 10:58 PM, Barry Williams <bazzawill@gmail.com> wrote:
> Hi Devin
> I did not reboot after installing the patch somehow I thought simply
> removing the module (as I had done to restore some stability to my
> system) and reloading the module after the patch would be all I need.
> Well I learned that is not the case my apologies for not trying that
> first. So your tree fixed my second system with the rev 1 tuner.
> However my first system with the rev 2 card while now stable with your
> tree will not tune.
> Barry

Ok, good.  So now we just need to nail down why the 0fe9:db98 board
doesn't work.  Fortunately, I think I know what that bug is too.

Try this:

1.  Reboot the system.
2.  Perform a single tuning attempt.
3.  Send the full dmesg output starting at the time the box is booted.

If you're lucky, it's the issue I think it is, which will result in a
one-line patch.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
