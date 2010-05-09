Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43131 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858Ab0EIRQG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 9 May 2010 13:16:06 -0400
Subject: Re: Linux V4L2 support dual stream video capture device
From: Andy Walls <awalls@md.metrocast.net>
To: "Wang, Wen W" <wen.w.wang@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A1E55D29F@shsmsx501.ccr.corp.intel.com>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A1E55D29F@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain
Date: Sun, 09 May 2010 13:16:51 -0400
Message-Id: <1273425411.3067.47.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-05-08 at 02:20 +0800, Wang, Wen W wrote:
> Hi all,
> 
> I'm wondering if V4L2 framework supports dual stream video capture
> device that transfer a preview stream and a regular stream (still
> capture or video capture) at the same time.

Yes.

At least for the ivtv and cx18 drivers, multiple streams can come from
the same hardware device and driver using differnet device nodes.

I.e.
	/dev/video0   MPEG stream (compressed audio and video)
	/dev/video24  PCM audio stream
	/dev/video32  YUV video stream

The PCM and YUV stream are really just the intermediate products the
CX2341[568] chips make available as they are needed for the MPEG
encoding anyway.

Because of the special relationship of the YUV and MPEG stream inside
the CX2341[568] chip, there is a restriction with the cx18 and ivtv
drivers that the MPEG stream and YUV stream have to be at the same
resolution and frame rate.  The cx18 and ivtv drivers handle the
enforcement of this, so the /dev/video* device nodes are not completely
indpendent: changing the controls or settings on one of the related
device nodes affects the others.




> We are developing a device driver with such capability. Our proposal
> to do this in V4L2 framework is to have two device nodes, one as
> primary node for still/video capture and one for preview. 

Sounds OK so far.


> The primary still/video capture device node is used for device
> configuration which can be compatible with open sourced applications.
> This will ensure the normal V4L2 application can run without code
> modification.

Be sure to keep in mind what userspace daemons can do here.  Daemons
like hald can open() secondary device nodes and call ioctl()'s on them
when the user is not even aware.  Pulseaudio will keep ALSA audio nodes
held open().   If there are interlocks on operations between secondary
and primary device nodes, users may run into some problems.

Some things I've noticed:

- Pulseaudio keeps a cx18-alsa provided ALSA device node open, making it
difficult to unload the cx18-alsa module and hence making it difficult
to unload the cx18 module.

- hald runs through all the /dev/video* device nodes as they appear,
calling ioctl()'s that query capabilities, causing what were deferred
firmware loadings to happen early.


>  Device node for preview will only accept preview buffer related
> operations.

Will any of the ioctl() calls on the preview buffer node affect the
settings made by ioctl()'s on the primary device?

The secondary node could be treated as a full fledged V4L2 video devices
by existing daemons and applications.  Would you be supporting things
like QUERYCAP on this node?

I guess what I'd suggest is that you not create a crippled V4L2 device
node.  It may be better to have it support as many of the V4L2 ioctl()'s
as possible that make sense for the secondary device.


> Buffer synchronization for still/video capture and preview will be
> done internally in the driver.

Why exactly do you need synchronization?


> This is our initial idea about the dual stream support in V4L2. Your
> comments will be appreciated!
> 
> Thanks
> Wen

Regards,
Andy

