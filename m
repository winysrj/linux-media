Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53567 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbZGCKN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 06:13:27 -0400
Received: by fxm18 with SMTP id 18so2055335fxm.37
        for <linux-media@vger.kernel.org>; Fri, 03 Jul 2009 03:13:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380906290700n16a0f4faxd29caa12587222f7@mail.gmail.com>
References: <829197380906290700n16a0f4faxd29caa12587222f7@mail.gmail.com>
Date: Fri, 3 Jul 2009 12:13:28 +0200
Message-ID: <d9def9db0907030313t4ea3685m8f63981696d63c96@mail.gmail.com>
Subject: Re: Call for testers: Terratec Cinergy T XS USB support
From: Markus Rechberger <mrechberger@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On Mon, Jun 29, 2009 at 4:00 PM, Devin
Heitmueller<dheitmueller@kernellabs.com> wrote:
> Hello all,
>
> A few weeks ago, I did some work on support for the Terratec Cinergy T
> XS USB product.  I successfully got the zl10353 version working and
> issued a PULL request last week
> (http://www.kernellabs.com/hg/~dheitmueller/em28xx-terratec-zl10353)
>

There will be an alternative driver entirely in userspace available
which works across all major kernelversions and distributions. It will
support the old em28xx devices and handle audio routing for the most
popular TV applications directly.

This system makes compiling the drivers unnecessary across all
available linux systems between 2.6.15 and ongoing. This package also
allows commercial drivers from vendors, the API itself is almost the
same as the video4linux/linuxdvb API. Installing a driver takes less
than five seconds without having to take care about the kernel API or
having to set up a development system. Aside of that it's operating
system independent (working on Linux, MacOSX and FreeBSD).
I think this is the way to go for the future since it adds more
possibilities to the drivers, and it eases up and speeds up driver
development dramatically.

Best Regards,
Markus

> However, the other version of the product, which contains a mt352 is
> not yet working.
>
> I am looking for people who own the device and would be willing to do
> testing of a tree to help debug the issue.  Ideal candidates should
> have the experience using DVB devices under Linux in addition to some
> other known-working tuner product so we can be sure that certain
> frequencies are available and that the antenna/location work properly.
>  If you are willing to provide remote SSH access for short periods of
> time if necessary, also indicate that in your email.
>
> Please email me if you are interested in helping out getting the device working.
>
> Thank you,
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
