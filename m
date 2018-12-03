Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:39854 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbeLCMen (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 07:34:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Bing Bu Cao <bingbu.cao@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        rajmohan.mani@intel.com, jian.xu.zheng@intel.com,
        jerry.w.hu@intel.com, tuukka.toivonen@intel.com,
        tian.shu.qiu@intel.com, bingbu.cao@intel.com
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Date: Mon, 03 Dec 2018 14:34:21 +0200
Message-ID: <2911537.Qa1ReeH21r@avalon>
In-Reply-To: <20181203095101.hqds7iwkrz5lvfli@paasikivi.fi.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <14050603.QCN9zesBFv@avalon> <20181203095101.hqds7iwkrz5lvfli@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday, 3 December 2018 11:51:01 EET Sakari Ailus wrote:
> On Fri, Nov 30, 2018 at 01:07:53AM +0200, Laurent Pinchart wrote:
> > On Wednesday, 7 November 2018 06:16:47 EET Bing Bu Cao wrote:
> >> On 11/01/2018 08:03 PM, Sakari Ailus wrote:
> >>> On Mon, Oct 29, 2018 at 03:22:54PM -0700, Yong Zhi wrote:
> > 
> > [snip]
> > 
> >>>> ImgU media topology print:
> >>>> 
> >>>> # media-ctl -d /dev/media0 -p
> >>>> Media controller API version 4.19.0
> >>>> 
> >>>> Media device information
> >>>> ------------------------
> >>>> driver          ipu3-imgu
> >>>> model           ipu3-imgu
> >>>> serial
> >>>> bus info        PCI:0000:00:05.0
> >>>> hw revision     0x80862015
> >>>> driver version  4.19.0
> >>>> 
> >>>> Device topology
> >>>> - entity 1: ipu3-imgu 0 (5 pads, 5 links)
> >>>>             type V4L2 subdev subtype Unknown flags 0
> >>>>             device node name /dev/v4l-subdev0
> >>>> 	pad0: Sink
> >>>> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown
> >>> 
> >>> This doesn't seem right. Which formats can be enumerated from the pad?
> >>> 
> >>>> 		 crop:(0,0)/1920x1080
> >>>> 		 compose:(0,0)/1920x1080]
> >>> 
> >>> Does the compose rectangle affect the scaling on all outputs?
> >> 
> >> Sakari, driver use crop and compose targets to help set input-feeder and
> >> BDS output resolutions which are 2 key block of whole imaging pipeline,
> >> not the actual ending output, but they will impact the final output.
> >> 
> >>>> 		<- "ipu3-imgu 0 input":0 []
> >>> 
> >>> Are there links that have no useful link configuration? If so, you
> >>> should set them enabled and immutable in the driver.
> >> 
> >> The enabled status of input pads is used to get which pipe that user is
> >> trying to enable (ipu3_link_setup()), so it could not been set as
> >> immutable.
> > 
> > Each pipe needs an input in order to operate, so from that point of view
> > the input is mandatory. Why can't we make this link immutable, and use
> > the stream state (VIDIOC_STREAMON/VIDIOC_STREAMOFF) to enable/disable the
> > pipes ?
> 
> There are only two options (AFAIK) in choosing the firmware, and by
> configuring the links this is better visible to the user: the links the
> state of which can be changed are not immutable. The driver can also obtain
> the explicit pipeline configuration, which makes the implementation more
> simple.

Do you mean that different firmwares are loaded based on link configuration ? 
Does it also mean that once we start using the first pipeline the 
configuration of the second pipeline can't be changed anymore ? If so, what's 
the reason for such a limitation ?

-- 
Regards,

Laurent Pinchart
