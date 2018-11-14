Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:42584 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbeKNRnC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 12:43:02 -0500
Date: Wed, 14 Nov 2018 09:40:50 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Message-ID: <20181114074050.76kv5ygqvt7h2l2p@kekkonen.localdomain>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <20181114002511.GD19257@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114002511.GD19257@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wed, Nov 14, 2018 at 01:25:11AM +0100, jacopo mondi wrote:
> On Mon, Oct 29, 2018 at 03:22:54PM -0700, Yong Zhi wrote:
> > Hi,
> >
> > This series adds support for the Intel IPU3 (Image Processing Unit)
> > ImgU which is essentially a modern memory-to-memory ISP. It implements
> > raw Bayer to YUV image format conversion as well as a large number of
> > other pixel processing algorithms for improving the image quality.
> >
> > Meta data formats are defined for image statistics (3A, i.e. automatic
> > white balance, exposure and focus, histogram and local area contrast
> > enhancement) as well as for the pixel processing algorithm parameters.
> > The documentation for these formats is currently not included in the
> > patchset but will be added in a future version of this set.
> >
> > The algorithm parameters need to be considered specific to a given frame
> > and typically a large number of these parameters change on frame to frame
> > basis. Additionally, the parameters are highly structured (and not a flat
> > space of independent configuration primitives). They also reflect the
> > data structures used by the firmware and the hardware. On top of that,
> > the algorithms require highly specialized user space to make meaningful
> > use of them. For these reasons it has been chosen video buffers to pass
> > the parameters to the device.
> >
> > On individual patches:
> >
> > The heart of ImgU is the CSS, or Camera Subsystem, which contains the
> > image processors and HW accelerators.
> >
> > The 3A statistics and other firmware parameter computation related
> > functions are implemented in patch 11.
> >
> > All IPU3 pipeline default settings can be found in patch 10.
> >
> 
> Seems to me that patch 10 didn't make it to the mailing list, am I
> wrong?
> 
> I'm pointing it out as the same happened on your v6.

Thanks for pointing this out. I've uploaded the entire set here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=ipu3-v7>

including the 10th patch:

<URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=ipu3-v7&id=41e2f0d114dbc195efed079202d22748ddedbe83>

It's too big to get through the list server. :-(

Luckily, it's mostly tables so there's not much to review there. Default
settings, effectively.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
