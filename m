Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53195 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751161AbdH1OPg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 10:15:36 -0400
Subject: Re: [RFC 0/2] BCM283x Camera Receiver driver
To: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <55eba688-5765-72dc-0984-7b642abaf38e@xs4all.nl>
Date: Mon, 28 Aug 2017 16:15:30 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

What is the status of this work? I ask because I tried to use this driver
plus my tc358743 on my rpi-2b without any luck. Specifically the tc358843
isn't able to read from the i2c bus.

This is probably a bug in my dts, if you have a tree somewhere containing
a working dts for this, then that would be very helpful.

Regards,

	Hans

On 14/06/17 17:15, Dave Stevenson wrote:
> Hi All.
> 
> This is adding a V4L2 subdevice driver for the CSI2/CCP2 camera
> receiver peripheral on BCM283x, as used on Raspberry Pi.
> 
> v4l2-compliance results depend on the sensor subdevice this is
> connected to. It passes the basic tests cleanly with TC358743,
> but objects with OV5647
> fail: v4l2-test-controls.cpp(574): g_ext_ctrls does not support count == 0
> Neither OV5647 nor Unicam support any controls.
> 
> I must admit to not having got OV5647 to stream with the current driver
> register settings. It works with a set of register settings for VGA RAW10.
> I also have a couple of patches pending for OV5647, but would like to
> understand the issues better before sending them out.
> 
> Two queries I do have in V4L2-land:
> - When s_dv_timings or s_std is called, is the format meant to
>   be updated automatically? Even if we're already streaming?
>   Some existing drivers seem to, but others don't.
> - With s_fmt, is sizeimage settable by the application in the same
>   way as bytesperline? yavta allows you to specify it on the command
>   line, whilst v4l2-ctl doesn't. Some of the other parts of the Pi
>   firmware have a requirement that the buffer is a multiple of 16 lines
>   high, which can be matched by V4L2 if we can over-allocate the
>   buffers by the app specifying sizeimage. But if I allow that,
>   then I get a v4l2-compliance failure as the size doesn't get
>   reset when switching from RGB3 to UYVY as it takes the request as
>   a request to over-allocate.
> 
> Apologies if I've messed up in sending these patches - so many ways
> to do something.
> 
> Thanks in advance.
>   Dave
> 
> Dave Stevenson (2):
>   [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
>   [media] bcm2835-unicam: Driver for CCP2/CSI2 camera interface
> 
>  .../devicetree/bindings/media/bcm2835-unicam.txt   |   76 +
>  drivers/media/platform/Kconfig                     |    1 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/bcm2835/Kconfig             |   14 +
>  drivers/media/platform/bcm2835/Makefile            |    3 +
>  drivers/media/platform/bcm2835/bcm2835-unicam.c    | 2100 ++++++++++++++++++++
>  drivers/media/platform/bcm2835/vc4-regs-unicam.h   |  257 +++
>  7 files changed, 2453 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>  create mode 100644 drivers/media/platform/bcm2835/Kconfig
>  create mode 100644 drivers/media/platform/bcm2835/Makefile
>  create mode 100644 drivers/media/platform/bcm2835/bcm2835-unicam.c
>  create mode 100644 drivers/media/platform/bcm2835/vc4-regs-unicam.h
> 
