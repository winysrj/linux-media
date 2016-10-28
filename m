Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:36723 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755830AbcJ1UPG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Oct 2016 16:15:06 -0400
Received: by mail-qt0-f178.google.com with SMTP id w33so1612407qtc.3
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2016 13:14:18 -0700 (PDT)
MIME-Version: 1.0
From: Matt Ranostay <matt@ranostay.consulting>
Date: Fri, 28 Oct 2016 13:14:17 -0700
Message-ID: <CAJ_EiSRM=zn--oFV=7YTE-kipP_ctT2sgSzv64bGrh_MNJbYaQ@mail.gmail.com>
Subject: [RFC] v4l2 support for thermopile devices
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Cc: Attila Kinali <attila@kinali.ch>, Marek Vasut <marex@denx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So want to toss a few thoughts on adding support for thermopile
devices (could be used for FLIR Lepton as well) that output pixel
data.
These typically aren't DMA'able devices since they are low speed
(partly to limiting the functionality to be in compliance with ITAR)
and data is piped over i2c/spi.

My question is that there doesn't seem to be an other driver that
polls frames off of a device and pushes it to the video buffer, and
wanted to be sure that this doesn't currently exist somewhere.

Also more importantly does the mailing list thinks it belongs in v4l2?
We already came up the opinion on the IIO list that it doesn't belong
in that subsystem since pushing raw pixel data to a buffer is a bit
hacky. Also could be generically written with regmap so other devices
(namely FLIR Lepton) could be easily supported.

Need some input for the video pixel data types, which the device we
are using (see datasheet links below) is outputting pixel data in
little endian 16-bit of which a 12-bits signed value is used.  Does it
make sense to do some basic processing on the data since greyscale is
going to look weird with temperatures under 0C degrees? Namely a cold
object is going to be brighter than the hottest object it could read.
Or should a new V4L2_PIX_FMT_* be defined and processing done in
software?  Another issue is how to report the scaling value of 0.25 C
for each LSB of the pixels to the respecting recording application.

Datasheet: http://media.digikey.com/pdf/Data%20Sheets/Panasonic%20Sensors%20PDFs/Grid-EYE_AMG88.pdf
Datasheet: https://eewiki.net/download/attachments/13599167/Grid-EYE%20SPECIFICATIONS%28Reference%29.pdf?version=1&modificationDate=1380660426690&api=v2

Thanks,

Matt
