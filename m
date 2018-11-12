Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:1447 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730558AbeKLOSB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 09:18:01 -0500
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <20181101120303.g7z2dy24pn5j2slo@kekkonen.localdomain>
 <6bc1a25d-5799-5a9b-546e-3b8cf42ce976@linux.intel.com>
 <20181109100953.4xfsslyfdhajhqoa@paasikivi.fi.intel.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <bf13758d-1ca3-5fa3-a573-ee773902f4dd@linux.intel.com>
Date: Mon, 12 Nov 2018 12:31:16 +0800
MIME-Version: 1.0
In-Reply-To: <20181109100953.4xfsslyfdhajhqoa@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/09/2018 06:09 PM, Sakari Ailus wrote:
> Hi Bing Bu,
>
> On Wed, Nov 07, 2018 at 12:16:47PM +0800, Bing Bu Cao wrote:
>> On 11/01/2018 08:03 PM, Sakari Ailus wrote:
>>> Hi Yong,
>>>
>>> Thanks for the update!
>>>
>>> On Mon, Oct 29, 2018 at 03:22:54PM -0700, Yong Zhi wrote:
>>>> Hi,
>>>>
>>>> This series adds support for the Intel IPU3 (Image Processing Unit)
>>>> ImgU which is essentially a modern memory-to-memory ISP. It implements
>>>> raw Bayer to YUV image format conversion as well as a large number of
>>>> other pixel processing algorithms for improving the image quality.
>>>>
>>>> Meta data formats are defined for image statistics (3A, i.e. automatic
>>>> white balance, exposure and focus, histogram and local area contrast
>>>> enhancement) as well as for the pixel processing algorithm parameters.
>>>> The documentation for these formats is currently not included in the
>>>> patchset but will be added in a future version of this set.
>>>>
>>>> The algorithm parameters need to be considered specific to a given frame
>>>> and typically a large number of these parameters change on frame to frame
>>>> basis. Additionally, the parameters are highly structured (and not a flat
>>>> space of independent configuration primitives). They also reflect the
>>>> data structures used by the firmware and the hardware. On top of that,
>>>> the algorithms require highly specialized user space to make meaningful
>>>> use of them. For these reasons it has been chosen video buffers to pass
>>>> the parameters to the device.
>>>>
>>>> On individual patches:
>>>>
>>>> The heart of ImgU is the CSS, or Camera Subsystem, which contains the
>>>> image processors and HW accelerators.
>>>>
>>>> The 3A statistics and other firmware parameter computation related
>>>> functions are implemented in patch 11.
>>>>
>>>> All IPU3 pipeline default settings can be found in patch 10.
>>>>
>>>> To access DDR via ImgU's own memory space, IPU3 is also equipped with
>>>> its own MMU unit, the driver is implemented in patch 6.
>>>>
>>>> Patch 7 uses above driver for DMA mapping operation.
>>>>
>>>> The communication between IPU3 firmware and driver is implemented with circular
>>>> queues in patch 8.
>>>>
>>>> Patch 9 provide some utility functions and manage IPU3 fw download and
>>>> install.
>>>>
>>>> The firmware which is called ipu3-fw.bin can be downloaded from:
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>>>> (commit 2c27b0cb02f18c022d8378e0e1abaf8b7ae8188f)
>>>>
>>>> Firmware ABI is defined in patches 4 and 5.
>>>>
>>>> Patches 12 and 13 are of the same file, the former contains all h/w programming
>>>> related code, the latter implements interface functions for access fw & hw
>>>> capabilities.
>>>>
>>>> Patch 14 has a dependency on Sakari's V4L2_BUF_TYPE_META_OUTPUT work:
>>>>
>>>> <URL:https://patchwork.kernel.org/patch/9976295/>
>>> I've pushed the latest set here:
>>>
>>> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=meta-output>
>>>
>>> You can just say the entire set depends on those going forward; the
>>> documentation is needed, too.
>>>
>>>> Patch 15 represents the top level that glues all of the other components together,
>>>> passing arguments between the components.
>>>>
>>>> Patch 16 is a recent effort to extend v6 for advanced camera features like
>>>> Continuous View Finder (CVF) and Snapshot During Video(SDV) support.
>>>>
>>>> Link to user space implementation:
>>>>
>>>> git clone https://chromium.googlesource.com/chromiumos/platform/arc-camera
>>>>
>>>> ImgU media topology print:
>>>>
>>>> # media-ctl -d /dev/media0 -p
>>>> Media controller API version 4.19.0
>>>>
>>>> Media device information
>>>> ------------------------
>>>> driver          ipu3-imgu
>>>> model           ipu3-imgu
>>>> serial          
>>>> bus info        PCI:0000:00:05.0
>>>> hw revision     0x80862015
>>>> driver version  4.19.0
>>>>
>>>> Device topology
>>>> - entity 1: ipu3-imgu 0 (5 pads, 5 links)
>>>>             type V4L2 subdev subtype Unknown flags 0
>>>>             device node name /dev/v4l-subdev0
>>>> 	pad0: Sink
>>>> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown
>>> This doesn't seem right. Which formats can be enumerated from the pad?
> Looking at the code, the OUTPUT video nodes have 10-bit GRBG (or a variant)
> format whereas the CAPTURE video nodes always have NV12. Can you confirm?
Hi, Sakari,
Yes, I think the pad_fmt should also be changed.
Yong, could you add some extra code for this and test? like:

