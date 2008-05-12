Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CIQ0R1017005
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 14:26:00 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4CIPnFO020192
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 14:25:49 -0400
Date: Mon, 12 May 2008 20:25:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Darius <augulis.darius@gmail.com>
In-Reply-To: <g08tjl$uqt$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0805121909130.5526@axis700.grange>
References: <g08tjl$uqt$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] driver model for camera sensors
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, 12 May 2008, Darius wrote:

> in 2.6.26-rc1 today we have soc-camera driver and two drivers for Micron
> cameras in this new driver model. But there are few old drivers for OmniVision
> cameras, and they do not work with soc-camera driver model.
> In other side, these two new Micron drivers does not work with old interface.
> So, we have the same sensors on different busses (soc, usb) and we need two
> different drivers for the same sensor. I thing it's a good idea to make all
> camera sensor drivers in unified model, that would be able to work on both
> busses (usb, soc).
> Now I need driver for OV7670 sensor and I want to write it correct form.
> I think sensor driver should be universal and configurable. It should be able
> interface with v4l2 through soc-camera or usb bus.
> I suggest to put all sensor drivers in separate directory in kernel tree.
> 
> Am I rigth? Please comment my opinion.

The soc-camera subsystem implements the following interfaces:

               user-space
                    |
               [V4L2 API]
                    |
             soc-camera core
                |       |
               /         \
        [sensor API]  [adapter API]
             /             \
camera sensor driver   camera adapter driver
           /                 \
      [e.g. I2C]      [e.g. platform driver]

Now, I think, you could write a camera driver, for example, for a 
USB-camera, and implement the sensor API from above to talk to the sensor. 
But, the interesting question what you do with the other interface - i2c 
in this case? As far as I can see, there are several drivers in the kernel 
ATM, that do this right: they export a (USB) i2c adapter to the kernel. 
Some others, I think, like the ov511.c, implement i2c operations over USB 
internally, which, certainly, cannot work with an external i2c sensor 
driver. So, in your USB camera driver you have to implement an i2c adapter 
driver, call i2c_new_device() for the i2c sensor chip as a part of your 
probe, and use the sensor API to talk to the sensor itself.

If the sensor API has to be extended / modified - this can be relatively 
easily done as long as there are still not too many users in the mainline.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
