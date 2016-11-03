Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dogan.ch ([77.109.151.89]:19075 "EHLO mail.dogan.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755124AbcKCNan (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 09:30:43 -0400
Date: Thu, 3 Nov 2016 14:21:34 +0100
From: Attila Kinali <attila@kinali.ch>
To: Matt Ranostay <matt@ranostay.consulting>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Marek Vasut <marex@denx.de>, Luca Barbato <lu_zero@gentoo.org>
Subject: Re: [RFC] v4l2 support for thermopile devices
Message-Id: <20161103142134.4a59dfc34c593391086c0508@kinali.ch>
In-Reply-To: <CAJ_EiSQRai=XqOryMW1WLKvFDPZUVVmkjXSF3TyxpPNMsVsR_Q@mail.gmail.com>
References: <CAJ_EiSRM=zn--oFV=7YTE-kipP_ctT2sgSzv64bGrh_MNJbYaQ@mail.gmail.com>
        <767cacf5-5f91-2596-90ef-31358b8e1db9@xs4all.nl>
        <CAJ_EiSQ-yf7hmnz1qqOAA-XcByCq9f12z=7h=+rCeWQbua+dOg@mail.gmail.com>
        <CAJ_EiSQRai=XqOryMW1WLKvFDPZUVVmkjXSF3TyxpPNMsVsR_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2 Nov 2016 23:10:41 -0700
Matt Ranostay <matt@ranostay.consulting> wrote:

> 
> So does anyone know of any software that is using V4L2_PIX_FMT_Y12
> currently? Want to test my driver but seems there isn't anything that
> uses that format (ffmpeg, mplayer, etc).
> 
> Raw data seems correct but would like to visualize it :). Suspect I'll
> need to write a test case application though

I was pretty sure that MPlayer supports 12bit greyscale, but I cannot
find where it was handled. You can of course pass it to the MPlayer
internas as 8bit greyscale, which would be IMGFMT_Y8 or just pass
it on as 16bit which would be IMGFMT_Y16_LE (LE = little endian).

You can find the internal #defines of the image formats in
libmpcodecs/img_format.h and can use https://www.fourcc.org/yuv.php
to decode their meaning.

The equivalent for libav would be libavutil/pixfmt.h

Luca Barbato tells me that adding Y12 support to libav would be easy.

			Attila Kinali

-- 
It is upon moral qualities that a society is ultimately founded. All 
the prosperity and technological sophistication in the world is of no 
use without that foundation.
                 -- Miss Matheson, The Diamond Age, Neil Stephenson
