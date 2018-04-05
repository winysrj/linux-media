Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34942 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbeDEIWJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 04:22:09 -0400
Received: by mail-vk0-f43.google.com with SMTP id h134so13986917vke.2
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2018 01:22:09 -0700 (PDT)
Received: from mail-vk0-f52.google.com (mail-vk0-f52.google.com. [209.85.213.52])
        by smtp.gmail.com with ESMTPSA id d13sm3685221uan.6.2018.04.05.01.22.07
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Apr 2018 01:22:07 -0700 (PDT)
Received: by mail-vk0-f52.google.com with SMTP id b16so13969729vka.5
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2018 01:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <1519402422-9595-1-git-send-email-andy.yeh@intel.com>
 <1519402422-9595-3-git-send-email-andy.yeh@intel.com> <CAL_JsqKd8dxF1eSkST1GyKCS_bkzALv2aGHC9TXHWfnrxx33SQ@mail.gmail.com>
 <20180228133126.cusxnid64xd5uawu@paasikivi.fi.intel.com> <20180302185900.cj4hpt5qqinhyvnt@rob-hp-laptop>
 <20180302201457.ia6egjlxa5zmuwmd@kekkonen.localdomain>
In-Reply-To: <20180302201457.ia6egjlxa5zmuwmd@kekkonen.localdomain>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 05 Apr 2018 08:21:56 +0000
Message-ID: <CAAFQd5AcWpkemhXDwqjvhAxKdBxK1B_XuNZmzDJvpAY_TtNuPw@mail.gmail.com>
Subject: Re: [v5 2/2] media: dt-bindings: Add bindings for Dongwoon DW9807
 voice coil
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Rob Herring <robh@kernel.org>, "Yeh, Andy" <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org, Alan Chiang <alanx.chiang@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 3, 2018 at 5:15 AM Sakari Ailus <sakari.ailus@linux.intel.com>
wrote:

> On Fri, Mar 02, 2018 at 12:59:00PM -0600, Rob Herring wrote:
> > On Wed, Feb 28, 2018 at 03:31:26PM +0200, Sakari Ailus wrote:
> > > Hi Rob,
> > >
> > > Thanks for the review.
> > >
> > > On Tue, Feb 27, 2018 at 04:10:31PM -0600, Rob Herring wrote:
> > > > On Fri, Feb 23, 2018 at 10:13 AM, Andy Yeh <andy.yeh@intel.com>
wrote:
> > > > > From: Alan Chiang <alanx.chiang@intel.com>
> > > > >
> > > > > Dongwoon DW9807 is a voice coil lens driver.
> > > > >
> > > > > Also add a vendor prefix for Dongwoon for one did not exist
previously.
> > > >
> > > > Where's that?
> > >
> > > Added by aece98a912d92444ea9da03b04269407d1308f1f . So that line isn't
> > > relevant indeed and should be removed.
> > >
> > > >
> > > > >
> > > > > Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> > > > > ---
> > > > >  Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
| 9 +++++++++
> > > >
> > > > DACs generally go in bindings/iio/dac/
> > >
> > > We have quite a few lens voice coil drivers under bindings/media/i2c
now. I
> > > don't really object to putting this one to bindings/iio/dac but then
the
> > > rest should be moved as well.
> > >
> > > The camera LED flash drivers are under bindings/leds so this would
actually
> > > be analoguous to that. The lens voice coil drivers are perhaps still
a bit
> > > more bound to the domain (camera) than the LED flash drivers.
> >
> > The h/w is bound to that function or just the s/w?

> The hardware. I guess in principle you could use them for other purposes
> --- most devices seem to be current sinks with configurable current ---
but
> I've never seen that.

> The datasheet (dw9714) is here:

> <URL:http://www.datasheetspdf.com/datasheet/download.php?id=840322>

> >
> > > I can send a patch if you think the existing bindings should be
moved; let
> > > me know.
> >
> > I'm okay if they are separate as long as we're not going to see the
> > same device show up in both places. However, "i2c" is not the best

> Ack. I wouldn't expect that. The datasheets of such devices clearly label
> the devices voice coil module drivers.

> > directory choice. It should be by function, so we can find common
> > properties.

> I2c devices in the media subsystem tend to be peripherals that are always
> used with another device with access to some system bus. Camera sensors,
lens
> devices and tuners can be found there currently. I don't know the original
> reasoning but it most likely is related to that.

> In terms of different kinds of devices we have currently at least the
> following:

>          Camera ISPs and CSI-2 receivers
>          Video muxes
>          Video codecs
>          Camera sensors
>          Camera lens drivers (right now only voice coil modules?)
>          Tuners (DVB, radio, analogue TV, whatever)
>          Radio transmitters
>          HDMI CEC
>          Remote controllers
>          JPEG codecs

> Cc Hans, too.

Any updates here?

To be honest, I'm not sure there is too much to be thinking about here.
This particular hardware block is a lens driver, specifically designed to
be used with cameras. Quoting maker's website [1]:

   "Driver ICs for automatically focus on images of mobile cameras.
    Dongwoon Anatech's AF driver ICs are optimized mobile cameras
    with low power, low noise, smallest package, as well as include
    various lens position control methodology."

IMHO putting its bindings under the more general purpose iio/ directory
doesn't make much sense and would be actually confusing.

[1] http://www.dwanatech.com/eng/sub/sub02_01.php?cat_no=6

Best regards,
Tomasz
