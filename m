Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:57493 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbeHBLCp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Aug 2018 07:02:45 -0400
Subject: Re: [PATCH 00/13] Better handle pads for tuning/decoder part of the
 devices
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>,
        Brian Warner <brian.warner@samsung.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antti Palosaari <crope@iki.fi>,
        Nasser Afshin <afshin.nasser@gmail.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2a14ce78-8a5d-be0d-1ff4-614fe128814f@xs4all.nl>
Date: Thu, 2 Aug 2018 11:12:23 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1533138685.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/01/18 17:55, Mauro Carvalho Chehab wrote:
> At PC consumer devices, it is very common that the bridge same driver 
> to be attached to different types of tuners and demods. We need a way
> for the Kernel to properly identify what kind of signal is provided by each
> PAD, in order to properly setup the pipelines.
> 
> The previous approach were to hardcode a fixed number of PADs for all
> elements of the same type. This is not good, as different devices may 
> actually have a different number of pads.
> 
> It was acceptable in the past, as there were a promisse of adding "soon"
> a properties API that would allow to identify the type for each PADs, but
> this was never merged (or even a patchset got submitted).
> 
> So, replace this approach by another one: add a "taint" mark to pads that
> contain different types of signals.
> 
> I tried to minimize the number of signals, in order to make it simpler to
> convert from the past way.
> 
> For now, it is tested only with a simple grabber device. I intend to do
> more tests before merging it, but it would be interesting to have this
> merged for Kernel 4.19, as we'll now be exposing the pad index via
> the MC API version 2.

Other than a small comment for the last patch I didn't see anything
problematical in this series. It doesn't touch on the public API or
on any of the non-tuner drivers. So for patches 1-12:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

And after adding back the documentation for the enums in patch 13 you
can add my Ack to that one as well.

Regards,

	Hans

> 
> Mauro Carvalho Chehab (13):
>   media: v4l2: remove VBI output pad
>   media: v4l2: taint pads with the signal types for consumer devices
>   v4l2-mc: switch it to use the new approach to setup pipelines
>   media: dvb: use signals to discover pads
>   media: au0828: use signals instead of hardcoding a pad number
>   media: au8522: declare its own pads
>   media: msp3400: declare its own pads
>   media: saa7115: declare its own pads
>   media: tvp5150: declare its own pads
>   media: si2157: declare its own pads
>   media: saa7134: declare its own pads
>   media: mxl111sf: declare its own pads
>   media: v4l2-mc: get rid of global pad indexes
> 
>  drivers/media/dvb-core/dvbdev.c              | 19 +++--
>  drivers/media/dvb-frontends/au8522_decoder.c | 10 ++-
>  drivers/media/dvb-frontends/au8522_priv.h    |  9 ++-
>  drivers/media/i2c/msp3400-driver.c           |  6 +-
>  drivers/media/i2c/msp3400-driver.h           |  8 +-
>  drivers/media/i2c/saa7115.c                  | 18 +++--
>  drivers/media/i2c/tvp5150.c                  | 21 ++++--
>  drivers/media/media-entity.c                 | 26 +++++++
>  drivers/media/pci/saa7134/saa7134-core.c     |  9 ++-
>  drivers/media/pci/saa7134/saa7134.h          |  8 +-
>  drivers/media/tuners/si2157.c                | 11 ++-
>  drivers/media/tuners/si2157_priv.h           |  9 ++-
>  drivers/media/usb/au0828/au0828-core.c       | 12 +--
>  drivers/media/usb/dvb-usb-v2/mxl111sf.c      |  8 +-
>  drivers/media/usb/dvb-usb-v2/mxl111sf.h      |  8 +-
>  drivers/media/v4l2-core/tuner-core.c         | 18 +++++
>  drivers/media/v4l2-core/v4l2-mc.c            | 73 +++++++++++++-----
>  include/media/media-entity.h                 | 54 ++++++++++++++
>  include/media/v4l2-mc.h                      | 78 --------------------
>  19 files changed, 266 insertions(+), 139 deletions(-)
> 
