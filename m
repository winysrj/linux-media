Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:10082 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727532AbeKIVQE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 16:16:04 -0500
Date: Fri, 9 Nov 2018 13:28:43 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Zhi, Yong" <yong.zhi@intel.com>
Cc: Bing Bu Cao <bingbu.cao@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Message-ID: <20181109112843.qhqlxz3hbywozutd@paasikivi.fi.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <20181101120303.g7z2dy24pn5j2slo@kekkonen.localdomain>
 <6bc1a25d-5799-5a9b-546e-3b8cf42ce976@linux.intel.com>
 <C193D76D23A22742993887E6D207B54D3DB2FD5E@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C193D76D23A22742993887E6D207B54D3DB2FD5E@ORSMSX106.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Fri, Nov 09, 2018 at 01:28:27AM +0000, Zhi, Yong wrote:
> Hi, Sakari,
> 
> Thanks for your review and comments.
> Bingbu has replied to some of your questions, so I will continue with the rest.
> 
> > -----Original Message-----
> > From: Bing Bu Cao [mailto:bingbu.cao@linux.intel.com]
> > Sent: Tuesday, November 6, 2018 10:17 PM
> > To: Sakari Ailus <sakari.ailus@linux.intel.com>; Zhi, Yong
> > <yong.zhi@intel.com>
> > Cc: linux-media@vger.kernel.org; tfiga@chromium.org;
> > mchehab@kernel.org; hans.verkuil@cisco.com;
> > laurent.pinchart@ideasonboard.com; Mani, Rajmohan
> > <rajmohan.mani@intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>; Hu,
> > Jerry W <jerry.w.hu@intel.com>; Toivonen, Tuukka
> > <tuukka.toivonen@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Cao,
> > Bingbu <bingbu.cao@intel.com>
> > Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
> > 
> > 
> > On 11/01/2018 08:03 PM, Sakari Ailus wrote:
> > > Hi Yong,
> > >
> > > Thanks for the update!
> > >
> > > On Mon, Oct 29, 2018 at 03:22:54PM -0700, Yong Zhi wrote:
> > >> Hi,
> > >>
> > >> This series adds support for the Intel IPU3 (Image Processing Unit)
> > >> ImgU which is essentially a modern memory-to-memory ISP. It
> > >> implements raw Bayer to YUV image format conversion as well as a
> > >> large number of other pixel processing algorithms for improving the image
> > quality.
> > >>
> > >> Meta data formats are defined for image statistics (3A, i.e.
> > >> automatic white balance, exposure and focus, histogram and local area
> > >> contrast
> > >> enhancement) as well as for the pixel processing algorithm parameters.
> > >> The documentation for these formats is currently not included in the
> > >> patchset but will be added in a future version of this set.
> > >>
> > >> The algorithm parameters need to be considered specific to a given
> > >> frame and typically a large number of these parameters change on
> > >> frame to frame basis. Additionally, the parameters are highly
> > >> structured (and not a flat space of independent configuration
> > >> primitives). They also reflect the data structures used by the
> > >> firmware and the hardware. On top of that, the algorithms require
> > >> highly specialized user space to make meaningful use of them. For
> > >> these reasons it has been chosen video buffers to pass the parameters to
> > the device.
> > >>
> > >> On individual patches:
> > >>
> > >> The heart of ImgU is the CSS, or Camera Subsystem, which contains the
> > >> image processors and HW accelerators.
> > >>
> > >> The 3A statistics and other firmware parameter computation related
> > >> functions are implemented in patch 11.
> > >>
> > >> All IPU3 pipeline default settings can be found in patch 10.
> > >>
> > >> To access DDR via ImgU's own memory space, IPU3 is also equipped with
> > >> its own MMU unit, the driver is implemented in patch 6.
> > >>
> > >> Patch 7 uses above driver for DMA mapping operation.
> > >>
> > >> The communication between IPU3 firmware and driver is implemented
> > >> with circular queues in patch 8.
> > >>
> > >> Patch 9 provide some utility functions and manage IPU3 fw download
> > >> and install.
> > >>
> > >> The firmware which is called ipu3-fw.bin can be downloaded from:
> > >>
> > >> git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware
> > >> .git (commit 2c27b0cb02f18c022d8378e0e1abaf8b7ae8188f)
> > >>
> > >> Firmware ABI is defined in patches 4 and 5.
> > >>
> > >> Patches 12 and 13 are of the same file, the former contains all h/w
> > >> programming related code, the latter implements interface functions
> > >> for access fw & hw capabilities.
> > >>
> > >> Patch 14 has a dependency on Sakari's V4L2_BUF_TYPE_META_OUTPUT
> > work:
> > >>
> > >> <URL:https://patchwork.kernel.org/patch/9976295/>
> > > I've pushed the latest set here:
> > >
> > > <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=meta-output>
> > >
> > > You can just say the entire set depends on those going forward; the
> > > documentation is needed, too.
> > >
> 
> Ack.
> 
> > >> Patch 15 represents the top level that glues all of the other
> > >> components together, passing arguments between the components.
> > >>
> > >> Patch 16 is a recent effort to extend v6 for advanced camera features
> > >> like Continuous View Finder (CVF) and Snapshot During Video(SDV)
> > support.
> > >>
> > >> Link to user space implementation:
> > >>
> > >> git clone
> > >> https://chromium.googlesource.com/chromiumos/platform/arc-camera
> > >>
> > >> ImgU media topology print:
> > >>
> > >> # media-ctl -d /dev/media0 -p
> > >> Media controller API version 4.19.0
> > >>
> > >> Media device information
> > >> ------------------------
> > >> driver          ipu3-imgu
> > >> model           ipu3-imgu
> > >> serial
> > >> bus info        PCI:0000:00:05.0
> > >> hw revision     0x80862015
> > >> driver version  4.19.0
> > >>
> > >> Device topology
> > >> - entity 1: ipu3-imgu 0 (5 pads, 5 links)
> > >>             type V4L2 subdev subtype Unknown flags 0
> > >>             device node name /dev/v4l-subdev0
> > >> 	pad0: Sink
> > >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown
> > > This doesn't seem right. Which formats can be enumerated from the pad?
> 
> Supposed to be raw formats for the colorspace field.

