Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37739 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751187AbdGONNr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 09:13:47 -0400
Received: by mail-wm0-f45.google.com with SMTP id b134so9437871wma.0
        for <linux-media@vger.kernel.org>; Sat, 15 Jul 2017 06:13:47 -0700 (PDT)
Message-ID: <1500124425.25393.3.camel@gmail.com>
Subject: Re: [PATCH 3/3] [media] uvcvideo: skip non-extension unit controls
 on Oculus Rift Sensors
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Sat, 15 Jul 2017 15:13:45 +0200
In-Reply-To: <1988392.8ZGCFRfgf9@avalon>
References: <20170714201424.23592-1-philipp.zabel@gmail.com>
         <20170714201424.23592-3-philipp.zabel@gmail.com>
         <1988392.8ZGCFRfgf9@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 15.07.2017, 12:54 +0300 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> Thank you for the patch.
> 
> On Friday 14 Jul 2017 22:14:24 Philipp Zabel wrote:
> > The Oculus Rift Sensors (DK2 and CV1) allow to configure their sensor chips
> > directly via I2C commands using extension unit controls. The processing and
> > camera unit controls do not function at all.
> 
> Do the processing and camera units they report controls that don't work when 
> exercised ? Who in a sane state of mind could have designed such a terrible 
> product ?

Yes. Without this patch I get a bunch of controls that have no effect
whatsoever.

> If I understand you correctly, this device requires userspace code that knows 
> how to program the sensor (and possibly other chips). If that's the case, is 
> there an open-source implementation of that code publicly available ?

Well, it's all still a bit in the experimentation phase. We have an
implementation to set up the DK2 camera for synchronised exposure
triggered by the Rift DK2 HMD and to read the calibration data from
flash, here:

https://github.com/pH5/ouvrt/blob/master/src/esp570.c
https://github.com/pH5/ouvrt/blob/master/src/mt9v034.c

And an even more rough version to set up the CV1 camera for
synchronised exposure triggered by the Rift CV1 HMD here:

https://github.com/OpenHMD/OpenHMD-RiftPlayground/blob/master/src/main.c

The latter is using libusb, as it needs the variable length SPI data
control.

Do you think adding a pseudo i2c driver for the eSP570/eSP770u webcam
controllers and then exposing the sensor chips as V4L2 subdevices could
be a good idea? We already have a sensor driver for the MT9V034 in the
DK2 USB camera.

regards
Philipp
