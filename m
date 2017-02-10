Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22675 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752509AbdBJMyb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 07:54:31 -0500
From: "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
To: Hans Verkuil <hansverk@cisco.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "mchehab@osg.samsung.com" <mchehab@osg.samsung.com>,
        "Laurent.pinchart@ideasonboard.com"
        <Laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Zhang, Lei L" <lei.l.zhang@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: RE: media device drivers for Intel hardware platform incoming
Date: Fri, 10 Feb 2017 12:42:15 +0000
Message-ID: <FA6CF6692DF0B343ABE491A46A2CD0E76C3AAB09@SHSMSX101.ccr.corp.intel.com>
References: <FA6CF6692DF0B343ABE491A46A2CD0E76C3AAAA3@SHSMSX101.ccr.corp.intel.com>
 <fd2eb32e-4cbe-7df9-2f24-3d91bbc58507@cisco.com>
In-Reply-To: <fd2eb32e-4cbe-7df9-2f24-3d91bbc58507@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


> -----Original Message-----
> From: Hans Verkuil [mailto:hansverk@cisco.com]
> Sent: Friday, February 10, 2017 8:38 PM
> To: Zheng, Jian Xu <jian.xu.zheng@intel.com>; hans.verkuil@cisco.com;
> mchehab@osg.samsung.com; Laurent.pinchart@ideasonboard.com
> Cc: linux-media@vger.kernel.org; Qiu, Tian Shu <tian.shu.qiu@intel.com>;
> Zhang, Lei L <lei.l.zhang@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>;
> Sakari Ailus <sakari.ailus@linux.intel.com>
> Subject: Re: media device drivers for Intel hardware platform incoming
> 
> On 02/10/17 13:26, Zheng, Jian Xu wrote:
> > Dear maintainers & reviewers,
> >
> > First, thank you so much for your time to reading this email.
> >
> > Recently we are about to upstream several media drivers on Intel hardware
> platform, especially one ISP HW with hybrid imaging processing pipeline and its
> driver may be the first Intel ISP driver trying to upstream in linux-media.
> > Also 2 sensor drivers and VCM driver are included.
> >
> > Patch sets will likely reach at mailing list in several weeks. So I'm sending ice-
> breaking email for a smooth communication in the next months.
> > Looking forward to work with the most active and respected kernel driver
> component. Also contributing to the Open Source community is our honor and
> goal in the progress.
> >
> > If you're interested in, here are some introductions about those drivers
> (details will be in the cover letter of patch set)
> > 	1. MIPI CSI-2 device is part of ISP and is one PCI device. It would pass
> on data from MIPI bus to the DDR memory(without image processing).
> >                      MIPI CSI-2 driver registers 1 v4l2 subdev and 1 video node.
> Buffers are managed via vb2.
> >
> > 	2. Imaging processing unit is another part of ISP. It's one PCI device and
> a hardware with one hybrid imaging processing hardware pipeline.
> > 	     This HW consumes DDR RAW input and produces the YUV output
> after running imaging processing pipeline.
> >                      So it's abstracted as one memory to memory device with 5
> output pins(main output, vf output, 3A statistics, DVS statistics, LACE),
> >                      2 input pins(RAW image, ISP parameters). Certain video nodes
> are created for buffer looping. Buffers are managed via vb2.
> >
> > 	3. Camera sensors are i2c devices and drivers register 2 v4l2 subdevs
> and media entities as Pixel Array and Binner (binning/subsample).
> >                      Exposure/gain/hflip/vflip/vblank/hblank settings are set via
> certain V4L2_CID_* IOCTLs.
> >
> > 	4. VCM is i2c device and registers as a v4l2 subdev. Lens position is
> > set through V4L2_CID_FOCUS_ABSOLUTE
> 
> Great news! Thank you for working on this.
> 
> Just one question for my understanding: Sakari, is this something you've been
> involved in or is this from a different Intel team?
> 
> If Sakari has not been involved in this, then it is probably a good idea to work
> with him to do a preliminary code review.
> 
> Looking forward to the patch series,

   Thanks a lot for your prompt response. 
   Sakari and I are from the same team and comments from him are under addressing. :-)

> 
> 	Hans

