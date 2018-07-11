Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59722 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732499AbeGKLGn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 07:06:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Carlos Garnacho <carlosg@gnome.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Devices with a front and back webcam represented as a single UVC device
Date: Wed, 11 Jul 2018 14:03:28 +0300
Message-ID: <3629177.qY90vYRvg1@avalon>
In-Reply-To: <5105002.ahX3nrg0vu@avalon>
References: <8804dcb3-1aca-3679-6a96-bbe554f188d0@redhat.com> <5105002.ahX3nrg0vu@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday, 11 July 2018 14:00:38 EEST Laurent Pinchart wrote:
> On Wednesday, 11 July 2018 11:37:14 EEST Hans de Goede wrote:
> > Hi Laurent,
> > 
> > At Guadec Carlos (in the Cc) told me that on his Acer 2-in-1 only
> > the frontcam is working and it seems both are represented by a
> > single UVC USB device. I've told him to check for some v4l control
> > to flip between front and back.
> > 
> > Carlos, as I mentioned you can try gtk-v4l
> > ("sudo dnf install gtk-v4l") or qv4l2
> > ("sudo dnf install qv4l2") these will both show
> > you various controls for the camera. One of those might do the trick.
> > 
> > But I recently bought a 2nd second hand Cherry Trail based HP
> > X2 2-in-1 and much to my surprise that is actually using an UVC
> > cam, rather then the usual ATOMISP crap and it has the same issue.
> > 
> > This device does not seem to have a control to flip between the
> > 2 cams, instead it registers 2 /dev/video? nodes but the second
> > node does not work
> 
> The second node is there to expose metadata to userspace, not image data.
> That's a recent addition to the uvcvideo driver.
> 
> > and dmesg contains:
> > 
> > [   26.079868] uvcvideo: Found UVC 1.00 device HP TrueVision HD
> > (05c8:03a3)
> > [   26.095485] uvcvideo 1-4.2:1.0: Entity type for entity Extension 4 was
> > not initialized!
> > [   26.095492] uvcvideo 1-4.2:1.0: Entity type for entity Processing 2 was
> > not initialized!
> > [   26.095496] uvcvideo 1-4.2:1.0: Entity type for entity Camera 1 was not
> > initialized!
> 
> You can safely ignore those messages. I need to submit a patch to get rid of
> them.
> 
> > Laurent, I've attached lsusb -v output so that you can check the
> > descriptors.
> 
> Thank you.
> 
> It's funny how UVC specifies a standard way to describe a device with two
> camera sensors with dynamic selection of one of them at runtime, and vendors
> instead implement vendor-specific crap :-(
> 
> The interesting part in the descriptors is
> 
>       VideoControl Interface Descriptor:
>         bLength                27
>         bDescriptorType        36
>         bDescriptorSubtype      6 (EXTENSION_UNIT)
>         bUnitID                 4
>         guidExtensionCode         {1229a78c-47b4-4094-b0ce-db07386fb938}
>         bNumControl             2
>         bNrPins                 1
>         baSourceID( 0)          2
>         bControlSize            2
>         bmControls( 0)       0x00
>         bmControls( 1)       0x06
>         iExtension              0
> 
> The extension unit exposes two controls (bmControls is a bitmask). They can
> be accessed from userspace through the UVCIOC_CTRL_QUERY ioctl, or mapped
> to V4L2 controls through the UVCIOC_CTRL_MAP ioctl, in which case they will
> be exposed to standard V4L2 applications.
> 
> If you want to experiment with this, I would advise querying both controls
> with UVCIOC_CTRL_QUERY. You can use the UVC_GET_CUR, UVC_GET_MIN,
> UVC_GET_MAX, UVC_GET_DEF and UVC_GET_RES requests to get the control
> current, minimum, maximum, default and resolution values, and UVC_GET_LEN
> and UVC_GET_INFO to get the control size (in bytes) and flags. Based on
> that you can start experimenting with UVC_SET_CUR to set semi-random
> values.
> 
> I'm however worried that those two controls would be a register address and
> a register value, for indirect access to all hardware registers in the
> device. In that case, you would likely need information from the device
> vendor, or possibly a USB traffic dump from a Windows machine when
> switching between the front and back cameras.

For the record, the USB descriptors of the 05c8:0403 device from the same 
vendor have the exact same extension unit, with the same two controls. I thus 
expect them to allow indirect access to internal registers :-(

> > Carlos, it might be good to get Laurent your descriptors too, to do
> > this do "lsusb", note what is the <vid>:<pid> for your camera and then
> > run:
> > 
> > sudo lsusb -v -d <vid>:<pid>  > lsusb.log
> > 
> > And send Laurent a mail with the generated lsusb
> 
> That would be appreciated, but I expect the same issue :-(

-- 
Regards,

Laurent Pinchart
