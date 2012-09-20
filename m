Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4776 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2ITGic (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 02:38:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv2 API PATCH 05/28] DocBook: bus_info can no longer be empty.
Date: Thu, 20 Sep 2012 08:38:26 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <201209131240.07085.hverkuil@xs4all.nl> <2703771.az7WlvTDGK@avalon>
In-Reply-To: <2703771.az7WlvTDGK@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209200838.26903.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed September 19 2012 20:46:19 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 13 September 2012 12:40:07 Hans Verkuil wrote:
> > On Thu 13 September 2012 03:24:53 Laurent Pinchart wrote:
> > > On Friday 07 September 2012 15:29:05 Hans Verkuil wrote:
> > > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > > 
> > > > During the 2012 Media Workshop it was decided that bus_info as returned
> > > > by VIDIOC_QUERYCAP can no longer be empty. It should be a unique
> > > > identifier, and empty strings are obviously not unique.
> > > > 
> > > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > > ---
> > > > 
> > > >  Documentation/DocBook/media/v4l/vidioc-querycap.xml |   14
> > > >  ++++++++++----
> > > >  1 file changed, 10 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> > > > b/Documentation/DocBook/media/v4l/vidioc-querycap.xml index
> > > > f33dd74..d5b1248 100644
> > > > --- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> > > > +++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> > > > @@ -90,11 +90,17 @@ ambiguities.</entry>
> > > > 
> > > >  	    <entry>__u8</entry>
> > > >  	    <entry><structfield>bus_info</structfield>[32]</entry>
> > > >  	    <entry>Location of the device in the system, a
> > > > 
> > > > -NUL-terminated ASCII string. For example: "PCI Slot 4". This
> > > > +NUL-terminated ASCII string. For example: "PCI:0000:05:06.0". This
> > > > 
> > > >  information is intended for users, to distinguish multiple
> > > > 
> > > > -identical devices. If no such information is available the field may
> > > > -simply count the devices controlled by the driver, or contain the
> > > > -empty string (<structfield>bus_info</structfield>[0] = 0).<!-- XXX
> > > > pci_dev->slot_name example --></entry>
> > > > +identical devices. If no such information is available the field must
> > > > +simply count the devices controlled by the driver ("vivi-000"). The
> > > > bus_info
> > > > +must start with "PCI:" for PCI boards, "PCIe:" for PCI Express boards,
> > > > +"usb-" for USB devices, "I2C:" for i2c devices, "ISA:" for ISA devices
> > > > and
> > > > +"parport" for parallel port devices.
> > > 
> > > What about being a bit more precise than that ? We could specify what API
> > > drivers must use to fill the bus_info field. For instance, for USB
> > > devices,
> > > usb_make_path() is currently used by most drivers (which, by the way,
> > > doesn't return a string that starts with "USB:").
> > 
> > I thought about that, but should that be defined in the spec? I'm not sure
> > if that's the right place.
> 
> On the other hand, if we don't specify the format of the bus_info field 
> precisely, it will only be usable as an opaque identifier to userspace. What 
> do we want to do with bus_info ? Telling otherwise identical devices apart is 
> a must, but do we want to provide more information to userspace ? If the field 
> had been longer a sysfs path might have been a good idea, but it won't fit.

Well, we can use the bus_info to find a device in sysfs. E.g. for the ivtv card
I get bus_info "PCI:0000:0b:01.0" and the same device is found here in sysfs:

/sys/bus/pci/devices/0000:0b:01.0

We can try to document the relationship between bus_info and sysfs here and that
would define bus_info exactly. I don't quite see how a usb bus_info maps to sysfs,
however. Do you know?

Regards,

	Hans
