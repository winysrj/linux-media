Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34982 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbeK3KQT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 05:16:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Bing Bu Cao <bingbu.cao@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        rajmohan.mani@intel.com, jian.xu.zheng@intel.com,
        jerry.w.hu@intel.com, tuukka.toivonen@intel.com,
        tian.shu.qiu@intel.com, bingbu.cao@intel.com
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Date: Fri, 30 Nov 2018 01:09:37 +0200
Message-ID: <59385138.zhZiANFFLA@avalon>
In-Reply-To: <20181109100953.4xfsslyfdhajhqoa@paasikivi.fi.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <6bc1a25d-5799-5a9b-546e-3b8cf42ce976@linux.intel.com> <20181109100953.4xfsslyfdhajhqoa@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On Friday, 9 November 2018 12:09:54 EET Sakari Ailus wrote:
> On Wed, Nov 07, 2018 at 12:16:47PM +0800, Bing Bu Cao wrote:
> > On 11/01/2018 08:03 PM, Sakari Ailus wrote:
> >> On Mon, Oct 29, 2018 at 03:22:54PM -0700, Yong Zhi wrote:

[snip]

> >>> ImgU media topology print:
> >>> 
> >>> # media-ctl -d /dev/media0 -p
> >>> Media controller API version 4.19.0
> >>> 
> >>> Media device information
> >>> ------------------------
> >>> driver          ipu3-imgu
> >>> model           ipu3-imgu
> >>> serial
> >>> bus info        PCI:0000:00:05.0
> >>> hw revision     0x80862015
> >>> driver version  4.19.0
> >>> 
> >>> Device topology
> >>> - entity 1: ipu3-imgu 0 (5 pads, 5 links)
> >>> type V4L2 subdev subtype Unknown flags 0
> >>> device node name /dev/v4l-subdev0
> >>> pad0: Sink
> >>> [fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown
> >> 
> >> This doesn't seem right. Which formats can be enumerated from the pad?
> 
> Looking at the code, the OUTPUT video nodes have 10-bit GRBG (or a variant)
> format whereas the CAPTURE video nodes always have NV12. Can you confirm?
> 
> If the OUTPUT video node format selection has no effect on the rest of the
> pipeline (device capabilities, which processing blocks are in use, CAPTURE
> video nodes formats etc.), I think you could simply use the FIXED media bus
> code for each pad. That would actually make sense: this device always works
> from memory to memory, and thus does not really have a pixel data bus
> external to the device which is what the media bus codes really are for.

Isn't the Bayer variant useful information to configure debayering ? I would 
expect it to be passed through the format on pad 0.

-- 
Regards,

Laurent Pinchart
