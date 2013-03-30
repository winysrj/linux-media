Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46750 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3C3JyD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Mar 2013 05:54:03 -0400
Received: by mail-lb0-f177.google.com with SMTP id r10so823626lbi.36
        for <linux-media@vger.kernel.org>; Sat, 30 Mar 2013 02:54:02 -0700 (PDT)
Date: Sat, 30 Mar 2013 11:54:55 +0200
From: Timo Teras <timo.teras@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130330115455.56c34b5f@vostro>
In-Reply-To: <20130328122252.19769614@redhat.com>
References: <20130325190846.3250fe98@vostro>
	<20130325143647.3da1360f@redhat.com>
	<20130325194820.7c122834@vostro>
	<20130325153220.3e6dbfe5@redhat.com>
	<20130325211238.7c325d5e@vostro>
	<20130326102056.63b55916@vostro>
	<20130327161049.683483f8@vostro>
	<20130328105201.7bcc7388@vostro>
	<20130328094052.26b7f3f5@redhat.com>
	<20130328153556.0b58d1aa@vostro>
	<20130328122252.19769614@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 Mar 2013 12:22:52 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> > On the W7 driver, I don't get any of the above mentioned problems.
> > 
> > I looked at the saa7113 register init sequence, and copied that
> > over to linux saa7113 init, but that did not remove the problems.
> > There were only few changes.
> 
> So, maybe it does a different crop setup at em28xx.

I did an analysis of the register setups of em28xx and found the
following differences:

1. Different crop settings

EM28XX_R1D_VSTART, EM28XX_R1F_CHEIGHT and EM28XX_R2B_YMAX set by W7
driver were divided by two compared to the linux driver. Seems that
linux driver did just this before commit c2a6b54.  I also found the
patch https://patchwork.kernel.org/patch/1272051/ to restore the
original behaviour, but somehow it was disregarded and commit 0bc9c89
was done instead. The mentioned patch though does not fix R1D setting
though.

2. Different outfmt used

It seems that ffmpeg defaults to v4l default, which somehow apparently
resulted in EM28XX_OUTFMT_RGB_8_RGRG set. When forcing ffmpeg to set
yuyv422 or EM28XX_OUTFMT_YUV422_Y0UY1V the color distortions vanished.
I'm unsure if the distiortion comes from ffmpeg doing some automatic
conversions, or from v4l kernel driver.

Though, it might be an idea to set the default outfmt to something that
is known to work. So I'm wondering if this could be fixed easily?
YUYV422 should have also better quality, so it would make sense to
select it instead of the other one.

--

So seems that now the device is working properly. Basically we need the
following changes:
 1. saa7113 id ignore (or autodetect, and fallback to forced type)
 2. saa7113 not writing to the registers 14-17 in case it's not the
    original chip (id not present)
 3. em28xx crop height/vstart to divided by 2 in interlaced mode
 4. (optionally) em28xx outfmt should default to YUYV422

I can post a patch for 3, but for others I'm not fully certain about
implementation details. With few pointers, I could probably produce
patches, though. But I would be also happy to just test what ever you
come up with.

Thanks,
 Timo
