Return-path: <linux-media-owner@vger.kernel.org>
Received: from ao2.it ([92.243.12.208]:51109 "EHLO ao2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754272AbcKCID3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 04:03:29 -0400
Date: Thu, 3 Nov 2016 08:35:33 +0100
From: Antonio Ospite <ao2@ao2.it>
To: Matt Ranostay <matt@ranostay.consulting>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Attila Kinali <attila@kinali.ch>, Marek Vasut <marex@denx.de>
Subject: Re: [RFC] v4l2 support for thermopile devices
Message-Id: <20161103083533.9ebc9c88d883b09bf16d44c0@ao2.it>
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

> On Fri, Oct 28, 2016 at 7:59 PM, Matt Ranostay <matt@ranostay.consulting> wrote:
> > On Fri, Oct 28, 2016 at 2:53 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> Hi Matt,
> >>
> >> On 28/10/16 22:14, Matt Ranostay wrote:
> >>>
> >>> So want to toss a few thoughts on adding support for thermopile
> >>> devices (could be used for FLIR Lepton as well) that output pixel
> >>> data.
> >>> These typically aren't DMA'able devices since they are low speed
> >>> (partly to limiting the functionality to be in compliance with ITAR)
> >>> and data is piped over i2c/spi.
> >>>
> >>> My question is that there doesn't seem to be an other driver that
> >>> polls frames off of a device and pushes it to the video buffer, and
> >>> wanted to be sure that this doesn't currently exist somewhere.
> >>
> >>
> >> Not anymore, but if you go back to kernel 3.6 then you'll find this driver:
> >>
> >> drivers/media/video/bw-qcam.c
> >>
> >> It was for a grayscale parallel port webcam (which explains why it was
> >> removed in 3.7 :-) ), and it used polling to get the pixels.
> >
> > Yikes parallel port, but I'll take a look at that for some reference :)
> 
> 
> So does anyone know of any software that is using V4L2_PIX_FMT_Y12
> currently? Want to test my driver but seems there isn't anything that
> uses that format (ffmpeg, mplayer, etc).
> 
> Raw data seems correct but would like to visualize it :). Suspect I'll
> need to write a test case application though
> 

You could add a conversion routine in libv4lconvert from v4l-utils to
have a grayscale representation of Y12, I did something similar for the
kinect depth map, discarding the least significant bits:

https://git.linuxtv.org/v4l-utils.git/commit/lib/libv4lconvert?id=6daa2b1ce8674bda66b0f3bb5cf08089e42579fd

After that any v4l2 program using libv4l2 will at least be able to show
_an_ image.

You can play with "false color" representations too in libv4lconvert,
however I don't know if such representations are generic enough to be
mainlined, in the Kinect case the false color representation of the
depth map was done in specialized software like libfreenect.

Ciao,
   Antonio

-- 
Antonio Ospite
https://ao2.it
https://twitter.com/ao2it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
