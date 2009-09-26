Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42318 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZIZWVv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 18:21:51 -0400
Received: by fxm18 with SMTP id 18so2938439fxm.17
        for <linux-media@vger.kernel.org>; Sat, 26 Sep 2009 15:21:53 -0700 (PDT)
Date: Sun, 27 Sep 2009 01:21:49 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: Re: [PATCH] cx25840 6.5MHz carrier detection fixes
Message-ID: <20090926222149.GA4275@moon>
References: <20090925211621.GA15452@moon> <1253995979.3156.31.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253995979.3156.31.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 26, 2009 at 04:12:59PM -0400, Andy Walls wrote:
> On Sat, 2009-09-26 at 00:16 +0300, Aleksandr V. Piskunov wrote:
> > cx25840:
> > Disable 6.5MHz carrier autodetection for PAL, always assume its DK.
> > Only try to autodetect 6.5MHz carrier for SECAM if user accepts both
> > system DK and L.
> > 
> > Signed-off-by: Aleksandr V. Piskunov <alexandr.v.piskunov@gmail.com>
> 
> Aleksandr,
> 
> I would like a little more time to look at your patch.

PAL part of the patch shouldn't affect any users IMHO, its the SECAM
part where we got SECAM-L users in France and SECAM-DK in Russia.

> 
> However, in the mean time, could you test the DK vs. L autodetection,
> without your patch, using the cx25840 firmware in
> 
> http://dl.ivtvdriver.org/ivtv/firmware/ivtv-firmware-20070217.tar.gz
> 
> ?
> 
> The MD5 sum of that firmware is:
> 
> $ md5sum /lib/firmware/v4l-cx25840.fw 
> 99836e41ccb28c7b373e87686f93712a  /lib/firmware/v4l-cx25840.fw
> 
> The cx25840 firmware in
> 
> http://dl.ivtvdriver.org/ivtv/firmware/ivtv-firmware-20080701.tar.gz
> http://dl.ivtvdriver.org/ivtv/firmware/ivtv-firmware.tar.gz
> 
> is probably wrong to use for the CX2584[0123] chips as it it actually
> CX23148 A/V core firmware - very similar but not the same.
> 

Tested following versions of v4l-cx25840.fw, no patch:

99836e41ccb28c7b373e87686f93712a
b3704908fd058485f3ef136941b2e513
647d818c6fc82f385ebfbbd4fb2def6d (comes as makoaudc.rom with win driver)

Same issue with all 3 versions of firmware tested, cold shutdown between
every test.
Quick description: PAL-DK source from cable, strong and clear signal.
On channel switch there are 3 typical outcomes
a) ~50% - DK audio system detected
b) ~40 - controller fails to detect standard, muted, may detect
   something later
c) ~10% - AM-L audio detected, playing some bogus static, may detect DK
   later

Of course there is a possibility that CX25843 doesn't like something
in IF that comes from xc2028 tuner, but as I said, signal ir very good
and picture/audio on every of 50+ channels is crisp and clear.
