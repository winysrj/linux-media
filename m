Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59422 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab2IMKQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 05/28] DocBook: bus_info can no longer be empty.
Date: Thu, 13 Sep 2012 03:24:53 +0200
Message-ID: <2833220.AbcIRhH3Bk@avalon>
In-Reply-To: <7d0e5a9425253ece02bb57adc9413a5558200f2d.1347023744.git.hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <7d0e5a9425253ece02bb57adc9413a5558200f2d.1347023744.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Friday 07 September 2012 15:29:05 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> During the 2012 Media Workshop it was decided that bus_info as returned
> by VIDIOC_QUERYCAP can no longer be empty. It should be a unique identifier,
> and empty strings are obviously not unique.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/v4l/vidioc-querycap.xml |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> b/Documentation/DocBook/media/v4l/vidioc-querycap.xml index
> f33dd74..d5b1248 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> @@ -90,11 +90,17 @@ ambiguities.</entry>
>  	    <entry>__u8</entry>
>  	    <entry><structfield>bus_info</structfield>[32]</entry>
>  	    <entry>Location of the device in the system, a
> -NUL-terminated ASCII string. For example: "PCI Slot 4". This
> +NUL-terminated ASCII string. For example: "PCI:0000:05:06.0". This
>  information is intended for users, to distinguish multiple
> -identical devices. If no such information is available the field may
> -simply count the devices controlled by the driver, or contain the
> -empty string (<structfield>bus_info</structfield>[0] = 0).<!-- XXX
> pci_dev->slot_name example --></entry>
> +identical devices. If no such information is available the field must
> +simply count the devices controlled by the driver ("vivi-000"). The
> bus_info
> +must start with "PCI:" for PCI boards, "PCIe:" for PCI Express boards,
> +"usb-" for USB devices, "I2C:" for i2c devices, "ISA:" for ISA devices and
> +"parport" for parallel port devices.

What about being a bit more precise than that ? We could specify what API 
drivers must use to fill the bus_info field. For instance, for USB devices, 
usb_make_path() is currently used by most drivers (which, by the way, doesn't 
return a string that starts with "USB:").

> +For devices without a bus it should start with the driver name, optionally
> +followed by "-" and an index if multiple instances of the device as
> possible.
> +Many platform devices can have only one instance, so in that case bus_info
> +is identical to the <structfield>driver</structfield> field.</entry> </row>
>  	  <row>
>  	    <entry>__u32</entry>

-- 
Regards,

Laurent Pinchart