I think you could even leave colorspace unchanged. Please also see my reply
to Bing Bu.

> 
> > >
> > >> 		 crop:(0,0)/1920x1080
> > >> 		 compose:(0,0)/1920x1080]
> > > Does the compose rectangle affect the scaling on all outputs?
> > Sakari, driver use crop and compose targets to help set input-feeder and BDS
> > output resolutions which are 2 key block of whole imaging pipeline, not the
> > actual ending output, but they will impact the final output.
> > >
> > >> 		<- "ipu3-imgu 0 input":0 []
> > > Are there links that have no useful link configuration? If so, you
> > > should set them enabled and immutable in the driver.
> > The enabled status of input pads is used to get which pipe that user is trying
> > to enable (ipu3_link_setup()), so it could not been set as immutable.
> > >
> > >> 	pad1: Sink
> > >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> > > I'd suggest to use MEDIA_BUS_FMT_FIXED here.
> 
> Make sense as the parameter size is fixed.
> 
> > >
> > >> 		<- "ipu3-imgu 0 parameters":0 []
> > >> 	pad2: Source
> > >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> > >> 		-> "ipu3-imgu 0 output":0 []
> > >> 	pad3: Source
> > >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> > >> 		-> "ipu3-imgu 0 viewfinder":0 []
> > > Are there other differences between output and viewfinder?
> > output and viewfinder are the main and secondary output of output system.
> > 'main' output is not allowed to be scaled, only support crop. secondary
> > output 'viewfinder'
> > can support both cropping and scaling. User can select different nodes to use
> > as preview and capture flexibly based on the actual use cases.
> > >
> > >> 	pad4: Source
> > >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> > >> 		-> "ipu3-imgu 0 3a stat":0 []
> > > FIXED here, too.
> 
> Sure.
> 
> > >
> > >> - entity 7: ipu3-imgu 1 (5 pads, 5 links)
> > >>             type V4L2 subdev subtype Unknown flags 0
> > >>             device node name /dev/v4l-subdev1
> > >> 	pad0: Sink
> > >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown
> > >> 		 crop:(0,0)/1920x1080
> > >> 		 compose:(0,0)/1920x1080]
> > >> 		<- "ipu3-imgu 1 input":0 []
> > >> 	pad1: Sink
> > >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> > >> 		<- "ipu3-imgu 1 parameters":0 []
> > >> 	pad2: Source
> > >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> > >> 		-> "ipu3-imgu 1 output":0 []
> > >> 	pad3: Source
> > >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> > >> 		-> "ipu3-imgu 1 viewfinder":0 []
> > >> 	pad4: Source
> > >> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
> > >> 		-> "ipu3-imgu 1 3a stat":0 []
> > > This is a minor matter but --- could you create the second sub-device
> > > after the video device nodes related to the first one have been already
> > created?
> > > That'd make reading the output easier.
> > >
> 
> This can be done in next update.

Thanks!

...

> > >> v4l2-compliance SHA: 7aa151889ffe89b1cd94a8198b0caba1a8c70398, 64
> > >> bits
> > >>
> > >> Compliance test for device /dev/media0:
> > >>
> > >> Media Driver Info:
> > >> 	Driver name      : ipu3-imgu
> > >> 	Model            : ipu3-imgu
> > >> 	Serial           :
> > >> 	Bus info         : PCI:0000:00:05.0
> > >> 	Media version    : 4.19.0
> > >> 	Hardware revision: 0x80862015 (2156273685)
> > > Is there no revision field for the hardware? We could also use the SoC
> > > name in the model if it's known. It might be that there is another SoC
> > > that contains the same device but I don't see that as a problem really.
> > >
> 
> For the first question, do you mean revision field of IPU3?
> For the Model, do you suggest changing "ipu3-imgu" to "Intel(R) Core(TM)
> m3-7Y30 CPU ipu3-imgu"? I have not found a handy way to read SoC name
> yet.

I was thinking of something like "Kaby lake". If the IPU3 appears in other
SoCs it would likely have a different PCI ID.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
