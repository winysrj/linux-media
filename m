Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1232 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2IHLPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Sep 2012 07:15:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [RFCv2 API PATCH 05/28] DocBook: bus_info can no longer be empty.
Date: Sat, 8 Sep 2012 13:15:15 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <7d0e5a9425253ece02bb57adc9413a5558200f2d.1347023744.git.hans.verkuil@cisco.com> <504A5261.1090405@gmail.com>
In-Reply-To: <504A5261.1090405@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209081315.15411.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri September 7 2012 22:00:33 Sylwester Nawrocki wrote:
> On 09/07/2012 03:29 PM, Hans Verkuil wrote:
> > From: Hans Verkuil<hans.verkuil@cisco.com>
> > 
> > During the 2012 Media Workshop it was decided that bus_info as returned
> > by VIDIOC_QUERYCAP can no longer be empty. It should be a unique identifier,
> > and empty strings are obviously not unique.
> > 
> > Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> 
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> > ---
> >   Documentation/DocBook/media/v4l/vidioc-querycap.xml |   14 ++++++++++----
> >   1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> > index f33dd74..d5b1248 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> > @@ -90,11 +90,17 @@ ambiguities.</entry>
> >   	<entry>__u8</entry>
> >   	<entry><structfield>bus_info</structfield>[32]</entry>
> >   	<entry>Location of the device in the system, a
> > -NUL-terminated ASCII string. For example: "PCI Slot 4". This
> > +NUL-terminated ASCII string. For example: "PCI:0000:05:06.0". This
> >   information is intended for users, to distinguish multiple
> > -identical devices. If no such information is available the field may
> > -simply count the devices controlled by the driver, or contain the
> > -empty string (<structfield>bus_info</structfield>[0] = 0).<!-- XXX pci_dev->slot_name example --></entry>
> > +identical devices. If no such information is available the field must
> > +simply count the devices controlled by the driver ("vivi-000"). The bus_info
> > +must start with "PCI:" for PCI boards, "PCIe:" for PCI Express boards,
> > +"usb-" for USB devices, "I2C:" for i2c devices, "ISA:" for ISA devices and
> > +"parport" for parallel port devices.
> > +For devices without a bus it should start with the driver name, optionally
> 
> Most, if not all, devices are on some sort of bus. What would be an example
> of a device "without a bus" ?

Virtual devices like vivi and platform devices. Or is there some sort of
platform bus?

> Could we just be saying here "For other devices" instead of "For devices
> without a bus", or something similar ?

Well, I'd like for any device on a bus to have a consistent naming convention
so we can guarantee that bus_info is always unique.

Regards,

	Hans

> 
> > +followed by "-" and an index if multiple instances of the device as possible.
> > +Many platform devices can have only one instance, so in that case bus_info
> > +is identical to the<structfield>driver</structfield>  field.</entry>
> >   	</row>
> >   	<row>
> >   	<entry>__u32</entry>
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
