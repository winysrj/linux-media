Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60520 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751758AbcKZNQK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 08:16:10 -0500
Date: Sat, 26 Nov 2016 14:16:02 +0100
From: Pavel Machek <pavel@denx.de>
To: Matt Ranostay <matt@ranostay.consulting>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Attila Kinali <attila@kinali.ch>, Marek Vasut <marex@denx.de>
Subject: Re: [RFC] v4l2 support for thermopile devices
Message-ID: <20161126131602.GC20568@xo-6d-61-c0.localdomain>
References: <CAJ_EiSRM=zn--oFV=7YTE-kipP_ctT2sgSzv64bGrh_MNJbYaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ_EiSRM=zn--oFV=7YTE-kipP_ctT2sgSzv64bGrh_MNJbYaQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> So want to toss a few thoughts on adding support for thermopile
> devices (could be used for FLIR Lepton as well) that output pixel
> data.
> These typically aren't DMA'able devices since they are low speed
> (partly to limiting the functionality to be in compliance with ITAR)
> and data is piped over i2c/spi.
> 
> My question is that there doesn't seem to be an other driver that
> polls frames off of a device and pushes it to the video buffer, and
> wanted to be sure that this doesn't currently exist somewhere.
> 
> Also more importantly does the mailing list thinks it belongs in v4l2?
> We already came up the opinion on the IIO list that it doesn't belong
> in that subsystem since pushing raw pixel data to a buffer is a bit
> hacky. Also could be generically written with regmap so other devices
> (namely FLIR Lepton) could be easily supported.
> 
> Need some input for the video pixel data types, which the device we
> are using (see datasheet links below) is outputting pixel data in
> little endian 16-bit of which a 12-bits signed value is used.  Does it
> make sense to do some basic processing on the data since greyscale is
> going to look weird with temperatures under 0C degrees? Namely a cold
> object is going to be brighter than the hottest object it could read.
> Or should a new V4L2_PIX_FMT_* be defined and processing done in
> software?  Another issue is how to report the scaling value of 0.25 C
> for each LSB of the pixels to the respecting recording application.

Should we get some kind of flag saying "this is deep infrared"? Most software 
won't care, but it would be nice to have enough information so that userspace
can do the right thing automatically...

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
