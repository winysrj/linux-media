Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34258 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdGXFwZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 01:52:25 -0400
Received: by mail-wm0-f52.google.com with SMTP id l81so16546484wmg.1
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 22:52:24 -0700 (PDT)
Message-ID: <1500875542.24053.1.camel@gmail.com>
Subject: Re: [PATCH 3/3] [media] uvcvideo: skip non-extension unit controls
 on Oculus Rift Sensors
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Mon, 24 Jul 2017 07:52:22 +0200
In-Reply-To: <1692289.IcaTpD3SF0@avalon>
References: <20170714201424.23592-1-philipp.zabel@gmail.com>
         <1988392.8ZGCFRfgf9@avalon> <1500124425.25393.3.camel@gmail.com>
         <1692289.IcaTpD3SF0@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Montag, den 17.07.2017, 05:25 +0300 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> On Saturday 15 Jul 2017 15:13:45 Philipp Zabel wrote:
> > Am Samstag, den 15.07.2017, 12:54 +0300 schrieb Laurent Pinchart:
> > > On Friday 14 Jul 2017 22:14:24 Philipp Zabel wrote:
> > > > The Oculus Rift Sensors (DK2 and CV1) allow to configure their
> > > > sensor
> > > > chips directly via I2C commands using extension unit controls.
> > > > The
> > > > processing and camera unit controls do not function at all.
> > > 
> > > Do the processing and camera units they report controls that
> > > don't work
> > > when  exercised ? Who in a sane state of mind could have designed
> > > such a
> > > terrible product ?
> > 
> > Yes. Without this patch I get a bunch of controls that have no
> > effect
> > whatsoever.
> > 
> > > If I understand you correctly, this device requires userspace
> > > code that
> > > knows  how to program the sensor (and possibly other chips). If
> > > that's
> > > the case, is there an open-source implementation of that code
> > > publicly
> > > available ?
> > 
> > Well, it's all still a bit in the experimentation phase. We have an
> > implementation to set up the DK2 camera for synchronised exposure
> > triggered by the Rift DK2 HMD and to read the calibration data from
> > flash, here:
> > 
> > https://github.com/pH5/ouvrt/blob/master/src/esp570.c
> > https://github.com/pH5/ouvrt/blob/master/src/mt9v034.c
> > 
> > And an even more rough version to set up the CV1 camera for
> > synchronised exposure triggered by the Rift CV1 HMD here:
> > 
> > https://github.com/OpenHMD/OpenHMD-RiftPlayground/blob/master/src/m
> > ain.c
> > 
> > The latter is using libusb, as it needs the variable length SPI
> > data
> > control.
> > 
> > Do you think adding a pseudo i2c driver for the eSP570/eSP770u
> > webcam
> > controllers and then exposing the sensor chips as V4L2 subdevices
> > could
> > be a good idea? We already have a sensor driver for the MT9V034 in
> > the
> > DK2 USB camera.
> 
> Yes, I think a device-specific driver would make sense, especially if
> we can 
> implement support for the sensor as a standalone V4L2 subdev driver.
> The 
> device only fakes UVC compatibility :-(

When you say standalone driver, do you mean I can reuse uvcvideo
device/stream/chain handling, and just replace the control handling?

I'll try this, but it isn't a straightforward as I initially thought.
For example, the mt9v032 subdev driver expects to have control over
power during probe and s_power. But in this case power is controlled by
UVC streaming. I'd either have to modify the subdev driver to support a
passive mode or fake the chip id register reads in the i2c adapter
driver to make mt9v032 probe at all.

Do you have any further comments on the first two patches?

regards
Philipp
