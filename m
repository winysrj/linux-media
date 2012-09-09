Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4174 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2IIIqi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 04:46:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [RFCv2 API PATCH 05/28] DocBook: bus_info can no longer be empty.
Date: Sun, 9 Sep 2012 10:45:56 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <201209081315.15411.hverkuil@xs4all.nl> <504B53E6.6000107@gmail.com>
In-Reply-To: <504B53E6.6000107@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209091045.56740.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat September 8 2012 16:19:18 Sylwester Nawrocki wrote:
> On 09/08/2012 01:15 PM, Hans Verkuil wrote:
> > On Fri September 7 2012 22:00:33 Sylwester Nawrocki wrote:
> >> On 09/07/2012 03:29 PM, Hans Verkuil wrote:
> >>> From: Hans Verkuil<hans.verkuil@cisco.com>
> >>>
> >>> During the 2012 Media Workshop it was decided that bus_info as returned
> >>> by VIDIOC_QUERYCAP can no longer be empty. It should be a unique identifier,
> >>> and empty strings are obviously not unique.
> >>>
> >>> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> >>
> >> Reviewed-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> >>
> >>> ---
> >>>    Documentation/DocBook/media/v4l/vidioc-querycap.xml |   14 ++++++++++----
> >>>    1 file changed, 10 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> >>> index f33dd74..d5b1248 100644
> >>> --- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> >>> +++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> >>> @@ -90,11 +90,17 @@ ambiguities.</entry>
> >>>    	<entry>__u8</entry>
> >>>    	<entry><structfield>bus_info</structfield>[32]</entry>
> >>>    	<entry>Location of the device in the system, a
> >>> -NUL-terminated ASCII string. For example: "PCI Slot 4". This
> >>> +NUL-terminated ASCII string. For example: "PCI:0000:05:06.0". This
> >>>    information is intended for users, to distinguish multiple
> >>> -identical devices. If no such information is available the field may
> >>> -simply count the devices controlled by the driver, or contain the
> >>> -empty string (<structfield>bus_info</structfield>[0] = 0).<!-- XXX pci_dev->slot_name example --></entry>
> >>> +identical devices. If no such information is available the field must
> >>> +simply count the devices controlled by the driver ("vivi-000"). The bus_info
> >>> +must start with "PCI:" for PCI boards, "PCIe:" for PCI Express boards,
> >>> +"usb-" for USB devices, "I2C:" for i2c devices, "ISA:" for ISA devices and
> >>> +"parport" for parallel port devices.
> >>> +For devices without a bus it should start with the driver name, optionally
> >>
> >> Most, if not all, devices are on some sort of bus. What would be an example
> >> of a device "without a bus" ?
> > 
> > Virtual devices like vivi and platform devices. Or is there some sort of
> > platform bus?
> 
> OK, then virtual devices like vivi are indeed not on any bus. But saying so,
> or implicitly assuming, about platform devices would have been misleading.
> 
> On ASICs and SoCs such devices are on some kind of on-chip peripheral bus, 
> e.g. AMBA APB/AHB [1].

Yes, but such busses are internal to the hardware and are not enumerated by
the kernel. The kernel will generate unique names for e.g. usb and pci busses
which is used to identify the device on that bus. And that's used also when
generating the bus_info.

That said, I checked drivers/base/platform.c and there is actually a platform
bus that's created in the kernel for platform devices. So perhaps something
like platform:devname wouldn't be such a bad idea after all. I'd have to do
some tests with this to see how it would look.

Regards,

	Hans

> So perhaps we could specify that for platform devices
> bus_info should start with "platform-" ? A unique remainder could be easily 
> formed in drivers on basis of a memory mapped register region address/size
> and/or a device interrupt number to the CPU. However, exposing such sensitive
> data may be questionable, so it's probably better to just stick with a simple 
> counter of identical devices.
> 
> >> Could we just be saying here "For other devices" instead of "For devices
> >> without a bus", or something similar ?
> > 
> > Well, I'd like for any device on a bus to have a consistent naming convention
> > so we can guarantee that bus_info is always unique.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> >>
> >>> +followed by "-" and an index if multiple instances of the device as possible.
> >>> +Many platform devices can have only one instance, so in that case bus_info
> >>> +is identical to the<structfield>driver</structfield>   field.</entry>
> >>>    	</row>
> >>>    	<row>
> >>>    	<entry>__u32</entry>
> 
> [1] http://www-micro.deis.unibo.it/~magagni/amba99.pdf
> 
> --
> 
> Regards,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
