Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38715 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdGYFvV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 01:51:21 -0400
Received: by mail-wm0-f53.google.com with SMTP id m85so33077763wma.1
        for <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 22:51:20 -0700 (PDT)
Message-ID: <1500961877.4366.1.camel@gmail.com>
Subject: Re: [PATCH 3/3] [media] uvcvideo: skip non-extension unit controls
 on Oculus Rift Sensors
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Tue, 25 Jul 2017 07:51:17 +0200
In-Reply-To: <3802589.DtyKMB5Jay@avalon>
References: <20170714201424.23592-1-philipp.zabel@gmail.com>
         <1692289.IcaTpD3SF0@avalon> <1500875542.24053.1.camel@gmail.com>
         <3802589.DtyKMB5Jay@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Dienstag, den 25.07.2017, 02:10 +0300 schrieb Laurent Pinchart:
> > > Yes, I think a device-specific driver would make sense, especially if
> > > we can implement support for the sensor as a standalone V4L2 subdev
> > > driver. The device only fakes UVC compatibility :-(
> > 
> > When you say standalone driver, do you mean I can reuse uvcvideo
> > device/stream/chain handling, and just replace the control handling?
> 
> No, I mean a completely separate driver. Given that the driver will be used 
> for a single device, you can hardcode lots of assumptions and don't have to 
> parse UVC descriptors.

I see, I was hoping I wouldn't have to (re)write all the video transfer
and timing parts myself.

> > I'll try this, but it isn't a straightforward as I initially thought.
> > For example, the mt9v032 subdev driver expects to have control over
> > power during probe and s_power. But in this case power is controlled by
> > UVC streaming.
> 
> How does that work with the device ? If the sensor is powered off until you 
> start video streaming, I assume it won't reply to I2C commands. Do you need to 
> configure it after stream start ?

Yes. The webcam controllers replay the stored initialization sequences
to the sensors on startup, like any other usb cameras, and start
streaming images. That is why I added them to uvcvideo in the first
place.

After the stream has started, I'd like to change the controls from the
defaults (enable AEC/AGC or increase gain for normal camera use, or
reduce gain and exposure time and enable trigger mode for Rift
tracking). Unfortunatley those can only be changed via I2C.

> > I'd either have to modify the subdev driver to support a passive mode or
> > fake the chip id register reads in the i2c adapter driver to make mt9v032
> > probe at all.
> > 
> > Do you have any further comments on the first two patches?
> 
> Just that those patches are not needed if we implement a driver specific to 
> the Oculus Rift :-)

Ok. I'll give that a shot then.

regards
Philipp
