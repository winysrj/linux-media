Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57456 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751864AbdGXXKr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 19:10:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] uvcvideo: skip non-extension unit controls on Oculus Rift Sensors
Date: Tue, 25 Jul 2017 02:10:57 +0300
Message-ID: <3802589.DtyKMB5Jay@avalon>
In-Reply-To: <1500875542.24053.1.camel@gmail.com>
References: <20170714201424.23592-1-philipp.zabel@gmail.com> <1692289.IcaTpD3SF0@avalon> <1500875542.24053.1.camel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Monday 24 Jul 2017 07:52:22 Philipp Zabel wrote:
> Am Montag, den 17.07.2017, 05:25 +0300 schrieb Laurent Pinchart:
> > On Saturday 15 Jul 2017 15:13:45 Philipp Zabel wrote:
> >> Am Samstag, den 15.07.2017, 12:54 +0300 schrieb Laurent Pinchart:
> >>> On Friday 14 Jul 2017 22:14:24 Philipp Zabel wrote:
> >>>> The Oculus Rift Sensors (DK2 and CV1) allow to configure their
> >>>> sensor chips directly via I2C commands using extension unit
> >>>> controls. The processing and camera unit controls do not function at
> >>>> all.
> >>> 
> >>> Do the processing and camera units they report controls that
> >>> don't work when  exercised ? Who in a sane state of mind could have
> >>> designed such a terrible product ?
> >> 
> >> Yes. Without this patch I get a bunch of controls that have no
> >> effect whatsoever.
> >> 
> >>> If I understand you correctly, this device requires userspace
> >>> code that knows  how to program the sensor (and possibly other chips).
> >>> If that's the case, is there an open-source implementation of that
> >>> code publicly available ?
> >> 
> >> Well, it's all still a bit in the experimentation phase. We have an
> >> implementation to set up the DK2 camera for synchronised exposure
> >> triggered by the Rift DK2 HMD and to read the calibration data from
> >> flash, here:
> >> 
> >> https://github.com/pH5/ouvrt/blob/master/src/esp570.c
> >> https://github.com/pH5/ouvrt/blob/master/src/mt9v034.c
> >> 
> >> And an even more rough version to set up the CV1 camera for
> >> synchronised exposure triggered by the Rift CV1 HMD here:
> >> 
> >> https://github.com/OpenHMD/OpenHMD-RiftPlayground/blob/master/src/m
> >> ain.c
> >> 
> >> The latter is using libusb, as it needs the variable length SPI
> >> data control.
> >> 
> >> Do you think adding a pseudo i2c driver for the eSP570/eSP770u
> >> webcam controllers and then exposing the sensor chips as V4L2 subdevices
> >> could be a good idea? We already have a sensor driver for the MT9V034 in
> >> the DK2 USB camera.
> > 
> > Yes, I think a device-specific driver would make sense, especially if
> > we can implement support for the sensor as a standalone V4L2 subdev
> > driver. The device only fakes UVC compatibility :-(
> 
> When you say standalone driver, do you mean I can reuse uvcvideo
> device/stream/chain handling, and just replace the control handling?

No, I mean a completely separate driver. Given that the driver will be used 
for a single device, you can hardcode lots of assumptions and don't have to 
parse UVC descriptors.

> I'll try this, but it isn't a straightforward as I initially thought.
> For example, the mt9v032 subdev driver expects to have control over
> power during probe and s_power. But in this case power is controlled by
> UVC streaming.

How does that work with the device ? If the sensor is powered off until you 
start video streaming, I assume it won't reply to I2C commands. Do you need to 
configure it after stream start ?

> I'd either have to modify the subdev driver to support a passive mode or
> fake the chip id register reads in the i2c adapter driver to make mt9v032
> probe at all.
> 
> Do you have any further comments on the first two patches?

Just that those patches are not needed if we implement a driver specific to 
the Oculus Rift :-)

-- 
Regards,

Laurent Pinchart