static int ipu3_v4l2_node_setup(struct imgu_device *imgu, unsigned int pipe,
...
                        V4L2_PIX_FMT_NV12;
                node->vdev_fmt.fmt.pix_mp = def_pix_fmt;
        }

+       if (node->vdev_fmt.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+               node->pad_fmt.code = MEDIA_BUS_FMT_SGRBG10_1X10;
+
 
>
> If the OUTPUT video node format selection has no effect on the rest of the
> pipeline (device capabilities, which processing blocks are in use, CAPTURE
> video nodes formats etc.), I think you could simply use the FIXED media bus
> code for each pad. That would actually make sense: this device always works
> from memory to memory, and thus does not really have a pixel data bus
> external to the device which is what the media bus codes really are for.
>
>>>> 		 crop:(0,0)/1920x1080
>>>> 		 compose:(0,0)/1920x1080]
>>> Does the compose rectangle affect the scaling on all outputs?
>> Sakari, driver use crop and compose targets to help set input-feeder and BDS
>> output resolutions which are 2 key block of whole imaging pipeline, not the
>> actual ending output, but they will impact the final output.
> Ack. Thanks for the clarification.
>
>>>> 		<- "ipu3-imgu 0 input":0 []
>>> Are there links that have no useful link configuration? If so, you should
>>> set them enabled and immutable in the driver.
>> The enabled status of input pads is used to get which pipe that user is
>> trying to enable (ipu3_link_setup()), so it could not been set as immutable.
> But the rest of them could be, right?
Yes.
>
>>>> 	pad1: Sink
>>>> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
>>> I'd suggest to use MEDIA_BUS_FMT_FIXED here.
>>>
>>>> 		<- "ipu3-imgu 0 parameters":0 []
>>>> 	pad2: Source
>>>> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
>>>> 		-> "ipu3-imgu 0 output":0 []
>>>> 	pad3: Source
>>>> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
>>>> 		-> "ipu3-imgu 0 viewfinder":0 []
>>> Are there other differences between output and viewfinder?
>> output and viewfinder are the main and secondary output of output system.
>> 'main' output is not allowed to be scaled, only support crop. secondary
>> output 'viewfinder'
>> can support both cropping and scaling. User can select different nodes
>> to use
>> as preview and capture flexibly based on the actual use cases.
> If there's scaling to be configured, I'd expect to see the COMPOSE target
> supported.
Actually the viewfinder is the result of scaling, that means you can not
do more scaling.
The resolution of output and viewfinder should be fixed once the
pipeline is determined.
>
