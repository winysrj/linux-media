Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54320 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934925AbcKQRbm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 12:31:42 -0500
Date: Thu, 17 Nov 2016 19:31:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Matt Ranostay <matt@ranostay.consulting>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Attila Kinali <attila@kinali.ch>, Marek Vasut <marex@denx.de>
Subject: Re: [RFC] v4l2 support for thermopile devices
Message-ID: <20161117173136.GB13965@valkosipuli.retiisi.org.uk>
References: <CAJ_EiSRM=zn--oFV=7YTE-kipP_ctT2sgSzv64bGrh_MNJbYaQ@mail.gmail.com>
 <767cacf5-5f91-2596-90ef-31358b8e1db9@xs4all.nl>
 <CAJ_EiSQ-yf7hmnz1qqOAA-XcByCq9f12z=7h=+rCeWQbua+dOg@mail.gmail.com>
 <CAJ_EiSQRai=XqOryMW1WLKvFDPZUVVmkjXSF3TyxpPNMsVsR_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ_EiSQRai=XqOryMW1WLKvFDPZUVVmkjXSF3TyxpPNMsVsR_Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matt and Hans,,

On Wed, Nov 02, 2016 at 11:10:41PM -0700, Matt Ranostay wrote:
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

yavta can capture that, it doesn't convert it to anything else though.

<URL:http://git.ideasonboard.org/yavta.git>

> 
> Raw data seems correct but would like to visualize it :). Suspect I'll
> need to write a test case application though
> 
> 
> >
> >>
> >>> Also more importantly does the mailing list thinks it belongs in v4l2?
> >>
> >>
> >> I think it fits. It's a sensor, just with a very small resolution and
> >> infrared
> >> instead of visible light.

Agreed.

> >>
> >>> We already came up the opinion on the IIO list that it doesn't belong
> >>> in that subsystem since pushing raw pixel data to a buffer is a bit
> >>> hacky. Also could be generically written with regmap so other devices
> >>> (namely FLIR Lepton) could be easily supported.
> >>>
> >>> Need some input for the video pixel data types, which the device we
> >>> are using (see datasheet links below) is outputting pixel data in
> >>> little endian 16-bit of which a 12-bits signed value is used.  Does it
> >>> make sense to do some basic processing on the data since greyscale is
> >>> going to look weird with temperatures under 0C degrees? Namely a cold
> >>> object is going to be brighter than the hottest object it could read.
> >>
> >>
> >>> Or should a new V4L2_PIX_FMT_* be defined and processing done in
> >>> software?
> >>
> >>
> >> I would recommend that. It's no big deal, as long as the new format is
> >> documented.

Agreed; in general such conversion on CPU does not belong to drivers (but
e.g. libv4l).

> >>
> >>> Another issue is how to report the scaling value of 0.25 C
> >>> for each LSB of the pixels to the respecting recording application.
> >>
> >>
> >> Probably through a read-only control, but I'm not sure.

As this is the property of the format, I'd try to represent it as such. But
that's another discussion...

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
