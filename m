Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36932 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753391AbeBULg0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 06:36:26 -0500
Date: Wed, 21 Feb 2018 12:36:28 +0100
From: gregkh <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: stable <stable@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        Kernel Build Reports Mailman List
        <kernel-build-reports@lists.linaro.org>,
        Olof's autobuilder <build@lixom.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: stable-rc build: 3 warnings 0 failures
 (stable-rc/v4.14.20-119-g1b1ab1d)
Message-ID: <20180221113628.GC19900@kroah.com>
References: <5a8c18fe.594a620a.7443c.50c7@mx.google.com>
 <CAK8P3a3ma6aO_rBCj5e4AhUMhxRH383Ag2KzKQ9qfk2=Nkx-oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3ma6aO_rBCj5e4AhUMhxRH383Ag2KzKQ9qfk2=Nkx-oQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 20, 2018 at 04:22:04PM +0100, Arnd Bergmann wrote:
> On Tue, Feb 20, 2018 at 1:47 PM, Olof's autobuilder <build@lixom.net> wrote:
> 
> > Warnings:
> >
> >         arm64.allmodconfig:
> > drivers/media/tuners/r820t.c:1334:1: warning: the frame size of 2896 bytes is larger than 2048 bytes [-Wframe-larger-than=]
> 
> Hi Greg,
> 
> please add
> 
> 16c3ada89cff ("media: r820t: fix r820t_write_reg for KASAN")
> 
> This is an old bug, but hasn't shown up before as the stack warning
> limit was turned off
> in allmodconfig kernels. The fix is also on the backport lists I sent
> for 4.9 and 4.4.

Now applied, thanks.

greg k-h
