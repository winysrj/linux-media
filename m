Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:41093 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2BGOjx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2012 09:39:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Adam Sutton" <adam.sutton@plextek.com>
Subject: Re: Setting routing of v4l2 subdevice
Date: Tue, 7 Feb 2012 15:39:08 +0100
Cc: linux-media@vger.kernel.org
References: <8C9A6B7580601F4FBDC0ED4C1D6A9B1D0638DC3B@plextek3.plextek.lan>
In-Reply-To: <8C9A6B7580601F4FBDC0ED4C1D6A9B1D0638DC3B@plextek3.plextek.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202071539.08471.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adam,

On Tuesday 07 February 2012 14:49:53 Adam Sutton wrote:
> Hi,
> 
> I'm trying to get the camera working on our Android platform and I'm
> having some trouble understanding how to select the appropriate input.
> 
> The platform specifics are:
> 
> Analog camera (PAL-I) -> TVP5150 TV decoder -> iMX53 IPU/CSI
> 
> Note: The TVP driver is not the one currently in the mainline kernel,
> I've had to modify it back to the old int-device format to be compatible
> with the Freescale IPU/CSI drivers.

Aargh! You should ask the developers of that driver to stop using that
obsolete int-device API and use the subdev API instead. Even better, get
them to upstream their driver.

> The TVP chip has 2 analog inputs which can be selected over the I2C
> interface. The driver includes a V4L2 ioctl
> (vidioc_int_s_video_routing_num) for selecting the required one.
> 
> My question is how do I go about accessing this from userland. The
> closest thing I can see if the VIDIOC_S_INPUT ioctl, but this get picked
> up by the freescale CSI driver (mxc_v4l2_capture.c), which also has 2
> possible input paths to select between (although we only ever use 1). I
> had initially hacked this ioctl in the freescale driver to pass the call
> to the TVP driver, but this doesn't feel right and I'm sure there must
> be a better way to handle this.

It is supposed to work as follows: the S_INPUT ioctl deals with 'user'
inputs. That is, the inputs that VIDIOC_ENUMINPUT returns correspond to
the labels on the inputs of the product (e.g. 'HDMI-1', 'S-Video', etc.).

The tvp driver has no idea how it is hooked up, so that only has routing
information that is pin-level and chip specific.

The driver implementing the S_INPUT ioctl is the one responsible for mapping
a userspace input to the right pin on the tvp chip. That driver should know
what the product is and how things are routed on the PCB. So when the user
says 'use the HDMI-1 input', then this driver will map that to a s_routing
call to the tvp driver with the correct parameters.

This mapping can either be hardcoded in the driver (typical for PCI(e)/USB
cards) or obtained from platform data (typical for SoCs).

Regards,

	Hans

> 
> Any suggestions welcome,
> Adam
> Plextek Limited
> Registered Address: London Road, Great Chesterford, Essex, CB10 1NY, UK
> Company Registration No. 2305889 VAT Registration No. GB 918 4425 15
> Tel: +44 1799 533 200. Fax: +44 1799 533 201 Web:http://www.plextek.com
> Electronics Design and Consultancy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
