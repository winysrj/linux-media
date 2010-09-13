Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:37669 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab0IMQqJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 12:46:09 -0400
Date: Mon, 13 Sep 2010 12:17:48 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: "Wang, Wen W" <wen.w.wang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>
Subject: Re: Linux V4L2 support dual stream video capture device
In-Reply-To: <201009130838.56888.laurent.pinchart@ideasonboard.com>
Message-ID: <alpine.LNX.2.00.1009131142000.22384@banach.math.auburn.edu>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A1E55D29F@shsmsx501.ccr.corp.intel.com> <201009130838.56888.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On Mon, 13 Sep 2010, Laurent Pinchart wrote:

> Hi Wen,
> 
> On Friday 07 May 2010 20:20:38 Wang, Wen W wrote:
> > Hi all,
> > 
> > I'm wondering if V4L2 framework supports dual stream video capture device
> > that transfer a preview stream and a regular stream (still capture or
> > video capture) at the same time.
> > 
> > We are developing a device driver with such capability. Our proposal to do
> > this in V4L2 framework is to have two device nodes, one as primary node
> > for still/video capture and one for preview.
> 
> If the device supports multiple simultaneous video streams, multiple video 
> nodes is the way to go.
> 
> > The primary still/video capture device node is used for device
> > configuration which can be compatible with open sourced applications. This
> > will ensure the normal V4L2 application can run without code modification.
> > Device node for preview will only accept preview buffer related
> > operations. Buffer synchronization for still/video capture and preview
> > will be done internally in the driver.
> 
> I suspect that the preview device node will need to support more than the 
> buffer-related operations, as you probably want applications to configure the 
> preview video stream format and size.
> 
> > This is our initial idea about the dual stream support in V4L2. Your
> > comments will be appreciated!
> 
> You should use the media controller framework. This will allow applications to 
> configure all sizes in the pipeline, including the frame sizes for the two 
> video nodes.

Hi, Wen,

You have hit upon an old and rather vexing problem. It affects many 
devices, not just your prospective one. The problem is that still mode is 
supported in Linux for a lot of cameras through userspace tools, namely 
libgphoto2 which uses libusb to interface with the device. But if the same 
device can also do video streaming then the streaming has to be supported 
through a kernel module. Thus until now it is not possible to do both of 
these smoothly and simultaneously.

As I have written both the kernel support and the libgphoto2 support for 
several dual-mode cameras, I am looking into the related problems, along 
with Hans de Goede. But right now I am dealing instead with a rather 
severe illness of a family member. So there is not much coding going on 
over here.

What I think that both of us (Hans and I) agree on is that the kernel 
modules for the affected devices have to be rewritten in order to allow 
the opening and closing of the different modes of the devices, and 
(perhaps) the userspace support has to take that into account as well. 
There might also have to be some additions to libv4l2 in order to make it 
"aware" of such devices. We have not gotten very far with this project. 
Hans is quite busy, and so am I (see above).

In spite of my present preoccupation, however, I would be very curious 
about any details of your envisioned camera. For example:

Does it use the isochronous mode for streaming and the bulk mode for 
stills? Or not?

In still mode, is it some kind of standard device, such as Mass Storage or 
PTP? Or will it use a proprietary or device-specific protocol? If so, 
it will clearly require a libgphoto2 driver.

In video mode, will it use a proprietary or device-specific protocol, or 
will it be a standard USB video class device? If it is proprietary, then 
it will presumably need its own module, and if standard then in any 
event we have to figure out how to make the two different modes to 
coexist.

If either of the still mode or the streaming video mode will use a 
proprietary protocol and especially if some unknown data compression 
algorithm is going to be in use, then clearly it is possible to get the 
support going much earlier if information is provided.

Hoping that this will help you and thanking you for any additional 
information about the new camera.

Theodore Kilgore
