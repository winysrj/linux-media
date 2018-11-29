Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34760 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbeK3KOf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 05:14:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bing Bu Cao <bingbu.cao@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        rajmohan.mani@intel.com, jian.xu.zheng@intel.com,
        jerry.w.hu@intel.com, tuukka.toivonen@intel.com,
        tian.shu.qiu@intel.com, bingbu.cao@intel.com
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Date: Fri, 30 Nov 2018 01:07:53 +0200
Message-ID: <14050603.QCN9zesBFv@avalon>
In-Reply-To: <6bc1a25d-5799-5a9b-546e-3b8cf42ce976@linux.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <20181101120303.g7z2dy24pn5j2slo@kekkonen.localdomain> <6bc1a25d-5799-5a9b-546e-3b8cf42ce976@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Bing,

On Wednesday, 7 November 2018 06:16:47 EET Bing Bu Cao wrote:
> On 11/01/2018 08:03 PM, Sakari Ailus wrote:
> > On Mon, Oct 29, 2018 at 03:22:54PM -0700, Yong Zhi wrote:

[snip]

> >> ImgU media topology print:
> >> 
> >> # media-ctl -d /dev/media0 -p
> >> Media controller API version 4.19.0
> >> 
> >> Media device information
> >> ------------------------
> >> driver          ipu3-imgu
> >> model           ipu3-imgu
> >> serial
> >> bus info        PCI:0000:00:05.0
> >> hw revision     0x80862015
> >> driver version  4.19.0
> >> 
> >> Device topology
> >> - entity 1: ipu3-imgu 0 (5 pads, 5 links)
> >>             type V4L2 subdev subtype Unknown flags 0
> >>             device node name /dev/v4l-subdev0
> >> 	pad0: Sink
> >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown
> > 
> > This doesn't seem right. Which formats can be enumerated from the pad?
> > 
> >> 		 crop:(0,0)/1920x1080
> >> 		 compose:(0,0)/1920x1080]
> > 
> > Does the compose rectangle affect the scaling on all outputs?
> 
> Sakari, driver use crop and compose targets to help set input-feeder and BDS
> output resolutions which are 2 key block of whole imaging pipeline, not the
> actual ending output, but they will impact the final output.
> 
> >> 		<- "ipu3-imgu 0 input":0 []
> > 
> > Are there links that have no useful link configuration? If so, you should
> > set them enabled and immutable in the driver.
> 
> The enabled status of input pads is used to get which pipe that user is
> trying to enable (ipu3_link_setup()), so it could not been set as immutable.

Each pipe needs an input in order to operate, so from that point of view the 
input is mandatory. Why can't we make this link immutable, and use the stream 
state (VIDIOC_STREAMON/VIDIOC_STREAMOFF) to enable/disable the pipes ?

> >> 	pad1: Sink
> >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> > 
> > I'd suggest to use MEDIA_BUS_FMT_FIXED here.
> > 
> >> 		<- "ipu3-imgu 0 parameters":0 []
> >> 	
> >> 	pad2: Source
> >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> >> 		-> "ipu3-imgu 0 output":0 []
> >> 	
> >> 	pad3: Source
> >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> >> 		-> "ipu3-imgu 0 viewfinder":0 []
> > 
> > Are there other differences between output and viewfinder?
> 
> output and viewfinder are the main and secondary output of output system.
> 'main' output is not allowed to be scaled, only support crop. secondary
> output 'viewfinder' can support both cropping and scaling. User can select
> different nodes to use as preview and capture flexibly based on the actual
> use cases.

This is very useful information, thank you. Could it be added to the 
documentation (patch 02/16) with a block diagram ?

> >> 	pad4: Source
> >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> >> 		-> "ipu3-imgu 0 3a stat":0 []
> > 
> > FIXED here, too.
> > 
> >> - entity 7: ipu3-imgu 1 (5 pads, 5 links)
> >>             type V4L2 subdev subtype Unknown flags 0
> >>             device node name /dev/v4l-subdev1
> >> 	
> >> 	pad0: Sink
> >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown
> >> 		 crop:(0,0)/1920x1080
> >> 		 compose:(0,0)/1920x1080]
> >> 		<- "ipu3-imgu 1 input":0 []
> >> 	
> >> 	pad1: Sink
> >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> >> 		<- "ipu3-imgu 1 parameters":0 []
> >> 	
> >> 	pad2: Source
> >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> >> 		-> "ipu3-imgu 1 output":0 []
> >> 	
> >> 	pad3: Source
> >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> >> 		-> "ipu3-imgu 1 viewfinder":0 []
> >> 	
> >> 	pad4: Source
> >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> >> 		-> "ipu3-imgu 1 3a stat":0 []
> > 
> > This is a minor matter but --- could you create the second sub-device
> > after the video device nodes related to the first one have been already
> > created? That'd make reading the output easier.
> > 
> >> - entity 17: ipu3-imgu 0 input (1 pad, 1 link)
> >> 
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video0
> >> 	
> >> 	pad0: Source
> >> 		-> "ipu3-imgu 0":0 []
> >> 
> >> - entity 23: ipu3-imgu 0 parameters (1 pad, 1 link)
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video1
> >> 	
> >> 	pad0: Source
> >> 		-> "ipu3-imgu 0":1 []
> >> 
> >> - entity 29: ipu3-imgu 0 output (1 pad, 1 link)
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video2
> >> 	
> >> 	pad0: Sink
> >> 		<- "ipu3-imgu 0":2 []
> >> 
> >> - entity 35: ipu3-imgu 0 viewfinder (1 pad, 1 link)
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video3
> >> 	
> >> 	pad0: Sink
> >> 		<- "ipu3-imgu 0":3 []
> >> 
> >> - entity 41: ipu3-imgu 0 3a stat (1 pad, 1 link)
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video4
> >> 	
> >> 	pad0: Sink
> >> 		<- "ipu3-imgu 0":4 []
> >> 
> >> - entity 47: ipu3-imgu 1 input (1 pad, 1 link)
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video5
> >> 	
> >> 	pad0: Source
> >> 		-> "ipu3-imgu 1":0 []
> >> 
> >> - entity 53: ipu3-imgu 1 parameters (1 pad, 1 link)
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video6
> >> 	
> >> 	pad0: Source
> >> 		-> "ipu3-imgu 1":1 []
> >> 
> >> - entity 59: ipu3-imgu 1 output (1 pad, 1 link)
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video7
> >> 	
> >> 	pad0: Sink
> >> 		<- "ipu3-imgu 1":2 []
> >> 
> >> - entity 65: ipu3-imgu 1 viewfinder (1 pad, 1 link)
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video8
> >> 	
> >> 	pad0: Sink
> >> 		<- "ipu3-imgu 1":3 []
> >> 
> >> - entity 71: ipu3-imgu 1 3a stat (1 pad, 1 link)
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video9
> >> 	
> >> 	pad0: Sink
> >> 		<- "ipu3-imgu 1":4 []

[snip]

-- 
Regards,

Laurent Pinchart
