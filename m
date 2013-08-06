Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:39295 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3HFNGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 09:06:34 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Syntek webcams and out-of-tree driver
Date: Tue, 6 Aug 2013 15:05:47 +0200
Cc: linux-media@vger.kernel.org,
	Jaime Velasco Juan <jsagarribay@gmail.com>,
	syntekdriver-devel@lists.sourceforge.net
References: <201308052319.26720.linux@rainbow-software.org> <5200935E.8080003@redhat.com>
In-Reply-To: <5200935E.8080003@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201308061505.47486.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 06 August 2013, Hans de Goede wrote:
> Hi,
>
> On 08/05/2013 11:19 PM, Ondrej Zary wrote:
> > Hello,
> > the in-kernel stkwebcam driver (by Jaime Velasco Juan and Nicolas VIVIEN)
> > supports only two webcam types (USB IDs 0x174f:0xa311 and 0x05e1:0x0501).
> > There are many other Syntek webcam types that are not supported by this
> > driver (such as 0x174f:0x6a31 in Asus F5RL laptop).
> >
> > There is an out-of-tree GPL driver called stk11xx (by Martin Roos and
> > also Nicolas VIVIEN) at http://sourceforge.net/projects/syntekdriver/
> > which supports more webcams. It can be even compiled for the latest
> > kernels using the patch below and seems to work somehow (slow and buggy
> > but better than nothing) with the Asus F5RL.
>
> I took a quick look and there are a number of issues with this driver:
>
> 1) It conflicts usb-id wise with the new stk1160 driver (which supports
> usb-id 05e1:0408) so support for that usb-id, and any code only used for
> that id will need to be removed
>
> 2) "seems to work somehow (slow and buggy)" is not really the quality
> we aim for with in kernel drivers. We definitely will want to remove
> any usb-ids, and any code only used for those ids, where there is overlap
> with the existing stkwebcam driver, to avoid regressions
>
> 3) It does in kernel bayer decoding, this is not acceptable, it needs to
> be modified to produce buffers with raw bayer data (libv4l will take care
> of the bater decoding in userspace).
>
> 4) It is not using any of the new kernel infrastructure we have been adding
> over time, like the control-framework, videobuf2, etc. It would be best
> to convert this to a gspca sub driver (of which there are many already,
> which can serve as examples), so that it will use all the existing
> framework code.

Yes, this would be the best way - only extract the HW-dependent parts.

> As a minimum issues 1-3 needs to be addressed before this can be merged. An
> alternative /  better approach might be to simply only lift the code for
> your camera, and add a new gspca driver supporting only your camera.
>
> Either way since non of the v4l developers have a laptop which such a
> camera, you will need to do most of the work yourself, as we cannot test.
>
> So congratulations, you've just become a v4l kernel developer :)

Unfortunately the laptop isn't mine. I'll have it only for a while but will 
try to do something.

> Regards,
>
> Hans
>
> > Is there any possibility that this driver could be merged into the
> > kernel? The code could probably be simplified a lot and integrated into
> > gspca.
> >
> >
> > diff -urp syntekdriver-code-107-trunk-orig/driver/stk11xx.h
> > syntekdriver-code-107-trunk//driver/stk11xx.h ---
> > syntekdriver-code-107-trunk-orig/driver/stk11xx.h	2012-03-10
> > 10:03:12.000000000 +0100 +++
> > syntekdriver-code-107-trunk//driver/stk11xx.h	2013-08-05
> > 22:50:00.000000000 +0200 @@ -33,6 +33,7 @@
> >
> >   #ifndef STK11XX_H
> >   #define STK11XX_H
> > +#include <media/v4l2-device.h>
> >
> >   #define DRIVER_NAME					"stk11xx"					/**< Name of this driver */
> >   #define DRIVER_VERSION				"v3.0.0"					/**< Version of this driver */
> > @@ -316,6 +317,7 @@ struct stk11xx_video {
> >    * @struct usb_stk11xx
> >    */
> >   struct usb_stk11xx {
> > +	struct v4l2_device v4l2_dev;
> >   	struct video_device *vdev; 			/**< Pointer on a V4L2 video device */
> >   	struct usb_device *udev;			/**< Pointer on a USB device */
> >   	struct usb_interface *interface;	/**< Pointer on a USB interface */
> > diff -urp syntekdriver-code-107-trunk-orig/driver/stk11xx-v4l.c
> > syntekdriver-code-107-trunk//driver/stk11xx-v4l.c ---
> > syntekdriver-code-107-trunk-orig/driver/stk11xx-v4l.c	2012-03-10
> > 09:54:57.000000000 +0100 +++
> > syntekdriver-code-107-trunk//driver/stk11xx-v4l.c	2013-08-05
> > 22:51:12.000000000 +0200 @@ -1498,9 +1498,17 @@ int
> > v4l_stk11xx_register_video_device(st
> >   {
> >   	int err;
> >
> > +	err = v4l2_device_register(&dev->interface->dev, &dev->v4l2_dev);
> > +	if (err < 0) {
> > +		STK_ERROR("couldn't register v4l2_device\n");
> > +		kfree(dev);
> > +		return err;
> > +	}
> > +
> >   	strcpy(dev->vdev->name, DRIVER_DESC);
> >
> > -	dev->vdev->parent = &dev->interface->dev;
> > +//	dev->vdev->parent = &dev->interface->dev;
> > +	dev->vdev->v4l2_dev = &dev->v4l2_dev;
> >   	dev->vdev->fops = &v4l_stk11xx_fops;
> >   	dev->vdev->release = video_device_release;
> >   	dev->vdev->minor = -1;
> > @@ -1533,6 +1541,7 @@ int v4l_stk11xx_unregister_video_device(
> >
> >   	video_set_drvdata(dev->vdev, NULL);
> >   	video_unregister_device(dev->vdev);
> > +	v4l2_device_unregister(&dev->v4l2_dev);
> >
> >   	return 0;
> >   }



-- 
Ondrej Zary
