Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61383 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967059AbeCAJsi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 04:48:38 -0500
Date: Thu, 1 Mar 2018 06:48:33 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC] media: em28xx: don't use coherent buffer for DMA
 transfers
Message-ID: <20180301064833.59eed81a@vento.lan>
In-Reply-To: <CAGoCfixqh-p6YWV3Fb9hGpX5Wv=qiWHFseuFRva66XsYtGkgFQ@mail.gmail.com>
References: <df78951777f4edb8f627b043a12c710f0ba2497d.1519753238.git.mchehab@s-opensource.com>
        <CAGoCfixqh-p6YWV3Fb9hGpX5Wv=qiWHFseuFRva66XsYtGkgFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 28 Feb 2018 09:49:12 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Tue, Feb 27, 2018 at 12:42 PM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
> > While coherent memory is cheap on x86, it has problems on
> > arm. So, stop using it.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >
> > I wrote this patch in order to check if this would make things better
> > for ISOCH transfers on Raspberry Pi3. It didn't. Yet, keep using
> > coherent memory at USB drivers seem an overkill.
> >
> > So, I'm actually not sure if we should either go ahead and merge it
> > or not.
> >
> > Comments? Tests?
> 
> For what it's worth, while I haven't tested this patch you're
> proposing, I've been running what is essentially the same change in a
> private tree for several years in order for the device to work better
> with several TI Davinci SOC platforms.

Good to know! I guess then it is worth applying it. Btw, while here,
I'm wandering if it should keep using URB_ISO_ASAP flag or not. On
my tests, for DVB, it seems to be working both ways. Didn't test
analog TV yet.

Thanks,
Mauro
